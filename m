Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B261B4CBA86
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 10:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiCCJoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 04:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiCCJoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 04:44:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53414BD2CC;
        Thu,  3 Mar 2022 01:43:12 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2238s8po025287;
        Thu, 3 Mar 2022 09:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=t7rA9v4DZYDLzxJsqjcTKKSN1Ami6KPsKX0/vnvXfJI=;
 b=jO7yQorlNetRAkFl4AXWuWiZY+0RszMC79dz9z2T6b5l6iBHIEPsPpDGufMeX9EnMYRR
 mMI0KszXaOJLhabLttAFoGwV7s727D9xbJJpM1PQDblVph+K9K9uAdId3HtOXh7+cNLJ
 aPGOW8OnOWYlRzBOfS/Q22PHU2k6Chu+OmW0ouaB1ZSNBrWdpsIp5zOhKxUpZYpxvPYW
 FFejE0lw5wvy+TOqpPQ1eWV4KxlwKyQkcxiCYArW+EgFNb4EX2ZZOW5xv2o1X1b90VRl
 ZM38yUSWdyR7HgO19xAo1cRSw3ZTFlrOrT1A2Db1eMNnazw1Iv3o2yGyxAfR2goZasEa ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejtjery2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 09:43:11 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2238wGHg002023;
        Thu, 3 Mar 2022 09:43:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejtjery20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 09:43:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2239arKg006158;
        Thu, 3 Mar 2022 09:43:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3efbu9hctj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 09:43:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2239h68N48628070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 09:43:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE618A404D;
        Thu,  3 Mar 2022 09:43:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A256A4053;
        Thu,  3 Mar 2022 09:43:05 +0000 (GMT)
Received: from [9.171.78.253] (unknown [9.171.78.253])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Mar 2022 09:43:05 +0000 (GMT)
Message-ID: <7dc2517d-c276-3a3b-bdec-b67bb5b5fd26@linux.ibm.com>
Date:   Thu, 3 Mar 2022 10:43:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH] s390x: Add strict mode to specification
 exception interpretation test
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220225172355.3564546-1-scgl@linux.ibm.com>
 <20220228142727.3542b767@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220228142727.3542b767@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KLaSW5fkQoKuCaG-AgI2_ozh8nEfjLUX
X-Proofpoint-ORIG-GUID: 2hx29klymdm1TxPvPa02oyHq7awmt3RH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_06,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/28/22 14:27, Claudio Imbrenda wrote:
> On Fri, 25 Feb 2022 18:23:55 +0100
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> While specification exception interpretation is not required to occur,
>> it can be useful for automatic regression testing to fail the test if it
>> does not occur.
>> Add a `--strict` argument to enable this.
>> `--strict` takes a list of machine types (as reported by STIDP)
>> for which to enable strict mode, for example
>> `--strict 8562,8561,3907,3906,2965,2964`
>> will enable it for models z15 - z13.
>> Alternatively, strict mode can be enabled for all but the listed machine
>> types by prefixing the list with a `!`, for example
>> `--strict !1090,1091,2064,2066,2084,2086,2094,2096,2097,2098,2817,2818,2827,2828`
>> will enable it for z/Architecture models except those older than z13.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
> 
> [...]
> 
>> +static bool parse_strict(int argc, char **argv)
>> +{
>> +	uint16_t machine_id;
>> +	char *list;
>> +	bool ret;
>> +
>> +	if (argc < 1)
>> +		return false;
>> +	if (strcmp("--strict", argv[0]))
>> +		return false;
>> +
>> +	machine_id = get_machine_id();
>> +	if (argc < 2) {
>> +		printf("No argument to --strict, ignoring\n");
>> +		return false;
>> +	}
>> +	list = argv[1];
>> +	if (list[0] == '!') {
>> +		ret = true;
>> +		list++;
>> +	} else
>> +		ret = false;
>> +	while (true) {
>> +		long input = 0;
>> +
>> +		if (strlen(list) == 0)
>> +			return ret;
>> +		input = strtol(list, &list, 16);
>> +		if (*list == ',')
>> +			list++;
>> +		else if (*list != '\0')
>> +			break;
>> +		if (input == machine_id)
>> +			return !ret;
>> +	}
>> +	printf("Invalid --strict argument \"%s\", ignoring\n", list);
>> +	return ret;
>> +}
> 
> probably I should write a few parsing functions for command line
> arguments, so we don't have to re-invent the wheel every time

Maybe, would depend on what you have in mind, I'm not sure most
use cases can be covered by a reasonable set of abstractions.
> 
>> +
>>  int main(int argc, char **argv)
>>  {
>>  	if (!sclp_facilities.has_sief2) {
>> @@ -76,7 +121,7 @@ int main(int argc, char **argv)
>>  		goto out;
>>  	}
>>  
>> -	test_spec_ex_sie();
>> +	test_spec_ex_sie(parse_strict(argc - 1, argv + 1));
> 
> hmmm... maybe it would be more readable and more uniform with the other
> tests to parse the command line during initialization of the unit test,
> and set a global flag.

More uniform maybe, but I tend to dislike globals from a readability point
of view. I'm inclined to keep it as is.
> 
>>  out:
>>  	return report_summary();
>>  }
>>
>> base-commit: 257c962f3d1b2d0534af59de4ad18764d734903a
> 

