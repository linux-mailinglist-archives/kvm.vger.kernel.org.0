Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37ADB4D1F65
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349262AbiCHRtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348465AbiCHRtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:49:42 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FF74838C
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:48:45 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m22so57622pja.0
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9EY+jbz7yxv8opR/z4nwJHkmZWRpRix7BFXhHKCoISQ=;
        b=HXAGF40IVistJKOXvEgTZPX31PpRTlv2NhZQsp0w0nAlT2c3IssIMwMm2CLCQGRgfV
         LqMUB0KqsayxM/XW+vAOSclwOFINpQGuUCmIaQTzvbU/PELYLARX16koTM8NzkLc3ELA
         8ihK5SuqfLYJm5oCY7ubBwGo1uTABBeS3ChzZTuMt/SBatkzzUgdsUSHyxb6ZYtsczQt
         TlruRmDyHW292Lc2Eg7PbhrmWIRY7OSl43JwLv7e7Co0iqfRRlj5UGmwvbrZTVgry/t7
         wsHLI7NrvxKHkQGXKWpe8I/MqFFP96YKNsRNAHneRx1okFTEcK5kyY+jm0+nM1pCUD+F
         Y4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9EY+jbz7yxv8opR/z4nwJHkmZWRpRix7BFXhHKCoISQ=;
        b=SaMOn106gulJy3IDxU5nGoyy9WW5l517rIALmz7ar9SAxDgZRFpHLoX2bLegi9Rkbs
         PfNGVHXdQi6tJBv0zO2ZG8+q5IRLDq5MDxhn2q6Dt2ZHzKjPjpxPHFvu24/N+3dKF1g7
         Ej9tv0fxwjWCcXJhPi7nf6Vy3P4GC0h+13osKqTU4sRF1vvDsevVJHl4b8fkyBuF1o9G
         HanOKeeUPvLPba16bCd2FiPsHYQZoW4KAm0z+VU9u7WN38Dk90qOiMwqvubia9NjSV06
         G9qo1+Yt63hlwZWkDtRYHCpKhuZlGx+xKvVLBUiFjRsTHFyMrBRoXLdmw07AopDSd8EK
         dbOA==
X-Gm-Message-State: AOAM533Vs48SOl5oEJov/RLfGXqBrpE4IKN+B0IYrT7EiR+sqJVyCdZO
        76Zk3zFTNOhKUBdoSg94TG86rQ==
X-Google-Smtp-Source: ABdhPJzAMqaA2eVSkxGml9gMR9kbyJkC+ocfJL8hF2J8qHUTa3dshAXxR+KRdUTYP8+4wSVp0hTH3w==
X-Received: by 2002:a17:90a:5d93:b0:1bc:4f9c:8eed with SMTP id t19-20020a17090a5d9300b001bc4f9c8eedmr5918639pji.180.1646761725209;
        Tue, 08 Mar 2022 09:48:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i11-20020a056a00004b00b004f6907b2cd3sm19046452pfk.122.2022.03.08.09.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:48:44 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:48:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 11/25] KVM: x86/mmu: remove
 kvm_calc_shadow_root_page_role_common
Message-ID: <YieW+PZarPdsSnO7@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-12-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-12-pbonzini@redhat.com>
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

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> kvm_calc_shadow_root_page_role_common is the same as
> kvm_calc_cpu_mode except for the level, which is overwritten
> afterwards in kvm_calc_shadow_mmu_root_page_role
> and kvm_calc_shadow_npt_root_page_role.
> 
> role.base.direct is already set correctly for the CPU mode,
> and CR0.PG=1 is required for VMRUN so it will also be
> correct for nested NPT.

Bzzzt, this is wrong, the nested NPT MMU is indirect but will be computed as direct.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3ffa6f2bf991..31874fad12fb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4796,27 +4796,11 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
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
> +	union kvm_mmu_role role = kvm_calc_cpu_mode(vcpu, regs);
>  
>  	if (!____is_efer_lma(regs))
>  		role.base.level = PT32E_ROOT_LEVEL;
> @@ -4869,9 +4853,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
>  				   const struct kvm_mmu_role_regs *regs)
>  {
>  	union kvm_mmu_role role =
> -		kvm_calc_shadow_root_page_role_common(vcpu, regs);
> +               kvm_calc_cpu_mode(vcpu, regs);

No need to split this line with the less verbose name.

>  
> -	role.base.direct = false;

As above, this line needs to stay.

>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
>  
>  	return role;
> -- 
> 2.31.1
> 
> 
