Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805D56B32F6
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 01:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCJA4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 19:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjCJA4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 19:56:12 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EFEFA8E6
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 16:56:03 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id ce7so2665726pfb.9
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 16:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678409763;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0kkspEbZEZODss7I79B81pms6JUpvvYXQ/aQnNzr8OM=;
        b=LTIT81GL7apINIbESfLtE5tv3ICnJvaUZ5XaovqNJOZTZoRTmIJ3m20hnFpazeCh1Q
         F0opPGgNKlnMlCZSdJYIr8oKLf0tNJncOM0UkVFpbm0k33DiHxTngv5Ri6YqEpc5dZA+
         KXRY5+5BxI/igIkhbZsCIT6OFYB6EduOHCh8UWUw5eItCarj1ljEQavzOqph9hGo7CLK
         HtqPwIFEE25covgQg5E59cXcb+9PAlXXhRgDW7WIUzURDpfYWDVCquRlM0t8cWBofVDX
         zMSTM+u4SP4fGHrQhtpOKkHVsWQiVArICtOw60cj9wZnof3OT5inp5z4deKIB3i6Xdtz
         t6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678409763;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0kkspEbZEZODss7I79B81pms6JUpvvYXQ/aQnNzr8OM=;
        b=3ZrGgYkeMnTLhA+R4qTl5/LHujT2sjS5OPvk3WoFKvZY8KnHIgDNwDVMk8zX5P9B5D
         wegNYiWSVFOl+4XoqWZqiG7puQqm7EDi7Fa0PDYtABtPdpIGg9Sd2i6ek+wCEh5bNZNh
         goNlNv5ZO0GJu2SMbXfkOEHY5MA3EpiYmWmDm5g31fvujNe5B8xc1wQJ9taCAfsw9/L7
         scKU9119U+nYDz/wUJERA7F9i8RjUbjIv6jPC8dQdamRVWTjpqNaLRp3l++7EdU+h8+k
         x11f/nsMmeBauxhIl21BYL90iT8R4a9vB+GFgSjGfIDte2CZwHtMgICvqZJkvDbBQCjj
         SPJQ==
X-Gm-Message-State: AO0yUKV4oeBn5gCtbK6wnnJ5MqdOCjpauj9EY3hyGuTch7afAENhj2Sf
        boHejh4b7yYdIM0fWECyT7df+Q==
X-Google-Smtp-Source: AK7set9DwuNdqc8mVCX3g4wsvx5F11+p8Uqv+KdNRUFNuvlWAplhbqMb2zW0vs4vGChtEBlh98IY6Q==
X-Received: by 2002:aa7:9405:0:b0:5aa:4df7:7ef6 with SMTP id x5-20020aa79405000000b005aa4df77ef6mr21287884pfo.7.1678409762556;
        Thu, 09 Mar 2023 16:56:02 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id z5-20020aa791c5000000b005a909290425sm168638pfa.172.2023.03.09.16.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 16:56:01 -0800 (PST)
Date:   Thu, 9 Mar 2023 16:55:58 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
Message-ID: <ZAqAHiaCz0b2OKJF@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-4-vipinsh@google.com>
 <ZApxh/GYfqev7sHA@google.com>
 <CAHVum0eQzmLXDxMy3+LpmGxVU7YsT1wRNYkFq9o7sfR2uNK-xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHVum0eQzmLXDxMy3+LpmGxVU7YsT1wRNYkFq9o7sfR2uNK-xA@mail.gmail.com>
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

On Thu, Mar 09, 2023 at 04:28:10PM -0800, Vipin Sharma wrote:
> On Thu, Mar 9, 2023 at 3:53 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Mon, Mar 06, 2023 at 02:41:12PM -0800, Vipin Sharma wrote:
> > > Create a global counter for total number of pages available
> > > in MMU page caches across all VMs. Add mmu_shadow_page_cache
> > > pages to this counter.
> >
> > I think I prefer counting the objects on-demand in mmu_shrink_count(),
> > instead of keeping track of the count. Keeping track of the count adds
> > complexity to the topup/alloc paths for the sole benefit of the
> > shrinker. I'd rather contain that complexity to the shrinker code unless
> > there is a compelling reason to optimize mmu_shrink_count().
> >
> > IIRC we discussed this at one point. Was there a reason to take this
> > approach that I'm just forgetting?
> 
> To count on demand, we first need to lock on kvm_lock and then for
> each VMs iterate through each vCPU, take a lock, and sum the objects
> count in caches. When the NUMA support will be introduced in this
> series then it means we have to iterate even more caches. We
> can't/shouldn't use mutex_trylock() as it will not give the correct
> picture and when shrink_scan is called count can be totally different.

Yeah good point. Hm, do we need to take the cache mutex to calculate the
count though? mmu_shrink_count() is inherently racy (something could get
freed or allocated in between count() and scan()). I don't think holding
the mutex buys us anything over just reading the count without the
mutex.

e.g.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index df8dcb7e5de7..c80a5c52f0ea 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6739,10 +6739,20 @@ static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 static unsigned long mmu_shrink_count(struct shrinker *shrink,
                                      struct shrink_control *sc)
 {
-       s64 count = percpu_counter_sum(&kvm_total_unused_cached_pages);
+       struct kvm *kvm, *next_kvm;
+       unsigned long count = 0;

-       WARN_ON(count < 0);
-       return count <= 0 ? SHRINK_EMPTY : count;
+       mutex_lock(&kvm_lock);
+       list_for_each_entry_safe(kvm, next_kvm, &vm_list, vm_list) {
+               struct kvm_vcpu *vcpu;
+               unsigned long i;
+
+               kvm_for_each_vcpu(i, vcpu, kvm)
+                       count += READ_ONCE(vcpu->arch.mmu_shadow_page_cache.nobjs);
+       }
+       mutex_unlock(&kvm_lock);
+
+       return count == 0 ? SHRINK_EMPTY : count;

 }

Then the only concern is an additional acquire of kvm_lock. But it
should be fairly quick (quicker than mmu_shrink_scan()). If we can
tolerate the kvm_lock overhead of mmu_shrink_scan(), then we should be
able to tolerate some here.

> 
> scan_count() API comment says to not do any deadlock check (I don't
> know what does that mean) and percpu_counter is very fast when we are
> adding/subtracting pages so the effect of using it to keep global
> count is very minimal. Since, there is not much impact to using
> percpu_count compared to previous one, we ended our discussion with
> keeping this per cpu counter.

Yeah it's just the code complexity of maintaing
kvm_total_unused_cached_pages that I'm hoping to avoid. We have to
create the counter, destroy it, and keep it up to date. Some
kvm_mmu_memory_caches have to update the counter, and others don't. It's
just adds a lot of bookkeeping code that I'm not convinced is worth the
it.
