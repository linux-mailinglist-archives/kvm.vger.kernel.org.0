Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C272D910D
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 23:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406833AbgLMW6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 17:58:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727958AbgLMW6G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 13 Dec 2020 17:58:06 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BDM3Nth086550;
        Sun, 13 Dec 2020 17:57:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2uH5+TD/pR8NMWhCWiPhuQP0TR87QJLQ64qYeO6sh3o=;
 b=gRf6rnW7xone2SYpMI8KYdCReiD66bFPZLK5XKDvfYzMD0qi7yevlTOYH3W3ToIcQGtR
 s1po9Tazh4ISjKLCDAoruonlIpUnvx56xnZ0UQwUncBLTcaY9nXUw9AoIVjtIHuglT+g
 2kii9D+AbBpwcnIHdqtlFLiWScz+u/T+CeD9vs6YZBMfJc0vJaKOxWzspTaWN5/uTx0/
 hYEYTZ3ao06yQ9JKEG0NKvghvlgrCNKhb6SQobQwhW2ZVStj5FTLrBWB0Nwa3Iwnuq3b
 8eWtVde7L3oi7H/XwXfkHE2GO2rcjiJfcN9uwY7UhZlBeOynavvqoFVh+fd0K/GdfpDn 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35dt1et52j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 17:57:22 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BDMnUPs013678;
        Sun, 13 Dec 2020 17:57:22 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35dt1et51w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 17:57:22 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BDMuY0C016072;
        Sun, 13 Dec 2020 22:57:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 35cng81hu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 22:57:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BDMvHMZ50069860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 22:57:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA9B04C075;
        Sun, 13 Dec 2020 22:57:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6119F4C072;
        Sun, 13 Dec 2020 22:57:16 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.55.88])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 13 Dec 2020 22:57:16 +0000 (GMT)
Date:   Sun, 13 Dec 2020 23:57:14 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201213235714.3e21cdab.pasic@linux.ibm.com>
In-Reply-To: <e196b743-74d8-398b-4b3e-4a64002d9bfc@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
        <20201203185514.54060568.pasic@linux.ibm.com>
        <a8a90aed-97df-6f10-85c2-8e18dba8f085@linux.ibm.com>
        <20201204200502.1c34ae58.pasic@linux.ibm.com>
        <683dd341-f047-0447-1ee8-c126c305b6c2@linux.ibm.com>
        <20201208010125.209883f5.pasic@linux.ibm.com>
        <e196b743-74d8-398b-4b3e-4a64002d9bfc@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-13_06:2020-12-11,2020-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130173
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 15:52:55 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 12/7/20 7:01 PM, Halil Pasic wrote:
> > On Mon, 7 Dec 2020 13:50:36 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >
> >> On 12/4/20 2:05 PM, Halil Pasic wrote:
> >>> On Fri, 4 Dec 2020 09:43:59 -0500
> >>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >>>   
> >>>>>> +{
> >>>>>> +	if (matrix_mdev->kvm) {
> >>>>>> +		(matrix_mdev->kvm);
> >>>>>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> >>>>> Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
> >>>>> to take more care?
> >>>>>
> >>>>> For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
> >>>>> kvm->arch.crypto.crycb.
> >>>> I do not think so. The CRYCB is used by KVM to provide crypto resources
> >>>> to the guest so it makes sense to protect it from changes to it while
> >>>> passing
> >>>> the AP devices through to the guest. The hook is used only when an AQIC
> >>>> executed on the guest is intercepted by KVM. If the notifier
> >>>> is being invoked to notify vfio_ap that KVM has been set to NULL, this means
> >>>> the guest is gone in which case there will be no AP instructions to
> >>>> intercept.
> >>> If the update to pqap_hook isn't observed as atomic we still have a
> >>> problem. With torn writes or reads we would try to use a corrupt function
> >>> pointer. While the compiler probably ain't likely to generate silly code
> >>> for the above assignment (multiple write instructions less then
> >>> quadword wide), I know of nothing that would prohibit the compiler to do
> >>> so.
> >> I'm sorry, but I still don't understand why you tkvm_vfio_group_set_kvmhink this is a problem
> >> given what I stated above.
> > I assume you are specifically referring to 'the guest is gone in which
> > case there will be no AP instructions to intercept'.  I assume by 'guest
> > is gone' you mean that the VM is being destroyed, and the vcpus are out
> > of SIE. You are probably right for the invocation of
> > kvm_vfio_group_set_kvm() in kvm_vfio_destroy(), but is that true for
> > the invocation in the KVM_DEV_VFIO_GROUP_DEL case in
> > kvm_vfio_set_group()? I.e. can't we get the notifier called when the
> > qemu device is hot unplugged (modulo remove which unregisters the
> > notifier and usually precludes the notifier being with NULL called at
> > all)?
> 
> I am assuming by your question that the qemu device you are
> talking about the '-device vfio-ap' specified on the qemu command
> line or attached vi||||||a qemu device_add. 

Yes.

> When an mdev is hot 
> unplugged, the
> vfio_ap driver's release callback gets invoked when the mdev fd is 
> closed. The
> release callback unregisters the notifier, so it does not get called
> when the guest subsequently shuts down.
> 

That is what I meant by 'modulo remove which unregisters the notifier
and usually precludes the notifier being with NULL called at all', but
unfortunately I mixed up remove and release.

AFAIU release should be called before the notifier gets invoked
regardless of whether we have a hot-unplug of '-device vfio-ap' or
a shutdown. The whole effort is about what happens if userspace does
not adhered to this. If I apply the logic of your last response to the
whole situation, then there is nothing to do (AFAIU).

The point I'm trying to make is, that in a case of the hot-unplug, the
guest may survive the call to the notifier and also the vfio_mdev device
it was associated to at some point. So your argument that 'the guest is
gone in which case there will be no AP instructions to interpret' does
not hold.

Regards,
Halil

