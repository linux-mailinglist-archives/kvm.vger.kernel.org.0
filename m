Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6006C2C771A
	for <lists+kvm@lfdr.de>; Sun, 29 Nov 2020 02:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgK2BKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 20:10:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbgK2BKQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 28 Nov 2020 20:10:16 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AT13SKX140324;
        Sat, 28 Nov 2020 20:09:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UDOXAYojWMGEmAUf2mXBo4TfALKrwni4+uI6zmb0F40=;
 b=qtFr31GEnos0/XgBZaxCKVZhbc9gzeXtDIRlTkuas8tJhM3yZTUOH2YBi2xkTU6azbfO
 KQRXc5X972S9EbrtNrO6mmaUNOKs1OYeo9XRVLDQ0Y1vuHcYhmLiRRZRzK90vuv/7eu6
 w518u+/pDSOw9d7IeDtLb0YeMZFZIgN62KTScGthvENK28om7QZjU0YQbDiTFoF3I+9r
 fOoV1OfK5ITY0AD1eiU6OXvE50q6wdTsZX/Fz849opOBqNQemWUKjzcCYcMJZiBKt6BU
 v5AuUMlf7/LQgle/s4q2eiH4y3Y6mlQWKnfEa6fnq/1YXw53xrTSBFBVVWaRTj3FlefW xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 353yq21rqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 20:09:31 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AT13lek140999;
        Sat, 28 Nov 2020 20:09:31 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 353yq21rpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 20:09:31 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AT11YIS029303;
        Sun, 29 Nov 2020 01:09:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 353e680rre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Nov 2020 01:09:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AT19Qbv11338324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Nov 2020 01:09:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A362A4054;
        Sun, 29 Nov 2020 01:09:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5803FA405C;
        Sun, 29 Nov 2020 01:09:25 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.47.217])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 29 Nov 2020 01:09:25 +0000 (GMT)
Date:   Sun, 29 Nov 2020 02:09:23 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 10/17] s390/vfio-ap: initialize the guest apcb
Message-ID: <20201129020923.6c470310.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-11-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-11-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-28_18:2020-11-26,2020-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011290003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:09 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The APCB is a control block containing the masks that specify the adapters,
> domains and control domains to which a KVM guest is granted access. When
> the vfio_ap device driver is notified that the KVM pointer has been set,
> the guest's APCB is initialized from the AP configuration of adapters,
> domains and control domains assigned to the matrix mdev. The linux device
> model, however, precludes passing through to a guest any devices that
> are not bound to the device driver facilitating the pass-through.
> Consequently, APQNs assigned to the matrix mdev that do not reference
> AP queue devices must be filtered before assigning them to the KVM guest's
> APCB; however, the AP architecture precludes filtering individual APQNs, so
> the APQNs will be filtered by APID. That is, if a given APQN does not
> reference a queue device bound to the vfio_ap driver, its APID will not
> get assigned to the guest's APCB. For example:
> 
> Queues bound to vfio_ap:
> 04.0004
> 04.0022
> 04.0035
> 05.0004
> 05.0022
> 
> Adapters/domains assigned to the matrix mdev:
> 04 0004
>    0022
>    0035
> 05 0004
>    0022
>    0035
> 
> APQNs assigned to APCB:
> 04.0004
> 04.0022
> 04.0035
> 
> The APID 05 was filtered from the matrix mdev's matrix because
> queue device 05.0035 is not bound to the vfio_ap device driver.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

This adds filtering. So from here guest_matrix may be different
than matrix also for an mdev that is associated with a guest. I'm still
grappling with the big picture. Have you thought about testability?
How is a testcase supposed to figure out which behavior is
to be deemed correct?

I don't like the title line. It implies that guest apcb was
uninitialized before. Which is not the case.




