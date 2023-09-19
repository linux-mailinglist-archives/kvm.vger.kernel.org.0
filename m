Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F23D7A6961
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 19:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjISRI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 13:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjISRI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 13:08:28 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E00C6;
        Tue, 19 Sep 2023 10:08:22 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 9A46E100005;
        Tue, 19 Sep 2023 20:08:20 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 9A46E100005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695143300;
        bh=WBEzhcNoJQuuB8UyJJ4PwqgwlRmL8WGe3MnPQeIgtlM=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type:From;
        b=NhBerhihqUy5GxCHrM0XAbfFt+86hsNFC8SdR+89agX8KqQjBBwIFrkGczFzEJtmh
         0jEQ7TG89mznJD4wnxifoAiemyVBKyNEkx/H8CNxo7FyYin4iucWaH8sJHEVZ+e0VR
         ihnwolNoabrPqweg8o1K3tHdHvDzVUhVggasXLLlBq5baFN8QGC/vmPiQEB8cTEK3V
         Jk+eePzkh2JwJHExbCNC4chbxYYdkih3k09W+soQfB/r4QwQx54HjPW2ArgUfYemNm
         1ljuLsmv2l/dI/blp+Fl2+r4GoADz0BfHT0H0Ez3+RjqsPfe58acRBwOuoT12wf7eB
         cFh0m1+MgxECg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 19 Sep 2023 20:08:19 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 19 Sep 2023 20:08:19 +0300
Message-ID: <c2c5a7ea-5186-37e6-d0e9-659c53d31876@salutedevices.com>
Date:   Tue, 19 Sep 2023 20:01:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v9 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Content-Language: en-US
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
 <b5873e36-fe8c-85e8-e11b-4ccec386c015@salutedevices.com>
 <yys5jgwkukvfyrgfz6txxzqc7el5megf2xntnk6j4ausvjdgld@7aan4quqy4bs>
 <a5b25ee07245125fac4bbdc3b3604758251907d2.camel@redhat.com>
 <hq67e2b3ljfjikvbaneczdve3fzg3dl5ziyc7xtujyqesp6dzm@fh5nqkptpb4n>
 <d3ba655b-6a70-ca68-2e3f-f063d91c12fd@salutedevices.com>
In-Reply-To: <d3ba655b-6a70-ca68-2e3f-f063d91c12fd@salutedevices.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179972 [Sep 19 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/19 04:37:00 #21921740
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.09.2023 19:48, Arseniy Krasnov wrote:
> 
> 
> On 19.09.2023 16:35, Stefano Garzarella wrote:
>> On Tue, Sep 19, 2023 at 03:19:54PM +0200, Paolo Abeni wrote:
>>> On Tue, 2023-09-19 at 09:54 +0200, Stefano Garzarella wrote:
>>>> On Mon, Sep 18, 2023 at 07:56:00PM +0300, Arseniy Krasnov wrote:
>>>>> Hi Stefano,
>>>>>
>>>>> thanks for review! So when this patchset will be merged to net-next,
>>>>> I'll start sending next part of MSG_ZEROCOPY patchset, e.g. AF_VSOCK +
>>>>> Documentation/ patches.
>>>>
>>>> Ack, if it is not a very big series, maybe better to include also the
>>>> tests so we can run them before merge the feature.
>>>
>>> I understand that at least 2 follow-up series are waiting for this, one
>>> of them targeting net-next and the bigger one targeting the virtio
>>> tree. Am I correct?
>>
>> IIUC the next series will touch only the vsock core
>> (net/vmw_vsock/af_vsock.c), tests, and documentation.
>>
>> The virtio part should be fully covered by this series.
>>
>> @Arseniy feel free to correct me!
> 
> Yes, only this patchset touches virtio code. Next patchset will be AF_VSOCK,
> Documentation/ and tests. I think there is no need to merge it to the virtio
> tree - we can continue in the same way as before during AF_VSOCK development,
> e.g. merging it to net-next only.

^^^
I mean of course if there is need to merge to virtio tree also - no problem,
just informing that the next set of patches doesn't touch virtio code.
(except two several lines patches for drivers/vhost/vsock.c and net/vmw_vsock/virtio_transport.c)

> 
> Thanks, Arseniy
> 
>>
>>>
>>> DaveM suggests this should go via the virtio tree, too. Any different
>>> opinion?
>>
>> For this series should be fine, I'm not sure about the next series.
>> Merging this with the virtio tree, then it forces us to do it for
>> followup as well right?
>>
>> In theory followup is more on the core, so better with net-next, but
>> it's also true that for now only virtio transports support it, so it
>> might be okay to continue with virtio.
>>
>> @Michael WDYT?
>>
>> Thanks,
>> Stefano
>>
