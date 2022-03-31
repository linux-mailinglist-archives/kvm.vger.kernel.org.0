Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B154EDCAD
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 17:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbiCaPXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 11:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238283AbiCaPXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 11:23:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60541AEC97;
        Thu, 31 Mar 2022 08:21:15 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VFHaCF016455;
        Thu, 31 Mar 2022 15:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HjY7ZaFnbnKXz+eLM0jthUmiGI2T+hKruWj49AoyMOg=;
 b=CNS+Vl6//krBspbvnQQX3BXwe0F8zt7NUFxEOToYl7Gf7jK7JqUkuge+P3b3/gVhT2Op
 beuecKq27z9CES6c9+L8hv1tQ7yfSD1xI7X5UAsl6azRktsklhlGOJmUpQQE1kdFcVGi
 ZNeazCw1PytgmgrFmmiSiJ8KfJ7JTpqMXQ4Ws4plGKKAkS6QKgJXBqL7dYGGSF2L/7jE
 QNmuwl0kfZYqrT0nn2Eh7CUId54gzL1fuwER890Y8H9hoX6ek66CfO08/XS/XfKVZnRp
 gFOFvm4ohzz9sCGU9pQs6RFsgUFHnSYi0vwHBydqEJQgeTzg6rynOBXsO2DIZ+p+exED PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f58888u4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:21:14 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VEDQZe027701;
        Thu, 31 Mar 2022 15:21:14 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f58888u40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:21:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VFDHnP024282;
        Thu, 31 Mar 2022 15:21:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf91dn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:21:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VFL9NI42139982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 15:21:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AE7A11C04C;
        Thu, 31 Mar 2022 15:21:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7334F11C050;
        Thu, 31 Mar 2022 15:21:08 +0000 (GMT)
Received: from [9.145.159.108] (unknown [9.145.159.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 15:21:08 +0000 (GMT)
Message-ID: <5e81b55b-4dc9-d708-2526-9eccbbc28659@linux.ibm.com>
Date:   Thu, 31 Mar 2022 17:21:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v1 3/4] lib: s390x: functions for machine
 models
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com,
        borntraeger@de.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        nrb@linux.ibm.com, thuth@redhat.com, david@redhat.com
References: <20220330144339.261419-1-imbrenda@linux.ibm.com>
 <20220330144339.261419-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220330144339.261419-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sr9arhG20cQmZOwXtuiR4VaQ8Vq3F6OF
X-Proofpoint-ORIG-GUID: bYn-v7xmZC2OeCJFMoy2ZVVtHMGrlX40
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 clxscore=1015 spamscore=0 mlxlogscore=820
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 16:43, Claudio Imbrenda wrote:
> * move existing macros for machine models to hardware.h
> * add macros for all known machine models
> * add machine_is_* functions

While I appreciate the effort that you put into this I question the need 
to check for anything below z13 right now.

I'd suggest we cut down this patch to the move of the z15 defines and be 
done with it for now.

> ---
>   lib/s390x/asm/arch_def.h |  3 --
>   lib/s390x/hardware.h     | 82 ++++++++++++++++++++++++++++++++++++++++
>   s390x/uv-host.c          |  4 +-
>   3 files changed, 84 insertions(+), 5 deletions(-)
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
> index 93f817ca..fb6565ad 100644
> --- a/lib/s390x/hardware.h
> +++ b/lib/s390x/hardware.h
> @@ -13,6 +13,25 @@
>   #define _S390X_HARDWARE_H_
>   #include <asm/arch_def.h>
>   
> +#define MACHINE_Z900	0x2064
> +#define MACHINE_Z800	0x2066
> +#define MACHINE_Z990	0x2084
> +#define MACHINE_Z890	0x2086
> +#define MACHINE_Z9EC	0x2094
> +#define MACHINE_Z9BC	0x2096
> +#define MACHINE_Z10EC	0x2097
> +#define MACHINE_Z10BC	0x2098
> +#define MACHINE_Z196	0x2817
> +#define MACHINE_Z114	0x2818
> +#define MACHINE_ZEC12	0x2827
> +#define MACHINE_ZBC12	0x2828
> +#define MACHINE_Z13	0x2964
> +#define MACHINE_Z13S	0x2965
> +#define MACHINE_Z14	0x3906
> +#define MACHINE_Z14ZR1	0x3907
> +#define MACHINE_Z15	0x8561
> +#define MACHINE_Z15T02	0x8562
> +
>   enum s390_host {
>   	HOST_IS_UNKNOWN,
>   	HOST_IS_LPAR,
> @@ -44,4 +63,67 @@ static inline bool host_is_zvm6(void)
>   	return detect_host() == HOST_IS_ZVM6;
>   }
>   
> +static inline bool machine_is_z900(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_Z900 || machine == MACHINE_Z800;
> +}
> +
> +static inline bool machine_is_z990(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_Z990 || machine == MACHINE_Z890;
> +}
> +
> +static inline bool machine_is_z9(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_Z9EC || machine == MACHINE_Z9BC;
> +}
> +
> +static inline bool machine_is_z10(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_Z10EC || machine == MACHINE_Z10BC;
> +}
> +
> +static inline bool machine_is_z1xx(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_Z196 || machine == MACHINE_Z114;
> +}
> +
> +static inline bool machine_is_z12(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_ZEC12 || machine == MACHINE_ZBC12;
> +}
> +
> +static inline bool machine_is_z13(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_Z13 || machine == MACHINE_Z13S;
> +}
> +
> +static inline bool machine_is_z14(void)
> +{
> +	uint16_t machine = get_machine_id();
> +
> +	return machine == MACHINE_Z14 || machine == MACHINE_Z14ZR1;
> +}
> +
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

