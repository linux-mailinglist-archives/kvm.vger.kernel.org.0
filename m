Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A876EC7DD
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 10:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjDXI0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 04:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjDXI0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 04:26:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B013C1FDE;
        Mon, 24 Apr 2023 01:26:44 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33O881J5031746;
        Mon, 24 Apr 2023 08:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nRSSeQirtkgqO+2p1ZoyB4SgUPLxJ3FeTzEyC/i/Hds=;
 b=d6JtZpGOkgrP5HuB/H5LDCC33p28LcTmX2a4MH3lcJ1pJUEmNvBvKQTwFH/SCt6Zde/5
 jOEVNRdtr+9HS10z/iCPKbjkrln+Mgnp0x5GqeLuzCAXWp0HdznI1TzWOFhpltfM752w
 RV2HN2ojbPwdLpZREMixQqwoAPiBS2bltxUYv6qrfbC8F/EJETGdV2fmcu9nlXJ92viA
 xFfK1z05+nm1EtCSrDdoo7jvIm7cteCz3USnhJzR/HNCfr5ZWX+7ef3WrwuGWGUvVD0Q
 vQAfvD0nsPEFJUOxb0VEF6cNXFjITkFIxi6wiuc1G2lyelKVKO3k2MoGmxiSo65nP5KY Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q461bum5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 08:26:43 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33O88srN007328;
        Mon, 24 Apr 2023 08:26:43 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q461bum53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 08:26:43 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33O1tGLX013474;
        Mon, 24 Apr 2023 08:26:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3q46ug0tq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 08:26:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33O8QbYu22151694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 08:26:37 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD51D2004B;
        Mon, 24 Apr 2023 08:26:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5701C20043;
        Mon, 24 Apr 2023 08:26:37 +0000 (GMT)
Received: from [9.171.17.179] (unknown [9.171.17.179])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Apr 2023 08:26:37 +0000 (GMT)
Message-ID: <7b6b05b8-5c07-69b5-dbd0-f1f5e48ecd9a@linux.ibm.com>
Date:   Mon, 24 Apr 2023 10:26:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        nrb@linux.ibm.com, david@redhat.com
References: <20230421113647.134536-1-frankja@linux.ibm.com>
 <20230421113647.134536-5-frankja@linux.ibm.com>
 <20230421161353.2dfaea97@p-imbrenda>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/7] lib: s390x: uv: Add pv guest
 requirement check function
In-Reply-To: <20230421161353.2dfaea97@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xrVfc83ZRRjaJi890rtnV1IeJxyLgrVj
X-Proofpoint-ORIG-GUID: aRhycZGe9zmyjde-wm2Q83jVVOmy--2L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_04,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304240073
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/23 16:13, Claudio Imbrenda wrote:
> On Fri, 21 Apr 2023 11:36:44 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> When running PV guests some of the UV memory needs to be allocated
>> with > 31 bit addresses which means tests with PV guests will always
>> need a lot more memory than other tests.
>> Additionally facilities nr 158 and sclp.sief2 need to be available.
>>
>> Let's add a function that checks for these requirements and prints a
>> helpful skip message.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/snippet.h |  7 +++++++
>>   lib/s390x/uv.c      | 20 ++++++++++++++++++++
>>   lib/s390x/uv.h      |  1 +
>>   s390x/pv-diags.c    |  8 +-------
>>   4 files changed, 29 insertions(+), 7 deletions(-)
>>
>> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
>> index 57045994..11ec54c3 100644
>> --- a/lib/s390x/snippet.h
>> +++ b/lib/s390x/snippet.h
>> @@ -30,6 +30,13 @@
>>   #define SNIPPET_HDR_LEN(type, file) \
>>   	((uintptr_t)SNIPPET_HDR_END(type, file) - (uintptr_t)SNIPPET_HDR_START(type, file))
>>   
>> +/*
>> + * Some of the UV memory needs to be allocated with >31 bit
>> + * addresses which means we need a lot more memory than other
>> + * tests.
>> + */
>> +#define SNIPPET_PV_MIN_MEM_SIZE	(SZ_1M * 2200UL)
>> +
>>   #define SNIPPET_PV_TWEAK0	0x42UL
>>   #define SNIPPET_PV_TWEAK1	0UL
>>   #define SNIPPET_UNPACK_OFF	0
>> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
>> index 383271a5..db47536c 100644
>> --- a/lib/s390x/uv.c
>> +++ b/lib/s390x/uv.c
>> @@ -18,6 +18,7 @@
>>   #include <asm/uv.h>
>>   #include <uv.h>
>>   #include <sie.h>
>> +#include <snippet.h>
>>   
>>   static struct uv_cb_qui uvcb_qui = {
>>   	.header.cmd = UVC_CMD_QUI,
>> @@ -38,6 +39,25 @@ bool uv_os_is_host(void)
>>   	return test_facility(158) && uv_query_test_call(BIT_UVC_CMD_INIT_UV);
>>   }
>>   
>> +bool uv_guest_requirement_checks(void)
> 
> I would call it uv_host_requirement_checks since it will run on the
> host to check if the host meets certain requirements

Sure
If someone has a shorter suggestion I'd also be happy to hear it.

> 
>> +{
>> +	if (!test_facility(158)) {
>> +		report_skip("UV Call facility unavailable");
>> +		return false;
>> +	}
>> +	if (!sclp_facilities.has_sief2) {
>> +		report_skip("SIEF2 facility unavailable");
>> +		return false;
>> +	}
>> +	if (get_ram_size() < SNIPPET_PV_MIN_MEM_SIZE) {
>> +		report_skip("Not enough memory. This test needs about %ld MB of memory",
>> +			    SNIPPET_PV_MIN_MEM_SIZE / 1024 / 1024);
> 
> a better way to do this would be to check the amount of memory needed
> by the Ultravisor and check if that size + 2GB is available
> 
> of course in that case unittest.cfg would also need to be adjusted

Could do, but in this case I opted for simplicity.

