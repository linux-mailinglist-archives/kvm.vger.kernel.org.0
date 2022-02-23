Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CB14C16FF
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242182AbiBWPj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242170AbiBWPjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:39:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0F1BD2C3;
        Wed, 23 Feb 2022 07:39:15 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NDlfu3016577;
        Wed, 23 Feb 2022 15:39:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date : to :
 cc : references : from : subject : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PaRikS2lHJXMoCbgRH4ZYKDmlc9yznXSXaa+a9DPKWc=;
 b=NpWgDiogahYGbiu0VEUT2aEisihmJ1jEsp69PZP9Ddwy6ihu/hl8fwu1SW4FSmEYF0f6
 U4KRz+edCOkERIc3FVzobU78CKKiOzMOU0fjr9GRnAp8RhUeQaxSmClvx8y3tHFADLoV
 qPlzA0eoKfAySQ3qXff7//5tC9z3ioDrTFff+X5eoZYcZQtHct0CpejoqXvHWfmgj2UQ
 bMlI4MAV7Y2jc9xUu4abTWe9hVVYobnCysjDkGezbd8kIZpEk+Tfb1OGPhSoK8c5xJT5
 fnLcxCHa0idthrBM/Q1V/AKUkUAriseYxAYidd65zNaJHUd80putipwrxKbDS4nCnGQU pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edp4f2vtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:39:14 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NEvaTl030626;
        Wed, 23 Feb 2022 15:39:14 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edp4f2vss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:39:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NFWZIp027391;
        Wed, 23 Feb 2022 15:39:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ear69b801-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:39:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NFd8pi54788514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 15:39:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1A2911C052;
        Wed, 23 Feb 2022 15:39:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83B2811C058;
        Wed, 23 Feb 2022 15:39:07 +0000 (GMT)
Received: from [9.145.59.38] (unknown [9.145.59.38])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 15:39:07 +0000 (GMT)
Message-ID: <04daca6a-5863-d205-ea98-096163a2296a@linux.ibm.com>
Date:   Wed, 23 Feb 2022 16:39:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, Pierre Morel <pmorel@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
 <20220223132940.2765217-7-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/8] s390x: Add more tests for STSCH
In-Reply-To: <20220223132940.2765217-7-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qH7Rnr0O8YUPwtdNISpEcZxOFT6eTXi4
X-Proofpoint-ORIG-GUID: CfmvwUomLHt-MYPSsksq6nsdxnvXqvAm
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_06,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/22 14:29, Nico Boehr wrote:
> css_lib extensively uses STSCH, but two more cases deserve their own
> tests:
> 
> - unaligned address for SCHIB. We check for misalignment by 1 and 2
>    bytes.
> - channel not operational
> - bit 47 in SID not set
> - bit 5 of PMCW flags.
>    As per the principles of operation, bit 5 of the PMCW flags shall be
>    ignored by msch and always stored as zero by stsch.
> 
>    Older QEMU versions require this bit to always be zero on msch,
>    which is why this test may fail. A fix is available in QEMU master
>    commit 2df59b73e086 ("s390x/css: fix PMCW invalid mask"). >
> Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/css.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 74 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index a90a0cd64e2b..021eb12573c0 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -496,6 +496,78 @@ static void test_ssch(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_stsch(void)
> +{
> +	const int align_to = 4;
> +	struct schib schib;
> +	int cc;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +
> +	report_prefix_push("Unaligned");
> +	for (int i = 1; i < align_to; i *= 2) {
> +		report_prefix_pushf("%d", i);
> +
> +		expect_pgm_int();
> +		stsch(test_device_sid, (struct schib *)(alignment_test_page + i));
> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	report_prefix_push("Invalid subchannel number");
> +	cc = stsch(0x0001ffff, &schib);
> +	report(cc == 3, "Channel not operational");
> +	report_prefix_pop();
> +
> +	report_prefix_push("Bit 47 in SID is zero");
> +	expect_pgm_int();
> +	stsch(0x0000ffff, &schib);
> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +	report_prefix_pop();

Add a comment:
No matter if the multiple-subchannel-set facility is installed or not, 
bit 47 always needs to be 1.

Do we have the MSS facility?
If yes, could we disable it to test the 32-47 == 0x0001 case?

> +}
> +
> +static void test_pmcw_bit5(void)
> +{
> +	int cc;
> +	uint16_t old_pmcw_flags;

I need a comment here for further reference since that behavior is 
documented at the description of the schib and not where STSCH is described:
According to architecture MSCH does ignore bit 5 of the second word but 
STSCH will store bit 5 as zero.


We could check if bits 0,1 and 6,7 are also zero but I'm not sure if 
that's interesting since MSCH does not ignore those bits and should 
result in an operand exception when trying to set them.

@Halil, @Pierre: Any opinions?

> +
> +	cc = stsch(test_device_sid, &schib);
> +	if (cc) {
> +		report_fail("stsch: sch %08x failed with cc=%d", test_device_sid, cc);
> +		return;
> +	}
> +	old_pmcw_flags = schib.pmcw.flags;
> +
> +	report_prefix_push("Bit 5 set");
> +
> +	schib.pmcw.flags = old_pmcw_flags | BIT(15 - 5);
> +	cc = msch(test_device_sid, &schib);
> +	report(!cc, "MSCH cc == 0");
> +
> +	cc = stsch(test_device_sid, &schib);
> +	report(!cc, "STSCH cc == 0");
> +	report(!(schib.pmcw.flags & BIT(15 - 5)), "STSCH PMCW Bit 5 is clear");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("Bit 5 clear");
> +
> +	schib.pmcw.flags = old_pmcw_flags & ~BIT(15 - 5);
> +	cc = msch(test_device_sid, &schib);
> +	report(!cc, "MSCH cc == 0");
> +
> +	cc = stsch(test_device_sid, &schib);
> +	report(!cc, "STSCH cc == 0");
> +	report(!(schib.pmcw.flags & BIT(15 - 5)), "STSCH PMCW Bit 5 is clear");
> +
> +	report_prefix_pop();
> +}
> +
>   static struct {
>   	const char *name;
>   	void (*func)(void);
> @@ -511,6 +583,8 @@ static struct {
>   	{ "msch", test_msch },
>   	{ "stcrw", test_stcrw },
>   	{ "ssch", test_ssch },
> +	{ "stsch", test_stsch },
> +	{ "pmcw bit 5 ignored", test_pmcw_bit5 },
>   	{ NULL, NULL }
>   };
>   

