Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E741D647AB1
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 01:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLIAVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 19:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLIAVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 19:21:22 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580AA92310
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 16:21:21 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 65so2554769pfx.9
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 16:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxo/Qa2g2l5VwByXQSAcUiX+7JZ8E7yRjzkXLItllwk=;
        b=qKjtkIGolnxH4WQLk5BeM6RGyuoRDEz1A5QgTyVPsR8QSZFl27gYnjBlvXDkAHSyOW
         MZx2qfFtLT5e6aTghd4D4gmW9bu4t6a+LFmw9TFol6K3x7RNjy7Aji2UTGul7jwIHz3n
         +PaZjIntMEGywi09J51pTA3N8FuaiT9KVh3L3OBRvMDNSq2q7Y7k7I6GiCH8A/CcG4ta
         /GonOItmYjyNbpzRPeCl3MwDufk9IkaDhFJ+QF+3AWT11lhtinv4uJGpMSLiZQiYMwUU
         0uO3LXJpHil3u2bxOmoTR7zLRqlVddn9Mh2Ja6hMiMwpxu9SWFKem7EsuywtvfIOEmGA
         05Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxo/Qa2g2l5VwByXQSAcUiX+7JZ8E7yRjzkXLItllwk=;
        b=24yJYc/ADslBppkcMHFGnvxGinEg5LCx4y42UgpL94Cu3c8AAMQGRSqVtESZy8gVna
         EHGfT/x5LTtTyqdn3fHLbm4QZpLtJDcf6FGkC90FNZwyAosr8gcUug2IIzPoS7IiMlRu
         tBJlyKrWtCS3ylT11ZVeFz5Cf3oChR4Ep0jcBizqYpL45ShZxouk06bKe4do+YnH07m6
         +o6gXBMcIeKmudP250xmx64AN5RQRw9XD6ohJWsqaOX0A3/8xlMJJ6BBZGf2UKnWeXCt
         PSspb1g/UZ2m/lo9NMzrLOx3Y1FtmNFAByoNozl357CzsWOKedoNHrLO+6/yEh8sPfFp
         SU8Q==
X-Gm-Message-State: ANoB5pl+FrUyb2Il28vlhboTPPAkrZzL6KVOjrI/oJs9YIShgr0zX2vA
        jxQeTuQCq2NobQTwBaZ/Yf76bw==
X-Google-Smtp-Source: AA0mqf7mO+Pqe5sMrWcrMy/uCytpp9lly4bvTEHXUxvTzALgNLSCAtBdL2QdSU48rL75mdDMtEsszg==
X-Received: by 2002:aa7:8656:0:b0:577:509d:df80 with SMTP id a22-20020aa78656000000b00577509ddf80mr4159355pfo.24.1670545280691;
        Thu, 08 Dec 2022 16:21:20 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00000c00b00575ecd1d301sm68162pfk.177.2022.12.08.16.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 16:21:20 -0800 (PST)
Date:   Thu, 8 Dec 2022 16:21:15 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     bgardon@google.com, seanjc@google.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 0/2] NUMA aware page table allocation
Message-ID: <Y5J/ewEmqaTef/EU@google.com>
References: <20221201195718.1409782-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201195718.1409782-1-vipinsh@google.com>
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

On Thu, Dec 01, 2022 at 11:57:16AM -0800, Vipin Sharma wrote:
> Hi,
> 
> This series improves page table accesses by allocating page tables on
> the same NUMA node where underlying physical page is present.
> 
> Currently page tables are allocated during page faults and page splits.
> In both instances page table location will depend on the current thread
> mempolicy. This can create suboptimal placement of page tables on NUMA
> node, for example, thread doing eager page split is on different NUMA
> node compared to page it is splitting.
> 
> Reviewers please provide suggestion to the following:
> 
> 1. Module parameter is true by default, which means this feature will
>    be enabled by default. Is this okay or should I set it to false?
> 
> 2. I haven't reduced KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE considering that
>    it might not be too much of an impact as only online nodes are filled
>    during topup phase and in many cases some of these nodes will never
>    be refilled again.  Please let me know if you want this to be
>    reduced.
> 
> 3. I have tried to keep everything in x86/mmu except for some changes in
>    virt/kvm/kvm_main.c. I used __weak function so that only x86/mmu will
>    see the change, other arch nothing will change. I hope this is the
>    right approach.
> 
> 4. I am not sure what is the right way to split patch 2. If you think
>    this is too big for a patch please let me know what would you prefer.

I agree it's too big. The split_shadow_page_cache changes can easily be
split into a separate commit.
