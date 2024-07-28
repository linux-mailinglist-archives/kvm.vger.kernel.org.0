Return-Path: <kvm+bounces-22472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 902FB93E96D
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 22:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1BF61C2128A
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 20:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F189877F08;
	Sun, 28 Jul 2024 20:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="JrgBbp/J"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E8054BD4;
	Sun, 28 Jul 2024 20:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722199248; cv=none; b=sqwkjO5/SE3wBzzlp6vgBj0z/FcWu6rsvJB3SwbvJbeKeI9WrMKuEMGs4sV/hsA23/8gAnyOqFvWDLwWnUDWpDS7/3F5xtEJNEprhA3UupMTGH6UJe+Kmy0BxfEw5PbavQB6TyBM7cM8WN/Yk01tUufJH7G4eF4UGN2QWKJA3g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722199248; c=relaxed/simple;
	bh=fo9SxnRqHmWkZ+4Xi5y0iHSeCC+yY2XTdoLtLszvGhg=;
	h=Message-ID:Date:MIME-Version:In-Reply-To:To:CC:From:Subject:
	 Content-Type; b=rbgD9r/0+XjSzc1CZi5Bkseq8J17DZwqf6J/B9OqMdvj9Umum9LvcBIsmEQyR/DHMbpF7Kxpd52bd+YzdBcHmAzEpbceJKsQOHCZJ0SQogCjVjCv4nT5SX4DKTOmEMY0nKgAMiOwKym6XKGmxTspwmqrvS6nF+O74LL0wO4TeoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=JrgBbp/J; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id D762D100004;
	Sun, 28 Jul 2024 23:40:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru D762D100004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1722199234;
	bh=qiJcQnSK+EjYjj6+LyL+4e28HtKf7NXcELPMPziM0TI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:From;
	b=JrgBbp/J/gqP72xMqAgVWV2MYxHIBAZmJkmkosZdbhugqZPs5tP8Raer96lUThaGq
	 BqVO7+48ve2oLt7uBklm1v4avi5H4YYSxgCRIGpjOclSgJS/PZxyhSM97wtCnprmb8
	 Wfd7YjJxwPQ8V5eWAsAoJhtHjQnTXk3s0X/O/lxE+uyKXxRhMKkjiFkup/uytwiPh2
	 RBHajb/uecZokN4tPxgSZHEwGSPDZsYspxJ1HGYnyp/tgUpkmZVwedtayeiggsCRjY
	 B8pS18DFS6Q8q4nDt9vmZTkcWPAIAiKzrBU2IEdG8Qe2VaMmmBlX/OVVlDLIHTdBaW
	 xtlQd8LnNUHCg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Sun, 28 Jul 2024 23:40:34 +0300 (MSK)
Received: from [192.168.1.103] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sun, 28 Jul 2024 23:40:33 +0300
Message-ID: <ce580c81-36a1-8b3b-b73f-1d88c5ec72b6@salutedevices.com>
Date: Sun, 28 Jul 2024 23:28:12 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <20240710212555.1617795-4-amery.hung@bytedance.com>
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
	<ameryhung@gmail.com>, <xiyou.wangcong@gmail.com>, <kernel@sberdevices.ru>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
Subject: Re: [RFC PATCH net-next v6 03/14] af_vsock: support multi-transport
 datagrams
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
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
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/28 19:39:00 #26171428
X-KSMG-AntiVirus-Status: Clean, skipped

Hi Amery

>  /* Transport features flags */
>  /* Transport provides host->guest communication */
> -#define VSOCK_TRANSPORT_F_H2G		0x00000001
> +#define VSOCK_TRANSPORT_F_H2G			0x00000001
>  /* Transport provides guest->host communication */
> -#define VSOCK_TRANSPORT_F_G2H		0x00000002
> -/* Transport provides DGRAM communication */
> -#define VSOCK_TRANSPORT_F_DGRAM		0x00000004
> +#define VSOCK_TRANSPORT_F_G2H			0x00000002
> +/* Transport provides fallback for DGRAM communication */
> +#define VSOCK_TRANSPORT_F_DGRAM_FALLBACK	0x00000004
>  /* Transport provides local (loopback) communication */
> -#define VSOCK_TRANSPORT_F_LOCAL		0x00000008
> +#define VSOCK_TRANSPORT_F_LOCAL			0x00000008

^^^ This is refactoring ?


> +		/* During vsock_create(), the transport cannot be decided yet if
> +		 * using virtio. While for VMCI, it is transport_dgram_fallback.


I'm not English speaker, but 'decided' -> 'detected'/'resolved' ?



Thanks, Arseniy

