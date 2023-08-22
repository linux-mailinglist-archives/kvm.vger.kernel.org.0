Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC139784D3E
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 01:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjHVXR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 19:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjHVXR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 19:17:27 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ED3E42
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 16:17:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-563ab574cb5so5405763a12.1
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 16:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692746245; x=1693351045;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFwVY5f5dTBaMzDscxqMGNrjI0xrE58qgkFcYAhYpMc=;
        b=75CU7MMPm59DuVURW4I5Awl+gGVby465miL42+4YWEZODWWEL1GIFpxXTJekpZnNnl
         N2+UnX2W4vOlRH75+HBCFSmi5KGyPUK+mTvBnhZwlFmzX9cCvSTIE7ZL1eAz9khnzhtP
         rknG3bjV6rcHOM9m2TBB2RUQgzFIUj/yrDi0u9in7pP+Djas/sZ1r/Eb7aIR9uP5sx0B
         hKeT31r+ZeTT5KpzX3mpjuNkpOeSLI6FVVRN8X1Q8PjrcDEOIGp6x27azlCmYj9H+sBZ
         V4N/le27vTaBzt7aJ4R4VYM2mXzinjZXff2aSp37hu/O48S1EavfVsSROouHe2adoqLg
         7g2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692746245; x=1693351045;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFwVY5f5dTBaMzDscxqMGNrjI0xrE58qgkFcYAhYpMc=;
        b=JFe7F8BYvlLjvqHrFvqkDgY2tDFs1tg8/yN3G5SbaZ19o0EoCaMeOIq902NYugZ098
         w4LkzydrAqfCgi/N50eLrnyYJ57Oc6JYY3qe/2JmcCsZUtsWC7NV7Y8PV6Evl3juFCuf
         LKeLZHqordZ8FyNHz1LIUPOza6g4cSU2VqR48r8GCSFhD2kDrO5drPj2oimfZq7LvtGl
         Wwq9qVKJb5IHYhQ57VC/vhBfCqlDjinmI3y3zRGi7eA6ayd9Gycn0VCBlN9+f105VJIZ
         nU6QUpBXEOkHoxRHTe3NA8yjsrEePku1RLkXyrz5trgzhge9/T7awIEVlk0v7sMG+2lM
         8xJA==
X-Gm-Message-State: AOJu0YzYTwkm5BTvN+cBJYkR+K8FqatHAa3srKscNnrNBL7YaI3y2dYk
        Ma4JXroprHK25Vzv5Tov7jgGMI0wurg=
X-Google-Smtp-Source: AGHT+IH25EflXFYRsSAIONlQdF4yEYShAZMjZEb7bXaRk6krlSYytMpTmCeiKJi71iN2KbTqlbAvt/EfaUY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fb03:b0:1bb:8c42:79f4 with SMTP id
 le3-20020a170902fb0300b001bb8c4279f4mr4246479plb.2.1692746245174; Tue, 22 Aug
 2023 16:17:25 -0700 (PDT)
Date:   Tue, 22 Aug 2023 16:17:23 -0700
In-Reply-To: <df49bbb2-92c0-7792-ab90-e748be570b5d@amd.com>
Mime-Version: 1.0
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
 <ZN+whX3/lSBcZKUj@google.com> <52c6a8a6-3a0a-83ba-173d-0833e16b64fd@amd.com>
 <ZN/0aefp2gw5wDXk@google.com> <CAL715WL9TJzDxZE8_gfhUQFGtOAydG0kyuSbzkqWTs3pc57j7A@mail.gmail.com>
 <df49bbb2-92c0-7792-ab90-e748be570b5d@amd.com>
Message-ID: <ZOVCAweRM8Es6rJ4@google.com>
Subject: Re: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Mingwei Zhang <mizhang@google.com>, Jacky Li <jackyli@google.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023, Ashish Kalra wrote:
> Hello Mingwei & Sean,
> 
> On 8/18/2023 9:08 PM, Mingwei Zhang wrote:
> The maximum hits are seen with shmem_fallocate and madvise, which we believe
> are response to shared<->private
> GHCB page-state-chage requests. discard=both handles discard both for
> private and shared memory, so freeing shared memory
> via fallocate(shared_memfd, FALLOC_FL_PUNCH_HOLE, ...) would trigger the
> notifiers when freeing shared pages after guest converts a GPA to
> private.
> 
> Now, as with SNP+guest_memfd, guest private memory is not mapped in host
> anymore, so i added a generic fix (instead of Sean's proposed patch of
> checking for SNP guest inside sev_guest_memory_reclaimed()):
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -593,6 +593,9 @@ static __always_inline int __kvm_handle_hva_range(struct
> kvm *kvm,
>                         unsigned long hva_start, hva_end;
> 
>                         slot = container_of(node, struct kvm_memory_slot,
> hva_node[slots->node_idx]);
> +                       if (kvm_slot_can_be_private(slot)) {
> +                               continue;
> +                       }
>                         hva_start = max(range->start, slot->userspace_addr);
>                         hva_end = min(range->end, slot->userspace_addr +
>                                                   (slot->npages <<
> PAGE_SHIFT));

...

> As expected, the SEV hook is not invoked for the guest private memory pages
> (no more invalidation from shmem_fallocate() + madvise()).
> 
> Isn't it better to skip invoking the KVM MMU invalidation notifier when the
> invalidated range belongs to guest private memory ?

Oooh, you're running into problems where KVM blasts both the private and shared
mappings even though invalidations from the mmu_notifier are shared-only by
definition.

The answer is "yes", but simply skipping slots that _can_ be private is wrong,
as KVM still needs to zap any shared mappings.  I have a plan[*], but I completely
spaced on incorporating the idea into the gmem RFC.  I'll add that to the "list
of todos for merging gmem", which I need to get sent out asap.

https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com

> > In fact, AFAIC, SNP VM does not track whether each page is previously
> > shared, isn't it? If a page was previously shared and was written by the
> > host kernel or devices before it was changed to private. No one tracks it
> > and dirty caches are there!
> 
> The skipped invalidation here covered the case Mingwei mentioned above,
> where the pages are changed from private->shared and subsequent freeing of
> shared pages triggered the invalidation.
> 
> But, then why are we concerned about this, i thought we have concerns about
> the case where the dirty cache lines contain encrypted guest data ?

Yes, that's my understanding as well (assuming by "this" you mean the case where
the CPU cache has dirty lines for _shared_ addresses).
