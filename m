Return-Path: <kvm+bounces-71097-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gMwLFmStkGmscAEAu9opvQ
	(envelope-from <kvm+bounces-71097-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 18:14:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF3713C93E
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 18:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D3542302BEB0
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 17:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE692D9EDB;
	Sat, 14 Feb 2026 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="g6Vt3UkO"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFE881724;
	Sat, 14 Feb 2026 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771089217; cv=none; b=olZGLsICXA6+KDz5N5wrnD5PDyTpYrUkgUS+gUITBeWovKmTBgAxuJHZ1QVNv2camFGAD9FSfJOeoYK+O801HfmT9gSoSyluaLekKVar+4RgycDoiS7WvBiLlqD2NtyeLHxIEKId7dY7Gcf+SLphBuwrCjOKIq8d+8NmW3HZ1xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771089217; c=relaxed/simple;
	bh=/nrbYdEUsBjKTxLlLkWb+YdDzuTPCAft9O3yJIdH39w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d09dhuUxA2ZPSXT+lk1h2DojHzxyYHCW8ugDb9aU6IOIkBBcuVkSxhx8jepvnSc390lzTlF5bZHlB33boltb+qVdbKYN+qLu/et/kV17/fk4IIol6xl/pFhaW7cZpIeH3SyMConE9s2lld5tVnx7lgEcSNWxgHagEFUoqB5xj/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=g6Vt3UkO; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 61EHDElZ028939
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 14 Feb 2026 18:13:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1771089196;
	bh=/nrbYdEUsBjKTxLlLkWb+YdDzuTPCAft9O3yJIdH39w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g6Vt3UkOnH3B4dNpVgy201fSIJmXrkfdvCNy6GDOCJ9Jf0CRYrstm8/0Z3f4Q1+y5
	 n3DSZ6W2Go6Bud/d3iZEz/qYCYzk5o7G1xU0/4MZ+LGrm7CLsKpqq4SPHcxIpHRd9r
	 eHPVGU8+0Ia4xM/4qRGLPNM42H0dBppoVVdcZDL0=
Message-ID: <59529fd2-2a08-4a89-a853-27198b76f842@tu-dortmund.de>
Date: Sat, 14 Feb 2026 18:13:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper with
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
 <bc1078e5-65fc-4de6-8475-517f626d8d96@tu-dortmund.de>
 <3a1d6232-efe4-4e79-a196-44794fdc0f33@tu-dortmund.de>
 <CACGkMEv71kn91FPAUrxJg=YB3+B0MRTgOidMPHjK7Qq0WEhGtw@mail.gmail.com>
 <260f48cd-caa1-4684-a235-8e1192722b3a@tu-dortmund.de>
 <CACGkMEsVMz+vS3KxykYBGXvyt3MZcstnYWUiYJZhLSMoHC5Smw@mail.gmail.com>
 <ba17ba38-9f61-4a10-b375-d0da805e6b73@tu-dortmund.de>
 <CACGkMEtnLw2b8iDysQzRbXxTj2xbgzKqEZUbhmZz9tXPLTE6Sw@mail.gmail.com>
 <0ebc00ba-35e7-4570-a44f-b0ae634f2316@tu-dortmund.de>
 <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
 <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
 <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
 <CACGkMEte=LwvkxPh-tesJHLVYQV1YZF4is1Yamokhkzaf5GOWw@mail.gmail.com>
 <205aa139-975d-4092-aa04-a2c570ae43a6@tu-dortmund.de>
 <CACGkMEtRikexX=cJz8zmuvW7mcO7uCFdG7AoHQLOezrsb5nbgQ@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEtRikexX=cJz8zmuvW7mcO7uCFdG7AoHQLOezrsb5nbgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[tu-dortmund.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[tu-dortmund.de:s=unimail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71097-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,redhat.com,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_PROHIBIT(0.00)[0.0.0.0:email];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[simon.schippers@tu-dortmund.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[tu-dortmund.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,stock_pktgen.data:url,pktgen_sample01_simple.sh:url,pktgen_sample03_burst_single_flow.sh:url,wake_on_empty_variant_pktgen.data:url,patched_pktgen.data:url]
X-Rspamd-Queue-Id: ABF3713C93E
X-Rspamd-Action: no action

On 2/12/26 09:14, Jason Wang wrote:
> On Mon, Feb 9, 2026 at 2:18 AM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> On 2/6/26 04:21, Jason Wang wrote:
>>> On Fri, Feb 6, 2026 at 6:28 AM Simon Schippers
>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>
>>>> On 2/5/26 04:59, Jason Wang wrote:
>>>>> On Wed, Feb 4, 2026 at 11:44 PM Simon Schippers
>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>
>>>>>> On 2/3/26 04:48, Jason Wang wrote:
>>>>>>> On Mon, Feb 2, 2026 at 4:19 AM Simon Schippers
>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>
>>>>>>>> On 1/30/26 02:51, Jason Wang wrote:
>>>>>>>>> On Thu, Jan 29, 2026 at 5:25 PM Simon Schippers
>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>
>>>>>>>>>> On 1/29/26 02:14, Jason Wang wrote:
>>>>>>>>>>> On Wed, Jan 28, 2026 at 3:54 PM Simon Schippers
>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> On 1/28/26 08:03, Jason Wang wrote:
>>>>>>>>>>>>> On Wed, Jan 28, 2026 at 12:48 AM Simon Schippers
>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 1/23/26 10:54, Simon Schippers wrote:
>>>>>>>>>>>>>>> On 1/23/26 04:05, Jason Wang wrote:
>>>>>>>>>>>>>>>> On Thu, Jan 22, 2026 at 1:35 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> On Wed, Jan 21, 2026 at 5:33 PM Simon Schippers
>>>>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> On 1/9/26 07:02, Jason Wang wrote:
>>>>>>>>>>>>>>>>>>> On Thu, Jan 8, 2026 at 3:41 PM Simon Schippers
>>>>>>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> On 1/8/26 04:38, Jason Wang wrote:
>>>>>>>>>>>>>>>>>>>>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
>>>>>>>>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_consume()
>>>>>>>>>>>>>>>>>>>>>> and wake the corresponding netdev subqueue when consuming an entry frees
>>>>>>>>>>>>>>>>>>>>>> space in the underlying ptr_ring.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Stopping of the netdev queue when the ptr_ring is full will be introduced
>>>>>>>>>>>>>>>>>>>>>> in an upcoming commit.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>>>>>>>>>>>>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>>>>>>>>>>>>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
>>>>>>>>>>>>>>>>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
>>>>>>>>>>>>>>>>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>>>>>>>>>>>>>>>>>>>>> index 1197f245e873..2442cf7ac385 100644
>>>>>>>>>>>>>>>>>>>>>> --- a/drivers/net/tap.c
>>>>>>>>>>>>>>>>>>>>>> +++ b/drivers/net/tap.c
>>>>>>>>>>>>>>>>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>>>>>>>>>>>>>>>>>>>>>         return ret ? ret : total;
>>>>>>>>>>>>>>>>>>>>>>  }
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
>>>>>>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>>>>>>> +       struct ptr_ring *ring = &q->ring;
>>>>>>>>>>>>>>>>>>>>>> +       struct net_device *dev;
>>>>>>>>>>>>>>>>>>>>>> +       void *ptr;
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>> +       ptr = __ptr_ring_consume(ring);
>>>>>>>>>>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>>>>>>>>>>>>>>>>>>>> +               rcu_read_lock();
>>>>>>>>>>>>>>>>>>>>>> +               dev = rcu_dereference(q->tap)->dev;
>>>>>>>>>>>>>>>>>>>>>> +               netif_wake_subqueue(dev, q->queue_index);
>>>>>>>>>>>>>>>>>>>>>> +               rcu_read_unlock();
>>>>>>>>>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>> +       spin_unlock(&ring->consumer_lock);
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>> +       return ptr;
>>>>>>>>>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>>>>>>>>>>>>>>>>>                            struct iov_iter *to,
>>>>>>>>>>>>>>>>>>>>>>                            int noblock, struct sk_buff *skb)
>>>>>>>>>>>>>>>>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>>>>>>>>>>>>>>>>>                                         TASK_INTERRUPTIBLE);
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>                 /* Read frames from the queue */
>>>>>>>>>>>>>>>>>>>>>> -               skb = ptr_ring_consume(&q->ring);
>>>>>>>>>>>>>>>>>>>>>> +               skb = tap_ring_consume(q);
>>>>>>>>>>>>>>>>>>>>>>                 if (skb)
>>>>>>>>>>>>>>>>>>>>>>                         break;
>>>>>>>>>>>>>>>>>>>>>>                 if (noblock) {
>>>>>>>>>>>>>>>>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>>>>>>>>>>>>>>>>>>> index 8192740357a0..7148f9a844a4 100644
>>>>>>>>>>>>>>>>>>>>>> --- a/drivers/net/tun.c
>>>>>>>>>>>>>>>>>>>>>> +++ b/drivers/net/tun.c
>>>>>>>>>>>>>>>>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>>>>>>>>>>>>>>>>>>>>         return total;
>>>>>>>>>>>>>>>>>>>>>>  }
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
>>>>>>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>>>>>>> +       struct ptr_ring *ring = &tfile->tx_ring;
>>>>>>>>>>>>>>>>>>>>>> +       struct net_device *dev;
>>>>>>>>>>>>>>>>>>>>>> +       void *ptr;
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>> +       ptr = __ptr_ring_consume(ring);
>>>>>>>>>>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> I guess it's the "bug" I mentioned in the previous patch that leads to
>>>>>>>>>>>>>>>>>>>>> the check of __ptr_ring_consume_created_space() here. If it's true,
>>>>>>>>>>>>>>>>>>>>> another call to tweak the current API.
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> +               rcu_read_lock();
>>>>>>>>>>>>>>>>>>>>>> +               dev = rcu_dereference(tfile->tun)->dev;
>>>>>>>>>>>>>>>>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_index);
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> This would cause the producer TX_SOFTIRQ to run on the same cpu which
>>>>>>>>>>>>>>>>>>>>> I'm not sure is what we want.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> What else would you suggest calling to wake the queue?
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> I don't have a good method in my mind, just want to point out its implications.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> I have to admit I'm a bit stuck at this point, particularly with this
>>>>>>>>>>>>>>>>>> aspect.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> What is the correct way to pass the producer CPU ID to the consumer?
>>>>>>>>>>>>>>>>>> Would it make sense to store smp_processor_id() in the tfile inside
>>>>>>>>>>>>>>>>>> tun_net_xmit(), or should it instead be stored in the skb (similar to the
>>>>>>>>>>>>>>>>>> XDP bit)? In the latter case, my concern is that this information may
>>>>>>>>>>>>>>>>>> already be significantly outdated by the time it is used.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Based on that, my idea would be for the consumer to wake the producer by
>>>>>>>>>>>>>>>>>> invoking a new function (e.g., tun_wake_queue()) on the producer CPU via
>>>>>>>>>>>>>>>>>> smp_call_function_single().
>>>>>>>>>>>>>>>>>> Is this a reasonable approach?
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I'm not sure but it would introduce costs like IPI.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> More generally, would triggering TX_SOFTIRQ on the consumer CPU be
>>>>>>>>>>>>>>>>>> considered a deal-breaker for the patch set?
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> It depends on whether or not it has effects on the performance.
>>>>>>>>>>>>>>>>> Especially when vhost is pinned.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> I meant we can benchmark to see the impact. For example, pin vhost to
>>>>>>>>>>>>>>>> a specific CPU and the try to see the impact of the TX_SOFTIRQ.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Thanks
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I ran benchmarks with vhost pinned to CPU 0 using taskset -p -c 0 ...
>>>>>>>>>>>>>>> for both the stock and patched versions. The benchmarks were run with
>>>>>>>>>>>>>>> the full patch series applied, since testing only patches 1-3 would not
>>>>>>>>>>>>>>> be meaningful - the queue is never stopped in that case, so no
>>>>>>>>>>>>>>> TX_SOFTIRQ is triggered.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Compared to the non-pinned CPU benchmarks in the cover letter,
>>>>>>>>>>>>>>> performance is lower for pktgen with a single thread but higher with
>>>>>>>>>>>>>>> four threads. The results show no regression for the patched version,
>>>>>>>>>>>>>>> with even slight performance improvements observed:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> +-------------------------+-----------+----------------+
>>>>>>>>>>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
>>>>>>>>>>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
>>>>>>>>>>>>>>> | 100M packets            |           |                |
>>>>>>>>>>>>>>> | vhost pinned to core 0  |           |                |
>>>>>>>>>>>>>>> +-----------+-------------+-----------+----------------+
>>>>>>>>>>>>>>> | TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
>>>>>>>>>>>>>>> |  +        +-------------+-----------+----------------+
>>>>>>>>>>>>>>> | vhost-net | Lost        | 1154 Kpps | 0              |
>>>>>>>>>>>>>>> +-----------+-------------+-----------+----------------+
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> +-------------------------+-----------+----------------+
>>>>>>>>>>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
>>>>>>>>>>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
>>>>>>>>>>>>>>> | 100M packets            |           |                |
>>>>>>>>>>>>>>> | vhost pinned to core 0  |           |                |
>>>>>>>>>>>>>>> | *4 threads*             |           |                |
>>>>>>>>>>>>>>> +-----------+-------------+-----------+----------------+
>>>>>>>>>>>>>>> | TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
>>>>>>>>>>>>>>> |  +        +-------------+-----------+----------------+
>>>>>>>>>>>>>>> | vhost-net | Lost        | 1527 Kpps | 0              |
>>>>>>>>>>>>>>> +-----------+-------------+-----------+----------------+
>>>>>>>>>>>>>
>>>>>>>>>>>>> The PPS seems to be low. I'd suggest using testpmd (rxonly) mode in
>>>>>>>>>>>>> the guest or an xdp program that did XDP_DROP in the guest.
>>>>>>>>>>>>
>>>>>>>>>>>> I forgot to mention that these PPS values are per thread.
>>>>>>>>>>>> So overall we have 71 Kpps * 4 = 284 Kpps and 79 Kpps * 4 = 326 Kpps,
>>>>>>>>>>>> respectively. For packet loss, that comes out to 1154 Kpps * 4 =
>>>>>>>>>>>> 4616 Kpps and 0, respectively.
>>>>>>>>>>>>
>>>>>>>>>>>> Sorry about that!
>>>>>>>>>>>>
>>>>>>>>>>>> The pktgen benchmarks with a single thread look fine, right?
>>>>>>>>>>>
>>>>>>>>>>> Still looks very low. E.g I just have a run of pktgen (using
>>>>>>>>>>> pktgen_sample03_burst_single_flow.sh) without a XDP_DROP in the guest,
>>>>>>>>>>> I can get 1Mpps.
>>>>>>>>>>
>>>>>>>>>> Keep in mind that I am using an older CPU (i5-6300HQ). For the
>>>>>>>>>> single-threaded tests I always used pktgen_sample01_simple.sh, and for
>>>>>>>>>> the multi-threaded tests I always used pktgen_sample02_multiqueue.sh.
>>>>>>>>>>
>>>>>>>>>> Using pktgen_sample03_burst_single_flow.sh as you did fails for me (even
>>>>>>>>>> though the same parameters work fine for sample01 and sample02):
>>>>>>>>>>
>>>>>>>>>> samples/pktgen/pktgen_sample03_burst_single_flow.sh -i tap0 -m
>>>>>>>>>> 52:54:00:12:34:56 -d 10.0.0.2 -n 100000000
>>>>>>>>>> /samples/pktgen/functions.sh: line 79: echo: write error: Operation not
>>>>>>>>>> supported
>>>>>>>>>> ERROR: Write error(1) occurred
>>>>>>>>>> cmd: "burst 32 > /proc/net/pktgen/tap0@0"
>>>>>>>>>>
>>>>>>>>>> ...and I do not know what I am doing wrong, even after looking at
>>>>>>>>>> Documentation/networking/pktgen.rst. Every burst size except 1 fails.
>>>>>>>>>> Any clues?
>>>>>>>>>
>>>>>>>>> Please use -b 0, and I'm Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz.
>>>>>>>>
>>>>>>>> I tried using "-b 0", and while it worked, there was no noticeable
>>>>>>>> performance improvement.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Another thing I can think of is to disable
>>>>>>>>>
>>>>>>>>> 1) mitigations in both guest and host
>>>>>>>>> 2) any kernel debug features in both host and guest
>>>>>>>>
>>>>>>>> I also rebuilt the kernel with everything disabled under
>>>>>>>> "Kernel hacking", but that didn’t make any difference either.
>>>>>>>>
>>>>>>>> Because of this, I ran "pktgen_sample01_simple.sh" and
>>>>>>>> "pktgen_sample02_multiqueue.sh" on my AMD Ryzen 5 5600X system. The
>>>>>>>> results were about 374 Kpps with TAP and 1192 Kpps with TAP+vhost_net,
>>>>>>>> with very similar performance between the stock and patched kernels.
>>>>>>>>
>>>>>>>> Personally, I think the low performance is to blame on the hardware.
>>>>>>>
>>>>>>> Let's double confirm this by:
>>>>>>>
>>>>>>> 1) make sure pktgen is using 100% CPU
>>>>>>> 2) Perf doesn't show anything strange for pktgen thread
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>
>>>>>> I ran pktgen using pktgen_sample01_simple.sh and, in parallel, started a
>>>>>> 100 second perf stat measurement covering all kpktgend threads.
>>>>>>
>>>>>> Across all configurations, a single CPU was fully utilized.
>>>>>>
>>>>>> Apart from that, the patched variants show a higher branch frequency and
>>>>>> a slightly increased number of context switches.
>>>>>>
>>>>>>
>>>>>> The detailed results are provided below:
>>>>>>
>>>>>> Processor: Ryzen 5 5600X
>>>>>>
>>>>>> pktgen command:
>>>>>> sudo perf stat samples/pktgen/pktgen_sample01_simple.sh -i tap0 -m
>>>>>> 52:54:00:12:34:56 -d 10.0.0.2 -n 10000000000
>>>>>>
>>>>>> perf stat command:
>>>>>> sudo perf stat --timeout 100000 -p $(pgrep kpktgend | tr '\n' ,) -o X.txt
>>>>>>
>>>>>>
>>>>>> Results:
>>>>>> Stock TAP:
>>>>>>             46.997      context-switches                 #    467,2 cs/sec  cs_per_second
>>>>>>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>>>>>>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>>>>>>         100.587,69 msec task-clock                       #      1,0 CPUs  CPUs_utilized
>>>>>>      8.491.586.483      branch-misses                    #     10,9 %  branch_miss_rate         (50,24%)
>>>>>>     77.734.761.406      branches                         #    772,8 M/sec  branch_frequency     (66,85%)
>>>>>>    382.420.291.585      cpu-cycles                       #      3,8 GHz  cycles_frequency       (66,85%)
>>>>>>    377.612.185.141      instructions                     #      1,0 instructions  insn_per_cycle  (66,85%)
>>>>>>     84.012.185.936      stalled-cycles-frontend          #     0,22 frontend_cycles_idle        (66,35%)
>>>>>>
>>>>>>      100,100414494 seconds time elapsed
>>>>>>
>>>>>>
>>>>>> Stock TAP+vhost-net:
>>>>>>             47.087      context-switches                 #    468,1 cs/sec  cs_per_second
>>>>>>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>>>>>>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>>>>>>         100.594,09 msec task-clock                       #      1,0 CPUs  CPUs_utilized
>>>>>>      8.034.703.613      branch-misses                    #     11,1 %  branch_miss_rate         (50,24%)
>>>>>>     72.477.989.922      branches                         #    720,5 M/sec  branch_frequency     (66,86%)
>>>>>>    382.218.276.832      cpu-cycles                       #      3,8 GHz  cycles_frequency       (66,85%)
>>>>>>    349.555.577.281      instructions                     #      0,9 instructions  insn_per_cycle  (66,85%)
>>>>>>     83.917.644.262      stalled-cycles-frontend          #     0,22 frontend_cycles_idle        (66,35%)
>>>>>>
>>>>>>      100,100520402 seconds time elapsed
>>>>>>
>>>>>>
>>>>>> Patched TAP:
>>>>>>             47.862      context-switches                 #    475,8 cs/sec  cs_per_second
>>>>>>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>>>>>>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>>>>>>         100.589,30 msec task-clock                       #      1,0 CPUs  CPUs_utilized
>>>>>>      9.337.258.794      branch-misses                    #      9,4 %  branch_miss_rate         (50,19%)
>>>>>>     99.518.421.676      branches                         #    989,4 M/sec  branch_frequency     (66,85%)
>>>>>>    382.508.244.894      cpu-cycles                       #      3,8 GHz  cycles_frequency       (66,85%)
>>>>>>    312.582.270.975      instructions                     #      0,8 instructions  insn_per_cycle  (66,85%)
>>>>>>     76.338.503.984      stalled-cycles-frontend          #     0,20 frontend_cycles_idle        (66,39%)
>>>>>>
>>>>>>      100,101262454 seconds time elapsed
>>>>>>
>>>>>>
>>>>>> Patched TAP+vhost-net:
>>>>>>             47.892      context-switches                 #    476,1 cs/sec  cs_per_second
>>>>>>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>>>>>>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>>>>>>         100.581,95 msec task-clock                       #      1,0 CPUs  CPUs_utilized
>>>>>>      9.083.588.313      branch-misses                    #     10,1 %  branch_miss_rate         (50,28%)
>>>>>>     90.300.124.712      branches                         #    897,8 M/sec  branch_frequency     (66,85%)
>>>>>>    382.374.510.376      cpu-cycles                       #      3,8 GHz  cycles_frequency       (66,85%)
>>>>>>    340.089.181.199      instructions                     #      0,9 instructions  insn_per_cycle  (66,85%)
>>>>>>     78.151.408.955      stalled-cycles-frontend          #     0,20 frontend_cycles_idle        (66,31%)
>>>>>>
>>>>>>      100,101212911 seconds time elapsed
>>>>>
>>>>> Thanks for sharing. I have more questions:
>>>>>
>>>>> 1) The number of CPU and vCPUs
>>>>
>>>> qemu runs with a single core. And my host system is now a Ryzen 5 5600x
>>>> with 6 cores, 12 threads.
>>>> This is my command for TAP+vhost-net:
>>>>
>>>> sudo qemu-system-x86_64 -hda debian.qcow2
>>>> -netdev tap,id=mynet0,ifname=tap0,script=no,downscript=no,vhost=on
>>>> -device virtio-net-pci,netdev=mynet0 -m 1024 -enable-kvm
>>>>
>>>> For TAP only it is the same but without vhost=on.
>>>>
>>>>> 2) If you pin vhost or vCPU threads
>>>>
>>>> Not in the previous shown benchmark. I pinned vhost in other benchmarks
>>>> but since there is only minor PPS difference I omitted for the sake of
>>>> simplicity.
>>>>
>>>>> 3) what does perf top looks like or perf top -p $pid_of_vhost
>>>>
>>>> The perf reports for the pid_of_vhost from pktgen_sample01_simple.sh
>>>> with TAP+vhost-net (not pinned, pktgen single queue, fq_codel) are shown
>>>> below. I can not see a huge difference between stock and patched.
>>>>
>>>> Also I included perf reports from the pktgen_pids. I find them more
>>>> intersting because tun_net_xmit shows less overhead for the patched.
>>>> I assume that is due to the stopped netdev queue.
>>>>
>>>> I have now benchmarked pretty much all possible combinations (with a
>>>> script) of TAP/TAP+vhost-net, single/multi-queue pktgen, vhost
>>>> pinned/not pinned, with/without -b 0, fq_codel/noqueue... All of that
>>>> with perf records..
>>>> I could share them if you want but I feel this is getting out of hand.
>>>>
>>>>
>>>> Stock:
>>>> sudo perf record -p "$vhost_pid"
>>>> ...
>>>> # Overhead  Command          Shared Object               Symbol
>>>> # ........  ...............  ..........................  ..........................................
>>>> #
>>>>      5.97%  vhost-4874       [kernel.kallsyms]           [k] _copy_to_iter
>>>>      2.68%  vhost-4874       [kernel.kallsyms]           [k] tun_do_read
>>>>      2.23%  vhost-4874       [kernel.kallsyms]           [k] native_write_msr
>>>>      1.93%  vhost-4874       [kernel.kallsyms]           [k] __check_object_size
>>>
>>> Let's disable CONFIG_HARDENED_USERCOPY and retry.
>>>
>>>>      1.61%  vhost-4874       [kernel.kallsyms]           [k] __slab_free.isra.0
>>>>      1.56%  vhost-4874       [kernel.kallsyms]           [k] __get_user_nocheck_2
>>>>      1.54%  vhost-4874       [kernel.kallsyms]           [k] iov_iter_zero
>>>>      1.45%  vhost-4874       [kernel.kallsyms]           [k] kmem_cache_free
>>>>      1.43%  vhost-4874       [kernel.kallsyms]           [k] tun_recvmsg
>>>>      1.24%  vhost-4874       [kernel.kallsyms]           [k] sk_skb_reason_drop
>>>>      1.12%  vhost-4874       [kernel.kallsyms]           [k] srso_alias_safe_ret
>>>>      1.07%  vhost-4874       [kernel.kallsyms]           [k] native_read_msr
>>>>      0.76%  vhost-4874       [kernel.kallsyms]           [k] simple_copy_to_iter
>>>>      0.75%  vhost-4874       [kernel.kallsyms]           [k] srso_alias_return_thunk
>>>>      0.69%  vhost-4874       [vhost]                     [k] 0x0000000000002e70
>>>>      0.59%  vhost-4874       [kernel.kallsyms]           [k] skb_release_data
>>>>      0.59%  vhost-4874       [kernel.kallsyms]           [k] __skb_datagram_iter
>>>>      0.53%  vhost-4874       [vhost]                     [k] 0x0000000000002e5f
>>>>      0.51%  vhost-4874       [kernel.kallsyms]           [k] slab_update_freelist.isra.0
>>>>      0.46%  vhost-4874       [kernel.kallsyms]           [k] kfree_skbmem
>>>>      0.44%  vhost-4874       [kernel.kallsyms]           [k] skb_copy_datagram_iter
>>>>      0.43%  vhost-4874       [kernel.kallsyms]           [k] skb_free_head
>>>>      0.37%  qemu-system-x86  [unknown]                   [k] 0xffffffffba898b1b
>>>>      0.35%  vhost-4874       [vhost]                     [k] 0x0000000000002e6b
>>>>      0.33%  vhost-4874       [vhost_net]                 [k] 0x000000000000357d
>>>>      0.28%  vhost-4874       [kernel.kallsyms]           [k] __check_heap_object
>>>>      0.27%  vhost-4874       [vhost_net]                 [k] 0x00000000000035f3
>>>>      0.26%  vhost-4874       [vhost_net]                 [k] 0x00000000000030f6
>>>>      0.26%  vhost-4874       [kernel.kallsyms]           [k] __virt_addr_valid
>>>>      0.24%  vhost-4874       [kernel.kallsyms]           [k] iov_iter_advance
>>>>      0.22%  vhost-4874       [kernel.kallsyms]           [k] perf_event_update_userpage
>>>>      0.22%  vhost-4874       [kernel.kallsyms]           [k] check_stack_object
>>>>      0.19%  qemu-system-x86  [unknown]                   [k] 0xffffffffba2a68cd
>>>>      0.19%  vhost-4874       [kernel.kallsyms]           [k] dequeue_entities
>>>>      0.19%  vhost-4874       [vhost_net]                 [k] 0x0000000000003237
>>>>      0.18%  vhost-4874       [vhost_net]                 [k] 0x0000000000003550
>>>>      0.18%  vhost-4874       [kernel.kallsyms]           [k] x86_pmu_del
>>>>      0.18%  vhost-4874       [vhost_net]                 [k] 0x00000000000034a0
>>>>      0.17%  vhost-4874       [kernel.kallsyms]           [k] x86_pmu_disable_all
>>>>      0.16%  vhost-4874       [vhost_net]                 [k] 0x0000000000003523
>>>>      0.16%  vhost-4874       [kernel.kallsyms]           [k] amd_pmu_addr_offset
>>>> ...
>>>>
>>>>
>>>> sudo perf record -p "$kpktgend_pids":
>>>> ...
>>>> # Overhead  Command      Shared Object      Symbol
>>>> # ........  ...........  .................  ...............................................
>>>> #
>>>>     10.98%  kpktgend_0   [kernel.kallsyms]  [k] tun_net_xmit
>>>>     10.45%  kpktgend_0   [kernel.kallsyms]  [k] memset
>>>>      8.40%  kpktgend_0   [kernel.kallsyms]  [k] __alloc_skb
>>>>      6.31%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_alloc_node_noprof
>>>>      3.13%  kpktgend_0   [kernel.kallsyms]  [k] srso_alias_safe_ret
>>>>      2.40%  kpktgend_0   [kernel.kallsyms]  [k] sk_skb_reason_drop
>>>>      2.11%  kpktgend_0   [kernel.kallsyms]  [k] srso_alias_return_thunk
>>>
>>> This is a hint that SRSO migitaion is enabled.
>>>
>>> Have you disabled CPU_MITIGATIONS via either Kconfig or kernel command
>>> line (mitigations = off) for both host and guest?
>>>
>>> Thanks
>>>
>>
>> Your both suggested changes really boosted the performance, especially
>> for TAP.
> 
> Good to know that.
> 
>>
>> I disabled SRSO mitigation with spec_rstack_overflow=off and went from
>> "Mitigation: Safe RET" to "Vulnerable" on the host. The VM showed "Not
>> affected" but I applied spec_rstack_overflow=off anyway.
> 
> I think we need to find the root cause of the regression.
> 
>>
>> Here are some new benchmarks for pktgen_sample01_simple.sh:
>> (I also have other available and I can share them if you want.)
>>
> 
> It's a little hard to compare the diff, maybe you can do perf diff.

