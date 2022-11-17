Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB48562E54D
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbiKQTbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbiKQTbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:31:31 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF246D4B5;
        Thu, 17 Nov 2022 11:31:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id h14so2531910pjv.4;
        Thu, 17 Nov 2022 11:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WiuxoynRLz+oGeIJ5rNZguwfh42cRexnDNgABpAnrbw=;
        b=PJeHgBlScQNvwpsB8VT37+K2TGOelG8LHVzzRuMeJyeMCV/S9FqNeSVwMQveoF0ML4
         u2Scd+LtFRYOkDMrjDA1HOGQrhYSWigFlybH9405+JFSSyGvezGyH5M9Yr49JBVh/MTY
         IyYsvkK8cVOKooUix+vei4DlcNQMx+9Pvx+FnX8zXe1LadV2SbDvzuK3mnZbMYpczq0v
         PIC2e1xlZCEnIl6JT6NqkotFq+59M7yvObvtpGtblwIBDsVoUlhIQhVug0KcZPWnN0oP
         OihVkPuVmQCWFI17lfGT+BezGi73W9l/IJejQyY10EOCJtRPMwxLEeVesdBhu2DPcVXt
         zviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WiuxoynRLz+oGeIJ5rNZguwfh42cRexnDNgABpAnrbw=;
        b=AexlF0CMMp2UCFBgGuOd0V0S96J5NALyFkNpMb05u5L7fFoRA3mH7Rj9l4G4YjXrAI
         XQOHK9cZ5b9edEIp6bGEYi/gpRoeHmgYvtzR3rHTnvR7EVHshFWcA57vkF5Z5d/vAspD
         VWVPpcRUvJLgW56uL0VrfV3GRqVgkem/NHXubBXXVHiY7enc1g6tzhP5AUWFWZ5+GV6Z
         AT5cHt2PWm2a/pxHjGczClxnma0NrnKLAZeMvVO0iZMOd7Qcm+HsOOUp1Js0jGM/tLT9
         izt1uZKnBF9//DnXasQjq9g+6+aDreYgjkrfCRrDBbz9PJ+Xo9vBDKhY1Fp9qCF2bgh3
         vxQA==
X-Gm-Message-State: ANoB5plzaONFdolY8EoY+GXHrslV8ffFW5t7mDtoCS5Yhjq3jFbFLzsZ
        84Xjhz9tzW+j/TDkn615JQA=
X-Google-Smtp-Source: AA0mqf5Wm5P2UM7qzuJWksEsRxlb1kn2Q/c2TQSh8oDstt7T5T8nA8qsxzBctPj/g5aU5NmMxp3hXg==
X-Received: by 2002:a17:903:228c:b0:186:8930:20e6 with SMTP id b12-20020a170903228c00b00186893020e6mr4203389plh.64.1668713489442;
        Thu, 17 Nov 2022 11:31:29 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902a50200b00187022627d7sm1788648plq.36.2022.11.17.11.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:31:29 -0800 (PST)
Date:   Thu, 17 Nov 2022 11:31:27 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 049/108] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20221117193127.GN2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
 <26a3508e4f57f6104abecd90192f12375fe04ecc.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <26a3508e4f57f6104abecd90192f12375fe04ecc.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 11:58:46AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> >  
> > +static inline int kvm_alloc_private_spt_for_split(struct kvm_mmu_page *sp, gfp_t gfp)
> > +{
> > +	gfp &= ~__GFP_ZERO;
> > +	sp->private_spt = (void *)__get_free_page(gfp);
> > +	if (!sp->private_spt)
> > +		return -ENOMEM;
> > +	return 0;
> > +}
> > +
> > 
> [...]
> 
> > @@ -1238,6 +1408,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  		    is_large_pte(iter.old_spte)) {
> >  			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> >  				break;
> > +			/*
> > +			 * TODO: large page support.
> > +			 * Doesn't support large page for TDX now
> > +			 */
> > +			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
> > +
> >  
> 
> So large page is not supported for private page, ...
> 
> >  			/*
> >  			 * The iter must explicitly re-read the spte here
> > @@ -1480,6 +1656,12 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, union kvm_mm
> >  
> >  	sp->role = role;
> >  	sp->spt = (void *)__get_free_page(gfp);
> > +	if (kvm_mmu_page_role_is_private(role)) {
> > +		if (kvm_alloc_private_spt_for_split(sp, gfp)) {
> > +			free_page((unsigned long)sp->spt);
> > +			sp->spt = NULL;
> > +		}
> > +	}
> 
> ... then I don't think eager splitting could happen for private mapping?
>  
> If so, should we just KVM_BUG_ON() if role is private?

Right, will remove this part from this patch series and move it to large page
support series.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
