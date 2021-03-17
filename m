Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B934A33F326
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 15:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCQOkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 10:40:25 -0400
Received: from foss.arm.com ([217.140.110.172]:34576 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232228AbhCQOkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 10:40:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE30EED1;
        Wed, 17 Mar 2021 07:40:09 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08F8F3F792;
        Wed, 17 Mar 2021 07:40:08 -0700 (PDT)
Date:   Wed, 17 Mar 2021 14:40:04 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] irqchip/gic-v4.1: Disable vSGI upon (GIC CPUIF <
 v4.1) detection
Message-ID: <20210317144004.GA6593@e121166-lin.cambridge.arm.com>
References: <20210302102744.12692-1-lorenzo.pieralisi@arm.com>
 <20210317100719.3331-1-lorenzo.pieralisi@arm.com>
 <20210317100719.3331-2-lorenzo.pieralisi@arm.com>
 <87blbhj2q3.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blbhj2q3.wl-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021 at 02:04:36PM +0000, Marc Zyngier wrote:
> Hi Lorenzo,
> 
> Wed, 17 Mar 2021 10:07:19 +0000,
> Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> > 
> > GIC CPU interfaces versions predating GIC v4.1 were not built to
> > accommodate vINTID within the vSGI range; as reported in the GIC
> > specifications (8.2 "Changes to the CPU interface"), it is
> > CONSTRAINED UNPREDICTABLE to deliver a vSGI to a PE with
> > ID_AA64PFR0_EL1.GIC < b0011.
> > 
> > Check the GIC CPUIF version by reading the SYS_ID_AA64_PFR0_EL1.
> > 
> > Disable vSGIs if a CPUIF version < 4.1 is detected to prevent using
> > vSGIs on systems where they may misbehave.
> > 
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> 
> Does it need to go in as a fix? or can it just be pushed into 5.13?
> Given that there is no such HW in the wild just yet, I'm inclined to
> do the latter...

I agree with you; it is to make the driver/vgic robust against HW
misconfigurations (because that's what they are and I am not aware of
any _existing_ HW with such a misconfiguration - yet), 5.13 will
perfectly do.

Thanks a lot.

Lorenzo
