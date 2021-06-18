Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9553ACF8A
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhFRP6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 11:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233886AbhFRP6M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 11:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624031763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Awjn2v8qac0K7VClk6HbxoaGBdL5LeTfJlE9EQ+fOjk=;
        b=OAACkEV23Oi9tlYJ9U6BKxTTlbDgCuADiI3NKHffgpkobmiW82yyTu/8q3N8yYbpn25lYO
        nq0D3IsNHqkMs+XJxXZr4g3Hr23r4ngMGb8N0S0UYbqnXCQvomAYTXutfLQdbI6O+dhW4T
        IAuC/ma+p4ISyUZCXqAIUlmO4Tssu70=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-QnSvl5FkM3O8eRUZtF24eQ-1; Fri, 18 Jun 2021 11:56:01 -0400
X-MC-Unique: QnSvl5FkM3O8eRUZtF24eQ-1
Received: by mail-wr1-f71.google.com with SMTP id h10-20020a5d688a0000b0290119c2ce2499so4515338wru.19
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 08:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Awjn2v8qac0K7VClk6HbxoaGBdL5LeTfJlE9EQ+fOjk=;
        b=E6DuKEcPbzCt4ieM5w41OVbT+PESukPB5ygUY7fnmDN9cnjTP/Ft2HlAE0bAxim5Zp
         4ocwYCMneXUrTPXbNqSwNxbE/iPWOpnJyMvCOeiAunS+WfzeBMW+CjkPIafhrEQin2I5
         OudzvIi7XU7wxiaZFIP1DFmuEn5wIZKsY+8yL2+S8aVjlyihjQJw9NHzIT+8FES3m3D8
         qggysNdJAdAxQMil1BMgeJdsry4dYaXRhorAYyT2vGZUCLmFwSxqK1sF9F0Z4/fj3KQT
         Jqv1C9/J+OEFKFW9t4xpUFDYSCepGhzinLaZ42CEllN6oSXoTHH3wkCz7dkq1111SxUM
         iEZA==
X-Gm-Message-State: AOAM531+5sltUyZm6OMhgSlCUfHMHpIXlmtkm8iabvjUgR+KV/x2IFeL
        ams4VTMkIwaPoTXPb/ebScwQxPJguphdbx3jXMptZH7381BSZ3hxf2rLY6a+wgcRiE8pz1nCicB
        0AzfGA13h7zgB
X-Received: by 2002:a5d:6d8a:: with SMTP id l10mr13665861wrs.63.1624031760678;
        Fri, 18 Jun 2021 08:56:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb8+5HIJLdutX7cENNNI1/ecBZD9YW9aCIcD5DoBeecwsxaAXgeOQAGd3lSOiR1Xdg+NTIjg==
X-Received: by 2002:a5d:6d8a:: with SMTP id l10mr13665839wrs.63.1624031760459;
        Fri, 18 Jun 2021 08:56:00 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.175])
        by smtp.gmail.com with ESMTPSA id m18sm8968801wmq.45.2021.06.18.08.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 08:56:00 -0700 (PDT)
