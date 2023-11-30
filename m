Return-Path: <kvm+bounces-2924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF637FF14A
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28F55282501
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6639B495C1;
	Thu, 30 Nov 2023 14:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="i79TTedW"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCEA1BCC;
	Thu, 30 Nov 2023 06:07:53 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 03588100008;
	Thu, 30 Nov 2023 17:07:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 03588100008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701353272;
	bh=2CVWwpUjY3zQsaFiTTcV8k9AaqfF3MCtSJZeZmvAu4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=i79TTedWwRUJYgpz3dc2epg9Akg3uLW6kYPdyDLUsl/xV8GpizwS4Xadi8Jvaoohf
	 u7F7+B9UOlNLUh5MRUD87Yj7UOwZ+cusL0mHXKM6x3Bjb2+E0ZSnavVHgfdFkCXNeh
	 IIeqNJ66+j5i81asayYjG2Cp2mzixrKXSlkjbWl9lzFLqXTV4DOAnm3QSN0SxWd2h6
	 svRXBjsIqZ8zpfRDvLH62SHaB53PvWBmPRC2JwP2mxLNa57+02SOSmdv3SrNaUyjrK
	 0Gd04rvBkiCpSvRb02o5vjz4vBe0L7/TlM4lfvD0iD1J/r/06PLNlfL0TZgVwTtE0h
	 QVyDcmXJf1mFw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu, 30 Nov 2023 17:07:51 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 30 Nov 2023 17:07:51 +0300
