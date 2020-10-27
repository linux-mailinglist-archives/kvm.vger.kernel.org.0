Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5E29ACA5
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 14:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751616AbgJ0NCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 09:02:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43151 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440804AbgJ0NCJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Oct 2020 09:02:09 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09RCWY9m031569;
        Tue, 27 Oct 2020 09:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=I7hN7Mkba9hz/hGA8vrbyFka7uQHZS+0zCPEM2EfoLI=;
 b=s7Ab4SnCzJFYn2h1vSKU+gcynCWGc8s8QiG5/CN9rjR/YZQGXbfOlOSC5tAwVoeHZfdA
 DCZS1VsrbF5/y1dI18Lnr114jnAhBz1sZAZ5esBY/isax3Hk1/XBasz9gCYickbN1Ytw
 57Sn5EXg+wBKOC1rCvETRQmtrlMoUoxq5Xh2mN7oJbAiif7IvGEJ2qG+TA6qy169e6QN
 KQH9gCeWZb23zVFyNwSRX1LXBIu7wkAkiPM4PJwPgb6OWMVWjjtA4e7hR93q/eC/Unzi
 iL2ltDqrC3CT5/z9moDPh9Hn68Ja33a2NQIeoXxBvUmHlREIC50Bj5BW8cw6vt0lNiIx +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ejb6bejv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 09:02:06 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09RCWcHo031954;
        Tue, 27 Oct 2020 09:02:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ejb6bega-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 09:02:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09RCmIg5030384;
        Tue, 27 Oct 2020 13:02:03 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 34e56qrruy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 13:02:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09RD20la33817030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 13:02:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9205052051;
        Tue, 27 Oct 2020 13:02:00 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.77.212])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D039652054;
        Tue, 27 Oct 2020 13:01:59 +0000 (GMT)
Date:   Tue, 27 Oct 2020 14:01:57 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 04/14] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20201027140157.0b510450.pasic@linux.ibm.com>
In-Reply-To: <20201022171209.19494-5-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-5-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_05:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 13:11:59 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Introduces a new driver callback to prevent a root user from unbinding
> an AP queue from its device driver if the queue is in use. The callback
> will be invoked whenever a change to the AP bus's sysfs apmask or aqmask
> attributes would result in one or more AP queues being removed from its
> driver. If the callback responds in the affirmative for any driver
> queried, the change to the apmask or aqmask will be rejected with a device
> in use error.

Like discussed last time, there seems to be nothing, that would prevent
a resource becoming in use between the in_use() callback returned false
and the resource being removed as a result of ap_bus_revise_bindings().

Another thing that may be of interest, is that now we hold the
ap_perms_mutex for the in_use() checks. The ap_perms_mutex is used
in ap_device_probe() and I don't quite understand some
usages of in zcrypt_api.c My feeling is that the extra pressure on that
lock should not be a problem, except if in_use() were to not return
because of some deadlock.

With all that said if Harald is fine with it, so am I.

Acked-by: Halil Pasic <pasic@linux.ibm.com>

> 
> For this patch, only non-default drivers will be queried. Currently,
> there is only one non-default driver, the vfio_ap device driver. The
> vfio_ap device driver facilitates pass-through of an AP queue to a
> guest. The idea here is that a guest may be administered by a different
> sysadmin than the host and we don't want AP resources to unexpectedly
> disappear from a guest's AP configuration (i.e., adapters and domains
> assigned to the matrix mdev). This will enforce the proper procedure for
> removing AP resources intended for guest usage which is to
> first unassign them from the matrix mdev, then unbind them from the
> vfio_ap device driver.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>
