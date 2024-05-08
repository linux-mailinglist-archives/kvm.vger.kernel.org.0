Return-Path: <kvm+bounces-16993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 028348BFB42
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 12:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC0971F21603
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 10:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D4081752;
	Wed,  8 May 2024 10:47:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A62F2836D;
	Wed,  8 May 2024 10:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715165279; cv=none; b=MATLTSxwd6RsElsAnXWmxvsqIRljMrD1isVvTCcvI8X6dUdhQ7zaBQOu17xNG9eiHY7+rifV8/zOze1OUzqr8txcknP9ubWAtR2exQ4hre2TWzLbMACEpb2od1+BvPv/VrANOc9Bl64uPGPlUPv+uLbyGkvp6pYMtYveDf9UA70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715165279; c=relaxed/simple;
	bh=+MeneR5VBNEb2SdP/icWDmNsj1Rc5U6B2Yd4fQBwbcc=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=qL9VJj3FoFNDXDtY8bZjFtkxHb7+1YRhiYDkaT0GBnLRQNME0hIMZ7h47rSVWdCYfDIvXCBiN4s1Y8J84+9rM70L3I6cU+fhalJyOvyEk6QkICJstuKQC79E+dII5cgJBzyd+9R+Bqt/KrTThGjwNCuPeWF3bg/17/P5tJiWCcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4VZBgN4rRBz8XrSC;
	Wed,  8 May 2024 18:47:44 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
	by mse-fl1.zte.com.cn with SMTP id 448AleAv005282;
	Wed, 8 May 2024 18:47:40 +0800 (+08)
	(envelope-from cheng.lin130@zte.com.cn)
Received: from mapi (szxlzmapp04[null])
	by mapi (Zmail) with MAPI id mid14;
	Wed, 8 May 2024 18:47:43 +0800 (CST)
Date: Wed, 8 May 2024 18:47:43 +0800 (CST)
X-Zmail-TransId: 2b06663b584fffffffff84b-63ef0
X-Mailer: Zmail v1.0
Message-ID: <20240508184743778PSWkv_r8dMoye7WmZ7enP@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <cheng.lin130@zte.com.cn>
To: <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jiang.yong5@zte.com.cn>, <wang.liang82@zte.com.cn>,
        <jiang.xuexin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBLVk06IGludHJvZHVjZSB2bSdzIG1heF9oYWx0X3BvbGxfbnMgdG8gZGVidWdmcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 448AleAv005282
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 663B5850.000/4VZBgN4rRBz8XrSC

From: Cheng Lin <cheng.lin130@zte.com.cn>

Introduce vm's max_halt_poll_ns and override_halt_poll_ns to
debugfs. Provide a way to check and modify them.

Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
---
 virt/kvm/kvm_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff0a20565..60dae952c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1151,6 +1151,11 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 				    &stat_fops_per_vm);
 	}

+	debugfs_create_bool("override_halt_poll_ns", 0444, kvm->debugfs_dentry,
+			    &kvm->override_halt_poll_ns);
+	debugfs_create_u32("max_halt_poll_ns", 0644, kvm->debugfs_dentry,
+			   &kvm->max_halt_poll_ns);
+
 	kvm_arch_create_vm_debugfs(kvm);
 	return 0;
 out_err:
-- 
2.18.1

