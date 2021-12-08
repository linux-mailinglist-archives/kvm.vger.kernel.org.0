Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94CE46D557
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 15:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhLHOQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:16:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55446 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232869AbhLHOQL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 09:16:11 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8DrlF7009456;
        Wed, 8 Dec 2021 14:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=u4AtiUpTCFXEmSH9NPmA1RQvLVYq1txs+eT3etv8XaQ=;
 b=FTW4RDxoigc9h/YCQPJE7NqazgkQPMRksBmYygLwAJeauJRqK2Bsr3dbLv0OlWPV+R4g
 plyDOnBQe64/auwLRngxbQgdMyTWw5274/lslyn2frxjdb/ZF5Djk1yqqNqzO/5xeabu
 vn+SndmOEcFCZaj/m7EXn6Gud1IgC7Z+DfeZcSTx4DkklpQfjo1xJ9rX0seTYi5mtn4D
 6SKYlTZ2ukx/n6fqAwqAzPCfq6irtREntLWT4+UHZC21nLUUVSDJUm+l9JmVhRGbuG2F
 lwuUMZJ3czlEt6ewPnzw3w8d7jki+4UAJ1U50AL1EK7iOS6F1c0hOSbavuaMNxE0CG72 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctwyyrd23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:39 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8DuEqg019206;
        Wed, 8 Dec 2021 14:12:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctwyyrd13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8E6sEZ020238;
        Wed, 8 Dec 2021 14:12:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykjgjum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8ECXxR26870192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 14:12:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 797BB52050;
        Wed,  8 Dec 2021 14:12:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 70CE05204E;
        Wed,  8 Dec 2021 14:12:32 +0000 (GMT)
Date:   Wed, 8 Dec 2021 14:09:34 +0100
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
Subject: Re: [PATCH 04/32] s390/sclp: detect the AISI facility
Message-ID: <20211208140934.7daf172a@p-imbrenda>
In-Reply-To: <20211207205743.150299-5-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
        <20211207205743.150299-5-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1XHPZcx3Aw4VGDsTTNX7VHOsgnPEIKRZ
X-Proofpoint-GUID: Fe2MsldIMgGL6HPyNZXme-MDVjBt1_sf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_05,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 15:57:15 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Detect the Adapter Interruption Suppression Interpretation facility.
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
> index a763563bb3e7..559adb28a24c 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -91,6 +91,7 @@ struct sclp_info {
>  	unsigned char has_zpci_interp : 1;
>  	unsigned char has_aisii : 1;
>  	unsigned char has_aeni : 1;
> +	unsigned char has_aisi : 1;
>  	unsigned int ibc;
>  	unsigned int mtid;
>  	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index 52a203ea23cc..9b29ed850d39 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -47,6 +47,7 @@ static void __init sclp_early_facilities_detect(void)
>  	sclp.has_kss = !!(sccb->fac98 & 0x01);
>  	sclp.has_aisii = !!(sccb->fac118 & 0x40);
>  	sclp.has_aeni = !!(sccb->fac118 & 0x20);
> +	sclp.has_aisi = !!(sccb->fac118 & 0x10);
>  	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
>  	if (sccb->fac85 & 0x02)
>  		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;

