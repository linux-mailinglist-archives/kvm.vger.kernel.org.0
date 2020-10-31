Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18982A1365
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 05:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgJaEI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 00:08:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJaEI7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 00:08:59 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09V42Jkr014246;
        Sat, 31 Oct 2020 00:08:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BZIc8kJ0AecLKZdXA3Z8SLdD4CpID6za1Fp/oxLvaOg=;
 b=MgzMrochXg4uhOPvghZzbGEsHOPvKGw4EDAJcK/ThV2UsGKI3O9UFXUgubCTmO/Q/NeW
 HPBLSUDjTP7/wDA/ZAnLVkQ6qkD91R2B3ZVzj7GK98k6+EijQa7SEkEFuezQEURJj7a1
 4v2FUcmfY9M9QwQJhx9ur5htsxM7fNEyGc0/M3Gk51QYZ03qOnzmYmqXfxyGSjUBnGYv
 vhhlmiB8Cbp2kGubTq7tC3MjuB3L/83j4GcTcua2jum790MJpTetd0a6dusi2UIvlvhl
 K3jrDk8ejQJyA3JIO12zROlm536v3tYkI/UGlyvT0MIuKk8qcJ/Ttv4pWy3EPnAzu9SK RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34h0am8d4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Oct 2020 00:08:54 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09V42Lfx014993;
        Sat, 31 Oct 2020 00:08:54 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34h0am8d2g-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Oct 2020 00:08:54 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09V3hLSL029632;
        Sat, 31 Oct 2020 03:43:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 34gy6h01de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Oct 2020 03:43:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09V3hW5T36831528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Oct 2020 03:43:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D09B11C058;
        Sat, 31 Oct 2020 03:43:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6C7711C052;
        Sat, 31 Oct 2020 03:43:31 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.172.93])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 31 Oct 2020 03:43:31 +0000 (GMT)
Date:   Sat, 31 Oct 2020 04:43:29 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
Message-ID: <20201031044329.77b5a249.pasic@linux.ibm.com>
In-Reply-To: <cb40a506-4a17-3562-728c-cbb57cd99817@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-2-akrowiak@linux.ibm.com>
        <20201027074846.30ee0ddc.pasic@linux.ibm.com>
        <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
        <20201030184242.3bceee09.pasic@linux.ibm.com>
        <cb40a506-4a17-3562-728c-cbb57cd99817@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-31_01:2020-10-30,2020-10-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=952
 spamscore=0 priorityscore=1501 mlxscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010310028
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Oct 2020 16:37:04 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 10/30/20 1:42 PM, Halil Pasic wrote:
> > On Thu, 29 Oct 2020 19:29:35 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >>>> @@ -1177,7 +1166,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
> >>>>    			 */
> >>>>    			if (ret)
> >>>>    				rc = ret;
> >>>> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
> >>>> +			q = vfio_ap_get_queue(matrix_mdev,
> >>>> +					      AP_MKQID(apid, apqi));
> >>>> +			if (q)
> >>>> +				vfio_ap_free_aqic_resources(q);  
> >>> Is it safe to do vfio_ap_free_aqic_resources() at this point? I don't
> >>> think so. I mean does the current code (and vfio_ap_mdev_reset_queue()
> >>> in particular guarantee that the reset is actually done when we arrive
> >>> here)? BTW, I think we have a similar problem with the current code as
> >>> well.  
> >> If the return code from the vfio_ap_mdev_reset_queue() function
> >> is zero, then yes, we are guaranteed the reset was done and the
> >> queue is empty.  
> > I've read up on this and I disagree. We should discuss this offline.  
> 
> Maybe you are confusing things here; my statement is specific to the return
> code from the vfio_ap_mdev_reset_queue() function, not the response code
> from the PQAP(ZAPQ) instruction. The vfio_ap_mdev_reset_queue()
> function issues the PQAP(ZAPQ) instruction and if the status response code
> is 0 indicating the reset was successfully initiated, it waits for the
> queue to empty. When the queue is empty, it returns 0 to indicate
> the queue is reset. 
> If the queue does not become empty after a period of 
> time,
> it will issue a warning (WARN_ON_ONCE) and return 0. In that case, I suppose
> there is no guarantee the reset was done, so maybe a change needs to be
> made there such as a non-zero return code.
>

I've overlooked the wait for empty. Maybe that return 0 had a part in
it. I now remember me insisting on having the wait code added when the
interrupt support was in the make. Sorry!

If we have given up on out of retries retries, we are in trouble anyway.
 
> >  
> >>    The function returns a non-zero return code if
> >> the reset fails or the queue the reset did not complete within a given
> >> amount of time, so maybe we shouldn't free AQIC resources when
> >> we get a non-zero return code from the reset function?
> >>  
> > If the queue is gone, or broken, it won't produce interrupts or poke the
> > notifier bit, and we should clean up the AQIC resources.  
> 
> True, which is what the code provided by this patch does; however,
> the AQIC resources should be cleaned up only if the KVM pointer is
> not NULL for reasons discussed elsewhere.

Yes, but these should be cleaned up before the KVM pointer becomes
null. We don't want to keep the page with the notifier byte pinned
forever, or?
