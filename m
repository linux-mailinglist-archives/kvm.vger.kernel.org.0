Return-Path: <kvm+bounces-71121-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sFWkCnkbk2mM1gEAu9opvQ
	(envelope-from <kvm+bounces-71121-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 14:28:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B204A143CB7
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 14:28:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D639F300AC90
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 13:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59C030EF88;
	Mon, 16 Feb 2026 13:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="C67w/Z7q"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8833090D4;
	Mon, 16 Feb 2026 13:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771248487; cv=none; b=FDrGzbhhuBh4jOqnc/ILTDdIpj8VxEm9gJ1aSN7HZXhRtDRR9UyRsvdtzaK7dsfsbTkWaoNqc2u1vjJhgH5tusiM6hXopRdf5MRy/oC8qon6iN/ewcbUfKl+8waTJfEz7ZdTztTFKxC69+wixJT6UWUn0WDxEBQOEm3pRD3OSdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771248487; c=relaxed/simple;
	bh=Q9GxoeGeSHdPBrcOB/A8/Eud4D4QnZYsPLmlsC6CaP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJv00oEx8AukVs+ktKfzSDmCpafeR2woFcG/E1YM/WqJyLShE80UV+IJT60uPVD8aT5kwrrSGo4kr3P6sYSwK9xZXtkxG2eOQQhyeQHS+rgIIx3FEVGSjzAHRf0Uxkxp60rFSe/b2E4oSijB2pDc9McC3YaD838Y5GbMD8tDmzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=C67w/Z7q; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 61GDRpGP020196
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 14:27:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1771248474;
	bh=Q9GxoeGeSHdPBrcOB/A8/Eud4D4QnZYsPLmlsC6CaP4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C67w/Z7qMrbkC06uTiYSuP7lOPFQJHlSiWcmVkYQxlSaJw+kJYzE0R+FTXvuuPMh4
	 ooBZw1Na0/BFVt3mGEh1d1C9yaJXCQjykXBbuJ/FrPgsiXK9T8mT/WsUNEN9ho6bKw
	 I+ta05lMo0ykF/rECo7IifwDNanOol6gh42YCvlU=
Message-ID: <4aeb991b-26e9-4a2e-81a2-85e3ecd6a8a5@tu-dortmund.de>
Date: Mon, 16 Feb 2026 14:27:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper with
 netdev queue wakeup
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
 <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
 <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
 <CACGkMEte=LwvkxPh-tesJHLVYQV1YZF4is1Yamokhkzaf5GOWw@mail.gmail.com>
 <205aa139-975d-4092-aa04-a2c570ae43a6@tu-dortmund.de>
 <CACGkMEtRikexX=cJz8zmuvW7mcO7uCFdG7AoHQLOezrsb5nbgQ@mail.gmail.com>
 <59529fd2-2a08-4a89-a853-27198b76f842@tu-dortmund.de>
 <20260214131703-mutt-send-email-mst@kernel.org>
 <1ab166aa-8e9c-4742-a80a-c2fa806218db@tu-dortmund.de>
 <20260215053411-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20260215053411-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[tu-dortmund.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[tu-dortmund.de:s=unimail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71121-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[simon.schippers@tu-dortmund.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[tu-dortmund.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tu-dortmund.de:mid,tu-dortmund.de:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B204A143CB7
X-Rspamd-Action: no action

On 2/15/26 11:38, Michael S. Tsirkin wrote:
> On Sat, Feb 14, 2026 at 08:51:53PM +0100, Simon Schippers wrote:
>> On 2/14/26 19:18, Michael S. Tsirkin wrote:
>>> On Sat, Feb 14, 2026 at 06:13:14PM +0100, Simon Schippers wrote:
>>>
>>> ...
>>>
>>>> Patched: Waking on __ptr_ring_produce_created_space() is too early. The
>>>>          stop/wake cycle occurs too frequently which slows down
>>>>          performance as can be seen for TAP.
>>>>
>>>> Wake on empty variant: Waking on __ptr_ring_empty() is (slightly) too
>>>>                        late. The consumer starves because the producer
>>>>                        first has to produce packets again. This slows
>>>>                        down performance aswell as can be seen for TAP
>>>> 		       and TAP+vhost-net (both down ~30-40Kpps).
>>>>
>>>> I think something inbetween should be used.
>>>> The wake should be done as late as possible to have as few
>>>> NET_TX_SOFTIRQs as possible but early enough that there are still
>>>> consumable packets remaining to not starve the consumer.
>>>>
>>>> However, I can not think of a proper way to implement this right now.
>>>>
>>>> Thanks!
>>>
>>> What is the difficulty?
>>
>> There is no way to tell how many entries are currently in the ring.
>>
>>>
>>> Your patches check __ptr_ring_consume_created_space(..., 1).
>>
>> Yes, and this returns if either 0 space or a batch size space was
>> created.
>> (In the current implementation it would be false or true, but as
>> discussed earlier this can be changed.)
>>
>>>
>>> How about __ptr_ring_consume_created_space(..., 8) then? 16?
>>>
>>
>> This would return how much space the last 8/16 consume operations
>> created. But in tap_ring_consume() we only consume a single entry.
>>
>> Maybe we could avoid __ptr_ring_consume_created_space with this:
>> 1. Wait for the queue to stop with netif_tx_queue_stopped()
>> 2. Then count the numbers of consumes we did after the queue stopped
>> 3. Wake the queue if count >= threshold with threshold >= ring->batch
>>
>> I would say that such a threshold could be something like ring->size/2.
> 
> 
> To add to what i wrote, size/2 means:
> leave half a ring for consumer, half a ring for producer.
> 
> If one of the two is more bursty, we might want a different
> balance. Offhand, the kernel is less bursty and userspace is
> more bursty.
> 
> So it's an interesting question but size/2 is a good start.
> 

I implemented this (I can post the implementation if you want)
and I got:
- 1216Kpps for TAP --> worse performance than stock (1293 Kpps) and
  also worse performance than wake on empty (1248 Kpps)
- 1408Kpps for TAP+vhost-net --> pretty much same performance as
  stock (1411 Kpps)

I also tried 7/8 for producer, 1/8 for consumer the results did not
really get better: 
- 1227Kpps for TAP --> worse performance than stock (1293 Kpps) and
  also worse performance than wake on empty (1248 Kpps); better
  performance than 1/2
- 1350Kpps for TAP+vhost-net --> worse performance than everything


So my theory of using something inbetween did not hold up here.
Judging from my benchmarking the best solution would be to use:
- Wake on empty for TAP --> 1248Kpps (1293 Kpps stock, 3% worse)
- Wake on __ptr_ring_consume_created_space() for TAP+vhost-net
  --> 1410Kpps (1411 Kpps stock, 0% worse)

This would also keep the implementation simple.


