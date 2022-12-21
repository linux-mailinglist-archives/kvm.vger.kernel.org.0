Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3878D65381E
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 22:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiLUVNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 16:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiLUVNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 16:13:51 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD791DD8
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 13:13:50 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id k2-20020a17090a514200b002198214abdcso1696115pjm.8
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 13:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PenTOvotttU7AmWkY+rsqQVQep4flBuUsNbRQCbS+sM=;
        b=pOTmhACNYo1c6e5VpoPFMfTaxHbIAJuEC/bxSSylZ5vRbtUdOFRCXgjFIA4X5jLvPD
         flb/LB4TH/uuvoK2/NtP8JnzbfZXvS9oBcxDUwcJj3QW4lRcXpSTNxIlkqP7cyKBl7nv
         4Jtq6tPAoI59O/RzpP0bcGNyfSJN1WPMXoBXtioyDtqsUO8V33g9bXwEegywfWsIxBvF
         sXErENFQlthvY1dtQam1/J86obaYy26jTOs/kejj6Fs7Qftdv8fCx8uD1f+Yqgw7xScQ
         VITw+P/JMdyCTi81bpYxT/SJvcGA8NpnRjgGoewE1JR+s0QkkZhgGB7tUYclt6lIxImm
         jctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PenTOvotttU7AmWkY+rsqQVQep4flBuUsNbRQCbS+sM=;
        b=rtegbB736mHMzUPguePUemmJEuYIMa78ARLPwAkSX/UYVkQL3ux+vu2pRawyGzuah7
         Nv4vG7vb5W1vg/Ffs1Hp5FJkGPJj0VtxSBBo3EM92fYVER1LbAqP+pYACd0737kmP3F5
         /pFoZHlK1EDerGWqmjIZrGS5qxUXgazr+GpFHC7cm3mInhgk+l2tdrsLGTcNr5NlqV2b
         owOJQndxyjrqpimARVWqdD8WFnCuRqtZHX04712xNDf8jLtLP8B8og1V6yogDPYc5ky9
         cXqhSdhuh2xpS8hxAiyPUFClfjmXSz37QXcvDl1aerKNpSFLYEpyRZIiXAacH7Te9vYv
         rhAA==
X-Gm-Message-State: AFqh2ko/H42gBv2SAn3eA1zRzdsf20QSBAYZBdSychbb515SUb/aduHs
        jiK0p2ZZnCmJRjY5waAs2ow1yUa3qa19MQht8g==
X-Google-Smtp-Source: AMrXdXtddR1n0o7PYnl0IaV/gyWF5bACxgunxQd/8awvcQVlOohm0sx9Yn/7KRBEs4Dt6XioXrkpg456lqVBy42XTg==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a05:6a00:1d81:b0:576:ba28:29a8 with
 SMTP id z1-20020a056a001d8100b00576ba2829a8mr195606pfw.47.1671657230323; Wed,
 21 Dec 2022 13:13:50 -0800 (PST)
Date:   Wed, 21 Dec 2022 13:13:48 -0800
In-Reply-To: <20221018205845.770121-6-pgonda@google.com> (message from Peter
 Gonda on Tue, 18 Oct 2022 13:58:43 -0700)
Mime-Version: 1.0
Message-ID: <diqz3598v4s3.fsf@google.com>
Subject: Re: [PATCH V5 5/7] KVM: selftests: add library for
 creating/interacting with SEV guests
From:   Ackerley Tng <ackerleytng@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, pgonda@google.com,
        vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +static void encrypt_region(struct kvm_vm *vm, struct  
> userspace_mem_region *region)
> +{
> +	const struct sparsebit *protected_phy_pages =
> +		region->protected_phy_pages;
> +	const uint64_t memory_size = region->region.memory_size;
> +	const vm_paddr_t gpa_start = region->region.guest_phys_addr;
> +	sparsebit_idx_t pg = 0;
> +
> +	sev_register_user_region(vm, region);
> +
> +	while (pg < (memory_size / vm->page_size)) {
> +		sparsebit_idx_t nr_pages;
> +
> +		if (sparsebit_is_clear(protected_phy_pages, pg)) {
> +			pg = sparsebit_next_set(protected_phy_pages, pg);
> +			if (!pg)
> +				break;
> +		}
> +
> +		nr_pages = sparsebit_next_clear(protected_phy_pages, pg) - pg;
> +		if (nr_pages <= 0)
> +			nr_pages = 1;

I think this may not be correct in the case where the sparsebit has the
range [x, 2**64-1] (inclusive) set. In that case, sparsebit_next_clear()
will return 0, but the number of pages could be more than 1.

> +
> +		sev_launch_update_data(vm, gpa_start + pg * vm->page_size,

Computing the beginning of the gpa range with

gpa_start + pg * vm->page_size

only works if this memory region's gpa_start is 0.

> +				       nr_pages * vm->page_size);
> +		pg += nr_pages;
> +	}
> +}

Here's a suggestion (I'm using this on a TDX version of this patch)


/**
  * Iterate over set ranges within sparsebit @s. In each iteration,
  * @range_begin and @range_end will take the beginning and end of the set  
range,
  * which are of type sparsebit_idx_t.
  *
  * For example, if the range [3, 7] (inclusive) is set, within the  
iteration,
  * @range_begin will take the value 3 and @range_end will take the value 7.
  *
  * Ensure that there is at least one bit set before using this macro with
  * sparsebit_any_set(), because sparsebit_first_set() will abort if none are
  * set.
  */
#define sparsebit_for_each_set_range(s, range_begin, range_end)		\
	for (range_begin = sparsebit_first_set(s),			\
		     range_end =					\
		     sparsebit_next_clear(s, range_begin) - 1;		\
	     range_begin && range_end;					\
	     range_begin = sparsebit_next_set(s, range_end),		\
		     range_end =					\
		     sparsebit_next_clear(s, range_begin) - 1)
/*
  * sparsebit_next_clear() can return 0 if [x, 2**64-1] are all set, and the  
-1
  * would then cause an underflow back to 2**64 - 1. This is expected and
  * correct.
  *
  * If the last range in the sparsebit is [x, y] and we try to iterate,
  * sparsebit_next_set() will return 0, and sparsebit_next_clear() will try  
and
  * find the first range, but that's correct because the condition expression
  * would cause us to quit the loop.
  */


static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region  
*region)
{
	const struct sparsebit *protected_phy_pages =
		region->protected_phy_pages;
	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;

	sparsebit_idx_t i;
	sparsebit_idx_t j;

	if (!sparsebit_any_set(protected_phy_pages))
		return;

	sev_register_user_region(vm, region);

	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
		const uint64_t size_to_load = (j - i + 1) * vm->page_size;
		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
		const uint64_t gpa = gpa_base + offset;

		sev_launch_update_data(vm, gpa, size_to_load);
	}
}
