Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063E27B853F
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 18:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243328AbjJDQ3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 12:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243287AbjJDQ3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 12:29:02 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FCAAB;
        Wed,  4 Oct 2023 09:28:57 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 7D34C100004;
        Wed,  4 Oct 2023 19:28:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 7D34C100004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696436936;
        bh=M04Cvv6jqbk+T4bX9iWhghTFTElf6sSk6pU3ewzQjAQ=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type:From;
        b=t8yWRA2DOJ0CAacDPLSwcfr2aBqGGcDMfsU0obT3lAcXNmwqHHmcCtt2mu9xCXZ6y
         PlNWNOszaDHWvziC+qsojAwN8J+W1FgbZLKtkxQRchX5snhy/Uz9VJ9C9IPwxjxlDK
         KDJCrcQssMI5/vze/O/lQc+8ErV2jbBOwEbLhKhk/RvfXE9jmgIe6BzWc5If/cUdhN
         PjOwLMB8RU6Zr0mL717F7xtszOsnSsUgdRrEy4SKpcQFwa1dZGdnCe+An/wmNeZe14
         RSl7xRIrp0D+YV9p+X4RluHG+8prFQweayw6w8AWMpPHJlWm9WDAe9pVy8OixsxLGn
         IgGFhw7PYUgJw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Wed,  4 Oct 2023 19:28:56 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 4 Oct 2023 19:28:55 +0300
Message-ID: <5ae3b08d-bcbb-514c-856a-94c538796714@salutedevices.com>
Date:   Wed, 4 Oct 2023 19:22:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 00/12] vsock/virtio: continue MSG_ZEROCOPY
 support
Content-Language: en-US
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
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
 <aef9a438-3c61-44ec-688f-ed89eb886bfd@salutedevices.com>
In-Reply-To: <aef9a438-3c61-44ec-688f-ed89eb886bfd@salutedevices.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180362 [Oct 04 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, lore.kernel.org:7.1.1;git.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;salutedevices.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/10/04 12:21:00
X-KSMG-LinksScanning: Clean, bases: 2023/10/04 14:53:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/04 15:39:00 #22058417
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.10.2023 08:25, Arseniy Krasnov wrote:
> 
> 
> On 03.10.2023 19:26, Stefano Garzarella wrote:
>> Hi Arseniy,
>>
>> On Sun, Oct 01, 2023 at 12:02:56AM +0300, Arseniy Krasnov wrote:
>>> Hello,
>>>
>>> this patchset contains second and third parts of another big patchset
>>> for MSG_ZEROCOPY flag support:
>>> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
>>>
>>> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>>> suggested to split it for three parts to simplify review and merging:
>>>
>>> 1) virtio and vhost updates (for fragged skbs) (merged to net-next, see
>>>   link below)
>>> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>>>   tx completions) and update for Documentation/. <-- this patchset
>>> 3) Updates for tests and utils. <-- this patchset
>>>
>>> Part 1) was merged:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=71b263e79370348349553ecdf46f4a69eb436dc7
>>>
>>> Head for this patchset is:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=236f3873b517acfaf949c23bb2d5dec13bfd2da2
>>>
>>> Link to v1:
>>> https://lore.kernel.org/netdev/20230922052428.4005676-1-avkrasnov@salutedevices.com/
>>>
>>> Changelog:
>>> v1 -> v2:
>>> * Patchset rebased and tested on new HEAD of net-next (see hash above).
>>> * See per-patch changelog after ---.
>>
>> Thanks for this new version.
>> I started to include vsock_uring_test in my test suite and tests are
>> going well.
>>
>> I reviewed code patches, I still need to review the tests.
>> I'll do that by the end of the week, but they looks good!
> 
> Thanks for review! Ok, I'll wait for tests review, and then send next
> version.

Got your comments from review. I'll update patches by:
1) Trying to avoid touching util.c/util.h
2) Add new header with functions shared between util vsock_perf and tests

Thanks, Arseniy

> 
> Thanks, Arseniy
> 
>>
>> Thanks,
>> Stefano
>>
