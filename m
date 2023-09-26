Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29037AF4C8
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 22:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbjIZUHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 16:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjIZUHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 16:07:30 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9906F3;
        Tue, 26 Sep 2023 13:07:22 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 72721120002;
        Tue, 26 Sep 2023 23:07:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 72721120002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695758841;
        bh=s7GCH61T88hlnNWcjUTVgfuSNPZWqf/bbDm9Jbk6EZY=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=Tx5z0T6DLy1nDXM6Y4/iCmWlbzx3mWrdXlw3OTNS5H/LWBOD1RXBaO7FPbFK/yOEs
         fcgbL7O0ncvZmDUX8zucYGIREGqyDSAR43rvplRMx6n9xA1N6mvsZsa555VRbRvv0o
         /lWQ77tNebYNzfQ2xUq4pbx96uWH2ik/gtvvcWw7x9Ndjmv+DbxOVeobcOzx++5X0g
         JOXABW/QfXdVbMKbBC52GNWu4jYxl2qx70w5kNToFR4U3nICkA8QORtT/qOxfK4Lwz
         cHh5duHVAxC70l/6zscy8nnQmNiPVDfr4MupAoJMKC3c7wyYp5ht2xTR8sPKbUVTNg
         C4ubgI74/MhGw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 26 Sep 2023 23:07:21 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 26 Sep 2023 23:07:20 +0300
Message-ID: <708be048-862f-76ee-6671-16b54e72e5a8@salutedevices.com>
Date:   Tue, 26 Sep 2023 23:00:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 12/12] test/vsock: io_uring rx/tx tests
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
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
 <20230922052428.4005676-13-avkrasnov@salutedevices.com>
 <kfuzqzhrgdk5f5arbq4n3vd6vro6533aeysqhdgqevcqxrdm6e@57ylpkc2t4q4>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <kfuzqzhrgdk5f5arbq4n3vd6vro6533aeysqhdgqevcqxrdm6e@57ylpkc2t4q4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180148 [Sep 26 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/26 14:54:00 #21988070
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.09.2023 16:04, Stefano Garzarella wrote:
> On Fri, Sep 22, 2023 at 08:24:28AM +0300, Arseniy Krasnov wrote:
>> This adds set of tests which use io_uring for rx/tx. This test suite is
>> implemented as separated util like 'vsock_test' and has the same set of
>> input arguments as 'vsock_test'. These tests only cover cases of data
>> transmission (no connect/bind/accept etc).
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> Changelog:
>> v5(big patchset) -> v1:
>>  * Use LDLIBS instead of LDFLAGS.
>>
>> tools/testing/vsock/Makefile           |   7 +-
>> tools/testing/vsock/vsock_uring_test.c | 321 +++++++++++++++++++++++++
>> 2 files changed, 327 insertions(+), 1 deletion(-)
>> create mode 100644 tools/testing/vsock/vsock_uring_test.c
>>
>> diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>> index 1a26f60a596c..c84380bfc18d 100644
>> --- a/tools/testing/vsock/Makefile
>> +++ b/tools/testing/vsock/Makefile
>> @@ -1,12 +1,17 @@
>> # SPDX-License-Identifier: GPL-2.0-only
>> +ifeq ($(MAKECMDGOALS),vsock_uring_test)
>> +LDLIBS = -luring
>> +endif
>> +
> 
> This will fails if for example we call make with more targets,
> e.g. `make vsock_test vsock_uring_test`.
> 
> I'd suggest to use something like this:
> 
> --- a/tools/testing/vsock/Makefile
> +++ b/tools/testing/vsock/Makefile
> @@ -1,13 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -ifeq ($(MAKECMDGOALS),vsock_uring_test)
> -LDLIBS = -luring
> -endif
> -
>  all: test vsock_perf
>  test: vsock_test vsock_diag_test
>  vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
>  vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>  vsock_perf: vsock_perf.o
> +
> +vsock_uring_test: LDLIBS = -luring
>  vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o
> 
>  CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
> 
>> all: test vsock_perf
>> test: vsock_test vsock_diag_test
>> vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
>> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>> vsock_perf: vsock_perf.o
>> +vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o
> 
> Shoud we add this new test to the "test" target as well?

Ok, but in this case, this target will always depend on liburing.

Thanks, Arseniy

> 
> Stefano
> 
