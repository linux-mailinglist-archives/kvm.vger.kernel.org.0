Return-Path: <kvm+bounces-88-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 462267DBD76
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 769A31C20A8E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4556018E04;
	Mon, 30 Oct 2023 16:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3eQEBVVJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE9818C17
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:07:21 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BAB93
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:07:20 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc281f1214so24076385ad.2
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698682039; x=1699286839; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CYj9CzuAjK7WX2GIPL2L+DIVtRCWsgVm7uwhZjeF2lA=;
        b=3eQEBVVJW6qpJRwIuasDzGtyhpatmXjUjasnElIBF8WjDI+5ApsFJ1zlDBlWT/69TB
         PbTOHJinmlk+6aMVIH1rf63/lkKTsx0HNyXkcOGxLPBIKoLTzYcS4D+N1dBwkqdfsq/S
         yrUZOH4RT0MgkqHKkV9fo9/iJHC5KhS9aBgKJ5GC3Ehhb5WvIv5T2CWdFs5anHN3mu4N
         TuA4Z1ZZjrp9Qq2HjIs19K7Ul9Ov/A5B/bGpzVvmCJQKXDxhBNMpPGy8oagszu8qGOCM
         Sy9/BZQ01UDgphVn92xAZ3R44OHqqS2VIxjhPZ/H/x+68a9CrcENGbg1bva66PztNRjU
         oSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698682039; x=1699286839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CYj9CzuAjK7WX2GIPL2L+DIVtRCWsgVm7uwhZjeF2lA=;
        b=Elr7mzOKr4jd4EfIYilpIGWOwmWgFOITH1xC9SqAgSs0sLtHeh2Biczvme9It3hvU4
         N60n/y8w5HTAvuOXwtCkeQRAyD/Ab9KYoana282l86UHpWIUEZOMi9k6Dglo/WCTVmNQ
         ImbhcUgYqLXoSrZ2HYEDMcbT7+qQMAUGhxCa4/g9qzfZLu/2GwegjsPtoHx+luLwTONe
         N5SlL24XyOdFGqsJchaeQrzV+7p2SO0teMK/bBEaAId8/qmT/UYF54xLDGyFr4+K1u3a
         9hGz8ysaMvPkXuBhOvL45a9ALtaa5l5VSiSt5L+Pxb8ICHRL5ZyyLsYO5BEJvlwFulQa
         DMjQ==
X-Gm-Message-State: AOJu0YwExJ5RiOkahV8Wl4em28KH8ww4b783K0Ru1Th034pzX3pgCWCH
	MF5JTuLLj7w/R38Ox/ujzBAL4/9kbWM=
X-Google-Smtp-Source: AGHT+IFV5tV3//QjGmVmppct6PwpDpPOizUHi1+e/PWkSYXnddQsZMLTEun3JdOKBwDTc/ow3wO73Wx/+3M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d887:b0:1cc:47d4:492c with SMTP id
 b7-20020a170902d88700b001cc47d4492cmr63679plz.11.1698682039706; Mon, 30 Oct
 2023 09:07:19 -0700 (PDT)
Date: Mon, 30 Oct 2023 16:07:18 +0000
In-Reply-To: <20231030141728.1406118-1-nik.borisov@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231030141728.1406118-1-nik.borisov@suse.com>
Message-ID: <ZT_UtjWSKCwgBxb_@google.com>
Subject: Re: [PATCH] KVM: x86: User mutex guards to eliminate __kvm_x86_vendor_init()
From: Sean Christopherson <seanjc@google.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 30, 2023, Nikolay Borisov wrote:
> Current separation between (__){0,1}kvm_x86_vendor_init() is superfluos as

superfluous

But this intro is actively misleading.  The double-underscore variant most definitely
isn't superfluous, e.g. it eliminates the need for gotos reduces the probability
of incorrect error codes, bugs in the error handling, etc.  It _becomes_ superflous
after switching to guard(mutex).

IMO, this is one of the instances where the "problem, then solution" appoach is
counter-productive.  If there are no objections, I'll massage the change log to
the below when applying (for 6.8, in a few weeks).

  Use the recently introduced guard(mutex) infrastructure acquire and
  automatically release vendor_module_lock when the guard goes out of scope.
  Drop the inner __kvm_x86_vendor_init(), its sole purpose was to simplify
  releasing vendor_module_lock in error paths.

  No functional change intended.

> the the underscore version doesn't have any other callers.
> 
> Instead, use the newly added cleanup infrastructure to ensure that
> kvm_x86_vendor_init() holds the vendor_module_lock throughout its
> exectuion and that in case of error in the middle it's released. No
> functional changes.


