Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AC949BA64
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 18:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381671AbiAYRaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 12:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588208AbiAYR32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 12:29:28 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EA5C06176C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 09:29:27 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id q127so3050803ljq.2
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 09:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/hknxCIQs9L7yHre9W/YjWQp1r1IskMzEHUGv30wqmk=;
        b=H6YC+7gZK+rHzUwevbdt/gr7+NRBE96gYj+hnmNLXygphziRTMrkZmlwV21jXKJwcK
         crXaMzls4gcmtSu34YkvKWYmX1uoCTkkrFXp9J9puYZgNVD9MXN1OhIzOffyupTYY+fi
         lapyzofoU1EzSl3abb0hWQAOIry8cLaUz2+RUf2AUsRKbMDllI4Dxt6iRUkpbNnsySCS
         MFgamwMl5T4hgh//j8XQoSWnkzbEBMMPZv1y3RdWbjtSU27+Wm7WT2RQu2sjKrWPhi8u
         wbfQj64J3YZV87RPSTC/lpmSfFOSA6D/IsppUK835u8aX46KDj6yCdyZOYyWA3W+rQWI
         NlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/hknxCIQs9L7yHre9W/YjWQp1r1IskMzEHUGv30wqmk=;
        b=VmAlB0fbXkjmyXP248ldU0URuXOe6iCbIaMi/vfcYoWdHKp70C+LRIZoGifA0wAo+g
         IinY/0mSfaoR58V1RzLIwFwuPmAg+hO7KzbSCRr9IZJGrKiYbLPPMlY9QHyg17IYk8zf
         AkKlTkbvBAGyJTfG+Rtrd26g73+0j4OBARdpu8mEbTS8m5AusU7WI4mf5+Jn51E4ayRM
         Uwcn7clqiDScV9fbMSMkHI7CJgDdMEoYaDqRef7vmj06cbJ/zd6X1ut2r/owR/m3i3GB
         paAqqozUHyjBLBm+10iLL/tJ/BMhb0pIb/6rsF/MW8RwaYVM9n1z3lss01KUYzpIIAJj
         9gkw==
X-Gm-Message-State: AOAM533g/Srp0IdZsXqb1PnS21oobKyIjRXPIDwVk81AKHfmZAEwq2oU
        XWCO9nfHBPOOF/LVPY4G71/JLQd17JsOpPQ2fdwzdQ==
X-Google-Smtp-Source: ABdhPJy9fZvaWGtBZz8tk4V1zsibsfK+5cWdGhGLbXd1O2iDMVIYgjWUUlbTawt6szEaW2PdkVfF1SxBUsCaH1/XpRo=
X-Received: by 2002:a2e:904f:: with SMTP id n15mr11656317ljg.275.1643131765866;
 Tue, 25 Jan 2022 09:29:25 -0800 (PST)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home> <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org> <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org> <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
 <CAJHc60wp4uCVQhigNrNxF3pPd_8RPHXQvK+gf7rSxCRfH6KwFg@mail.gmail.com> <875yq88app.wl-maz@kernel.org>
In-Reply-To: <875yq88app.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 25 Jan 2022 09:29:13 -0800
Message-ID: <CAOQ_QshL2MCc8-vkYRTDhtZXug20OnMg=qedhSGDrp_VUnX+5g@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To:     Marc Zyngier <maz@kernel.org>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Andrew Jones <drjones@redhat.com>,
        kvmarm@lists.cs.columbia.edu, pshier@google.com,
        ricarkol@google.com, reijiw@google.com, jingzhangos@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com, Alexandru.Elisei@arm.com,
        suzuki.poulose@arm.com, Peter Maydell <peter.maydell@linaro.org>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Jan 25, 2022 at 12:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > If I understand correctly, the original motivation for going with
> > pseudo-registers was to comply with QEMU, which uses KVM_GET_REG_LIST
> > and KVM_[GET|SET]_ONE_REG interface, but I'm guessing the VMMs doing
> > save/restore across migration might write the same values for every
> > vCPU.
>
> KVM currently restricts the vcpu features to be unified across vcpus,
> but that's only an implementation choice.

But that implementation choice has become ABI, no? How could support
for asymmetry be added without requiring userspace opt-in or breaking
existing VMMs that depend on feature unification?

> The ARM architecture doesn't
> mandate that these registers are all the same, and it isn't impossible
> that we'd allow for the feature set to become per-vcpu at some point
> in time. So this argument doesn't really hold.

Accessing per-VM state N times is bound to increase VM blackout time
during migrations ~linearly as the number of vCPUs in a VM increases,
since a VM scoped lock is necessary to serialize guest accesses. It
could be tolerable at present scale, but seems like in the future it
could become a real problem.

> Furthermore, compatibility with QEMU's save/restore model is
> essential, and AFAICT, there is no open source alternative.

Agree fundamentally, but I believe it is entirely reasonable to
require a userspace change to adopt a new KVM feature. Otherwise, we
may be trying to shoehorn new features into existing UAPI that may not
be a precise fit..

In order to cure the serialization mentioned above, two options are
top of mind: accessing the VM state with the VM FD or informing
userspace that a set of registers need only be written once for an
entire VM. If we add support for asymmetry later down the road, that
would become an opt-in such that userspace will do the access
per-vCPU.

> A device means yet another configuration and migration API. Don't you
> think we have enough of those? The complexity of KVM/arm64 userspace
> API is already insane, and extremely fragile. Adding to it will be a
> validation nightmare (it already is, and I don't see anyone actively
> helping with it).

It seems equally fragile to introduce VM-wide serialization to vCPU
UAPI that we know is in the live migration critical path for _any_
VMM. Without requiring userspace changes for all the new widgets under
discussion we're effectively forcing VMMs to do something suboptimal.

--
Thanks,
Oliver
