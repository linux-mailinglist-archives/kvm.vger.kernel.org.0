Return-Path: <kvm+bounces-4383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F01811C19
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 19:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEC371F2194B
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFE359E29;
	Wed, 13 Dec 2023 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="eQ0Sjs6M"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AAFB2;
	Wed, 13 Dec 2023 10:15:18 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 86F53100009;
	Wed, 13 Dec 2023 20:20:20 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 86F53100009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1702488020;
	bh=LFMnN+kiRRzcxIQfO0sCVj3w5ce0aLsvMu8LL0VRk/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=eQ0Sjs6MyQp4yIIb9BQZQYBSSGmijZSoDa4qyUnApyGqsz1fSjpu49mEa/9TC9PL/
	 LxO+lCKvM9RkQODdNZ6I537IMTNArXe1f5ER55qTlmQEVvLV8H0zHqEjn21DwtvJNj
	 FgKR+W8FMAWRlQQ9OA1VZCYWTI99tU0kj90AcJYkGTjC8ZugWiQqCYuDR0ALfTLmNP
	 n32eeyFlOB50vKOraTNKxJ52Cz6yh22fSc5zRaa9k7iCuI6I7WHanhFBC8upKXPkOU
	 k0XG9Fw66n1pvKBU8s8JyGvPFp1PABsKjQozf9/WwT/YiNAwCzQSHX7Vtw46qpUq2w
	 GwGKwg6lo6JFw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed, 13 Dec 2023 20:20:19 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 13 Dec 2023 20:20:19 +0300
Message-ID: <8e6b06a5-eeb3-84c8-c6df-a8b81b596295@salutedevices.com>
Date: Wed, 13 Dec 2023 20:11:57 +0300
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
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefano Garzarella <sgarzare@redhat.com>, Stefan Hajnoczi
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
 <20231213100518-mutt-send-email-mst@kernel.org>
 <20231213100957-mutt-send-email-mst@kernel.org>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20231213100957-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 182095 [Dec 13 2023]
X-KSMG-AntiSpam-Version: 6.1.0.3
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 7 0.3.7 6d6bf5bd8eea7373134f756a2fd73e9456bb7d1a, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;lore.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/12/13 14:39:00
X-KSMG-LinksScanning: Clean, bases: 2023/12/13 16:50:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/13 16:15:00 #22673827
X-KSMG-AntiVirus-Status: Clean, skipped



On 13.12.2023 18:13, Michael S. Tsirkin wrote:
> On Wed, Dec 13, 2023 at 10:05:44AM -0500, Michael S. Tsirkin wrote:
>> On Wed, Dec 13, 2023 at 12:08:27PM +0300, Arseniy Krasnov wrote:
>>>
>>>
>>> On 13.12.2023 11:43, Stefano Garzarella wrote:
>>>> On Tue, Dec 12, 2023 at 08:43:07PM +0300, Arseniy Krasnov wrote:
>>>>>
>>>>>
>>>>> On 12.12.2023 19:12, Michael S. Tsirkin wrote:
>>>>>> On Tue, Dec 12, 2023 at 06:59:03PM +0300, Arseniy Krasnov wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
>>>>>>>> On Tue, Dec 12, 2023 at 12:16:54AM +0300, Arseniy Krasnov wrote:
>>>>>>>>> Hello,
>>>>>>>>>
>>>>>>>>>                                DESCRIPTION
>>>>>>>>>
>>>>>>>>> This patchset fixes old problem with hungup of both rx/tx sides and adds
>>>>>>>>> test for it. This happens due to non-default SO_RCVLOWAT value and
>>>>>>>>> deferred credit update in virtio/vsock. Link to previous old patchset:
>>>>>>>>> https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
>>>>>>>>
>>>>>>>>
>>>>>>>> Patchset:
>>>>>>>>
>>>>>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>>>>>
>>>>>>> Thanks!
>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> But I worry whether we actually need 3/8 in net not in net-next.
>>>>>>>
>>>>>>> Because of "Fixes" tag ? I think this problem is not critical and reproducible
>>>>>>> only in special cases, but i'm not familiar with netdev process so good, so I don't
>>>>>>> have strong opinion. I guess @Stefano knows better.
>>>>>>>
>>>>>>> Thanks, Arseniy
>>>>>>
>>>>>> Fixes means "if you have that other commit then you need this commit
>>>>>> too". I think as a minimum you need to rearrange patches to make the
>>>>>> fix go in first. We don't want a regression followed by a fix.
>>>>>
>>>>> I see, ok, @Stefano WDYT? I think rearrange doesn't break anything, because this
>>>>> patch fixes problem that is not related with the new patches from this patchset.
>>>>
>>>> I agree, patch 3 is for sure net material (I'm fine with both rearrangement or send it separately), but IMHO also patch 2 could be.
>>>> I think with the same fixes tag, since before commit b89d882dc9fc ("vsock/virtio: reduce credit update messages") we sent a credit update
>>>> for every bytes we read, so we should not have this problem, right?
>>>
>>> Agree for 2, so I think I can rearrange: two fixes go first, then current 0001, and then tests. And send it as V9 for 'net' only ?
>>>
>>> Thanks, Arseniy
>>
>>
>> hmm why not net-next?
> 
> Oh I missed your previous discussion. I think everything in net-next is
> safer.  Having said that, I won't nack it net, either.

So, summarizing all above:
1) This patchset entirely goes to net-next as v9
2) I reorder patches like 3 - 2 - 1 - 4, e.g. two fixes goes first with Fixes tag
3) Add Acked-by: Michael S. Tsirkin <mst@redhat.com> to each patch

@Michael, @Stefano ?

Thanks, Arseniy

> 
>>>>
>>>> So, maybe all the series could be "net".
>>>>
>>>> Thanks,
>>>> Stefano
>>>>
> 

