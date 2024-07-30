Return-Path: <kvm+bounces-22683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4DC941B85
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 18:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4878B25D8F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 16:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D91A18B46D;
	Tue, 30 Jul 2024 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="U+jckZV0"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D2418801C;
	Tue, 30 Jul 2024 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358381; cv=none; b=Fi0Bqf1bgES+nP6O8JAqTDECsLkxkoDSm6Io99JVudAWkEHy+TRsVJ7yGeSKGLvkSVbdoLspIDPTtIuYFK7iPK8yXGxcbW7bf3MqM+NxLizmt0ze/E08EIg7ohevV7DtnL8eXgzjh++AHtUyb/LV9URG9HsD3vFtL4/SwAnm6RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358381; c=relaxed/simple;
	bh=acYkmx7Yj8SYjPzp076P9isbfl8X0+qYp4Ms1MYvVR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=leLV/ELZZDuTjEbsKC8D/xIHgW3jghIbvNLSUJFhrxz7P7vsVIPlIwOCzouAWdA/VGOYdib4An9iOTRO3F+X0ye/fmvQksSYqs0VV4gSYzBb2L3/VpUN8sBYVlBmYVyCejDwfsrnYFfGYfKmkpArhJDa8s89lAZiy4YQVkbGZt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=U+jckZV0; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 76D6B120007;
	Tue, 30 Jul 2024 19:52:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 76D6B120007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1722358373;
	bh=KLiTVr2w5RM4rRcfqLd3HLJ6BUMlDc+UogIM6fL3jyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=U+jckZV0lF6/nktaviqUpB9QWpKZ06bSA5nKna95gYkPvul1lkIBb2cFM8BYMmUcH
	 TgH+M9jgyeT7zyZVwy23k+SWNWwrWT/lr5O+ZPTuT6JNkY9y2gcngS+k/BAQvbMs+y
	 /djj49R67rVazN97GwFt83B4XsQb9bLhIZ2l6CVmPZsKcAgfXgqccb+h2Tzi0ZpMyx
	 uHDc+OerhWlHH5A3R8UGaTuG0Dk8S8m5EASRDJpXjsvTukCYJfnEkmxrANpd6sovf2
	 YmnPlxpV77UoHxh/tzMKAp22ZTomr05YVr5+EYvc1kP6yl/W+mr9CzBr3Syi4CdcOI
	 c5jQ0wjbYV7lA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Tue, 30 Jul 2024 19:52:53 +0300 (MSK)
Received: from [172.28.192.160] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 30 Jul 2024 19:52:52 +0300
Message-ID: <510e1114-abac-7ad3-c690-94b8b14ffe69@salutedevices.com>
Date: Tue, 30 Jul 2024 19:40:32 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1] MAINTAINERS: add me as reviewer of AF_VSOCK and
 virtio-vsock
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20240728183325.1295283-1-avkrasnov@salutedevices.com>
 <20240730084707.72ff802c@kernel.org>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20240730084707.72ff802c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186794 [Jul 30 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_arrow_text}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;smtp.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/30 15:23:00 #26184428
X-KSMG-AntiVirus-Status: Clean, skipped



On 30.07.2024 18:47, Jakub Kicinski wrote:
> On Sun, 28 Jul 2024 21:33:25 +0300 Arseniy Krasnov wrote:
>> I'm working on AF_VSOCK and virtio-vsock.
> 
> If you want to review the code perhaps you can use lore+lei
> and filter on the paths?
> 
> Adding people to MAINTAINERS is somewhat fraught.

Ah ok, got it.

Thanks, Arseniy

