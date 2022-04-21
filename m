Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F27509E86
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 13:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388779AbiDUL3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 07:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiDUL3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 07:29:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B5A2180B;
        Thu, 21 Apr 2022 04:26:21 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9LDem025694;
        Thu, 21 Apr 2022 11:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/jF8e4hTfgt79JfiEll7thWIgxcsFYfOpY18EW6sRt8=;
 b=RdzyG9P7ON4jgRNq4ur6USm/0P9osfWqLjB3iJ4qvHsXmY2y4dK9bVFN+joxgyCn4NMJ
 w3woxoNbqYIo8xAfWyLVQQu15JN0ziLUDY6BX7Y6KnBArOf2d0YMciXjiP/HzrISOPIz
 gagNO/lXgBP+O+A7xCrWaCITbUakvzKZrKQyJ8M0Yhsn3alQuMyk/qzzIEVCmZS7Nd7V
 wTUWD5zWmwC+5gLXrX/NFHiAbmqVMVjnEJMPCOzPmW84M5W9pJ4bZjF/yI9igSECzeRn
 wrUHtgA/NTCWcTQnKnIOKj8x6dj7/pxdiCbrlHiJcTtHTh7mFTsi71Zbk3mbEBlmr1bz dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjyk4qrj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:26:20 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23LBOOff014682;
        Thu, 21 Apr 2022 11:26:20 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjyk4qrht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:26:20 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LBDhPf007937;
        Thu, 21 Apr 2022 11:26:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3ffn2hx512-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:26:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LBQEFG40370522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 11:26:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD19842041;
        Thu, 21 Apr 2022 11:26:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76E214203F;
        Thu, 21 Apr 2022 11:26:14 +0000 (GMT)
Received: from [9.145.69.75] (unknown [9.145.69.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 11:26:14 +0000 (GMT)
Message-ID: <1d48456d-f48b-e04c-dcaa-686028533cfe@linux.ibm.com>
Date:   Thu, 21 Apr 2022 13:26:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v4 2/5] s390x: lib: Add QUI getter
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220421094527.32261-1-seiden@linux.ibm.com>
 <20220421094527.32261-3-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220421094527.32261-3-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Sf9XxeEJDzMRSS6D6g38UBo4dATBFSZc
X-Proofpoint-GUID: uEOAZDzVpXydMJQbOMY-8qrNYjCXWWqX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210062
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 11:45, Steffen Eiden wrote:
> Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
> already has cached the qui result. Let's add a function to avoid
> unnecessary QUI UVCs.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

If you fix the issue below:
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


uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100

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

