Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDCD758F30
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 09:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjGSHht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 03:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjGSHhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 03:37:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEB5E60
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 00:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689752193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/l/BFx3Ouxomc0W5crH0QEL+N5uRN2SeYoUdCWhVZBA=;
        b=X5HS4QAmje4SpahwTW5wG/vym2nUcsDkyr7FlgXBPl7g+2xoQY1ra99ZpvCmnH8hYDtsbj
        PdP+oylMcRQhXOhGrYi+cQtid8BidRkQlQmzwavFcS7q3IofX9sY0m65fRV7Cgn6DblpU2
        ngNOPsiiPCSuMWh6Psc3sEsNIcOcYhY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-FGvYNDVCOASJtPwIRS4OFg-1; Wed, 19 Jul 2023 03:36:32 -0400
X-MC-Unique: FGvYNDVCOASJtPwIRS4OFg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b703a076ceso59965771fa.1
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 00:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689752191; x=1690356991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/l/BFx3Ouxomc0W5crH0QEL+N5uRN2SeYoUdCWhVZBA=;
        b=dn0o/4bXtmunAn/H9vTN5r9X7gHG+BBl2pWtMCgYDidoT6MfYxSkMLLPiP/7NMLjDA
         M7U4o+qqDyDzgi6WevvdROKQDkhdc+kuuCVZ5ofnlpDwosA4BTa7qDLeMGkxk891JJAu
         4esQPFdYmec+zZLuC0Lb/uKRBtXWbyEeeekVZfHRSsTfafVIb/P84wuYJ/Z+cLQJI7Lo
         J0qTxmy4iPPhd62SoCVou539lnIcR3UjtQuYW9Rq0AkiGf0hcyMjzxrZBy5HCJ1RsQo9
         LnkUDgKrQXRKV7CHx00x5OM6kD7N8FsLGmFSpmRehGULCg2Xc+2Ouq4zKl6Wzu3QZY+q
         vodw==
X-Gm-Message-State: ABy/qLbo+YEGCHZadwUvJXcO4brdfwC2L1BGrFKAiK3PF3zKm3W2zWsR
        mmws/HIIxHpkRaqdntJHIcr9DgLOOMT+7eFwZgQn2fXarqsiK5OmCWKLpbXIxcF9I8mAWQ2Q7RV
        jvKoiSVEmU81f
X-Received: by 2002:a05:6512:15a6:b0:4fd:d3aa:e425 with SMTP id bp38-20020a05651215a600b004fdd3aae425mr1581925lfb.27.1689752190998;
        Wed, 19 Jul 2023 00:36:30 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH1vDeqm1BTcVm9t1Zzvu6JlLhYTYor1hjJsu8aGBt07Q6f2nfDA4itiCmBAX5Xer/YiP+tpg==
X-Received: by 2002:a05:6512:15a6:b0:4fd:d3aa:e425 with SMTP id bp38-20020a05651215a600b004fdd3aae425mr1581912lfb.27.1689752190665;
        Wed, 19 Jul 2023 00:36:30 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-29.business.telecomitalia.it. [87.12.25.29])
        by smtp.gmail.com with ESMTPSA id by27-20020a0564021b1b00b0051d87e72159sm2315237edb.13.2023.07.19.00.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 00:36:29 -0700 (PDT)
Date:   Wed, 19 Jul 2023 09:36:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v2 2/4] vsock/virtio: support to send non-linear
 skb
Message-ID: <4batgyn7pmxn2rysqpztuaim4dxtpfjbrjyyuodsct3qun7w5e@ebd45ngrsfut>
References: <20230718180237.3248179-1-AVKrasnov@sberdevices.ru>
 <20230718180237.3248179-3-AVKrasnov@sberdevices.ru>
 <20230718162202-mutt-send-email-mst@kernel.org>
 <1ac4be11-0814-05af-6c2e-8563ac15e206@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1ac4be11-0814-05af-6c2e-8563ac15e206@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 07:46:05AM +0300, Arseniy Krasnov wrote:
