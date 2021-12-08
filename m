Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4329146D55C
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 15:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhLHOQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:16:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234755AbhLHOQR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 09:16:17 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8Cel91030866;
        Wed, 8 Dec 2021 14:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0vq1iAcPK5d/YGXy74g83QSXwNrKMBR27U5DO//P4WQ=;
 b=Aj0gFgtXm6dbsQ/VbENLZcDl/UjuJVbx5AybM+Q58U2x36YV5aBp9JW+EoOQFnUH2OjB
 wbFUpACU6haNgxgdH53nrkvgjUQoUb7ga6H5MzLSi0Fl8LBFd+8azqVIfEYAtnPidg9L
 DNtuTVzE5mVj2K9RehHZKs/LcKw+cYtueCmdNKA1/Zx2VZNpbkhqYCpl5g2YxOQF0l5E
 zuWtgEQ8RH5kedhS5ZeZem9CIyIwHZxCiHoJh3YjyDd5I6aE6omLuqWfleEkI6nrT9cK
 NhLEVrQp81W6lbO257Fq/L1Uf9vUlJeyQiU4OI4eY44052AMv5r2xB0TjMku46s8GkGO tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctv4sk1av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:44 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8DFY92031099;
        Wed, 8 Dec 2021 14:12:44 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctv4sk1a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:44 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8E6sEe020238;
        Wed, 8 Dec 2021 14:12:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykjgjvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8ECdHj31850894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 14:12:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2353A5204E;
        Wed,  8 Dec 2021 14:12:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1513052052;
        Wed,  8 Dec 2021 14:12:38 +0000 (GMT)
Date:   Wed, 8 Dec 2021 14:08:13 +0100
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
Subject: Re: [PATCH 03/32] s390/sclp: detect the AENI facility
Message-ID: <20211208140813.35d3eb22@p-imbrenda>
In-Reply-To: <20211207205743.150299-4-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
        <20211207205743.150299-4-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7ywqNPbZn7pEn8CJa2C4nLtkuH7UgVFB
X-Proofpoint-GUID: RtYC7gb9N5dqyx4JuD5myUl2oIAErLI0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_05,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 15:57:14 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Detect the Adapter Event Notification Interpretation facility.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/sclp.h   | 1 +
>  drivers/s390/char/sclp_early.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> index 524a99baf221..a763563bb3e7 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -90,6 +90,7 @@ struct sclp_info {
>  	unsigned char has_dirq : 1;
>  	unsigned char has_zpci_interp : 1;
>  	unsigned char has_aisii : 1;
> +	unsigned char has_aeni : 1;
>  	unsigned int ibc;
>  	unsigned int mtid;
>  	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index a73120b8a5de..52a203ea23cc 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -46,6 +46,7 @@ static void __init sclp_early_facilities_detect(void)
>  	sclp.has_hvs = !!(sccb->fac119 & 0x80);
>  	sclp.has_kss = !!(sccb->fac98 & 0x01);
>  	sclp.has_aisii = !!(sccb->fac118 & 0x40);
> +	sclp.has_aeni = !!(sccb->fac118 & 0x20);
>  	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
>  	if (sccb->fac85 & 0x02)
>  		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;