I ran perf diff for the pktgen perf records of TAP and TAP+vhost-net
(both single queue, not cpu pinned).

With the help of that perf diff (results below) I was able to find out
that functions related to the wake (e.g. __local_bh_enable_ip) cost
quite some performance. Because my patch already wakes on
__ptr_ring_consume_created_space(), I suspected that this leads to very
frequent stop -> wake -> stop -> wake cycles.

Therefore, I also compiled a new variant that wakes on
__ptr_ring_empty() instead. The idea is that netif_tx_wake_queue() is
invoked less frequently.

The pktgen results:

+-------------------------+-----------+-----------+---------------+
| pktgen benchmarks to    | Stock     | Patched   | Wake on       |
| Debian VM, R5 5600X,    |           |           | empty Variant |
| 100M packets            |           |           |               |
| CPU not pinned          |           |           |               |
+-----------+-------------+-----------+-----------+---------------+
| TAP       | Transmitted | 1293 Kpps | 989 Kpps  | 1248 Kpps     |
|           +-------------+-----------+-----------+---------------+
|           | Lost        | 3918 Kpps | 0         | 0             |
+-----------+-------------+-----------+-----------+---------------+
| TAP       | Transmitted | 1411 Kpps | 1410 Kpps | 1379 Kpps     |
|  +        +-------------+-----------+-----------+---------------+
| vhost-net | Lost        | 3659 Kpps | 0         | 0             |
+-----------+-------------+-----------+-----------+---------------+


