Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367892D78BB
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 16:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390936AbgLKPES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 10:04:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437554AbgLKPDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 10:03:11 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9569229C4;
        Fri, 11 Dec 2020 15:01:55 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=wait-a-minute.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knjve-000TxV-6W; Fri, 11 Dec 2020 15:01:54 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     shawnguo@kernel.org, linux@rasmusvillemoes.dk, leoyang.li@nxp.com,
        mark.rutland@arm.com, zhiqiang.hou@nxp.com,
        Biwen Li <biwen.li@oss.nxp.com>, robh+dt@kernel.org,
        tglx@linutronix.de, kvmarm@lists.cs.columbia.edu,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Shenming Lu <lushenming@huawei.com>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     xiaobo.xie@nxp.com, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        devicetree@vger.kernel.org, Biwen Li <biwen.li@nxp.com>,
        jiafei.pan@nxp.com, yuzenghui@huawei.com,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH v2 0/2] KVM: arm64: Optimize the wait for the completion of the VPT analysis
Date:   Fri, 11 Dec 2020 15:01:39 +0000
Message-Id: <160769813659.482133.2716418035359567004.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201128141857.983-1-lushenming@huawei.com>
References: <20201128141857.983-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: shawnguo@kernel.org, linux@rasmusvillemoes.dk, leoyang.li@nxp.com, mark.rutland@arm.com, zhiqiang.hou@nxp.com, biwen.li@oss.nxp.com, robh+dt@kernel.org, tglx@linutronix.de, kvmarm@lists.cs.columbia.edu, will@kernel.org, kvm@vger.kernel.org, eric.auger@redhat.com, christoffer.dall@arm.com, linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com, lushenming@huawei.com, james.morse@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, julien.thierry.kdev@gmail.com, xiaobo.xie@nxp.com, Zhiqiang.Hou@nxp.com, devicetree@vger.kernel.org, biwen.li@nxp.com, jiafei.pan@nxp.com, yuzenghui@huawei.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 28 Nov 2020 22:18:55 +0800, Shenming Lu wrote:
> Right after a vPE is made resident, the code starts polling the
> GICR_VPENDBASER.Dirty bit until it becomes 0, where the delay_us
> is set to 10. But in our measurement, it takes only hundreds of
> nanoseconds, or 1~2 microseconds, to finish parsing the VPT in most
> cases. What's more, we found that the MMIO delay on GICv4.1 system
> (HiSilicon) is about 10 times higher than that on GICv4.0 system in
> kvm-unit-tests (the specific data is as follows).
> 
> [...]

Applied to irq/irqchip-next, thanks!

[1/2] irqchip/gic-v4.1: Reduce the delay time of the poll on the GICR_VPENDBASER.Dirty bit
      commit: 0b39498230ae53e6af981141be99f4c7d5144de6

Patch 2 will be routed via the KVM/arm64 tree.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


