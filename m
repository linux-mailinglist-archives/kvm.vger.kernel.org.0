Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005AD62E58B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbiKQT7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiKQT7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:59:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AE27EC9B;
        Thu, 17 Nov 2022 11:59:53 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id h14so2593020pjv.4;
        Thu, 17 Nov 2022 11:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0jjCvN/U62CBtNeRGjUmxMt91mNJt0xq2BvAYRF4zlc=;
        b=k1hyU3F/f01xjMrd93O3wYDTxkW+ZAFE6ofw4phH6rJliVlN3o1VsL6w2kZm2hV2aw
         U8H7qUuiM1r1pwfJqKHYFIJzm/QcTUVOo4HcCiq4KxIWVuRPbYBnHTlBMX2uSgI2E+WB
         gCdWTxCFNqhmmG6EOXADKyqxUBRVToK1sCPzHxkPDreh3bhUDYj05oENUjnnbw7KnZpq
         cZFz6Uhj2wzyNLvDrvZ70/7kmvFsnj8bPXQcOkzgLqCdyvEtAVfVPuyxqQMlNtw/7Ors
         GA+poZsrcWuQzqpAOviVZW4i1lj1rvWLBQywC3GuCuV1ADOV+EGSx61FKkgIQbfOUkdq
         JEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jjCvN/U62CBtNeRGjUmxMt91mNJt0xq2BvAYRF4zlc=;
        b=6BJhoiHwKwnFa74m2IScx6DV1mfXeI/Hqp+fospMeX+qZ09xLdqyauLfWUzi7SmN5e
         Gyb0MtWkYsiqrpaX6oiCq2TlmbMEkDbyy+2/CeYUslBElxUcpGZKlt1OA88F7AI6Z+9e
         aa7Fn4Ch8R56NRqYDw2x+emP3pEONSw4Smrd3HkbictNRBQZFA+341CmEkHBx6MDeypI
         EOtfueobuejLVwzCc1aIBRiZ3/fW4UPyRoL5mEGCQcMBiJN3gwx6jnDsbIfBtxZ4K9Vi
         f9lLtvcEekiFQJIWLRIqkGbzL0IrmbtIIV8tSMAp8jCLbAVpHdVWTzVRvo2SLvtW1IoP
         O41A==
X-Gm-Message-State: ANoB5plrXBHsldyIC8r+SRv2jv6Epn78waqX4U8H6h15KNnliZxNK34S
        4/iL0oZiISpY4hrHdhW4VbMUYafWfK0=
X-Google-Smtp-Source: AA0mqf55Tf9WAUPyndp9reHlPVJmS5trCuKsmQ7qY+x5waUTDSRcGC20MoqAN+f2b+4ZWkHk78pmXw==
X-Received: by 2002:a17:90a:8406:b0:205:d3f8:5241 with SMTP id j6-20020a17090a840600b00205d3f85241mr9988198pjn.188.1668715193051;
        Thu, 17 Nov 2022 11:59:53 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id j15-20020a170903028f00b001754fa42065sm1776493plr.143.2022.11.17.11.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:59:52 -0800 (PST)
Date:   Thu, 17 Nov 2022 11:59:51 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v10 049/108] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20221117195951.GO2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
 <30be6d64-31bd-bfc8-72f7-fb57999e4566@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <30be6d64-31bd-bfc8-72f7-fb57999e4566@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 09:41:44PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index f28c9fd72ac4..1b01dc2098b0 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -94,6 +94,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
> >   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> >   KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> >   KVM_X86_OP(load_mmu_pgd)
> > +KVM_X86_OP_OPTIONAL(link_private_spt)
> > +KVM_X86_OP_OPTIONAL(free_private_spt)
> > +KVM_X86_OP_OPTIONAL(set_private_spte)
> > +KVM_X86_OP_OPTIONAL(remove_private_spte)
> > +KVM_X86_OP_OPTIONAL(zap_private_spte)
> >   KVM_X86_OP(has_wbinvd_exit)
> >   KVM_X86_OP(get_l2_tsc_offset)
> >   KVM_X86_OP(get_l2_tsc_multiplier)
> > 
> > @@ -509,9 +524,81 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
> >   		WARN_ON_ONCE(ret);
> >   	}
> > +	if (is_private_sp(sp) &&
> > +	    WARN_ON(static_call(kvm_x86_free_private_spt)(kvm, sp->gfn, sp->role.level,
> > +							  kvm_mmu_private_spt(sp)))) {
> > +		/*
> > +		 * Failed to unlink Secure EPT page and there is nothing to do
> > +		 * further.  Intentionally leak the page to prevent the kernel
> > +		 * from accessing the encrypted page.
> > +		 */
> > +		kvm_mmu_init_private_spt(sp, NULL);
> 
> Do you think is it better to add some statistics for the intentinal leakage?

No because this error case happens only when race condition bug(TDX_OPERAND_BUSY)
or TDX module was shutdown due to bug or attack.  They are (should be) rare.

The race condition bug should be fixed. It's covered by WARN_ON().  In the case
of TDX module shutdown, the current TDX KVM implementation checks unexpected
error and mark it bugged, KVM_BUG_ON(), in vmx/tdx.c.  So adding statistic
counter doesn't help.  It's another story to harden the code against TDX module
shutdown.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
