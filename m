Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3166D3A1952
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhFIPZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbhFIPZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 11:25:35 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8643CC0617A8
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 08:23:33 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id l15-20020a05683016cfb02903fca0eacd15so384387otr.7
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 08:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EJisOkRU2LFWrcDGE1haBYgrxVOy2iOBRr5zUUIQhb0=;
        b=svt+D/9IKeiSzXsNpeGHltXWwDsQL5BTkIoQnOwbHViP9DxgVWEe/HN93hrclIxQ3d
         kbwFBFd8jnKGMbtPLUUQvwbqr5Ic41K1zNP/tV0f0tSmt2sx8FzVP8CP44FfzOgHRe+p
         iHfhcdKgnCRURW49kWRFjeJx8N6Ns58ewEq38WmRUsYGm+rIh43E6LfJmaPk5E2bJK7P
         0J7n6Fl75BwuA3E1O0S3WuuWPzQZyKSWCGOpYzNZJEL0MFiQt4dHuNNx1z72et3Om7VU
         6eHMdlCsZ/ykxU+EM0tNKM6SMK5bifBeGa8so/FlVS+YoP7htaWfqvswwXEOLwF3QCn6
         /z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EJisOkRU2LFWrcDGE1haBYgrxVOy2iOBRr5zUUIQhb0=;
        b=bvznX0DK52QrDlsZVcH9oMD+hsuI4FJsthA/Y7OAWq6MKulBh0245ltQDg9hpQ39mA
         acJzythr24WKJVnQBo2UKx0a5RDQ5oc2ycnSUKDW7VZQ+Rxek+t8Cq0ME9Vtd/JSVlSu
         kfHqdExxy5jlzppbPGhgCcum5YgOpV4587U9ahWhsJ5KaASkBEbhuxgP0r67q4HZRT4w
         i/tnaG84H2rMKdLYlEhPqm/u9yTh8/ZT0VjmMGUjthRrkph1c67HpF8aiBSYbhP0KYrD
         s6OgfuC8eDW2enfB87hTz9JsDlhJyBZgEuH27sdpUAytvy1fmXex490Q4pQpzCKYjnoI
         m1ig==
X-Gm-Message-State: AOAM530zjaczPKnm2yI51WN2BOpmao85MSXd/+/0RG5UXW+z6Tcv7VXp
        U6vsTs6Z2EPb+zIyUDXFdiu2UuTzl5qP8ddZUiUkgA==
X-Google-Smtp-Source: ABdhPJxgVOCheyyILFqjegp7GUGRVogeiAUh2ROYM1Kb0N9a0fAtjrEf0c+Uw4+MPgaFmlX1GbnGk4jA3mXmYKDxKvk=
X-Received: by 2002:a05:6830:1002:: with SMTP id a2mr12893470otp.144.1623252212597;
 Wed, 09 Jun 2021 08:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com> <20210608150739.7ztstw52ynxh6m5p@gator>
In-Reply-To: <20210608150739.7ztstw52ynxh6m5p@gator>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 9 Jun 2021 16:22:55 +0100
Message-ID: <CA+EHjTxuzSVVk-U20wpw5-JjhyXOFN1sCRv3AhAsd9yNeM8cEg@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
To:     Andrew Jones <drjones@redhat.com>
Cc:     "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>, kernel-team@android.com,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        pbonzini@redhat.com, Will Deacon <will@kernel.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

> I see this series takes the approach we currently have in KVM of masking
> features we don't want to expose to the guest. This approach adds yet
> another "reject list" to be maintained as hardware evolves. I'd rather see
> that we first change KVM to using an accept list, i.e. mask everything and
> then only set what we want to enable. Mimicking that new accept list in
> pKVM, where much less would be enabled, would reduce the amount of
> maintenance needed.

Good point. I agree that having an allow list is preferable to having
a block list. The way this patch series handles system register
accesses is actually an allow list. However, as it is now, features
being exposed to protected guests via the feature registers take the
block list approach. I will fix that to ensure that instead it exposes
a list of allowed features, rather than hiding restricted ones. As you
suggest, this would reduce the amount of maintenance as hardware
evolves and is better for security as well.

As for changing KVM first, I think that that's orthogonal to what this
series is trying to accomplish. Features in pKVM are not controlled or
negotiable by userspace, as it is a fixed virtual platform. When KVM
changes to use allow lists instead, it shouldn't conflict with how
this series works, especially if I fix it to use an allow list
instead.

Thanks for your feedback.

Cheers,
/fuad


> Thanks,
> drew
>
> >
> > This series is based on kvmarm/next and Will's patches for an Initial pKVM user
> > ABI [1]. You can find the applied series here [2].
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
> >
> > For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
> > https://www.youtube.com/watch?v=edqJSzsDRxk
> >
> > [2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1
> >
> > To: kvmarm@lists.cs.columbia.edu
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Quentin Perret <qperret@google.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: kernel-team@android.com
> >
> > Fuad Tabba (13):
> >   KVM: arm64: Remove trailing whitespace in comments
> >   KVM: arm64: MDCR_EL2 is a 64-bit register
> >   KVM: arm64: Fix name of HCR_TACR to match the spec
> >   KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
> >   KVM: arm64: Restore mdcr_el2 from vcpu
> >   KVM: arm64: Add feature register flag definitions
> >   KVM: arm64: Add config register bit definitions
> >   KVM: arm64: Guest exit handlers for nVHE hyp
> >   KVM: arm64: Add trap handlers for protected VMs
> >   KVM: arm64: Move sanitized copies of CPU features
> >   KVM: arm64: Trap access to pVM restricted features
> >   KVM: arm64: Handle protected guests at 32 bits
> >   KVM: arm64: Check vcpu features at pVM creation
> >
> >  arch/arm64/include/asm/kvm_arm.h        |  34 +-
> >  arch/arm64/include/asm/kvm_asm.h        |   2 +-
> >  arch/arm64/include/asm/kvm_host.h       |   2 +-
> >  arch/arm64/include/asm/kvm_hyp.h        |   4 +
> >  arch/arm64/include/asm/sysreg.h         |   6 +
> >  arch/arm64/kvm/arm.c                    |   4 +
> >  arch/arm64/kvm/debug.c                  |   5 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  42 ++
> >  arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/debug-sr.c      |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c   |   6 -
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 114 +++++-
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c      | 501 ++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/vhe/debug-sr.c       |   2 +-
> >  arch/arm64/kvm/pkvm.c                   |  31 ++
> >  arch/arm64/kvm/sys_regs.c               |  62 +--
> >  arch/arm64/kvm/sys_regs.h               |  35 ++
> >  17 files changed, 782 insertions(+), 72 deletions(-)
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
> >
> >
> > base-commit: 35b256a5eebe3ac715b4ea6234aa4236a10d1a88
> > --
> > 2.32.0.rc1.229.g3e70b5a671-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>
