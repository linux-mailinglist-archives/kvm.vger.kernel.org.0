Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413142C5185
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 10:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732732AbgKZJms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 04:42:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731882AbgKZJmr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 04:42:47 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ9XD0h060007;
        Thu, 26 Nov 2020 04:42:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yxWmYa9S3svL+b+jzqzJOxS23lLhP49nBkfB7NFJ9dc=;
 b=Upw/tTzcDEeQKDSKykoptaTF4A5lwaH5YmokMC5jrSLAemtMp4OgOYhLfivBWr4HGG4H
 iLqxMu/SwolL5Fg/5ES+yJ0QOriR8TW2kduMiAxc40M/V7+RwIDNtSdjfe2A6DrAnTx7
 W6gKsdaBoh7q26/9y+xI9bFMNtXm69FHLoOvlfOkaxvOqW2J0prWoBv2nVk8A+Hdn5ua
 grTSyt3WhvKe6zP2/BlboKAAt+3ioQhA/ObNjE9vZ/7dwiRp7HYTVdF5piDcTUAsYN6c
 DHzOpabEURqEcn5uYqdC91dPHey82dK0VRilV+kFPzDKb1W0Pqkv87wyn6zIBZlVTf10 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3526k8dd39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 04:42:43 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AQ9XGrW060270;
        Thu, 26 Nov 2020 04:42:43 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3526k8dd2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 04:42:43 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ9SDa3026545;
        Thu, 26 Nov 2020 09:42:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 34xth8dg58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 09:42:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ9gbGe53215732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 09:42:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 414E811C04C;
        Thu, 26 Nov 2020 09:42:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77C0011C052;
        Thu, 26 Nov 2020 09:42:36 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.0.176])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 26 Nov 2020 09:42:36 +0000 (GMT)
Date:   Thu, 26 Nov 2020 10:42:34 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v12 02/17] s390/vfio-ap: decrement reference count to
 KVM
Message-ID: <20201126104234.0bee248d.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-3-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-3-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_03:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1011 bulkscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:01 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Decrement the reference count to KVM when notified that KVM pointer is
> invalidated via the vfio group notifier.

Can you please explain more thoroughly. Is this a bug you found? If
yes do we need to backport it (cc stabe, fixes tag)? 

It doesn't see related to the objective of the series. If not related,
why not spin it separately?


> 
> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>

This s-o-b is probably by accident.

> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 66fd9784a156..31e39c1f6e56 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1095,7 +1095,11 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>  
>  	if (!data) {
> +		if (matrix_mdev->kvm)
> +			kvm_put_kvm(matrix_mdev->kvm);
> +
>  		matrix_mdev->kvm = NULL;
> +
>  		return NOTIFY_OK;
>  	}
>  

