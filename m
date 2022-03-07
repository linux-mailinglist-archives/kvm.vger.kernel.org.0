Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC164CF0E2
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 06:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiCGFXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 00:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbiCGFXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 00:23:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25E805E17F
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 21:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646630528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kIThXwRRrbwGAgS6X4NoXOQQVM2y3LkIWTD+Y9xtfwE=;
        b=D1JwnN5KJ/2zCNOM0iN9y5VtA7fG4sk79dDRr4qazJMs08gksnBhbJTM5b6zI1je8pw0Lf
        IHV2PNN5eUNvZUJ1kxF5PosE7/xIZbDvuL6891VQJCc8gIOhkDxuaKD8qyYuyFGasGtjHk
        Yj5HasiGkSsiLmfromN58VZN2J5PeYE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-aONDFO-CNOSC505LnJWhFA-1; Mon, 07 Mar 2022 00:22:06 -0500
X-MC-Unique: aONDFO-CNOSC505LnJWhFA-1
Received: by mail-pj1-f70.google.com with SMTP id c7-20020a17090a674700b001beef0afd32so5507277pjm.2
        for <kvm@vger.kernel.org>; Sun, 06 Mar 2022 21:22:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kIThXwRRrbwGAgS6X4NoXOQQVM2y3LkIWTD+Y9xtfwE=;
        b=c16z9URRSsMGQLi+Vhfa9h7la43kCXSh7zm5hmRmte9N7ZDwAMgAIawvJM5LcF1Q4W
         H2Tj8NvA/qhKqQmVKC1xqxeYp9PiHa/nfyTKrMexuvRrTHhndHzTz2MU0z2gWMXWSuFS
         rSktmuFmsiseWKiNntxMH84pplAqlC+LI8MlcriasZCdU7eMTNUiZ+9HebnwUV0H2ydc
         Hp+A8mA1FOiPGUvHmQMDBGmFJ5pLVljs0GkeQHtQXnHPJWioExLv1EN0wD2LzdjHKqUO
         XT1jDV59rYlbIh8xh1Z+qNsc5UEPApEStFTsdDMGoVzI/h/vaHngTd4IVHqwQFKzXlsa
         jbww==
X-Gm-Message-State: AOAM532vkNQts1OE0P7MQpy/Y7LM0bU4sJ0txmrB+Y2UwQlLTPWnRM8p
        xJRpqKxt1usX9+hMvD6UAnVo0zK5ejnJYD9Fzr+yR5SpSrgBAyx/ttNmC2wOHKES2rIraHNPn6k
        4IbEzTDCMQgVj
X-Received: by 2002:a65:604a:0:b0:375:5cc8:7458 with SMTP id a10-20020a65604a000000b003755cc87458mr8647818pgp.205.1646630524078;
        Sun, 06 Mar 2022 21:22:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwXR9z1AcmBQmiArrH1KMtu8XlcFColbf6EdtzeDu1/rRwNprlfzpM6wlLuEQ0+4JeA96z8w==
X-Received: by 2002:a65:604a:0:b0:375:5cc8:7458 with SMTP id a10-20020a65604a000000b003755cc87458mr8647802pgp.205.1646630523753;
        Sun, 06 Mar 2022 21:22:03 -0800 (PST)
Received: from xz-m1.local ([94.177.118.47])
        by smtp.gmail.com with ESMTPSA id d25-20020a639919000000b00364f999aed5sm10326594pge.20.2022.03.06.21.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 21:22:03 -0800 (PST)
Date:   Mon, 7 Mar 2022 13:21:57 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 00/23] Extend Eager Page Splitting to the shadow MMU
Message-ID: <YiWWdekvbPjI/WZm@xz-m1.local>
References: <20220203010051.2813563-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, David,

Sorry for a very late comment.