My conclusions are:

Patched: Waking on __ptr_ring_produce_created_space() is too early. The
         stop/wake cycle occurs too frequently which slows down
         performance as can be seen for TAP.

Wake on empty variant: Waking on __ptr_ring_empty() is (slightly) too
                       late. The consumer starves because the producer
                       first has to produce packets again. This slows
                       down performance aswell as can be seen for TAP
		       and TAP+vhost-net (both down ~30-40Kpps).

I think something inbetween should be used.
The wake should be done as late as possible to have as few
NET_TX_SOFTIRQs as possible but early enough that there are still
consumable packets remaining to not starve the consumer.

However, I can not think of a proper way to implement this right now.

Thanks!


=========================================================================
TAP:

# Event 'cpu/cycles/P'
#
# Data files:
#  [0] stock_pktgen.data (Baseline)
#  [1] patched_pktgen.data 
#  [2] wake_on_empty_variant_pktgen.data 
#
# Baseline/0  Delta Abs/1  Delta Abs/2  Shared Object      Symbol                                                  
# ..........  ...........  ...........  .................  ........................................................
#
      24.49%      +43.46%      +47.09%  [pktgen]           [k] 0x0000000000000e30
      22.27%      -17.03%      -16.76%  [kernel.kallsyms]  [k] memset
      10.59%       -7.72%       -8.06%  [kernel.kallsyms]  [k] __alloc_skb
       7.50%       -5.34%       -6.00%  [kernel.kallsyms]  [k] kmem_cache_alloc_node_noprof
       1.20%       +4.08%       +2.82%  [kernel.kallsyms]  [k] __local_bh_enable_ip
       5.76%       -4.04%       -4.07%  [kernel.kallsyms]  [k] tun_net_xmit
       3.15%       -2.23%       -2.37%  [kernel.kallsyms]  [k] chacha_permute
       0.22%       +1.87%       +1.41%  [kernel.kallsyms]  [k] kthread_should_stop
       2.36%       -1.55%       -1.57%  [kernel.kallsyms]  [k] get_random_u32
       2.19%       -1.51%       -1.74%  [kernel.kallsyms]  [k] skb_put
       0.18%       +1.33%       +1.04%  [kernel.kallsyms]  [k] __cond_resched
       0.68%       +1.32%       +0.87%  [kernel.kallsyms]  [k] __rcu_read_unlock
       0.49%       +1.17%       +0.85%  [kernel.kallsyms]  [k] __rcu_read_lock
       1.40%       -1.15%       -1.24%  [kernel.kallsyms]  [k] sk_skb_reason_drop
       1.34%       -1.12%       -1.16%  [kernel.kallsyms]  [k] ip_send_check
       1.10%       -0.80%       -0.85%  [kernel.kallsyms]  [k] _raw_spin_lock
       1.04%       -0.71%       -0.81%  [kernel.kallsyms]  [k] kmalloc_reserve
       0.86%       -0.51%       -0.66%  [kernel.kallsyms]  [k] __netdev_alloc_skb
       0.62%       -0.41%       -0.46%  [kernel.kallsyms]  [k] __get_random_u32_below
       0.50%       -0.34%       -0.38%  [kernel.kallsyms]  [k] _get_random_bytes
       0.37%       -0.26%       -0.28%  [kernel.kallsyms]  [k] crng_fast_key_erasure
       0.33%       -0.19%       -0.25%  [kernel.kallsyms]  [k] chacha_block_generic
       0.24%       -0.15%       -0.18%  [kernel.kallsyms]  [k] skb_clone_tx_timestamp
       0.31%       -0.13%       -0.23%  [kernel.kallsyms]  [k] skb_push
       0.30%       -0.11%       -0.22%  [kernel.kallsyms]  [k] _raw_spin_unlock
       0.25%       -0.10%       -0.14%  [kernel.kallsyms]  [k] __x86_indirect_thunk_array
       0.56%       +0.08%       +0.15%  [kernel.kallsyms]  [k] sock_def_readable
       0.12%       -0.08%       -0.09%  [kernel.kallsyms]  [k] memcpy
       0.25%       +0.06%       +0.01%  [kernel.kallsyms]  [k] ___slab_alloc
       0.31%       +0.05%       -0.03%  [kernel.kallsyms]  [k] native_write_msr
       0.01%       +0.05%       +0.96%  [kernel.kallsyms]  [k] clear_page_erms
       0.07%       +0.03%       -0.03%  [kernel.kallsyms]  [k] get_partial_node
       0.08%       -0.03%       -0.05%  [kernel.kallsyms]  [k] crng_make_state
       0.02%       +0.02%       -0.01%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
       0.02%       -0.02%       -0.01%  [kernel.kallsyms]  [k] read_tsc
       0.02%       +0.02%       +0.00%  [kernel.kallsyms]  [k] __slab_alloc.isra.0
       0.00%       +0.02%       +0.10%  [kernel.kallsyms]  [k] get_page_from_freelist
       0.08%       +0.01%       -0.06%  [kernel.kallsyms]  [k] put_cpu_partial
       0.00%       +0.01%       +0.25%  [kernel.kallsyms]  [k] allocate_slab
       0.01%       +0.01%       -0.00%  [kernel.kallsyms]  [k] x86_schedule_events
       0.01%       +0.01%       -0.01%  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
       0.00%       +0.01%       +0.00%  [kernel.kallsyms]  [k] perf_assign_events
       0.00%       +0.01%       -0.00%  [amdgpu]           [k] 0x00000000000662f4
       0.02%       +0.01%       +0.00%  [kernel.kallsyms]  [k] amd_pmu_addr_offset


