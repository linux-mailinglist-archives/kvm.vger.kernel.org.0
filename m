Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64807B777E
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 07:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbjJDFce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 01:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjJDFcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 01:32:33 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917F2A7;
        Tue,  3 Oct 2023 22:32:29 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id C31B9120007;
        Wed,  4 Oct 2023 08:32:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru C31B9120007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696397547;
        bh=CLKlKrCqAdeepCHsWhFMDBWkvkAJ8TxMV8E1PWgt7+I=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=Lz/DQ1Bnxvkh6x4hgbzbOndmcddK5Bme0jG82haFWiAEE6AdoX3ISlkVd0+vXEzkU
         L5WsUmUNgvX/EC31KRW+kSNDA7R+ra7JmNrRG6RbGmsrWdVbhJttq3wXP6WCT7um4a
         VRjN4L3XH9u0jzrgZZmhY48p/4YkoKHkfIJ4EB8FUn8G/UArQT4AKTCOf7AXHs6xqh
         j0Oc9YAMdU/ymoBKdBS+2MYkv/+7D07phuZSimQ/sO8nk2njIErtgok/Oa1AtL9bbx
         Lfi3Zqsd1pzP+aNq20J91IdZMBiopnIl96Ny/aWZC76zzzcRdWELIaFr4b37aI63ys
         rS7jlmLt3RdWg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Wed,  4 Oct 2023 08:32:27 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 4 Oct 2023 08:32:27 +0300
Message-ID: <aef9a438-3c61-44ec-688f-ed89eb886bfd@salutedevices.com>
Date:   Wed, 4 Oct 2023 08:25:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 00/12] vsock/virtio: continue MSG_ZEROCOPY
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
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
 <4nwo6nd2ihjqsoqnjdjhuucqyc4fhfhxk52q6ulrs6sd2fmf7z@24hi65hbpl4i>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <4nwo6nd2ihjqsoqnjdjhuucqyc4fhfhxk52q6ulrs6sd2fmf7z@24hi65hbpl4i>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180332 [Oct 04 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;salutedevices.com:7.1.1;100.64.160.123:7.1.2;git.kernel.org:7.1.1;lore.kernel.org:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/10/04 03:39:00
X-KSMG-LinksScanning: Clean, bases: 2023/10/04 03:39:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/04 04:17:00 #22052298
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03.10.2023 19:26, Stefano Garzarella wrote:
> Hi Arseniy,
> 
> On Sun, Oct 01, 2023 at 12:02:56AM +0300, Arseniy Krasnov wrote:
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
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=236f3873b517acfaf949c23bb2d5dec13bfd2da2
>>
>> Link to v1:
>> https://lore.kernel.org/netdev/20230922052428.4005676-1-avkrasnov@salutedevices.com/
>>
>> Changelog:
>> v1 -> v2:
>> * Patchset rebased and tested on new HEAD of net-next (see hash above).
>> * See per-patch changelog after ---.
> 
> Thanks for this new version.
> I started to include vsock_uring_test in my test suite and tests are
> going well.
> 
> I reviewed code patches, I still need to review the tests.
> I'll do that by the end of the week, but they looks good!

Thanks for review! Ok, I'll wait for tests review, and then send next
version.

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
