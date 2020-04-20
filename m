Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C381B0DAB
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 16:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgDTODX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 10:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgDTODW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 10:03:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 918E420722;
        Mon, 20 Apr 2020 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587391401;
        bh=GPT20fEi2/FOGz+OkWS9srVMj+Rsxisj5E5BJqEY3UU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bQ8HBwamtxiv7Lhgcap7xcBV4Jlc9CX5VQNZlpTf0yVkbH9kEl5RE8gBvInvva93g
         L4UulNBvuMdIJR8930Fx1dR/9O25nYqJSi1DKOPDBZoVX9F47jjaSRSr2uWm8H/mMg
         Nsa/xcz6YHHICI8JzH58nRHy4kE+RfdMsNOcJ3ME=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jQX15-004ttw-TP; Mon, 20 Apr 2020 15:03:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 Apr 2020 15:03:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     "Zengtao (B)" <prime.zeng@hisilicon.com>
Cc:     George Cherian <gcherian@marvell.com>, Dave.Martin@arm.com,
        alexandru.elisei@arm.com, andre.przywara@arm.com,
        christoffer.dall@arm.com, james.morse@arm.com,
        jintack@cs.columbia.edu, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com,
        Anil Kumar Reddy H <areddy3@marvell.com>,
        Ganapatrao Kulkarni <gkulkarni@marvell.com>
Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
In-Reply-To: <678F3D1BB717D949B966B68EAEB446ED3A545C71@dggemm526-mbx.china.huawei.com>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
 <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
 <86r1wus7df.wl-maz@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
 <3e84aaf8b757bc5a7685a291e54c232b@kernel.org> <20200417160602.26706917@why>
 <678F3D1BB717D949B966B68EAEB446ED3A545C71@dggemm526-mbx.china.huawei.com>
Message-ID: <dd1283e9b31fd01ac5c9f434aa00d34e@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: prime.zeng@hisilicon.com, gcherian@marvell.com, Dave.Martin@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com, james.morse@arm.com, jintack@cs.columbia.edu, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com, areddy3@marvell.com, gkulkarni@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-18 03:49, Zengtao (B) wrote:
> -----Original Message-----
>> From: Marc Zyngier [mailto:maz@kernel.org]
>> Sent: Friday, April 17, 2020 11:06 PM
>> To: Zengtao (B)
>> Cc: George Cherian; Dave.Martin@arm.com; alexandru.elisei@arm.com;
>> andre.przywara@arm.com; christoffer.dall@arm.com;
>> james.morse@arm.com; jintack@cs.columbia.edu;
>> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
>> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
>> suzuki.poulose@arm.com; Anil Kumar Reddy H; Ganapatrao Kulkarni
>> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
>> Virtualization support
>> 
>> On Thu, 16 Apr 2020 19:22:21 +0100
>> Marc Zyngier <maz@kernel.org> wrote:
>> 
>> > Hi Zengtao,
>> >
>> > On 2020-04-16 02:38, Zengtao (B) wrote:
>> > > Hi Marc:
>> > >
>> > > Got it.
>> > > Really a bit patch set :)
>> >
>> > Well, yeah... ;-)
>> >
>> > >
>> > > BTW, I have done a basic kvm unit test
>> > > git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
>> > > And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
>> > > The psci test failed for some reason, I can't understand why, this
>> > > is only the test result.(find the patch by git bisect + kvm test)
>> >
>> > That it is that mechanical, we should be able to quickly nail that one.
>> >
>> > > My platform: Hisilicon D06 board.
>> > > Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
>> > > Could you help to take a look?
>> >
>> > I'll have a look tomorrow. I'm in the middle of refactoring the series
>> > for 5.7, and things have changed quite a bit. Hopefully this isn't a VHE
>> > vs non-VHE issue.
>> 
>> So I've repeatedly tried with the current state of the NV patches[1],
>> on both an ARMv8.0 system (Seattle) and an ARMv8.2 pile of putrid junk
>> (vim3l). PSCI is pretty happy, although I can only test with at most 8
>> vcpus (GICv2 gets in the way).
>> 
>> Can you please:
>> 
>> - post the detailed error by running the PSCI unit test on its own
> I tried to trace the error, and I found in kernel function 
> kvm_mpidr_to_vcpu,
> casually, mpidr returns zero and we can't get the expected vcpu, and 
> psci
>  test failed due to this.

Can you post the exact error message from the unit test?

> And as I mentioned in my last before, the psci error is introduced by 
> the
>  patch KVM: arm64: VNCR-ize ELR_EL1.(Only test result)
> Maybe you have to try tens of times to reproduce. :)
> Deep into the patch itself, I don't find any connection between the 
> patch
> and the issue.

Me neither, and I haven't managed to reproduce your issue.

>> - test with the current state of the patches
> I test with your nv-5.7-rc1-WIP branch and latest kvm_unit_test, the
> error still exist.

How many vcpus do you create with this PSCI test?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
