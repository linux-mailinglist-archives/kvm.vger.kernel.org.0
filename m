Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43747C54DA
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 15:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjJKNIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 09:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjJKNIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 09:08:21 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE407C6;
        Wed, 11 Oct 2023 06:08:16 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id A355912000B;
        Wed, 11 Oct 2023 16:08:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A355912000B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1697029692;
        bh=dP/baYZO5kD6Jow1pKoRT0YdQnHaH2Jq7btNsozjlq0=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=iDe+rNDdKa3j9IX6E3Yv2hjNmYg7ECISUDPpR6O5xdZbFEPPaHA0YC9MQ2W32oCkJ
         /LkRJ5PDlvEeEr5qP1qFH4kkQzKxY1yOrHmwkWDKwdcKBkT1/91iCNCHzB4eGaDlbC
         FgoLacwBA0LJLpDoulRg5po//Y8KK4pDddkESGkDKoBXuBTffVE8EpecXuYmTQ8/Dq
         eiSHfvNDFVfy3kWXUCVAWmmLbIn0osl4HmAQPCK9iDporZYpdecmb2FZ5mzwpsGltj
         Za5UIQ7h7VGXtJiikLYhhdsZVUqfj4IRLHIzuG/zROJawv8ET7zby6Ze8C9doKKFtG
         yelUUiD+UuWwA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Wed, 11 Oct 2023 16:08:10 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 11 Oct 2023 16:08:10 +0300
Message-ID: <a1bcc86e-2f22-89d8-d7e2-f3f6f7663235@salutedevices.com>
Date:   Wed, 11 Oct 2023 16:01:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v4 00/12] vsock/virtio: continue MSG_ZEROCOPY
 support
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
 <eey4hfz43popgwlwtheapjefzmxea7dk733y3v6aqsrewhq3mq@lcmmhdpwvvzc>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <eey4hfz43popgwlwtheapjefzmxea7dk733y3v6aqsrewhq3mq@lcmmhdpwvvzc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180531 [Oct 11 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 538 538 68c58b60b94be3a031a44c71e306321381fb1d87, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;lore.kernel.org:7.1.1;git.kernel.org:7.1.1;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/10/11 12:28:00
X-KSMG-LinksScanning: Clean, bases: 2023/10/11 12:28:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/11 11:30:00 #22159170
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11.10.2023 15:57, Stefano Garzarella wrote:
> On Tue, Oct 10, 2023 at 10:15:12PM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>> this patchset contains second and third parts of another big patchset
>> for MSG_ZEROCOPY flag support:
>> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
>>
>> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>> suggested to split it for three parts to simplify review and merging:
>>
>> 1) virtio and vhost updates (for fragged skbs) (merged to net-next, see
>>   link below)
>> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>>   tx completions) and update for Documentation/. <-- this patchset
>> 3) Updates for tests and utils. <-- this patchset
>>
>> Part 1) was merged:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=71b263e79370348349553ecdf46f4a69eb436dc7
>>
>> Head for this patchset is:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=19537e125cc7cf2da43a606f5bcebbe0c9aea4cc
>>
>> Link to v1:
>> https://lore.kernel.org/netdev/20230922052428.4005676-1-avkrasnov@salutedevices.com/
>> Link to v2:
>> https://lore.kernel.org/netdev/20230930210308.2394919-1-avkrasnov@salutedevices.com/
>> Link to v3:
>> https://lore.kernel.org/netdev/20231007172139.1338644-1-avkrasnov@salutedevices.com/
>>
>> Changelog:
>> v1 -> v2:
>> * Patchset rebased and tested on new HEAD of net-next (see hash above).
>> * See per-patch changelog after ---.
>> v2 -> v3:
>> * Patchset rebased and tested on new HEAD of net-next (see hash above).
>> * See per-patch changelog after ---.
>> v3 -> v4:
>> * Patchset rebased and tested on new HEAD of net-next (see hash above).
>> * See per-patch changelog after ---.
> 
> I think I fully reviewed the series ;-)
> 
> Tests are all passing here, including the new ones. I also added
> vsock_perf and vsock_uring_test to my test suite!

Thanks for review!

> 
> So for vsock point of view everything looks fine.
> 
> Let's see if there is anything about net (MSG_ZEROCOPY flags, etc.)

Yes, let's wait for more comments, because whole patchset is R-b now and
this finally completes MSG_ZEROCOPY support for virtio/vsock.

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
