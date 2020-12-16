Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0162DC8C5
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 23:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgLPWKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 17:10:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730182AbgLPWKF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 17:10:05 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGM2FKA059508;
        Wed, 16 Dec 2020 17:09:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nXRqNJk9VOFOyqSyFPQz+bIalFtwhVOu2Cj8xAFeNEk=;
 b=BHC/ed03bX+2e7jJdMiMZG99uvl5UnDSi3LttHOrVAjnUBYcSc3gA9U6b+2DmMNW+25I
 R4WxA7Gk/LdKWHYlF3UfsMCZoHatZ3MEgPbh9fm+aDFElRjJI02nIysREsc4B+dX0nlb
 WJh3BMrn/JNJxaZK8blQgqn+NMvlcByKCfUCsIisTIwH5hhRAhynqMLyW7e+tb4IPeV+
 SyFnhkuo39fH/2CIURL66KTNImmB1xuodprhzzj7TwqAHyqinrc+aWtc0NKDi9Gy/5YS
 Y1Uvpl47TFiQDOWci4XpD0/DK7L+Owk68rQknbbtPzti+NxxkSXQPscmkQJqObjGdM1q eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ftm5gbq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 17:09:22 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGM2FJY059548;
        Wed, 16 Dec 2020 17:09:22 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ftm5gbph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 17:09:22 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGM78CA008669;
        Wed, 16 Dec 2020 22:09:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 35cng84qdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 22:09:20 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGM9Hf930343674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 22:09:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83B7C4203F;
        Wed, 16 Dec 2020 22:09:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 047D24204B;
        Wed, 16 Dec 2020 22:09:16 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.26.143])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 16 Dec 2020 22:09:15 +0000 (GMT)
Date:   Wed, 16 Dec 2020 23:09:14 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 11/17] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20201216230914.63c0223c.pasic@linux.ibm.com>
In-Reply-To: <b94f220b-37c4-abce-432d-5304d22f65b9@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-12-akrowiak@linux.ibm.com>
        <20201129021717.5683e779.pasic@linux.ibm.com>
        <b94f220b-37c4-abce-432d-5304d22f65b9@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_09:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Dec 2020 15:14:47 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 11/28/20 8:17 PM, Halil Pasic wrote:
> > On Tue, 24 Nov 2020 16:40:10 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >
> >> The current implementation does not allow assignment of an AP adapter or
> >> domain to an mdev device if each APQN resulting from the assignment
> >> does not reference an AP queue device that is bound to the vfio_ap device
> >> driver. This patch allows assignment of AP resources to the matrix mdev as
> >> long as the APQNs resulting from the assignment:
> >>     1. Are not reserved by the AP BUS for use by the zcrypt device drivers.
> >>     2. Are not assigned to another matrix mdev.
> >>
> >> The rationale behind this is twofold:
> >>     1. The AP architecture does not preclude assignment of APQNs to an AP
> >>        configuration that are not available to the system.
> >>     2. APQNs that do not reference a queue device bound to the vfio_ap
> >>        device driver will not be assigned to the guest's CRYCB, so the
> >>        guest will not get access to queues not bound to the vfio_ap driver.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > Again code looks good. I'm still worried about all the incremental
> > changes (good for review) and their testability.
> 
> I'm not sure what your concern is here. Is there an expectation
> that each patch needs to be testable by itself, or whether the
> functionality in each patch can be easily tested en masse?

I was referring to the testability of each patch in the following
sense: can you (at least theoretically) write a testsuite, that has
perfect coverage, and no false positives for each prefix of the
series applied. 

BTW I don't consider this a showstopper. 

> 
> I'm not sure some of these changes can be tested with an
> automated test because the test code would have to be able to
> dynamically change the host's AP configuration and I don't know
> if there is currently a way to do this programmatically. In order to
> test the effects of dynamic host crypto configuration manually, one
> needs access to an SE or HMC with DPM.
> 

Nested should also give you this: you can change G2 which is a host
to G3.

Regards,
Halil
