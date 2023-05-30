Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D85716FEC
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 23:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbjE3Voo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 17:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbjE3Von (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 17:44:43 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84349C7
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 14:44:42 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d280c3a89so5747901b3a.0
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 14:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685483082; x=1688075082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gllGKsW6EGZXrfCcY2RdUJbcNCKzFTs597NLojSvrvI=;
        b=YB21CRWLPbjctiVhKFr/qkUBgxJuoKPSp9aosRn38iTlwGDonkS0O/Z/efZVwH0eaI
         gW8phHmjr+GiJQZ8ewOsEijJkAOs9fcAFR0JoSwPuyfZuY6kI1nH3o+WdiRmkotLzm7E
         VZj947GiWEycCEkfzX1DoTNI5bwouXLx3YLqamJ3Dkj61BAHyfpA/tOra1Ct40WXkm9G
         jl3qNPsprl6wnx/eXDRLVpYH+IDiUfLK/D7yK7Ap9j8KODZ9WXVjJyx/h7sUYiXzddIq
         CdjwHdDutN+q6h1txM5nGCYa6MW6xx8HDPXIMKAyDiiuBMFOJ2Jc66k5rVxLkpQpsO//
         p5Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685483082; x=1688075082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gllGKsW6EGZXrfCcY2RdUJbcNCKzFTs597NLojSvrvI=;
        b=DUsdZdUtI6vWZflqfkmzujSvaz5k30IGcSe9bh/8Q7Rvm195RVGX/lzRIpRoqqK0Jj
         gkwa7NJvlQgZpTpMfJI4YWq75P2JdYTnkQrK3RPZAqlniJtY+YuTtQLN1IGIpoIc4gvA
         wc9aVZiBJj5eGfNNLt9FktIjJ75oAxVsbuWkhgXtUbKmqQf/nEukQ38U70MhfCiSKeEl
         xY/nhWvIKAUzhWljkAeK9GekfhO0AhKSN028K8YCGZWma2olYXhnDBeBoUMlvP2CJ0ky
         RDjn3Y7rJ72FDH7AAMmy0zxN8E+lPDejAXyE7c9pxjQ6NhxW5d3NiejzNYT6E7PQwN0+
         86TA==
X-Gm-Message-State: AC+VfDxB0hkPd+o9wa5DWEKce9dtFzdbd+WGiTWqj48sMK9gL76Vj8HY
        /X6B2cGpLElNZdj++J78mjwLofjcqzo=
X-Google-Smtp-Source: ACHHUZ5d+yPelHfD9nH7zTboFYLRXWmOGbgt1EDhXbPu0aPAY8uJr08Pgxaff9F0pxr9tOTbGa5MVHoeIPM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1399:b0:647:1eaf:9577 with SMTP id
 t25-20020a056a00139900b006471eaf9577mr1326642pfg.1.1685483082042; Tue, 30 May
 2023 14:44:42 -0700 (PDT)
Date:   Tue, 30 May 2023 14:44:40 -0700
In-Reply-To: <ZHYCygONW53/Byp3@nvidia.com>
Mime-Version: 1.0
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com> <87pm6ii6qi.fsf@nvidia.com> <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com> <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com> <ZHYCygONW53/Byp3@nvidia.com>
Message-ID: <ZHZuSDp6ioPqI272@google.com>
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Jason Gunthorpe wrote:
> IMHO I think we messed this up at some point..
> 
> Joerg added invalidate_range just for the iommu to use, so having it
> be arch specific could make some sense.
> 
> However, KVM later co-opted it to do this:
> 
> commit e649b3f0188f8fd34dd0dde8d43fd3312b902fb2
> Author: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> Date:   Sat Jun 6 13:26:27 2020 +0900
> 
>     KVM: x86: Fix APIC page invalidation race

...

>     The fix therefore is to reload the APIC-access page field in the VMCS
>     from kvm_mmu_notifier_invalidate_range() instead of ..._range_start().
> 
> Which I think is a hacky fix.

Agreed, though as you note below, the invalidate_range() description does make it
seem like a somewhat reasonable thing to do. 

> KVM already has locking for invalidate_start/end - it has to check
> mmu_notifier_retry_cache() with the sequence numbers/etc around when
> it does does hva_to_pfn()
> 
> The bug is that the kvm_vcpu_reload_apic_access_page() path is
> ignoring this locking so it ignores in-progress range
> invalidations. It should spin until the invalidation clears like other
> places in KVM.
> 
> The comment is kind of misleading because drivers shouldn't be abusing
> the iommu centric invalidate_range() thing to fix missing locking in
> start/end users. :\
> 
> So if KVM could be fixed up we could make invalidate_range defined to
> be an arch specific callback to synchronize the iommu TLB.

And maybe rename invalidate_range() and/or invalidate_range_{start,end}() to make
it super obvious that they are intended for two different purposes?  E.g. instead
of invalidate_range(), something like invalidate_secondary_tlbs().

FWIW, PPC's OpenCAPI support (drivers/misc/ocxl/link.c) also uses invalidate_range().
Though IIUC, the use case is the same as a "traditional" IOMMU, where a device can
share the CPU's page tables, so maybe the devices can be considered IOMMUs in practice,
if not in name?

  It allows an accelerator (which could be an FPGA, ASICs, ...) to access
  the host memory coherently, using virtual addresses. An OpenCAPI
  device can also host its own memory, that can be accessed from the
  host.

> Sean?

It's doable, though definitely not 6.4 material.  

I have patches coded up.  Assuming testing goes well, I'll post them regardless
of the OCXL side of things.  I've disliked KVM's one-off use of invalidate_range()
for a long time, this is a good excuse to get rid of it before KVM gains more usage.
