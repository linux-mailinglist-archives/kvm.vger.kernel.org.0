Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E6B3DFD91
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 11:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbhHDJBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 05:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbhHDJB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 05:01:29 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B459DC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 02:01:16 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r6so1587410ioj.8
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 02:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NYfkt4uRij4SSSRRXYtBr9G5dtp2FZwlSoOWKF8Ky8Y=;
        b=mf0qTtEK/giub+1P3TU2OnTzv1QwoxeTR5Gqo0arO5WGGO0glvk2NUYW8KF6BgSJAT
         jEpJfESjEKpC2SV+2SZOv/z4gy94oE2LdNHShX98Cl8nSnPvcdh5qkBlsYVJgidz0Hag
         NgW+cT60tAmaE8LcKl90DoapyN8FmdOqHD+YQ1pFrjoDACmumJf0EypPz2ZTAMbAL0n2
         mUHxC/4kS620v8TCiDsoMqtFZ+0mihTEvb3udwjqg3y1aNuOl/jObv84zxdiCiVaElcO
         +UmHdfI/IdKrTpz2aZyL2uUjutbwF1JiE7rQVNV6w143EPT++Aym8ZeraKF68n7Rc1Nf
         zIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NYfkt4uRij4SSSRRXYtBr9G5dtp2FZwlSoOWKF8Ky8Y=;
        b=b0NMWnBYeTsDWVQoKJPJWG45xuPm/xXlQZGdBK0vKvTsjnTRS6/l5EBBt3ER5SmVjb
         3euonwklAxTMtLvtV5p2UESjaaep97TNEvBEsgVmUgR9Z1NSZWlQ+cDzbTscVfpITQr4
         L6v1937i1Py/RTrFA5pJojymzZEhLjN1dSQeXwy0BFHulaegbunixLhe7Aott7BaFQR4
         POOAcvu+wxqFV8ZEbzlpfnLIldcGFxQeZCMZ98njmHtJ4Uao8+05soV/SUTpHByEHHh/
         MoS7ql7nbuEqJY65xuG0/tnqnjPPBaTqzd4uPWqW/1KAXQx7ZzK+NDGdA1vCy8i1n/8c
         5a6Q==
X-Gm-Message-State: AOAM5324DxiFxRQF3RPR+tCzz//sgxaozsatkiPphErbTD7R3NT5wTXx
        6UiGZOd6f5YE9usfd8EYQ6wpwdBEK58Ovv9KQMguqSQY
X-Google-Smtp-Source: ABdhPJzJUFV6dNG6OunTRLKsDiMiGOjHQEZcWAbkA3qfkz1e3ZKs2n2bjTDcrYrMtZ2uqev5IsRrRFliBWAg5zbNqJk=
X-Received: by 2002:a02:a390:: with SMTP id y16mr6048390jak.120.1628067676182;
 Wed, 04 Aug 2021 02:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain>
In-Reply-To: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 4 Aug 2021 11:01:04 +0200
Message-ID: <CAM9Jb+jAx8uy0PerK6gN2GOykQpPXQbd9uoPkeyxZSbya==o5w@mail.gmail.com>
Subject: Re: What does KVM_HINTS_REALTIME do?
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, Jenifer Abrams <jhopper@redhat.com>,
        atheurer@redhat.com, jmario@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Hi,
> I was just in a discussion where we realized KVM_HINTS_REALTIME is a
> little underdocumented. Here is attempt to address that. Please correct
> me if there are inaccuracies or reply if you have additional questions:
>
> KVM_HINTS_REALTIME (akaalso  QEMU kvm-hint-dedicated) is defined as follows
> in Documentation/virt/kvm/cpuid.rst:
>
>   guest checks this feature bit to determine that vCPUs are never
>   preempted for an unlimited time allowing optimizations
>
> Users or management tools set this flag themselves (it is not set
> automatically). This raises the question of what effects this flag has
> and when it should be set.
>
> When should I set KVM_HINTS_REALTIME?
> -------------------------------------
> When vCPUs are pinned to dedicated pCPUs. Even better if the isolcpus=
> kernel parameter is used on the host so there are no disturbances.
>
> Is the flag guest-wide or per-vCPU?
> -----------------------------------
> This flag is guest-wide so all vCPUs should be dedicated, not just some
> of them.
>
> Which Linux guest features are affected?
> ----------------------------------------
> PV spinlocks, PV TLB flush, and PV sched yield are disabled by
> KVM_HINTS_REALTIME. This is because no other vCPUs or host tasks will be
> running on the pCPUs, so there is no benefit in involving the host.

Do we need to mention "halt_poll_ns" at host side also will also be disabled?

>
> The cpuidle-haltpoll driver is enabled by KVM_HINTS_REALTIME. This
> driver performs busy waiting inside the guest before halting the CPU in
> order to avoid the vCPU's wakeup latency. This driver also has a boolean
> "force" module parameter if you wish to enable it without setting
> KVM_HINTS_REALTIME.
>
> When KVM_HINTS_REALTIME is set, the KVM_CAP_X86_DISABLE_EXITS capability
> can also be used to disable MWAIT/HLT/PAUSE/CSTATE exits. This improves
> the latency of these operations. The user or management tools need to
> disable these exits themselves, e.g. with QEMU's -overcommit cpu-pm=on.

This looks good. Thank you.

Thanks,
Pankaj
