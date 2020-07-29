Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C794C232548
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 21:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgG2TVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 15:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2TVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 15:21:19 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3849C061794
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 12:21:18 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id d14so23327882qke.13
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 12:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xf8y6+QE7u4z9tDYoWpKfnyILr6WJGhsLpbcNKIkelU=;
        b=n8so8KYJL7JTmU4FRh9v0OQdg1omhOYvRSE92qmDvKlITdi/LJg3OMvlrRg7KCISxw
         GDiEDm6vbZDm4z7zCnQ9gOZen6GBUgOVlhajnAsr/bMFrhTaaNfLHX6ukTqQc3u9ykaz
         vpfHcgO1dQPjfiB4BBf0JmXcZAONXwPrRp/fHP/7yMRdFvHzaxud620vIIfCJkM31y/u
         L9Vuw+e+5PV9CF1QdpRziQUdRphSv2XcZkdlItKQQib8zHIYmj31ZVVNPDcL7HUx1bYa
         D4ZPuZTk8pwt0T18C2F5ftoc4JBv5FbT7S2naq/vJtjg8z0HqS+SFgPElReYcxMN1Ewn
         bkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=xf8y6+QE7u4z9tDYoWpKfnyILr6WJGhsLpbcNKIkelU=;
        b=ZDrIvC5+e3CX7sVyz3gM28ciAQ1IRd9kLlsqg1ceCw2L9l5k4TpuXG+cE5DZu3iXP4
         5aEtJT6kqMFHwiSq1uEUdqayW4GABtfTskjDyPQY7BwKaDOfei08ExQeItL374qq6NPZ
         8vOSWmhyJbuxAijMXN671iecm06MqGbe6qmTuvx1ycohV5vK8xpmPUlb5aDBT7wJMLMG
         5APVrX6IN8Ieq9ulf2JavForU3DuXZYckKt8KrbeAlRmnIbehgnqwf4TKyiEPbmjSQkd
         x32ctyvDqwLD9x7Zsd6qLwdXmBDU9OfDfT4EMu0mTsa2hXjRYzD38qL7vWzQ9BzzGftr
         /lSw==
X-Gm-Message-State: AOAM533rXhp0HYGVV44ZL68z9//RdvmQGr4n11RAhiSou6rgOfuLXmtO
        3JQs5vJVppU+T1HGJ6tQjBbXvQ==
X-Google-Smtp-Source: ABdhPJztd8X9PkPqPBt+mePsOqrRf4zvhkmVEscAYT44kSObS9rUvpzOQV1mbjxPBgBiGbWIkNUOYg==
X-Received: by 2002:a37:b307:: with SMTP id c7mr35592806qkf.307.1596050477865;
        Wed, 29 Jul 2020 12:21:17 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id s128sm2212336qkd.108.2020.07.29.12.21.12
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 29 Jul 2020 12:21:16 -0700 (PDT)
Date:   Wed, 29 Jul 2020 12:21:11 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Pengfei Li <fly@kernel.page>
cc:     akpm@linux-foundation.org, bmt@zurich.ibm.com, dledford@redhat.com,
        willy@infradead.org, vbabka@suse.cz,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        alex.williamson@redhat.com, cohuck@redhat.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jglisse@redhat.com,
        jhubbard@nvidia.com, ldufour@linux.ibm.com,
        Liam.Howlett@oracle.com, peterz@infradead.org, cl@linux.com,
        jack@suse.cz, rientjes@google.com, walken@google.com,
        hughd@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm, util: account_locked_vm() does not hold
 mmap_lock
In-Reply-To: <20200726080224.205470-2-fly@kernel.page>
Message-ID: <alpine.LSU.2.11.2007291121280.4649@eggly.anvils>
References: <20200726080224.205470-1-fly@kernel.page> <20200726080224.205470-2-fly@kernel.page>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 Jul 2020, Pengfei Li wrote:

> Since mm->locked_vm is already an atomic counter, account_locked_vm()
> does not need to hold mmap_lock.

I am worried that this patch, already added to mmotm, along with its
1/2 making locked_vm an atomic64, might be rushed into v5.9 with just
that two-line commit description, and no discussion at all.

locked_vm belongs fundamentally to mm/mlock.c, and the lock to guard
it is mmap_lock; and mlock() has some complicated stuff to do under
that lock while it decides how to adjust locked_vm.

It is very easy to convert an unsigned long to an atomic64_t, but
"atomic read, check limit and do stuff, atomic add" does not give
the same guarantee as holding the right lock around it all.

(At the very least, __account_locked_vm() in 1/2 should be changed to
replace its atomic64_add by an atomic64_cmpxchg, to enforce the limit
that it just checked.  But that will be no more than lipstick on a pig,
when the right lock that everyone else agrees upon is not being held.)

Now, it can be argued that our locked_vm and pinned_vm maintenance
is so random and deficient, and too difficult to keep right across
a sprawl of drivers, that we should just be grateful for those that
do volunteer to subject themselves to RLIMIT_MEMLOCK limitation,
and never mind if it's a little racy.

And it may well be that all those who have made considerable efforts
in the past to improve the situation, have more interesting things to
devote their time to, and would prefer not to get dragged back here.

But let's at least give this a little more visibility, and hope
to hear opinions one way or the other from those who care.

Hugh

> 
> Signed-off-by: Pengfei Li <fly@kernel.page>
> ---
>  drivers/vfio/vfio_iommu_type1.c |  8 ++------
>  mm/util.c                       | 15 +++------------
>  2 files changed, 5 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 78013be07fe7..53818fce78a6 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -376,12 +376,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>  	if (!mm)
>  		return -ESRCH; /* process exited */
>  
> -	ret = mmap_write_lock_killable(mm);
> -	if (!ret) {
> -		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
> -					  dma->lock_cap);
> -		mmap_write_unlock(mm);
> -	}
> +	ret = __account_locked_vm(mm, abs(npage), npage > 0,
> +					dma->task, dma->lock_cap);
>  
>  	if (async)
>  		mmput(mm);
> diff --git a/mm/util.c b/mm/util.c
> index 473add0dc275..320fdd537aea 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -424,8 +424,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>   * @task:        task used to check RLIMIT_MEMLOCK
>   * @bypass_rlim: %true if checking RLIMIT_MEMLOCK should be skipped
>   *
> - * Assumes @task and @mm are valid (i.e. at least one reference on each), and
> - * that mmap_lock is held as writer.
> + * Assumes @task and @mm are valid (i.e. at least one reference on each).
>   *
>   * Return:
>   * * 0       on success
> @@ -437,8 +436,6 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
>  	unsigned long locked_vm, limit;
>  	int ret = 0;
>  
> -	mmap_assert_write_locked(mm);
> -
>  	locked_vm = atomic64_read(&mm->locked_vm);
>  	if (inc) {
>  		if (!bypass_rlim) {
> @@ -476,17 +473,11 @@ EXPORT_SYMBOL_GPL(__account_locked_vm);
>   */
>  int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc)
>  {
> -	int ret;
> -
>  	if (pages == 0 || !mm)
>  		return 0;
>  
> -	mmap_write_lock(mm);
> -	ret = __account_locked_vm(mm, pages, inc, current,
> -				  capable(CAP_IPC_LOCK));
> -	mmap_write_unlock(mm);
> -
> -	return ret;
> +	return __account_locked_vm(mm, pages, inc,
> +					current, capable(CAP_IPC_LOCK));
>  }
>  EXPORT_SYMBOL_GPL(account_locked_vm);
>  
> -- 
> 2.26.2
