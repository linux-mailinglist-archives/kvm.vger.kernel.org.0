Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B837C46D1F0
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 12:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhLHLVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 06:21:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhLHLVP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 06:21:15 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8AmNhu009097;
        Wed, 8 Dec 2021 11:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PFKQp9yvN6pWFPCbRqbUVlCDnNV4ALkVO13ydkgrKpM=;
 b=soL2gkZTE2Z0DFbNadBYo3L/sO1uRJZaD/nT018dGX/TNLfljy1I19sKQSOjuYQTukLt
 sYPmoHD+6SiMi5BnO7h1Ec438Nll7Esz6sGEE3TWkD+cHFuvBWeeKvqtclwSa4LpOSNb
 nofG3+0E/OQk7B4LZK930Ggji1N185OrjUjiUh8udG8PhqiEWwxwiT+YA26LuAzMkvEY
 e/ZjeYhQleIFtj7/ZtTTF6vqIe2POXe9vcGAtCdK1iAX76ZE7X94C+wH5lsKcT2zDft0
 KqAHkPHcUQn/kYl9cMFoOK9Fy4k397ZTi+BBZWBApyvfKOFY7CqVnz9YZhrIBMkfF/yp oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctu9b8gqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:17:43 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8B8g5l000884;
        Wed, 8 Dec 2021 11:17:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctu9b8gpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:17:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8BDocw007816;
        Wed, 8 Dec 2021 11:17:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3cqyy9netc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:17:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8BHbdd21234004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 11:17:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87E3611C052;
        Wed,  8 Dec 2021 11:17:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 834EC11C050;
        Wed,  8 Dec 2021 11:17:36 +0000 (GMT)
Received: from [9.171.54.177] (unknown [9.171.54.177])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 11:17:36 +0000 (GMT)
Message-ID: <b3f53dfa-d54c-ef75-a584-ea1da0634abc@linux.ibm.com>
Date:   Wed, 8 Dec 2021 12:17:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 03/32] s390/sclp: detect the AENI facility
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
 <20211207205743.150299-4-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-4-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UeheQUPGQtKipDylLCr98ItxOqFFMz5d
X-Proofpoint-ORIG-GUID: uq4CKHpZNtF6Cz-u5J8qXlQaurhABAhl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> Detect the Adapter Event Notification Interpretation facility.
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
> index 524a99baf221..a763563bb3e7 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -90,6 +90,7 @@ struct sclp_info {
>   	unsigned char has_dirq : 1;
>   	unsigned char has_zpci_interp : 1;
>   	unsigned char has_aisii : 1;
> +	unsigned char has_aeni : 1;
>   	unsigned int ibc;
>   	unsigned int mtid;
>   	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index a73120b8a5de..52a203ea23cc 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -46,6 +46,7 @@ static void __init sclp_early_facilities_detect(void)
>   	sclp.has_hvs = !!(sccb->fac119 & 0x80);
>   	sclp.has_kss = !!(sccb->fac98 & 0x01);
>   	sclp.has_aisii = !!(sccb->fac118 & 0x40);
> +	sclp.has_aeni = !!(sccb->fac118 & 0x20);
>   	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
>   	if (sccb->fac85 & 0x02)
>   		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
> 
