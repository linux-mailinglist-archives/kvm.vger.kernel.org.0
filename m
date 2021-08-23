Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5F23F4898
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 12:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbhHWKZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 06:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhHWKZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 06:25:05 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16132C061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 03:24:23 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so34972530otf.6
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 03:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k3uARFKW5i95Stpaj6QcX5SJb/gBsd5wlKEHWvxTOlE=;
        b=WC9BKVUPEOP7oxtXFoSslK3UCllSr4wtkJ5GS7jnuiGbxOzFlvh7IZH+Zcvxg89wPQ
         QLL+AV1Z4hLDWp7zZi+e7cgUJ4/d/R04W4gED4FYKdPm7pKrVoqI4OGGkOEK8bvxM6/z
         v8Dytaoxjljppi25q2KvOdmn0mMabXeYaZS8x1psv5tICnFjLs2WJDIJmorv5CkkNZgz
         AM2rNAOhO+sYIr1VYvV3LOMLQDsbUWmDVAY26Dm4YGsZe9HSn0QCtOe4/6wYGomGJiEn
         2NF/PD3DFr7UcQNbwDAl+HdY1Yr+LI+El0+wL+KWzeUftDzjsEjh57ggEak3wLVQl6ym
         f8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k3uARFKW5i95Stpaj6QcX5SJb/gBsd5wlKEHWvxTOlE=;
        b=Ib/o5i4I1udXSC99TaiLxFly6jqjYnxxmu8T6PdzUoWHRdEL8+7FPWaA8EZ63QNkA9
         NrnXJgZDRV0xMexPRFUKE7EcazZ3E/Y3zkWyFDch42A72MOTPthkHuIsGTyU8fihiYCo
         /HofQveGoJuq4BaUGSQKR1voOSX7XMSMkRwLN4Q6gJtdouG5RMJdPoQ8cyUldMBvc5hE
         3bRRjmxBhdEjIEPMuHn9UskOU5bj8ttWyGaa4n2hQ+sqRvcrjqTli611YzAqpjulgefo
         cgOjyCcszEZ8eIjFvw9FclawAKYKuyalXV/dIy3DjbZoRTf9qqXwZJw/w4tRUcQncWX+
         NLTg==
X-Gm-Message-State: AOAM533q5NGCDVJrs2QTaIeVxPicQvfY5UM7OZlOrEFcyH74G1bwRq+U
        o9Y7/awwIKCQAgb9d7jUEI1s3vhuIpHiqFfwVtRi3g==
X-Google-Smtp-Source: ABdhPJw47asjLGg3IHhq6DwkpRq1WK6eZuxYYe87HFmvJkCVR3ngD76xFymCkYMGEPR3xZRntez8Vcl8RXyvpG9rt38=
X-Received: by 2002:a9d:309:: with SMTP id 9mr27320777otv.365.1629714262300;
 Mon, 23 Aug 2021 03:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com> <162945557041.2025988.6137048861111259637.b4-ty@kernel.org>
In-Reply-To: <162945557041.2025988.6137048861111259637.b4-ty@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 23 Aug 2021 11:23:46 +0100
Message-ID: <CA+EHjTzZn+_4VZ+J7gToBv6XYXUBDxmHT0zkHVy+-2RDFY=-wQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/15] KVM: arm64: Fixed features for protected VMs
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, oupton@google.com,
        james.morse@arm.com, drjones@redhat.com, mark.rutland@arm.com,
        alexandru.elisei@arm.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        suzuki.poulose@arm.com, will@kernel.org, pbonzini@redhat.com,
        christoffer.dall@arm.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Aug 20, 2021 at 11:34 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 17 Aug 2021 09:11:19 +0100, Fuad Tabba wrote:
> > Changes since v3 [1]:
> > - Redid calculating restricted values of feature register fields, ensuring that
> >   the code distinguishes between unsigned and (potentially in the future)
> >   signed fields (Will)
> > - Refactoring and fixes (Drew, Will)
> > - More documentation and comments (Oliver, Will)
> > - Dropped patch "Restrict protected VM capabilities", since it should come with
> >   or after the user ABI series for pKVM (Will)
> > - Carried Will's acks
> >
> > [...]
>
> I've taken the first 10 patches of this series in order to
> progress it. I also stashed a fixlet on top to address the
> tracepoint issue.
>
> Hopefully we can resolve the rest of the issues quickly.

