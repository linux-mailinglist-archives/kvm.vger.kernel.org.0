Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632F04ADBC5
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 15:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378959AbiBHO5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 09:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355010AbiBHO5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 09:57:21 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBE6C06157A;
        Tue,  8 Feb 2022 06:57:20 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218Epsk6024620;
        Tue, 8 Feb 2022 14:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aVqpSazcfSWp0HZsZ45GX1W5e/pDUprcfRunYvXNYns=;
 b=TlGd1BkeN/7VD9BAWi3WWQcGhGraebACZZ1h2R+LVvyudKoCSZTdIVlzhAulqgXpxPbk
 UD6hxfiHNLHEhni/TboEyTFIJm8uO/H2pi01M5DAjl9hmmTGnLUpC/0YiISLZlXGe6Fw
 gfPyGMcKQ2xop8pqF59UkLu60d3kpoCfMSKKZV6C9QZy783yFRZ9IO+enfzzlhHZfkr0
 tCRx5Q95XCWVowoyaMorbuzQIF71wP9YNvsR1palyzJzOiUndF1Zkr2DZo5lfW6urggF
 QcFj8pcy1FKRIAqiewoxnofQ1fCp5xoZhMrEM412DfPP6vSW68hsoH8GAXpSVFCuq90P BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3npsfraa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 14:57:19 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218ENPR7007772;
        Tue, 8 Feb 2022 14:57:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3npsfr9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 14:57:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218Er6IF021608;
        Tue, 8 Feb 2022 14:57:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv96uhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 14:57:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218El9cg42336520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 14:47:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08B00A405F;
        Tue,  8 Feb 2022 14:57:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B550EA405B;
        Tue,  8 Feb 2022 14:57:13 +0000 (GMT)
Received: from [9.145.70.126] (unknown [9.145.70.126])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 14:57:13 +0000 (GMT)
Message-ID: <0b28bd4b-cc4e-38a0-5cfe-c50c2bd70067@linux.ibm.com>
Date:   Tue, 8 Feb 2022 15:57:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v2 3/4] s390x: uv-guest: remove duplicated
 checks
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220203091935.2716-1-seiden@linux.ibm.com>
 <20220203091935.2716-4-seiden@linux.ibm.com>
 <20220203173143.57c488e5@p-imbrenda>
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20220203173143.57c488e5@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1U1ieDbc2IuDI7NFatrjC0_fEaBoIARl
X-Proofpoint-GUID: Emv5XLhwYoyYic0xGyPgiXMBcQPGLBXh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/3/22 17:31, Claudio Imbrenda wrote:
> On Thu,  3 Feb 2022 09:19:34 +0000
> Steffen Eiden <seiden@linux.ibm.com> wrote:
> 
>> Removing some tests which are done at other points in the code
>> implicitly.

[...]
>>
>> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
>> index 44ad2154..97ae4687 100644
>> --- a/s390x/uv-guest.c
>> +++ b/s390x/uv-guest.c
>> @@ -69,23 +69,15 @@ static void test_query(void)
>>   	cc = uv_call(0, (u64)&uvcb);
>>   	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
>>   
>> -	uvcb.header.len = sizeof(uvcb);
>> -	cc = uv_call(0, (u64)&uvcb);
>> -	report((!cc && uvcb.header.rc == UVC_RC_EXECUTED) ||
>> -	       (cc == 1 && uvcb.header.rc == 0x100),
>> -		"successful query");
>> -
> 
> ok fair enough, an unsuccessful query would have caused an assert in
> the setup code, but I don't think it hurts, and I think it would be
> nice to have for completeness.
>
Janosch explicitly asked me to remove this while I am editing uv_guest.

[...]

> 
> also, what happens if only one of the two bits is set? (which is very
> wrong). In that scenario, I would like this test to fail, not skip.
> this means that we can't rely on uv_os_is_guest to decide whether to
> skip this test.
>
That is true and a test if both bits are present xor none would be a 
great addition. However, if just one bit is set, uv_os_is_guest would
return false and this part will never be reached anyway.

I can add a test before the uv_os_is_guest fence to verify that both
xor none SHARED flags are set.

>>   	 */
>> -	report(test_bit_inv(BIT_UVC_CMD_QUI, &uvcb.inst_calls_list[0]),
>> -	       "query indicated");
>> -	report(test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
>> -	       "share indicated");
>> -	report(test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
>> -	       "unshare indicated");
>> +	report(uv_query_test_call(BIT_UVC_CMD_QUI), "query indicated");
>>   	report_prefix_pop();
>>   }
>>   
> 

Steffen
