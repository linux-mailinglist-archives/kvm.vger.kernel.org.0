Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE862F257E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 02:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbhALBVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 20:21:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727919AbhALBVD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 20:21:03 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10C11m6r030847;
        Mon, 11 Jan 2021 20:20:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IY0FNg71Sd157RzPniY1lE+vTVNWXVrYaKLd5+dZUus=;
 b=pl70X5Brw7oPjuMZR83X6VVo58j+9jtpC9Vsz7ePsqwG5kbgQfMRgJl/RYVP5eEuNmmD
 EPdLY2lKNRAdvjOnRFCiwlfgHcNasP4WyfxIu0/eQhQMzjCRlnKkp6PA3WSE6qg7XfUL
 5/Xr2a56riF0g/4+B8zh8Mg0dOjQFrOoHHbaQroExTgEpPrXprJfdrIHnu71eT5ndxRn
 EppxVJiMDAOxF09pq2ZEj9dxFRwNqDvdayLgGtkgJ1mWznYY4jWifUGmZj9paS7xjy2s
 h71rXC7iVy6fLpP7ohNrnKS7T576WrCcwBqbTF75tLUMUoqHRX1WFC8qjV4ZvM+SZkNC sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361114scr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 20:20:20 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10C1BAG5071534;
        Mon, 11 Jan 2021 20:20:20 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361114scqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 20:20:20 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10C1Gv59007873;
        Tue, 12 Jan 2021 01:20:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447txp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 01:20:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10C1KFqo38142306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 01:20:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94A0011C052;
        Tue, 12 Jan 2021 01:20:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB16D11C054;
        Tue, 12 Jan 2021 01:20:14 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.92.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 12 Jan 2021 01:20:14 +0000 (GMT)
Date:   Tue, 12 Jan 2021 02:20:12 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>, mjrosato@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 11/15] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Message-ID: <20210112022012.4bad464f.pasic@linux.ibm.com>
In-Reply-To: <20201223011606.5265-12-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-12-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120000
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 20:16:02 -0500
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
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c     | 21 ++++++++++++++++++---
>  drivers/s390/crypto/vfio_ap_private.h |  2 ++
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
[..]
>  }
> +
> +int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
> +{
> +	int ret;
> +
> +	if (!mutex_trylock(&matrix_dev->lock))
> +		return -EBUSY;
> +	ret = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);

If we detect that resources are in use, then we spit warnings to the
message log, right?

@Matt: Is your userspace tooling going to guarantee that this will never
happen?

> +	mutex_unlock(&matrix_dev->lock);
> +
> +	return ret;
> +}
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index d2d26ba18602..15b7cd74843b 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -107,4 +107,6 @@ struct vfio_ap_queue {
>  int vfio_ap_mdev_probe_queue(struct ap_device *queue);
>  void vfio_ap_mdev_remove_queue(struct ap_device *queue);
>  
> +int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
> +
>  #endif /* _VFIO_AP_PRIVATE_H_ */

