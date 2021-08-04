Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6B63DFD9B
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 11:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbhHDJHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 05:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbhHDJHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 05:07:01 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC14C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 02:06:48 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id s184so1637524ios.2
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 02:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KpWU8S2rnRJUrosxQi6qwyfx5W1dTAzpFDbdGBIRVh4=;
        b=MifTh5R4ZMmURl28E4XLwG9O81A4kneMeOhdNThYWIa3ylNmsUIWMeSHnpAbFnbH+m
         msA8NtoXKU3zPa6vzDHAvKB9QLmM7L+mdLppajOFbH1ksCbfH5BLsPz0OWNPruVUl671
         gl35Ei0R8+6FMPCdiGGFsxaQi3WYrB/jIlnkHU8jgbec5QpA5xs0FTyaJRoUEVrqtoD5
         dwxU97itNfedFAYFwsyfr4DwElmkM00m2/gOclmM9034kYuNyW+SvyiTubV6DXp4KoX5
         JFBkh2svyW6pJXvLQWLKMWRZY74hqNnfK+bg64TYd0fBH+TD1BhYDSjKo/O69fCN38HC
         JaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KpWU8S2rnRJUrosxQi6qwyfx5W1dTAzpFDbdGBIRVh4=;
        b=nyq1XuHbonXUhcjq2wPwe0gvNWYPratZj7K4RHlrt4bE9b40lxwDVyKAyhqQzVx6cJ
         3X7cVnWT34a6jC2buB++IAcvT6ypkXXZSlNBRpYfXthL4h/BEHdMmSnOOzgrgHNczKnS
         +ZwduJPZMIhFuD5yGfOZG8SKXKfmESBou4OtEVSv6LXcAj874rh50gvuLv8EgCcZ1eDW
         J8TZPQjY7dFui1353wHmYfAcu6b0ipK8rbjutjmaD2IjcNEzzuFKuJThd6NEHqNAGXar
         pH+/PLyFVa5yfUao0PLz/K5rlVj/wg3v6Th5DsQ9eGpYUEY2ZaWFCwM/ALj6jbMSlF0j
         TmKg==
X-Gm-Message-State: AOAM5334OjkYMpdReXbRFMvoZwVcDDsw32bAdza0lH1OKoFGY/JLPQ1t
        TlSop/Wp/jzFcAn56dCW6EmdxUgqWbs4Ny8Hqdo=
X-Google-Smtp-Source: ABdhPJwCZX5c1nCNybr01QMYC0HxKNSAYZ5FoMn5reti11HNcRWnTG7kOxvYk/c64w2yHu6SWp9+tenVOricwsSirZA=
X-Received: by 2002:a05:6602:228d:: with SMTP id d13mr1062869iod.36.1628068008300;
 Wed, 04 Aug 2021 02:06:48 -0700 (PDT)
MIME-Version: 1.0
References: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain> <CAM9Jb+jAx8uy0PerK6gN2GOykQpPXQbd9uoPkeyxZSbya==o5w@mail.gmail.com>
In-Reply-To: <CAM9Jb+jAx8uy0PerK6gN2GOykQpPXQbd9uoPkeyxZSbya==o5w@mail.gmail.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 4 Aug 2021 11:06:37 +0200
Message-ID: <CAM9Jb+jNUrympkjUMnX3D0AMTfZOuHYbF+-VDb10AiXybW-e_A@mail.gmail.com>
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

> > Hi,
> > I was just in a discussion where we realized KVM_HINTS_REALTIME is a
> > little underdocumented. Here is attempt to address that. Please correct
> > me if there are inaccuracies or reply if you have additional questions:
> >
> > KVM_HINTS_REALTIME (akaalso  QEMU kvm-hint-dedicated) is defined as follows
> > in Documentation/virt/kvm/cpuid.rst:
> >
> >   guest checks this feature bit to determine that vCPUs are never
> >   preempted for an unlimited time allowing optimizations
> >
> > Users or management tools set this flag themselves (it is not set
> > automatically). This raises the question of what effects this flag has
> > and when it should be set.
> >
> > When should I set KVM_HINTS_REALTIME?
> > -------------------------------------
> > When vCPUs are pinned to dedicated pCPUs. Even better if the isolcpus=
> > kernel parameter is used on the host so there are no disturbances.
> >
> > Is the flag guest-wide or per-vCPU?
> > -----------------------------------
> > This flag is guest-wide so all vCPUs should be dedicated, not just some
> > of them.
> >
> > Which Linux guest features are affected?
> > ----------------------------------------
> > PV spinlocks, PV TLB flush, and PV sched yield are disabled by
> > KVM_HINTS_REALTIME. This is because no other vCPUs or host tasks will be
> > running on the pCPUs, so there is no benefit in involving the host.
>
> Do we need to mention "halt_poll_ns" at host side also will also be disabled?
with KVM_FEATURE_POLL_CONTROL

Sorry, pressed enter quickly in previous email.
>
> >
> > The cpuidle-haltpoll driver is enabled by KVM_HINTS_REALTIME. This
> > driver performs busy waiting inside the guest before halting the CPU in
> > order to avoid the vCPU's wakeup latency. This driver also has a boolean
> > "force" module parameter if you wish to enable it without setting
> > KVM_HINTS_REALTIME.
> >
> > When KVM_HINTS_REALTIME is set, the KVM_CAP_X86_DISABLE_EXITS capability
> > can also be used to disable MWAIT/HLT/PAUSE/CSTATE exits. This improves
> > the latency of these operations. The user or management tools need to
> > disable these exits themselves, e.g. with QEMU's -overcommit cpu-pm=on.
>
> This looks good. Thank you.
>
> Thanks,
> Pankaj
