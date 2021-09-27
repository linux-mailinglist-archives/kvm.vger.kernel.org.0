Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FD24198E5
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhI0Qdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhI0Qdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:33:52 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC74BC061575
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 09:32:13 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t18so53056563wrb.0
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 09:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sDm0X5qQPferwq6fv+ku/0Jsg062MnSmwsDAd1S9+ac=;
        b=gGwDEcPz9HLzaQCAI7q3j4o5mViGJZZaCFUHWm+LGKKIWsJnbNfUOuirDv9dCdi6DC
         q+EzRoJzs8owpT/noKmfYmdMYftJd+hO9RgGv4Ti5mip4+SPxvq85IWvAPZkrzgv85Qu
         HQPKsfQ71rr7WuEzqtGV4az3nA6/UUhEACkdoVHLXF46X2A5J9SaU62v0MtY988HfyRm
         v0RnGY1SaQMamGv0t41roAMyiOso7/1NX3selVMrSbvvL2NLJc9rxYSfzx2QUGthc6L+
         GsRdVMkJ4wrO53K4bTiFMki4C9BQxEPKGSOowkMQCiYCGJu4y2wEyUdsPoql1FTdwg4u
         +o8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sDm0X5qQPferwq6fv+ku/0Jsg062MnSmwsDAd1S9+ac=;
        b=BNxHH4x9Om149ENgVN2jJDIH8VTynaY++i3ALtMTvZeoGwxMsC/NE6SSxva2XBgr84
         s13V/qukxNw/f2+IEya60zW2YjhnX1nQtRJbBe8F4AnQ5QyDxZXXYO9mzGvMjXBAbfx8
         VecSCbuDsLYyk5zwa3vbu7IQzTc14OpjFT2y35lMWOdTt6GBANOHie46zPFQ9lgiWz6f
         cVFfaYKL5AGBp9Nj2Dug9PK++FjdesXbDZ+Wmg2uxjYPqz+JcnSYL8n0z+2s9WzbVg/4
         3RMb5Xi0/vGRVQ19iXbAdshyn/u7LEthMZ5rxOkVsnFC5R4HqMszfmMp5VR8syfe+74G
         TM1Q==
X-Gm-Message-State: AOAM531vUCvRrSmxWcduKNjSVFqAcIy2AuE9eT3vtMo5K9rfnDZ5nLuw
        8s2mK09b905JpZjJFymSJ9FN1w==
X-Google-Smtp-Source: ABdhPJz+nq3KlBHGIoypjiRXZpcfjyQ1XRIJV9AK88Ba7/gCIYfpf+eVqswPyUj0b+aAtePsXm96tg==
X-Received: by 2002:adf:8b52:: with SMTP id v18mr875658wra.1.1632760332278;
        Mon, 27 Sep 2021 09:32:12 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
        by smtp.gmail.com with ESMTPSA id j21sm18107813wmj.40.2021.09.27.09.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 09:32:12 -0700 (PDT)
Date:   Mon, 27 Sep 2021 17:32:09 +0100
From:   Quentin Perret <qperret@google.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, drjones@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [RFC PATCH v1 11/30] KVM: arm64: create and use a new
 vcpu_hyp_state struct
Message-ID: <YVHyCW+D0M3U2Llu@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-12-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-12-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday 24 Sep 2021 at 13:53:40 (+0100), Fuad Tabba wrote:
> Create a struct for the hypervisor state from the related fields
> in vcpu_arch. This is needed in future patches to reduce the
> scope of functions from the vcpu as a whole to only the relevant
> state, via this newly created struct.
> 
> Create a new instance of this struct in vcpu_arch and fix the
> accessors to use the new fields. Remove the existing fields from
> vcpu_arch.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 35 ++++++++++++++++++-------------
>  arch/arm64/kernel/asm-offsets.c   |  2 +-
>  2 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3e5c173d2360..dc4b5e133d86 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -269,27 +269,35 @@ struct vcpu_reset_state {
>  	bool		reset;
>  };
>  
> +/* Holds the hyp-relevant data of a vcpu.*/
> +struct vcpu_hyp_state {
> +	/* HYP configuration */
> +	u64 hcr_el2;
> +	u32 mdcr_el2;
> +
> +	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> +	u64 vsesr_el2;
> +
> +	/* Exception Information */
> +	struct kvm_vcpu_fault_info fault;
> +
> +	/* Miscellaneous vcpu state flags */
> +	u64 flags;
> +};
> +
>  struct kvm_vcpu_arch {
>  	struct kvm_cpu_context ctxt;
>  	void *sve_state;
>  	unsigned int sve_max_vl;
>  
> +	struct vcpu_hyp_state hyp_state;
> +
>  	/* Stage 2 paging state used by the hardware on next switch */
>  	struct kvm_s2_mmu *hw_mmu;
>  
> -	/* HYP configuration */
> -	u64 hcr_el2;
> -	u32 mdcr_el2;
> -
> -	/* Exception Information */
> -	struct kvm_vcpu_fault_info fault;
> -
>  	/* State of various workarounds, see kvm_asm.h for bit assignment */
>  	u64 workaround_flags;
>  
> -	/* Miscellaneous vcpu state flags */
> -	u64 flags;
> -
>  	/*
>  	 * We maintain more than a single set of debug registers to support
>  	 * debugging the guest from the host and to maintain separate host and
> @@ -356,9 +364,6 @@ struct kvm_vcpu_arch {
>  	/* Detect first run of a vcpu */
>  	bool has_run_once;
>  
> -	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> -	u64 vsesr_el2;
> -
>  	/* Additional reset state */
>  	struct vcpu_reset_state	reset_state;
>  
> @@ -373,7 +378,7 @@ struct kvm_vcpu_arch {
>  	} steal;
>  };
>  
> -#define hyp_state(vcpu) ((vcpu)->arch)
> +#define hyp_state(vcpu) ((vcpu)->arch.hyp_state)

Aha, so _that_ is the nice thing about the previous patches ... I need
to stare at this series for a little longer, but wouldn't it be easier
to simply apply the struct kvm_vcpu_arch change and fixup all the users
at once instead of having all these preparatory patches? It's probably
personal preference at this point, but I must admit I'm finding all
these layers of accessors a little confusing. Happy to hear what others
think.

Thanks,
Quentin
