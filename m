Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C6146D553
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 15:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhLHOQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:16:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232757AbhLHOQJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 09:16:09 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8DNkUF021230;
        Wed, 8 Dec 2021 14:12:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ABScJ0ZEOC56bM6LTEeZ6FC0Kk5FHDgN19/xzmB3nUI=;
 b=f6bRfswgCLDYD2t1f8Szure5vALeuP91osFeMEDUwY7VFmX6rCgss1aLJCk2yPoCsi1k
 ja7G0MrBz5i6362WmpYsD3aH/lArVdVibu3aWbTbpxJLzVyWkw9UE+ku8BJpKq9g9FdU
 tI70wLCBZFd48wCVbAwPqtjLAIIs0CIokqK7NwWHwMUgaXagtFRkQW8a2Sv1R+cKUO7Y
 3I+sC94B6WjPPOQCrPo9dAZjKTH4g7C0XhaE8EPK5+JD6qXMnptlQey1R8QlHhBTtB+s
 GGldoUn8hAs6SRCDXtyf2vEAUkTT7vKsYMjpqSCJE6gDJJWvbNOtosnNx1v4K6cChF9U nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctwj590d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:37 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8DOOnr023896;
        Wed, 8 Dec 2021 14:12:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctwj590cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8E7Ipb017328;
        Wed, 8 Dec 2021 14:12:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyb0g0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:12:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8ECUk328639502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 14:12:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF2AB5206D;
        Wed,  8 Dec 2021 14:12:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8C5215204E;
        Wed,  8 Dec 2021 14:12:29 +0000 (GMT)
Date:   Wed, 8 Dec 2021 14:07:38 +0100
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
Subject: Re: [PATCH 02/32] s390/sclp: detect the AISII facility
Message-ID: <20211208140738.70227578@p-imbrenda>
In-Reply-To: <20211207205743.150299-3-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
        <20211207205743.150299-3-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CQ7jOvhj9q32MkBXIwpaaGUVyDq6s6Da
X-Proofpoint-ORIG-GUID: 3yKv5OFuQ_5aY0-sCMlEuCs8ybzN3p67
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_05,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=947 suspectscore=0 mlxscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 15:57:13 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Detect the Adapter Interruption Source ID Interpretation facility.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/sclp.h   | 1 +
>  drivers/s390/char/sclp_early.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> index c84e8e0ca344..524a99baf221 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -89,6 +89,7 @@ struct sclp_info {
>  	unsigned char has_sipl : 1;
>  	unsigned char has_dirq : 1;
>  	unsigned char has_zpci_interp : 1;
> +	unsigned char has_aisii : 1;
>  	unsigned int ibc;
>  	unsigned int mtid;
>  	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index 2e8199b7ae50..a73120b8a5de 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -45,6 +45,7 @@ static void __init sclp_early_facilities_detect(void)
>  	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
>  	sclp.has_hvs = !!(sccb->fac119 & 0x80);
>  	sclp.has_kss = !!(sccb->fac98 & 0x01);
> +	sclp.has_aisii = !!(sccb->fac118 & 0x40);
>  	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
>  	if (sccb->fac85 & 0x02)
>  		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;

