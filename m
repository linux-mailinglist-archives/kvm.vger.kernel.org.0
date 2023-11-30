Return-Path: <kvm+bounces-2971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B267FF3F0
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3E3C1C21068
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156C85380D;
	Thu, 30 Nov 2023 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="ccQ32oTx"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651AFD4A;
	Thu, 30 Nov 2023 07:49:59 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id B72E912001D;
	Thu, 30 Nov 2023 18:49:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru B72E912001D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701359396;
	bh=GPspWvvW9bTH7lAgniND5YEprjoaTp1JsWWZlfyZifw=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=ccQ32oTxDnCS4PBVSk9uB+qXD5NZDVetvjG2tz/iG6rqpBSxa6lE7FPTHkmEjKWC3
	 L5/p7VnChZ7J8YeaPoJpg/MyJh06+VAmKeBteLGAkZ2Xcsqo859mNIYv5UAcrEJ05+
	 +r3nVuAr3mFCApHazDV75mHWI8GsDh5GTDis2Xrz2BQyObPgE2B9pAQmIRbd9l2pP9
	 fzIWebEAeoA2Oahh7Xq60TUnZN69XeODfS0rWkyeXtpnhIkvJyNyn+7f4rIGuabE+m
	 TvsvoG3Zd3ZU8xypfP7vC+gZDop1zP7QQf2KltdwxZrCEF5BGgD51cUxp93wTWDQaO
	 8nb5Urs781UkQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu, 30 Nov 2023 18:49:54 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 30 Nov 2023 18:49:54 +0300
