Return-Path: <kvm+bounces-43254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D5EA888F7
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 18:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97EB117BB6B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B3E288C89;
	Mon, 14 Apr 2025 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Op39d3Et"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE54A284687;
	Mon, 14 Apr 2025 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744649524; cv=none; b=tH/ryjNAlUYXTEe7Gf44LqOekbsQqKI53nS0WMHjl65116KLCYMJCkmh8CsiAIqT1v+/JN93COSSdK24kzOy1V2rbKUpHXaIfwOk9ZTy0JMXIXJ1iA2T8uinSBRaWBlc56bjyyUJA3mOzfuk3sBoZq5lwTun3eXbEliVz/pmLyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744649524; c=relaxed/simple;
	bh=R1S7RaWPVlRAT0t1ZYmVJuTwQHq6TQH0O6oceEPyRdk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=POXY0mN4VTvQ2dWq3Vq1La/Kpnk8TDIMKfhwd4gj24KCdxS+VAPkewNeSMkA1hTa+pUyVBHjk10+Yiy4h3IhaX7aH2t/UatCB4o62lI/JMn3LYrJFXM6murFz0kX9DZfpIvtbfyDoMDG42cpdfLCDEnnyBI/7OK8kBaLmPieR98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Op39d3Et; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53EGplm52279462
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 14 Apr 2025 09:51:52 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53EGplm52279462
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1744649512;
	bh=DLT/9k/43vpfkMEjnFjZcZUM16eyzAR8pgDlAvfPvV4=;
	h=From:To:Cc:Subject:Date:From;
	b=Op39d3EtffbM9p3nA/uzskL6aLReK3r4w16UunCt2ZcEEf84yXE47aKCyVFE9GHcR
	 FlMaWCOWQ/+UF0u8JubPD8jbpluNJk0DthuLQB6k3h+qARJgpbiDCMXNF8DFucVkw5
	 I7f1wahgdonx2PMuBSDQfAdza6tHXRIESX5BNcf7nn9kUQLtQ4X1c13oREm7ED2LI5
	 o2C8zwvIRP9x4LDn5HTxla0pkvvS+dHbo1PriOw3H8wrs/MVNQ8OhFd1HZJif0cMnV
	 oohWQ5X5DXRsswAaVOxUnQ+LEp+3fDhuuahjyDv/eQiW0qsGLMS/dD0S3ztxlYdRbb
	 ov1rqKYNgL8RQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, corbet@lwn.net
Subject: [PATCH v1 1/1] Documentation: kvm: Fix a section number
Date: Mon, 14 Apr 2025 09:51:46 -0700
Message-ID: <20250414165146.2279450-1-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous section is 7.41, thus this should be 7.42.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 47c7c3f92314..58478b470860 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8478,7 +8478,7 @@ ENOSYS for the others.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
-7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
+7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
 -------------------------------------
 
 :Architectures: arm64

base-commit: 8ffd015db85fea3e15a77027fda6c02ced4d2444
-- 
2.49.0


