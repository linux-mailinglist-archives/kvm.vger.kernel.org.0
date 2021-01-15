Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF52F6FDB
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 02:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbhAOBJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 20:09:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726125AbhAOBJH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 20:09:07 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10F13AVv167512;
        Thu, 14 Jan 2021 20:08:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=XOeSzX9xb6InbeP9NV1F2CyB2AXbY0GV7E32ThriA+I=;
 b=jBVtj1eod2YOMAruM741kW141nR2JmzIeE5Wb8L6pHWagOOov/+4Zo6wnHBhv27Ccl6n
 wUppyGZWEBFK+cKqKKR8nzHz1Bcuu48Hk9VOiqbZHeubwzMDy1KgYvx1UnzgSQvrHGJ2
 x6McXDUvF9Pribn9FJ2D3DVpkV/cfXCKLOdWC697yY5PVuD3GVr+ESTmYS0JGxQqP4mS
 6NEepd7pYUhwPuzCACCo4jgvgWcFs+VuZcmHvZHDVn3kZX5qu/nKGQ5tluOYANMXlJkP
 U+ADFXceykHDhufxe6CO6mOuRhnuy4yr1WL+9Si4J1VMQI8NadxP9kc3ILpfZ5eyxrIM yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3630rv8ey9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:08:26 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10F15WgP177099;
        Thu, 14 Jan 2021 20:08:25 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3630rv8exf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:08:25 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10F16C7N023565;
        Fri, 15 Jan 2021 01:08:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdendd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 01:08:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10F18K2816515396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 01:08:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 675E64C046;
        Fri, 15 Jan 2021 01:08:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4BD24C040;
        Fri, 15 Jan 2021 01:08:19 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.66.6])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 15 Jan 2021 01:08:19 +0000 (GMT)
Date:   Fri, 15 Jan 2021 02:08:16 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 06/15] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20210115020816.3e0226bd.pasic@linux.ibm.com>
In-Reply-To: <270e192b-b88d-b072-428c-6cbfc0f9a280@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-7-akrowiak@linux.ibm.com>
        <20210111214037.477f0f03.pasic@linux.ibm.com>
        <270e192b-b88d-b072-428c-6cbfc0f9a280@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_10:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=990 adultscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 12:54:39 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 1/11/21 3:40 PM, Halil Pasic wrote:
> > On Tue, 22 Dec 2020 20:15:57 -0500
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
> > You didn't tell us about the changed error code.  
> 
> I am assuming you are talking about returning -EBUSY from
> the vfio_ap_mdev_verify_no_sharing() function instead of
> -EADDRINUSE. I'm going to change this back per your comments
> below.
> 
> >
> > Also notice that this point we don't have neither filtering nor in-use.
> > This used to be patch 11, and most of that stuff used to be in place. But
> > I'm going to trust you, if you say its fine to enable it this early.  
> 
> The patch order was changed due to your review comments in
> in Message ID <20201126165431.6ef1457a.pasic@linux.ibm.com>,
> patch 07/17 in the v12 series. In order to ensure that only queues
> bound to the vfio_ap driver are given to the guest, I'm going to
> create a patch that will preceded this one which introduces the
> filtering code currently introduced in the patch 12/17, the hot
> plug patch.
> 

I don't want to delay this any further, so it's up to you. I don't think
we will get the in-between steps perfect anyway.

I've re-readthe Message ID
 <20201126165431.6ef1457a.pasic@linux.ibm.com> and I didn't
ask for this change. I pointed out a problem, and said, maybe it can be
solved by reordering, I didn't think it through.

[..]
