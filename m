Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A45E768489
	for <lists+kvm@lfdr.de>; Sun, 30 Jul 2023 11:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjG3JDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jul 2023 05:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjG3JDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jul 2023 05:03:08 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BE0D1;
        Sun, 30 Jul 2023 02:03:04 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id CC809100004;
        Sun, 30 Jul 2023 12:03:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru CC809100004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690707781;
        bh=MtL8wPniwo65aKavq2K+GHyI8+05gR+igtpRIHhgXG4=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=iLzsMWye/oaM7hTmDb4pot0WXAfidewjzU+HTPWSUWzZmAIimWsQGAonGqppYQvJ8
         uzY2oAlOVWQOrPj0AG9KrVdncUmt2GrQr7XgReIH3VcHu4iYAybVeHkv5Mr1HlqLjK
         UYcvhmGCfPSvJt4vkwbpdwTT0i+KH6sd6/yuBS2eOUytJjHMsOTSRxIsvqETRHRfp7
         ER7gZNaoCfZDiMksBp4SUKsYbPWu3Gw8zC/PjdV2I3QESCmf7TpSovxOJ3koZ4yzzY
         4TandjtWQaAeGbD3S6UGsLDSXoE3roqtcNBG2wo8UkT5X/eGYFUZFWV1LPm70TLx9i
         UQAs7lBAZ7xIg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sun, 30 Jul 2023 12:03:01 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sun, 30 Jul 2023 12:02:21 +0300
Message-ID: <9fa21e91-f92d-03a2-aac6-cfa378fb84eb@sberdevices.ru>
Date:   Sun, 30 Jul 2023 11:57:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v4 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
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
Content-Language: en-US
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230728012845-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
> - what's the performance with all these changes - still same?

Hello Michael,

here are results on the last version:

There is some difference between these numbers and numbers from link
(it was v3). Looks like new version of zerocopy become slower on big
buffers. But anyway it is faster than copy mode in all cases (except
<<<<<< marked line below, but I had same result for this testcase in v3
before).

I tried to find reason of this difference by switching to v3 version, but
seems it is no easy - I get current results again. I guess reason maybe:
1) My environment change - I perform this test in nested virtualization
   mode, so host OS may also affect performance.
2) My mistake in v3 :(

Anyway:
1) MSG_ZEROCOPY is still faster than copy as expected.

2) I'v added column with benchmark on 'net-next' without MSG_ZEROCOPY
   patchset. Seems it doesn't affect copy performance. Cases where we
   have difference like 26 against 29 is not a big deal - final result
   is unstable with some error, e.g. if you run again same test, you
   can get opposite result like 29 against 26.

2) Numbers below could be considered valid. This is newest measurement.


G2H transmission (values are Gbit/s):

   Core i7 with nested guest.

*-------------------------------*-----------------------*
|          |         |          |                       |
| buf size |   copy  | zerocopy | copy w/o MSG_ZEROCOPY |
|          |         |          |       patchset        |
|          |         |          |                       |
*-------------------------------*-----------------------*
|   4KB    |    3    |    11    |           3           |
*-------------------------------*-----------------------*
|   32KB   |    9    |    70    |          10           |
*-------------------------------*-----------------------*
|   256KB  |   30    |   224    |          29           |
*-------------------------------*-----------------------*
|    1M    |   27    |   285    |          30           |
*-------------------------------*-----------------------*
|    8M    |   26    |   365    |          29           |
*-------------------------------*-----------------------*


H2G:

   Core i7 with nested guest.

*-------------------------------*-----------------------*
|          |         |          |                       |
| buf size |   copy  | zerocopy | copy w/o MSG_ZEROCOPY |
|          |         |          |       patchset        |
|          |         |          |                       |
*-------------------------------*-----------------------*
|   4KB    |   17    |    10    |          17           | <<<<<<
*-------------------------------*-----------------------*
|   32KB   |   30    |    61    |          31           |
*-------------------------------*-----------------------*
|   256KB  |   35    |   214    |          30           |
*-------------------------------*-----------------------*
|    1M    |   29    |   292    |          28           |
*-------------------------------*-----------------------*
|    8M    |   28    |   341    |          28           |
*-------------------------------*-----------------------*

Loopback:

   Core i7 with nested guest.

*-------------------------------*-----------------------*
|          |         |          |                       |
| buf size |   copy  | zerocopy | copy w/o MSG_ZEROCOPY |
|          |         |          |       patchset        |
|          |         |          |                       |
*-------------------------------*-----------------------*
|   4KB    |    8    |     7    |           8           |
*-------------------------------*-----------------------*
|   32KB   |   27    |    43    |          30           |
*-------------------------------*-----------------------*
|   256KB  |   38    |   100    |          39           |
*-------------------------------*-----------------------*
|    1M    |   37    |   141    |          39           |
*-------------------------------*-----------------------*
|    8M    |   40    |   201    |          36           |
*-------------------------------*-----------------------*

Thanks, Arseniy

> - most systems have a copybreak scheme where buffers
>   smaller than a given size are copied directly.
>   This will address regression you see with small buffers -
>   but need to find that value. we know it's between 4k and 32k :)
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
