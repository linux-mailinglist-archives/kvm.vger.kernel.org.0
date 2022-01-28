Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2988449F5DA
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 10:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbiA1JDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 04:03:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230179AbiA1JDF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 04:03:05 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20S78bcs015168;
        Fri, 28 Jan 2022 09:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mO/SU9jLixFLSV9JRswrhN0zUUOWxQxP26uDdIhSLHE=;
 b=YXwmvcpJEOdZ+e0668QpbM21Mmof68Z33O8dReuzDNyWaPyXP+v5pIADn79Ldz4UcsnZ
 Brzq3xFREhtg69kHpw+66bA7PZ+HPFKBojxEAz7hMJIVmN2LMtxMyMQ3fGHJRKzHI934
 4saXAUvis7x2UzQxGNd9vmOoyq+QIQcuXbXvXSGPiFQg9ScP5EATfzBiF+gRCCWJB1MF
 Bov5tYNlWWEJbjo/kOm5Z4a7WocWfwzDQCwuSiweFlejTQl2RJ/H3OHgtWMfyaCcth+M
 IV10IauKr8+jFXjS3w3mulkKEvZFxEUTFOOkmPxi4i7oH3a6NSFxMCAWGZY96IdtdUcR tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvak233gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:03:04 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20S8lVj1020765;
        Fri, 28 Jan 2022 09:03:04 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvak233ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:03:04 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20S92nGl009939;
        Fri, 28 Jan 2022 09:03:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3dr9j9yg8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:03:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20S92whC37486920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 09:02:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 685E1AE045;
        Fri, 28 Jan 2022 09:02:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 257D2AE051;
        Fri, 28 Jan 2022 09:02:58 +0000 (GMT)
Received: from [9.145.170.148] (unknown [9.145.170.148])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 09:02:58 +0000 (GMT)
Message-ID: <54dd92b2-ecd4-209a-568b-bf0ecc16a57a@linux.ibm.com>
Date:   Fri, 28 Jan 2022 10:02:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 2/4] s390x: lib: Add QUI getter
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220127141559.35250-1-seiden@linux.ibm.com>
 <20220127141559.35250-3-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220127141559.35250-3-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Of_OhAnPKf18brNOOLcTwN4WKTRfGu-C
X-Proofpoint-ORIG-GUID: 4IdUoKyu3jP8s1EY2NBpvPdlYMOIp_g5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_01,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 phishscore=0 suspectscore=0 mlxscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 15:15, Steffen Eiden wrote:
> Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
> already has cached the qui result. Let's add a function to avoid
> unnecessary  QUI UVCs.

Double space

> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   lib/s390x/uv.c | 10 +++++++++-
>   lib/s390x/uv.h |  1 +
>   2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index 6fe11dff..5625a1ee 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -2,7 +2,7 @@
>   /*
>    * Ultravisor related functionality
>    *
> - * Copyright 2020 IBM Corp.
> + * Copyright 2020, 2022 IBM Corp.
>    *
>    * Authors:
>    *    Janosch Frank <frankja@linux.ibm.com>
> @@ -47,6 +47,14 @@ bool uv_query_test_call(unsigned int nr)
>   	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
>   }
>   
> +const struct uv_cb_qui *uv_get_info(void)

uv_get_query_data?

> +{
> +	/* Query needs to be called first */
> +	assert(uvcb_qui.header.rc);
> +
> +	return &uvcb_qui;
> +}
> +
>   int uv_setup(void)
>   {
>   	if (!test_facility(158))
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> index 8175d9c6..e9935fd2 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -8,6 +8,7 @@
>   bool uv_os_is_guest(void);
>   bool uv_os_is_host(void);
>   bool uv_query_test_call(unsigned int nr);
> +const struct uv_cb_qui *uv_get_info(void);
>   void uv_init(void);
>   int uv_setup(void);
>   void uv_create_guest(struct vm *vm);
> 

