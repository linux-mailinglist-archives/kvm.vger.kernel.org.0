Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9619341816
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhCSJTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:19:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229640AbhCSJSc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:18:32 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12J94NuU162474
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8GsSwk0U/fcNVSq1NXjY7nvVX8Yns2e+ZPco8efGiFQ=;
 b=mWMBr4Jebx3lxhIwLxUD7gDM6q5hlHbUuiBkoZUFuImUp0kC160dcyVpAdAtHSWhTWfz
 0pHi0A8SmHfS9OQsJLp474qrAClnPvnTTKQ478JTbSG3NmRFXN8CLW8ZuW3oaIaNc3X9
 ABZGqB6bSRfyP/yKCAYxbEP1YGsUyK5iZQmbwM/t48GXj7outgai6Or0aufT3WeGTYfg
 YQGa+oyfyC0TgVLUL+2Ud6uq7ntp0x/T4uCeH4bkwrlqOt24xJKw0xfRO70DL5/iWicJ
 9whYTAxChfTKTF7G+KvG2TldkgzQjQZpC+brL77sfNaVCDXqK9NoamwsXRhZo5ffnaLo BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c302wefa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:18:32 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12J952Y6164649
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:18:32 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c302weem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 05:18:32 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12J97vDI006519;
        Fri, 19 Mar 2021 09:18:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 378mnhaxtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 09:18:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12J9I9oc33489312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 09:18:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E307052052;
        Fri, 19 Mar 2021 09:18:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.32.248])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 855325204E;
        Fri, 19 Mar 2021 09:18:26 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-6-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 5/6] s390x: css: testing ssch error
 response
Message-ID: <201e476c-a014-55f6-b4d0-ff2c1d429c42@linux.ibm.com>
Date:   Fri, 19 Mar 2021 10:18:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616073988-10381-6-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_03:2021-03-17,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/18/21 2:26 PM, Pierre Morel wrote:
> Checking error response on various eroneous SSCH instructions:
> - ORB alignment
> - ORB above 2G
> - CCW above 2G
> - bad ORB flags
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 102 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index a6a9773..1c891f8 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -51,6 +51,107 @@ static void test_enable(void)
>  	report(cc == 0, "Enable subchannel %08x", test_device_sid);
>  }
>  
> +static void test_ssch(void)
> +{
> +	struct orb orb = {
> +		.intparm = test_device_sid,
> +		.ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT,
> +	};
> +	int i;
> +	phys_addr_t base, top;
> +
> +	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
> +	assert(register_io_int_func(css_irq_io) == 0);
> +
> +	/* ORB address should be aligned on 32 bits */
> +	report_prefix_push("ORB alignment");
> +	expect_pgm_int();
> +	ssch(test_device_sid, (void *)0x110002);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	/* ORB address should be lower than 2G */
> +	report_prefix_push("ORB Address above 2G");
> +	expect_pgm_int();
> +	ssch(test_device_sid, (void *)0x80000000);
> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +	report_prefix_pop();
> +
> +	phys_alloc_get_unused(&base, &top);
> +	report_info("base %08lx, top %08lx", base, top);

Please use this function from lib/s390x/sclp.c

uint64_t get_ram_size(void)
{
        return ram_size;
}

> +
> +	/* ORB address should be available we check 1G*/
> +	report_prefix_push("ORB Address must be available");
> +	if (top < 0x40000000) {
> +		expect_pgm_int();
> +		ssch(test_device_sid, (void *)0x40000000);
> +		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +	} else {
> +		report_skip("guest started with more than 1G memory");
> +	}
> +	report_prefix_pop();
> +
> +	report_prefix_push("CCW address above 2G");
> +	orb.cpa = 0x80000000;
> +	expect_pgm_int();
> +	ssch(test_device_sid, &orb);
> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +	report_prefix_pop();
> +
> +	senseid = alloc_io_mem(sizeof(*senseid), 0);
> +	assert(senseid);
> +	orb.cpa = (uint64_t)ccw_alloc(CCW_CMD_SENSE_ID, senseid,
> +				      sizeof(*senseid), CCW_F_SLI);
> +	assert(orb.cpa);
> +
> +	report_prefix_push("Disabled subchannel");
> +	assert(css_disable(test_device_sid) == 0);
> +	report(ssch(test_device_sid, &orb) == 3, "CC = 3");
> +	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
> +	report_prefix_pop();
> +
> +	/*
> +	 * Check sending a second SSCH before clearing the status with TSCH
> +	 * the subchannel is left disabled.

If a second SSCH is sent before clearing via TSCH the subchannel is
disabled by firmware? Did I get that right?

> +	 */
> +	report_prefix_push("SSCH on channel with status pending");
> +	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
> +	assert(ssch(test_device_sid, &orb) == 0);
> +	report(ssch(test_device_sid, &orb) == 1, "CC = 1");
> +	/* now we clear the status */
> +	assert(wait_and_check_io_completion(test_device_sid, SCSW_FC_START) == 0);
> +	assert(css_disable(test_device_sid) == 0);
> +	report_prefix_pop();
> +
> +	report_prefix_push("ORB MIDAW unsupported");
> +	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
> +	orb.ctrl |= ORB_CTRL_MIDAW;
> +	expect_pgm_int();
> +	ssch(test_device_sid, &orb);
> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +	report_prefix_pop();
> +	orb.ctrl = 0;
> +
> +	for (i = 0; i < 5; i++) {
> +		char buffer[30];
> +
> +		orb.ctrl = (0x02 << i);
> +		snprintf(buffer, 30, "ORB reserved ctrl flags %02x", orb.ctrl);
> +		report_prefix_push(buffer);
> +		expect_pgm_int();
> +		ssch(test_device_sid, &orb);
> +		check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +		report_prefix_pop();
> +	}
> +
> +	report_prefix_push("ORB wrong ctrl flags");
> +	orb.ctrl |= 0x040000;
> +	expect_pgm_int();
> +	ssch(test_device_sid, &orb);
> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +	report_prefix_pop();
> +}
> +
>  /*
>   * test_sense
>   * Pre-requisites:
> @@ -339,6 +440,7 @@ static struct {
>  	{ "initialize CSS (chsc)", css_init },
>  	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
> +	{ "start subchannel", test_ssch },
>  	{ "sense (ssch/tsch)", test_sense },
>  	{ "measurement block (schm)", test_schm },
>  	{ "measurement block format0", test_schm_fmt0 },
> 

