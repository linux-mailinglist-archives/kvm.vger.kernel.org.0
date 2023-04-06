Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA98C6D9100
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 10:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbjDFIBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 04:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbjDFIBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 04:01:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E029D13E;
        Thu,  6 Apr 2023 01:01:30 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3367TkoP027539;
        Thu, 6 Apr 2023 08:01:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O3mKm+YBoQnUmHgmzoSVfv5LTZzgdSjEwPou7UCR0Q4=;
 b=M4w2D128wjtODR6bmZdz3DFLOCKX4RyF5dp+ohRBLg+xYzNKwkhbvLYGklxFnog4aXwx
 FJuliK+/iG/oDe7K+j2x6vxCeRxNJGAKt63vjx54BeOzkNiU9A2NXiC1avL3H3iTbkqA
 LVu7KIdxBfzIr43UP5qlqWaqTuonOSC0RYtkEG2lsYTuuFHgA+ByGE2JalwrjZg2QwBG
 gcIKdahPTgzwxcsL6DcPeE+d0l0aQfPeaPELgoWPKrFaYZci33fOBOWeJZ2rY8KgnJQ/
 1S1eZx0ssC3sQ8pv3pY/SpMZpR0gDXsDhXMwYbcmHX1aWha1I9nvuL+kncPZCOYsiDB2 fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps75k3b8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 08:01:30 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3367u59N021257;
        Thu, 6 Apr 2023 08:01:29 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps75k3b67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 08:01:29 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3365P6J1022079;
        Thu, 6 Apr 2023 08:01:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ppbvfu2ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 08:01:26 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33681NZ46029876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Apr 2023 08:01:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25E942004B;
        Thu,  6 Apr 2023 08:01:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2A8420040;
        Thu,  6 Apr 2023 08:01:22 +0000 (GMT)
Received: from [9.179.16.135] (unknown [9.179.16.135])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  6 Apr 2023 08:01:22 +0000 (GMT)
Message-ID: <5770ea2b-2cf2-a57e-2003-fb043b0bea9c@linux.ibm.com>
Date:   Thu, 6 Apr 2023 10:01:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230327082118.2177-1-nrb@linux.ibm.com>
 <20230327082118.2177-5-nrb@linux.ibm.com>
 <cfd83c1d7a74e969e6e3c922bbe5650f8e9adadd.camel@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add a test for SIE without
 MSO/MSL
In-Reply-To: <cfd83c1d7a74e969e6e3c922bbe5650f8e9adadd.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ExmmPkX-EyUgeK7qSuSAXVkZVfXSsRCp
X-Proofpoint-ORIG-GUID: i8Pf3VzXhEgh6oGPxwyC055NawIxh5po
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_02,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304060071
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 21:55, Nina Schoetterl-Glausch wrote:
> On Mon, 2023-03-27 at 10:21 +0200, Nico Boehr wrote:
>> Since we now have the ability to run guests without MSO/MSL, add a test
>> to make sure this doesn't break.
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---

[...]

>> +static inline void force_exit_value(uint64_t val)
>> +{
>> +	asm volatile(
>> +		"	diag	%[val],0,0x9c\n"
>> +		: : [val] "d"(val)
>> +	);
>> +}
>> +
>> +__attribute__((section(".text"))) int main(void)
> 
> Why is the attribute necessary? I know all the snippets have it, but I don't see
> why it's necessary.
> @Janosch ?

"Historical growth" :)

If it doesn't work without it then we need to find a way to fix it.
If it does work without it then we should remove the attribute from all 
snippets.

But this issue is a low priority for me.

> 
>> +{
>> +	uint8_t *invalid_ptr;
>> +
>> +	memset(test_page, 0, sizeof(test_page));
>> +	/* tell the host the page's physical address (we're running DAT off) */
>> +	force_exit_value((uint64_t)test_page);
>> +
>> +	/* write some value to the page so the host can verify it */
>> +	for (size_t i = 0; i < TEST_PAGE_COUNT; i++)
>> +		test_page[i * PAGE_SIZE] = 42 + i;
>> +
>> +	/* indicate we've written all pages */
>> +	force_exit();
>> +
>> +	/* the first unmapped address */
>> +	invalid_ptr = (uint8_t *)(TOTAL_PAGE_COUNT * PAGE_SIZE);
> 
> Why not just use an address high enough you know it will not be mapped?
> -1 should do just fine.
> 
>> +	*invalid_ptr = 42;
>> +
>> +	/* indicate we've written the non-allowed page (should never get here) */
>> +	force_exit();
>> +
>> +	return 0;
>> +}
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index d97eb5e943c8..aab0e670f2d4 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -215,3 +215,6 @@ file = migration-skey.elf
>>   smp = 2
>>   groups = migration
>>   extra_params = -append '--parallel'
>> +
>> +[sie-dat]
>> +file = sie-dat.elf
> 

