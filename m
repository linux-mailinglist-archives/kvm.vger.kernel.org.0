Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D041B46EB19
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbhLIP3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:29:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236184AbhLIP3D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 10:29:03 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FAoxT022635;
        Thu, 9 Dec 2021 15:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TUQ4MnLXCtO6ENbSrMYjrzLlGKpRBLhMgYqa3YyKwSc=;
 b=BUO9Ppu4XliZg4SKvsNxO7cG976yc8qMmbXDaIseyxe1UWks+MEKtugDQ3GW9s8t7qvn
 Kkrjtcc2Tw9sHTIBciGqnHmkssZ7f3PQJbC9O/D2fRm1Ycvvbm8y8SfS4NSKgtNAIwPD
 vpFLdkK4Rsad85iO7Ph1qfoxmLWq+7393YX0h2tqUnDbvjRBWFX1XF8Hte8C5kaOfomh
 05ka3MbZ0P7zCORoptG/SYBKQwqXl+mprb9hfFvutWISlwa2piyvTzlKhg0q12sITFSm
 iXrR6HClLMKqEcWytIC/bVSMgOntKFAxWAgTgVx5ffs5TrJMevSshi0XZmOHW7BJDp0p ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cujqktwn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:25:29 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9DUNVU026618;
        Thu, 9 Dec 2021 15:25:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cujqktwm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:25:28 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FBvTJ023340;
        Thu, 9 Dec 2021 15:25:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyyajvw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:25:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9FPO9S30998918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 15:25:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E500AA4066;
        Thu,  9 Dec 2021 15:25:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03912A4060;
        Thu,  9 Dec 2021 15:25:23 +0000 (GMT)
Received: from [9.171.49.66] (unknown [9.171.49.66])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 15:25:22 +0000 (GMT)
Message-ID: <ae22743b-f861-e48a-5e0b-db692d557cca@linux.ibm.com>
Date:   Thu, 9 Dec 2021 16:25:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 10/32] s390/pci: stash dtsm and maxstbl
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-11-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-11-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SpPEqdPVMdh4J_qs9LBg9tl6jLcUb9WS
X-Proofpoint-GUID: nwjR9OxqCKdepX4gJBT_ULhJX_D_67N1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_06,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> Store information about what IOAT designation types are supported by
> underlying hardware as well as the largest store block size allowed.
> These values will be needed by passthrough.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/include/asm/pci.h     | 2 ++
>   arch/s390/include/asm/pci_clp.h | 6 ++++--
>   arch/s390/pci/pci_clp.c         | 2 ++
>   3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 2474b8d30f2a..1a8f9f42da3a 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -126,9 +126,11 @@ struct zpci_dev {
>   	u32		gd;		/* GISA designation for passthrough */
>   	u16		vfn;		/* virtual function number */
>   	u16		pchid;		/* physical channel ID */
> +	u16		maxstbl;	/* Maximum store block size */
>   	u8		pfgid;		/* function group ID */
>   	u8		pft;		/* pci function type */
>   	u8		port;
> +	u8		dtsm;		/* Supported DT mask */
>   	u8		rid_available	: 1;
>   	u8		has_hp_slot	: 1;
>   	u8		has_resources	: 1;
> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
> index 3af8d196da74..124fadfb74b9 100644
> --- a/arch/s390/include/asm/pci_clp.h
> +++ b/arch/s390/include/asm/pci_clp.h
> @@ -153,9 +153,11 @@ struct clp_rsp_query_pci_grp {
>   	u8			:  6;
>   	u8 frame		:  1;
>   	u8 refresh		:  1;	/* TLB refresh mode */
> -	u16 reserved2;
> +	u16			:  3;
> +	u16 maxstbl		: 13;	/* Maximum store block size */
>   	u16 mui;
> -	u16			: 16;
> +	u8 dtsm;			/* Supported DT mask */
> +	u8 reserved3;
>   	u16 maxfaal;
>   	u16			:  4;
>   	u16 dnoi		: 12;
> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> index e9ed0e4a5cf0..bc7446566cbc 100644
> --- a/arch/s390/pci/pci_clp.c
> +++ b/arch/s390/pci/pci_clp.c
> @@ -103,6 +103,8 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
>   	zdev->max_msi = response->noi;
>   	zdev->fmb_update = response->mui;
>   	zdev->version = response->version;
> +	zdev->maxstbl = response->maxstbl;
> +	zdev->dtsm = response->dtsm;
>   
>   	switch (response->version) {
>   	case 1:
> 
