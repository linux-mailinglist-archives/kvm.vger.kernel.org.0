Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D4641983B
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhI0Pwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbhI0Pwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:52:32 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082D6C061575
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 08:50:54 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v17so9368189wrv.9
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bD2SU81ByuO8RLJO5RDrMC/8VFdSNtKnthXXLJULzNc=;
        b=KPdnEoeTKth8fMdTKgIpFSy869w3KC5nA4MquQVHTHDJxdBR+mmpeme/Bio+k5fsct
         y2gPk7IU4/ekMyVwex+F4Igu19Nrh2wt6I7SyCvDTksgnK629UvITvv4bAX7ih7lcWRM
         7vuLfw5Ud7dNIApDLbNWlF1iGhWp67OsxOuMh7y13EiDfuRQB0XZ8i4wNWXULuygFEXt
         EHU0OkVvFJrwiZ6sBCasDhCoxTGRa6ctE6Iif7gQjbrBo3+p4lXVp+mNIZDYSD2h/McX
         oDXAoGzI0/emAX7x0ZxznathRbF+53ohnySmo1yOu+MF275OQKIHA4Wyyq5/+2uDhzJ3
         mf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bD2SU81ByuO8RLJO5RDrMC/8VFdSNtKnthXXLJULzNc=;
        b=yoTULDDjBhNbYUP9SCXU7Q38jsP3vWBUEWgrd5A/KndBqHfEzYEalfEItO3I8IL+Wj
         cBeraSdCqyvLLbfBnec7r8Rbe3JnprLJ3pTdjKNAhsghGGh3vrPNu+JcKZq7Adw61bdW
         OMGsFzgioGucnX2RFftJoLkc5Rr8+FUOweOtiDxzlglMD1hPKIfHUL85+hNy/NR8/NZG
         XsUnIdY77eWGpcyxcJra2AYFV0DHsfYGsdSXb3QtDmGSZTG2K9O59DzkXCXQHFXB1ucT
         amX+ZKCrXS3alhSDMCY0PHJvkPSKUkj3n+9KX7IOTtQ/ZWUCKJ17eGP/NngaTZWwtQsd
         RodA==
X-Gm-Message-State: AOAM53192UfzbCCMqNMdM0myykMmy9OCmeyvSopwioPOVAk+V/wyzSsE
        pb0KRtx+zTT9SWWQAmlYsuTBxA==
X-Google-Smtp-Source: ABdhPJwk7UodlbcmeCXvgKd8A7K3G5BMhG4Ur82WbOKNPVZPKso9e2mYyfKX7AMU2xjSrywlN10B7w==
X-Received: by 2002:a5d:648f:: with SMTP id o15mr664308wri.338.1632757852232;
        Mon, 27 Sep 2021 08:50:52 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
        by smtp.gmail.com with ESMTPSA id 8sm6619875wmo.47.2021.09.27.08.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:50:51 -0700 (PDT)
Date:   Mon, 27 Sep 2021 16:50:49 +0100
From:   Quentin Perret <qperret@google.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, drjones@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [RFC PATCH v1 01/30] KVM: arm64: placeholder to check if VM is
 protected
Message-ID: <YVHoWbPXSHt07Ooq@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-2-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-2-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Fuad,

On Friday 24 Sep 2021 at 13:53:30 (+0100), Fuad Tabba wrote:
> Add a function to check whether a VM is protected (under pKVM).
> Since the creation of protected VMs isn't enabled yet, this is a
> placeholder that always returns false. The intention is for this
> to become a check for protected VMs in the future (see Will's RFC).
> 
> No functional change intended.
> 
> Acked-by: Will Deacon <will@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> Link: https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
> ---
>  arch/arm64/include/asm/kvm_host.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cd7d5c8c4bc..adb21a7f0891 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -763,6 +763,11 @@ void kvm_arch_free_vm(struct kvm *kvm);
>  
>  int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
>  
> +static inline bool kvm_vm_is_protected(struct kvm *kvm)
> +{
> +	return false;
> +}

Nit: this isn't used before patch 25 I think, so maybe move to a later
point in the series? That confused me a tiny bit :)

Thanks,
Quentin
