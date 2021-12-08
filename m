Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AF846D1C1
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 12:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhLHLQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 06:16:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhLHLQh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 06:16:37 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B89mZrF000839;
        Wed, 8 Dec 2021 11:13:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HeRu8SwC9vox6YeZojQZza3ZgW6HuKUhVsZB4788DAs=;
 b=Wq5s4XGfW/Vgto2tqsYow8vlG5e0FR6Nvn1aQkIeVdu+MMhfDr9Z0qEBPgh4FEZCdwW6
 g84oKhyGrkAM4OGH/5ibh5qFoxMl64CTeVFfdM+NYZzn7O86/m8s0Xn8FJRzUoYijWCI
 z8F9UG8OTomVk7704657hKtLPzrTQnYlZe74fV4zh8rgM8mzQtSJvJhXkmXgn8erqiPu
 BMobx6xSQiJehxaquqRRJTk7VkJtni6xh6XksIZYIVsJW+P+E5xVeZwdm3acMGCoXSSX
 cqQM7qBqg8wUdnwK/jEzY2Yq08sy7WKOM9fA7ki4xJI5IxJHhCR5rRfrhZDGUFDUnvWt Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cttdb9epj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:13:05 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8Awsep004261;
        Wed, 8 Dec 2021 11:13:05 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cttdb9enx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:13:04 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8BATns027353;
        Wed, 8 Dec 2021 11:13:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3cqyy9nctx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 11:13:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8BCxIr28246492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 11:12:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DED6611C05B;
        Wed,  8 Dec 2021 11:12:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E781811C054;
        Wed,  8 Dec 2021 11:12:57 +0000 (GMT)
Received: from [9.171.54.177] (unknown [9.171.54.177])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 11:12:57 +0000 (GMT)
Message-ID: <3ed8f5ca-e508-e261-e71d-875f5762f2f9@linux.ibm.com>
Date:   Wed, 8 Dec 2021 12:12:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 01/32] s390/sclp: detect the zPCI interpretation facility
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
 <20211207205743.150299-2-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eliOqbfoqCwPRpMYTHXAT_-MbxcB2fVI
X-Proofpoint-ORIG-GUID: B0-q5xW2-umgVEaSKEmcco75vJDer0fD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112080071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> Detect the zPCI Load/Store Interpretation facility.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/sclp.h   | 1 +
>   drivers/s390/char/sclp_early.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> index c68ea35de498..c84e8e0ca344 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -88,6 +88,7 @@ struct sclp_info {
>   	unsigned char has_diag318 : 1;
>   	unsigned char has_sipl : 1;
>   	unsigned char has_dirq : 1;
> +	unsigned char has_zpci_interp : 1;

maybe use zpci_lsi (load store interpretion) as pci interpretion would be something else (also fix the the subject line).
With that

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>


>   	unsigned int ibc;
>   	unsigned int mtid;
>   	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index b64feab62caa..2e8199b7ae50 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -45,6 +45,7 @@ static void __init sclp_early_facilities_detect(void)
>   	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
>   	sclp.has_hvs = !!(sccb->fac119 & 0x80);
>   	sclp.has_kss = !!(sccb->fac98 & 0x01);
> +	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
>   	if (sccb->fac85 & 0x02)
>   		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
>   	if (sccb->fac91 & 0x40)
> 
