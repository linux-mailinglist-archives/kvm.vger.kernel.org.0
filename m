Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4841B724430
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbjFFNTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbjFFNTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:19:32 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C21126;
        Tue,  6 Jun 2023 06:19:32 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b04706c974so52656185ad.2;
        Tue, 06 Jun 2023 06:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686057571; x=1688649571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+J0YyEG+Bc29nQ2RIHEkbLv3QWk8xBsAd1vdT8IvS7g=;
        b=Ec4yMwnyrZjdH/+gIXXH/c8NWhC0USVFjAN4xFs3QCzZXrho2aZMH2pc7xn6MNsBV4
         oHHNnYV5JbsDFuBqO/HJiUH3srguDl3NLu4nbGdkNqLbccRJHvGHnQ6kjAcg2vYtlXla
         bm13S/yN/uIAhqOM7MSv6yfic5pDHuonX7MbIEbmVIaoCgddBtTy4Zh2Z8Vnm0kCbHZn
         +QMbYfeNvioTnv0eTEI+AVX49dKc8mYRwCWefRxeHHRY1+QPzXnSMeoX0v+JybbexJsY
         xQWJPZo2c3UY2V/i9Cku8C+HlnRE0DWWtWapuHk3MXouGrC+dxK0kkdjiaFJXy/fm+b5
         iRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686057571; x=1688649571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+J0YyEG+Bc29nQ2RIHEkbLv3QWk8xBsAd1vdT8IvS7g=;
        b=UWykpg4sjQqiSvqBloi6Q9uOWnDIC/mWn78a/fU8UyhbHUNAJ/D/jMr8ZVQn+Aytz4
         N+qLXzOngVRpLtWn7MBLtPsbQefZBQN45TFuOsIVxok/G3MOT6ts1JCpTSKjlXh0vs3l
         bokqc6sG23fNmvYX9A47vQK6hNmO26jImcsp3Mcqbb8al/eMqsYoNEemcrYEoUyH8VZ6
         YAVJHq4DOwT+2joT5UyD0Ziv6nkQfU0GEFlzAAaf60ETGr7PIWqyh98dkSyr5thhFHB3
         c6kb+BaALYJwVHXoKl2g+4quTviqoKSSGm7eIn3rn6vpVBnDCshtIXSorG5vgwtyT6K2
         VPhg==
X-Gm-Message-State: AC+VfDy35K35arX7Tutn0wDSPOzjvUK0752Zv6eXm+1KZp6U0Qv9k+J/
        3ik0w4q7JvtL8uNDbXVPykQ=
X-Google-Smtp-Source: ACHHUZ7ZZfaFDdXqM05a0itePPSLYv0CvztkAVEuUDRYYwe01/8+sXJpFV38aXfaT6/onULzozX3SA==
X-Received: by 2002:a17:902:e742:b0:1ad:cb4b:1d50 with SMTP id p2-20020a170902e74200b001adcb4b1d50mr2723294plf.43.1686057571118;
        Tue, 06 Jun 2023 06:19:31 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id r2-20020a1709028bc200b001afd6647a77sm8496482plo.155.2023.06.06.06.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:19:30 -0700 (PDT)
Date:   Tue, 6 Jun 2023 06:19:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v14 031/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Message-ID: <20230606131929.GA2403361@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <8b4f21e2fada944d041ffee0f27d527e0e447cbb.1685333727.git.isaku.yamahata@intel.com>
 <20230606045923.ol5kjhagiimqksmn@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230606045923.ol5kjhagiimqksmn@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 12:59:23PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Sun, May 28, 2023 at 09:19:13PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > The TDX support will need the "suppress #VE" bit (bit 63) set as the
> > initial value for SPTE.  To reduce code change size, introduce a new macro
> > SHADOW_NONPRESENT_VALUE for the initial value for the shadow page table
> > entry (SPTE) and replace hard-coded value 0 for it.  Initialize shadow page
> > tables with their value.
> >
> > The plan is to unconditionally set the "suppress #VE" bit for both AMD and
> > Intel as: 1) AMD hardware uses the bit 63 as NX for present SPTE and
> > ignored for non-present SPTE; 2) for conventional VMX guests, KVM never
> > enables the "EPT-violation #VE" in VMCS control and "suppress #VE" bit is
> > ignored by hardware.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c         | 20 +++++++++++++++-----
> >  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
> >  arch/x86/kvm/mmu/spte.h        |  2 ++
> >  arch/x86/kvm/mmu/tdp_mmu.c     | 14 +++++++-------
> >  4 files changed, 25 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index dc2b9a2f717c..1b6fd4434e96 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -576,9 +576,9 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
> >
> >  	if (!is_shadow_present_pte(old_spte) ||
> >  	    !spte_has_volatile_bits(old_spte))
> > -		__update_clear_spte_fast(sptep, 0ull);
> > +		__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
> >  	else
> > -		old_spte = __update_clear_spte_slow(sptep, 0ull);
> > +		old_spte = __update_clear_spte_slow(sptep, SHADOW_NONPRESENT_VALUE);
> >
> >  	if (!is_shadow_present_pte(old_spte))
> >  		return old_spte;
> > @@ -612,7 +612,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
> >   */
> >  static void mmu_spte_clear_no_track(u64 *sptep)
> >  {
> > -	__update_clear_spte_fast(sptep, 0ull);
> > +	__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
> >  }
> >
> >  static u64 mmu_spte_get_lockless(u64 *sptep)
> > @@ -1969,7 +1969,8 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> >
> >  static int kvm_sync_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
> >  {
> > -	if (!sp->spt[i])
> > +	/* sp->spt[i] has initial value of shadow page table allocation */
> > +	if (sp->spt[i] != SHADOW_NONPRESENT_VALUE)
> 
> This should be "sp->spt[i] == SHADOW_NONPRESENT_VALUE" ? Looks all present spt[i]
> are skipped without sync for shadow paging.

Oop, you're right. Will fix it.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
