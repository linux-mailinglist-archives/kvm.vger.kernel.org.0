Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD65A1362
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 16:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiHYOWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 10:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiHYOWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 10:22:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71919ADCF9;
        Thu, 25 Aug 2022 07:22:36 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PE69rC010819;
        Thu, 25 Aug 2022 14:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qWJPfKXf4ME1eqZxch0TD1ItaXw5xpQVwjcPKbSQhiI=;
 b=sgVaPY6xL2j+pu/SphiS82eRSkDQpJC4KXCNhNvaxsokUIDbJ47Uh1a7bisJn+n7ttgv
 0GUPsWpKEsGNFWKh3ZV4GxV3M5bsTLCZwuFyOLb8s/u4fXdPZwm1pQgR01VbjZHoaw4W
 ba5cO4kMjkUScvVdXNk8KmuuZs7lBWHTY5DBWtd0PQ02TCkxyNYz/cYpXTGjsqkajp+U
 0WvGzdy+OeqEFYDFy7txq4v1XTH8yL+TmXE/Lk59BFgjZwWY3wbFpRjcqQVcR07x6rKu
 wSElBULNj2gjBfOewqH5EIevkT1CZwR1y5gNBwRU/kzIbSpjBOtRepA6M/aKFytS46bs wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6ahvgmcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 14:22:35 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27PE6apf012799;
        Thu, 25 Aug 2022 14:22:34 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6ahvgmbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 14:22:34 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PELkgJ000435;
        Thu, 25 Aug 2022 14:22:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3j2q89csrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 14:22:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PEMTrX39125320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 14:22:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B74B5204F;
        Thu, 25 Aug 2022 14:22:29 +0000 (GMT)
Received: from [9.145.149.19] (unknown [9.145.149.19])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E47A35204E;
        Thu, 25 Aug 2022 14:22:28 +0000 (GMT)
Message-ID: <aeea0f64-2140-c060-1858-bca9b0350ad4@linux.ibm.com>
Date:   Thu, 25 Aug 2022 16:22:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v4] s390x: Add strict mode to specification
 exception interpretation test
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220825112047.2206929-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220825112047.2206929-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jQatkDx2moL6UFkanphZ5slYOiGST5Yd
X-Proofpoint-GUID: bKituHFUzRM0KdYTH1Tyufzc_T2Lit78
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208250053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/22 13:20, Janis Schoetterl-Glausch wrote:
> While specification exception interpretation is not required to occur,
> it can be useful for automatic regression testing to fail the test if it
> does not occur.
> Add a `--strict` argument to enable this.
> `--strict` takes a list of machine types (as reported by STIDP)
> for which to enable strict mode, for example
> `--strict 3931,8562,8561,3907,3906,2965,2964`
> will enable it for models z16 - z13.
> Alternatively, strict mode can be enabled for all but the listed machine
> types by prefixing the list with a `!`, for example
> `--strict !1090,1091,2064,2066,2084,2086,2094,2096,2097,2098,2817,2818,2827,2828`
> will enable it for z/Architecture models except those older than z13.
> `--strict !` will enable it always.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks, picked

> ---
> v3 -> v4
>   * fix compiler warning due to format string (thanks Janosch)
>       see range diff below
>   * add R-b (thanks Thomas)
> 
> v2 -> v3
>   * rebase on master
>   * global strict bool
>   * fix style issue
> 
> Range-diff against v3:
> 1:  76199f42 ! 1:  ef697f15 s390x: Add strict mode to specification exception interpretation test
>      @@ Commit message
>           `--strict !` will enable it always.
>       
>           Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>      +    Reviewed-by: Thomas Huth <thuth@redhat.com>
>       
>        ## s390x/spec_ex-sie.c ##
>       @@
>      @@ s390x/spec_ex-sie.c: static void test_spec_ex_sie(void)
>       -		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
>       +	msg = "Interpreted initial exception, intercepted invalid program new PSW exception";
>       +	if (strict)
>      -+		report(vm.sblk->gpsw.addr == 0xdeadbeee, msg);
>      ++		report(vm.sblk->gpsw.addr == 0xdeadbeee, "%s", msg);
>       +	else if (vm.sblk->gpsw.addr == 0xdeadbeee)
>      -+		report_info(msg);
>      ++		report_info("%s", msg);
>        	else
>        		report_info("Did not interpret initial exception");
>        	report_prefix_pop();
> 
>   s390x/spec_ex-sie.c | 53 +++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
> index d8e25e75..5fa135b8 100644
> --- a/s390x/spec_ex-sie.c
> +++ b/s390x/spec_ex-sie.c
> @@ -7,16 +7,19 @@
>    * specification exception interpretation is off/on.
>    */
>   #include <libcflat.h>
> +#include <stdlib.h>
>   #include <sclp.h>
>   #include <asm/page.h>
>   #include <asm/arch_def.h>
>   #include <alloc_page.h>
>   #include <sie.h>
>   #include <snippet.h>
> +#include <hardware.h>
>   
>   static struct vm vm;
>   extern const char SNIPPET_NAME_START(c, spec_ex)[];
>   extern const char SNIPPET_NAME_END(c, spec_ex)[];
> +static bool strict;
>   
>   static void setup_guest(void)
>   {
> @@ -37,6 +40,8 @@ static void reset_guest(void)
>   
>   static void test_spec_ex_sie(void)
>   {
> +	const char *msg;
> +
>   	setup_guest();
>   
>   	report_prefix_push("SIE spec ex interpretation");
> @@ -60,16 +65,60 @@ static void test_spec_ex_sie(void)
>   	report(vm.sblk->icptcode == ICPT_PROGI
>   	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
>   	       "Received specification exception intercept");
> -	if (vm.sblk->gpsw.addr == 0xdeadbeee)
> -		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
> +	msg = "Interpreted initial exception, intercepted invalid program new PSW exception";
> +	if (strict)
> +		report(vm.sblk->gpsw.addr == 0xdeadbeee, "%s", msg);
> +	else if (vm.sblk->gpsw.addr == 0xdeadbeee)
> +		report_info("%s", msg);
>   	else
>   		report_info("Did not interpret initial exception");
>   	report_prefix_pop();
>   	report_prefix_pop();
>   }
>   
> +static bool parse_strict(int argc, char **argv)
> +{
> +	uint16_t machine_id;
> +	char *list;
> +	bool ret;
> +
> +	if (argc < 1)
> +		return false;
> +	if (strcmp("--strict", argv[0]))
> +		return false;
> +
> +	machine_id = get_machine_id();
> +	if (argc < 2) {
> +		printf("No argument to --strict, ignoring\n");
> +		return false;
> +	}
> +	list = argv[1];
> +	if (list[0] == '!') {
> +		ret = true;
> +		list++;
> +	} else {
> +		ret = false;
> +	}
> +	while (true) {
> +		long input = 0;
> +
> +		if (strlen(list) == 0)
> +			return ret;
> +		input = strtol(list, &list, 16);
> +		if (*list == ',')
> +			list++;
> +		else if (*list != '\0')
> +			break;
> +		if (input == machine_id)
> +			return !ret;
> +	}
> +	printf("Invalid --strict argument \"%s\", ignoring\n", list);
> +	return ret;
> +}
> +
>   int main(int argc, char **argv)
>   {
> +	strict = parse_strict(argc - 1, argv + 1);
>   	if (!sclp_facilities.has_sief2) {
>   		report_skip("SIEF2 facility unavailable");
>   		goto out;
> 
> base-commit: ca85dda2671e88d34acfbca6de48a9ab32b1810d