On Thu, Feb 03, 2022 at 01:00:28AM +0000, David Matlack wrote:
> Performance
> -----------
> 
> Eager page splitting moves the cost of splitting huge pages off of the
> vCPU thread and onto the thread invoking VM-ioctls to configure dirty
> logging. This is useful because:
> 
>  - Splitting on the vCPU thread interrupts vCPUs execution and is
>    disruptive to customers whereas splitting on VM ioctl threads can
>    run in parallel with vCPU execution.
> 
>  - Splitting on the VM ioctl thread is more efficient because it does
>    no require performing VM-exit handling and page table walks for every
>    4K page.
> 
> To measure the performance impact of Eager Page Splitting I ran
> dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
> vCPU, and backed by 1GiB HugeTLB memory.
> 
> To measure the imapct of customer performance, we can look at the time
> it takes all vCPUs to dirty memory after dirty logging has been enabled.
> Without Eager Page Splitting enabled, such dirtying must take faults to
> split huge pages and bottleneck on the MMU lock.
> 
>              | "Iteration 1 dirty memory time"             |
>              | ------------------------------------------- |
> vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> ------------ | -------------------- | -------------------- |
> 2            | 0.310786549s         | 0.058731929s         |
> 4            | 0.419165587s         | 0.059615316s         |
> 8            | 1.061233860s         | 0.060945457s         |
> 16           | 2.852955595s         | 0.067069980s         |
> 32           | 7.032750509s         | 0.078623606s         |
> 64           | 16.501287504s        | 0.083914116s         |
> 
> Eager Page Splitting does increase the time it takes to enable dirty
> logging when not using initially-all-set, since that's when KVM splits
> huge pages. However, this runs in parallel with vCPU execution and does
> not bottleneck on the MMU lock.
> 
>              | "Enabling dirty logging time"               |
>              | ------------------------------------------- |
> vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> ------------ | -------------------- | -------------------- |
> 2            | 0.001581619s         |  0.025699730s        |
> 4            | 0.003138664s         |  0.051510208s        |
> 8            | 0.006247177s         |  0.102960379s        |
> 16           | 0.012603892s         |  0.206949435s        |
> 32           | 0.026428036s         |  0.435855597s        |
> 64           | 0.103826796s         |  1.199686530s        |
> 
> Similarly, Eager Page Splitting increases the time it takes to clear the
> dirty log for when using initially-all-set. The first time userspace
> clears the dirty log, KVM will split huge pages:
> 
>              | "Iteration 1 clear dirty log time"          |
>              | ------------------------------------------- |
> vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> ------------ | -------------------- | -------------------- |
> 2            | 0.001544730s         | 0.055327916s         |
> 4            | 0.003145920s         | 0.111887354s         |
> 8            | 0.006306964s         | 0.223920530s         |
> 16           | 0.012681628s         | 0.447849488s         |
> 32           | 0.026827560s         | 0.943874520s         |
> 64           | 0.090461490s         | 2.664388025s         |
> 
> Subsequent calls to clear the dirty log incur almost no additional cost
> since KVM can very quickly determine there are no more huge pages to
> split via the RMAP. This is unlike the TDP MMU which must re-traverse
> the entire page table to check for huge pages.
> 
>              | "Iteration 2 clear dirty log time"          |
>              | ------------------------------------------- |
> vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> ------------ | -------------------- | -------------------- |
> 2            | 0.015613726s         | 0.015771982s         |
> 4            | 0.031456620s         | 0.031911594s         |
> 8            | 0.063341572s         | 0.063837403s         |
> 16           | 0.128409332s         | 0.127484064s         |
> 32           | 0.255635696s         | 0.268837996s         |
> 64           | 0.695572818s         | 0.700420727s         |

Are all the tests above with ept=Y (except the one below)?

> 
> Eager Page Splitting also improves the performance for shadow paging
> configurations, as measured with ept=N. Although the absolute gains are
> less since ept=N requires taking the MMU lock to track writes to 4KiB
> pages (i.e. no fast_page_fault() or PML), which dominates the dirty
> memory time.
> 
>              | "Iteration 1 dirty memory time"             |
>              | ------------------------------------------- |
> vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> ------------ | -------------------- | -------------------- |
> 2            | 0.373022770s         | 0.348926043s         |
> 4            | 0.563697483s         | 0.453022037s         |
> 8            | 1.588492808s         | 1.524962010s         |
> 16           | 3.988934732s         | 3.369129917s         |
> 32           | 9.470333115s         | 8.292953856s         |
> 64           | 20.086419186s        | 18.531840021s        |

This one is definitely for ept=N because it's written there. That's ~10%
performance increase which looks still good, but IMHO that increase is
"debatable" since a normal guest may not simply write over the whole guest
mem.. So that 10% increase is based on some assumptions.

What if the guest writes 80% and reads 20%?  IIUC the split thread will
also start to block the readers too for shadow mmu while it was not blocked
previusly?  From that pov, not sure whether the series needs some more
justification, as the changeset seems still large.

Is there other benefits besides the 10% increase on writes?

Thanks,

-- 
Peter Xu

