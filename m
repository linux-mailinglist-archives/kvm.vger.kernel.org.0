Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B63C4EE996
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbiDAIMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344214AbiDAIMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:12:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8DF1F3797;
        Fri,  1 Apr 2022 01:10:46 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2317eLxe020671;
        Fri, 1 Apr 2022 08:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LawAo55IiFe5cj+pFnOhoF/vmkrCC8wckFnSCggoXRE=;
 b=sS9UZAma6+k//wjnKJhye+jv5T9BcQ88z990pJjyp7bJfMnsn9NUdR9LihVZKvXP+uN7
 XWImVJaETkBFW9nnpWWHE75yDd4I3Yyi0pyORLAi3JeK+lH2FpgB3YLZHjqpztZH4h5+
 8wEH3qP4MlYBPkBYecB90gnBhu5NNTzUGtzadNC31KVHUrbpSufwfXfGzSUuKGZD/Ryl
 mFf0fy7xdo2KcTp53Y8EmgWKtc3ptfZG7y2am3I+QJcRTHGl9XsemFF2nNqKj9FXeLaN
 iyASNHWFAP+tpvaGHvdR8ou8g0DbCAEs1l1e7fndK6etlaK8pRIEPFUK++QYK84RUrG3 /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f5a3kq9wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 08:10:45 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2317ebHi021101;
        Fri, 1 Apr 2022 08:10:44 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f5a3kq9wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 08:10:44 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23187bEN003032;
        Fri, 1 Apr 2022 08:10:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3f1tf92m98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 08:10:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2317wZjX42729946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 07:58:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42C8842057;
        Fri,  1 Apr 2022 08:10:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB85B42041;
        Fri,  1 Apr 2022 08:10:38 +0000 (GMT)
Received: from [9.145.70.97] (unknown [9.145.70.97])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 08:10:38 +0000 (GMT)
Message-ID: <aaea27d2-51b3-e765-c3e0-0a39eff3a444@linux.ibm.com>
Date:   Fri, 1 Apr 2022 10:10:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v2 4/5] lib: s390x: functions for machine
 models
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com,
        borntraeger@de.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        nrb@linux.ibm.com, thuth@redhat.com, david@redhat.com
References: <20220331160419.333157-1-imbrenda@linux.ibm.com>
 <20220331160419.333157-5-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220331160419.333157-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zwwC8_h9pAAILtPExrpEJlYZAF7kN8Xu
X-Proofpoint-ORIG-GUID: 3KZFM7rtNso7-Zr1U2GPqpvz7vrdbvVI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_02,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=914 suspectscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/31/22 18:04, Claudio Imbrenda wrote:
> * move existing macros for machine models to hardware.h
> * add machine_is_* functions
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/asm/arch_def.h |  3 ---
>   lib/s390x/hardware.h     | 10 ++++++++++
>   s390x/uv-host.c          |  4 ++--
>   3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 40626d72..8d860ccf 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -219,9 +219,6 @@ static inline unsigned short stap(void)
>   	return cpu_address;
>   }
>   
> -#define MACHINE_Z15A	0x8561
> -#define MACHINE_Z15B	0x8562
> -
>   static inline uint16_t get_machine_id(void)
>   {
>   	uint64_t cpuid;
> diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
> index e5910ea5..af20be18 100644
> --- a/lib/s390x/hardware.h
> +++ b/lib/s390x/hardware.h
> @@ -13,6 +13,9 @@
>   #define _S390X_HARDWARE_H_
>   #include <asm/arch_def.h>
>   
> +#define MACHINE_Z15	0x8561
> +#define MACHINE_Z15T02	0x8562
> +
>   enum s390_host {
>   	HOST_IS_UNKNOWN,
>   	HOST_IS_LPAR,
> @@ -37,4 +40,11 @@ static inline bool host_is_lpar(void)
>   	return detect_host() == HOST_IS_LPAR;
>   }
>   
> +static inline bool machine_is_z15(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_Z15 || machine == MACHINE_Z15T02;
> +}
> +
>   #endif  /* _S390X_HARDWARE_H_ */
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index de2e4850..d3018e3c 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -9,6 +9,7 @@
>    */
>   
>   #include <libcflat.h>
> +#include <hardware.h>
>   #include <alloc.h>
>   #include <vmalloc.h>
>   #include <sclp.h>
> @@ -111,7 +112,6 @@ static void test_config_destroy(void)
>   static void test_cpu_destroy(void)
>   {
>   	int rc;
> -	uint16_t machineid = get_machine_id();
>   	struct uv_cb_nodata uvcb = {
>   		.header.len = sizeof(uvcb),
>   		.header.cmd = UVC_CMD_DESTROY_SEC_CPU,
> @@ -126,7 +126,7 @@ static void test_cpu_destroy(void)
>   	       "hdr invalid length");
>   	uvcb.header.len += 8;
>   
> -	if (machineid != MACHINE_Z15A && machineid != MACHINE_Z15B) {
> +	if (!machine_is_z15()) {
>   		uvcb.handle += 1;
>   		rc = uv_call(0, (uint64_t)&uvcb);
>   		report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");

