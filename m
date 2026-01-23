Return-Path: <kvm+bounces-68955-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BLdLeZFc2mHuQAAu9opvQ
	(envelope-from <kvm+bounces-68955-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 10:56:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86CDA73BE3
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 10:56:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AE8DA301C032
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 09:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E13B37FF56;
	Fri, 23 Jan 2026 09:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="mU0/HmTc"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7335D607;
	Fri, 23 Jan 2026 09:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769162089; cv=none; b=Gg6cZhCJjZiAD4hh8R3wpbC6ff78DcdCUGiyJ6g6vfLIxE5Xe+/pO85mOajmqrlYgEGFJso59yjJcdQJdFAnHMWlYRzA7wld2xyrzI7kVZkvNlFLarjd6RsL0yUAMOnzGrwmM9n5b/+1TBfudmLhbVuf3/t+Td64pyT9e4C4FwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769162089; c=relaxed/simple;
	bh=q85x/6xAKg2JqfTmKOYVSrUZKkpTdeUW8/rVSPPswwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eC4qgfi0Siv+9shGd03jF9wGLqioFhWdBT9sFQxUeskH71Gsta5DtfiwVXEog+nPetu4qPI3lbiVwN2HLSMNjSUqbeuk8ijfoVGn1BrubWAWy5vdzqq4fryMeDbUHu3nHcZPkfKxPKTpO+0C0y8g1ek+tGrKKrKpEbcDBFmQkNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=mU0/HmTc; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 60N9sKhv029982
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Jan 2026 10:54:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1769162064;
	bh=q85x/6xAKg2JqfTmKOYVSrUZKkpTdeUW8/rVSPPswwU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mU0/HmTcWDjTKJZrvCA1imaBamUMg6WcRCWfR6beSdn4g3lYa9SCb61Ceb7ns55qJ
	 VFoDs9jduxRERJFByWfddM+bzjj3bzhU6OjzAVRdOHh4l8VlJa961iLEDWoIUypW45
	 fTx7bymBgFzhHZ5Ae+KxBTabTDm5p5m6U/k99J+o=
Message-ID: <bc1078e5-65fc-4de6-8475-517f626d8d96@tu-dortmund.de>
Date: Fri, 23 Jan 2026 10:54:20 +0100
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
 <afa40345-acbe-42b0-81d1-0a838343792d@tu-dortmund.de>
 <CACGkMEtxRoavBMTXom8Z=FM-pvu3pHbsuwCs+e450b1B=V7iWA@mail.gmail.com>
 <CACGkMEsJKeEsH=G8H5RzMNHY4g3HNdciMDMhciShawh-9Xb9hg@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEsJKeEsH=G8H5RzMNHY4g3HNdciMDMhciShawh-9Xb9hg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[tu-dortmund.de,none];
	R_DKIM_ALLOW(-0.20)[tu-dortmund.de:s=unimail];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68955-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,redhat.com,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[simon.schippers@tu-dortmund.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[tu-dortmund.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,tu-dortmund.de:email,tu-dortmund.de:dkim,tu-dortmund.de:mid]
X-Rspamd-Queue-Id: 86CDA73BE3
X-Rspamd-Action: no action

On 1/23/26 04:05, Jason Wang wrote:
> On Thu, Jan 22, 2026 at 1:35 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On Wed, Jan 21, 2026 at 5:33 PM Simon Schippers
>> <simon.schippers@tu-dortmund.de> wrote:
>>>
>>> On 1/9/26 07:02, Jason Wang wrote:
>>>> On Thu, Jan 8, 2026 at 3:41 PM Simon Schippers
>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>
>>>>> On 1/8/26 04:38, Jason Wang wrote:
>>>>>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>
>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_consume()
>>>>>>> and wake the corresponding netdev subqueue when consuming an entry frees
>>>>>>> space in the underlying ptr_ring.
>>>>>>>
>>>>>>> Stopping of the netdev queue when the ptr_ring is full will be introduced
>>>>>>> in an upcoming commit.
>>>>>>>
>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>>>>> ---
>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>>>>>> index 1197f245e873..2442cf7ac385 100644
>>>>>>> --- a/drivers/net/tap.c
>>>>>>> +++ b/drivers/net/tap.c
>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>>>>>>         return ret ? ret : total;
>>>>>>>  }
>>>>>>>
>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
>>>>>>> +{
>>>>>>> +       struct ptr_ring *ring = &q->ring;
>>>>>>> +       struct net_device *dev;
>>>>>>> +       void *ptr;
>>>>>>> +
>>>>>>> +       spin_lock(&ring->consumer_lock);
>>>>>>> +
>>>>>>> +       ptr = __ptr_ring_consume(ring);
>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>>>>> +               rcu_read_lock();
>>>>>>> +               dev = rcu_dereference(q->tap)->dev;
>>>>>>> +               netif_wake_subqueue(dev, q->queue_index);
>>>>>>> +               rcu_read_unlock();
>>>>>>> +       }
>>>>>>> +
>>>>>>> +       spin_unlock(&ring->consumer_lock);
>>>>>>> +
>>>>>>> +       return ptr;
>>>>>>> +}
>>>>>>> +
>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>>                            struct iov_iter *to,
>>>>>>>                            int noblock, struct sk_buff *skb)
>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>>                                         TASK_INTERRUPTIBLE);
>>>>>>>
>>>>>>>                 /* Read frames from the queue */
>>>>>>> -               skb = ptr_ring_consume(&q->ring);
>>>>>>> +               skb = tap_ring_consume(q);
>>>>>>>                 if (skb)
>>>>>>>                         break;
>>>>>>>                 if (noblock) {
>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>>>> index 8192740357a0..7148f9a844a4 100644
>>>>>>> --- a/drivers/net/tun.c
>>>>>>> +++ b/drivers/net/tun.c
>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>>>>>         return total;
>>>>>>>  }
>>>>>>>
>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
>>>>>>> +{
>>>>>>> +       struct ptr_ring *ring = &tfile->tx_ring;
>>>>>>> +       struct net_device *dev;
>>>>>>> +       void *ptr;
>>>>>>> +
>>>>>>> +       spin_lock(&ring->consumer_lock);
>>>>>>> +
>>>>>>> +       ptr = __ptr_ring_consume(ring);
>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>>>>
>>>>>> I guess it's the "bug" I mentioned in the previous patch that leads to
>>>>>> the check of __ptr_ring_consume_created_space() here. If it's true,
>>>>>> another call to tweak the current API.
>>>>>>
>>>>>>> +               rcu_read_lock();
>>>>>>> +               dev = rcu_dereference(tfile->tun)->dev;
>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_index);
>>>>>>
>>>>>> This would cause the producer TX_SOFTIRQ to run on the same cpu which
>>>>>> I'm not sure is what we want.
>>>>>
>>>>> What else would you suggest calling to wake the queue?
>>>>
>>>> I don't have a good method in my mind, just want to point out its implications.
>>>
>>> I have to admit I'm a bit stuck at this point, particularly with this
>>> aspect.
>>>
>>> What is the correct way to pass the producer CPU ID to the consumer?
>>> Would it make sense to store smp_processor_id() in the tfile inside
>>> tun_net_xmit(), or should it instead be stored in the skb (similar to the
>>> XDP bit)? In the latter case, my concern is that this information may
>>> already be significantly outdated by the time it is used.
>>>
>>> Based on that, my idea would be for the consumer to wake the producer by
>>> invoking a new function (e.g., tun_wake_queue()) on the producer CPU via
>>> smp_call_function_single().
>>> Is this a reasonable approach?
>>
>> I'm not sure but it would introduce costs like IPI.
>>
>>>
>>> More generally, would triggering TX_SOFTIRQ on the consumer CPU be
>>> considered a deal-breaker for the patch set?
>>
>> It depends on whether or not it has effects on the performance.
>> Especially when vhost is pinned.
> 
> I meant we can benchmark to see the impact. For example, pin vhost to
> a specific CPU and the try to see the impact of the TX_SOFTIRQ.
> 
> Thanks
> 

