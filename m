Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91294ACC08
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 23:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244458AbiBGWZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 17:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244351AbiBGWZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 17:25:51 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D2CC061A73
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 14:25:50 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e28so15482989pfj.5
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 14:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JKKByTaqxwBETFgifuJGqMvFg0/F2eEogOf15wsQKv0=;
        b=NbyPzld53eTimR/fpMxmGI7Wm69fxft6mLphoK4914TdhrqdtbPZTrArO81lodDHt8
         /l/YWsRIi6ka2wbOcEX2QpmraG46HaWq1GMspikF/Qsdzj+EDSaM3N2WzIQklIFhGdaa
         o+ArZdNn28MtPMXmgZr2GndTWsaCVhi9Tudn5K4hN43y6EzoAFuvatiglo5mL+B1ZErB
         BMMGuPR0gehBxGmRBeh2DwvHS6rxiKz1DJGDqBcj0L66D7/wDDIEwWkZbSMEaWXfd22n
         x4l+YxcZw9f+IzFq/jar629/1uWsjJxs6PaLSRdcIbxgIAqtPQow9vioIIM2eHUBxXvW
         LHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JKKByTaqxwBETFgifuJGqMvFg0/F2eEogOf15wsQKv0=;
        b=X5VXoq+1Vu1jxQP3NtSx27do0NiBSRkEAC3Obci4ZTnOI02LZqLS6PqIW+tvTyGnwN
         q9S2yVUZX/O16cTCilWFxhbWqfd8KOC/a+3q9Gm3vW0YjRQM0u3dRtwm21HryoIBRtfH
         f9vP409vI04MV4KJABy1s0a1Cd7XOJR0MYCthFY6v5VJo5uoBzeUZW0Wo5X799wVjP+u
         boI5S5+f9A+TxlML00d1OzhEMuQbX80VdKoCe+IaG+ogDoCN+Wcg2bGbaB+3jsjEl9vp
         PtxxgN7F0KkqfWfPiWnCU9pDXslkrGUS6a9d0DJ3YTzuIFsR54UwEfuLvT2AuoEy1T0E
         GvEg==
X-Gm-Message-State: AOAM531mjEc9uj/8cKevgOcRkQOSlDVilboCk9PjZKRQH144blFB8XYb
        Tw8XuYwEDwlQWLbp9N7BlBLbyQ+QUV2rAA==
X-Google-Smtp-Source: ABdhPJw2GiXbzYApnPpFCG3QBzOoEg1ES9DoDLuTdiofLWgz85dQUsRxQnQHdWtzQ5l4siviT6EH1w==
X-Received: by 2002:a63:1517:: with SMTP id v23mr648351pgl.207.1644272750296;
        Mon, 07 Feb 2022 14:25:50 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id g2sm12989560pfj.83.2022.02.07.14.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:25:49 -0800 (PST)
Date:   Mon, 7 Feb 2022 22:25:46 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 13/23] KVM: MMU: remove
 kvm_calc_shadow_root_page_role_common
Message-ID: <YgGcagaLENvf3Y/t@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-14-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-14-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:08AM -0500, Paolo Bonzini wrote:
> kvm_calc_shadow_root_page_role_common is the same as
> kvm_calc_cpu_role except for the level, which is overwritten
> afterwards in kvm_calc_shadow_mmu_root_page_role
> and kvm_calc_shadow_npt_root_page_role.
> 
> role.base.direct is already set correctly for the CPU role,
> and CR0.PG=1 is required for VMRUN so it will also be
> correct for nested NPT.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d6b5d8c1c0dc..19abf1e4cee9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4772,27 +4772,11 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
>  	reset_tdp_shadow_zero_bits_mask(context);
>  }
>  
> -static union kvm_mmu_role
> -kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
> -				      const struct kvm_mmu_role_regs *regs)
> -{
> -	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
> -
> -	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
> -	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
> -	role.base.has_4_byte_gpte = ____is_cr0_pg(regs) && !____is_cr4_pae(regs);
> -
> -	return role;
> -}
> -
>  static union kvm_mmu_role
>  kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  				   const struct kvm_mmu_role_regs *regs)
>  {
> -	union kvm_mmu_role role =
> -		kvm_calc_shadow_root_page_role_common(vcpu, regs);
> -
> -	role.base.direct = !____is_cr0_pg(regs);
> +	union kvm_mmu_role role = kvm_calc_cpu_role(vcpu, regs);
>  
>  	if (!____is_efer_lma(regs))
>  		role.base.level = PT32E_ROOT_LEVEL;
> @@ -4853,9 +4837,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
>  				   const struct kvm_mmu_role_regs *regs)
>  {
>  	union kvm_mmu_role role =
> -		kvm_calc_shadow_root_page_role_common(vcpu, regs);
> +               kvm_calc_cpu_role(vcpu, regs);
>  
> -	role.base.direct = false;
>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
>  
>  	return role;
> -- 
> 2.31.1
> 
> 
