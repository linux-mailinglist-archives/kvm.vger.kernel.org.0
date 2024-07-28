Return-Path: <kvm+bounces-22470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B27CB93E8E9
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 20:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3DF01C20D98
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 18:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C3777109;
	Sun, 28 Jul 2024 18:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="pnBwJN1j"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10BF6F2E8;
	Sun, 28 Jul 2024 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722192370; cv=none; b=mpFHsaUFBYQMi2AGiUnC6kNnNtG6wvv0Z+D9bcZ+8AJNU3WGMvcwtCpSxwkSly2Zv/vsp/DHc1askEBnW1BGYTg1Ms1W9zF+x8mWd7CotsuAUivzt51pq/EZB8bsUlAAzybmuCmkxI2RWPEZUazMtmrxfjoN0P28CJMc9vRY/Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722192370; c=relaxed/simple;
	bh=mhY5V8J8gB/UGyxNjmHjbbLGoVlGOg7JOoBSPBcGpo0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p5DNYc5X8Cztyofing31Mxadere7A1qBgZYS56RwATg+/zRlp4uV72Up2a7NHCseCGdWw8UIwbMwLFmeoTSQxLm2jnvdS+27J0fqS0lPvqiuVGoW4roid7EKEmImu/zIJDCmLqD4noLq0H6P3BAwmTwtplbP7/KlnN6nnToxRpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=pnBwJN1j; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 1103D120002;
	Sun, 28 Jul 2024 21:45:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 1103D120002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1722192356;
	bh=9o/ZHYQE9Ij66yuCyWy+gG83haFDOx+z13e/Jm3klnw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=pnBwJN1jbm1YYoOrc2eLRaKGOMhHelFfy4q3n8cwSJtAEGQhQlnmRg/XMwjRCy4m9
	 2njHXqz8gps8KVY0I98cUMoCZns8W3YwsK8+Gh+cVBAjnQm/Xy4lFOwG3OPK5Yz7JQ
	 NxdeDSzZQYJDS5N5b8orQUb+a7c8e6PIEq0eS6nDCJXoStpBZGWV2QIaUiQ6+HiAg/
	 wMQS16KDygtKrjdie3jok2MV7Lwu7PL5McEit48jt5YzHhUY8xIqOVLmPgYTvOL2z8
	 /yTWiESxZzE41Ksd2q76a9abi11hjdD4IMQxqBPymJxB5GW7BIqICgLlP2ZshEjvSG
	 r72uUPZkqABDg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Sun, 28 Jul 2024 21:45:55 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sun, 28 Jul 2024 21:45:54 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [PATCH v1] MAINTAINERS: add me as reviewer of AF_VSOCK and virtio-vsock
Date: Sun, 28 Jul 2024 21:33:25 +0300
Message-ID: <20240728183325.1295283-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186756 [Jul 28 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:5.0.1,7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/28 16:08:00 #26170679
X-KSMG-AntiVirus-Status: Clean, skipped

I'm working on AF_VSOCK and virtio-vsock.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c0a3d9e93689..2bf0987d87ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24131,6 +24131,7 @@ F:	virt/lib/
 VIRTIO AND VHOST VSOCK DRIVER
 M:	Stefan Hajnoczi <stefanha@redhat.com>
 M:	Stefano Garzarella <sgarzare@redhat.com>
+R:	Arseniy Krasnov <avkrasnov@salutedevices.com>
 L:	kvm@vger.kernel.org
 L:	virtualization@lists.linux.dev
 L:	netdev@vger.kernel.org
@@ -24370,6 +24371,7 @@ F:	drivers/media/test-drivers/vivid/*
 
 VM SOCKETS (AF_VSOCK)
 M:	Stefano Garzarella <sgarzare@redhat.com>
+R:	Arseniy Krasnov <avkrasnov@salutedevices.com>
 L:	virtualization@lists.linux.dev
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.35.0


