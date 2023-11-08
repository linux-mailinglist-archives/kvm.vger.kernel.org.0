Return-Path: <kvm+bounces-1216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2AA57E5AEC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F8901C20BF9
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661A430FAF;
	Wed,  8 Nov 2023 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jmM381Qo"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CFF30D08
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:15:21 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEFA1FE8
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 08:15:21 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc23f2226bso49848625ad.2
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 08:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699460121; x=1700064921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkv2aSpFw25Sjc2pDxCz5exBlHcYk4gTYVmkV2GOyQs=;
        b=jmM381QoHM6/g0FB4YGETIBR5O3J1Dych7X+lotMdYThzDNuBSm38Bvy2TsfZPUuBz
         LzlpsoZeXenCsP0R9cO1z5mCRUWbfMliqX3Z3O7dCfsTunpZ30Cgf3LrGqt/mpzbZSbW
         O46em/jCPUWIkZdsHEfghHGMlEzU+D2q9+JXzOIJcLoFDjOuitCNXbMB6+FW+S0LNsxc
         F5WUZwqo/HTJJeTLt/A3/SNIOAkpsY83aURbgEu8jX3rhG1CNmCXmqlv5kG2IL5HBNiD
         v9M9nQ6x4wQbc3Uuw3RJHsDPVCYkYFT/ksNlNSKDpcP6VV1dYHtf7ofUP8DUxJg0LVXp
         aDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699460121; x=1700064921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkv2aSpFw25Sjc2pDxCz5exBlHcYk4gTYVmkV2GOyQs=;
        b=WkauanEmwtwABuRoVBus0bZMaSpZgMhLbH7yF5C8TVRYK9RkCAKyPSQjiJZ3FT4YdV
         dqPRIbIwKrGWaX2STUdIGqb7rQeslm7PmLi4TLBjoUMgPV8AeF/xGa5h02eEUxG09nS9
         PodWLFHW1DqMqX8qCsxHmv2EObQx0pVSlEJPpEkEJog07zfTm51LikGHMfCPhVTkOaLe
         3Zg0wcnQayY5wIQXnzZS4EoIKyH6yMaxqpwxNLTvY/nUM0EE7AerH1VaJ6sj6fzgiNVm
         SQh2HFt/JCUozG2ZuhHWNbwV0ibhGVbKwiTjLMvsK5rJGn3h0NkE5mglLJF4qXdvf5KQ
         E+BA==
X-Gm-Message-State: AOJu0YxAxykhnysQhaBpzWklfN6WFMum3bERioQixu66RJYJcnPcScQJ
	zZrz6ZI5YQzSsNSJcbtcH3zLTwkmlU0=
X-Google-Smtp-Source: AGHT+IFTaQxuB68rES3N/Ouf34zgkF8c8VJFXOJJTqeB2NI7Tbr2np/f2yCXpxs97M+wYFrZ4r8BXQsnFFA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1386:b0:1cc:5674:9177 with SMTP id
 jx6-20020a170903138600b001cc56749177mr37933plb.11.1699460120994; Wed, 08 Nov
 2023 08:15:20 -0800 (PST)
Date: Wed, 8 Nov 2023 08:15:19 -0800
In-Reply-To: <2573d04d-feff-4119-a79c-dbf9b85e62fd@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-30-nsaenz@amazon.com>
 <2573d04d-feff-4119-a79c-dbf9b85e62fd@amazon.com>
Message-ID: <ZUu0FzbW5tr2Werz@google.com>
Subject: Re: [RFC 29/33] KVM: VMX: Save instruction length on EPT violation
From: Sean Christopherson <seanjc@google.com>
To: Alexander Graf <graf@amazon.com>
Cc: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, corbert@lwn.net, 
	kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com, 
	x86@kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Alexander Graf wrote:
> 
> On 08.11.23 12:18, Nicolas Saenz Julienne wrote:
> > Save the length of the instruction that triggered an EPT violation in
> > struct kvm_vcpu_arch. This will be used to populate Hyper-V VSM memory
> > intercept messages.
> > 
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> 
> 
> In v1, please do this for SVM as well :)

Why?  KVM caches values on VMX because VMREAD is measurable slower than memory
accesses, especially when running nested.  SVM has no such problems.  I wouldn't
be surprised if adding a "cache" is actually less performant due to increased
pressure and misses on the hardware cache.

