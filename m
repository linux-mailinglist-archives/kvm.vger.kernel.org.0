Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8B83A5979
	for <lists+kvm@lfdr.de>; Sun, 13 Jun 2021 18:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhFMQOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 12:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhFMQOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Jun 2021 12:14:49 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC72C061574
        for <kvm@vger.kernel.org>; Sun, 13 Jun 2021 09:12:48 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id a26so11741078oie.11
        for <kvm@vger.kernel.org>; Sun, 13 Jun 2021 09:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yBpBfIL3c4yamjUOfh15PIn+LHH5VYTkKMJefPrut2U=;
        b=Kk1EkSOGGZUnQmk/Y5ovSAZDucF09RKbvv7M+cI3W/y5UN2zfNEdQaLyMUsbHzweUG
         7UaTXV2w146xSDeKfpeJ223VvIVqbWq90CIQ39uBhwIpqZAK2klqcgiOUSMqp5YM3+O5
         T6yPCADHedtsNkBC7+C4FzNzIiyWB+9GQw4yBm8XiGoQdOmkvDn33Wk5Owtx3EaoMrSy
         7yrMAX7ddpB+fF0voDZ3HYWsOynQmwcT/kyw+azriyLCXZN6WyTdHZeASGp+MNAOIllb
         zMXAFBwuxvqSW5JNHJpbvQTvntXCMPRDrLeNLeFE/qpxaGXNiUpi70rGe/Cya601P9/q
         /puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yBpBfIL3c4yamjUOfh15PIn+LHH5VYTkKMJefPrut2U=;
        b=NnQrbd91l7gxaIK36ARyjr7GZqpcop7F+qzqFwPJgeKE+UneMH+1UQFn8UvRqoQX4S
         Gic8JEVMnMShXNNFpYDGTIo/3/Hd5BYFSLJLCosrm6712ptOiLbdjlDFu585Tk6JbC9j
         bRHAN1c5xxQgUVLnXpQ4Zty8p8vwU79eYYGdeE2rJAfWHmtYhhLhH2f2MzXAsN8e1Gev
         Kfp1CjiF+c6px/ltLIIPThsaYckLEpWVobI46mBNt/zlIjT6IYAbSDyv9JaAtnErIW+S
         N3SAM9DEXb/IyZ5KYNuerP41qnGsiYNtzUl7Qzj2grd6SnYCQ0B1CQkGwodJvJnR5C8R
         xvlA==
X-Gm-Message-State: AOAM531CD9J/CpvBAg9d9PJmawkaa4N/5Y9vnDpLBiyG18QQSlFjG5/8
        iL+aMdpCdLOHy4Z5u0Yn/DH9EOxxWIslfwP4aMp3ieTMZS+IaA==
X-Google-Smtp-Source: ABdhPJzWGHaVD19FqHVK4GsyrVIw0KQskIBRxuyKj72ptUY/vcAoi5FVZ+gupdPpuLBzb1vZtheIBWJJBppN5Bry+xQ=
X-Received: by 2002:aca:de07:: with SMTP id v7mr78881oig.8.1623600767323; Sun,
 13 Jun 2021 09:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com> <e32d28f3-4ba6-4b5d-a5a2-7362a4010583@arm.com>
