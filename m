Return-Path: <kvm+bounces-333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D5287DE666
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 20:32:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B8A51C20E2C
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 19:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472751A262;
	Wed,  1 Nov 2023 19:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u0fnYm+/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2538184F
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 19:32:33 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B52411A
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 12:32:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da040c021aeso120049276.3
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 12:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698867147; x=1699471947; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6IOFILc1juY1gEvvnFoIG8ITiseh8mrQ04o+Gb2z3/Q=;
        b=u0fnYm+/Mhehjs+tjn8iDIp7NIZAwd9q9wqg76RhU4Rd2qFhntWrPdfhRLRx2WicaT
         7vT7MAqNdVGtx6H/fyZkW1LclrCOy0DLBdcTUuAAxxESYCDkaUhewzwr57YiME0kH4Ig
         iXQo5fr3dTzqUpWA7PY6KV4lSdjIL7R/tmC/N9cQpSyBVrR72yLrzSYGGgL4KPUpB1hZ
         yIhWFnlxiM/BCewW9HDJIAZVESOAvJrPcGbBLxvLeF113RJB+37/wVVbPRtQ7JrGTvbr
         ANZaNmfaQMVHkIlrQzQVMQy0GdBJm4eW2ApCiNHgSb29tAuW/PjCvYUypahM9muNp2QR
         bQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698867147; x=1699471947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6IOFILc1juY1gEvvnFoIG8ITiseh8mrQ04o+Gb2z3/Q=;
        b=RD5ZumC+qeCQTOUdOUsFtzlwOhmyB7GvlzhfNiJW/JEvmDnbL6vnJ+hk/14Au5cf0Y
         Ehz5mM4/ojRw9u63EGs6W1iJYVtsWTCJmmL2oIQnx87BNqnn0ZHPEf3ke8W0+MvIWfuy
         K0yAD2IWtYRyJpgDOg9livKx50Hxvyy09UaoEMDDnl/TwQmdUg+m+RzLZ+7o0dFXvVbH
         tRMVUSGkyxX9hNVONzlOnWTl86o41mqpCvCTOkGhAEH9Y1rkqk3rnr0vPjTncKqL4M7h
         K+GxWvB/bNc5TQW3r4Ts4USuaAIjUE1t+aK1ySOevUvKgtH+6UxmRXdxJjcX3je75EPA
         SFEQ==
X-Gm-Message-State: AOJu0YybjUOZD8b3zcZ1Sz3T1ixmoMZLLjrVkJtIu/LDF4wO2NFr2oQw
	2eYtuXa7IOp6UYDO0vB34moDxSaY34s=
X-Google-Smtp-Source: AGHT+IGcHEr0x9rrRKoy4mO3Yhn1gyEFe0DDAl1bhpW3gzQoxc7OCR9FRvOVEppdVcqmAkuT32MQrLIjjDI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9385:0:b0:da0:59f7:3c97 with SMTP id
 a5-20020a259385000000b00da059f73c97mr290120ybm.12.1698867147286; Wed, 01 Nov
 2023 12:32:27 -0700 (PDT)
Date: Wed, 1 Nov 2023 12:32:25 -0700
In-Reply-To: <92faa0085d1450537a111ed7d90faa8074201bed.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-11-weijiang.yang@intel.com> <92faa0085d1450537a111ed7d90faa8074201bed.camel@redhat.com>
Message-ID: <ZUKnyfbRqTFhMABI@google.com>
Subject: Re: [PATCH v6 10/25] KVM: x86: Add kvm_msr_{read,write}() helpers
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > Wrap __kvm_{get,set}_msr() into two new helpers for KVM usage and use the
> > helpers to replace existing usage of the raw functions.
> > kvm_msr_{read,write}() are KVM-internal helpers, i.e. used when KVM needs
> > to get/set a MSR value for emulating CPU behavior.
> 
> I am not sure if I like this patch or not. On one hand the code is cleaner
> this way, but on the other hand now it is easier to call kvm_msr_write() on
> behalf of the guest.
> 
> For example we also have the 'kvm_set_msr()' which does actually set the msr
> on behalf of the guest.
> 
> How about we call the new function kvm_msr_set_host() and rename
> kvm_set_msr() to kvm_msr_set_guest(), together with good comments explaning
> what they do?

LOL, just call me Nostradamus[*] ;-)

 : > SSP save/load should go to enter_smm_save_state_64() and rsm_load_state_64(),
 : > where other fields of SMRAM are handled.
 : 
 : +1.  The right way to get/set MSRs like this is to use __kvm_get_msr() and pass
 : %true for @host_initiated.  Though I would add a prep patch to provide wrappers
 : for __kvm_get_msr() and __kvm_set_msr().  Naming will be hard, but I think we
                                             ^^^^^^^^^^^^^^^^^^^
 : can use kvm_{read,write}_msr() to go along with the KVM-initiated register
 : accessors/mutators, e.g. kvm_register_read(), kvm_pdptr_write(), etc.

[*] https://lore.kernel.org/all/ZM0YZgFsYWuBFOze@google.com

> Also functions like kvm_set_msr_ignored_check(), kvm_set_msr_with_filter() and such,
> IMHO have names that are not very user friendly.

I don't like the host/guest split because KVM always operates on guest values,
e.g. kvm_msr_set_host() in particular could get confusing.

IMO kvm_get_msr() and kvm_set_msr(), and to some extent the helpers you note below,
are the real problem.

What if we rename kvm_{g,s}et_msr() to kvm_emulate_msr_{read,write}() to make it
more obvious that those are the "guest" helpers?  And do that as a prep patch in
this series (there aren't _that_ many users).

I'm also in favor of renaming the "inner" helpers, but I think we should tackle
those separately.separately

