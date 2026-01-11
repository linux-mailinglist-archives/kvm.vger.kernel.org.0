Return-Path: <kvm+bounces-67669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D22D0EA52
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 12:00:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 16AED30087BD
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 11:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276EC335BCC;
	Sun, 11 Jan 2026 11:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="gIttdBbc"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B151F583D
	for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 11:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768129217; cv=none; b=MxFljECm6m0cPIkDzG5Urk0hQOQ8oPVCoX4dKxAVe2CmGiys7p9KuD0VI7z+G6H+1uqnKTpUkMUCdw0WZqPqAo1UX0nuQHB6jsqAhqPgGKnhNnM1GUTG4sRyhrTNW5G86a0nRSlUjMFq7LTIUyG+C3nqhzpwAEKGk5au2EQ3Vd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768129217; c=relaxed/simple;
	bh=meGd7AwSWHQxCNFnfcJQBz3TtBD4Lp2Slh3imR0wTzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E9hjD5A2gsDWqllaqekkurrisIzUTgfx4DIfXZD0hA1uLfMnSBHYC0CKjc8GoTMvOegZ3wGjvGcSWrnCL+mX19PGKbDbN8CIcU733GKRWx7cohVpSm4OH95kYBF25eXN+4hJgJIwywQ/b2OhyY8lsUAOArqpPfkJDj7jYWHEb9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=gIttdBbc; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vetAn-009kGg-Ny; Sun, 11 Jan 2026 11:59:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=scKKsBdmiFKU4HTFxkWMttf7eOA7bKyWv2l9rVYugb4=; b=gIttdBbcr9aXvqOyJrxw1sQn7X
	vSZyoSfnP6otpsl3gPrIFY+QW3o4rV/Gexi20o8WOfcWPWNox+hcMHZ+NBuFlTGAWS4RNms0qSlna
	f9Nx3sXU8mvf1J2EK6wWcyfGilKq15eylLUpfFx/Fce4c9xYNGJS5XCmuM3/+PBv4gP423Wdw1fuy
	RDnst5SluxsjoG7zlh1pZ0e/FzuSrPDy3z5/JaL7dchT/BxrALwHy2ipy39MowBegNJtFIG86xVFb
	Fp8rSxpWbAjKHs2ACzymtVCPQ6t4UUQlOkSVfOBKtfAavPPfZIiW+HXm1IjZ+QBI5IE96g83kFtr3
	YAAuKpvQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vetAm-0003Gy-Qw; Sun, 11 Jan 2026 11:59:52 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vetAg-007axd-2J; Sun, 11 Jan 2026 11:59:46 +0100
Message-ID: <ae564ab4-2dd2-4a12-a92c-b613fa430829@rbox.co>
Date: Sun, 11 Jan 2026 11:59:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] vsock/virtio: Coalesce only linear skb
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
 <20260108-vsock-recv-coalescence-v1-1-26f97bb9a99b@rbox.co>
 <aWEnYm6ePitdHPQe@sgarzare-redhat>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <aWEnYm6ePitdHPQe@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 17:18, Stefano Garzarella wrote:
> On Thu, Jan 08, 2026 at 10:54:54AM +0100, Michal Luczaj wrote:
...
>> @@ -1375,7 +1375,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>> 		 * of a new message.
>> 		 */
>> 		if (skb->len < skb_tailroom(last_skb) &&
>> -		    !(le32_to_cpu(last_hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)) {
>> +		    !(le32_to_cpu(last_hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) &&
>> +		    !skb_is_nonlinear(skb)) {
> 
> Why here? I mean we can do the check even early, something like this:
> 
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1361,7 +1361,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>           * to avoid wasting memory queueing the entire buffer with a small
>           * payload.
>           */
> -       if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue)) {
> +       if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue) &&
> +           !skb_is_nonlinear(skb)) {
>                  struct virtio_vsock_hdr *last_hdr;
>                  struct sk_buff *last_skb;

Right, can do. I've assumed skb being non-linear is the least likely in
this context.

> I would also add the reason in the comment before that to make it clear.

OK, sure.


