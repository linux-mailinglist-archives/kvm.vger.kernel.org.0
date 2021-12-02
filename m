Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62B14661E7
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346184AbhLBLE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:04:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241412AbhLBLEu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 06:04:50 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2AGSTO027327;
        Thu, 2 Dec 2021 11:01:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iTilyjhxI1t2OWyf9yjk/VxD9AxqxYTOc0BAzMBnSls=;
 b=YNiXu+INMkCrPZxG8ug545FXOhGrhUBf4VL1y61TdI0XM66fRyud1HVqEYyVh3eVfJhf
 cQs1kj22ldLTvBKsLQA8IH7pla67TG/OqraBs9zTJMNwCFs5MDMzzMXb4Av42t5bBlcI
 HZHRvWODfXjBnL42LuqfGQuoU5zhzZoYNB7oUnmBbhuFXUTqMuJhgf6bHVhOt/TgnUGc
 plApyvZtBUcHSX/3njFpQTDipxiWHBL+WXBZYhtW8ttMvzptfv0+gRc2SGo6lyNbM8FR
 hP8TyJlQNVt+u7qUO3UWggvZSa0CCIx2NfpyUrpqWTdjrN1Cp/aLNYd5nWOtiPkLmgtR gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpv8e8tnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:01:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2B1Qtn029842;
        Thu, 2 Dec 2021 11:01:26 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpv8e8tmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:01:26 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2AvWvb014820;
        Thu, 2 Dec 2021 11:01:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ckcaa3588-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:01:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2B1KLJ23921066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 11:01:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EA4642045;
        Thu,  2 Dec 2021 11:01:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3A1D42049;
        Thu,  2 Dec 2021 11:01:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.140])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 11:01:19 +0000 (GMT)
Date:   Thu, 2 Dec 2021 11:33:11 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x: make smp_cpu_setup()
 return 0 on success
Message-ID: <20211202113311.320ffba7@p-imbrenda>
In-Reply-To: <20211202095843.41162-2-david@redhat.com>
References: <20211202095843.41162-1-david@redhat.com>
        <20211202095843.41162-2-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o93n6dzJSy-aJVmvCbM6goHlNjpzaQjo
X-Proofpoint-ORIG-GUID: t7OpQQpghUGO2lpKxvrtYit7Z6R9KRP_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_06,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  2 Dec 2021 10:58:42 +0100
David Hildenbrand <david@redhat.com> wrote:

> Properly return "0" on success so callers can check if the setup was
> successful.
> 
> The return value is yet unused, which is why this wasn't noticed so far.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/smp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index da6d32f..b753eab 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -212,6 +212,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>  	/* Wait until the cpu has finished setup and started the provided psw */
>  	while (lc->restart_new_psw.addr != psw.addr)
>  		mb();
> +	rc = 0;
>  out:
>  	spin_unlock(&lock);
>  	return rc;