=========================================================================
TAP+vhost-net:

# Event 'cpu/cycles/P'
#
# Data files:
#  [0] stock_pktgen.data (Baseline)
#  [1] patched_pktgen.data 
#  [2] wake_on_empty_variant_pktgen.data 
#
# Baseline/0  Delta Abs/1  Delta Abs/2  Shared Object      Symbol                                        
# ..........  ...........  ...........  .................  ..............................................
#
      24.35%      +47.04%      +45.59%  [pktgen]           [k] 0x0000000000000e30
      22.06%      -16.02%      -16.19%  [kernel.kallsyms]  [k] memset
      10.72%       -7.84%       -7.84%  [kernel.kallsyms]  [k] __alloc_skb
       7.59%       -5.82%       -5.79%  [kernel.kallsyms]  [k] kmem_cache_alloc_node_noprof
       5.69%       -3.98%       -4.08%  [kernel.kallsyms]  [k] tun_net_xmit
       1.22%       +2.74%       +2.65%  [kernel.kallsyms]  [k] __local_bh_enable_ip
       3.18%       -2.33%       -2.30%  [kernel.kallsyms]  [k] chacha_permute
       2.47%       -1.78%       -1.49%  [kernel.kallsyms]  [k] get_random_u32
       2.16%       -1.58%       -1.66%  [kernel.kallsyms]  [k] skb_put
       0.24%       +1.36%       +1.33%  [kernel.kallsyms]  [k] kthread_should_stop
       1.47%       -1.28%       -1.29%  [kernel.kallsyms]  [k] sk_skb_reason_drop
       0.18%       +1.05%       +1.01%  [kernel.kallsyms]  [k] __cond_resched
       0.69%       +0.88%       +0.84%  [kernel.kallsyms]  [k] __rcu_read_unlock
       1.23%       -0.87%       -1.04%  [kernel.kallsyms]  [k] ip_send_check
       0.52%       +0.83%       +0.84%  [kernel.kallsyms]  [k] __rcu_read_lock
       1.09%       -0.80%       -0.78%  [kernel.kallsyms]  [k] _raw_spin_lock
       1.03%       -0.73%       -0.75%  [kernel.kallsyms]  [k] kmalloc_reserve
       0.83%       -0.61%       -0.58%  [kernel.kallsyms]  [k] __netdev_alloc_skb
       0.63%       -0.47%       -0.45%  [kernel.kallsyms]  [k] __get_random_u32_below
       0.47%       -0.34%       -0.33%  [kernel.kallsyms]  [k] _get_random_bytes
       0.36%       -0.26%       -0.25%  [kernel.kallsyms]  [k] crng_fast_key_erasure
       0.34%       -0.25%       -0.24%  [kernel.kallsyms]  [k] chacha_block_generic
       0.32%       -0.22%       -0.23%  [kernel.kallsyms]  [k] skb_push
       0.31%       -0.21%       -0.22%  [kernel.kallsyms]  [k] _raw_spin_unlock
       0.25%       -0.19%       -0.18%  [kernel.kallsyms]  [k] skb_clone_tx_timestamp
       0.28%       -0.15%       -0.16%  [kernel.kallsyms]  [k] __x86_indirect_thunk_array
       0.11%       -0.09%       -0.08%  [kernel.kallsyms]  [k] memcpy
       0.10%       -0.08%       -0.08%  [kernel.kallsyms]  [k] crng_make_state
       0.29%       -0.03%       -0.02%  [kernel.kallsyms]  [k] native_write_msr
       0.13%       -0.03%       -0.01%  [kernel.kallsyms]  [k] native_read_msr
       0.66%       +0.02%       +0.09%  [kernel.kallsyms]  [k] sock_def_readable
       0.27%       +0.01%       +0.03%  [kernel.kallsyms]  [k] ___slab_alloc
       0.03%       -0.01%       -0.01%  [kernel.kallsyms]  [k] __slab_alloc.isra.0
       0.03%       -0.01%       -0.00%  [kernel.kallsyms]  [k] amd_pmu_addr_offset
       0.08%       -0.01%       -0.03%  [kernel.kallsyms]  [k] get_partial_node
       0.09%       -0.01%       +1.02%  [kernel.kallsyms]  [k] clear_page_erms
       0.00%       +0.00%       +0.00%  [kernel.kallsyms]  [k] x86_schedule_events
       0.01%       +0.00%       +0.01%  [kernel.kallsyms]  [k] x86_pmu_add
       0.01%       +0.00%       +0.10%  [kernel.kallsyms]  [k] get_page_from_freelist
       0.01%       -0.00%       +0.00%  [kernel.kallsyms]  [k] x86_pmu_del
       0.01%       -0.00%       -0.00%  [kernel.kallsyms]  [k] x86_pmu_disable_all
       0.00%       +0.00%       -0.00%  [kernel.kallsyms]  [k] perf_assign_events
       0.01%       -0.00%       -0.00%  [kernel.kallsyms]  [k] group_sched_out
       0.01%       -0.00%       -0.00%  [kernel.kallsyms]  [k] read_tsc

> 
> (Btw, it's near to the public holiday of spring festival in China, so
> the reply might a slow).

Good to know, I won't ping you then.

> 
> Thanks
> 

