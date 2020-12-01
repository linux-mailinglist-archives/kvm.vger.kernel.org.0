Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB1B2C9F09
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 11:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391103AbgLAKUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 05:20:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725861AbgLAKUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 05:20:04 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1A2RDZ003901;
        Tue, 1 Dec 2020 05:19:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zcsKcaL/n16flYNT4L3IRwPPYwtWNvqwN2J50JiuBNc=;
 b=i9sUZv5R+jgMPHHR5CL+5t4NHkkgmQmub17U6re/lirzE631By2K5BE5qPyoO3CDmWBz
 chjPvbPIHa+arm65+5EdituqRoJKjZRBlc2XWTavzAbqgt3rkyAlLImu4VjBIT5K4dUD
 4wSzdOmqDCEt1w++HwCL2Mv3F5lBIfnDPbRtlMJ852xot98uSUWFTDZ/291xSKr+Tx5v
 Q/qP/EPpgJMsjScsAHM+vpUaO18yovpYCO8WbJwhN5ps1IAqIlHgv0537or7PPhUZGG2
 H2zmdwR5r5HgPu3OowkOF0U2NrspwLkMM+E+AezCADHK8Tlta/aTxvTBafi2XwtOCNXr kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355a79qbhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 05:19:22 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B1A47JM014642;
        Tue, 1 Dec 2020 05:19:22 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355a79qbgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 05:19:22 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1ABrI3020910;
        Tue, 1 Dec 2020 10:19:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpd9rc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 10:19:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1AJGil60490204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 10:19:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEEF452051;
        Tue,  1 Dec 2020 10:19:16 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.25.88])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id E2BB25204E;
        Tue,  1 Dec 2020 10:19:15 +0000 (GMT)
Date:   Tue, 1 Dec 2020 11:19:14 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 12/17] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20201201111914.25a80561.pasic@linux.ibm.com>
In-Reply-To: <65834705-347c-1e8d-f33f-b64bc2501b37@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-13-akrowiak@linux.ibm.com>
        <20201129025250.16eb8355.pasic@linux.ibm.com>
        <103cbe02-2093-c950-8d65-d3dc385942ce@linux.ibm.com>
        <20201201003227.0c3696fc.pasic@linux.ibm.com>
        <65834705-347c-1e8d-f33f-b64bc2501b37@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Nov 2020 19:18:30 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >>>> +static bool vfio_ap_assign_apid_to_apcb(struct ap_matrix_mdev *matrix_mdev,
> >>>> +					unsigned long apid)
> >>>> +{
> >>>> +	unsigned long apqi, apqn;
> >>>> +	unsigned long *aqm = matrix_mdev->shadow_apcb.aqm;
> >>>> +
> >>>> +	/*
> >>>> +	 * If the APID is already assigned to the guest's shadow APCB, there is
> >>>> +	 * no need to assign it.
> >>>> +	 */
> >>>> +	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
> >>>> +		return false;
> >>>> +
> >>>> +	/*
> >>>> +	 * If no domains have yet been assigned to the shadow APCB and one or
> >>>> +	 * more domains have been assigned to the matrix mdev, then use
> >>>> +	 * the domains assigned to the matrix mdev; otherwise, there is nothing
> >>>> +	 * to assign to the shadow APCB.
> >>>> +	 */
> >>>> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS)) {
> >>>> +		if (bitmap_empty(matrix_mdev->matrix.aqm, AP_DOMAINS))
> >>>> +			return false;
> >>>> +
> >>>> +		aqm = matrix_mdev->matrix.aqm;
> >>>> +	}
> >>>> +
> >>>> +	/* Make sure all APQNs are bound to the vfio_ap driver */
> >>>> +	for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> >>>> +		apqn = AP_MKQID(apid, apqi);
> >>>> +
> >>>> +		if (vfio_ap_mdev_get_queue(matrix_mdev, apqn) == NULL)
> >>>> +			return false;
> >>>> +	}
> >>>> +
> >>>> +	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> >>>> +
> >>>> +	/*
> >>>> +	 * If we verified APQNs using the domains assigned to the matrix mdev,
> >>>> +	 * then copy the APQIs of those domains into the guest's APCB
> >>>> +	 */
> >>>> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
> >>>> +		bitmap_copy(matrix_mdev->shadow_apcb.aqm,
> >>>> +			    matrix_mdev->matrix.aqm, AP_DOMAINS);
> >>>> +
> >>>> +	return true;
> >>>> +}  
> >>> What is the rationale behind the shadow aqm empty special handling?  
> >> The rationale was to avoid taking the VCPUs
> >> out of SIE in order to make an update to the guest's APCB
> >> unnecessarily. For example, suppose the guest is started
> >> without access to any APQNs (i.e., all matrix and shadow_apcb
> >> masks are zeros). Now suppose the administrator proceeds to
> >> start assigning AP resources to the mdev. Let's say he starts
> >> by assigning adapters 1 through 100. The code below will return
> >> true indicating the shadow_apcb was updated. Consequently,
> >> the calling code will commit the changes to the guest's
> >> APCB. The problem there is that in order to update the guest's
> >> VCPUs, they will have to be taken out of SIE, yet the guest will
> >> not get access to the adapter since no domains have yet been
> >> assigned to the APCB. Doing this 100 times - once for each
> >> adapter 1-100 - is probably a bad idea.
> >>  
> > Not yanking the VCPUs out of SIE does make a lot of sense. At least
> > I understand your motivation now. I will think some more about this,
> > but in the meanwhile, please try to answer one more question (see
> > below).
> >     
> >>>    I.e.
> >>> why not simply:
> >>>
> >>>
> >>> static bool vfio_ap_assign_apid_to_apcb(struct ap_matrix_mdev *matrix_mdev,
> >>>                                           unsigned long apid)
> >>> {
> >>>           unsigned long apqi, apqn;
> >>>           unsigned long *aqm = matrix_mdev->shadow_apcb.aqm;
> >>>                                                                                   
> >>>           /*
> >>>            * If the APID is already assigned to the guest's shadow APCB, there is
> >>>            * no need to assign it.
> >>>            */
> >>>           if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
> >>>                   return false;
> >>>                                                                                   
> >>>           /* Make sure all APQNs are bound to the vfio_ap driver */
> >>>           for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> >>>                   apqn = AP_MKQID(apid, apqi);
> >>>                                                                                   
> >>>                   if (vfio_ap_mdev_get_queue(matrix_mdev, apqn) == NULL)
> >>>                           return false;
> >>>           }
> >>>                                                                                   
> >>>           set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> >>>                                                                                   
> >>>           return true;  
> > Would
> > s/return true/return !bitmap_empty(matrix_mdev->shadow_apcb.aqm,
> > AP_DOMAINS)/
> > do the trick?
> >
> > I mean if empty, then we would not commit the APCB, so we would
> > not take the vCPUs out of SIE -- see below.  
> 
> At first glance I'd say yes, it does the trick; but, I need to consider
> all possible scenarios. For example, that will work fine when someone
> either assigns all of the adapters or all of the domains first, then assigns
> the other.

Maybe I can help you. The only caveat I have in mind is the show of the
guest_matrix attribute. We probably don't want to display adapters
without domains and vice-versa. But that can be easily handled with
a flag.

Regards,
Halil
