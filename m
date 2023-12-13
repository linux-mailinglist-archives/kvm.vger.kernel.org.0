Return-Path: <kvm+bounces-4313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4806A810E33
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 11:17:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02BEC281BC6
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 10:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5925225AA;
	Wed, 13 Dec 2023 10:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="Ip6PUfSf"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B05AC;
	Wed, 13 Dec 2023 02:16:43 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id A7AC0120041;
	Wed, 13 Dec 2023 13:16:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A7AC0120041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1702462600;
	bh=fDqSilOxyyIEJK0arkhLr4La7YzBbCeFPREGB3Y8lHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=Ip6PUfSfuh16oihBSfumKZ17VT1OGtIIhv7s4yZRhW+qrTZB62/YKL+NmD5NTyP6x
	 m1TSyjz7LyardqFJ1RXNNrBf3Xd/VPjqOxOAWihX05JHAamk7rku43EC3K4sFYRqGg
	 +IZd+Mzm6o+mdFGXYdDPsT6seKLWodk/SWa9yr9jZFKzev3p9OSs3RQu2h2hen0euf
	 FG7uPCiEB0uJm5CNW1KS/2CcM8wn3K4XzgIefpwh7GpshIGZ5tN2P16gV318QqfYwx
	 Hvaba1e7EgG/tAUrX+GmZTPqRIpslItoJ3HxNnTtdbW3W74VoZDT/MGptK9Ijn2jGW
	 yMPdxXBRm6Ugw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed, 13 Dec 2023 13:16:40 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 13 Dec 2023 13:16:40 +0300
Message-ID: <6b43e38a-d047-6e7a-329c-bbc11aefb99a@salutedevices.com>
Date: Wed, 13 Dec 2023 13:08:19 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v8 0/4] send credit update during setting
 SO_RCVLOWAT
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231211211658.2904268-1-avkrasnov@salutedevices.com>
 <20231212105423-mutt-send-email-mst@kernel.org>
 <d27f22f0-0f1e-e1bb-5b13-a524dc6e94d7@salutedevices.com>
 <20231212111131-mutt-send-email-mst@kernel.org>
 <7b362aef-6774-0e08-81e9-0a6f7f616290@salutedevices.com>
 <ucmekzurgt3zcaezzdkk6277ukjmwaoy6kdq6tzivbtqd4d32b@izqbcsixgngk>
 <402ea723-d154-45c9-1efe-b0022d9ea95a@salutedevices.com>
 <msexilrot3dmvzrsn25zfwmcnbxpsmiuuvktzbnirq34udk6as@pdz6yt4rrjvo>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <msexilrot3dmvzrsn25zfwmcnbxpsmiuuvktzbnirq34udk6as@pdz6yt4rrjvo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 182074 [Dec 13 2023]
X-KSMG-AntiSpam-Version: 6.1.0.3
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 7 0.3.7 6d6bf5bd8eea7373134f756a2fd73e9456bb7d1a, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;lore.kernel.org:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/12/13 07:20:00
X-KSMG-LinksScanning: Clean, bases: 2023/12/13 07:20:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/13 06:29:00 #22674381
X-KSMG-AntiVirus-Status: Clean, skipped



On 13.12.2023 12:41, Stefano Garzarella wrote:
> On Wed, Dec 13, 2023 at 12:08:27PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 13.12.2023 11:43, Stefano Garzarella wrote:
>>> On Tue, Dec 12, 2023 at 08:43:07PM +0300, Arseniy Krasnov wrote:
>>>>
>>>>
>>>> On 12.12.2023 19:12, Michael S. Tsirkin wrote:
>>>>> On Tue, Dec 12, 2023 at 06:59:03PM +0300, Arseniy Krasnov wrote:
>>>>>>
>>>>>>
>>>>>> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
>>>>>>> On Tue, Dec 12, 2023 at 12:16:54AM +0300, Arseniy Krasnov wrote:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>>                                DESCRIPTION
>>>>>>>>
>>>>>>>> This patchset fixes old problem with hungup of both rx/tx sides and adds
>>>>>>>> test for it. This happens due to non-default SO_RCVLOWAT value and
>>>>>>>> deferred credit update in virtio/vsock. Link to previous old patchset:
>>>>>>>> https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
>>>>>>>
>>>>>>>
>>>>>>> Patchset:
>>>>>>>
>>>>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>>>>
>>>>>> Thanks!
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> But I worry whether we actually need 3/8 in net not in net-next.
>>>>>>
>>>>>> Because of "Fixes" tag ? I think this problem is not critical and reproducible
>>>>>> only in special cases, but i'm not familiar with netdev process so good, so I don't
>>>>>> have strong opinion. I guess @Stefano knows better.
>>>>>>
>>>>>> Thanks, Arseniy
>>>>>
>>>>> Fixes means "if you have that other commit then you need this commit
>>>>> too". I think as a minimum you need to rearrange patches to make the
>>>>> fix go in first. We don't want a regression followed by a fix.
>>>>
>>>> I see, ok, @Stefano WDYT? I think rearrange doesn't break anything, because this
>>>> patch fixes problem that is not related with the new patches from this patchset.
>>>
>>> I agree, patch 3 is for sure net material (I'm fine with both rearrangement or send it separately), but IMHO also patch 2 could be.
>>> I think with the same fixes tag, since before commit b89d882dc9fc ("vsock/virtio: reduce credit update messages") we sent a credit update
>>> for every bytes we read, so we should not have this problem, right?
>>
>> Agree for 2, so I think I can rearrange: two fixes go first, then current 0001, and then tests. And send it as V9 for 'net' only ?
> 
> Maybe you can add this to patch 1 if we want it on net:
> 
> Fixes: e38f22c860ed ("vsock: SO_RCVLOWAT transport set callback")
> 
> Then I think that patch should go before patch 2, so we don't need to
> touch that code multiple times.
> 
> so, IMHO the order should be the actual order or 3 - 1 - 2 - 4.
> 
> Another option is to send just 2 & 3 to net, and the rest (1 & 4) to net-next. IMHO should be fine to send the entire series to net with the fixes tag also in patch 1.

Ok, agree that it is good to send whole patchset to net without splitting it.

> 
> Net maintainers and Michael might have a different advice.

Ok

> 
> Thanks,
> Stefano
> 

