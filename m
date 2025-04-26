Return-Path: <kvm+bounces-44427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC082A9DA9B
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DAC71BA745F
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780FD2522B3;
	Sat, 26 Apr 2025 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdQuYbdx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9959D2512F5;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670534; cv=none; b=tUmC8dFgeK700eQQo+TpB7LDiE/KnOBrxprFcMv7/Vz2JqW26xwWsUCAllvMGYPvJq5JDLoLXnE6Z+SXVd3wKGieV28dOVsOFQ0GFH8cMIAZv6cjFLovV4j1c1FNbj0gmWrm4V6paUAEsudpUgmolxBacVkmJyxoLYHR46mdvLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670534; c=relaxed/simple;
	bh=Uxgz86q4vttcqou3lbEa8mbH5Xk35X47+RPO2LMlXkk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hwtxhPSV3KW7LUDiqCRePU9pLxKC2ty5PvFLjMQgRcSpBQT3hA7ZQs2yn4ya6EPJ7dHVrwNSdhM/Kms9uJnTcsZW63jNSYI7WxeNX9JftkBIlkTPYIq97z4cLAXxTuxewbCT7ENraOzmQ4ZVu7JYS+r624G8Gb7hfaAXWe7f6g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdQuYbdx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7470BC4CEEC;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670534;
	bh=Uxgz86q4vttcqou3lbEa8mbH5Xk35X47+RPO2LMlXkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdQuYbdxcKyau7PSbfz8GgotYQ0d4XCoE7ZH/PaR17p6qpEvWfqYssMiNN9Pte/tv
	 KKbkMmS9Do/MgtFAce8M3nz2Q/wplZNAP0gbwaDP306vmxhy9wmHdw+8G3u5RWz9X+
	 CekYPwUDNLr70IPeU1DiKrmvpmkMxxJJ9QjqcRi6lhrhw3Ab5SXg9iAWNMtRiMOOQ7
	 48P2IoloewPk69eJh1y0qEkuburu1VxnjTAhwn/k4wQTW1wgVCKsf1W3qEx+bd3PU2
	 WsxWM1PJhGP8BXski5SikAhh6Sv2Jy6J5apjxoazthGP5Xr693qU0mHZ0NZC/4knWK
	 Ry2PBF3atuKKg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeK-0092VH-JQ;
	Sat, 26 Apr 2025 13:28:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 15/42] KVM: arm64: Tighten handling of unknown FGT groups
Date: Sat, 26 Apr 2025 13:28:09 +0100
Message-Id: <20250426122836.3341523-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

triage_sysreg_trap() assumes that it knows all the possible values
for FGT groups, which won't be the case as we start adding more
FGT registers (unless we add everything in one go, which is obviously
undesirable).

At the same time, it doesn't offer much in terms of debugging info
when things go wrong.

Turn the "__NR_FGT_GROUP_IDS__" case into a default, covering any
unhandled value, and give the kernel hacker a bit of a clue about
what's wrong (system register and full trap descriptor).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index efe1eb3f1bd07..1bcbddc88a9b7 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2352,9 +2352,10 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		}
 		break;
 
-	case __NR_FGT_GROUP_IDS__:
+	default:
 		/* Something is really wrong, bail out */
-		WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
+		WARN_ONCE(1, "Bad FGT group (encoding %08x, config %016llx)\n",
+			  sysreg, tc.val);
 		goto local;
 	}
 
-- 
2.39.2


