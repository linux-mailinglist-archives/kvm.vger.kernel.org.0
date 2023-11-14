Return-Path: <kvm+bounces-1695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C13C7EB6F6
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 20:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A4511F257DF
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 19:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6925626AD9;
	Tue, 14 Nov 2023 19:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1eyvjaKP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1809D443C
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 19:39:50 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C37112
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 11:39:49 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6baaa9c0ba5so6344246b3a.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 11:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699990789; x=1700595589; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YOy2Jb1yR8H+KDVAUkMuOWbnw7u2AlKs0q0OU4Ox4dg=;
        b=1eyvjaKPkOM9/syod/APwe8rlxIwK30ARa9MZJGVqFCG3NVtEyevw7exzedQVttEAN
         BnNFs/Q6XJq2nkVllvikQhlKGoB/QMhhHX75HK2C8ZIa+MruMRGDhO1w4qd0UnYw/Xjm
         Zp95YT/dVeRGFTqwGAmzB387ymv6D5mbilZ7y9Ceu1vPGS8dFL0dk96F+uiygTeHT1bC
         EyNtv10r9ZyuuIHntlvmCjPX3oQ3np+W6HobxuBxtTxcUGI6Qnli1XFHljubG6UM5WfO
         drqO+rEHXqAwizZpUua7CbMKE7fE9mqt0OQP1zzjpkgVsTimXjo+KGkj+UZvjDXi7Ve9
         qHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699990789; x=1700595589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOy2Jb1yR8H+KDVAUkMuOWbnw7u2AlKs0q0OU4Ox4dg=;
        b=jOmk3sz0uZvaWRMnyvHMJnB674wJqGn+EgCwFTnM4PPQz54qWfC04EKpywE/Wsa3i0
         L+a9OuOZ4NXDx9xtHdx+J3JWSdZ5f8BEw074iUqq/XCmHK98Pe1teIvUyQDVrEZaGdBH
         ra/FQ1u+AFlxH7V5lCFByv6y/vwc2BsZ9GWCHynRy+IWuKSwchZtR88b2kz2Zi5Iopta
         aTFZWREZanF9mf28vRGqAiRao+cNjtR2WJCtdSLZgMZJb9puwBw/AY25oom6DhaorPw9
         0nVZhUdNQ0qteH4duNndLtVh76npTldojiuXU+tD28pmzLEX9/tgA1t4bYgVJXuKlfLN
         qz+Q==
X-Gm-Message-State: AOJu0Yz9/gZugUxX/aMWGs2CBAr1Z57sRlCuvSpD6hEc20Y7Hf12xaT3
	ZBQKtBfTDuEgeGkOOnGwDxCPFd+/sDg=
X-Google-Smtp-Source: AGHT+IELdNJfmBdSyGP1UazLrbiVBbECc8jW+oar24BNIoRCoD71ecIN2G1p5PdKbnM8GZXagF+ybaigYRQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8b82:b0:68e:3c6d:da66 with SMTP id
 ig2-20020a056a008b8200b0068e3c6dda66mr2732255pfb.6.1699990789174; Tue, 14 Nov
 2023 11:39:49 -0800 (PST)
Date: Tue, 14 Nov 2023 11:39:39 -0800
In-Reply-To: <0e27a686-43f9-5120-5097-3fd99982df62@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231018195638.1898375-1-seanjc@google.com> <e8002e94-33c5-617c-e951-42cd76666fad@oracle.com>
 <0e27a686-43f9-5120-5097-3fd99982df62@oracle.com>
Message-ID: <ZVPM-8MKW56hHCuw@google.com>
Subject: Re: [PATCH] KVM: x86: Don't unnecessarily force masterclock update on
 vCPU hotplug
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 14, 2023, Dongli Zhang wrote:
> Hi Sean,
> 
> Would mind sharing if the patch is waiting for Reviewed-by, and when it will be
> merged into kvm-x86 tree?

I'm at LPC this week, and out next week, so nothing is going to get applied to
kvm-x86 until after -rc3.  I considered trying to squeeze in a few things this
week, but decided to just wait until -rc3 and not rush anything, as the timing
doesn't really matter in the end.

> While I not sure if the same developer can give both Tested-by and Reviewed-by ...
> 
> Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>

Thanks!  Providing both a Reviewed-by and Tested-by is totally valid.

