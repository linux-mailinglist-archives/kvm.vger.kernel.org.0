Return-Path: <kvm+bounces-3011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E4CB7FFB1C
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 038521F20FF2
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C2922075;
	Thu, 30 Nov 2023 19:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GD6R9ETk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C15F10E5
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701372072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1xrIynOc3yDB69n1RULdeleHvHvjuBPS0rAizzwpeI=;
	b=GD6R9ETk6X+ZHS7UwwzYQWX/g2uAkJPhC+xVPyodBxvs8Vb+9xCvu6M3tocz7SNj9WF2ui
	F3DgnWvcLc88n8cs78sJZkAZ5m8KeyA9DKm4bNGln7R1Jo81uzQzzz22HvORJpeuhqBRi0
	nyQbnKzwIF79NpS20n7ALbee7cNyRL0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-85WwAwwBN_uxi3EOIvKh4w-1; Thu, 30 Nov 2023 14:21:11 -0500
X-MC-Unique: 85WwAwwBN_uxi3EOIvKh4w-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33174d082b7so1026481f8f.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:21:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372069; x=1701976869;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k1xrIynOc3yDB69n1RULdeleHvHvjuBPS0rAizzwpeI=;
        b=Yhy/873kgLNZtQC8ykYl490Gph9UnRW8D5NG3s18mR5+R3uLIvLIo/VA+INjIQI44J
         WtvD8rAcdWush12SCsble2+883KMnnqG3Bj9sR9LhqE5iho4MAlnABYM3oJBdH8d9GqA
         fniczvw0AgZITCcYoeID5dxyi+PkiKKw9x/Jes7wEtIbcF1kizc9aaAsawPf1Hb7bW0t
         W8bmv2aUpsyScOi4fryWGUEeHvmrAgObe6qYhoFdwjN37FYF+8ZHoYKK2974I6EV5A1F
         RMSrRlECI9HNkHXgHxESNvVwjePSalvj6gWrowFt7vVPqFL1ctujIAvINJ9phFjrmON9
         +axg==
X-Gm-Message-State: AOJu0YwgiiXPTnTlX5itClR27enCvo7+FcaWdL2nBZIw9/e4zl79bUcf
	l96fshH9EY7jjgG0rHeOhkpQKzaevjoLUD5UXqZThBjOqkiltlykS4Rvlv8sTqqZ/x90IquHttd
	BRZEg/vaq9G1lx5zqiB4t
X-Received: by 2002:a50:c102:0:b0:54a:f8e9:a9a8 with SMTP id l2-20020a50c102000000b0054af8e9a9a8mr2150edf.20.1701368821161;
        Thu, 30 Nov 2023 10:27:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnZwxybDBa9d+1jyY55F9oLhZyquCMf4W1j/ajoNAp6Waooi/h9c1ywSFaPfo9Hba4Ac3Jdg==
X-Received: by 2002:a19:4f06:0:b0:509:4ab3:a8a3 with SMTP id d6-20020a194f06000000b005094ab3a8a3mr48861lfb.22.1701366035828;
        Thu, 30 Nov 2023 09:40:35 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id o12-20020ac24e8c000000b0050bbf6b1f74sm213812lfr.232.2023.11.30.09.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:40:29 -0800 (PST)
Message-ID: <8ff392a0c2ddbd622fd86b1c6eaab38eefeb05c3.camel@redhat.com>
Subject: Re: [PATCH v7 19/26] KVM: x86: Use KVM-governed feature framework
 to track "SHSTK/IBT enabled"
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:40:26 +0200
In-Reply-To: <20231124055330.138870-20-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-20-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> Use the governed feature framework to track whether X86_FEATURE_SHSTK
> and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
> the features can be used iff both KVM and guest CPUID can support them.
> 
> TODO: remove this patch once Sean's refactor to "KVM-governed" framework
> is upstreamed. See the work here [*].
> 
> [*]: https://lore.kernel.org/all/20231110235528.1561679-1-seanjc@google.com/
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/governed_features.h | 2 ++
>  arch/x86/kvm/vmx/vmx.c           | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index 423a73395c10..db7e21c5ecc2 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -16,6 +16,8 @@ KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
>  KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
>  KVM_GOVERNED_X86_FEATURE(VGIF)
>  KVM_GOVERNED_X86_FEATURE(VNMI)
> +KVM_GOVERNED_X86_FEATURE(SHSTK)
> +KVM_GOVERNED_X86_FEATURE(IBT)
>  
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d3d0d74fef70..f6ad5ba5d518 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7762,6 +7762,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
>  
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_IBT);
>  
>  	vmx_setup_uret_msrs(vmx);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


