Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0B02A6F81
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbgKDVUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:20:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726152AbgKDVUg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:20:36 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4KvraL124384;
        Wed, 4 Nov 2020 16:20:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/+LmYavEgp6KEniV2HQDA4tu8OkX2lGzVGPj3WaP1pw=;
 b=FPxpeAl7WUm7TpfB4sYcj9bTSpoz0leHcRXYpp9Hma8aDQamMW2j8K/LpVcnoQNUtZ69
 xbvihD+IO9qH5aSpHELaGsCB1yY3xFX56bBQfPShZATYuxb8QfzpseyOaAyZgyZSyHCW
 wEK9mJipsz0kUB+U7a3pQYj0yJhx4H3D6uvFcztO6g1rKZ9Tbz78q29cmSIkd/o11D7o
 XBv5fPEnfOKfv+pljum/dc0bc2Fugu6G2x5VTpHiyM3EXU+KQaDo3BL/6Ca/PAQMHYbp
 kCfUOpGXzUGhOgv5Oo9pKDYZ/sq6drs+TalNfO4IPEHPE7ttyK0fLlXtYx4gXvo64zNa 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34kv448c33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 16:20:33 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A4L2n6u138506;
        Wed, 4 Nov 2020 16:20:32 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34kv448c2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 16:20:32 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A4L7Mav029720;
        Wed, 4 Nov 2020 21:20:32 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 34h0fk1fvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 21:20:32 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A4LKNXN2949758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Nov 2020 21:20:23 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AB977805F;
        Wed,  4 Nov 2020 21:20:29 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE7217805C;
        Wed,  4 Nov 2020 21:20:27 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  4 Nov 2020 21:20:27 +0000 (GMT)
Subject: Re: [PATCH v11 08/14] s390/vfio-ap: hot plug/unplug queues on
 bind/unbind of queue device
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-9-akrowiak@linux.ibm.com>
 <20201028145725.1a81c5cf.pasic@linux.ibm.com>
 <055284df-87d8-507a-d7d7-05a73459322d@linux.ibm.com>
 <20201104135218.666bf0f5.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <eb27fc27-e236-7b16-9d8c-814bba816934@linux.ibm.com>
Date:   Wed, 4 Nov 2020 16:20:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201104135218.666bf0f5.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_14:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 suspectscore=3 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/4/20 7:52 AM, Halil Pasic wrote:
> On Tue, 3 Nov 2020 17:49:21 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>>>    
>>>> +void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
>>>> +{
>>>> +	unsigned long apid = AP_QID_CARD(q->apqn);
>>>> +
>>>> +	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
>>>> +		return;
>>>> +
>>>> +	/*
>>>> +	 * If the APID is assigned to the guest, then let's
>>>> +	 * go ahead and unplug the adapter since the
>>>> +	 * architecture does not provide a means to unplug
>>>> +	 * an individual queue.
>>>> +	 */
>>>> +	if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm)) {
>>>> +		clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
>>> Shouldn't we check aqm as well? I mean it may be clear at this point
>>> bacause of info->aqm. If the bit is clear, we don't have to remove
>>> the apm bit.
>> The rule we agreed upon is that if a queue is removed, we unplug
>> the card because we can't unplug an individual queue, so this code
>> is consistent with the stated rule.
> All I'm asking for is to verify that the queue is actually plugged. The
> queue is actually plugged iff
> test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm) && test_bit_inv(apqi,
> q->matrix_mdev->shadow_apcb.aqm).
>
> There is no point in unplugging the whole card, if the queue removed is
> unplugged in the first place.

No problem, I can make that change.

>
>> Typically, a queue is unplugged
>> because the adapter has been deconfigured or is broken which means
>> that all queues for that adapter will be removed in succession. On the
>> other hand, that situation would be handled when the last queue is
>> removed if we check the AQM, so I'm not adverse to making that
>> check if you insist.
> I don't agree. Let's detail your scenario. We have a nicely
> operating card which is as a whole passed trough to our guest. It
> goes broken, and the ap bus decides to deconstruct the queues.
> Already the first queue removed would unplug the the card, because
> both the apm and the aqm bits are set at this point. Subsequent removals
> then see that the apm bit is removed. Actually IMHO everything works
> like without the extra check on aqm (in this scenario).
>
> Would make reasoning about the code much easier to me, so sorry I do
> insist.

