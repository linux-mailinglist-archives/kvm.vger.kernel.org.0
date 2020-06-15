Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5891F92D4
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgFOJJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbgFOJJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 05:09:41 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7589AC061A0E
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 02:09:41 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o8so4389779wmh.4
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 02:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kBWHSnavnojggz6uvJr4ssNYwt9EO3XZXmWi0mLaVfo=;
        b=u5WnUGXso1CB5GxvVY5/j8SU9R6DyWFLnNXkqLW/yca23ej9LHGG9t327osTw7hV6c
         otK2j+87vksb+pxAnQaE3otq6MTONULdqSOIwMauTjgFICXMGSu3Op4aJ4lOuT+6LJMr
         Z9YA09iSVvv1mUuCTCnu8OICojUAQHjlqjkevFZlNOGr4krWeO0z4IFTZRpfScryQwo3
         T3FYYsNdi1/BurX6pBUs9ch+JI+OUYm5L76j4lj5vjueB3DqOShrhp3KB3VeARns7BTr
         YAbOVynWkOenw/7UXgg2PExrlbTHPj+8+hPpIPFVZdqIPCMc+CG2LAQCeN8d73G9mEB6
         1NPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kBWHSnavnojggz6uvJr4ssNYwt9EO3XZXmWi0mLaVfo=;
        b=eLeh1vB5U6xo7DXowUErDPLkAQLqrqrwEJ7FlvIiQiPMJb3dINzlgqAKEuSs6nnDm2
         9T8nd8OS6eKNDXtjqAIm8RA7Ye7MGWipjmMrsomMOC2G+RIAkTeclc7VmOl7cXZDEvG/
         CKuWfTrtXdPfCBGo0DrD9+15j/7nd99wY51VyEcJd5xjgXWTXw40HL1MnxfDHuRUnaTW
         /pR8uO0qMRNGEz6aivdzm658Qwz1pxTmiGeokwP9B6V/c/KEbB45jhTtha85TRQSz1MQ
         p2SF6lBOf7Y0r2GEQvu1SxZ/5FSzNK6Fl1zdSozFL45fJPvmuagRQhpIBWWM5DtEqwIf
         wRrg==
X-Gm-Message-State: AOAM533QYqV1Xs/RNI7BgjhVV6gXCzqYbA84KoQjqlO50nEtghbFux2l
        OCpPoeS50F6djVnKgE98ic+CIM3XEJs=
X-Google-Smtp-Source: ABdhPJxWx8VU501epgibxbnVhiRJ1svQndBXVYgotpBnvYqxiAcvxjK5SEZuaVtNXVlxltfUJaKCZg==
X-Received: by 2002:a7b:cb18:: with SMTP id u24mr2040292wmj.67.1592212180116;
        Mon, 15 Jun 2020 02:09:40 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id j5sm24100579wrq.39.2020.06.15.02.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 02:09:39 -0700 (PDT)
Date:   Mon, 15 Jun 2020 10:09:35 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 3/4] KVM: arm64: Allow PtrAuth to be enabled from
 userspace on non-VHE systems
Message-ID: <20200615090935.GF177680@google.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-4-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 09:19:53AM +0100, Marc Zyngier wrote:
> Now that the scene is set for enabling PtrAuth on non-VHE, drop
> the restrictions preventing userspace from enabling it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/reset.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index d3b209023727..2a929789fe2e 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -42,6 +42,11 @@ static u32 kvm_ipa_limit;
>  #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
>  				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
>  
> +static bool system_has_full_ptr_auth(void)
> +{
> +	return system_supports_address_auth() && system_supports_generic_auth();
> +}
> +
>  /**
>   * kvm_arch_vm_ioctl_check_extension
>   *
> @@ -80,8 +85,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		break;
>  	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> -		r = has_vhe() && system_supports_address_auth() &&
> -				 system_supports_generic_auth();
> +		r = system_has_full_ptr_auth();
>  		break;
>  	default:
>  		r = 0;
> @@ -205,19 +209,14 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>  
>  static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>  {
> -	/* Support ptrauth only if the system supports these capabilities. */
> -	if (!has_vhe())
> -		return -EINVAL;
> -
> -	if (!system_supports_address_auth() ||
> -	    !system_supports_generic_auth())
> -		return -EINVAL;
>  	/*
>  	 * For now make sure that both address/generic pointer authentication
> -	 * features are requested by the userspace together.
> +	 * features are requested by the userspace together and the system
> +	 * supports these capabilities.
>  	 */
>  	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
> -	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
> +	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
> +	    !system_has_full_ptr_auth())
>  		return -EINVAL;
>  
>  	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;

That was easy. Let EL2 use ptrauth and it can save and restore the
guest's state and done.

Acked-by: Andrew Scull <ascull@google.com>
