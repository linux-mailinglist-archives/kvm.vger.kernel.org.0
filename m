Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B28272334
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 13:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIUL5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 07:57:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726326AbgIUL5y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 07:57:54 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LBVcDV112559;
        Mon, 21 Sep 2020 07:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=cv9aYg5ay77N/571CLKcX48/pmMEZzaqBIwgKv0yXdQ=;
 b=qJk8j16Esfd3v4YioGAqeIwU8F9xPZyGp0O0RtEm0TTpBTP5mjtg+CcHNwrPwkSifuop
 uvlZtsrTvk5HZHK/WHkTrmt4IS8S/HbrLhTUF2OzK4eO/pbM6zhmRX4kw3XfKaY7AWgV
 sst9OzVUglkrpZZBlibQ7xjJ6mlaL76LP5S0yZ4KjmwcBLo6k9ZPhnev4vpmt2IdnamI
 vOMbClXg7pOf9yz/kYZyQT89q8nGiIDkSc7qlEPGUxhYCJyTnOzCcIxhXpRKDeDllA2I
 SND6/701VTNjAu/rCSJP43iIGXyp9hmqQEFiMPlMd+o2rRgnUPWCSNCLyw/g5bXd5iRk Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33pt9b2p1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 07:57:52 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08LBVlpw113422;
        Mon, 21 Sep 2020 07:57:51 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33pt9b2p1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 07:57:51 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08LBvM3p025114;
        Mon, 21 Sep 2020 11:57:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 33n98gs1pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 11:57:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08LBuCBO33358210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 11:56:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0F04A404D;
        Mon, 21 Sep 2020 11:57:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72DA6A4051;
        Mon, 21 Sep 2020 11:57:46 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.8.1])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Sep 2020 11:57:46 +0000 (GMT)
Date:   Mon, 21 Sep 2020 13:56:55 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pmorel@linux.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, kwankhede@nvidia.com
Subject: Re: [PATCH] s390/vfio-ap: fix unregister GISC when KVM is already
 gone results in OOPS
Message-ID: <20200921135655.152c77c6.pasic@linux.ibm.com>
In-Reply-To: <a108cd19-8c4b-908f-844d-5717ca405559@de.ibm.com>
References: <20200918170234.5807-1-akrowiak@linux.ibm.com>
        <a108cd19-8c4b-908f-844d-5717ca405559@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_03:2020-09-21,2020-09-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=2 phishscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1011 mlxscore=0 spamscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Sep 2020 07:48:58 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> 
> 
> On 18.09.20 19:02, Tony Krowiak wrote:
> > Attempting to unregister Guest Interruption Subclass (GISC) when the
> > link between the matrix mdev and KVM has been removed results in the
> > following:
> > 
> >    "Kernel panic -not syncing: Fatal exception: panic_on_oops"
> 
> I think the full backtrace would be better in case someone runs into this
> and needs to compare this patch to its oops. This also makes it easier to
> understand the fix. 
> > 
> > This patch fixes this bug by verifying the matrix mdev and KVM are still
> > linked prior to unregistering the GISC.
> > 
> > Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> 
> Do we need a Fixes tag and cc stable?
> 

I believe we do!

> 
> > ---
> >  drivers/s390/crypto/vfio_ap_ops.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> > index e0bde8518745..847a88642644 100644
> > --- a/drivers/s390/crypto/vfio_ap_ops.c
> > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > @@ -119,11 +119,15 @@ static void vfio_ap_wait_for_irqclear(int apqn)
> >   */
> >  static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
> >  {
> > -	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
> 
> So we already check for q->matrix_mdev here
> 
> > -		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
> > -	if (q->saved_pfn && q->matrix_mdev)
> 
> and here
> > -		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> > -				 &q->saved_pfn, 1);
> > +	if (q->matrix_mdev) {
> > +		if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev->kvm)
>                                                            ^^^^ and this is the only
> 		new check? Cant we just add this condition to the first if?

You are technically right, but I'm not comfortable with my level of
understanding of this logic regardless of the coding style. Will ask
some questions directly.

Regards,
Halil

> 
> > +			kvm_s390_gisc_unregister(q->matrix_mdev->kvm,
> > +						 q->saved_isc);
> > +		if (q->saved_pfn)
> > +			vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> > +					 &q->saved_pfn, 1);
> > +	}
> > +
> >  	q->saved_pfn = 0;
> >  	q->saved_isc = VFIO_AP_ISC_INVALID;
> >  }
> > 

