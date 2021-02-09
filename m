Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D291315829
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 22:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhBIUzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 15:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhBIUlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 15:41:52 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0ADC0611C0;
        Tue,  9 Feb 2021 12:39:11 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id r75so7269891oie.11;
        Tue, 09 Feb 2021 12:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SPNWZbb0ieq9Ng06qC0uChxxvuZ9IvrBtT/bnjNCrBU=;
        b=et1kBEEg+v6H8NIWZjACr5TuvWhITrHzEIFDjgALhR3dXA2ZbNwPtE0kh0K05oQrwG
         kgnvCq/R72PCNgKrC0Rljjec9M+ZBOqracReJ49vzlwxObJlWTPv1XTBkgf6KIjLq0cu
         Su9jxQc/1w7Tgkq3dVJOskVyDmpH3bxA+NVl8dcPQPWvOKsumSmOpNuuxv63h9XfdoV9
         nVvvAD+vfuJcSmCI/Lc3YX51ad+7HnOoE4lxd0x6HvifNItTGTp4YYEkMeXKv2Ht5Lza
         i7HFfJisGFDqbCCjENqUhPoiMRQXSSgHd/a6DSy4V4XL3yfLqDNuppHrGOj51tDYNkyB
         bORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=SPNWZbb0ieq9Ng06qC0uChxxvuZ9IvrBtT/bnjNCrBU=;
        b=J/Ww+xAi4qAcIbRnzEPtoi1PriM7PJLK7SyTaJCiG1HycwuYOPraRIqLYgoCen0wql
         hbCzbvvjai3W5yIoZCu8HmxJdhEP+ZgOgeQiAoTYuXqqvleqCalgxvtKIVx8YTTQuBAK
         v+4gmWg+Q9OwtdML8CQua+lQd64IQ+AGij013nNAXM2OY3wZG1g2Ihmr9BrDhKynfzev
         oFaxRW4hrrz57BPmxhYNfp8TGEveDgXtm56/t2WrlSYPlg0meFwqQUjHDb87sfcsA0ke
         bZk9O5RVG8Y2KIOoRYoTNio5dXX0gCeKm8E5++uFa8c0+MmMb6INd+1VIOe2+Fu2XdjK
         Z+Nw==
X-Gm-Message-State: AOAM53335MGxxw1vxRcWrSL8lXA6EN1UXrQ8qW/1IjEHbyZrWBfE6Z5N
        YossmoaNcqGjd5WL4bHW+vU=
X-Google-Smtp-Source: ABdhPJz1mgIh96Av+D1mUCur16fGMm3LSB7G/mFdcwk1A2yesrpkRh5fMZTO6Vg9WkR65TXGup0jmg==
X-Received: by 2002:aca:e085:: with SMTP id x127mr3758508oig.127.1612903151358;
        Tue, 09 Feb 2021 12:39:11 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k21sm2973786otl.27.2021.02.09.12.39.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 12:39:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 12:39:08 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 06/28] locking/rwlocks: Add contention detection for
 rwlocks
Message-ID: <20210209203908.GA255655@roeck-us.net>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-7-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202185734.1680553-7-bgardon@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 10:57:12AM -0800, Ben Gardon wrote:
> rwlocks do not currently have any facility to detect contention
> like spinlocks do. In order to allow users of rwlocks to better manage
> latency, add contention detection for queued rwlocks.
> 
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Will Deacon <will@kernel.org>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Davidlohr Bueso <dbueso@suse.de>
> Acked-by: Waiman Long <longman@redhat.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>

When building mips:defconfig, this patch results in:

Error log:
In file included from include/linux/spinlock.h:90,
                 from include/linux/ipc.h:5,
                 from include/uapi/linux/sem.h:5,
                 from include/linux/sem.h:5,
                 from include/linux/compat.h:14,
                 from arch/mips/kernel/asm-offsets.c:12:
arch/mips/include/asm/spinlock.h:17:28: error: redefinition of 'queued_spin_unlock'
   17 | #define queued_spin_unlock queued_spin_unlock
      |                            ^~~~~~~~~~~~~~~~~~
