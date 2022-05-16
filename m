Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3900F528849
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbiEPPQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245166AbiEPPQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:16:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF14D9F;
        Mon, 16 May 2022 08:16:04 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GE193Y025902;
        Mon, 16 May 2022 15:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AXqEYA7yUC9sSYp8uprmlHCfYlPXzPktPghqfKK2tF4=;
 b=mS1UJoD5NTeGsX4xO8p5yZwnGaeoKKI2GnAB0Y3j3dQgUxKSeaHe9tIGGo8exSEL3od9
 DlsFs+UriyBi1G9miLnDUM5bWWhyJybbijveBcexydNhOq4X99Cs6VcFdZziGi3sxNA8
 8V49zBKNOWCaowUB9n7JDXCz5nM4nGzIuikRz2RDKh6B/8dLbay+RpSBXqeDUfsTVr1w
 F0t9kzrAasqyOioIwM3Ji5ZrGsHVR/s313pt4lsqz9Ch4KgKNshfMCl4IPyBELs6eHAI
 tf6Dy4mzVeWLHSZDusng4E00tCc5cf4MbYEa7wV1RQ4liNC6UgKUDERqgCAnv5mcgWN6 DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3r0rsvjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:16:03 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GFEemb013927;
        Mon, 16 May 2022 15:16:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3r0rsvj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:16:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GFBWhu015366;
        Mon, 16 May 2022 15:16:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429awf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:16:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GFFwH548365880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 15:15:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6013E4C04A;
        Mon, 16 May 2022 15:15:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F06A14C040;
        Mon, 16 May 2022 15:15:57 +0000 (GMT)
Received: from [9.145.154.60] (unknown [9.145.154.60])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 15:15:57 +0000 (GMT)
Message-ID: <9ed77ba2-034a-0278-1416-1b71b9454d8d@linux.ibm.com>
Date:   Mon, 16 May 2022 17:15:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 2/6] s390x: uv-host: Add uninitialized UV
 tests
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220513095017.16301-1-frankja@linux.ibm.com>
 <20220513095017.16301-3-frankja@linux.ibm.com>
 <a78d4b62-87a9-3095-b7bb-0d333a4657b2@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <a78d4b62-87a9-3095-b7bb-0d333a4657b2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -hkeLRxNE3-HdSwmeWWzbG5jUpCXQFDG
X-Proofpoint-GUID: mOZgGlEM_EF_rmMBuCfAyjzI1OzORYFK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_14,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205160086
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/22 17:02, Steffen Eiden wrote:
> 
> 
> On 5/13/22 11:50, Janosch Frank wrote:
>> Let's also test for rc 0x3
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> I, however, have some nits below.
> 
>> ---
>>    s390x/uv-host.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++--
>>    1 file changed, 76 insertions(+), 2 deletions(-)
>>
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index 0f0b18a1..f846fc42 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -83,6 +83,24 @@ static void test_priv(void)
>>    	report_prefix_pop();
>>    }
>>    
>> +static void test_uv_uninitialized(void)
>> +{
>> +	struct uv_cb_header uvcb = {};
>> +	int i;
>> +
>> +	report_prefix_push("uninitialized");
>> +
>> +	/* i = 1 to skip over initialize */
>> +	for (i = 1; cmds[i].name; i++) {
>> +		expect_pgm_int();
>> +		uvcb.cmd = cmds[i].cmd;
>> +		uvcb.len = cmds[i].len;
>> +		uv_call_once(0, (uint64_t)&uvcb);
>> +		report(uvcb.rc == UVC_RC_INV_STATE, "%s", cmds[i].name);
>> +	}
>> +	report_prefix_pop();
>> +}
>> +
>>    static void test_config_destroy(void)
>>    {
>>    	int rc;
>> @@ -477,13 +495,68 @@ static void test_invalid(void)
>>    	report_prefix_pop();
>>    }
>>    
>> +static void test_clear_setup(void)
> maybe rename this to setup_test_clear(void)
> I initially mistook this function as a test and not a setup function for
> a test

Sure

> 
>> +{
>> +	unsigned long vsize;
>> +	int rc;
>> +
[...]
>>    static void setup_vmem(void)
>> @@ -514,6 +587,7 @@ int main(void)
>>    
>>    	test_priv();
>>    	test_invalid();
>> +	test_uv_uninitialized();
>>    	test_query();
>>    	test_init();
> IIRC this test must be done last, as a following test has an
> uninitialized UV. Maybe add a short comment for that here.

You're referring to the test_init()?

The test_clear() function must be done last but you're commenting under 
the test_init() call. So I'm a bit confused about what you want me to do 
here.

>>    
> 

