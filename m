Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED36C2C58DA
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 16:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403911AbgKZPzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 10:55:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391421AbgKZPyo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 10:54:44 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQFWNou064250;
        Thu, 26 Nov 2020 10:54:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=e4Qwx/ayVeb9ZbZv5VaULTaIFsFfcFgooqcpj2nGS1M=;
 b=B8X9NYEXw4KwdwIbIKyPFG0iZ7gyxLd1SDmh2BEhkOeR9cbJEpukBODHT/WC9tsAd4ZM
 sYK8jv3jkp0KulL99YyAZ3E3OvKqmaJqOxL23A8A1Esd2NZ5+aNMoLaG8g1eXkRwNGAE
 hyGcdtKCC6RGS2kXL4ytDKaLLfbqpvXboCXa0NvMMeGiDq8CALlmOB8OZXZAL3qotCgM
 LpZoD5CAOufGxu3099TVgduaDi4C85wX1IhDS+xJ74i897T0O9z7nwm9dV0ck/IzHJLH
 WPRO5SgzmPCpfRpmc12q6b2dUK9wHb6iCg1kxHdt1+VTjHpU+enK97siZMB2CXdN+GfV aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352cqumtq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 10:54:40 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AQFWPcW064498;
        Thu, 26 Nov 2020 10:54:39 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352cqumtpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 10:54:39 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQFlaOq020032;
        Thu, 26 Nov 2020 15:54:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 352ata04gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 15:54:37 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQFsYG863111536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 15:54:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5414011C04C;
        Thu, 26 Nov 2020 15:54:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89D7111C050;
        Thu, 26 Nov 2020 15:54:33 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.0.176])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 26 Nov 2020 15:54:33 +0000 (GMT)
Date:   Thu, 26 Nov 2020 16:54:31 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 07/17] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Message-ID: <20201126165431.6ef1457a.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-8-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-8-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_05:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:06 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's implement the callback to indicate when an APQN
> is in use by the vfio_ap device driver. The callback is
> invoked whenever a change to the apmask or aqmask would
> result in one or more queue devices being removed from the driver. The
> vfio_ap device driver will indicate a resource is in use
> if the APQN of any of the queue devices to be removed are assigned to
> any of the matrix mdevs under the driver's control.
> 
> There is potential for a deadlock condition between the matrix_dev->lock
> used to lock the matrix device during assignment of adapters and domains
> and the ap_perms_mutex locked by the AP bus when changes are made to the
> sysfs apmask/aqmask attributes.
> 
> Consider following scenario (courtesy of Halil Pasic):
> 1) apmask_store() takes ap_perms_mutex
> 2) assign_adapter_store() takes matrix_dev->lock
> 3) apmask_store() calls vfio_ap_mdev_resource_in_use() which tries
>    to take matrix_dev->lock
> 4) assign_adapter_store() calls ap_apqn_in_matrix_owned_by_def_drv
>    which tries to take ap_perms_mutex
> 
> BANG!
> 
> To resolve this issue, instead of using the mutex_lock(&matrix_dev->lock)
> function to lock the matrix device during assignment of an adapter or
> domain to a matrix_mdev as well as during the in_use callback, the
> mutex_trylock(&matrix_dev->lock) function will be used. If the lock is not
> obtained, then the assignment and in_use functions will terminate with
> -EBUSY.

Good news is: the final product is OK with regards to in_use(). Bad news
is: this patch does not do enough. At this stage we are still racy.

The problem is that the assign operations don't bother to take the
ap_perms_mutex lock under the matrix_dev->lock.

The scenario is the following:
1) apmask_store() takes ap_perms_mutex
2) apmask_store() calls vfio_ap_mdev_resource_in_use() which
     takes matrix_dev->lock
3) vfio_ap_mdev_resource_in_use() releases matrix_dev->lock
   and returns 0
4) assign_adapter_store() takes matrix_dev->lock does the
   assign (the queues are still bound to vfio_ap) and releases
   matrix_dev->lock 
5) apmask_store() carries on, does the update to apask and releases
   ap_perms_mutex
6) The queues get 'stolen' from vfio ap while used.

This gets fixed with "s390/vfio-ap: allow assignment of unavailable AP
queues to mdev device". Maybe we can reorder these patches. I didn't
look into that.

We could also just ignore the problem, because it is just for a couple
of commits, but I would prefer it gone.

Regards,
Halil
   


