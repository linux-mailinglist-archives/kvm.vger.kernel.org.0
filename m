Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D704E4DC5
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbiCWIJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiCWIJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:09:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FA174870;
        Wed, 23 Mar 2022 01:07:34 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N4rMVN026163;
        Wed, 23 Mar 2022 08:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=akQDP+KYxvTdm/Qyo5AkQExa7fVcXAgJ8MEXWP6MtKk=;
 b=WUJxESkiGiJNFw2S/Lo3aCO7duHWVjImkqdKFYjtv84V4HYW0Fop0UBBxlzsbAVlkLwz
 gvdrLYWvj6IPX/NhflgiKu9KKVftuJNpQwbxtxg2vk63kt2OcpRnxbceYXANQk9Re0uB
 GJmR8J0T/GKYl3trOgvpIQoklZiQ8d+sGU3aeuIUkZKsMX72BxR3ATkQHMBUhutuWB2b
 BhAMIJhsLrIwWojNO3LK9bTcYSa8faJj3DilM/gyJWkpjWeujZCT24DhPtPVrbPUxpJ0
 oxmUX6TB270def0Lbu7a8jP9/NES8LC3M4Z4N2KshosUhXOcUhrVgM6ZQNTeKj7d73e8 BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyvx035js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:07:33 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22N85hd3014726;
        Wed, 23 Mar 2022 08:07:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyvx035j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:07:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22N86sBi029789;
        Wed, 23 Mar 2022 08:07:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej01s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:07:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22N87S9v53215654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 08:07:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5559111C052;
        Wed, 23 Mar 2022 08:07:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 189AC11C050;
        Wed, 23 Mar 2022 08:07:28 +0000 (GMT)
Received: from [9.145.94.199] (unknown [9.145.94.199])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 08:07:27 +0000 (GMT)
Message-ID: <0e282f42-1ae8-0b83-8483-f04a04e9179e@linux.ibm.com>
Date:   Wed, 23 Mar 2022 09:07:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v3 2/5] s390x: lib: Add QUI getter
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220222145456.9956-1-seiden@linux.ibm.com>
 <20220222145456.9956-3-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220222145456.9956-3-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5jxJtUlVqBtcyX4xITDjqKY5KkRZbL8Q
X-Proofpoint-GUID: qiSU67tXxIjbkRSK5bjcgiOdXjWIe_FZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_08,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 15:54, Steffen Eiden wrote:
> Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
> already has cached the qui result. Let's add a function to avoid
> unnecessary QUI UVCs.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/uv.c | 8 ++++++++
>   lib/s390x/uv.h | 1 +
>   2 files changed, 9 insertions(+)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index 6fe11dff..602cbbfc 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -47,6 +47,14 @@ bool uv_query_test_call(unsigned int nr)
>   	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
>   }
>   
> +const struct uv_cb_qui *uv_get_query_data(void)
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
> index 8175d9c6..44264861 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -8,6 +8,7 @@
>   bool uv_os_is_guest(void);
>   bool uv_os_is_host(void);
>   bool uv_query_test_call(unsigned int nr);
> +const struct uv_cb_qui *uv_get_query_data(void);
>   void uv_init(void);
>   int uv_setup(void);
>   void uv_create_guest(struct vm *vm);

