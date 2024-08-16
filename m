Return-Path: <kvm+bounces-24373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7999545CF
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D9F21F29680
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB1B14F121;
	Fri, 16 Aug 2024 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXlIJ5Or"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9324514D71A;
	Fri, 16 Aug 2024 09:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723800482; cv=none; b=oSr5MGtTErCS2zWk1bAdeeSzMFNwcG0Lplxd/tVvwmjrul/YowbBv9QvCI9xU81skqDUZoFgi0Axgj4IqjsGRmJGwn/DkGBYmFf7/xTWW/4vzNpWXTfM1zOqNDTga5HsrK0qVRcQ4RkgJZxuemk+M3i2kNu1XshKGhB8wJqoNKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723800482; c=relaxed/simple;
	bh=wSUG6N0b072xD6DUFsCdzV84E/s31xj3kcg6qaEVlJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dG72XpOCzk9hnedDxcJFopjLgVMDuVNsZtOprPXbbhe/s1n6tZEWWsKEDwkwQtglInw5jCQZi691+O3f53qhBy4Kk08fSCc9psAXzm2iZbTuH8bv+QDvjIb4nslr8GEOnMkmCfdjbaCzp6Lbf1W36rEAcYoQHXricaKYqBlB4Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXlIJ5Or; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04744C32782;
	Fri, 16 Aug 2024 09:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723800482;
	bh=wSUG6N0b072xD6DUFsCdzV84E/s31xj3kcg6qaEVlJk=;
	h=From:To:Cc:Subject:Date:From;
	b=aXlIJ5OrC84qslmThKj7xICdmqYSO20BsMqjM5iD/2rYV7QECLQVrqjo6Rl8ImC6P
	 OXGhi8nDwUhBSh0DqqgZVIGedy1053Nn1p8KDRl1Z3GG9AL+6A4CZo31fwo6eMLgY6
	 F8SMXlNokEo8p0Xgpo4Eiirgw7LmPq/WycQIy5dkTbbZyxdCWqyDtAxOH6pjN0d+9B
	 P/Btx23deA/QEDgbyscr0jU+DCoTs0ApXYrH8Pn40zl6Wvu4eL4oj90dOdGeywiJ3w
	 +Lwvt+uQEFasExrXQsa+OFPcKKyuPa0BZcPVnlFzoFSOsvQ5dHCflwdgz0LBgNXwc7
	 33HD+WNcrbyEw==
From: alexs@kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org (open list)
Cc: Alex Shi <alexs@kernel.org>
Subject: [PATCH] KVM: PPC: remove unused varible
Date: Fri, 16 Aug 2024 17:33:12 +0800
Message-ID: <20240816093313.327268-1-alexs@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alex Shi <alexs@kernel.org>

During build testing, we found a error:
/arch/powerpc/kvm/book3s_hv.c:4052:17: error: variable 'loops' set but not used [-Werror,-Wunused-but-set-variable]
                unsigned long loops = 0;
1 error generated.

Remove the unused variable could fix this.

Signed-off-by: Alex Shi <alexs@kernel.org>
Cc: kvm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kvm/book3s_hv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8f7d7e37bc8c..ac27ca4385e4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4049,7 +4049,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	/* Return to whole-core mode if we split the core earlier */
 	if (cmd_bit) {
 		unsigned long hid0 = mfspr(SPRN_HID0);
-		unsigned long loops = 0;
 
 		hid0 &= ~HID0_POWER8_DYNLPARDIS;
 		stat_bit = HID0_POWER8_2LPARMODE | HID0_POWER8_4LPARMODE;
@@ -4061,7 +4060,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 			if (!(hid0 & stat_bit))
 				break;
 			cpu_relax();
-			++loops;
 		}
 		split_info.do_nap = 0;
 	}
-- 
2.43.0


