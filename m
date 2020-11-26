Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570D02C56AF
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 15:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389970AbgKZOIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 09:08:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388291AbgKZOIi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 09:08:38 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQE32qB072410;
        Thu, 26 Nov 2020 09:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sj6pwlTM26uzANfJRuGsI+hlWiYKct3Y5yGAfXZ2MGg=;
 b=DNC64MryATRapW8LQ/hvVVrdoqPxfUeZuizKs5n0RuVwYyPugRoSQ1Z+02GViZWEXMEP
 aaW/8XWsJIsUXphfX8ZFe+cfoHWffoZCPdDVpY31sD0VxdR6NAsW5JPAs+TyJtwDkoJ2
 wIVVnpRGV7MfBwIRMaa1dn2LGITMa/y4IEN/GgCMHf33NnS4VPMNgECo+VXHlY+/9ya2
 azU0AokZ6oYnQyqiKlHacy/umzZRTe1Ym0moYALSNQVhbhZr2Li6FktpLgoJvc53KIfG
 yzlM7nZVYPQoDOr52r+QV84lhl/ddezxunLgSoeohbGqXgMAemzVXjBfU+Hsdmw10zIO 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352dp68ct9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 09:08:35 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AQE3G8h073452;
        Thu, 26 Nov 2020 09:08:35 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352dp68csm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 09:08:35 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQE2Vvi001097;
        Thu, 26 Nov 2020 14:08:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34xth8dp6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 14:08:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQE8Uvf6619710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 14:08:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E9B0AE057;
        Thu, 26 Nov 2020 14:08:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD762AE045;
        Thu, 26 Nov 2020 14:08:29 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.0.176])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 26 Nov 2020 14:08:29 +0000 (GMT)
Date:   Thu, 26 Nov 2020 15:08:28 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 05/17] s390/vfio-ap: manage link between queue
 struct and matrix mdev
Message-ID: <20201126150828.78776e62.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-6-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-6-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_04:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 clxscore=1015 impostorscore=0 suspectscore=2 phishscore=0
 spamscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:04 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> @@ -1155,6 +1243,11 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  			     matrix_mdev->matrix.apm_max + 1) {
>  		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>  				     matrix_mdev->matrix.aqm_max + 1) {
> +			q = vfio_ap_mdev_get_queue(matrix_mdev,
> +						   AP_MKQID(apid, apqi));
> +			if (!q)
> +				continue;
> +
>  			ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
>  			/*
>  			 * Regardless whether a queue turns out to be busy, or
> @@ -1164,9 +1257,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  			if (ret)
>  				rc = ret;
>  
> -			q = vfio_ap_get_queue(matrix_mdev, AP_MKQID(apid, apqi);
> -			if (q)
> -				vfio_ap_free_aqic_resources(q);
> +			vfio_ap_free_aqic_resources(q);
>  		}
>  	}

During the review of v11 we discussed this. Introducing this the one
way around, just to change it in the next patch, which should deal
with something different makes no sense to me.

BTW I've provided a ton of feedback for '[PATCH v11 03/14]
s390/vfio-ap: manage link between queue struct and matrix mdev', but I
can't find your response to that. Some of the things resurface here, and
I don't feel like repeating myself. Can you provide me an answer to
the v11 version?