Date:   Fri, 18 Jun 2021 17:55:55 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [PATCH v11 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210618155555.j5p4v6j5gk2dboj3@steredhat.lan>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
 <bb323125-f802-1d16-7530-6e4f4abb00a6@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb323125-f802-1d16-7530-6e4f4abb00a6@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 06:04:37PM +0300, Arseny Krasnov wrote:
>
>On 18.06.2021 16:44, Stefano Garzarella wrote:
>> Hi Arseny,
>> the series looks great, I have just a question below about
>> seqpacket_dequeue.
>>
>> I also sent a couple a simple fixes, it would be great if you can review
>> them:
>> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/
>>
>>
>> On Fri, Jun 11, 2021 at 02:12:38PM +0300, Arseny Krasnov wrote:
>>> Callback fetches RW packets from rx queue of socket until whole record
>>> is copied(if user's buffer is full, user is not woken up). This is done
>>> to not stall sender, because if we wake up user and it leaves syscall,
>>> nobody will send credit update for rest of record, and sender will wait
>>> for next enter of read syscall at receiver's side. So if user buffer is
>>> full, we just send credit update and drop data.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>> v10 -> v11:
>>> 1) 'msg_count' field added to count current number of EORs.
>>> 2) 'msg_ready' argument removed from callback.
>>> 3) If 'memcpy_to_msg()' failed during copy loop, there will be
>>>    no next attempts to copy data, rest of record will be freed.
>>>
>>> include/linux/virtio_vsock.h            |  5 ++
>>> net/vmw_vsock/virtio_transport_common.c | 84 +++++++++++++++++++++++++
>>> 2 files changed, 89 insertions(+)
>>>
>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>> index dc636b727179..1d9a302cb91d 100644
>>> --- a/include/linux/virtio_vsock.h
>>> +++ b/include/linux/virtio_vsock.h
>>> @@ -36,6 +36,7 @@ struct virtio_vsock_sock {
>>> 	u32 rx_bytes;
>>> 	u32 buf_alloc;
>>> 	struct list_head rx_queue;
>>> +	u32 msg_count;
>>> };
>>>
>>> struct virtio_vsock_pkt {
>>> @@ -80,6 +81,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>> 			       struct msghdr *msg,
>>> 			       size_t len, int flags);
>>>
>>> +ssize_t
>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>> +				   struct msghdr *msg,
>>> +				   int flags);
>>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index ad0d34d41444..1e1df19ec164 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -393,6 +393,78 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>> 	return err;
>>> }
>>>
>>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>> +						 struct msghdr *msg,
>>> +						 int flags)
>>> +{
>>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>>> +	struct virtio_vsock_pkt *pkt;
>>> +	int dequeued_len = 0;
>>> +	size_t user_buf_len = msg_data_left(msg);
>>> +	bool copy_failed = false;
>>> +	bool msg_ready = false;
>>> +
>>> +	spin_lock_bh(&vvs->rx_lock);
>>> +
>>> +	if (vvs->msg_count == 0) {
>>> +		spin_unlock_bh(&vvs->rx_lock);
>>> +		return 0;
>>> +	}
>>> +
>>> +	while (!msg_ready) {
>>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>>> +
>>> +		if (!copy_failed) {
>>> +			size_t pkt_len;
>>> +			size_t bytes_to_copy;
>>> +
>>> +			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>>> +			bytes_to_copy = min(user_buf_len, pkt_len);
>>> +
>>> +			if (bytes_to_copy) {
>>> +				int err;
>>> +
>>> +				/* sk_lock is held by caller so no one else can dequeue.
>>> +				 * Unlock rx_lock since memcpy_to_msg() may sleep.
>>> +				 */
>>> +				spin_unlock_bh(&vvs->rx_lock);
>>> +
>>> +				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
>>> +				if (err) {
>>> +					/* Copy of message failed, set flag to skip
>>> +					 * copy path for rest of fragments. Rest of
>>> +					 * fragments will be freed without copy.
>>> +					 */
>>> +					copy_failed = true;
>>> +					dequeued_len = err;
>> If we fail to copy the message we will discard the entire packet.
>> Is it acceptable for the user point of view, or we should leave the
>> packet in the queue and the user can retry, maybe with a different
>> buffer?
>>
>> Then we can remove the packets only when we successfully copied all the
>> fragments.
>>
>> I'm not sure make sense, maybe better to check also other
>> implementations :-)
>>
>> Thanks,
>> Stefano
>
>Understand, i'll check it on weekend, anyway I think it is
>not critical for implementation.

Yep, I agree.

>
>
>I have another question: may be it is useful to research for
>approach where packets are not queued until whole message
>is received, but copied to user's buffer thus freeing memory.
>(like previous implementation, of course with solution of problem
>where part of message still in queue, while reader was woken
>by timeout or signal).
>
>I think it is better, because  in current version, sender may set
>'peer_alloc_buf' to  for example 1MB, so at receiver we get
>1MB of 'kmalloc()' memory allocated, while having user's buffer
>to copy data there or drop it(if user's buffer is full). This way
>won't change spec(e.g. no message id or SEQ_BEGIN will be added).
>
>What do You think?

Yep, I see your point and it would be great, but I think the main issues 
to fix is how to handle a signal while we are waiting other fragments 
since the other peer can take unspecified time to send them.

Note that the 'peer_alloc_buf' in the sender, is the value get from the 
receiver, so if the receiver doesn't want to allocate 1MB, can advertise 
a small buffer size.

Thanks,
Stefano

