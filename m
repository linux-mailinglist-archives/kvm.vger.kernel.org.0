Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0634C6E24
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 14:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiB1N2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 08:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiB1N2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 08:28:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2740D23BDC;
        Mon, 28 Feb 2022 05:27:37 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SCQH9U025635;
        Mon, 28 Feb 2022 13:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/He3bN6E9kDr8bKzYNahF/LLEQrdHBPWQroZed5tbCY=;
 b=tjJE85zpygpauzReEhEGD6B6H94bmI4SGlV6b6RYp9RZijcTY/W8j/1uB3agGtvhi92H
 wei8eOSbwgkpHIHk58QZEpaDJwCtCxb7RjZEL2JJ18idW5H/4+yuDRb7sJfUCnIay4zt
 ndc4fLdGP1pr3puphCjXgCDQ2r7lxZzihh/5wDVKBKlnyX+jwarnhJsZTUJqkZ7BzD8l
 f5R1DPtw7n7qj8MEvYquHbDYf4djJpxxy5Ym+ATM8gAUhU+8fj8d7dQBDO+CiJ6b/2Nb
 0qcHRxLA+s8KMFknhXLbgd8YvWuuvSzQqCjCk9JNBDMgrTYBfA5HGYrCbEfjqBWjGbQB QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3egxd9hej8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Feb 2022 13:27:36 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21SDQcCq000410;
        Mon, 28 Feb 2022 13:27:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3egxd9hehj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Feb 2022 13:27:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21SDHP64026198;
        Mon, 28 Feb 2022 13:27:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3efbu985j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Feb 2022 13:27:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21SDRUvY45678978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 13:27:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 945AAAE045;
        Mon, 28 Feb 2022 13:27:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 391CAAE051;
        Mon, 28 Feb 2022 13:27:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.37])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Feb 2022 13:27:30 +0000 (GMT)
Date:   Mon, 28 Feb 2022 14:27:27 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x: Add strict mode to specification
 exception interpretation test
Message-ID: <20220228142727.3542b767@p-imbrenda>
In-Reply-To: <20220225172355.3564546-1-scgl@linux.ibm.com>
References: <20220225172355.3564546-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eSovgeLlqCHIaFkvSuHtcBxRiKzhiAAI
X-Proofpoint-ORIG-GUID: 9NlXIyShuUcKc-Dc0iZdXgOHgGX5xW7j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_05,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Feb 2022 18:23:55 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> While specification exception interpretation is not required to occur,
> it can be useful for automatic regression testing to fail the test if it
> does not occur.
> Add a `--strict` argument to enable this.
> `--strict` takes a list of machine types (as reported by STIDP)
> for which to enable strict mode, for example
> `--strict 8562,8561,3907,3906,2965,2964`
> will enable it for models z15 - z13.
> Alternatively, strict mode can be enabled for all but the listed machine
> types by prefixing the list with a `!`, for example
> `--strict !1090,1091,2064,2066,2084,2086,2094,2096,2097,2098,2817,2818,2827,2828`
> will enable it for z/Architecture models except those older than z13.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---

[...]

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
> +	} else
> +		ret = false;
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

probably I should write a few parsing functions for command line
arguments, so we don't have to re-invent the wheel every time

> +
>  int main(int argc, char **argv)
>  {
>  	if (!sclp_facilities.has_sief2) {
> @@ -76,7 +121,7 @@ int main(int argc, char **argv)
>  		goto out;
>  	}
>  
> -	test_spec_ex_sie();
> +	test_spec_ex_sie(parse_strict(argc - 1, argv + 1));

hmmm... maybe it would be more readable and more uniform with the other
tests to parse the command line during initialization of the unit test,
and set a global flag.

>  out:
>  	return report_summary();
>  }
> 
> base-commit: 257c962f3d1b2d0534af59de4ad18764d734903a