Message-ID: <3fcda3c4-5f58-fd84-9020-02493226343b@salutedevices.com>
Date: Thu, 30 Nov 2023 16:59:53 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v5 2/3] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231130130840.253733-1-avkrasnov@salutedevices.com>
 <20231130130840.253733-3-avkrasnov@salutedevices.com>
 <20231130084044-mutt-send-email-mst@kernel.org>
 <02de8982-ec4a-b3b2-e8e5-1bca28cfc01b@salutedevices.com>
 <20231130085445-mutt-send-email-mst@kernel.org>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20231130085445-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181740 [Nov 30 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/30 11:05:00 #22583687
X-KSMG-AntiVirus-Status: Clean, skipped



On 30.11.2023 16:58, Michael S. Tsirkin wrote:
> On Thu, Nov 30, 2023 at 04:43:34PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 30.11.2023 16:42, Michael S. Tsirkin wrote:
>>> On Thu, Nov 30, 2023 at 04:08:39PM +0300, Arseniy Krasnov wrote:
>>>> Send credit update message when SO_RCVLOWAT is updated and it is bigger
>>>> than number of bytes in rx queue. It is needed, because 'poll()' will
>>>> wait until number of bytes in rx queue will be not smaller than
>>>> SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
>>>> for tx/rx is possible: sender waits for free space and receiver is
>>>> waiting data in 'poll()'.
>>>>
>>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>>> ---
>>>>  Changelog:
>>>>  v1 -> v2:
>>>>   * Update commit message by removing 'This patch adds XXX' manner.
>>>>   * Do not initialize 'send_update' variable - set it directly during
>>>>     first usage.
>>>>  v3 -> v4:
>>>>   * Fit comment in 'virtio_transport_notify_set_rcvlowat()' to 80 chars.
>>>>  v4 -> v5:
>>>>   * Do not change callbacks order in transport structures.
>>>>
>>>>  drivers/vhost/vsock.c                   |  1 +
>>>>  include/linux/virtio_vsock.h            |  1 +
>>>>  net/vmw_vsock/virtio_transport.c        |  1 +
>>>>  net/vmw_vsock/virtio_transport_common.c | 27 +++++++++++++++++++++++++
>>>>  net/vmw_vsock/vsock_loopback.c          |  1 +
>>>>  5 files changed, 31 insertions(+)
>>>>
>>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>>> index f75731396b7e..4146f80db8ac 100644
>>>> --- a/drivers/vhost/vsock.c
>>>> +++ b/drivers/vhost/vsock.c
>>>> @@ -451,6 +451,7 @@ static struct virtio_transport vhost_transport = {
>>>>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>>>>  
>>>>  		.read_skb = virtio_transport_read_skb,
>>>> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>>>>  	},
>>>>  
>>>>  	.send_pkt = vhost_transport_send_pkt,
>>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>>> index ebb3ce63d64d..c82089dee0c8 100644
>>>> --- a/include/linux/virtio_vsock.h
>>>> +++ b/include/linux/virtio_vsock.h
>>>> @@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>>>>  void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>>>>  int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>>>>  int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>>>> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
>>>>  #endif /* _LINUX_VIRTIO_VSOCK_H */
>>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>>> index af5bab1acee1..8007593a3a93 100644
>>>> --- a/net/vmw_vsock/virtio_transport.c
>>>> +++ b/net/vmw_vsock/virtio_transport.c
>>>> @@ -539,6 +539,7 @@ static struct virtio_transport virtio_transport = {
>>>>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>>>>  
>>>>  		.read_skb = virtio_transport_read_skb,
>>>> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>>>>  	},
>>>>  
>>>>  	.send_pkt = virtio_transport_send_pkt,
>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>> index f6dc896bf44c..1cb556ad4597 100644
>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>> @@ -1684,6 +1684,33 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>>>>  
>>>> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
>>>> +{
>>>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>>>> +	bool send_update;
>>>> +
>>>> +	spin_lock_bh(&vvs->rx_lock);
>>>> +
>>>> +	/* If number of available bytes is less than new SO_RCVLOWAT value,
>>>> +	 * kick sender to send more data, because sender may sleep in its
>>>> +	 * 'send()' syscall waiting for enough space at our side.
>>>> +	 */
>>>> +	send_update = vvs->rx_bytes < val;
>>>> +
>>>> +	spin_unlock_bh(&vvs->rx_lock);
>>>> +
>>>> +	if (send_update) {
>>>> +		int err;
>>>> +
>>>> +		err = virtio_transport_send_credit_update(vsk);
>>>> +		if (err < 0)
>>>> +			return err;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>
>>>
>>> I find it strange that this will send a credit update
>>> even if nothing changed since this was called previously.
>>> I'm not sure whether this is a problem protocol-wise,
>>> but it certainly was not envisioned when the protocol was
>>> built. WDYT?
>>
>> >From virtio spec I found:
>>
>> It is also valid to send a VIRTIO_VSOCK_OP_CREDIT_UPDATE packet without previously receiving a
>> VIRTIO_VSOCK_OP_CREDIT_REQUEST packet. This allows communicating updates any time a change
>> in buffer space occurs.
>> So I guess there is no limitations to send such type of packet, e.g. it is not
>> required to be a reply for some another packet. Please, correct me if im wrong.
>>
>> Thanks, Arseniy
> 
> 
> Absolutely. My point was different - with this patch it is possible
> that you are not adding any credits at all since the previous
> VIRTIO_VSOCK_OP_CREDIT_UPDATE.

I see, @Stefano, what do you think ?

Thanks, Arseniy

> 
>>
>>>
>>>
>>>> +EXPORT_SYMBOL_GPL(virtio_transport_notify_set_rcvlowat);
>>>> +
>>>>  MODULE_LICENSE("GPL v2");
>>>>  MODULE_AUTHOR("Asias He");
>>>>  MODULE_DESCRIPTION("common code for virtio vsock");
>>>> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>>>> index 048640167411..9f4b814fbbc7 100644
>>>> --- a/net/vmw_vsock/vsock_loopback.c
>>>> +++ b/net/vmw_vsock/vsock_loopback.c
>>>> @@ -98,6 +98,7 @@ static struct virtio_transport loopback_transport = {
>>>>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>>>>  
>>>>  		.read_skb = virtio_transport_read_skb,
>>>> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>>>>  	},
>>>>  
>>>>  	.send_pkt = vsock_loopback_send_pkt,
>>>> -- 
>>>> 2.25.1
>>>
> 

