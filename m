Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7749569D33
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 10:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiGGITA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 04:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbiGGISE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 04:18:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DCA32EF0;
        Thu,  7 Jul 2022 01:16:51 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2678C16Z003607;
        Thu, 7 Jul 2022 08:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=huLa6BBmIJqqnkXB6gz8rthVwcy/GkzaeAXZsM2Mtrc=;
 b=pzrvhtoeX51s5CggSTnzeWIIz23PnzXWd5M6PaCOMAuXQ1woCTASAP/eF2tCYWMtbxRx
 UJXZ0EK+ww2bLvSaa18tiMjAnkTa7MAHOhT9endjAuNYJCT1dC3CwUClAfyNprKfxlwK
 RpB3/KEsX8LdWCE90pCGZo/2Cvq7awOTbkiqk0NX5WkcfuZK4j+XD89wwZdsAqZTh9d9
 jLcZZR0qZltLRhPHnP6s6VJWqOquUmRvwBoXgmPG/THN7Wkk6lWY68/Y2LpYe8dRUv31
 J4yQ911Zrk1ntDsZ89syf3DQr9ARiwIeyl3k6U3Wh6eYh3+fu3++De9r+FM+tPwT/Ib5 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5ury044q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:16:51 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2678Cn4t005617;
        Thu, 7 Jul 2022 08:16:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5ury043v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:16:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26785u2c011427;
        Thu, 7 Jul 2022 08:16:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3h4v4jt8ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:16:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2678GjPP20578606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 08:16:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BC1511C04C;
        Thu,  7 Jul 2022 08:16:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDCC011C04A;
        Thu,  7 Jul 2022 08:16:44 +0000 (GMT)
Received: from [9.145.178.7] (unknown [9.145.178.7])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jul 2022 08:16:44 +0000 (GMT)
Message-ID: <f471d1a8-54b7-b858-1324-c62d0d20623c@linux.ibm.com>
Date:   Thu, 7 Jul 2022 10:16:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: uv-host: Add access checks
 for donated memory
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220706064024.16573-1-frankja@linux.ibm.com>
 <20220706064024.16573-2-frankja@linux.ibm.com>
 <20220706183346.2a027e8b@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220706183346.2a027e8b@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gN-JG6IymdFSXArNkdzxwPdUvmWKiE0D
X-Proofpoint-GUID: CaYVEnbnFUAdwkbhHgyds2G89gN-2Z4j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/22 18:33, Claudio Imbrenda wrote:
> On Wed,  6 Jul 2022 06:40:17 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Let's check if the UV really protected all the memory we donated.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   s390x/uv-host.c | 29 +++++++++++++++++++++++++++++
>>   1 file changed, 29 insertions(+)
>>
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index a1a6d120..983cb4a1 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -43,6 +43,24 @@ static void cpu_loop(void)
>>   	for (;;) {}
>>   }
>>   
>> +/*
>> + * Checks if a memory area is protected as secure memory.
>> + * Will return true if all pages are protected, false otherwise.
>> + */
>> +static bool access_check_3d(uint64_t *access_ptr, uint64_t len)
>> +{
>> +	while (len) {
>> +		expect_pgm_int();
>> +		*access_ptr += 42;
> 
> I'm surprised this works, you will get an (expected) exception when
> reading from the pointer, and then you should get another one (at this
> point unexpected) when writing
> 

Let me introduce you to "AGSI" add grand storage immediate.
But I get your point, inline assembly would make this much more explicit.

>> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
>> +			return false;
>> +		access_ptr += PAGE_SIZE / sizeof(access_ptr);
>> +		len -= PAGE_SIZE;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>   static struct cmd_list cmds[] = {
>>   	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
>>   	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
>> @@ -194,6 +212,10 @@ static void test_cpu_create(void)
>>   	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
>>   	       uvcb_csc.cpu_handle, "success");
>>   
>> +	rc = access_check_3d((uint64_t *)uvcb_csc.stor_origin,
>> +			     uvcb_qui.cpu_stor_len);
>> +	report(rc, "Storage protection");
>> +
>>   	tmp = uvcb_csc.stor_origin;
>>   	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
>>   	rc = uv_call(0, (uint64_t)&uvcb_csc);
>> @@ -292,6 +314,13 @@ static void test_config_create(void)
>>   	rc = uv_call(0, (uint64_t)&uvcb_cgc);
>>   	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
>>   
>> +	rc = access_check_3d((uint64_t *)uvcb_cgc.conf_var_stor_origin, vsize);
>> +	report(rc, "Base storage protection");
>> +
>> +	rc = access_check_3d((uint64_t *)uvcb_cgc.conf_base_stor_origin,
>> +			     uvcb_qui.conf_base_phys_stor_len);
>> +	report(rc, "Variable storage protection");
>> +
>>   	uvcb_cgc.header.rc = 0;
>>   	uvcb_cgc.header.rrc = 0;
>>   	tmp = uvcb_cgc.guest_handle;
> 