Thanks. I am working on a patch series with the remaining patches to
address the issues. Stay tuned :)

Cheers,
/fuad

> [01/15] KVM: arm64: placeholder to check if VM is protected
>         commit: 2ea7f655800b00b109951f22539fe2025add210b
> [02/15] KVM: arm64: Remove trailing whitespace in comment
>         commit: e6bc555c96990046d680ff92c8e2e7b6b43b509f
> [03/15] KVM: arm64: MDCR_EL2 is a 64-bit register
>         commit: d6c850dd6ce9ce4b410142a600d8c34dc041d860
> [04/15] KVM: arm64: Fix names of config register fields
>         commit: dabb1667d8573302712a75530cccfee8f3ffff84
> [05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
>         commit: f76f89e2f73d93720cfcad7fb7b24d022b2846bf
> [06/15] KVM: arm64: Restore mdcr_el2 from vcpu
>         commit: 1460b4b25fde52cbee746c11a4b1d3185f2e2847
> [07/15] KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
>         commit: 12849badc6d2456f15f8f2c93037628d5176810b
> [08/15] KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
>         commit: cd496228fd8de2e82b6636d3d89105631ea2b69c
> [09/15] KVM: arm64: Add feature register flag definitions
>         commit: 95b54c3e4c92b9185b15c83e8baab9ba312195f6
> [10/15] KVM: arm64: Add config register bit definitions
>         commit: 2d701243b9f231b5d7f9a8cb81870650d3eb32bc
>
> Cheers,
>
>         M.
> --
> Without deviation from the norm, progress is not possible.
>
>

On Fri, Aug 20, 2021 at 11:34 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 17 Aug 2021 09:11:19 +0100, Fuad Tabba wrote:
> > Changes since v3 [1]:
> > - Redid calculating restricted values of feature register fields, ensuring that
> >   the code distinguishes between unsigned and (potentially in the future)
> >   signed fields (Will)
> > - Refactoring and fixes (Drew, Will)
> > - More documentation and comments (Oliver, Will)
> > - Dropped patch "Restrict protected VM capabilities", since it should come with
> >   or after the user ABI series for pKVM (Will)
> > - Carried Will's acks
> >
> > [...]
>
> I've taken the first 10 patches of this series in order to
> progress it. I also stashed a fixlet on top to address the
> tracepoint issue.
>
> Hopefully we can resolve the rest of the issues quickly.
>
> [01/15] KVM: arm64: placeholder to check if VM is protected
>         commit: 2ea7f655800b00b109951f22539fe2025add210b
> [02/15] KVM: arm64: Remove trailing whitespace in comment
>         commit: e6bc555c96990046d680ff92c8e2e7b6b43b509f
> [03/15] KVM: arm64: MDCR_EL2 is a 64-bit register
>         commit: d6c850dd6ce9ce4b410142a600d8c34dc041d860
> [04/15] KVM: arm64: Fix names of config register fields
>         commit: dabb1667d8573302712a75530cccfee8f3ffff84
> [05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
>         commit: f76f89e2f73d93720cfcad7fb7b24d022b2846bf
> [06/15] KVM: arm64: Restore mdcr_el2 from vcpu
>         commit: 1460b4b25fde52cbee746c11a4b1d3185f2e2847
> [07/15] KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
>         commit: 12849badc6d2456f15f8f2c93037628d5176810b
> [08/15] KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
>         commit: cd496228fd8de2e82b6636d3d89105631ea2b69c
> [09/15] KVM: arm64: Add feature register flag definitions
>         commit: 95b54c3e4c92b9185b15c83e8baab9ba312195f6
> [10/15] KVM: arm64: Add config register bit definitions
>         commit: 2d701243b9f231b5d7f9a8cb81870650d3eb32bc
>
> Cheers,
>
>         M.
> --
> Without deviation from the norm, progress is not possible.
>
>
