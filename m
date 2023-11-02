Return-Path: <kvm+bounces-433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 953E47DF998
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 893A61C20FB5
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7701421116;
	Thu,  2 Nov 2023 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MeZyCA/J"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184D221108
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:10:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090012135
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sIFznvQlxk51k3f904KCSD64BoprihpIPN0Cj8duUj0=;
	b=MeZyCA/J46OlSxW6otdFlxFCRxivhcYeUMjmn6fDL7qMCf1mdEcCfN4mJ7GCXjXyMJwxi3
	Kb/N80Erfl7AWvwqJSiGv4pxk23hsP0SnoUQoeYeb6NmL1hBs1xf2S89srMoiy3kxeP4Ar
	fmjbICWHECfp2d4ZyKvKWVMyLIxs9J8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-qs1p_JkkM2icyQtuB3pcQw-1; Thu, 02 Nov 2023 14:07:39 -0400
X-MC-Unique: qs1p_JkkM2icyQtuB3pcQw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4094158c899so7455715e9.3
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948458; x=1699553258;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sIFznvQlxk51k3f904KCSD64BoprihpIPN0Cj8duUj0=;
        b=MlNk07GhmmeOYtU7KQf/TxXj2+9LQm+5ZqvOGRZzlQ7ThkgX6YCIB4dHOK9cX5cTlK
         FZDix91jI9OcHXp+F77NGimMfqPQs1sqsqVRA1lgpAH5VVx3gi01lP3pgur1IpSr5eKA
         2SB5PRyEFjySXnlVWhvmPvIrwOndBe+ifg/A1cq5zHqOEFogyE1u2BFPSgcejSPN2ExX
         3sge7LF++QKEzO41CG6+oXjQZ2PxIb1Fan9Lghjiv98fuxnemgrBt2WBN6kBmzb4hnON
         9zyt2LsHqJc7r9sOdIAYqUPAvYPzds9iwCtgAFAUh+IqDQmv/5RoujSTcvLFa1ef3baQ
         Nh4Q==
X-Gm-Message-State: AOJu0YxZMQOGIJB29j9TwvJKTaygfJIgV0KXNwk0Ca3PrpX9Ixsl6fv4
	S7txlqdYsz8JcnKk+zXAqA5PGlZSNNLQ0WVBY1TPLFxj3j0M2GybrKjudiDlVvVJ+oOm946Wnbz
	w5p9Ba7ajGRepeB++UAIK
X-Received: by 2002:adf:ef02:0:b0:32d:a688:8813 with SMTP id e2-20020adfef02000000b0032da6888813mr14611603wro.32.1698948458080;
        Thu, 02 Nov 2023 11:07:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDOc+TH+n8PNZsR7qYgqGWsihlIO9CVD2E86cBDK98UHrTnMH3KOjuJbGY69nHoE8ayCu1Dw==
X-Received: by 2002:adf:ef02:0:b0:32d:a688:8813 with SMTP id e2-20020adfef02000000b0032da6888813mr14611578wro.32.1698948457782;
        Thu, 02 Nov 2023 11:07:37 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id x4-20020a5d60c4000000b0031aef72a021sm3020841wrt.86.2023.11.02.11.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:07:37 -0700 (PDT)
Message-ID: <963fbc8076172bd430621446070cfd6ca8f165b8.camel@redhat.com>
Subject: Re: [PATCH 8/9] KVM: SVM: Use KVM-governed features to track SHSTK
From: Maxim Levitsky <mlevitsk@redhat.com>
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 weijiang.yang@intel.com,  rick.p.edgecombe@intel.com, seanjc@google.com,
 x86@kernel.org,  thomas.lendacky@amd.com, bp@alien8.de
Date: Thu, 02 Nov 2023 20:07:35 +0200
In-Reply-To: <20231010200220.897953-9-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-9-john.allen@amd.com>
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
> Use the KVM-governed features framework to track whether SHSTK can be by
> both userspace and guest for SVM.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ee7c7d0a09ab..00a8cef3cbb8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4366,6 +4366,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
>  
>  	svm_recalc_instruction_intercepts(vcpu, svm);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


