Return-Path: <kvm+bounces-73103-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GBkyJFEKq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73103-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:09:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37690225A82
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:09:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 00EA1303A3E7
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC7B401484;
	Fri,  6 Mar 2026 17:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9PmJ/P1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B683FB04E;
	Fri,  6 Mar 2026 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772816970; cv=none; b=DNgETedllrUMJLEK1Dm5DSkqVUe14SPulv/e9u3+px5nURGaBvChjbyk0y8LyoykalXVF/VT2VqQAvQA+p1SHHhLdIHlvjglGL5lbUjJy2LXf8/M+/UnJQ5Ls4YESAsG9uZZQwB98Ymi23D17/UbBbuubTDMH3ZGO+j5pmLlp6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772816970; c=relaxed/simple;
	bh=iE8TJ62f6uMzW9uqVWzvpfHVO0KL3OXm+i7JJ3rnjXM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OaaDq2HzQU2iDGJuSWt7IIObMZR3jQG0EBJwTPolF/nJowYaHLOuTyBnaT6gPBRzFoFvNZJZGfXEYqUFWIRaiGSXEVzCKoQY00/ETaiDxLFhosv/PmZyIIC+jSuxvwDt+aoB7MrDTyG6Dwj6R5YI0qmOVls0NKM3mxm/W4xL4dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9PmJ/P1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D72C19425;
	Fri,  6 Mar 2026 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772816969;
	bh=iE8TJ62f6uMzW9uqVWzvpfHVO0KL3OXm+i7JJ3rnjXM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=e9PmJ/P1wJNK7L7GtRPNZ5MY6bM3hiHOfjJ5HcCZarS5eSSXgVVN30Yn3mVVBhBZj
	 pLlsCfDPt8F8FKqPcBGoc+fUS2MZFFeqBOU7HQaZLInf3BwyJfT0Olf578QuaelbCw
	 fvvj4CWDApGkB9PbBtdfWdm3w38W0VYYq4gafaGzE86WA009wIgELwP92lXGWAmzSf
	 v+HAqo8Z5tAiqEn1CjQl1A7QTP8w2DEXdtPlBX/Vk3614c/8xJYXkiyXb/9rIgXM4t
	 4iREMm9wkR03VtDJcm70SgGtUUPYaJbQ2q1XH+oFDtPaTitjj5HdQCA/CO6SJ+JXQK
	 I11X4uIuyBkeg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:00:53 +0000
Subject: [PATCH v10 01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601
 2025-06
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-1-43f7683a0fb7@kernel.org>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
In-Reply-To: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-6ac23
X-Developer-Signature: v=1; a=openpgp-sha256; l=978; i=broonie@kernel.org;
 h=from:subject:message-id; bh=iE8TJ62f6uMzW9uqVWzvpfHVO0KL3OXm+i7JJ3rnjXM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwopL4waf4p9vIMTbtYH6LENXlVn+f/cqmjsa
 Gdyla7fQIqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKKQAKCRAk1otyXVSH
 0JxrB/9RFY+pwbrQCPGwKr6YbGcoYjU1PRHwuApHAbOf28EIZ5uMZf08eL9SqxsVkfel04R2+bs
 QTtPo1HP4dt4Hm8Tgz2+qKEbs+DiIKiEcHQfiBne1a0ifw5KcJmp2/IzpvACHBWdTB9EPAZUxTC
 wMqR6t9HXSR3brPy+4mukOQoQFG5ZiOV16acdUeulDxWngWFx89RJhXy83DLmdbca+2yllaMZWQ
 RonPJZnDaXxTX0uJdw3jdtzmZom3eeWsjTCDJH8AXZL3azOpPzrbsuMV5y3RoiUk3a1HKHqdGPF
 YghzNGPRQ0EvCxWOy7HpmaIstjomKnzaUF0tmmAKQa7Tx/BJ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 37690225A82
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73103-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.917];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

Update the definition of SMIDR_EL1 in the sysreg definition to reflect the
information in DD0601 2025-06. This includes somewhat more generic ways of
describing the sharing of SMCUs, more information on supported priorities
and provides additional resolution for describing affinity groups.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 9d1c21108057..b6586accf344 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3655,11 +3655,15 @@ Field	3:0	BS
 EndSysreg
 
 Sysreg	SMIDR_EL1	3	1	0	0	6
-Res0	63:32
+Res0	63:60
+Field	59:56	NSMC
+Field	55:52	HIP
+Field	51:32	AFFINITY2
 Field	31:24	IMPLEMENTER
 Field	23:16	REVISION
 Field	15	SMPS
-Res0	14:12
+Field	14:13	SH
+Res0	12
 Field	11:0	AFFINITY
 EndSysreg
 

-- 
2.47.3


