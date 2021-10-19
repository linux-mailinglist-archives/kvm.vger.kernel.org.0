Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66FE434247
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJSXuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 19:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhJSXug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 19:50:36 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C86C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 16:48:22 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id w10so20159167ilc.13
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 16:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LrGODUIDqDouE2CKW+dzXobr7rj4x9l2glmXVBWB2ME=;
        b=dXZbCS9GtLKUK3qxAoWwQlojNot7ERBDZV2JdTo+0jK3Zld8K1sudwXlf37cP0TuBb
         wxm9Kb80eEfW5t8LeDr4l2XDfS5KNedxHJLQsfYfFv2JYcR0GRfBB6T5z7OIdvD1eowy
         sL/xirdUon+lZqWwiTvZyGA7PKBytl158RCIxTo+bd8fUcHEeHWRYGILn3/YEA91+9KZ
         vu/J//7k5Yhq2ZmZny+8wA6QfNnA/MWq6dYfLE1PNkSjM1Ovt7KdFKp67tj22yukPAaS
         l9pAEMx77atocqry11Fvt8lmojPHToujzvyWxETW+kMme5O+L6VK4brZFn3+bvN7raAF
         J4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LrGODUIDqDouE2CKW+dzXobr7rj4x9l2glmXVBWB2ME=;
        b=aHUO9JltSgnkAb8myQJEAUQTCGlY2P5qfv5aXUFOe/5i6LDU+ihhPZT8++xeGcvmmR
         wXMs/td2LOyNqho1lDUV5YwXWRSSUV6H9FM/slhsvbOVExQ+bIXFq4iGTe8m+zivF9Ho
         DYfOaZ9rFTQmMqEYuIv0IvcS/E4avqCWGsIS8dB0xKue34PVuS6XZD+qqOFa6oaVusGl
         3nAbVg3Umns/bLgIi/t2KS/UODv9VGNQq2b+zVKQ/Wi+oEgDzjvN0USJ1jpUgM1T2XMp
         mewvGlS0Ucc7u0z7zQMDIZKOq2FrUzL+JjxvHahyosjavTNBR6kuo1frj9U5lB/0Cn/X
         I/uw==
X-Gm-Message-State: AOAM530jgGQ4ceMc2DM+TgKDwHthRkbkyF6uTHz2eTARfZWC6Pv2QcKE
        PtPx5TWq0ZkLTluAhDJI8jy6L1hUlMA9HcUBerp60A==
X-Google-Smtp-Source: ABdhPJzAl0Px7DvXV5dj0lMtIk2pjS5W3ps7Ys3xEtS6F8kmXQW0I4vpGnpzKGHULijG1B1TMg4CiEl3cH5dTX7kvuc=
X-Received: by 2002:a05:6e02:1847:: with SMTP id b7mr20461187ilv.129.1634687301596;
 Tue, 19 Oct 2021 16:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211019013953.116390-1-junaids@google.com>
