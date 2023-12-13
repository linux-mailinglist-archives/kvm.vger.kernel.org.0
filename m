Return-Path: <kvm+bounces-4309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D4C810D2A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 10:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BADBEB20C94
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3E32030D;
	Wed, 13 Dec 2023 09:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="jgCCcRdt"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B40B7;
	Wed, 13 Dec 2023 01:16:52 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 8608012003B;
	Wed, 13 Dec 2023 12:16:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8608012003B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1702459008;
	bh=lcFAydWJM6e3tNghes74FvbJpEn6IZgN1OI+f3Std2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=jgCCcRdt6cL3fSBkwpnjeGK9vQ6xAbSOhequFl2N7W7Ucqhe25qpK7+nkYlN8DJeO
	 /2rw6cytLJI57FO9GbPMPTnj0VhbEIFwJLskUUSctpGrBDBZ56qACpecMfNTe+I8Pb
	 PXLbevJlom39nARCRJBclA8S/MfU3koD6gaFSs/UyyH3TKkTSSQj993/ekKsD4uZIZ
	 yo8dvtzWovh2teUZxVFsKgjdG/RTHzk2GmeJ5xiDFfTd0fJRi7ig7+CVmMR+JSOiTL
	 qP29CEBT/ujuhuvmpbGaH78UYv97aZndWk6OmONhv1B74BSLKJ3Mnroavu9LBf3Rvv
	 hCfBjKFUE+QYg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed, 13 Dec 2023 12:16:48 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 13 Dec 2023 12:16:48 +0300
Message-ID: <402ea723-d154-45c9-1efe-b0022d9ea95a@salutedevices.com>
Date: Wed, 13 Dec 2023 12:08:27 +0300
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
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <ucmekzurgt3zcaezzdkk6277ukjmwaoy6kdq6tzivbtqd4d32b@izqbcsixgngk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 182073 [Dec 13 2023]
X-KSMG-AntiSpam-Version: 6.1.0.3
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 7 0.3.7 6d6bf5bd8eea7373134f756a2fd73e9456bb7d1a, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;lore.kernel.org:7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/12/13 07:20:00
X-KSMG-LinksScanning: Clean, bases: 2023/12/13 07:20:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/13 06:29:00 #22674381
X-KSMG-AntiVirus-Status: Clean, skipped



On 13.12.2023 11:43, Stefano Garzarella wrote:
> On Tue, Dec 12, 2023 at 08:43:07PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 12.12.2023 19:12, Michael S. Tsirkin wrote:
>>> On Tue, Dec 12, 2023 at 06:59:03PM +0300, Arseniy Krasnov wrote:
>>>>
>>>>
>>>> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
>>>>> On Tue, Dec 12, 2023 at 12:16:54AM +0300, Arseniy Krasnov wrote:
>>>>>> Hello,
>>>>>>
>>>>>>                                DESCRIPTION
>>>>>>
>>>>>> This patchset fixes old problem with hungup of both rx/tx sides and adds
>>>>>> test for it. This happens due to non-default SO_RCVLOWAT value and
>>>>>> deferred credit update in virtio/vsock. Link to previous old patchset:
>>>>>> https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
>>>>>
>>>>>
>>>>> Patchset:
>>>>>
>>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>>
>>>> Thanks!
>>>>
>>>>>
>>>>>
>>>>> But I worry whether we actually need 3/8 in net not in net-next.
>>>>
>>>> Because of "Fixes" tag ? I think this problem is not critical and reproducible
>>>> only in special cases, but i'm not familiar with netdev process so good, so I don't
>>>> have strong opinion. I guess @Stefano knows better.
>>>>
>>>> Thanks, Arseniy
>>>
>>> Fixes means "if you have that other commit then you need this commit
>>> too". I think as a minimum you need to rearrange patches to make the
>>> fix go in first. We don't want a regression followed by a fix.
>>
>> I see, ok, @Stefano WDYT? I think rearrange doesn't break anything, because this
>> patch fixes problem that is not related with the new patches from this patchset.
> 
> I agree, patch 3 is for sure net material (I'm fine with both rearrangement or send it separately), but IMHO also patch 2 could be.
> I think with the same fixes tag, since before commit b89d882dc9fc ("vsock/virtio: reduce credit update messages") we sent a credit update
> for every bytes we read, so we should not have this problem, right?

Agree for 2, so I think I can rearrange: two fixes go first, then current 0001, and then tests. And send it as V9 for 'net' only ?

Thanks, Arseniy

> 
> So, maybe all the series could be "net".
> 
> Thanks,
> Stefano
> 

