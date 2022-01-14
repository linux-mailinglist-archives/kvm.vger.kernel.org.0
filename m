Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBD148E916
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 12:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240789AbiANLUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 06:20:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240785AbiANLUM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 06:20:12 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E9uUex038975;
        Fri, 14 Jan 2022 11:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zs9Vs8BInhFQrY+SYtiH6aG9sHlPwB6ir4xVIZYWnas=;
 b=ZOyc/evImRo1+7kQluHmGJHpI0+ffh4J6tW669XAWcnFWl0lZh8aOTDWnm3SOQMGwy/h
 /HodBk9APEbxOFORZPRyvVycZr4wPVKixm11fBMgtodP9LsOVzwROhBir7RpI7sHn1zW
 wecuDIQ961qnNzfa4c2O9I4NUUk2LQ6XYkVJfZt8v6eSEp9qViE2Ll6C4XIc5L7c/pFn
 fqcLDiUCT8Tfv+xii5TKhRlNsY81VNieggJXin1qMB0c2087/CwHG3kmbl2+df8vXRiV
 iFTi16E0NgSdgy9a+TI0eowV/Zcs3thnNdWJC/bamfSB1OKaD7F3mJJB+hdqrp6K9tBy 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk702scqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EAj2mN029336;
        Fri, 14 Jan 2022 11:20:11 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk702scq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EBDU3E015335;
        Fri, 14 Jan 2022 11:20:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3df28a2pmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EBK6rg44171574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 11:20:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A4064C050;
        Fri, 14 Jan 2022 11:20:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 935014C046;
        Fri, 14 Jan 2022 11:20:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 11:20:05 +0000 (GMT)
Date:   Fri, 14 Jan 2022 12:19:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 5/5] s390x: firq: Fix sclp buffer
 allocation
Message-ID: <20220114121900.540bf127@p-imbrenda>
In-Reply-To: <20220114100245.8643-6-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
        <20220114100245.8643-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tqgk-skTUEjNLS4XtN9JzGB19lXedfx7
X-Proofpoint-ORIG-GUID: Uex3p1Yi7nFrxUGsc17f6nXWbIidTR5b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 impostorscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 10:02:45 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> We need a 32 bit address for the sclp buffer so let's use a page from
> the first 31 bits.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/firq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/firq.c b/s390x/firq.c
> index 1f877183..a0ef1555 100644
> --- a/s390x/firq.c
> +++ b/s390x/firq.c
> @@ -87,7 +87,7 @@ static void test_wait_state_delivery(void)
>  	 */
>  	while(smp_sense_running_status(1));
>  
> -	h = alloc_page();
> +	h = alloc_pages_flags(1, AREA_DMA31);
>  	h->length = 4096;
>  	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
>  	if (ret) {

