Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A2F712C3E
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 20:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjEZSNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 14:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjEZSNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 14:13:05 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C156FB
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 11:13:03 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b0213d4b43so2084195ad.1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 11:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685124783; x=1687716783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8723Sfa2idjuBQyBmaDZ+sDNH51vHhk7kq9m2RHFfPo=;
        b=phFaQo+YrscBxZ4dCTRlBjVL4pmD4DdWCACjQdTVYBaRZdnSp2rdTXqVB/UWwgr4M4
         /xCclCbfcj/rmH54dDvHRJQJMFWVkDOrFJX9i17QTyocpAv55VhyK4bMV0RTKxPb9ove
         Wss+h0JL9nsYapeRI+aMTvInNeBDtWl84Q2QbZZYT6VzRAHfq61xWYvnDbasvi/JWePI
         ZGWQPvdvsTT6VRfjovZ2wf5WzCY63S02m6VLIGprrWqtaJ+IqtQA57EurgYvvEU4CUp+
         PzWGGDCEL+J17Pvjx++8WmIi/2WC/WMLZnpp9g2nvWHRui1QMKMGLyHd9nkSOI4BMnQV
         mMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685124783; x=1687716783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8723Sfa2idjuBQyBmaDZ+sDNH51vHhk7kq9m2RHFfPo=;
        b=MVxbV3QS1F/9O4xwXA09Ui8lKgIsOM3JZOeioA3XLbBysRn/CdZdzY1ahth4n/cAyt
         wvC8mO4D72Ufgn0YNRYN+mBYca7m6RmXBummzvgBKnqypd5hSIsuyfwJDL8g8ibYBwKY
         neIJjU+seOqsm73FFlxxyLjKfCyXKxdwjiXbcT8AAVbUf4r7khwmSbUf+ImPPjqGd1GT
         u9O/WCe5DR6oE1wEOInuTYS1+UUXq+bDCeGid/atXHgfggd5XqIJoSj88jEwIhZu5g3a
         czIVYhHH2Ub1wgFyJ4y/RFb3x3dvEmfxpevU02+70xq8u2HMJkdgDW9NatPuC+0JIGm8
         vaTg==
X-Gm-Message-State: AC+VfDwR1E+0SFtl6I2sKDzObHubbfYJWqTVVrU+hpAQ2MFjTMnPz2vR
        uW2jEypdeLMP3bDqbrUZlfI1zPStlrU=
X-Google-Smtp-Source: ACHHUZ76Nlf0os6oArC9JsZPgT3KHXz0dP+otmezqCfGjdcj+1gOtdBh4RxUVCe0m5DonJ7AV1EEZxLe5ZE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da82:b0:1a5:25db:5bc0 with SMTP id
 j2-20020a170902da8200b001a525db5bc0mr786579plx.3.1685124782889; Fri, 26 May
 2023 11:13:02 -0700 (PDT)
Date:   Fri, 26 May 2023 11:13:01 -0700
In-Reply-To: <20230425113932.3148-1-ubizjak@gmail.com>
Mime-Version: 1.0
References: <20230425113932.3148-1-ubizjak@gmail.com>
Message-ID: <ZHD2rYBCSe5OSYIU@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add comment on try_cmpxchg64 usage in tdp_mmu_set_spte_atomic
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 25, 2023, Uros Bizjak wrote:
> Commit aee98a6838d5 ("KVM: x86/mmu: Use try_cmpxchg64 in
> tdp_mmu_set_spte_atomic") removed the comment that iter->old_spte is
> updated when different logical CPU modifies the page table entry.
> Although this is what try_cmpxchg does implicitly, it won't hurt
> if this fact is explicitly mentioned in a restored comment.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c25dbf32ecc..5d126b015086 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -655,8 +655,16 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
>  	 * does not hold the mmu_lock.
>  	 */
> -	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
> +	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte)) {
> +		/*
> +		 * The page table entry was modified by a different logical
> +		 * CPU. In this case the above try_cmpxchg updates
> +		 * iter->old_spte with the current value, so the caller
> +		 * operates on fresh data, e.g. if it retries
> +		 * tdp_mmu_set_spte_atomic().
> +		 */

If there's no objection, when applying I'll massage this to extend the comment
above the try_cmpxchg64(), e.g.

	/*
	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
	 * the current value, so the caller operates on fresh data, e.g. if it
	 * retries tdp_mmu_set_spte_atomic()
	 */
	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
		return -EBUSY;
