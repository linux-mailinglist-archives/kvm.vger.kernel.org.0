Return-Path: <kvm+bounces-68693-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2OHQH+2gcGlyYgAAu9opvQ
	(envelope-from <kvm+bounces-68693-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:48:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DF93554A8C
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0A97D8890F0
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1315343637F;
	Wed, 21 Jan 2026 09:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="oLPc+O2a"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B2E3ACEE8;
	Wed, 21 Jan 2026 09:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768987967; cv=none; b=DhrXnnzPXB/AWjSm+Bd1Inibd3llfIP40w+adTw16L40Zvz6jiu4ZejqDTTQjralJzj/ExArnUNqYXkVJhFJNG2S2fmgkr7ABKu4FW+Bzls+BVlRKXdtum7dKtqCeqtd1xONjXGmcMnuCegJVVmzGlkuAvkKiFEXJl1kWkCA/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768987967; c=relaxed/simple;
	bh=S6Jsr9iC1GnVhpjf+bKMgc9kqfY4K5WhFGlPiUf4D5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=neufYmS2FbM9EJiHMukk0ypHuGSmnrCyOhDUAgIxsJeFZRmH6JQ/mY84wAbEJEQbVgC0aZ3JXDHuBI2cCpSJFAlSFcJ4t6lgxvAr4M9jN4nn32JEr5RX+sSbZAbU1pnS6ZcZg9weLmAeEXLTUH6E9rVaMDowk958ow9dLFAWelM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=oLPc+O2a; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.154] ([129.217.186.154])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 60L9WTZn002712
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 10:32:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1768987950;
	bh=S6Jsr9iC1GnVhpjf+bKMgc9kqfY4K5WhFGlPiUf4D5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oLPc+O2a+imba04rEJKdoffOHEI3asOVNiGnLpMjfxgrQvT/+R5Wxp6keF24mbA26
	 aH6sY8FA3gQ6Gq4JT5v8QeONQnluxk7jCFygUmvE4sroDo4KYMibV5g8Wb0DdGQtGW
	 VeHETgZHaQkMGedV1/x8YlYBotJSzhkj3fMpuSQk=
