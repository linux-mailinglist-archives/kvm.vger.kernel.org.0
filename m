Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8231C773BD4
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjHHP4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 11:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjHHPyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 11:54:24 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82C85586
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 08:43:32 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id ada2fe7eead31-44757af136cso2224924137.3
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 08:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691509397; x=1692114197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EnmQmxZbCd/pBw+aXS0zexuT786dNjoRNzkG/zy0ZEU=;
        b=ed00Tyi+DsuyxZz/9Ovzz4W8VenKCcmK4LTeRNqypg9CD47iLcHgxX+F/I0VRbz2hd
         cViTJWMczAA/XPts6tUGfe1Wj0VVnNmRiMxn85WQa996ZptdlCh4vM+0+JIuyE5AnTmQ
         KHrHm4UM61FbU6wR4Y1aa5bfXZoClF10PjrN3yu8AUcX1D4yj7jtCU7cnyoj+Izz8IZN
         O0Ri31jgprXw3i/kHH9iFs39yaLs+zJrRW1xcMBt2Y+zbmPe0R420LYN8qTWruM4Rgh+
         YIsVR+mt03tfutRdFfh7CrYYUULmi+E21ZtpuSSwf+320u2jeF0mWtqr/PXRv5e0sOVQ
         10Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691509397; x=1692114197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EnmQmxZbCd/pBw+aXS0zexuT786dNjoRNzkG/zy0ZEU=;
        b=NuUwWOjjmoN6DQCZkXP2OhD+89SWqAn4VxrHZBR5Oijm4cZL7mGhH2c65ojk6WV4rf
         STJoqpTRMmDY1cotbDk5jQ9Ah8TrlPX7r9PE4MtdjXYv/CYe0g1O2ElHgp+zTt08c8T0
         VQDAO3Vxm2f7DLqc3UUTkDx0CzIRJXWajWaXLiwDtiK/yfqppZ7tW48WExUg37sMW0LN
         0oHQDg9Ge10en/o7FvVyJOPqu2W3Yk/7GUEhu7uakyCRbVsb0q3d4zie737WRsRdqiC9
         UaZjLUXdrTkLl28VFZiWxXUaZnFg64LIxLNziDo9HDoDCXhWA1ql6iA1fkjRQQqoM64Z
         wmXg==
X-Gm-Message-State: AOJu0YxXjazl8bpnZPJ8QegPmg/t9zEV/jgsL63RbEjJMNiduH9LhuTy
        6T5TAix0EHn33yqpaUURgy9bjMsnDmD/4SAHiEhXOtcwjtOQ6A==
X-Google-Smtp-Source: AGHT+IHnXzaNilLUfq1UbnOnDU0JwyvRyWYT4cvWmbCBwLqHdRZ4EZnAxLhmPlEXpPqjfJb3dlqWi8UqJWb8RW2aip4=
X-Received: by 2002:a1f:c183:0:b0:471:1785:e838 with SMTP id
 r125-20020a1fc183000000b004711785e838mr254858vkf.2.1691508886283; Tue, 08 Aug
 2023 08:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
 <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com>
In-Reply-To: <ZMqX7TJavsx8WEY2@google.com>
From:   Amaan Cheval <amaan.cheval@gmail.com>
Date:   Tue, 8 Aug 2023 21:04:34 +0530
Message-ID: <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
Subject: Re: Deadlock due to EPT_VIOLATION
To:     Sean Christopherson <seanjc@google.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Sean,

> If NUMA balancing is going nuclear and constantly zapping PTEs, the resulting
> mmu_notifier events could theoretically stall a vCPU indefinitely.  The reason I
> dislike NUMA balancing is that it's all too easy to end up with subtle bugs
> and/or misconfigured setups where the NUMA balancing logic zaps PTEs/SPTEs without
> actuablly being able to move the page in the end, i.e. it's (IMO) too easy for
> NUMA balancing to get false positives when determining whether or not to try and
> migrate a page.

What are some situations where it might not be able to move the page in the end?

> That said, it's definitely very unexpected that NUMA balancing would be zapping
> SPTEs to the point where a vCPU can't make forward progress.   It's theoretically
> possible that that's what's happening, but quite unlikely, especially since it
> sounds like you're seeing issues even with NUMA balancing disabled.

Yep, we're definitely seeing the issue occur even with numa_balancing enabled,
but the likelihood of it occurring has significantly dropped since
we've disabled
numa_balancing.

> More likely is that there is a bug somewhere that results in the mmu_notifier
> event refcount staying incorrectly eleveated, but that type of bug shouldn't follow
> the VM across a live migration...

Good news! We managed to live migrate a guest and that did "fix it".

The console was locked-up on the login screen before migration for about 6.5
hours, looping EPT_VIOLATIONs.
Post migration, we saw `rcu_shed detected stalls on CPUs/tasks` on the console,
and then the VM resumed normal operation. Here's a screenshot of the console (it
was "locked up"/frozen on the login screen until the migration):

https://i.imgur.com/n6CSsAv.png

> [*] Not technically a full zap of the PTE, it's just marked PROT_NONE, i.e.
>     !PRESET, but on the KVM side of things it does manifest as a full zap of the
>     SPTE.

Thank you so much for that detailed explanation!

A colleague also modified a host kernel with KFI (Kernel Function
Instrumentation) and wrote a kernel module to intercept the vmexit handler,
handle_ept_violation, and does an EPT walk for each pfn, compared against
/proc/iomem.

Assuming the EPT walking code is correct, we see this surprising result of a
PDPTE's pfn=0:

```
[15295.792019] kvm-kfi: enter: handle_ept_violation
[15295.792021] kvm-kfi: ept walk: eptp=0x103aaa05e gpa=0x792d4ff8
[15295.792023]   PML4E : [0x103aaa05e] pfn=0x103aaa         : is
within the range: 0x100000-0x3fffffff: System RAM
[15295.792026]   PDPTE : [0x0] pfn=0x0         : is within the range:
0x0-0xfff: Reserved
[15295.792029]   PDE   : [0xf000eef3f000e2c3] pfn=0xeef3f000e [large]
: is within the range: 0x100000000-0x1075ffffff: System RAM
```

For comparison, the same module's output on a host without any "locked up"
guests:

```
[13956.578732] kvm-kfi: ept walk: eptp=0x1061b505e gpa=0xfcf28
[13956.578733]   PML4E : [0x1061b505e] pfn=0x1061b5         : is
within the range: 0x100000-0x3fffffff: System RAM
[13956.578736]   PDPTE : [0x11f29a907] pfn=0x11f29a         : is
within the range: 0x100000-0x3fffffff: System RAM
[13956.578739]   PDE   : [0x11c205907] pfn=0x11c205         : is
within the range: 0x100000-0x3fffffff: System RAM
[13956.578741]   PTE   : [0x11c204907] pfn=0x11c204         : is
within the range: 0x100000-0x3fffffff: System RAM
```

Does this seem to indicate an mmu_notifier refcount issue to you, given that
migration did fix it? Any way to verify?

We haven't found any guests with `softlockup_panic=1` yet, and since we can't
reproduce the issue on command ourselves yet, we might have to wait a bit - but
I imagine that the fact that live migration "fixed" the locked up guest confirms
that the other guests that didn't get "fixed" were likely softlocked from the
CPU stalling?

If you have any suggestions on how modifying the host kernel (and then migrating
a locked up guest to it) or eBPF programs that might help illuminate the issue
further, let me know!

Thanks for all your help so far!