Message-ID: <b3fa2aaa-9fdc-30a2-4c87-53eb106900ee@salutedevices.com>
Date: Thu, 30 Nov 2023 18:41:56 +0300
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
To: Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231130130840.253733-1-avkrasnov@salutedevices.com>
 <20231130130840.253733-3-avkrasnov@salutedevices.com>
 <20231130084044-mutt-send-email-mst@kernel.org>
 <02de8982-ec4a-b3b2-e8e5-1bca28cfc01b@salutedevices.com>
 <20231130085445-mutt-send-email-mst@kernel.org>
 <pbkiwezwlf6dmogx7exur6tjrtcfzxyn7eqlehqxivqifbkojv@xlziiuzekon4>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <pbkiwezwlf6dmogx7exur6tjrtcfzxyn7eqlehqxivqifbkojv@xlziiuzekon4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181744 [Nov 30 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/11/30 10:41:00
X-KSMG-LinksScanning: Clean, bases: 2023/11/30 14:39:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/30 13:53:00 #22585260
X-KSMG-AntiVirus-Status: Clean, skipped



On 30.11.2023 17:11, Stefano Garzarella wrote:
> On Thu, Nov 30, 2023 at 08:58:58AM -0500, Michael S. Tsirkin wrote:
>> On Thu, Nov 30, 2023 at 04:43:34PM +0300, Arseniy Krasnov wrote:
>>>
>>>
>>> On 30.11.2023 16:42, Michael S. Tsirkin wrote:
>>> > On Thu, Nov 30, 2023 at 04:08:39PM +0300, Arseniy Krasnov wrote:
>>> >> Send credit update message when SO_RCVLOWAT is updated and it is bigger
>>> >> than number of bytes in rx queue. It is needed, because 'poll()' will
>>> >> wait until number of bytes in rx queue will be not smaller than
>>> >> SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
>>> >> for tx/rx is possible: sender waits for free space and receiver is
>>> >> waiting data in 'poll()'.
>>> >>
>>> >> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>> >> ---
>>> >>  Changelog:
>>> >>  v1 -> v2:
>>> >>   * Update commit message by removing 'This patch adds XXX' manner.
>>> >>   * Do not initialize 'send_update' variable - set it directly during
>>> >>     first usage.
>>> >>  v3 -> v4:
>>> >>   * Fit comment in 'virtio_transport_notify_set_rcvlowat()' to 80 chars.
>>> >>  v4 -> v5:
>>> >>   * Do not change callbacks order in transport structures.
>>> >>
>>> >>  drivers/vhost/vsock.c                   |  1 +
>>> >>  include/linux/virtio_vsock.h            |  1 +
>>> >>  net/vmw_vsock/virtio_transport.c        |  1 +
>>> >>  net/vmw_vsock/virtio_transport_common.c | 27 +++++++++++++++++++++++++
>>> >>  net/vmw_vsock/vsock_loopback.c          |  1 +
>>> >>  5 files changed, 31 insertions(+)
>>> >>
>>> >> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>> >> index f75731396b7e..4146f80db8ac 100644
>>> >> --- a/drivers/vhost/vsock.c
>>> >> +++ b/drivers/vhost/vsock.c
>>> >> @@ -451,6 +451,7 @@ static struct virtio_transport vhost_transport = {
>>> >>          .notify_buffer_size       = virtio_transport_notify_buffer_size,
>>> >>
>>> >>          .read_skb = virtio_transport_read_skb,
>>> >> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>>> >>      },
>>> >>
>>> >>      .send_pkt = vhost_transport_send_pkt,
>>> >> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>> >> index ebb3ce63d64d..c82089dee0c8 100644
>>> >> --- a/include/linux/virtio_vsock.h
>>> >> +++ b/include/linux/virtio_vsock.h
>>> >> @@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>>> >>  void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>>> >>  int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>>> >>  int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>>> >> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
>>> >>  #endif /* _LINUX_VIRTIO_VSOCK_H */
>>> >> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>> >> index af5bab1acee1..8007593a3a93 100644
>>> >> --- a/net/vmw_vsock/virtio_transport.c
>>> >> +++ b/net/vmw_vsock/virtio_transport.c
>>> >> @@ -539,6 +539,7 @@ static struct virtio_transport virtio_transport = {
>>> >>          .notify_buffer_size       = virtio_transport_notify_buffer_size,
>>> >>
>>> >>          .read_skb = virtio_transport_read_skb,
>>> >> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>>> >>      },
>>> >>
>>> >>      .send_pkt = virtio_transport_send_pkt,
>>> >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> >> index f6dc896bf44c..1cb556ad4597 100644
>>> >> --- a/net/vmw_vsock/virtio_transport_common.c
>>> >> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> >> @@ -1684,6 +1684,33 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>>> >>  }
>>> >>  EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>>> >>
>>> >> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, >> int val)
>>> >> +{
>>> >> +    struct virtio_vsock_sock *vvs = vsk->trans;
>>> >> +    bool send_update;
>>> >> +
>>> >> +    spin_lock_bh(&vvs->rx_lock);
>>> >> +
>>> >> +    /* If number of available bytes is less than new SO_RCVLOWAT value,
>>> >> +     * kick sender to send more data, because sender may sleep in >> its
>>> >> +     * 'send()' syscall waiting for enough space at our side.
>>> >> +     */
>>> >> +    send_update = vvs->rx_bytes < val;
>>> >> +
>>> >> +    spin_unlock_bh(&vvs->rx_lock);
>>> >> +
>>> >> +    if (send_update) {
>>> >> +        int err;
>>> >> +
>>> >> +        err = virtio_transport_send_credit_update(vsk);
>>> >> +        if (err < 0)
>>> >> +            return err;
>>> >> +    }
>>> >> +
>>> >> +    return 0;
>>> >> +}
>>> >
>>> >
>>> > I find it strange that this will send a credit update
>>> > even if nothing changed since this was called previously.
>>> > I'm not sure whether this is a problem protocol-wise,
>>> > but it certainly was not envisioned when the protocol was
>>> > built. WDYT?
>>>
>>> >From virtio spec I found:
>>>
>>> It is also valid to send a VIRTIO_VSOCK_OP_CREDIT_UPDATE packet without previously receiving a
>>> VIRTIO_VSOCK_OP_CREDIT_REQUEST packet. This allows communicating updates any time a change
>>> in buffer space occurs.
>>> So I guess there is no limitations to send such type of packet, e.g. it is not
>>> required to be a reply for some another packet. Please, correct me if im wrong.
>>>
>>> Thanks, Arseniy
>>
>>
>> Absolutely. My point was different - with this patch it is possible
>> that you are not adding any credits at all since the previous
>> VIRTIO_VSOCK_OP_CREDIT_UPDATE.
> 
> I think the problem we're solving here is that since as an optimization we avoid sending the update for every byte we consume, but we put a threshold, then we make sure we update the peer.
> 
> A credit update contains a snapshot and sending it the same as the previous one should not create any problem.
> 
> My doubt now is that we only do this when we set RCVLOWAT , should we also do something when we consume bytes to avoid the optimization we have?

@Michael, Stefano just reproduced problem during bytes reading, but there is already old fix for this, which we forget to merge:)
I think it must be included to this patchset.

https://lore.kernel.org/netdev/f304eabe-d2ef-11b1-f115-6967632f0339@sberdevices.ru/

Thanks, Arseniy

> 
> Stefano
> 

