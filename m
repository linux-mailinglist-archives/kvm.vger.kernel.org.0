Return-Path: <kvm+bounces-4796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E880818553
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 11:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 684981C229BA
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CE214AA9;
	Tue, 19 Dec 2023 10:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TF4yIrJm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A4F14A92;
	Tue, 19 Dec 2023 10:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7FFC433C8;
	Tue, 19 Dec 2023 10:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702981928;
	bh=6rYt5wHJJ1PkZxRDZMbvW+Rzr/DmQKT1fLozmyWHiEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TF4yIrJma3NSbsZENLPhuvT/sH+I2z6i/YRJkY4e/DngMtTrl+k7RSueVpmyhUPmK
	 4/PahJ5L5IVNqqNB2NmL9w+jAea8KuKaLezJwZHVGMExLHGK6OCLOHqsZcEqEwZ/12
	 qPS/auAUfoZWiVGWO56av/EdM66CklUEas+jEQw5pjd17g59r1zc+f9FlTXukqjF4d
	 fc+1J0yhwScfUs5zZAlX/aMmL033yd1RDu8r5nF4r/lzIZ5SD6Qm7OOgBu0pn4bkTh
	 N+G8bhTOe7PfUWC0tpOqzWZUVfI5Kwt1pjoOL9lqcJhX6RhceEMqwG/F6e+BGCkSGV
	 gsgharTjiIUvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rFXOP-005Jq2-Sy;
	Tue, 19 Dec 2023 10:32:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Miguel Luis <miguel.luis@oracle.com>
Subject: Re: (subset) [PATCH v11 00/43] KVM: arm64: Nested Virtualization support (FEAT_NV2 only)
Date: Tue, 19 Dec 2023 10:32:02 +0000
Message-Id: <170298189037.3443606.3400166802031595828.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, rmk+kernel@armlinux.org.uk, christoffer.dall@arm.com, oliver.upton@linux.dev, james.morse@arm.com, yuzenghui@huawei.com, darren@os.amperecomputing.com, andre.przywara@arm.com, alexandru.elisei@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, suzuki.poulose@arm.com, chase.conklin@arm.com, miguel.luis@oracle.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 20 Nov 2023 13:09:44 +0000, Marc Zyngier wrote:
> This is the 5th drop of NV support on arm64 for this year, and most
> probably the last one for this side of Christmas.
> 
> For the previous episodes, see [1].
> 
> What's changed:
> 
> [...]

Applied to next, thanks!

[01/43] arm64: cpufeatures: Restrict NV support to FEAT_NV2
        commit: 2bfc654b89c4dd1c372bb2cbba6b5a0eb578d214
[02/43] KVM: arm64: nv: Hoist vcpu_has_nv() into is_hyp_ctxt()
        commit: 111903d1f5b9334d1100e1c6ee08e740fa374d91
[03/43] KVM: arm64: nv: Compute NV view of idregs as a one-off
        commit: 3ed0b5123cd5a2a4f1fe4e594e7bf319e9eaf1da
[04/43] KVM: arm64: nv: Drop EL12 register traps that are redirected to VNCR
        commit: 4d4f52052ba8357f1591cb9bc3086541070711af
[05/43] KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
        commit: 3606e0b2e462164bced151dbb54ccfe42ac6c35b
[06/43] KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
        commit: 60ce16cc122aad999129d23061fa35f63d5b1e9b
[07/43] KVM: arm64: Introduce a bad_trap() primitive for unexpected trap handling
        commit: 2733dd10701abc6ab23d65a732f58fbeb80bd203
[08/43] KVM: arm64: nv: Add EL2_REG_VNCR()/EL2_REG_REDIR() sysreg helpers
        commit: 9b9cce60be85e6807bdb0eaa2f520e78dbab0659
[09/43] KVM: arm64: nv: Map VNCR-capable registers to a separate page
        commit: d8bd48e3f0ee9e1fdba2a2e453155a5354e48a8d
[10/43] KVM: arm64: nv: Handle virtual EL2 registers in vcpu_read/write_sys_reg()
        commit: fedc612314acfebf506e071bf3a941076aa56d10

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