arch/mips/include/asm/spinlock.h:22:20: note: in expansion of macro 'queued_spin_unlock'
   22 | static inline void queued_spin_unlock(struct qspinlock *lock)
      |                    ^~~~~~~~~~~~~~~~~~
In file included from include/asm-generic/qrwlock.h:17,
                 from ./arch/mips/include/generated/asm/qrwlock.h:1,
                 from arch/mips/include/asm/spinlock.h:13,
                 from include/linux/spinlock.h:90,
                 from include/linux/ipc.h:5,
                 from include/uapi/linux/sem.h:5,
                 from include/linux/sem.h:5,
                 from include/linux/compat.h:14,
                 from arch/mips/kernel/asm-offsets.c:12:
include/asm-generic/qspinlock.h:94:29: note: previous definition of 'queued_spin_unlock' was here
   94 | static __always_inline void queued_spin_unlock(struct qspinlock *lock)
      |                             ^~~~~~~~~~~~~~~~~~

Bisect log attached.

Guenter

---
# bad: [a4bfd8d46ac357c12529e4eebb6c89502b03ecc9] Add linux-next specific files for 20210209
# good: [92bf22614b21a2706f4993b278017e437f7785b3] Linux 5.11-rc7
git bisect start 'HEAD' 'v5.11-rc7'
# good: [a8eb921ba7e8e77d994a1c6c69c8ef08456ecf53] Merge remote-tracking branch 'crypto/master'
git bisect good a8eb921ba7e8e77d994a1c6c69c8ef08456ecf53
# good: [21d507c41bdf83f6afc0e02976e43c10badfc6cd] Merge remote-tracking branch 'spi/for-next'
git bisect good 21d507c41bdf83f6afc0e02976e43c10badfc6cd
# bad: [30cd4c688a3bcf324f011d7716044b1a4681efc1] Merge remote-tracking branch 'soundwire/next'
git bisect bad 30cd4c688a3bcf324f011d7716044b1a4681efc1
# bad: [c43d2173d3eb4047bb62a7a393a298a1032cce18] Merge remote-tracking branch 'drivers-x86/for-next'
git bisect bad c43d2173d3eb4047bb62a7a393a298a1032cce18
# good: [973e9d8622a6fecc52f639680cbbde1519e1fcf8] Merge remote-tracking branch 'rcu/rcu/next'
git bisect good 973e9d8622a6fecc52f639680cbbde1519e1fcf8
# bad: [7b2aaf51d499e0372cbecafad04582c71ad03c73] Merge remote-tracking branch 'kvm/next'
git bisect bad 7b2aaf51d499e0372cbecafad04582c71ad03c73
# good: [04548ed0206ca895c8edd6a078c20a218423890b] KVM: SVM: Replace hard-coded value with #define
git bisect good 04548ed0206ca895c8edd6a078c20a218423890b
# bad: [92f4d400a407235783afd4399fa26c4c665024b5] KVM: x86/xen: Fix __user pointer handling for hypercall page installation
git bisect bad 92f4d400a407235783afd4399fa26c4c665024b5
# good: [ed5e484b79e8a9b8be714bd85b6fc70bd6dc99a7] KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter
git bisect good ed5e484b79e8a9b8be714bd85b6fc70bd6dc99a7
# bad: [f3d4b4b1dc1c5fb9ea17cac14133463bfe72f170] sched: Add cond_resched_rwlock
git bisect bad f3d4b4b1dc1c5fb9ea17cac14133463bfe72f170
# good: [f1b3b06a058bb5c636ffad0afae138fe30775881] KVM: x86/mmu: Clear dirtied pages mask bit before early break
git bisect good f1b3b06a058bb5c636ffad0afae138fe30775881
# bad: [26128cb6c7e6731fe644c687af97733adfdb5ee9] locking/rwlocks: Add contention detection for rwlocks
git bisect bad 26128cb6c7e6731fe644c687af97733adfdb5ee9
# good: [7cca2d0b7e7d9f3cd740d41afdc00051c9b508a0] KVM: x86/mmu: Protect TDP MMU page table memory with RCU
git bisect good 7cca2d0b7e7d9f3cd740d41afdc00051c9b508a0
# first bad commit: [26128cb6c7e6731fe644c687af97733adfdb5ee9] locking/rwlocks: Add contention detection for rwlocks
