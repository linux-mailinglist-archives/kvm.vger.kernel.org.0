Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645F87194AD
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 09:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjFAHrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 03:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjFAHpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 03:45:21 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB2018D;
        Thu,  1 Jun 2023 00:42:55 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3517gohm011768;
        Thu, 1 Jun 2023 07:42:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2nhb2G5vZGOm/oQEZn6+EKktkdDhEHyBzKEv68/ux2Q=;
 b=E5aSg87lWwVgmGyBGYtaL5Qz3gmq/sUIx9I945v7oIFY1qKQCMV8bGNUBzbF92pN++lg
 BjqiBC2oQd927eu2RaGcJOsyAhmOY/XMjY5R8D2v5YBnMU1Lzr9+6rVlHpTQ720anmIW
 mmCNWAgMDtoyb7x6FiP5CNOzwDzaHIOPC8DD9EU4WJkF7va9j3AtRQanggEXNgD/0Blj
 9KFLlWainDJcP1yDV+qXndkInLL0bDX/LD8wWYzR9V5V8rxYB+4HbfgFN39SDvNjdj3Z
 B57oJj4RHjytcUvWYZpW4G3KC8AhVmSNq6lt4hTvps6fyoVMBkP9WZReGCzsXY5VGm5C wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpur0cnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:42:54 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3517gs1q011967;
        Thu, 1 Jun 2023 07:42:54 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpur0cme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:42:54 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3515ZQ8C003622;
        Thu, 1 Jun 2023 07:42:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qu9g520gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:42:52 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3517gnir45941392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 07:42:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 258D220043;
        Thu,  1 Jun 2023 07:42:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D148520040;
        Thu,  1 Jun 2023 07:42:48 +0000 (GMT)
Received: from [9.171.14.211] (unknown [9.171.14.211])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 07:42:48 +0000 (GMT)
Message-ID: <3667d7af-f9ba-fbb6-537d-e6143f63ac43@linux.ibm.com>
Date:   Thu, 1 Jun 2023 09:42:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-2-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/6] lib: s390x: introduce bitfield for
 PSW mask
In-Reply-To: <20230601070202.152094-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ROVdbmKfeJdB2LNxQRZd9e5_VzxACRip
X-Proofpoint-GUID: 503zh4OY3sQVdbTC1jt5JLvCJJPMW0dO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_04,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=946 bulkscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010067
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/23 09:01, Nico Boehr wrote:
> Changing the PSW mask is currently little clumsy, since there is only the
> PSW_MASK_* defines. This makes it hard to change e.g. only the address
> space in the current PSW without a lot of bit fiddling.
> 
> Introduce a bitfield for the PSW mask. This makes this kind of
> modifications much simpler and easier to read.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 25 ++++++++++++++++++++++++-
>   s390x/selftest.c         | 40 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bb26e008cc68..84f6996c4d8c 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -37,12 +37,35 @@ struct stack_frame_int {
>   };
>   
>   struct psw {
> -	uint64_t	mask;
> +	union {
> +		uint64_t	mask;
> +		struct {
> +			uint8_t reserved00:1;
> +			uint8_t per:1;
> +			uint8_t reserved02:3;
> +			uint8_t dat:1;
> +			uint8_t io:1;
> +			uint8_t ext:1;
> +			uint8_t key:4;
> +			uint8_t reserved12:1;
> +			uint8_t mchk:1;
> +			uint8_t wait:1;
> +			uint8_t pstate:1;
> +			uint8_t as:2;
> +			uint8_t cc:2;
> +			uint8_t prg_mask:4;
> +			uint8_t reserved24:7;
> +			uint8_t ea:1;
> +			uint8_t ba:1;
> +			uint32_t reserved33:31;

Hrm, since I already made the mistake of introducing bitfields with and 
without spaces between the ":" I'm in no position to complain here.

I'm also not sure what the consensus is.

> +		};
> +	};
>   	uint64_t	addr;
>   };

I've come to like static asserts for huge structs and bitfields since 
they can safe you from a *lot* of headaches.

>   
>   #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
>   
> +

Whitespace damage

>   struct short_psw {
>   	uint32_t	mask;
>   	uint32_t	addr;
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index 13fd36bc06f8..8d81ba312279 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -74,6 +74,45 @@ static void test_malloc(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_psw_mask(void)
> +{
> +	uint64_t expected_key = 0xF;

We're using lowercase chars for hex constants

> +	struct psw test_psw = PSW(0, 0);
> +
> +	report_prefix_push("PSW mask");
> +	test_psw.dat = 1;
> +	report(test_psw.mask == PSW_MASK_DAT, "DAT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_DAT, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.io = 1;
> +	report(test_psw.mask == PSW_MASK_IO, "IO matches expected=0x%016lx actual=0x%016lx", PSW_MASK_IO, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.ext = 1;
> +	report(test_psw.mask == PSW_MASK_EXT, "EXT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_EXT, test_psw.mask);
> +
> +	test_psw.mask = expected_key << (63 - 11);
> +	report(test_psw.key == expected_key, "PSW Key matches expected=0x%lx actual=0x%x", expected_key, test_psw.key);
> +
> +	test_psw.mask = 1UL << (63 - 13);
> +	report(test_psw.mchk, "MCHK matches");
> +
> +	test_psw.mask = 0;
> +	test_psw.wait = 1;
> +	report(test_psw.mask == PSW_MASK_WAIT, "Wait matches expected=0x%016lx actual=0x%016lx", PSW_MASK_WAIT, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.pstate = 1;
> +	report(test_psw.mask == PSW_MASK_PSTATE, "Pstate matches expected=0x%016lx actual=0x%016lx", PSW_MASK_PSTATE, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.ea = 1;
> +	test_psw.ba = 1;
> +	report(test_psw.mask == PSW_MASK_64, "BA/EA matches expected=0x%016lx actual=0x%016lx", PSW_MASK_64, test_psw.mask);
> +
> +	report_prefix_pop();
> +}
> +
>   int main(int argc, char**argv)
>   {
>   	report_prefix_push("selftest");
> @@ -89,6 +128,7 @@ int main(int argc, char**argv)
>   	test_fp();
>   	test_pgm_int();
>   	test_malloc();
> +	test_psw_mask();
>   
>   	return report_summary();
>   }

