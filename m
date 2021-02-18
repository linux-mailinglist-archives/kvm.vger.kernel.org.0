Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8036D31EC1B
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 17:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhBRQP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 11:15:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230332AbhBROzu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 09:55:50 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IEguaP038504;
        Thu, 18 Feb 2021 09:54:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sAmfnz55hDwLdXGQLGrWBfn/MoTqiaYqd/jczJBeTVE=;
 b=e/7EELopdgywcsMbUkYvEnHzQ6qUoQvjo0PHINV809EB046MLnqzc8NDCA52Ib0zbyKW
 KiU+Y1FUURgWQQCIl+iehYBAeZANYVK1CDhPPnX0TH0yqa3kKd2y3oTeza7KFv3aR4pY
 hH0Nsmtx0c0HPzPCpiUD1ytDljr9d1wg2qs0IipG+XuPRI3cg3HIEhHWK+xHazezFlta
 gAE/gSjostHnTKhELL+BduuOluzHJun/tF+G7W2o6bvecEta5r9S4RM1sUOCjqGARXEX
 3dI6H08CqtTIWq8Am1vagkCFnR1oVx3HDYGdPxH52I1IIwZhbLxbi8/PfYyaCsBdGpLl aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36st84rd5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 09:54:45 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IEh529039065;
        Thu, 18 Feb 2021 09:54:45 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36st84rd4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 09:54:45 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IEreX1017120;
        Thu, 18 Feb 2021 14:54:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 36rw3u9anw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 14:54:43 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IEseuL36503838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 14:54:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF2F111C04A;
        Thu, 18 Feb 2021 14:54:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6878A11C05B;
        Thu, 18 Feb 2021 14:54:40 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.5.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 14:54:40 +0000 (GMT)
Date:   Thu, 18 Feb 2021 15:54:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: Remove sthyi partition number
 check
Message-ID: <20210218155439.0dce34cf@ibm-vm>
In-Reply-To: <20210218082449.29876-1-frankja@linux.ibm.com>
References: <20210218082449.29876-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_05:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 03:24:49 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Turns out that partition numbers start from 0 and not from 1 so a 0
> check doesn't make sense here.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/sthyi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/s390x/sthyi.c b/s390x/sthyi.c
> index d8dfc854..db90b56f 100644
> --- a/s390x/sthyi.c
> +++ b/s390x/sthyi.c
> @@ -128,7 +128,6 @@ static void test_fcode0_par(struct sthyi_par_sctn
> *par) report(sum, "core counts");
>  
>  	if (par->INFPVAL1 & PART_STSI_SUC) {
> -		report(par->INFPPNUM, "number");
>  		report(memcmp(par->INFPPNAM, null_buf,
> sizeof(par->INFPPNAM)), "name");
>  	}

