Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613B446D1CF
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhLHLR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 06:17:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232292AbhLHLRZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 06:17:25 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8AIgmG030674;
        Wed, 8 Dec 2021 11:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=p+hR73c7oilo2pPaxIQvq+l+IO5Si8d4qy66UdU0FA8=;
 b=sAYirZnC1lnyfeHege36mEylyV5DgJ1P4xgApnipjEUPQSIzZhFLO3jmUHmcrjzdymIG
 VEFBBd6DiK3XqTpv3gX6hwnyy2reIuLg6fcp7pxmQqN8HIaQQF9lm47/GTT5B7k0hSnA
 N/URhF44Pgq1FoS3QHVcQgXuBywZk4Yd4cgxnGcHbChktMshWxCJrp/gNgOPW1SF4lyE
 bMnUqXrKcUxkZryuYVIF5DfVKXRPXpPKuXESSkCFC8TeN6OBRwJJhW5LEBbsNiVKB6ZW
 gKc4nTIM5SBx+PV3erHWNqiPFOG4Y2NnX0bzq3czZvWhcU2+raUSwJfpaNy4WhFjiryK uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cttufrwmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:13:53 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8B1AYX012091;
        Wed, 8 Dec 2021 11:13:52 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cttufrwkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:13:52 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8B8SxD011082;
        Wed, 8 Dec 2021 11:13:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3cqyy9ndmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:13:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8BDkAK22151558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 11:13:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B44FE11C05B;
        Wed,  8 Dec 2021 11:13:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90ECD11C05C;
        Wed,  8 Dec 2021 11:13:45 +0000 (GMT)
Received: from [9.171.54.177] (unknown [9.171.54.177])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 11:13:45 +0000 (GMT)
Message-ID: <b3162ece-d654-a540-8071-ebc8499db25c@linux.ibm.com>
Date:   Wed, 8 Dec 2021 12:13:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 02/32] s390/sclp: detect the AISII facility
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
 <20211207205743.150299-3-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-3-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hIBKaCUWixUDDN0QhjBc4Bk8xpWBaI0K
X-Proofpoint-ORIG-GUID: rD7c68sk_RO7GYKdB0rivvFo4zP4VRsK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112080071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> Detect the Adapter Interruption Source ID Interpretation facility.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/include/asm/sclp.h   | 1 +
>   drivers/s390/char/sclp_early.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> index c84e8e0ca344..524a99baf221 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -89,6 +89,7 @@ struct sclp_info {
>   	unsigned char has_sipl : 1;
>   	unsigned char has_dirq : 1;
>   	unsigned char has_zpci_interp : 1;
> +	unsigned char has_aisii : 1;
>   	unsigned int ibc;
>   	unsigned int mtid;
>   	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index 2e8199b7ae50..a73120b8a5de 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -45,6 +45,7 @@ static void __init sclp_early_facilities_detect(void)
>   	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
>   	sclp.has_hvs = !!(sccb->fac119 & 0x80);
>   	sclp.has_kss = !!(sccb->fac98 & 0x01);
> +	sclp.has_aisii = !!(sccb->fac118 & 0x40);
>   	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
>   	if (sccb->fac85 & 0x02)
>   		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
> 
