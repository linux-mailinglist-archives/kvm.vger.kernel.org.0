Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D391AE06D
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 17:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgDQPGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 11:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgDQPGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 11:06:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6BA320857;
        Fri, 17 Apr 2020 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587135966;
        bh=VD3NiQgcjY0DUGZAjRsEC+ytO3vlZSGq4k2zQEHZ9AA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O49ELBs/WQwrUBMUrrWH4KUCznZ97VVDgy2iJ4DWXor8xO8MHIdT4DU86vRFhhNR6
         N2JtD2m1ZBMRnc4vrajOj2f438b4/hQbXGP+fXuoconP7Ok+MOgGQKWCHg72xCfulK
         kBvzxccuHjPTkz0ZqdO/vA4B7W0w2Grr+LCLnD2w=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jPSZA-004DB1-9N; Fri, 17 Apr 2020 16:06:04 +0100
Date:   Fri, 17 Apr 2020 16:06:02 +0100
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
Message-ID: <20200417160602.26706917@why>
In-Reply-To: <3e84aaf8b757bc5a7685a291e54c232b@kernel.org>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
        <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
        <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
        <86r1wus7df.wl-maz@kernel.org>
        <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
        <3e84aaf8b757bc5a7685a291e54c232b@kernel.org>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: prime.zeng@hisilicon.com, gcherian@marvell.com, Dave.Martin@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com, james.morse@arm.com, jintack@cs.columbia.edu, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com, areddy3@marvell.com, gkulkarni@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Apr 2020 19:22:21 +0100
Marc Zyngier <maz@kernel.org> wrote:

> Hi Zengtao,
> 
> On 2020-04-16 02:38, Zengtao (B) wrote:
> > Hi Marc:
> > 
> > Got it.
> > Really a bit patch set :)  
> 
> Well, yeah... ;-)
> 
> > 
> > BTW, I have done a basic kvm unit test
> > git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> > And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
> > The psci test failed for some reason, I can't understand why, this
> > is only the test result.(find the patch by git bisect + kvm test)  
> 
> That it is that mechanical, we should be able to quickly nail that one.
> 
> > My platform: Hisilicon D06 board.
> > Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
> > Could you help to take a look?  
> 
> I'll have a look tomorrow. I'm in the middle of refactoring the series
> for 5.7, and things have changed quite a bit. Hopefully this isn't a VHE
> vs non-VHE issue.

So I've repeatedly tried with the current state of the NV patches[1],
on both an ARMv8.0 system (Seattle) and an ARMv8.2 pile of putrid junk
(vim3l). PSCI is pretty happy, although I can only test with at most 8
vcpus (GICv2 gets in the way).

Can you please:

- post the detailed error by running the PSCI unit test on its own
- test with the current state of the patches

Thanks,

	M.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-5.7-rc1-WIP
-- 
Jazz is not dead. It just smells funny...