I ran benchmarks with vhost pinned to CPU 0 using taskset -p -c 0 ...
for both the stock and patched versions. The benchmarks were run with
the full patch series applied, since testing only patches 1-3 would not
be meaningful - the queue is never stopped in that case, so no
TX_SOFTIRQ is triggered.

Compared to the non-pinned CPU benchmarks in the cover letter,
performance is lower for pktgen with a single thread but higher with
four threads. The results show no regression for the patched version,
with even slight performance improvements observed:

+-------------------------+-----------+----------------+
| pktgen benchmarks to    | Stock     | Patched with   |
| Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
| 100M packets            |           |                |
| vhost pinned to core 0  |           |                |
+-----------+-------------+-----------+----------------+
| TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
|  +        +-------------+-----------+----------------+
| vhost-net | Lost        | 1154 Kpps | 0              |
+-----------+-------------+-----------+----------------+

+-------------------------+-----------+----------------+
| pktgen benchmarks to    | Stock     | Patched with   |
| Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
| 100M packets            |           |                |
| vhost pinned to core 0  |           |                |
| *4 threads*             |           |                |
+-----------+-------------+-----------+----------------+
| TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
|  +        +-------------+-----------+----------------+
| vhost-net | Lost        | 1527 Kpps | 0              |
+-----------+-------------+-----------+----------------+

+------------------------+-------------+----------------+
| iperf3 TCP benchmarks  | Stock       | Patched with   |
| to Debian VM 120s      |             | fq_codel qdisc |
| vhost pinned to core 0 |             |                |
+------------------------+-------------+----------------+
| TAP                    | 22.0 Gbit/s | 22.0 Gbit/s    |
|  +                     |             |                |
| vhost-net              |             |                |
+------------------------+-------------+----------------+

+---------------------------+-------------+----------------+
| iperf3 TCP benchmarks     | Stock       | Patched with   |
| to Debian VM 120s         |             | fq_codel qdisc |
| vhost pinned to core 0    |             |                |
| *4 iperf3 client threads* |             |                |
+---------------------------+-------------+----------------+
| TAP                       | 21.4 Gbit/s | 21.5 Gbit/s    |
|  +                        |             |                |
| vhost-net                 |             |                |
+---------------------------+-------------+----------------+

