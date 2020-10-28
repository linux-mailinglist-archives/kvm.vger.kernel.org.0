Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7C529E116
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 02:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgJ2BxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 21:53:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728700AbgJ1V5l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 17:57:41 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09S816OC021686;
        Wed, 28 Oct 2020 04:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=707H0p0zw3rhnMlQmR87vkJRgoeY+wzNdJ8crVjsyh0=;
 b=ttwcydCsssMq0jvRgIi0dAHGMLr5viqKRHnln+LC04FDjSsg1iyJVMunniRSJJKzzFaf
 BjwKXny0SxbDt+nanRywJAdV/ssjjAOi6YHfarmfOui3pNfPKZUAUV90ULRiTOS31jjf
 8iz7qa2eHoMkUNnC61SWfsY+AccGcqVC3pRy6q7k9B1pIvHHQHE1eUxln5LVHWjtn4H0
 CWpO/OWxN1eSLsigUBjh88LPYtDwEJN+32JscGnawI2nz97+9254EVcOz4oKdzaJA/zI
 NsrD1KmhJrUWu3zi0d6M/FpnTOekU+T5gsnWoTgZ3DCxNz0lqK75XNS2KY8dP7iYb3St RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34eqnnwu8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 04:18:36 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09S81Ec3022481;
        Wed, 28 Oct 2020 04:18:36 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34eqnnwu7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 04:18:35 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09S8HxM0007447;
        Wed, 28 Oct 2020 08:18:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 34cbw826m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 08:18:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09S8IVj027853162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 08:18:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E1035204F;
        Wed, 28 Oct 2020 08:18:31 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.18.81])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 658F152051;
        Wed, 28 Oct 2020 08:18:30 +0000 (GMT)
Date:   Wed, 28 Oct 2020 09:17:58 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 07/14] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
Message-ID: <20201028091758.73aa77a3.pasic@linux.ibm.com>
In-Reply-To: <20201022171209.19494-8-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-8-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_01:2020-10-26,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 phishscore=0 impostorscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 13:12:02 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> +static ssize_t guest_matrix_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	ssize_t nchars;
> +	struct mdev_device *mdev = mdev_from_dev(dev);
> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +
> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
> +		return -ENODEV;

I'm wondering, would it make sense to have guest_matrix display the would
be guest matrix when we don't have a KVM? With the filtering in
place, the question in what guest_matrix would my (assign) matrix result
right now if I were to hook up my vfio_ap_mdev to a guest seems a
legitimate one.


> +
> +	mutex_lock(&matrix_dev->lock);
> +	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->shadow_apcb, buf);
> +	mutex_unlock(&matrix_dev->lock);
> +
> +	return nchars;
> +}
> +static DEVICE_ATTR_RO(guest_matrix);
