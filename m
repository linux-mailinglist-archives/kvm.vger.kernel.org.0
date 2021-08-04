Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1593DF8FA
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 02:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhHDAjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 20:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhHDAjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 20:39:13 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CB4C06175F
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 17:39:01 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so219073oti.0
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 17:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIxIODv/KXQQdTNzvHXnF6RyCq8epmlZKshZBKKOkhc=;
        b=ChPqxi8jpGXh5LtSA6CH4tJUdKiFVjYDth3nMzPuFdikFvo9fQnDgcw/99seKBphrW
         MEin4bfjYloij8SocRKMPh5OYH+l2RalJJVsjP+3+1uLUd3rBRJ+aixMRuQhzYmws/gC
         5lS/EQvbG+Tm28J1NpCeH+SiJKSzJa6vQwIPmmQ/iudr7SM021njikH0+Ny4loQtRxGg
         pfQu+U/2VU9gBnSaYSvzHAp+sR6caWGSVNdsA2XH7FPawitFv/lMxV0NrgEvQ8HAOR8z
         Owg6Z0iQglcgIxmomKcKkcVR6y+zdHMfzy/oJkBi5Yc62lFa2Q5VZtsTyrz0+4MBi2wn
         oBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIxIODv/KXQQdTNzvHXnF6RyCq8epmlZKshZBKKOkhc=;
        b=Dt85BsxwSt48XoTnfiTR8efvvSlPgnZ+mcKabtn0rhyQptiKBrqgdn/DUT8v1K5zW4
         3M3RszJdER1PA49r8E9vcVB8WlBE29Z6MKl+Q7O9NcAVoVY4NX9PxbmqOxxaS1a8BIkl
         0kIir4LPdM+oqaOZ/CKnyWrIQSfdhQEzXXwCrWkWHeDIFuh2onDtgiyPQN5vXTiCLne/
         FtsvOGVq6UESJuyHSGvuVbKjCmsGl5rDYEnkjI/c+nic5f7oxYxVhaL1VfVqi8O2iMKC
         06ib1zA5zlHPj84rnVdN1i4SBH9rWB2EpjQjdw22eJbu0LaeJDRUs+b/fIqegL/XzCDm
         Kr8A==
X-Gm-Message-State: AOAM532JT97wrFRskZhHyipmN13zi5c8i29srs7cKg3DbpwtqjWL34gI
        G7L8CW9ymVaE6Ihho8bUyCUm9V4Ky5nVrUE/mos=
X-Google-Smtp-Source: ABdhPJzhOS9SWifCdLUqG0NVqLZED7uAHz1MZ6X0Vuq4TIxyVqc0izh3EH+FSYZIh0T9jDKCmC3QeQwwB8RFPvdgY+8=
X-Received: by 2002:a05:6830:1c69:: with SMTP id s9mr17485492otg.185.1628037541255;
 Tue, 03 Aug 2021 17:39:01 -0700 (PDT)
MIME-Version: 1.0
References: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain>
In-Reply-To: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 4 Aug 2021 08:38:50 +0800
Message-ID: <CANRm+Cy6CN2hF=BxZagkm0amUoQ8UcuD0JGvCV_Sj7bJFit0ow@mail.gmail.com>
Subject: Re: What does KVM_HINTS_REALTIME do?
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Jenifer Abrams <jhopper@redhat.com>,
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

On Tue, 3 Aug 2021 at 22:14, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> Hi,
> I was just in a discussion where we realized KVM_HINTS_REALTIME is a
> little underdocumented. Here is attempt to address that. Please correct
> me if there are inaccuracies or reply if you have additional questions:
>
> KVM_HINTS_REALTIME (aka QEMU kvm-hint-dedicated) is defined as follows
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

Looks good to me, too. :)

    Wanpeng
