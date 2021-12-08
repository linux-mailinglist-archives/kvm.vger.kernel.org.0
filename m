Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D1B46D559
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 15:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhLHOQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:16:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232641AbhLHOQO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 09:16:14 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CemjT023610;
        Wed, 8 Dec 2021 14:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=HlGJLnOczjtt2ujifmTiLDXcYUWE56/nOPhLdkaDazM=;
 b=H5aMf/8Zk0pqESBsfgwlcIk5WPERD9FN6EnaUj8jumdENIpuvsnR/D85mjyCWAy3Db+7
 /f9nR+PPSdkF2e2ko6lA/WenpcyYQnTU3FxgaGFM/KanIH+YoUEz52VUF5C0bRVQ1XO0
 giucElHMUR20QXslICmVJejAG94EFX7cgKCl5VW0LxPoGJ2iHFXVTqMBz+o2c+kFKAMK
 3xqiOAtbfsnMWUQycnz/O2Pg/qi45ShdZYmqGYoVfKKBf9ghTq94ya40+zdDrunm5q2/
 vWhZ6GtJdetxH99zd3ug+bxwr3tv7w13c5iPTfmb+I0xQMSmzC1laV3+fHq3Ddwwx5yT CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctuq2bf6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:41 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8EBus6004805;
        Wed, 8 Dec 2021 14:12:41 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctuq2bf5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:41 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8E8EkN006729;
        Wed, 8 Dec 2021 14:12:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3cqyy9q0aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8ECacM24314124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 14:12:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53EC652059;
        Wed,  8 Dec 2021 14:12:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 39C8E52050;
        Wed,  8 Dec 2021 14:12:35 +0000 (GMT)
Date:   Wed, 8 Dec 2021 14:06:51 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/32] s390/sclp: detect the zPCI interpretation
 facility
Message-ID: <20211208140651.5c7cdb1e@p-imbrenda>
In-Reply-To: <20211207205743.150299-2-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
        <20211207205743.150299-2-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Sshp_8gbK3MJOvB1gj7no5-JfaT9D0KA
X-Proofpoint-GUID: D0i4WkiXvlJ6S5avSW5ErP9fAjuK9vV-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_05,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 15:57:12 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Detect the zPCI Load/Store Interpretation facility.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

I have the same comment as Christian; with that fixed:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/sclp.h   | 1 +
>  drivers/s390/char/sclp_early.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> index c68ea35de498..c84e8e0ca344 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -88,6 +88,7 @@ struct sclp_info {
>  	unsigned char has_diag318 : 1;
>  	unsigned char has_sipl : 1;
>  	unsigned char has_dirq : 1;
> +	unsigned char has_zpci_interp : 1;
>  	unsigned int ibc;
>  	unsigned int mtid;
>  	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index b64feab62caa..2e8199b7ae50 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -45,6 +45,7 @@ static void __init sclp_early_facilities_detect(void)
>  	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
>  	sclp.has_hvs = !!(sccb->fac119 & 0x80);
>  	sclp.has_kss = !!(sccb->fac98 & 0x01);
> +	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
>  	if (sccb->fac85 & 0x02)
>  		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
>  	if (sccb->fac91 & 0x40)

