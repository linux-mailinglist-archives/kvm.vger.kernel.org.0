Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3B61ACF88
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 20:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgDPSWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 14:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgDPSWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 14:22:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D55042222D;
        Thu, 16 Apr 2020 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587061344;
        bh=6zrtXU9CGPRKE5NSlsMwz1LYWf6+ZBpckIQKGAKC7K8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HiRIy1z1b/9U9K+HKP8HUDXGPoNL44r3nyxvBq85trtY+XWWj6ob8+0lfJFRnW0H3
         xfrIzxGX3t37kXQ5lYZE/Dqk9a5OD4UMRUfqJoTwM5pf/dVoOf37Zft4sSvRmAP3Yz
         uAPsq677yjr3o4m7tOWUz+zx5md6spR3xPjkCFqk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jP99a-003xpV-12; Thu, 16 Apr 2020 19:22:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 16 Apr 2020 19:22:21 +0100
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
In-Reply-To: <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
 <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
 <86r1wus7df.wl-maz@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
Message-ID: <3e84aaf8b757bc5a7685a291e54c232b@kernel.org>
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

Hi Zengtao,

On 2020-04-16 02:38, Zengtao (B) wrote:
> Hi Marc:
> 
> Got it.
> Really a bit patch set :)

Well, yeah... ;-)

> 
> BTW, I have done a basic kvm unit test
> git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
> The psci test failed for some reason, I can't understand why, this
> is only the test result.(find the patch by git bisect + kvm test)

That it is that mechanical, we should be able to quickly nail that one.

> My platform: Hisilicon D06 board.
> Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
> Could you help to take a look?

I'll have a look tomorrow. I'm in the middle of refactoring the series
for 5.7, and things have changed quite a bit. Hopefully this isn't a VHE
vs non-VHE issue.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