In-Reply-To: <20211019013953.116390-1-junaids@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 19 Oct 2021 16:48:10 -0700
Message-ID: <CANgfPd8a3_snsbF7Y-McZMFx4xz4uwWLjXD3VTaKUBr1xnNTrg@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: x86: mmu: Make NX huge page recovery period configurable
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021 at 6:40 PM Junaid Shahid <junaids@google.com> wrote:
>
> v2:
>  - A configured period of 0 now automatically derives the actual period
>    from the ratio.
>
> Currently, the NX huge page recovery thread wakes up every minute and
> zaps 1/nx_huge_pages_recovery_ratio of the total number of split NX
> huge pages at a time. This is intended to ensure that only a
> relatively small number of pages get zapped at a time. But for very
> large VMs (or more specifically, VMs with a large number of
> executable pages), a period of 1 minute could still result in this
> number being too high (unless the ratio is changed significantly,
> but that can result in split pages lingering on for too long).
>
> This change makes the period configurable instead of fixing it at
> 1 minute. Users of large VMs can then adjust the period and/or the
> ratio to reduce the number of pages zapped at one time while still
> maintaining the same overall duration for cycling through the
> entire list. By default, KVM derives a period from the ratio such
> that the entire list can be zapped in 1 hour.
>
> Signed-off-by: Junaid Shahid <junaids@google.com>
> ---
>  .../admin-guide/kernel-parameters.txt         | 10 +++++-
>  arch/x86/kvm/mmu/mmu.c                        | 33 +++++++++++++------
>  2 files changed, 32 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 91ba391f9b32..dd47336a525f 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2353,7 +2353,15 @@
>                         [KVM] Controls how many 4KiB pages are periodically zapped
>                         back to huge pages.  0 disables the recovery, otherwise if
>                         the value is N KVM will zap 1/Nth of the 4KiB pages every
> -                       minute.  The default is 60.
> +                       period (see below).  The default is 60.
> +
> +       kvm.nx_huge_pages_recovery_period_ms=
> +                       [KVM] Controls the time period at which KVM zaps 4KiB pages
> +                       back to huge pages. If the value is a non-zero N, KVM will
> +                       zap a portion (see ratio above) of the pages every N msecs.
> +                       If the value is 0 (the default), KVM will pick a period based
> +                       on the ratio such that the entire set of pages can be zapped
> +                       in approximately 1 hour on average.
>
>         kvm-amd.nested= [KVM,AMD] Allow nested virtualization in KVM/SVM.
>                         Default is 1 (enabled)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 24a9f4c3f5e7..273b43272c4d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -58,6 +58,7 @@
>  extern bool itlb_multihit_kvm_mitigation;
>
>  int __read_mostly nx_huge_pages = -1;
> +static uint __read_mostly nx_huge_pages_recovery_period_ms;
>  #ifdef CONFIG_PREEMPT_RT
>  /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
>  static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
> @@ -66,23 +67,26 @@ static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
>  #endif
>
>  static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
> -static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp);
> +static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp);
>
>  static const struct kernel_param_ops nx_huge_pages_ops = {
>         .set = set_nx_huge_pages,
>         .get = param_get_bool,
>  };
>
> -static const struct kernel_param_ops nx_huge_pages_recovery_ratio_ops = {
> -       .set = set_nx_huge_pages_recovery_ratio,
> +static const struct kernel_param_ops nx_huge_pages_recovery_param_ops = {
> +       .set = set_nx_huge_pages_recovery_param,
>         .get = param_get_uint,
>  };
>
>  module_param_cb(nx_huge_pages, &nx_huge_pages_ops, &nx_huge_pages, 0644);
>  __MODULE_PARM_TYPE(nx_huge_pages, "bool");
> -module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_ratio_ops,
> +module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_param_ops,
>                 &nx_huge_pages_recovery_ratio, 0644);
>  __MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
> +module_param_cb(nx_huge_pages_recovery_period_ms, &nx_huge_pages_recovery_param_ops,
> +               &nx_huge_pages_recovery_period_ms, 0644);
> +__MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
>
>  static bool __read_mostly force_flush_and_sync_on_reuse;
>  module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
> @@ -6088,18 +6092,21 @@ void kvm_mmu_module_exit(void)
>         mmu_audit_disable();
>  }
>
> -static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
> +static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
>  {
> -       unsigned int old_val;
> +       bool was_recovery_enabled, is_recovery_enabled;
>         int err;
>
> -       old_val = nx_huge_pages_recovery_ratio;
> +       was_recovery_enabled = nx_huge_pages_recovery_ratio;
> +
>         err = param_set_uint(val, kp);
>         if (err)
>                 return err;
>
> +       is_recovery_enabled = nx_huge_pages_recovery_ratio;
> +
>         if (READ_ONCE(nx_huge_pages) &&
> -           !old_val && nx_huge_pages_recovery_ratio) {
> +           !was_recovery_enabled && is_recovery_enabled) {
>                 struct kvm *kvm;
>
>                 mutex_lock(&kvm_lock);

I might be missing something, but it seems like setting
nx_huge_pages_recovery_period_ms through this function won't do
anything special. Is there any reason to use this function for it
versus param_set_uint?

> @@ -6162,8 +6169,14 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>
>  static long get_nx_lpage_recovery_timeout(u64 start_time)
>  {
> -       return READ_ONCE(nx_huge_pages) && READ_ONCE(nx_huge_pages_recovery_ratio)
> -               ? start_time + 60 * HZ - get_jiffies_64()
> +       uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> +       uint period = READ_ONCE(nx_huge_pages_recovery_period_ms);
> +
> +       if (!period && ratio)
> +               period = 60 * 60 * 1000 / ratio;
> +
> +       return READ_ONCE(nx_huge_pages) && ratio
> +               ? start_time + msecs_to_jiffies(period) - get_jiffies_64()
>                 : MAX_SCHEDULE_TIMEOUT;
>  }
>
> --
> 2.33.0.1079.g6e70778dc9-goog
>