In-Reply-To: <e32d28f3-4ba6-4b5d-a5a2-7362a4010583@arm.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Sun, 13 Jun 2021 17:12:10 +0100
Message-ID: <CA+EHjTyi2rbYaUu6OWpfBvtZuZKPJN5B8WkWMLRhNz3mm3A-HA@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, christoffer.dall@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>, KVM <kvm@vger.kernel.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Fri, Jun 11, 2021 at 1:43 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On 6/8/21 3:11 PM, Fuad Tabba wrote:
> > Hi,
> >
> > This patch series adds support for restricting CPU features for protected VMs
> > in KVM [1].
> >
> > Various feature configurations are allowed in KVM/arm64. Supporting all
> > these features in pKVM is difficult, as it either involves moving much of
> > the handling code to EL2, which adds bloat and results in a less verifiable
> > trusted code base. Or it involves leaving the code handling at EL1, which
> > risks having an untrusted host kernel feeding wrong information to the EL2
> > and to the protected guests.
> >
> > This series attempts to mitigate this by reducing the configuration space,
> > providing a reduced amount of feature support at EL2 with the least amount of
> > compromise of protected guests' capabilities.
> >
> > This is done by restricting CPU features exposed to protected guests through
> > feature registers. These restrictions are enforced by trapping register
> > accesses as well as instructions associated with these features, and injecting
> > an undefined exception into the guest if it attempts to use a restricted
> > feature.
> >
> > The features being restricted (only for protected VMs in protected mode) are
> > the following:
> > - Debug, Trace, and DoubleLock
> > - Performance Monitoring (PMU)
> > - Statistical Profiling (SPE)
> > - Scalable Vector Extension (SVE)
> > - Memory Partitioning and Monitoring (MPAM)
> > - Activity Monitoring (AMU)
> > - Memory Tagging (MTE)
> > - Limited Ordering Regions (LOR)
> > - AArch32 State
> > - Generic Interrupt Controller (GIC) (depending on rVIC support)
> > - Nested Virtualization (NV)
> > - Reliability, Availability, and Serviceability (RAS) above V1
> > - Implementation-defined Features
> >
> > This series is based on kvmarm/next and Will's patches for an Initial pKVM user
> > ABI [1]. You can find the applied series here [2].
>
> Since this is implementing the kernel side of an RFC userspace ABI, I'm going to
> treat the series as an RFC also and not go into the individual patches.
>
> What strikes me as odd is the fact that, as far as I can tell, you're duplicating
> part of the kvm/sys_regs.c and kvm/handle_exit.c functionality in the nvhe code.
> Why was this approach chosen instead of reusing the existing functions and adding
> extra code to handle the protected VM case?
>
> Another example of this is detecting when a host dropped to 32bit EL0, the comment
> says that you don't trust the host to make the check. What exactly do you trust
> the host to do at what point? I don't see this explained anywhere, it's possible
> I've missed it.

You're right. I haven't explained this in the patch series or provided
enough context other than a link to Will's presentation [1].

The idea is that protected VMs are protected from the host Linux
kernel (and from other VMs), where the host does not have access to
guest memory even if compromised. This patch series does not cover
that part yet. It is a part of, and builds on, other concurrent work
in order to get us there eventually [2].

Once everything falls into place, the host should not even have access
to a protected guest's state or anything that would enable it to
manipulate it (e.g., vcpu register context and el2 system registers),
only hyp would have that access. If the host could access that state,
then it might be able to get around the protection provided.
Therefore, anything that is sensitive and that would require such
access needs to happen at hyp, hence the code in nvhe running only at
hyp.

> I also think that registers that mostly don't change during the lifetime of the VM
> (HCR_EL2, CPTR_EL2, MDCR_EL2) can be set by host when the VM becomes protected,
> instead of fiddling with them at each world switch. Was there a particular reason
> for changing them in __activate_traps_pvm() or was this just an implementation choice?

You're right that they don't change during the lifetime of a VM, but
protected VMs can coexist with non-protected VMs. The values of these
registers are different between the two (different trapping to control
protection as well as enabled features). Thus the new
__activate_traps_pvm(), which would activate traps specifically for
protected VMs.

Thank you,
/fuad

[1]
https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/slides/kvmforum-2020-edited.pdf

[2] Some of the work on protected KVM:
https://lore.kernel.org/kvmarm/20201202184122.26046-1-dbrazdil@google.com/
https://lore.kernel.org/kvmarm/20210602094347.3730846-1-qperret@google.com/
https://lore.kernel.org/kvmarm/20210608114518.748712-1-qperret@google.com/
https://lore.kernel.org/kvmarm/20210322175639.801566-1-maz@kernel.org/
https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/






> Thanks,
>
> Alex
>
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
> >
> > For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
> > https://www.youtube.com/watch?v=edqJSzsDRxk
> >
> > [2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1
