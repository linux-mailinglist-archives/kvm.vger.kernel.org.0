Return-Path: <kvm+bounces-57499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35740B56260
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 19:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE81B567653
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 17:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162F9207DF7;
	Sat, 13 Sep 2025 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redadmin.org header.i=@redadmin.org header.b="vqMmsexm"
X-Original-To: kvm@vger.kernel.org
Received: from www.redadmin.org (ag129037.ppp.asahi-net.or.jp [157.107.129.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4831F872D;
	Sat, 13 Sep 2025 17:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=157.107.129.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757785138; cv=pass; b=CAGaDiciJIdKUCOSUVLLOjsbVyKE9p1BAdTRq7DL52MGghevW61YcohYn/r4mLVHWI1wPA9fdipOnnwAHis7a53jx/Sf3GO0GUeavPsYArKeWuLsqtV1vQf1pqe+lyyOWcMxJnn1HN6pwhktUDe/ccUaYBd+puezY2/7p/hBIEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757785138; c=relaxed/simple;
	bh=dWCb/vnvK0BtdkWp3MFmAB/oC5jsmUMTgwfKeUuN9M0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u3DXNqhfud8blOeoALmirDO7YfR+tqy38Bp8NW1SnQnVqrMk9KmeWnGEl3oOQRSxuRQ8KdkhIVciJ87D36DRvwL7qQx2+fPlNF4veIU4vXkHn0oXCbyOfIrz1du8bjTAMBPTXiboloLdXYs9Y67uO3Gjug5wsU+uVXyDOGYeIpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redadmin.org; spf=pass smtp.mailfrom=redadmin.org; dkim=pass (1024-bit key) header.d=redadmin.org header.i=@redadmin.org header.b=vqMmsexm; arc=pass smtp.client-ip=157.107.129.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redadmin.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redadmin.org
Received: from localhost (localhost [127.0.0.1])
	by www.redadmin.org (Postfix) with ESMTP id 603E2104A17FC;
	Sun, 14 Sep 2025 02:38:54 +0900 (JST)
X-Virus-Scanned: amavis at redadmin.org
Received: from www.redadmin.org ([127.0.0.1])
 by localhost (redadmin.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id mP92b3jo6ITG; Sun, 14 Sep 2025 02:38:49 +0900 (JST)
Received: by www.redadmin.org (Postfix, from userid 1000)
	id CFC8D10B40B73; Sun, 14 Sep 2025 02:38:49 +0900 (JST)
Authentication-Results: www.redadmin.org; arc=none smtp.remote-ip=127.0.0.1
ARC-Seal: i=1; a=rsa-sha256; d=redadmin.org; s=20231208space; t=1757785129;
	cv=none; b=xgednUfirqTXObFn4EDkh9kHjBizEo12aR0ZaSDPdZJJkdiYghFB/cCva/cwc8k2S+eoAR4uXvFeU0RfqF5wYf7rqK99Q01CHY4+LDEeFRYG7C7OmMlD/lF5avVQZmswvwB2Djy3SJInHyT6BCPcaBKmacoN9QqVT6qPFXfZQwA=
ARC-Message-Signature: i=1; a=rsa-sha256; d=redadmin.org; s=20231208space;
	t=1757785129; c=relaxed/relaxed;
	bh=pB4FLnsJZ/3z3o0EVbQQcG9ZUrnntGwHKSlQlpuIDMM=;
	h=DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding; b=P5pIICWkJu04ZCuy9nadqMcpUk3Gd+s7la1r9HR5tg7t62IK3HQPDnMQL7hGFvR+hEYWU/KNhpnssmM1Mq+UuBzSUAs8P2DkhpMu18ZKTyW2CN+T1C2BzkubxD3GKCTOUd3UcpQ3gMc5QzirWxJGq+EAEL/Fri1Cvb77v/xiZuQ=
ARC-Authentication-Results: i=1; www.redadmin.org
DKIM-Filter: OpenDKIM Filter v2.11.0 www.redadmin.org CFC8D10B40B73
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redadmin.org;
	s=20231208space; t=1757785129;
	bh=pB4FLnsJZ/3z3o0EVbQQcG9ZUrnntGwHKSlQlpuIDMM=;
	h=From:To:Cc:Subject:Date:From;
	b=vqMmsexmT4Uaj05vG2wvB5U/IFcdDgpD+rtgXJMg0kvsKdnVqW+M9HmTq8gwJsncc
	 7upuwVaqtFrwOEadLsQK+6JKZ4R9akcz8DkKagNXn8vbtz1OAtgzN1X5ypTtTcuurr
	 xf1ySoTMFxUwJwtld4usHXCZJWzLT7fOAnyOG5BQ=
From: Akiyoshi Kurita <weibu@redadmin.org>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	Akiyoshi Kurita <weibu@redadmin.org>
Subject: [PATCH] docs: wmi: lenovo-wmi-gamezone: fix typo in frequency
Date: Sun, 14 Sep 2025 02:38:45 +0900
Message-ID: <20250913173845.951982-1-weibu@redadmin.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Fix a spelling mistake in lenovo-wmi-gamezone.rst
("freqency" -> "frequency").

No functional change.

Signed-off-by: Akiyoshi Kurita <weibu@redadmin.org>
---
 Documentation/wmi/devices/lenovo-wmi-gamezone.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/wmi/devices/lenovo-wmi-gamezone.rst b/Documentat=
ion/wmi/devices/lenovo-wmi-gamezone.rst
index 997263e51a7d..167548929ac2 100644
--- a/Documentation/wmi/devices/lenovo-wmi-gamezone.rst
+++ b/Documentation/wmi/devices/lenovo-wmi-gamezone.rst
@@ -153,7 +153,7 @@ data using the `bmfdec <https://github.com/pali/bmfdec>=
`_ utility:
     [WmiDataId(1), read, Description("P-State ID.")] uint32 PStateID;
     [WmiDataId(2), read, Description("CLOCK ID.")] uint32 ClockID;
     [WmiDataId(3), read, Description("Default value.")] uint32 defaultvalu=
e;
-    [WmiDataId(4), read, Description("OC Offset freqency.")] uint32 OCOffs=
etFreq;
+    [WmiDataId(4), read, Description("OC Offset frequency")] uint32 OCOffs=
etFreq;
     [WmiDataId(5), read, Description("OC Min offset value.")] uint32 OCMin=
Offset;
     [WmiDataId(6), read, Description("OC Max offset value.")] uint32 OCMax=
Offset;
     [WmiDataId(7), read, Description("OC Offset Scale.")] uint32 OCOffsetS=
cale;
--=20
2.47.3


