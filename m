Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176247A09B5
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 17:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241226AbjINPuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 11:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241065AbjINPuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 11:50:06 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22B999;
        Thu, 14 Sep 2023 08:50:01 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id DA9B3100008;
        Thu, 14 Sep 2023 18:49:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru DA9B3100008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1694706599;
        bh=A03gfYoSH59CVMFYfHmRQ/fyqxKJV1wkWlqg/zJjjJI=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=LFcmXxw2rO+WbEe/9wfMtyrB6tFK/wXNukyDXO3r1fzZXc1BwTow62TvIr7aXMuk5
         dQsbGGI1Wes++AG14bLTWXWXVFWq8gK3x061Xl8S8TaN2E6VNYDE/1ivTxmEbxGE0E
         I4jxGVDKRsZEuvbbYtlvO0pSvxFthUeZIW6Diu6+8gFtbsfj2den3Ap+XXmGh6y4KI
         DmKpXNgmZynqSh+uXQjSamEZbQbb1qBXOmGFUsj8KmdUegOoAkcYN/zg5+o3CcanMI
         WlqI8Rlhkkh9935yNd0oD+wUudyZ8WUqqAQx5rvIBZA1ok6RknLPOydJ9j7VILZL/T
         /IkDDYpesnFlg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Thu, 14 Sep 2023 18:49:58 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 14 Sep 2023 18:49:57 +0300
Message-ID: <af22df3f-2fe2-3714-1a40-47ff32e46660@salutedevices.com>
Date:   Thu, 14 Sep 2023 18:43:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v8 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
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
References: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
 <554ugdobcmxraek662xkxjdehcu5ri6awxvhvlvnygyru5zlsx@e7cyloz6so7u>
 <7bf35d28-893b-5bea-beb7-9a25bc2f0a0e@salutedevices.com>
 <63xflnwiohdfo6m3vnrrxgv2ulplencpwug5qqacugqh7xxpu3@tsczkuqgwurb>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <63xflnwiohdfo6m3vnrrxgv2ulplencpwug5qqacugqh7xxpu3@tsczkuqgwurb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179874 [Sep 14 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 530 530 ecb1547b3f72d1df4c71c0b60e67ba6b4aea5432, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;lore.kernel.org:7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/09/14 12:07:00
X-KSMG-LinksScanning: Clean, bases: 2023/09/14 12:07:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/14 11:07:00 #21890594
X-KSMG-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.09.2023 18:34, Stefano Garzarella wrote:
> On Thu, Sep 14, 2023 at 05:05:17PM +0300, Arseniy Krasnov wrote:
>> Hello Stefano,
>>
>> On 14.09.2023 17:07, Stefano Garzarella wrote:
>>> Hi Arseniy,
>>>
>>> On Mon, Sep 11, 2023 at 11:22:30PM +0300, Arseniy Krasnov wrote:
>>>> Hello,
>>>>
>>>> this patchset is first of three parts of another big patchset for
>>>> MSG_ZEROCOPY flag support:
>>>> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
>>>>
>>>> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>>>> suggested to split it for three parts to simplify review and merging:
>>>>
>>>> 1) virtio and vhost updates (for fragged skbs) <--- this patchset
>>>> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>>>>   tx completions) and update for Documentation/.
>>>> 3) Updates for tests and utils.
>>>>
>>>> This series enables handling of fragged skbs in virtio and vhost parts.
>>>> Newly logic won't be triggered, because SO_ZEROCOPY options is still
>>>> impossible to enable at this moment (next bunch of patches from big
>>>> set above will enable it).
>>>>
>>>> I've included changelog to some patches anyway, because there were some
>>>> comments during review of last big patchset from the link above.
>>>
>>> Thanks, I left some comments on patch 4, the others LGTM.
>>> Sorry to not having spotted them before, but moving
>>> virtio_transport_alloc_skb() around the file, made the patch a little
>>> confusing and difficult to review.
>>
>> Sure, no problem, I'll fix them! Thanks for review.
>>
>>>
>>> In addition, I started having failures of test 14 (server: host,
>>> client: guest), so I looked better to see if there was anything wrong,
>>> but it fails me even without this series applied.
>>>
>>> It happens to me intermittently (~30%), does it happen to you?
>>> Can you take a look at it?
>>
>> Yes! sometime ago I also started to get fails of this test, not ~30%,
>> significantly rare, but it depends on environment I guess, anyway I'm going to
>> look at this on the next few days
> 
> Maybe it's just a timing issue in the test, indeed we are expecting 8
> bytes but we received only 3 plus the 2 bytes we received before it
> seems exactly the same bytes we send with the first
> `send(fd, HELLO_STR, strlen(HELLO_STR), 0);`
> 
> Since it is a stream socket, it could happen, so we should retry
> the recv() or just use MSG_WAITALL.
> 
> Applying the following patch fixed the issue for me (15 mins without
> errors for now):
> 
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> index 90718c2fd4ea..7b0fed9fc58d 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -1129,7 +1129,7 @@ static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
>         control_expectln("SEND0");
> 
>         /* Read skbuff partially. */
> -       res = recv(fd, buf, 2, 0);
> +       res = recv(fd, buf, 2, MSG_WAITALL);
>         if (res != 2) {
>                 fprintf(stderr, "expected recv(2) returns 2 bytes, got %zi\n", res);
>                 exit(EXIT_FAILURE);
> @@ -1138,7 +1138,7 @@ static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
>         control_writeln("REPLY0");
>         control_expectln("SEND1");
> 
> -       res = recv(fd, buf + 2, sizeof(buf) - 2, 0);
> +       res = recv(fd, buf + 2, 8, MSG_WAITALL);
>         if (res != 8) {
>                 fprintf(stderr, "expected recv(2) returns 8 bytes, got %zi\n", res);
>                 exit(EXIT_FAILURE);
> 
> I will check better all the cases and send a patch upstream.

Agree, I think this will fix it!

Thanks, Arseniy

> 
> Anyway it looks just an issue in our test suite :-)
> 
> Stefano
> 
>>
>> Thanks, Arseniy
>>
>>>
>>> host$ ./vsock_test --mode=server --control-port=12345 --peer-cid=4
>>> ...
>>> 14 - SOCK_STREAM virtio skb merge...expected recv(2) returns 8 bytes, got 3
>>>
>>> guest$ ./vsock_test --mode=client --control-host=192.168.133.2 --control-port=12345 --peer-cid=2
>>>
>>> Thanks,
>>> Stefano
>>>
>>
> 
