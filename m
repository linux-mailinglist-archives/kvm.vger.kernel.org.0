Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99415422701
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 14:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhJEMsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 08:48:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234026AbhJEMsU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 08:48:20 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195Cfe2S025229;
        Tue, 5 Oct 2021 08:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ek2whv3pqDoimJiiO/YCyQNRCmDt/PNumxYsScMUZXA=;
 b=Bsi4c2T6bALFksNcQH759H/pug3+8m5pVe5Dkid0B/TesaTlBYbalKouxMQAW0ddY4d6
 MWKUVqadxeOWQoYlXQ75ooPZ70/S2o73GH1+Dm9mM3mZ2hi84YY8NrR9J6w92RBIbZzP
 PK1tK7cTJ+qOQU2eS0yaUZS2JrKq9F5p7GkYyfC52uRGNUSlOz9h197QxDoCkHYY7H0C
 Knq/6k9j0TfKFpWsDhT2Vn7KK7jv3v2Qe+R878haylZFfluw8QIg/djkxEjncDkouo8G
 nVThRGyMyzCEyZ6kTXr/ZAeHACaiYGkPAcW1jJjdsZfTs0CR9SoP3J4EJZKkZyUwUOeH OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgpxcg3xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 08:46:29 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195CgSSQ027015;
        Tue, 5 Oct 2021 08:46:29 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgpxcg3wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 08:46:28 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195ChfF6007531;
        Tue, 5 Oct 2021 12:46:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3beepjje6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 12:46:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195CkMgA64684470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 12:46:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C148D4C052;
        Tue,  5 Oct 2021 12:46:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33B4F4C046;
        Tue,  5 Oct 2021 12:46:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.133])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 12:46:22 +0000 (GMT)
Date:   Tue, 5 Oct 2021 14:46:20 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: Remove assert from
 arch_def.h
Message-ID: <20211005144620.579e48c1@p-imbrenda>
In-Reply-To: <20211005091153.1863139-2-scgl@linux.ibm.com>
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
        <20211005091153.1863139-2-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6isCI41i1JVouLcqAKo2CGfErCTDKSGS
X-Proofpoint-GUID: cOCm9qIbyN4Mn7LBZm87nhOQkr_rX7jn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_01,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Oct 2021 11:11:52 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Do not use asserts in arch_def.h so it can be included by snippets.
> The caller in stsi.c does not need to be adjusted, returning -1 causes
> the test to fail.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 302ef1f..4167e2b 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -334,7 +334,7 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
>  	return cc;
>  }
>  
> -static inline unsigned long stsi_get_fc(void)
> +static inline int stsi_get_fc(void)
>  {
>  	register unsigned long r0 asm("0") = 0;
>  	register unsigned long r1 asm("1") = 0;
> @@ -346,7 +346,8 @@ static inline unsigned long stsi_get_fc(void)
>  		     : "+d" (r0), [cc] "=d" (cc)
>  		     : "d" (r1)
>  		     : "cc", "memory");
> -	assert(!cc);
> +	if (cc != 0)
> +		return -1;
>  	return r0 >> 28;
>  }
>  