As you said, it works as-is in the scenario you pointed out:)
Whether it makes it any easier to understand the code is in
the eyes of the beholder (for example, I disagree),
but I'm willing to make the change, it's not a big deal.

>
>> Of course, if the queue is manually unbound from
>> the vfio driver, what you are asking for makes sense I suppose. I'll have
>> to think about this one some more, but feel free to respond to this.
> I'm not sure the situation where the queues ->mdev_matrix pointer is set
> but the apqi is not in the shadow_apcb can actually happen (races not
> considered).

Of course it can, for example:

1. No queues bound to vfio driver

2. APQN 04.0004 assigned to matrix mdev

3. Guest started:
     a. No bits set in shadow_apcb because no queues are bound to vfio

4. queue device 04.0004 is bound to the driver
     a. q->matrix_mdev is set because 04.0004 is assigned to matrix mdev
     b. apqi 0004 is not in shadow_apcb (see 3a.)


> But I'm sure the code is suggesting it can, because
> vfio_ap_mdev_filter_guest_matrix() has a third parameter called filter_apid,
> which governs whether the apm or the aqm bit should be removed. And
> vfio_ap_mdev_filter_guest_matrix() does get called with filter_apid=false in
> assign_domain_store() and I don't see subsequent unlink operations that would
> severe q->mdev_matrix.

I think you may be conflating two different things. The q in q->matrix_mdev
represents a queue device bound to the driver. The link to matrix_mdev
indicates the APQN of the queue device is assigned to the matrix_mdev.
When a new domain is assigned to matrix_mdev, we know that
all APQNS currently assigned to the shadow_apcb  are bound to the vfio 
driver
because of previous filtering, so we are only concerned with those APQNs
with the APQI of the new domain being assigned.

1. Queues bound to vfio_ap:
     04.0004
     04.0047
2. APQNs assigned to matrix_mdev:
     04.0004
     04.0047
3. shadow_apcb:
     04.0004
     04.0047
4. Assign domain 0054 to matrix_mdev
5. APQI 0054 gets filtered because 04.0054 not bound to vfio_ap
6. no change to shadow_apcb:
     04.0004
     04.0047

Or:

1. Queues bound to vfio_ap:
     04.0004
     04.0047
     04.0054
2. APQNs assigned to matrix_mdev:
     04.0004
     04.0047
3. shadow_apcb:
     04.0004
     04.0047
4. Assign domain 0054 to matrix_mdev
5. APQNs assigned to matrix_mdev
     04.0004
     04.0047
     04.0054
5. APQI 0054 does not get filtered because 04.0054 is bound to vfio_ap
6. shadow_apcb after filtering:
     04.0004
     04.0047
     04.0054

I'm not sure why you are bringing up unlinking in the context of assigning
a new domain. Unlinking only occurs when an APID or APQI is unassigned.

>
> Another case where the aqm may get filtered in
> vfio_ap_mdev_filter_guest_matrix() is the info->aqm bit not set, as I've
> mentioned in my previous mail. If that can not happen, we should turn
> that into an assert.

In an earlier email of yours, you brought up the scenario whereby
a queue is probed not because of a change in the QCI info,
but because an unbound queue is bound; for instance manually.
I made a change to account for that so consider the following
scenario:

1. APQI 0004 removed from info->aqm
2. AP bus notifies vfio_ap that AP configuration has changed
3. vfio_ap removes APQI 0004 from shadow_apcb
4. Userspace binds queue 04.0004 to vfio_ap
5. Filtering code filters 0004 because it has been removed
     from info->aqm
6. AP bus notifies vfio_ap scan is over

>
> Actually if you are convinced that apqi bit is always set in the
> q->matrix_mdev->shadow_apcb.aqm, I would agree to turning that into an
> assertion instead of condition. Then if not completely convinced, I
> could at least try to trigger the assert :).
>
> Regards,
> Halil