>
>
>On 18.07.2023 23:27, Michael S. Tsirkin wrote:
>> On Tue, Jul 18, 2023 at 09:02:35PM +0300, Arseniy Krasnov wrote:
>>> For non-linear skb use its pages from fragment array as buffers in
>>> virtio tx queue. These pages are already pinned by 'get_user_pages()'
>>> during such skb creation.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>>> ---
>>>  net/vmw_vsock/virtio_transport.c | 40 +++++++++++++++++++++++++++-----
>>>  1 file changed, 34 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>> index e95df847176b..6cbb45bb12d2 100644
>>> --- a/net/vmw_vsock/virtio_transport.c
>>> +++ b/net/vmw_vsock/virtio_transport.c
>>> @@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>>  	vq = vsock->vqs[VSOCK_VQ_TX];
>>>
>>>  	for (;;) {
>>> -		struct scatterlist hdr, buf, *sgs[2];
>>> +		/* +1 is for packet header. */
>>> +		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
>>> +		struct scatterlist bufs[MAX_SKB_FRAGS + 1];
>>>  		int ret, in_sg = 0, out_sg = 0;
>>>  		struct sk_buff *skb;
>>>  		bool reply;
>>> @@ -111,12 +113,38 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>>
>>>  		virtio_transport_deliver_tap_pkt(skb);
>>>  		reply = virtio_vsock_skb_reply(skb);
>>> +		sg_init_one(&bufs[out_sg], virtio_vsock_hdr(skb),
>>> +			    sizeof(*virtio_vsock_hdr(skb)));
>>> +		sgs[out_sg] = &bufs[out_sg];
>>> +		out_sg++;
>>> +
>>> +		if (!skb_is_nonlinear(skb)) {
>>> +			if (skb->len > 0) {
>>> +				sg_init_one(&bufs[out_sg], skb->data, skb->len);
>>> +				sgs[out_sg] = &bufs[out_sg];
>>> +				out_sg++;
>>> +			}
>>> +		} else {
>>> +			struct skb_shared_info *si;
>>> +			int i;
>>> +
>>> +			si = skb_shinfo(skb);
>>> +
>>> +			for (i = 0; i < si->nr_frags; i++) {
>>> +				skb_frag_t *skb_frag = &si->frags[i];
>>> +				void *va = page_to_virt(skb_frag->bv_page);
>>>
>>> -		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>>> -		sgs[out_sg++] = &hdr;
>>> -		if (skb->len > 0) {
>>> -			sg_init_one(&buf, skb->data, skb->len);
>>> -			sgs[out_sg++] = &buf;
>>> +				/* We will use 'page_to_virt()' for userspace page here,
>>
>> don't put comments after code they refer to, please?
>>
>>> +				 * because virtio layer will call 'virt_to_phys()' later
>>
>> it will but not always. sometimes it's the dma mapping layer.
>>
>>
>>> +				 * to fill buffer descriptor. We don't touch memory at
>>> +				 * "virtual" address of this page.
>>
>>
>> you need to stick "the" in a bunch of places above.
>
>Ok, I'll fix this comment!
>
>>
>>> +				 */
>>> +				sg_init_one(&bufs[out_sg],
>>> +					    va + skb_frag->bv_offset,
>>> +					    skb_frag->bv_len);
>>> +				sgs[out_sg] = &bufs[out_sg];
>>> +				out_sg++;
>>> +			}
>>>  		}
>>>
>>>  		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>>
>>
>> There's a problem here: if there vq is small this will fail.
>> So you really should check free vq s/gs and switch to non-zcopy
>> if too small.
>
>Ok, so idea is that:
>
>if (out_sg > vq->num_free)
>    reorganise current skb for copy mode (e.g. 2 out_sg - header and data)
>    and try to add it to vq again.
>
>?
>
>@Stefano, I'll remove net-next tag (guess RFC is not required again, but not net-next
>anyway) as this change will require review. R-b I think should be also removed. All
>other patches in this set still unchanged.

It's still a new feature so we have net-next tree as the target, right?

I think we should keep net-next. Even if patches require to be
re-reviewed, net-next indicates the tree where we want these to be merge
and for new features is the right one.

Ack for not putting RFC again and for R-b removal for this patch.

Thanks,
Stefano

