Return-Path: <kvm+bounces-22212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F28B793BCB1
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 08:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30C4F1C216AA
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 06:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43D816DED1;
	Thu, 25 Jul 2024 06:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="e1WSj6n7"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728E916D32C;
	Thu, 25 Jul 2024 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721889700; cv=none; b=GvxKeFacLn5H0qCUVS/G6x/TalSZTEkDUiJZ/qladwSEhDJmRYzVMvYxpgIIXOWrP8bF5hhNKcbxgUb/pwBEUqwac7vkhzrTlunVzYpEIycndfSf+8vsW7PTLNmGrbO3usUMKT0HUVooDm7W/uQVLSCljy4AwWfN/gNuv7BTTA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721889700; c=relaxed/simple;
	bh=rAVu9ZElq2tHrFn2OocNT/B8uUEx8GhOMKP/3T/ippQ=;
	h=Message-ID:Date:MIME-Version:In-Reply-To:To:CC:From:Subject:
	 Content-Type; b=A7CvCXIpPSRbqpLjmxbP8/NJgPWQUW+KxbVwyRIY1eFO98tArBtirWSvHYsvSCozvHxm443iAKVHxuJgiO0GHf2KjpcPyb0gMYC7bfwQcoEnl7Ga/687E/M7+DGsltRzRTClLgYF5RvTN4G5e3+UR/565Zu8Ff+mQk4xIo7w3+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=e1WSj6n7; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 5AC2A120010;
	Thu, 25 Jul 2024 09:41:25 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 5AC2A120010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1721889685;
	bh=jFOZBtASNS8TD+cMyjYdZRjS87a0iHpCBSElLaKs7aQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:From;
	b=e1WSj6n72ah5AKw6aDdw2DQiwtn86ftA4q4Z2fO84ADOVy40UGZEE3Q22XggVXW+9
	 gzXtuDHbiqGg41nozJh2wWO/CgBD+HvFwK5kuClMxL2p3I4XFBYoYVgpwwa+c5jgJC
	 O56pc747ZwxEvEj8XhL3n3q9n04L1wNPkX5uZx/epDvFvclKmOpxoo/mWtTwopfKLg
	 RqXrPCfQrDrv4HxhHYAsnwWAbMMFfihXOZdizZlhMSPSo1IUc/3rp2jyPX1bfXhRJZ
	 EiQ+AJiDwF8RHXvXEjUWxrVOIkYpwLEP1HIvcXKM13R2BRzlrZvKL2/rZUfRttc+wf
	 /1f21J8Z6qzAQ==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu, 25 Jul 2024 09:41:25 +0300 (MSK)
Received: from [172.28.192.160] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 25 Jul 2024 09:41:23 +0300
Message-ID: <8d7dc8cb-0211-8e20-2391-c16d266b8be6@salutedevices.com>
Date: Thu, 25 Jul 2024 09:29:10 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <20240710212555.1617795-3-amery.hung@bytedance.com>
To: <stefanha@redhat.com>, <sgarzare@redhat.com>, <mst@redhat.com>,
	<jasowang@redhat.com>, <xuanzhuo@linux.alibaba.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <wei.liu@kernel.org>,
	<decui@microsoft.com>, <bryantan@vmware.com>, <vdasa@vmware.com>,
	<pv-drivers@vmware.com>
CC: <dan.carpenter@linaro.org>, <simon.horman@corigine.com>,
	<oxffffaa@gmail.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<bpf@vger.kernel.org>, <bobby.eshleman@bytedance.com>,
	<jiang.wang@bytedance.com>, <amery.hung@bytedance.com>,
	<ameryhung@gmail.com>, <xiyou.wangcong@gmail.com>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
Subject: [RFC PATCH net-next v6 02/14] af_vsock: refactor transport lookup
 code
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186705 [Jul 25 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/24 23:24:00 #26143731
X-KSMG-AntiVirus-Status: Clean, skipped

Hi

+static const struct vsock_transport *
+vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
                                                      ^^^ may be just 'u8' ?
+{
+	const struct vsock_transport *transport;
                                       ^^^ do we really need this variable now?
                                       May be shorter like:
                                       if (A)
                                           return transport_local;
                                       else if (B)
                                           return transport_g2h;
                                       else
                                           return transport_h2g;
+
+	if (vsock_use_local_transport(cid))
+		transport = transport_local;
+	else if (cid <= VMADDR_CID_HOST || !transport_h2g ||
+		 (flags & VMADDR_FLAG_TO_HOST))
+		transport = transport_g2h;
+	else
+		transport = transport_h2g;
+
+	return transport;
+}
+

Thanks

