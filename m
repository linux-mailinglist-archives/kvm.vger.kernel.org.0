Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68EE3CFE94
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 18:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhGTPXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 11:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242834AbhGTPMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 11:12:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBC5C0613DC
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 08:49:50 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f17so26540270wrt.6
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 08:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eXamM+sMZZfyW2rB3syre/v13RlKOutdbrix8Hieb/Q=;
        b=KXp0zKrUI/OXoRw6lXxx2SFUUXaOZwzGxopbvF0uAfHTw7ZmIku2LexAmSY8NEHCGQ
         K5WN0Y8Jo3COz5c3QitqdFAQNczB2y0+XoewDy5ZSAI5R78/TdP4nbqPKFtoTSTfunVl
         bYN8+t4/ZagWjaeYdraSMxMDpI8Hog34PDuKoXSZx9FX+J+2o6wqUoAD9MttLM/PKiro
         OCwm/Cvoam/U9zF03GieeDkrvVkMT0/cqwSXZxbvvcGAbOXoUBAlCKlMWMmqAj7lHMtD
         X5g2NJEkHfXzydWS8RU//uFnq6ZimmZw6TPCCxXOqcqeMnwLuORTvkgHMukdmC1e5bTB
         emKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eXamM+sMZZfyW2rB3syre/v13RlKOutdbrix8Hieb/Q=;
        b=IuEr3JdrG/Dej7VS2/ecxR9GMsifGZLhIKB9boe5Cm/7eqoiJmlwZFOkJUno4cxvZ8
         daRo9lS5PT55l38JlqR/f9A/tsV/JbVof5MN2hR+noO88bSfRu1M7CUTgTBdrk9zcpby
         bGgqxAahJWbF6KsH2hcyHa0WAdrYnyRXMaFggVGnX+feGjAC0hJVEmc2HUt8fYXdV/X4
         7/8t3cJ/MXL/YHUuJ0CnivhUuwrAV/sLn3/lnL7dlESQdtZUdd34fl02GL64tkXYYrSz
         EwZBOGQCtybd3CF7XiZerD8xFfJsiq5+GqTLp3MxqQ3hMtQX9kCsm2NMO4fdqlxWw5n2
         a7Fg==
X-Gm-Message-State: AOAM530RjnOnQV7q7f0e8xex58uHNjNtR86g+JyIwhxy5Yr8fvq5KmDD
        U3zKAqs5T/iOlD+JW5PtFdVkmA==
X-Google-Smtp-Source: ABdhPJyzRWkzFreaGWXMPsTfkWs7PmiScWdF0pFWpbrQIca+q2nIlIPzY5Ms7/DYn3Ihu8xo8lE/SQ==
X-Received: by 2002:adf:efc6:: with SMTP id i6mr36363480wrp.213.1626796189365;
        Tue, 20 Jul 2021 08:49:49 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:ffa2:b757:e72a:11dd])
        by smtp.gmail.com with ESMTPSA id c2sm23910164wrs.60.2021.07.20.08.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 08:49:48 -0700 (PDT)
Date:   Tue, 20 Jul 2021 16:49:45 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        dbrazdil@google.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <YPbwmVk1YD9+y7tr@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
 <YPav0Hye5Dat/yoL@google.com>
 <87wnpl86sz.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnpl86sz.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday 20 Jul 2021 at 14:15:56 (+0100), Marc Zyngier wrote:
> On Tue, 20 Jul 2021 12:13:20 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > On Thursday 15 Jul 2021 at 17:31:47 (+0100), Marc Zyngier wrote:
> > > +struct s2_walk_data {
> > > +	kvm_pte_t	pteval;
> > > +	u32		level;
> > > +};
> > > +
> > > +static int s2_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > > +		     enum kvm_pgtable_walk_flags flag, void * const arg)
> > > +{
> > > +	struct s2_walk_data *data = arg;
> > > +
> > > +	data->level = level;
> > > +	data->pteval = *ptep;
> > > +	return 0;
> > > +}
> > > +
> > > +/* Assumes mmu_lock taken */
> > > +static bool __check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> > > +{
> > > +	struct s2_walk_data data;
> > > +	struct kvm_pgtable_walker walker = {
> > > +		.cb             = s2_walker,
> > > +		.flags          = KVM_PGTABLE_WALK_LEAF,
> > > +		.arg            = &data,
> > > +	};
> > > +
> > > +	kvm_pgtable_walk(vcpu->arch.hw_mmu->pgt, ALIGN_DOWN(ipa, PAGE_SIZE),
> > > +			 PAGE_SIZE, &walker);
> > > +
> > > +	/* Must be a PAGE_SIZE mapping with our annotation */
> > > +	return (BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(data.level)) == PAGE_SIZE &&
> > > +		data.pteval == MMIO_NOTE);
> > 
> > Nit: you could do this check in the walker directly and check the return
> > value of kvm_pgtable_walk() instead. That would allow to get rid of
> > struct s2_walk_data.
> > 
> > Also, though the compiler might be able to optimize, maybe simplify the
> > level check to level == (KVM_PGTABLE_MAX_LEVELS - 1)?
> 
> Yup, all good points. I guess I could do the same in my other series
> that parses the userspace PT to extract the level.

Well, actually, let me take that back. I think something like you have
would be useful, but in pgtable.c directly and re-usable for stage-1 and
stage-2 walks. Maybe something like the below (totally untested)?

I could use such a walker in several places as well in the memory
ownership series:

 - following the idea of [1], I could remove the
   kvm_pgtable_stage2_find_range() function entirely;

 - [2] defines 2 custom walkers that do nothing but walk host stage-2
   and hyp stage-1 page-tables to check permissions and such --  they
   could be removed/re-implemented easily as well.

And you seem to need something similar here, so clearly there is a need.
WDYT?

Thanks,
Quentin

[1] https://lore.kernel.org/kvmarm/20210719104735.3681732-3-qperret@google.com/
[2] https://lore.kernel.org/kvmarm/20210719104735.3681732-14-qperret@google.com/

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e0ae57dca827..bd6d26f27e1a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -357,6 +357,38 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
        return _kvm_pgtable_walk(&walk_data);
 }

+struct get_leaf_data {
+       kvm_pte_t *ptep;
+       u32 *level;
+};
+
+static int get_leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+                          enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+       struct get_leaf_data *data = arg;
+
+       *(data->ptep) = *ptep;
+       *(data->level) = level;
+
+       return 0;
+}
+
+int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr, kvm_pte_t *ptep,
+                        u32 *level)
+{
+       struct get_leaf_data data = {
+               .ptep = ptep,
+               .level = level,
+       };
+       struct kvm_pgtable_walker __get_leaf_walker = {
+               .cb             = get_leaf_walker,
+               .flags          = KVM_PGTABLE_WALK_LEAF,
+               .arg            = &data,
+       };
+
+       return kvm_pgtable_walk(pgt, addr, PAGE_SIZE, &__get_leaf_walker);
+}
+
 struct hyp_map_data {
        u64                             phys;
        kvm_pte_t                       attr;

