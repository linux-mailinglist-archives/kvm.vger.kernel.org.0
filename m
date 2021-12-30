Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885A24818F7
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 04:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhL3Dde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 22:33:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231751AbhL3Ddd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Dec 2021 22:33:33 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BU1gZjK032632;
        Thu, 30 Dec 2021 03:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OHLEHEuvQsUOBNtNyJQmOyXSioS+90Zvl0tvlsDoTU0=;
 b=RllvalWBpM0OEw9Lw53QcKM68/wy52D2UVTBHwewgtGPARokjxC0Nwha/kru19E40Cb6
 vk00AKqTu6RQxY+bD4iw+SXY+8jmdO4lkqfsXZVasVjPwNLXftLrE3osdrDe12BnSpR1
 pFWmV5+0ncOxZPWFHfJ7O/OlhGRhfTtO9eIiaw2wQtnY/QcsMbP7fn0TVqpf+9XPILjn
 XYlSSQ4/rT+7Ia66TM3DqWmR2DB8ZXwlmY1FotXxBxbZHbJ0KHsWO/NhDITFm422dEnC
 /xHd3mKiSbpq81c2F2YG2Pof4XZiAUZMIYd2PH4HxIaIm52qS4hHiJmnbdAEI1uTrbiN qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d84jm7rnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 03:33:31 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BU3TAZp028118;
        Thu, 30 Dec 2021 03:33:31 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d84jm7rnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 03:33:31 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BU3RmC2005025;
        Thu, 30 Dec 2021 03:33:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3d5tx9f0c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 03:33:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BU3XQuv45941026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Dec 2021 03:33:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF2AC4C05C;
        Thu, 30 Dec 2021 03:33:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AF724C040;
        Thu, 30 Dec 2021 03:33:25 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.80.242])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 30 Dec 2021 03:33:25 +0000 (GMT)
Date:   Thu, 30 Dec 2021 04:33:22 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v17 08/15] s390/vfio-ap: keep track of active guests
Message-ID: <20211230043322.2ba19bbd.pasic@linux.ibm.com>
In-Reply-To: <20211021152332.70455-9-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
        <20211021152332.70455-9-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZqUoopOEfZB5AT4ANfgbYC8bGqj_COhY
X-Proofpoint-ORIG-GUID: 64LDbmE7XijYeAVbRy85Qnc3eVZAZjlw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-30_01,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112300015
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Oct 2021 11:23:25 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The vfio_ap device driver registers for notification when the pointer to
> the KVM object for a guest is set. Let's store the KVM pointer as well as
> the pointer to the mediated device when the KVM pointer is set.

[..]


> struct ap_matrix_dev {
>         ...
>         struct rw_semaphore guests_lock;
>         struct list_head guests;
>        ...
> }
> 
> The 'guests_lock' field is a r/w semaphore to control access to the
> 'guests' field. The 'guests' field is a list of ap_guest
> structures containing the KVM and matrix_mdev pointers for each active
> guest. An ap_guest structure will be stored into the list whenever the
> vfio_ap device driver is notified that the KVM pointer has been set and
> removed when notified that the KVM pointer has been cleared.
> 

Is this about the field or about the list including all the nodes? This
reads lie guests_lock only protects the head element, which makes no
sense to me. Because of how these lists work.

The narrowest scope that could make sense is all the list_head stuff
in the entire list. I.e. one would only need the lock to traverse or
manipulate the list, while the payload would still be subject to
the matrix_dev->lock mutex.

[..]

> +struct ap_guest {
> +	struct kvm *kvm;
> +	struct list_head node;
> +};
> +
>  /**
>   * struct ap_matrix_dev - Contains the data for the matrix device.
>   *
> @@ -39,6 +44,9 @@
>   *		single ap_matrix_mdev device. It's quite coarse but we don't
>   *		expect much contention.
>   * @vfio_ap_drv: the vfio_ap device driver
> + * @guests_lock: r/w semaphore for protecting access to @guests
> + * @guests:	list of guests (struct ap_guest) using AP devices bound to the
> + *		vfio_ap device driver.

Please compare the above. Also if it is only about the access to the
list, then you could drop the lock right after create, and not keep it
till the very end of vfio_ap_mdev_set_kvm(). Right?

In any case I'm skeptical about this whole struct ap_guest business. To
me, it looks like something that just makes things more obscure and
complicated without any real benefit.

Regards,
Halil

>   */
>  struct ap_matrix_dev {
>  	struct device device;
> @@ -47,6 +55,8 @@ struct ap_matrix_dev {
>  	struct list_head mdev_list;
>  	struct mutex lock;
>  	struct ap_driver  *vfio_ap_drv;
> +	struct rw_semaphore guests_lock;
> +	struct list_head guests;
>  };
>  
>  extern struct ap_matrix_dev *matrix_dev;

