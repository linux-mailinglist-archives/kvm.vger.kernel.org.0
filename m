Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA7076CFEE
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 16:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjHBOWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 10:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjHBOWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 10:22:07 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03EBA2
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 07:22:04 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-486556dea4dso2862935e0c.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 07:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690986124; x=1691590924;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9iazQFSEZt0KXvxOju7NOYwxZXHJ/2YlcdXCfV+Ilwo=;
        b=qzo8p5epeoTMJJxT6j64sImktDJ7Piw0GgY8rea+bMBvCvaQx5aaBlpmDlp0+6yfOv
         sbBWldmHLv7h+MelPqWgtwPlXDSL/ZeacWRCYgCkHBtApMMR0XohhJVqfHXb45j3Rj2B
         OKxI5t+GZuhZJpcv2RRk/7E9DcEsATQyX5wqNbrgklTPtuO1uQI19NfKDEisEuVunNIg
         HsmsA7GTcZdY+S3FwR68zk8MZ/OIHTIKIndlbJShxvAPhgsNmmtWh7HRdN4RwKcyDFhL
         tqAGgl0EvGG/eBDv8KYcD/KTSK/kpjAlz5cfOexX6ShLHc4IU8vB1vtJhINDj/tK3sFR
         kBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690986124; x=1691590924;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9iazQFSEZt0KXvxOju7NOYwxZXHJ/2YlcdXCfV+Ilwo=;
        b=gaGP9tINpBK2hzC7yPRAQIbVbIrPzxtsevps4tm0Rjy3apxj3sLUzSA3cHEBG+KbGs
         /P8BMtgR8jHv+JQgmw0vc937wD91rIq02egphykRvYGjxiGFhzYZmqwCYpxa2AkOWQb6
         2O27417rd9bEDKIzf1nAEze2l4wuxAPR9J+E9KuS4vJFXyMbHUYT74eAxkg5ZIaVMlBr
         NFgGPvlzQav7BSBki1I7MI6JlGNVVXFSR9wBpwUMY7MACNjhWRq+FqshCECPibFtJG7P
         0rqDZyazwg5J8x7qvDei2qjT1wc28VbLGFBEhDsEIFdrNrRVwVYb+JeVxqoXIHAWVQVO
         kImw==
X-Gm-Message-State: ABy/qLYdweLFIgeV9PHLWgpnkM8evpjvTFQ30tQecgrhCZUWctIOA0Yu
        jhfIiFiqKr2v5PwPYvHBoXt+77BsreMdcGRWi33mz3MWYCkTw90J
X-Google-Smtp-Source: APBJJlGyPKrw0gk362/LLzsjRpErrxgVw9vwEThT973lciai3KZ/k6+92snYkPeiqrYT3A3oGZz6NDnUZTW80sEc20s=
X-Received: by 2002:a1f:c1d4:0:b0:481:2dec:c27 with SMTP id
 r203-20020a1fc1d4000000b004812dec0c27mr5295915vkf.1.1690986123961; Wed, 02
 Aug 2023 07:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
 <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com>
In-Reply-To: <ZMAGuic1viMLtV7h@google.com>
From:   Amaan Cheval <amaan.cheval@gmail.com>
Date:   Wed, 2 Aug 2023 19:51:52 +0530
Message-ID: <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
Subject: Re: Deadlock due to EPT_VIOLATION
To:     Sean Christopherson <seanjc@google.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Yeesh.  There is a ridiculous amount of potentially problematic activity.  KSM is
> active in that trace, it looks like NUMA balancing might be in play,

Sorry about the delayed response - it seems like the majority of locked up guest
VMs stop throwing repeated EPT_VIOLATIONs as soon as we turn `numa_balancing`
off.
They still remain locked up, but that might be because the original cause of the
looping EPT_VIOLATIONs corrupted/crashed them in an unrecoverable way (are there
any ways you can think of that that might happen)?

----

We experimented with numa_balancing + transparent hugepage settings in certain
data centers (to determine if the settings make the lockups disappear) and the
incidence rate of locked up guests has lowered significantly for the
numa_balancing=0 and thp=1 case, but numa_balancing=0 and thp=0 are still
locking up / looping on EPT_VIOLATIONs at about the same rate (or slightly
lower than both numa_balancing=thp=1).

Here's a function_graph of a host which had numa_balancing=0, thp=1, ksm=2
(KSM unloaded and unmerged after it was initially on):

https://transfer.sh/M4WdfxaTJs/ept-fn-graph.log

```
# bpftrace -e 'kprobe:handle_ept_violation { @ept[comm] = count(); }
tracepoint:kvm:kvm_page_fault { @pf[comm] = count(); }'
Attaching 2 probes...
^C

@ept[CPU 0/KVM]: 52
@ept[CPU 3/KVM]: 61
@ept[CPU 2/KVM]: 112
@ept[CPU 1/KVM]: 257

@pf[CPU 0/KVM]: 52
@pf[CPU 3/KVM]: 61
@pf[CPU 2/KVM]: 111
@pf[CPU 1/KVM]: 262
```

> there might be hugepage shattering, etc.

Is there a BPF program / another way we can confirm this is the case? I think
the fact that guests lockup at about the same rate when thp=0,numa_balancing=0
as thp=1,numa_balancing=1 is interesting and relevant.

Only thp=1,numa_balancing=0 seems to have the least guests locking up.

> Let me rephrase that statement: it rules out a certain class of memslot and
> mmu_notifier bugs, namely bugs where KVM would incorrect leave an invalidation
> refcount (for lack of a better term) elevated.  It doesn't mean memslot changes
> and/or mmu_notifier events aren't at fault.

I see, thanks!

> kernel bug, e.g. it's possible the vCPU is stuck purely because it's being trashed
> to the point where it can't make forward progress.

Given that the guest stays locked-up post-migration on a completely unloaded
host, I think this is unlikely unless the thrashing also corrupts the guests'
state before the migration somehow?

> Yeah.  Definitely not related async page fault.

I guess the biggest lead currently is why `numa_balancing=1` increases the
odds of this issue occurring, and why is it specifically more likely with
transparent hugepages off (`thp=0`)?

To be clear, the lockups occur in all configurations we've tried so far, so none
of these are likely the direct cause, just relevant factors.

If there's any changes in the kernel that might help illuminate the issue
further, we can run a custom kernel and migrate a guest to the modified host -
let me know if there's anything that might help!
