Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FBF3B149D
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 09:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhFWHcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 03:32:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10184 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhFWHcM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 03:32:12 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N735hj128278;
        Wed, 23 Jun 2021 03:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1PxWw8Sl+Wy2LxI9yyqwdQNB2LGT7fL5g7Xk0g2kyJg=;
 b=FYoIoK7C2XuSM0PzWFOM1wqOASdwtTeVdAhHuMjlJCRYIFtqnJqg778sUE38dZ377FXy
 K0H38Horq8+uYPgxS7y8mvrFFrQVJstpuy6JKmySbwvzoRTn6YbAYLOenPBBq6iH4lpc
 lpnk6db3OxZjENPaDuFd45KlWDGD6AbU4E7EKXbSy5oySQ72+K//4VQrGs2A8bKPGsP1
 gdqCC0UXam8tmSkXE1a4LixGynoU/dEmUi45BzVkPpNMW7/RaA9VlVqmTryU0ShAk3Ml
 /pd2n7W8kmh/OBa7PKektYbUB5yLiQmsXOfTq63zoWNrkpS9ZdGKr6EfwGmc4NIYhNZW yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39byp71tap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 03:29:54 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15N73njI130725;
        Wed, 23 Jun 2021 03:29:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39byp71t9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 03:29:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15N7S9MR031891;
        Wed, 23 Jun 2021 07:29:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3998789ttn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 07:29:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15N7SRhv33816900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 07:28:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FAD9A404D;
        Wed, 23 Jun 2021 07:29:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E79F5A4040;
        Wed, 23 Jun 2021 07:29:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.77.251])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Jun 2021 07:29:48 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: s390: gen_facilities: allow facilities 165, 193,
 194 and 196
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
 <20210622143412.143369-2-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <804db2fe-5c69-737c-b843-2e7b698ade29@linux.ibm.com>
Date:   Wed, 23 Jun 2021 09:29:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622143412.143369-2-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WFyuo5W7VW8FdSz-aOEdlNGFZqIR26Jk
X-Proofpoint-ORIG-GUID: CEPvoRDdyfgcgtmfLSm-Ogo1afpkt8Rg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_02:2021-06-22,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1015 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/21 4:34 PM, Christian Borntraeger wrote:
> This enables the neural NNPA, BEAR enhancement,reset DAT protection and
> processor activity counter facilities via the cpu model.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/tools/gen_facilities.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
> index 61ce5b59b828..606324e56e4e 100644
> --- a/arch/s390/tools/gen_facilities.c
> +++ b/arch/s390/tools/gen_facilities.c
> @@ -115,6 +115,10 @@ static struct facility_def facility_defs[] = {
>  			12, /* AP Query Configuration Information */
>  			15, /* AP Facilities Test */
>  			156, /* etoken facility */
> +			165, /* nnpa facility */
> +			193, /* bear enhancement facility */
> +			194, /* rdp enhancement facility */
> +			196, /* processor activity instrumentation facility */
>  			-1  /* END */
>  		}
>  	},
> 

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
