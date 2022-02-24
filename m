Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA42A4C34E4
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 19:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbiBXSmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 13:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiBXSmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 13:42:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0961A593BA;
        Thu, 24 Feb 2022 10:41:44 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OHknNM026532;
        Thu, 24 Feb 2022 18:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wNVrJ/FMGNpu39kHvm8GV1qRktbTk85MUQoY3p7mL3I=;
 b=f1uO/JlPftf0pRsaS6hmSYFDEIAzn/76cO95595vUmZxotUiLVp+KutroJdXM//GV6os
 X4RPkpqVRXUgBodVGoFwcdgQBt2MIALghwu8uy5Va3LricGB4Yqe3h3E4xjjK0JCf0Tg
 axNnmaZOnU0X8mPNoeP43mX1KT90QykjZFJO2QYPOneFDjAmq8C2ulypyWVHP7RaiGoR
 yG3pfRdfkjEzVuTfhgr5fhMcN/QWKaqkrKZz5Y4n6lg/wS9bZLwWHv0edoJS1JvvLrPX
 FKWHitQMvavNzc4gF+FqG5oicFeJsJWDpI88ymDScolLHajcas+d0aofotTqaO6KtXMk jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edwkeqpv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 18:41:43 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21OI4KEO012376;
        Thu, 24 Feb 2022 18:41:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edwkeqpuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 18:41:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OIbCeU008619;
        Thu, 24 Feb 2022 18:41:40 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ear69htrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 18:41:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OIeMcI46793192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 18:40:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94E79AE04D;
        Thu, 24 Feb 2022 18:40:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 274C9AE045;
        Thu, 24 Feb 2022 18:40:22 +0000 (GMT)
Received: from [9.171.25.98] (unknown [9.171.25.98])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 18:40:22 +0000 (GMT)
Message-ID: <2f5be4d0-f6f4-75d7-41de-4a13140e50c9@linux.ibm.com>
Date:   Thu, 24 Feb 2022 19:42:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 1/8] s390x: Add more tests for MSCH
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
References: <20220224154336.3459839-1-nrb@linux.ibm.com>
 <20220224154336.3459839-2-nrb@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220224154336.3459839-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mdefjSd666RJ1s_I0ij7FfRWDIRcnSQr
X-Proofpoint-ORIG-GUID: FoNNC2cyOS6mhST4BxyalRLFUahICjVK
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_04,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/24/22 16:43, Nico Boehr wrote:
> We already have some coverage for MSCH, but there are more cases to test
> for:
> 
> - invalid SCHIB structure. We cover that by setting reserved bits 0, 1,
>    6 and 7 in the flags of the PMCW.
>    Older QEMU versions require this bit to always be zero on msch,
>    which is why this test may fail. A fix is available in QEMU master
>    commit 2df59b73e086 ("s390x/css: fix PMCW invalid mask").
> - a pointer to an unaligned SCHIB. We cover misalignment by 1
>    and 2 bytes. Using pointer to valid memory avoids messing up
>    random memory in case of test failures.
> 
> Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Here too I gave my R-B already a long time ago didn't I ?

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

> ---
>   s390x/css.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 58 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 881206ba1cef..396007ed0074 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -27,6 +27,8 @@ static int test_device_sid;
>   static struct senseid *senseid;
>   struct ccw1 *ccw;
>   
> +char alignment_test_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
>   static void test_enumerate(void)
>   {
>   	test_device_sid = css_enumerate();
> @@ -331,6 +333,61 @@ static void test_schm_fmt1(void)
>   	free_io_mem(mb1, sizeof(struct measurement_block_format1));
>   }
>   
> +static void test_msch(void)
> +{
> +	int invalid_pmcw_flags[] = {0, 1, 6, 7};
> +	struct schib test_schib;
> +	uint16_t old_pmcw_flags;
> +	const int align_to = 4;
> +	int invalid_flag;
> +	int cc;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +
> +	cc = stsch(test_device_sid, &schib);
> +	if (cc) {
> +		report_fail("stsch: sch %08x failed with cc=%d", test_device_sid, cc);
> +		return;
> +	}
> +
> +	report_prefix_push("Unaligned");
> +	for (int i = 1; i < align_to; i *= 2) {
> +		report_prefix_pushf("%d", i);
> +
> +		expect_pgm_int();
> +		msch(test_device_sid, (struct schib *)(alignment_test_page + i));
> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	report_prefix_push("Invalid SCHIB");
> +	old_pmcw_flags = schib.pmcw.flags;
> +	for (int i = 0; i < ARRAY_SIZE(invalid_pmcw_flags); i++) {
> +		invalid_flag = invalid_pmcw_flags[i];
> +
> +		report_prefix_pushf("PMCW flag bit %d set", invalid_flag);
> +
> +		schib.pmcw.flags = old_pmcw_flags | BIT(15 - invalid_flag);
> +		expect_pgm_int();
> +		msch(test_device_sid, &schib);
> +		check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +
> +		cc = stsch(test_device_sid, &test_schib);
> +		report(!cc, "STSCH succeeded");
> +		report(!(test_schib.pmcw.flags & BIT(15 - invalid_flag)), "Clear on STSCH");
> +
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	schib.pmcw.flags = old_pmcw_flags;
> +}
> +
>   static struct {
>   	const char *name;
>   	void (*func)(void);
> @@ -343,6 +400,7 @@ static struct {
>   	{ "measurement block (schm)", test_schm },
>   	{ "measurement block format0", test_schm_fmt0 },
>   	{ "measurement block format1", test_schm_fmt1 },
> +	{ "msch", test_msch },
>   	{ NULL, NULL }
>   };
>   
> 

-- 
Pierre Morel
IBM Lab Boeblingen
