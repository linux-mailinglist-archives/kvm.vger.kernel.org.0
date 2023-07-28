Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB7376665E
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbjG1IHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbjG1IGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:06:24 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E43C3A8C;
        Fri, 28 Jul 2023 01:05:59 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 3EF65120008;
        Fri, 28 Jul 2023 11:05:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 3EF65120008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690531557;
        bh=pxmpm6ehJB6yrppCYchV6OYzSRmL4h9Nwe7yz4TJX7U=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=T1WzpL//7RykxP3nVZxJqwmjY9QrHUciBG8aRwhT1L13GginezvhTdDIVwdyaPAl8
         5qJHF2rniEmeGAg5ic1xECJCwr45z5ttPWRait6pIqxwtlwgC/JYrwiVPSFrFJPDs3
         iS36wYP4m3goHRtoCzSbRWMa/lZq3Rc1PkHLfkYuwdTFMKvO5MLJ5plVbSni4oiGo1
         zt05hRLGeW/nd6SB8SZnoqKsi4Ruj9ODBEBbf4Nv7H6pcRJuQaoZbCnrZTVTrGl0h4
         XVh+jEl5wzxneAE0iniFlR/aU6wFt9wVbPnAhmWmTv5Y29Qt53bbXW3R+4HuV0cmzS
         L+BEVrKXu1SDw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri, 28 Jul 2023 11:05:57 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 28 Jul 2023 11:05:33 +0300
Message-ID: <eeefef14-2c92-a7a6-e58e-77dccbe38282@sberdevices.ru>
Date:   Fri, 28 Jul 2023 11:00:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v4 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230727222627.1895355-1-AVKrasnov@sberdevices.ru>
 <20230728012845-mutt-send-email-mst@kernel.org>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230728012845-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178796 [Jul 22 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/07/23 10:45:00
X-KSMG-LinksScanning: Clean, bases: 2023/07/23 10:46:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.07.2023 08:45, Michael S. Tsirkin wrote:
> On Fri, Jul 28, 2023 at 01:26:23AM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>> this patchset is first of three parts of another big patchset for
>> MSG_ZEROCOPY flag support:
>> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
> 
> overall looks good. Two points I'd like to see addressed:

Thanks!

> - what's the performance with all these changes - still same?

Yes, I perform quick tests and seems result are same. This is because last
implemented logic when I compare size of payload against 'num_max' is
for "emergency" case and not triggered in default environment. Anyway, I'll
perform retest at least in nested guest case.

> - most systems have a copybreak scheme where buffers
>   smaller than a given size are copied directly.
>   This will address regression you see with small buffers -
>   but need to find that value. we know it's between 4k and 32k :)

I see, You suggest to find this value and add this check for decision to
use zerocopy or copy ?

Thanks, Arseniy

> 
> 
>> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>> suggested to split it for three parts to simplify review and merging:
>>
>> 1) virtio and vhost updates (for fragged skbs) <--- this patchset
>> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>>    tx completions) and update for Documentation/.
>> 3) Updates for tests and utils.
>>
>> This series enables handling of fragged skbs in virtio and vhost parts.
>> Newly logic won't be triggered, because SO_ZEROCOPY options is still
>> impossible to enable at this moment (next bunch of patches from big
>> set above will enable it).
>>
>> I've included changelog to some patches anyway, because there were some
>> comments during review of last big patchset from the link above.
>>
>> Head for this patchset is 9d0cd5d25f7d45bce01bbb3193b54ac24b3a60f3
>>
>> Link to v1:
>> https://lore.kernel.org/netdev/20230717210051.856388-1-AVKrasnov@sberdevices.ru/
>> Link to v2:
>> https://lore.kernel.org/netdev/20230718180237.3248179-1-AVKrasnov@sberdevices.ru/
>> Link to v3:
>> https://lore.kernel.org/netdev/20230720214245.457298-1-AVKrasnov@sberdevices.ru/
>>
>> Changelog:
>>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>>  * See per-patch changelog after ---.
>>
>> Arseniy Krasnov (4):
>>   vsock/virtio/vhost: read data from non-linear skb
>>   vsock/virtio: support to send non-linear skb
>>   vsock/virtio: non-linear skb handling for tap
>>   vsock/virtio: MSG_ZEROCOPY flag support
>>
>>  drivers/vhost/vsock.c                   |  14 +-
>>  include/linux/virtio_vsock.h            |   6 +
>>  net/vmw_vsock/virtio_transport.c        |  79 +++++-
>>  net/vmw_vsock/virtio_transport_common.c | 312 ++++++++++++++++++------
>>  4 files changed, 330 insertions(+), 81 deletions(-)
>>
>> -- 
>> 2.25.1
> 
