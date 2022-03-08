Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F204D1D10
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348316AbiCHQXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243812AbiCHQXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:23:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EF750E35
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:22:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso2708332pjb.0
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 08:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xW2imMOutmquafxF6rHzfFkEBpMTI0PWyZxcGyPtb50=;
        b=MCD+dvcy259RSICUkCH75otGlkyAbPXPKDoUEleaC2vus6Waenni04K+yoC1lkqvTl
         nCCOOHMtejyt5BFBlIKi4g6Smi8klWMZFbGixfK7emKCYEXxikHDwveMZU2ftutnlw8b
         l89l7xo+s291rz85/nUEMPRFEzS3sQhrC2UIQ3eFQzRfK7A3yydVnADQHa08z2S8x0kx
         VS4v2QqRfM9Vwjy4GhoSBCx/fuFHgtIg/3ox3wvywh2m2cw/248YKQPFSZT4Nb82ZT86
         6+691BC0qmioMGzkZ79SoGigpBBxE85TrMNe7Tp2DIZPB91z3bwRUAQ4BWu9/BHlUe/n
         tJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xW2imMOutmquafxF6rHzfFkEBpMTI0PWyZxcGyPtb50=;
        b=A3lYamoiFv78bZrjQgk7SbirkO+MXJ1TZzA84n7hqWoEAcFSoLKPqpTPtBPwzZz+oA
         4tzrSAnZQcRUjcGZ61P5n8Utk+YxXM3xRWPy/Z1RrO/FV2oTCOd/KcqFOzViCyqe7Hf9
         JpuG0wr4lyD/YBu2BJjwpBu1NKyalsrhtflVnF1oKK4jXCG4JE4dD7fS+wKmohFI1fkR
         jKT/wO5UdhbVrUIkYyesJ9wB18OZmcfuy2tnccJiSzWVxSDqZSSxdQoQBAc/SWYellaW
         17PBo4BNcbQIl3NwhjLJ/3Jc+87Bd1R6i2JH3/7f14I5ygYD1Kwue4U7Dd0UiA6F7wcY
         apFA==
X-Gm-Message-State: AOAM531SpjDgC4vnQ9dHLEaTmVzz54OL5TjTmHOMtituOpLNfZZQM/Nx
        UPfptcN1dRQiTYdQKUAsahmvjA==
X-Google-Smtp-Source: ABdhPJz6ARuYB4YZ7aXIng0pjWq4qPANAL65m0PtT31NQs0c0fE7sDf+xOj6vXdW+JuOFPDnB5TA9w==
X-Received: by 2002:a17:902:7049:b0:151:e52e:ae42 with SMTP id h9-20020a170902704900b00151e52eae42mr12259055plt.118.1646756542191;
        Tue, 08 Mar 2022 08:22:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a00244500b004f6f049432esm11261271pfj.176.2022.03.08.08.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 08:22:21 -0800 (PST)
Date:   Tue, 8 Mar 2022 16:22:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 03/25] KVM: x86/mmu: constify uses of struct
 kvm_mmu_role_regs
Message-ID: <YieCuvb7FSMj849F@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> struct kvm_mmu_role_regs is computed just once and then accessed.  Use
> const to make this clearer, even though the const fields of struct
> kvm_mmu_role_regs already prevent modifications to the contents of the
> struct, or rather make them harder.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4f9bbd02fb8b..97566ac539e3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -197,7 +197,7 @@ struct kvm_mmu_role_regs {
>   * the single source of truth for the MMU's state.
>   */
>  #define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
> -static inline bool __maybe_unused ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
> +static inline bool __maybe_unused ____is_##reg##_##name(const struct kvm_mmu_role_regs *regs)\

This is one of the very rare times I think it's worth splitting the prototype,
it's not like the function name is grep-friendly anyways.  Either way,

Reviewed-by: Sean Christopherson <seanjc@google.com>

static inline bool __maybe_unused					\
____is_##reg##_##name(const struct kvm_mmu_role_regs *regs)		\
{									\
	return !!(regs->reg & flag);					\
}
