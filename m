Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A0E46D1F7
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 12:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhLHLVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 06:21:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230197AbhLHLVq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 06:21:46 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B88MUMJ019789;
        Wed, 8 Dec 2021 11:18:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CyyDj1kDDcAZcdyjLOQX3z4/weVTyb0ciM6argTgPfM=;
 b=nBUsz5ZNJnt/Q0lghTdW2+tR5rtHEpOOVnNLC2oh8hI84wglSS2APK+96hhyCAlNoZuH
 HMLtp++y8XhcQI9IA0F0SwedhmuQCZ4wQg6r+otPXgqh1KcpMgoo10KRoXu04KfKCMX/
 P+6KYX96i684hGN/xyEdB+HSqR5NLdW2RLpZHDTPaHFjKGI2tX+Sg+fEMsdv0YKcsyld
 bVrT2Xd514m3Z0pfz09iLpxedtrFn5r73S1LmuliuqMdszi8b3dFQnrZJoY2C8CPTbXF
 5FQdUHd15gwuVNEWAQCn6z+TZ4at5mqk0Eb8PQXg17iUCUZCvWzA39tAA+tEMm4OUOTY tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cts50u4hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:18:14 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8BGUg9011098;
        Wed, 8 Dec 2021 11:18:14 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cts50u4h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:18:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8BDrjQ006322;
        Wed, 8 Dec 2021 11:18:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyya6un1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:18:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8BI8cu10617148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 11:18:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CDAF11C054;
        Wed,  8 Dec 2021 11:18:08 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A03F11C04A;
        Wed,  8 Dec 2021 11:18:07 +0000 (GMT)
Received: from [9.171.54.177] (unknown [9.171.54.177])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 11:18:07 +0000 (GMT)
Message-ID: <5d4d9cfc-31ed-c22c-f52b-ba3be230bf9a@linux.ibm.com>
Date:   Wed, 8 Dec 2021 12:18:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 04/32] s390/sclp: detect the AISI facility
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
 <20211207205743.150299-5-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-5-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RMYXfC96tPDTwfhYfjtzucbdik288Hx1
X-Proofpoint-ORIG-GUID: Mr4TIL2J4lpn5ul4EGSwpwudB5wxNmAq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> Detect the Adapter Interruption Suppression Interpretation facility.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   arch/s390/include/asm/sclp.h   | 1 +
>   drivers/s390/char/sclp_early.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> index a763563bb3e7..559adb28a24c 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -91,6 +91,7 @@ struct sclp_info {
>   	unsigned char has_zpci_interp : 1;
>   	unsigned char has_aisii : 1;
>   	unsigned char has_aeni : 1;
> +	unsigned char has_aisi : 1;
>   	unsigned int ibc;
>   	unsigned int mtid;
>   	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index 52a203ea23cc..9b29ed850d39 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -47,6 +47,7 @@ static void __init sclp_early_facilities_detect(void)
>   	sclp.has_kss = !!(sccb->fac98 & 0x01);
>   	sclp.has_aisii = !!(sccb->fac118 & 0x40);
>   	sclp.has_aeni = !!(sccb->fac118 & 0x20);
> +	sclp.has_aisi = !!(sccb->fac118 & 0x10);
>   	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
>   	if (sccb->fac85 & 0x02)
>   		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
> 
