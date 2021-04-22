Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10B436768B
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbhDVA4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbhDVA4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 20:56:05 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC183C06174A;
        Wed, 21 Apr 2021 17:55:30 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id e25so14274016oii.2;
        Wed, 21 Apr 2021 17:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLBiD4Tk04qTKkjyIW7B4SXWL4eElYN21Iltqq+dkjI=;
        b=nVSKhA9jbTCQXGKT9VEE2jEn9daDPmQnc92m0FSOt8YqSlv3yQb6ws/3JSWDjA2tF4
         URaAqnxyWUbM8qaopN5nwaRlzd1eiNwSJJayX+TsXYUYLxUmbET+V/sVItEQAsRa/JOH
         O0DdNZYQrIJAU6vtrXXlpUkUWNa81+4v2CRF9kAny2YZmV6u577kuFkg8JbEVp2BS+Wg
         vziVMn/vIVXLdU7zeLMQRMCj9APbZwUgQZcV9BcVRXMib60qb1QoZWXWedM74ucClHfO
         GkTiCPcJPj0s+8lYligf6uMmfwgWbJ2TdmbGhPkZM3zIa3wDkQt+gIz+X0jvWiIKHDCK
         A+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLBiD4Tk04qTKkjyIW7B4SXWL4eElYN21Iltqq+dkjI=;
        b=qCpmiBBW95ftMzM+qPmAxedHROqRXvbP2lrubbCdmxi8xPP5lpd4WmBMzbPJN18wCU
         bXxH5FzLBzQMoiH6WygK5yIXP1xFFQk0axsyg8wxUa23vfal5wYzzI9WL1whchIaU8yn
         ddr8NcgI5qpjtaKQD93qIVYnll4j6uYZMhmUosfNOpAtNjMnanUKKlS6CM4b/6Lb7o7w
         efbRBDtdnErfCydeMursjMOz1vHOVM+K0rQL26KVJR5w2LRrkeUzrf+Iv5tG4OTEDpBv
         mUEGVxKu29z0S9QiCEZmloOQBRAWjohDhvzCDPbfyg0tNuljM80IAcOa+L2Wy5Xqm2io
         jf+w==
X-Gm-Message-State: AOAM532BW309X5HVFXutW7kZNdwcaxuHADe1EqvqfM4MgWgr759oehh1
        4CwzRsIlLV05K2NlLxmDUKMtdGKQ6ZtUyyd2IzI=
X-Google-Smtp-Source: ABdhPJzSxmMzr0fgRvT7YYexSh2vvSZM5cj/lAd32qu5bVc6ek/0yb56L5ty29OxkkiSZ6r3NXeYsd49EzjGDqaf9gE=
X-Received: by 2002:a05:6808:5c5:: with SMTP id d5mr8509578oij.141.1619052930189;
 Wed, 21 Apr 2021 17:55:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210421150831.60133-1-kentaishiguro@sslab.ics.keio.ac.jp>
In-Reply-To: <20210421150831.60133-1-kentaishiguro@sslab.ics.keio.ac.jp>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 22 Apr 2021 08:55:18 +0800
Message-ID: <CANRm+Cw1hNauuWGXOazpJ=s0tb6C-iQx=CZY92SPTDSEaT7jAw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Mitigating Excessive Pause-Loop Exiting in
 VM-Agnostic KVM
To:     Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        pl@sslab.ics.keio.ac.jp, kono@sslab.ics.keio.ac.jp
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Apr 2021 at 06:13, Kenta Ishiguro
<kentaishiguro@sslab.ics.keio.ac.jp> wrote:
>
> Dear KVM developers and maintainers,
>
> In our research work presented last week at the VEE 2021 conference [1], we
> found out that a lot of continuous Pause-Loop-Exiting (PLE) events occur
> due to three problems we have identified: 1) Linux CFS ignores hints from
> KVM; 2) IPI receiver vCPUs in user-mode are not boosted; 3) IPI-receiver
> that has halted is always a candidate for boost.  We have intoduced two
> mitigations against the problems.
>
> To solve problem (1), patch 1 increases the vruntime of yielded vCPU to
> pass the check `if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next,
> left) < 1)` in `struct sched_entity * pick_next_entity()` if the cfs_rq's
> skip and next are both vCPUs in the same VM. To keep fairness it does not
> prioritize the guest VM which causes PLE, however it improves the
> performance by eliminating unnecessary PLE. Also we have confirmed
> `yield_to_task_fair` is called only from KVM.
>
> To solve problems (2) and (3), patch 2 monitors IPI communication between
> vCPUs and leverages the relationship between vCPUs to select boost
> candidates.  The "[PATCH] KVM: Boost vCPU candidiate in user mode which is
> delivering interrupt" patch
> (https://lore.kernel.org/kvm/CANRm+Cy-78UnrkX8nh5WdHut2WW5NU=UL84FRJnUNjsAPK+Uww@mail.gmail.com/T/)
> seems to be effective for (2) while it only uses the IPI receiver
> information.
>
> Our approach reduces the total number of PLE events by up to 87.6 % in four
> 8-vCPU VMs in over-subscribed scenario with the Linux kernel 5.6.0. Please
> find the patch below.

You should mention that this improvement mainly comes from your
problems (1) scheduler hacking, however, kvm task is just an ordinary
task and scheduler maintainer always does not accept special
treatment.  the worst case for problems (1) mentioned in your paper, I
guess it is vCPU stacking issue, I try to mitigate it before
(https://lore.kernel.org/kvm/1564479235-25074-1-git-send-email-wanpengli@tencent.com/).
For your problems (3), we evaluate hackbench which is heavily
contended rq locks and heavy async ipi(reschedule ipi), the async ipi
influence is around 0.X%, I don't expect normal workloads can feel any
affected. In addition, four 8-vCPU VMs are not suitable for
scalability evaluation. I don't think the complex which is introduced
by your patch 2 is worth it since it gets a similar effect as my
version w/ current heuristic algorithm.

    Wanpeng
