Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715DB648AD3
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 23:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLIWoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 17:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiLIWow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 17:44:52 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A712A1A20E
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 14:44:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id fa4-20020a17090af0c400b002198d1328a0so9265424pjb.0
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 14:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X60ise7QEnBOLcc3D/dBQfic8PhzrSOslDuErC7Ni10=;
        b=pHUdoOKYb0ikWsUFyedzTVRqWFVg+GHcvD2Qt3tMkYnRgphgWNKSWcAqSb1lJUGYV3
         2In6LQHTmk+M/woccvtGcbol+tHuihY0FVIDF2Z4kIsolqvzKaINNw+vqEAgWAFvqT3e
         SBqsToY0x6VAUpiv7c3CoqyhOzssWXjkXdqbdXdotU02cHCxLcCpXYCL19pqFE1kK7Dk
         ixODee2lydPhJ+A9DZ458RZ0X9UpXWkPEiwQTP+5HexIHqUS5/vkKTGRPoxNwSi9JlPk
         99NqBP9UYRQiH5YX47o/EMMJabhk6ghiMSkm4nNj7uUXklplo0CopLcnv7/A5zDLfW7Q
         Ctkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X60ise7QEnBOLcc3D/dBQfic8PhzrSOslDuErC7Ni10=;
        b=xXH696BytqypM39TtG2TsaEsZjsHs33zR98jQxuWC6ziuf10N9q6kM0RBtg0gi0tRG
         ZVd4AEnBu+tBy/cPIaYPQNeEx2AlUERMo8DrWuXtC33F+Ryxtn1z4E2EbkdzKNL6HEzl
         baY7kCbmmxWjXjTchIpHV4725xEWyKRLvLwbmraSh+EN9J95+Bq/1MSAQc+Gy937B+zK
         Xo3+JIn9gOyK6q/yhgG7LXfExdVKc9IxjCEeo0reG8Y0tswnrbDQJAlEXmCHAVdzJelC
         ORuwc/yuq2sXcE/wuqY3Zof3YdFOqdB9fg4/gLN7qRieVgNdOUgs+UzXMNNJrNSRqXwl
         0UrA==
X-Gm-Message-State: ANoB5pkYfIHKZvub2Hgzz25+6WvJ6PXMdxAkcITKqb3TSIPCs2qI26YC
        MSTYDMiSDrPUPEZ9xjKdnv6eEA==
X-Google-Smtp-Source: AA0mqf6kfZWSPqHNCi32c0RbsdLJDYiO+lxQPBmPCC1xUSm/BB/fFxSx+3nTSHZ4LGgFZvPhGyTGBw==
X-Received: by 2002:a17:90a:1b0b:b0:219:396c:9e32 with SMTP id q11-20020a17090a1b0b00b00219396c9e32mr7524057pjq.16.1670625891035;
        Fri, 09 Dec 2022 14:44:51 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090a3b0c00b00219f8eb271fsm1670901pjc.5.2022.12.09.14.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 14:44:50 -0800 (PST)
Date:   Fri, 9 Dec 2022 14:44:46 -0800
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 6/7] KVM: x86/MMU: Move rmap zap operations to rmap.c
Message-ID: <Y5O6XiJSjGmpMl3R@google.com>
References: <20221206173601.549281-1-bgardon@google.com>
 <20221206173601.549281-7-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206173601.549281-7-bgardon@google.com>
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

On Tue, Dec 06, 2022 at 05:36:00PM +0000, Ben Gardon wrote:
> Move the various rmap zap functions to rmap.c. These functions are less
> "pure" rmap operations in that they also contain some SPTE manipulation,
> however they're mostly about rmap / pte list manipulation.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
[...]
> -static void kvm_zap_one_rmap_spte(struct kvm *kvm,
> -				  struct kvm_rmap_head *rmap_head, u64 *sptep)
> -{
> -	mmu_spte_clear_track_bits(kvm, sptep);
> -	pte_list_remove(sptep, rmap_head);
> -}
> -
> -/* Return true if at least one SPTE was zapped, false otherwise */
> -static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
> -				   struct kvm_rmap_head *rmap_head)
> -{
> -	struct pte_list_desc *desc, *next;
> -	int i;
> -
> -	if (!rmap_head->val)
> -		return false;
> -
> -	if (!(rmap_head->val & 1)) {
> -		mmu_spte_clear_track_bits(kvm, (u64 *)rmap_head->val);
> -		goto out;
> -	}
> -
> -	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
> -
> -	for (; desc; desc = next) {
> -		for (i = 0; i < desc->spte_count; i++)
> -			mmu_spte_clear_track_bits(kvm, desc->sptes[i]);
> -		next = desc->more;
> -		free_pte_list_desc(desc);
> -	}
> -out:
> -	/* rmap_head is meaningless now, remember to reset it */
> -	rmap_head->val = 0;
> -	return true;
> -}

I don't like moving the rmap zap functions into rmap.c, because they are
more mmu.c functions, as you note in the commit description. e.g. It's
odd to have kvm_zap_all_rmap_sptes() in rmap.c but not, say
__rmap_clear_dirty().

I get your point though that kvm_zap_all_rmap_sptes() has to know
intimate details of the pte_list_desc structure. It would be nice to
keep those details isolated to rmap.c.

What about keeping the zap functions mmu.c and just provide a better API
for kvm_zap_all_rmap_sptes() to process the rmap entries?

e.g.

mmu.c:

static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
				   struct kvm_rmap_head *rmap_head)
{
	struct rmap_iterator iter;
	bool flush = false;
	u64 *sptep;

	for_each_rmap_spte(rmap_head, &iter, sptep) {
		mmu_spte_clear_track_bits(kvm, sptep);
		flush = true;
	}

	pte_list_free_all(rmap_head);  // <-- implemented in rmap.c
	return flush;
}

This should be about as efficient as the current approach (same big-O
notation at least) and maintain the separation of pte_list_desc
internals in rmap.c.
