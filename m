Return-Path: <kvm+bounces-71101-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IEZ9HIXSkGl3dAEAu9opvQ
	(envelope-from <kvm+bounces-71101-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 20:52:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3EB13D167
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 20:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8251B302EEAA
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 19:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A2B30DD00;
	Sat, 14 Feb 2026 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="XbUQP6dZ"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBF71D5ABA;
	Sat, 14 Feb 2026 19:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771098728; cv=none; b=VOBy2CAqvKB1UkxneEPVNWqrd0edwcphulsgvWHNavFVeXlCzuP4r/5TcVPVPsF9dH5PNYbDcGZ11q/RJlLvN4fSaMFkt8mvKNWVL6I0jfdEe25DtCQ14x6+bqKO5v0WZQ1eZQqJy7QYwI711dHngyjrx/DvXfEUBwXP9z/qyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771098728; c=relaxed/simple;
	bh=O5oUb9SrEAeUxPySAQ+ao3ohEjafJkj+zkJqWx2/KM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uBRQV6mv4APAJi6sA60lCe/L9jwyZ9FHbxLfHKdWuhZPtyH7H2alAIovnWkIs98b+aRwArryzJnatgoCD1B+4tFdc22k2oOgWPgeJP57lgP5ciVYHVFHduOLc6qwaz0zM1BDSyuIeXISQ831Al6cYC3EP11oPmTXyFOTIRIVmtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=XbUQP6dZ; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 61EJprKh017235
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 14 Feb 2026 20:51:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1771098714;
	bh=O5oUb9SrEAeUxPySAQ+ao3ohEjafJkj+zkJqWx2/KM4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XbUQP6dZ0XCE9d3ZjKknm6+If26OQBS5jkhlJOMU3jKCVe+LEtNhDT7Q7tVt/PWlW
	 McHiIElIDa6A943F3t7wLLAMVWPLWtbflWDc7PDMjNP7ynYXb5QYfYT3sd91sOtgtb
	 r4tDRE3z52ptjMhssDBWrYsElT89iQgJh0wG+P8I=
Message-ID: <1ab166aa-8e9c-4742-a80a-c2fa806218db@tu-dortmund.de>
Date: Sat, 14 Feb 2026 20:51:53 +0100
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
References: <CACGkMEtnLw2b8iDysQzRbXxTj2xbgzKqEZUbhmZz9tXPLTE6Sw@mail.gmail.com>
 <0ebc00ba-35e7-4570-a44f-b0ae634f2316@tu-dortmund.de>
 <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
 <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
 <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
 <CACGkMEte=LwvkxPh-tesJHLVYQV1YZF4is1Yamokhkzaf5GOWw@mail.gmail.com>
 <205aa139-975d-4092-aa04-a2c570ae43a6@tu-dortmund.de>
 <CACGkMEtRikexX=cJz8zmuvW7mcO7uCFdG7AoHQLOezrsb5nbgQ@mail.gmail.com>
 <59529fd2-2a08-4a89-a853-27198b76f842@tu-dortmund.de>
 <20260214131703-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20260214131703-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[tu-dortmund.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[tu-dortmund.de:s=unimail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71101-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1F3EB13D167
X-Rspamd-Action: no action

On 2/14/26 19:18, Michael S. Tsirkin wrote:
> On Sat, Feb 14, 2026 at 06:13:14PM +0100, Simon Schippers wrote:
> 
> ...
> 
>> Patched: Waking on __ptr_ring_produce_created_space() is too early. The
>>          stop/wake cycle occurs too frequently which slows down
>>          performance as can be seen for TAP.
>>
>> Wake on empty variant: Waking on __ptr_ring_empty() is (slightly) too
>>                        late. The consumer starves because the producer
>>                        first has to produce packets again. This slows
>>                        down performance aswell as can be seen for TAP
>> 		       and TAP+vhost-net (both down ~30-40Kpps).
>>
>> I think something inbetween should be used.
>> The wake should be done as late as possible to have as few
>> NET_TX_SOFTIRQs as possible but early enough that there are still
>> consumable packets remaining to not starve the consumer.
>>
>> However, I can not think of a proper way to implement this right now.
>>
>> Thanks!
> 
> What is the difficulty?

There is no way to tell how many entries are currently in the ring.

> 
> Your patches check __ptr_ring_consume_created_space(..., 1).

Yes, and this returns if either 0 space or a batch size space was
created.
(In the current implementation it would be false or true, but as
discussed earlier this can be changed.)

> 
> How about __ptr_ring_consume_created_space(..., 8) then? 16?
> 

This would return how much space the last 8/16 consume operations
created. But in tap_ring_consume() we only consume a single entry.

Maybe we could avoid __ptr_ring_consume_created_space with this:
1. Wait for the queue to stop with netif_tx_queue_stopped()
2. Then count the numbers of consumes we did after the queue stopped
3. Wake the queue if count >= threshold with threshold >= ring->batch

I would say that such a threshold could be something like ring->size/2.


