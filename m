Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E074B465D7F
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 05:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355557AbhLBEqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 23:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355573AbhLBEqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 23:46:22 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FEEC061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 20:43:00 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id s37so16151285pga.9
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 20:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBjl40eoblEtslotDXg+2znA3v0fTi0Ym3CxNJvfO3s=;
        b=TCckOGN3de8PY6NFcbcSpt8fk++CRE8VftBWP67XQ6mYRi7RqPub6LnWwQM+At6lKJ
         wQxtMC04nGYlAFFE5zE+QvG95XzT27x0S9OzOalW30FZeMzi5/WEVbGUApakPWpwuhDd
         jFXyISCZlJOAnD+7brVTEJ5x10O1QrF6RQV0nAzZLxVeTGi0oULMJ8HZSP5n0n5OofZU
         KiHbiSwmxfodfIfjCcYDwNw5dduiv45dJge/d5dHQtCbYRhSRorirgHAiMgzfek2+l0n
         hwL+PsNX1xKsUlCOm+G0/nMEk7VngYbX/J4TJv8ARc25iX9//IhnN+6cK7piGFbayOWF
         GrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBjl40eoblEtslotDXg+2znA3v0fTi0Ym3CxNJvfO3s=;
        b=4N7k6MsTSkiE/KPjwNP7jB9epVoTVJwxcwcI4UctOcT0aVnxVu/17SPmvz638nRd6H
         Y2YKmCD/XyEHCv9ORHu1tzb/5CaKNrPfg318Rfk8nKlCPuohBhGQmcHTR02E/bhXZdzp
         q+x99Qy1oM3aItjZr33wXjBmAL8cqAqsw/AsJAtnQviNHV3n/1KA3hkIKfYOb2baeeen
         rr7X1pWs7Pp1B2UBf491EqpM3gKslvZGe74vlmgdC0JOnxnmKiY102zrD/MaQSLfP/+P
         gQvvNUlR3Wh7u7CVZ5CvUimw89IJK3Cp+DLbSHm1xEZIWsZ0C8f2cEJhNV3M44nhyuyt
         RiQQ==
X-Gm-Message-State: AOAM532sduZjd0J5ZxIrXLCzk55hfNfoCA+BzC5Vbr8hUb1iHxuV/sZ0
        i4U7MdHLrGjS7gOJWlmxXIhszVc1RVyDJ54GJEOtjw==
X-Google-Smtp-Source: ABdhPJxe4f/ujhOahFLP6qr2iHzh8FVCbjXWHq53ajA7lz1m6Pq5502HFMviU1EboUUbswOwgX8Vt+QD9Mu3lTYrBZ8=
X-Received: by 2002:a62:874b:0:b0:4a8:2df0:1804 with SMTP id
 i72-20020a62874b000000b004a82df01804mr10493744pfe.39.1638420180251; Wed, 01
 Dec 2021 20:43:00 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com> <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <YaeabhZnYNLQcejs@monolith.localdoman> <YaeeJUGRwZN00byk@monolith.localdoman>
In-Reply-To: <YaeeJUGRwZN00byk@monolith.localdoman>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 1 Dec 2021 20:42:44 -0800
Message-ID: <CAAeT=FxWsg-Bgyw4vOMqcq-aZ5LtyFaN-o=OjQSLsEZeLiV+ag@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Eric Auger <eauger@redhat.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Wed, Dec 1, 2021 at 8:09 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> On Wed, Dec 01, 2021 at 03:53:18PM +0000, Alexandru Elisei wrote:
> > Hi Reiji,
> >
> > On Mon, Nov 29, 2021 at 09:32:02PM -0800, Reiji Watanabe wrote:
> > > Hi Eric,
> > >
> > > On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> > > >
> > > > Hi Reiji,
> > > >
> > > > On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > > > > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > > > > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > > > > expose the value for the guest as it is.  Since KVM doesn't support
> > > > > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > > > > exopse 0x0 (PMU is not implemented) instead.
> > > > s/exopse/expose
> > > > >
> > > > > Change cpuid_feature_cap_perfmon_field() to update the field value
> > > > > to 0x0 when it is 0xf.
> > > > is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > > > guest should not use it as a PMUv3?
> > >
> > > > is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > > > guest should not use it as a PMUv3?
> > >
> > > For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> > > Arm ARM says:
> > >   "IMPLEMENTATION DEFINED form of performance monitors supported,
> > >    PMUv3 not supported."
> > >
> > > Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> > > be exposed to guests (And this patch series doesn't allow userspace
> > > to set the fields to 0xf for guests).
> >
> > While it's true that a value of 0xf means that PMUv3 is not present (both
> > KVM and the PMU driver handle it this way) this is an userspace visible
> > change.
> >
> > Are you sure there isn't software in the wild that relies on this value
> > being 0xf to detect that some non-Arm architected hardware is present?
> >
> > Since both 0 and 0xf are valid values that mean that PMUv3 is not present,
> > I think it's best that both are kept.
>
> Sorry, somehow I managed to get myself confused and didn't realize that
> this is only used by KVM.
>
> What I said above about the possibility of software existing that pokes IMP
> DEF registers when PMUVer = 0xf is in fact a good argument for this patch,
> because KVM injects an undefined exception when a guest tries to access
> such registers.

Thank you for your review.  My understanding is the same as yours.

Thanks,
Reiji
