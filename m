Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DEB1BBAC4
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 12:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgD1KIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 06:08:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726932AbgD1KI3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 06:08:29 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SA1fVx113549;
        Tue, 28 Apr 2020 06:08:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30pgnxujvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 06:08:26 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03SA1kTZ114104;
        Tue, 28 Apr 2020 06:08:26 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30pgnxuju1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 06:08:26 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03SA5hsK003543;
        Tue, 28 Apr 2020 10:08:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu6wvxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 10:08:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03SA8Lii65208416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 10:08:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A6D0A4040;
        Tue, 28 Apr 2020 10:08:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA56BA404D;
        Tue, 28 Apr 2020 10:08:20 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.145.25])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Apr 2020 10:08:20 +0000 (GMT)
Date:   Tue, 28 Apr 2020 12:07:26 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 01/15] s390/vfio-ap: store queue struct in hash table
 for quick access
Message-ID: <20200428120726.3f769ce3.pasic@linux.ibm.com>
In-Reply-To: <6ea12752-d23f-abe4-8d5f-3e7738984576@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-2-akrowiak@linux.ibm.com>
        <20200424055732.7663896d.pasic@linux.ibm.com>
        <d15b4a8e-66eb-e4ce-c8ac-6885519940aa@linux.ibm.com>
        <20200427171739.76291a74.pasic@linux.ibm.com>
        <6ea12752-d23f-abe4-8d5f-3e7738984576@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_05:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Apr 2020 17:48:58 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 4/27/20 11:17 AM, Halil Pasic wrote:
> > On Mon, 27 Apr 2020 15:05:23 +0200
> > Harald Freudenberger <freude@linux.ibm.com> wrote:
> >
> >> On 24.04.20 05:57, Halil Pasic wrote:
> >>> On Tue,  7 Apr 2020 15:20:01 -0400
> >>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >>>   
> >>>> Rather than looping over potentially 65535 objects, let's store the
> >>>> structures for caching information about queue devices bound to the
> >>>> vfio_ap device driver in a hash table keyed by APQN.
> >>> @Harald:
> >>> Would it make sense to make the efficient lookup of an apqueue base
> >>> on its APQN core AP functionality instead of each driver figuring it out
> >>> on it's own?
> >>>
> >>> If I'm not wrong the zcrypt device/driver(s) must the problem of
> >>> looking up a queue based on its APQN as well.
> >>>
> >>> For instance struct ep11_cprb has a target_id filed
> >>> (arch/s390/include/uapi/asm/zcrypt.h).
> >>>
> >>> Regards,
> >>> Halil
> >> Hi Halil
> >>
> >> no, the zcrypt drivers don't have this problem. They build up their own device object which
> >> includes a pointer to the base ap device.
> > I'm a bit confused. Doesn't your code loop first trough the ap_card
> > objects to find the APID portion of the APQN, and then loop the queue
> > list of the matching card to find the right ap_queue object? Or did I
> > miss something? Isn't that what _zcrypt_send_ep11_cprb() does? Can you
> > point me to the code that avoids the lookup (by apqn) for zcrypt?
> 
> The code you reference, _zcrypt_send_ep11_cprb(), does loop through
> each queue associated with each card, but it doesn't appear to be 
> looking for
> a queue with a particular APQN. It appears to be looking for a queue
> meeting a specific set of conditions. At least that's my take after 
> taking a very
> brief look at the code, so I'm not sure that applies here.
> 

One of the possible conditions is that the APQN is in the targets array.
Please have another look at the code below, is_desired_ep11_queue()
and is_desired_ep11_card() do APQI and APID part of the check
respectively:

        for_each_zcrypt_card(zc) {
                /* Check for online EP11 cards */
                if (!zc->online || !(zc->card->functions & 0x04000000))
                        continue;
                /* Check for user selected EP11 card */
                if (targets &&
                    !is_desired_ep11_card(zc->card->id, target_num, targets))
                        continue;
                /* check if device node has admission for this card */
                if (!zcrypt_check_card(perms, zc->card->id))
                        continue;
                /* get weight index of the card device  */
                weight = speed_idx_ep11(func_code) * zc->speed_rating[SECKEY];
                if (zcrypt_card_compare(zc, pref_zc, weight, pref_weight))
                        continue;
                for_each_zcrypt_queue(zq, zc) {
                        /* check if device is online and eligible */
                        if (!zq->online ||
                            !zq->ops->send_ep11_cprb ||
                            (targets &&
                             !is_desired_ep11_queue(zq->queue->qid,
                                                    target_num, targets)))


Yes the size of targets may or may not be 1 (example for size == 1 is
the invocation form ep11_cryptsingle()) and the respective costs
depend on the usual size of the array. Since the goal of the whole
exercise seems to be to pick a single queue, and we settle with the first
suitable (first not in the input array, but in our lists) that is
suitable, I assumed we wouldn't need many hashtable lookups.

Regards,
Halil

> >
> >
> > If you look at the new function of vfio_ap_get_queue(unsigned long apqn)
> > it basically about finding the queue based on the apqn, with the
> > difference that it is vfio specific.
> >
> > Regards,
> > Halil
> >
> >> However, this is not a big issue, as the ap_bus holds a list of ap_card objects and within each
> >> ap_card object there exists a list of ap_queues.
> >
> >
> >
> 

