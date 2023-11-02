Return-Path: <kvm+bounces-434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D69B27DF99D
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:11:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13E191C20FFB
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770FC2111B;
	Thu,  2 Nov 2023 18:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UA7lMKOi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C67221111
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:11:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6D72D5F
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zINgmLEM4y/IYGJ6cER3rWqUY+I7ZJgEaJpIssBF02I=;
	b=UA7lMKOiyvQDfdRicEt742ujfXLWlr7ua11StmOl44jh9aFjNw+l9zfxBTthDRg0jQo3QW
	RxpYA5Ghb4nFhvE3h3Bj6XWg68/DbtQ3C+pghFbCAwFNEbcWnyYd2C6L6jlXfjmmbIRkCs
	EQd1Fg6bFA1Hm345y9wL+ZarzcxIbGo=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-bdJhCdVaPLartMnyUDQa_Q-1; Thu, 02 Nov 2023 14:07:49 -0400
X-MC-Unique: bdJhCdVaPLartMnyUDQa_Q-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-507cb169766so1163769e87.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948468; x=1699553268;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zINgmLEM4y/IYGJ6cER3rWqUY+I7ZJgEaJpIssBF02I=;
        b=hixZEvGXm7vZLafUed6CkzWWC5WNhbtG/TIvJSwhHLA/a3uUWoM4VsIsiQw9hPi6qa
         NRTTgSJfjVHkj7aEeE1BgmIivYWqau1qHtPuVTyx+WCXxTkHoSNFtC74qK30NACbkZQz
         J/9SAjbYRtLkOiTlVDPHLEdyMKhqoom19cL7vSSy1752TtDAQs0aFw+fILyX34djZVvE
         W+V2O1fbhLLXtxreEoG4QrSXYhwNKge0JpXS6mMGaazZMUv8udfP/ViSHjl6aD+YJLWE
         wO61K+oOT9diQ4IDAfeWdN+aKYa2q3vwo1SlsShitMjsBh7T56TLUzv2N+f8aP6gt5d8
         YPLw==
X-Gm-Message-State: AOJu0YxALc5csKNBYpaIlNBCvLYH9cte6xzCrZdHJgMzsrvYoRIDAG93
	ZBAWqb10M3aUi6l+3kDpAY6Ecr0b3vYT9FkJbVD4lhTjqYnhA1g47rYZgz2Xi9rKRZEVXa24Mqi
	dV2m1Hf+Xuqsz
X-Received: by 2002:a2e:b012:0:b0:2c6:eab4:84a6 with SMTP id y18-20020a2eb012000000b002c6eab484a6mr3426353ljk.48.1698948468255;
        Thu, 02 Nov 2023 11:07:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdUEjgS7PG9GhauxVXM5EOr3ap/D3wP5H6TRULsVzmP0fxfQq4HG2TkR3twytAokRXmT0GBg==
X-Received: by 2002:a2e:b012:0:b0:2c6:eab4:84a6 with SMTP id y18-20020a2eb012000000b002c6eab484a6mr3426341ljk.48.1698948468058;
        Thu, 02 Nov 2023 11:07:48 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d4849000000b0032d8eecf901sm3078149wrs.3.2023.11.02.11.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:07:47 -0700 (PDT)
Message-ID: <1e8ae50b41418d7df2cc44e2bde8d8713132e5c2.camel@redhat.com>
Subject: Re: [PATCH 9/9] KVM: SVM: Add CET features to supported_xss
From: Maxim Levitsky <mlevitsk@redhat.com>
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 weijiang.yang@intel.com,  rick.p.edgecombe@intel.com, seanjc@google.com,
 x86@kernel.org,  thomas.lendacky@amd.com, bp@alien8.de
Date: Thu, 02 Nov 2023 20:07:45 +0200
In-Reply-To: <20231010200220.897953-10-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-10-john.allen@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> If the CPU supports CET, add CET XSAVES feature bits to the
> supported_xss mask.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 00a8cef3cbb8..f63b2bbac542 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5151,6 +5151,10 @@ static __init void svm_set_cpu_caps(void)
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +		kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
> +					  XFEATURE_MASK_CET_KERNEL;
> +
>  	if (enable_pmu) {
>  		/*
>  		 * Enumerate support for PERFCTR_CORE if and only if KVM has

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