Message-ID: <afa40345-acbe-42b0-81d1-0a838343792d@tu-dortmund.de>
Date: Wed, 21 Jan 2026 10:32:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper with
 netdev queue wakeup
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-4-simon.schippers@tu-dortmund.de>
 <CACGkMEuSiEcyaeFeZd0=RgNpviJgNvUDq_ctjeMLT5jZTgRkwQ@mail.gmail.com>
 <1e30464c-99ae-441e-bb46-6d0485d494dc@tu-dortmund.de>
 <CACGkMEtzD3ORJuJcc8VeqwASiGeVFdQmJowsK6PYVEF_Zkcn8Q@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEtzD3ORJuJcc8VeqwASiGeVFdQmJowsK6PYVEF_Zkcn8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.46 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[tu-dortmund.de:s=unimail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-68693-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,redhat.com,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[tu-dortmund.de,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[simon.schippers@tu-dortmund.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[tu-dortmund.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tu-dortmund.de:email,tu-dortmund.de:dkim,tu-dortmund.de:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: DF93554A8C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/9/26 07:02, Jason Wang wrote:
> On Thu, Jan 8, 2026 at 3:41 PM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> On 1/8/26 04:38, Jason Wang wrote:
>>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>
>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_consume()
>>>> and wake the corresponding netdev subqueue when consuming an entry frees
>>>> space in the underlying ptr_ring.
>>>>
>>>> Stopping of the netdev queue when the ptr_ring is full will be introduced
>>>> in an upcoming commit.
>>>>
>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>> ---
>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>>> index 1197f245e873..2442cf7ac385 100644
>>>> --- a/drivers/net/tap.c
>>>> +++ b/drivers/net/tap.c
>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>>>         return ret ? ret : total;
>>>>  }
>>>>
>>>> +static void *tap_ring_consume(struct tap_queue *q)
>>>> +{
>>>> +       struct ptr_ring *ring = &q->ring;
>>>> +       struct net_device *dev;
>>>> +       void *ptr;
>>>> +
>>>> +       spin_lock(&ring->consumer_lock);
>>>> +
>>>> +       ptr = __ptr_ring_consume(ring);
>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>> +               rcu_read_lock();
>>>> +               dev = rcu_dereference(q->tap)->dev;
>>>> +               netif_wake_subqueue(dev, q->queue_index);
>>>> +               rcu_read_unlock();
>>>> +       }
>>>> +
>>>> +       spin_unlock(&ring->consumer_lock);
>>>> +
>>>> +       return ptr;
>>>> +}
>>>> +
>>>>  static ssize_t tap_do_read(struct tap_queue *q,
>>>>                            struct iov_iter *to,
>>>>                            int noblock, struct sk_buff *skb)
>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>>>>                                         TASK_INTERRUPTIBLE);
>>>>
>>>>                 /* Read frames from the queue */
>>>> -               skb = ptr_ring_consume(&q->ring);
>>>> +               skb = tap_ring_consume(q);
>>>>                 if (skb)
>>>>                         break;
>>>>                 if (noblock) {
>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>> index 8192740357a0..7148f9a844a4 100644
>>>> --- a/drivers/net/tun.c
>>>> +++ b/drivers/net/tun.c
>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>>         return total;
>>>>  }
>>>>
>>>> +static void *tun_ring_consume(struct tun_file *tfile)
>>>> +{
>>>> +       struct ptr_ring *ring = &tfile->tx_ring;
>>>> +       struct net_device *dev;
>>>> +       void *ptr;
>>>> +
>>>> +       spin_lock(&ring->consumer_lock);
>>>> +
>>>> +       ptr = __ptr_ring_consume(ring);
>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>
>>> I guess it's the "bug" I mentioned in the previous patch that leads to
>>> the check of __ptr_ring_consume_created_space() here. If it's true,
>>> another call to tweak the current API.
>>>
>>>> +               rcu_read_lock();
>>>> +               dev = rcu_dereference(tfile->tun)->dev;
>>>> +               netif_wake_subqueue(dev, tfile->queue_index);
>>>
>>> This would cause the producer TX_SOFTIRQ to run on the same cpu which
>>> I'm not sure is what we want.
>>
>> What else would you suggest calling to wake the queue?
> 
> I don't have a good method in my mind, just want to point out its implications.

I have to admit I'm a bit stuck at this point, particularly with this
aspect.

What is the correct way to pass the producer CPU ID to the consumer?
Would it make sense to store smp_processor_id() in the tfile inside
tun_net_xmit(), or should it instead be stored in the skb (similar to the
XDP bit)? In the latter case, my concern is that this information may
already be significantly outdated by the time it is used.

Based on that, my idea would be for the consumer to wake the producer by
invoking a new function (e.g., tun_wake_queue()) on the producer CPU via
smp_call_function_single().
Is this a reasonable approach?

More generally, would triggering TX_SOFTIRQ on the consumer CPU be
considered a deal-breaker for the patch set?

Thanks!

> 
>>
>>>
>>>> +               rcu_read_unlock();
>>>> +       }
>>>
>>> Btw, this function duplicates a lot of logic of tap_ring_consume() we
>>> should consider to merge the logic.
>>
>> Yes, it is largely the same approach, but it would require accessing the
>> net_device each time.
> 
> The problem is that, at least for TUN, the socket is loosely coupled
> with the netdev. It means the netdev can go away while the socket
> might still exist. That's why vhost only talks to the socket, not the
> netdev. If we really want to go this way, here, we should at least
> check the existence of tun->dev first.
> 
>>
>>>
>>>> +
>>>> +       spin_unlock(&ring->consumer_lock);
>>>> +
>>>> +       return ptr;
>>>> +}
>>>> +
>>>>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>>>  {
>>>>         DECLARE_WAITQUEUE(wait, current);
>>>>         void *ptr = NULL;
>>>>         int error = 0;
>>>>
>>>> -       ptr = ptr_ring_consume(&tfile->tx_ring);
>>>> +       ptr = tun_ring_consume(tfile);
>>>
>>> I'm not sure having a separate patch like this may help. For example,
>>> it will introduce performance regression.
>>
>> I ran benchmarks for the whole patch set with noqueue (where the queue is
>> not stopped to preserve the old behavior), as described in the cover
>> letter, and observed no performance regression. This leads me to conclude
>> that there is no performance impact because of this patch when the queue
>> is not stopped.
> 
> Have you run a benchmark per patch? Or it might just be because the
> regression is not obvious. But at least this patch would introduce
> more atomic operations or it might just because the TUN doesn't
> support burst so pktgen can't have the best PPS.
> 
> Thanks
> 
> 
>>
>>>
>>>>         if (ptr)
>>>>                 goto out;
>>>>         if (noblock) {
>>>> @@ -2131,7 +2152,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>>>
>>>>         while (1) {
>>>>                 set_current_state(TASK_INTERRUPTIBLE);
>>>> -               ptr = ptr_ring_consume(&tfile->tx_ring);
>>>> +               ptr = tun_ring_consume(tfile);
>>>>                 if (ptr)
>>>>                         break;
>>>>                 if (signal_pending(current)) {
>>>> --
>>>> 2.43.0
>>>>
>>>
>>> Thanks
>>>
>>
> 

