Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB9B6A74C7
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 21:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCAUJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 15:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCAUJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 15:09:07 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B9130F8
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 12:09:06 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso464488pjb.2
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 12:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P7eAD2Gb6fcDDSne2DyL9bnHSfz2x3cReasxazf6twg=;
        b=McB++hXnaNyFjHfhU69tOUW5gP3cKRJ4Huvd3MNSv74KxrVBxE0IzHqtcAAaNn4wcf
         V1ONo4iCz7CFiizKEo2S1UhjV7pn4mqMzwJXiKl3+M0kJLq2Rx6JvPR+0FYMIp1SlmAL
         T3mKdsTJzcjN/OhRI7ujMkAJ1VLKHZUyWEwozYtF4cz+VGzuO9ZgTNWNr/6Y7TZuNTGZ
         u+JMIkfUqZxQfPiKtNR/LvVTjsD3+6M3dufQ1p4zWOINHGxd5xuxJMT8S+XrBDKwmYP/
         G8C0hIZn/dOR9QUX6WYadSTzMcRXtxGEz5/NRz7zI0L7sUeb/vrujAa1RLU0GunlV+sp
         i33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7eAD2Gb6fcDDSne2DyL9bnHSfz2x3cReasxazf6twg=;
        b=wguYfj/edH1XCDqVECAP3D4pD7JGNchJLK+uSascezwkxAa2vOdR6uc/kNlZM9AiqW
         0EeyJa7oxY3QPqiBRM1tWdX6bWZRPksWr0wEQC7jTeqMS/+A2vVusm6X1S6+4Qh2m7FR
         PS2Y6W7AHYNSST6gU+f5iyTKeAwpmPKMfFvFrUiKNpAk4dwreOHQo1khO9nxT9/+7Trc
         GBdMHMYW66jWnlLbAN2ibH/e4pRfSHvSHIMBxihlyPrVAJWsf4Ha9TUewBT3+DthlhpT
         7KNdz2ryMS/eaSJ6jXPotfSr82VQs4nXNLvNEZ58eQX7FwGUi9F25cyFrPxoO4iP1TQ0
         keYw==
X-Gm-Message-State: AO0yUKXHvGP7pTIN00plmhXTkrcxB9qOGmC2RGWLzwZphpqzAR/VjhEt
        SEb9Eq0hsEd7IDOtoIdynKD6UQ==
X-Google-Smtp-Source: AK7set9z9D8Fdr2+P4yxzM4OueOcGxjQgTmIZiMRXYC6uxfYo8CsAM/CGzgUCTp8VyKNp5/A1TnqdQ==
X-Received: by 2002:a17:903:27c4:b0:19a:723a:81cb with SMTP id km4-20020a17090327c400b0019a723a81cbmr22410plb.13.1677701345729;
        Wed, 01 Mar 2023 12:09:05 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id e7-20020a170902b78700b00186b7443082sm8839022pls.195.2023.03.01.12.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 12:09:05 -0800 (PST)
Date:   Wed, 1 Mar 2023 12:09:00 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH v4 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y/+w3O9I7Qsuo5wO@google.com>
References: <20230218032314.635829-1-ricarkol@google.com>
 <20230218032314.635829-5-ricarkol@google.com>
 <Y/BFz5uC+iL2+q2o@google.com>
 <90bcd4e5-bfa6-17fe-25f2-3c6b7aab9a4c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90bcd4e5-bfa6-17fe-25f2-3c6b7aab9a4c@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +/*
> > > + * Get the number of page-tables needed to replace a block with a
> > > + * fully populated tree, up to the PTE level, at particular level.
> > > + */
> > > +static inline int stage2_block_get_nr_page_tables(u32 level)
> > > +{
> > > +	if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
> > > +			 level >= KVM_PGTABLE_MAX_LEVELS))
> > > +		return -EINVAL;
> > > +
> > > +	switch (level) {
> > > +	case 1:
> > > +		return PTRS_PER_PTE + 1;
> > > +	case 2:
> > > +		return 1;
> > > +	case 3:
> > > +		return 0;
> > > +	default:
> > > +		return -EINVAL;
> > > +	};
> > > +}
> > 
> > Shaoqin,
> > 
> > "Is the level 3 check really needed?"
> > 
> > Regarding your question about the need for "case 3". You are right,
> > it's not actually needed in this particular case (when called from
> > stage2_split_walker()). However, it would be nice to reuse this
> > function and so it should cover all functions.
> > 
> > Thanks,
> > Ricardo
> > 
> 
> Hi Ricardo,
> 
> Thanks for your explanation. And I'm wondering since
> stage2_block_get_nr_page_tables() is aimed to get how many pages needed to
> populate a new pgtable and replace the block mapping, and level 3 is the
> PTE, it can't be split. So is it still ok to put level 3 in this function,
> although put it here has no effect.
> 
> Shaoqin

Hi,

The "level 3" check is not used by kvm_pgtable_stage2_split(), but
stage2_block_get_nr_page_tables(level=3) is not an invalid (EINVAL) call
either.

Sorry for the late reply.

Thanks,
Ricardo
