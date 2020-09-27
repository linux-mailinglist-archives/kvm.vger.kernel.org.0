Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39EF279CFD
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 02:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgI0AD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Sep 2020 20:03:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61704 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgI0AD0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 26 Sep 2020 20:03:26 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08R01TYX151753;
        Sat, 26 Sep 2020 20:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=M0PhSozL3gyEL26b9uq7FZv8dv+vWETw1ww0FRa/cog=;
 b=NhOvzXSf6K/jXbVM32R2omjGqeIR3LBxemVIdpX9X+783LPkT4XaP+lvOXi6zaZAGgh4
 +90erdi4Js3cPrdO23KyvlfJ7eZnmQEsxOVFeVRpLApD0w5/8AvxoRGIIWk2Cnd/rSek
 hmxhl3Bac+yHfyhw1CJEJoTeTr+BNkSsoei/ZJKdoWUFUgLoajsr9KPJIH7FB7kBoZZ5
 ra0LSNpzAbrqamaJrNNBXrrQnAK8ibZYU6wUGsLJFa8Jr+ZvMhRFiCOOVVFHNk1L5IbO
 Ll4NcDqPxPGokz/Dheu6VjC2H8lCKmGk2qE4VK47qY2ME8E+G+wWRf+2E2UH4CHZe6+/ wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33teh2s6d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 20:03:24 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08R03NO8156695;
        Sat, 26 Sep 2020 20:03:24 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33teh2s6cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 20:03:23 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08R03MU8009665;
        Sun, 27 Sep 2020 00:03:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 33sw988cdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Sep 2020 00:03:22 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08R03Jfa26411400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 00:03:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F152242042;
        Sun, 27 Sep 2020 00:03:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BCA342049;
        Sun, 27 Sep 2020 00:03:18 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.162.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 27 Sep 2020 00:03:18 +0000 (GMT)
Date:   Sun, 27 Sep 2020 02:03:16 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 10/16] s390/vfio-ap: allow configuration of matrix
 mdev in use by a KVM guest
Message-ID: <20200927020316.38bf3fa1.pasic@linux.ibm.com>
In-Reply-To: <20200821195616.13554-11-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-11-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_21:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260214
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:10 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The current support for pass-through crypto adapters does not allow
> configuration of a matrix mdev when it is in use by a KVM guest. Let's
> allow AP resources - i.e., adapters, domains and control domains - to be
> assigned to or unassigned from a matrix mdev while it is in use by a guest.
> This is in preparation for the introduction of support for dynamic
> configuration of the AP matrix for a running KVM guest.

AFAIU this will let the user do the assign, which will however only take
effect if the same mdev is re-used with a freshly constructed VM, or?

This is however supposed to change real soon (in patch 11). From the
perspective of bisectability we would end up with a single commit that
acts funny.

How about switching up patches 10 and 11. This way the changes you have
in the current 11 would remain dormant until the changes in the current
10 enable the complete new feature (hotplug)?


> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 24 ------------------------
>  1 file changed, 24 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 24fd47e43b80..cf3321eb239b 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -773,10 +773,6 @@ static ssize_t assign_adapter_store(struct device *dev,
>  	struct mdev_device *mdev = mdev_from_dev(dev);
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	/* If the guest is running, disallow assignment of adapter */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &apid);
>  	if (ret)
>  		return ret;
> @@ -828,10 +824,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  	struct mdev_device *mdev = mdev_from_dev(dev);
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	/* If the guest is running, disallow un-assignment of adapter */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &apid);
>  	if (ret)
>  		return ret;
> @@ -891,10 +883,6 @@ static ssize_t assign_domain_store(struct device *dev,
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
>  
> -	/* If the guest is running, disallow assignment of domain */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &apqi);
>  	if (ret)
>  		return ret;
> @@ -946,10 +934,6 @@ static ssize_t unassign_domain_store(struct device *dev,
>  	struct mdev_device *mdev = mdev_from_dev(dev);
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	/* If the guest is running, disallow un-assignment of domain */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &apqi);
>  	if (ret)
>  		return ret;
> @@ -991,10 +975,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
>  	struct mdev_device *mdev = mdev_from_dev(dev);
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	/* If the guest is running, disallow assignment of control domain */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &id);
>  	if (ret)
>  		return ret;
> @@ -1036,10 +1016,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
>  
> -	/* If the guest is running, disallow un-assignment of control domain */
> -	if (matrix_mdev->kvm)
> -		return -EBUSY;
> -
>  	ret = kstrtoul(buf, 0, &domid);
>  	if (ret)
>  		return ret;

