Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54DE588AFC
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 13:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiHCLSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 07:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiHCLSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 07:18:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AED6556;
        Wed,  3 Aug 2022 04:18:17 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273BDx4N016762;
        Wed, 3 Aug 2022 11:18:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=McV4fypsvkKkaJAZIm/hv3s9f3nELW6Xwbubor1WJ7M=;
 b=i6PCKcKL/DOCP/AQRtHyZ4s6ZcN3llxmmboIo+LurjJo6qYoDla7ByKJQ2vM95MLwi10
 K7Lb2zDURkluJshv+BFBZIKNR+umO3LmFDiFHHdz8R5ZjfiEvDCuLfEbONaPuWK3dFYO
 nytqTedQRlqhQvAhWIcafaClN2dnJic9KHQ5zEOOF3w5hqv4ckkm/M0jT2bNjtMKHer8
 iJIDfcopdx/fU9+IUO5G9HK1wGa4p2Vm6VXZkzA1Tw5t7uWu347kmbFviM9ce/5QfMdC
 oEYaVHg2itqeXDMXg40dbNJ5Sq7qZxV94GDdQ56ZrG4W6FEdtt7ypf++8qSool0ehJAW cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqqy903tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 11:18:16 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 273BEQDq019213;
        Wed, 3 Aug 2022 11:18:16 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqqy903t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 11:18:16 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273ArWNw022126;
        Wed, 3 Aug 2022 11:18:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3hmuwhsqrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 11:18:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273BFtMX26345808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 11:15:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02E69AE051;
        Wed,  3 Aug 2022 11:18:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A57DBAE04D;
        Wed,  3 Aug 2022 11:18:10 +0000 (GMT)
Received: from [9.145.59.133] (unknown [9.145.59.133])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 11:18:10 +0000 (GMT)
Message-ID: <6ab20b3d-f271-336a-c3f7-36e5ac7f88a6@linux.ibm.com>
Date:   Wed, 3 Aug 2022 13:18:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v3] s390x: uv-host: Add access checks for
 donated memory
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220707111912.51ecc0f2@p-imbrenda>
 <20220725130859.48740-1-frankja@linux.ibm.com>
 <20220803114602.5359a8a4@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220803114602.5359a8a4@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: it5Zy0hcsq0D29D1TVdzuKizLOHEHfZj
X-Proofpoint-GUID: AR25Du0UfydZwc7XwES8Elt0yAF9tYGX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/22 11:46, Claudio Imbrenda wrote:
> On Mon, 25 Jul 2022 13:08:59 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Let's check if the UV really protected all the memory we donated.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   s390x/uv-host.c | 37 +++++++++++++++++++++++++++++++++++++
>>   1 file changed, 37 insertions(+)
>>
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index dfcebe10..ba6c9008 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -45,6 +45,32 @@ static void cpu_loop(void)
>>   	for (;;) {}
>>   }
>>   
>> +/*
>> + * Checks if a memory area is protected as secure memory.
>> + * Will return true if all pages are protected, false otherwise.
>> + */
>> +static bool access_check_3d(uint64_t *access_ptr, uint64_t len)
>> +{
>> +	assert(!(len & ~PAGE_MASK));
>> +	assert(!((uint64_t)access_ptr & ~PAGE_MASK));
>> +
>> +	while (len) {
>> +		expect_pgm_int();
>> +		READ_ONCE(*access_ptr);
>> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
>> +			return false;
>> +		expect_pgm_int();
>> +		WRITE_ONCE(*access_ptr, 42);
>> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
>> +			return false;
>> +
>> +		access_ptr += PAGE_SIZE / sizeof(access_ptr);
> 
> this looks ugly, although in principle the correct way to handle a
> pointer. In this specific case it's techically wrong though (you
> actually want sizeof(*access_ptr) )
> 
> what about making access_ptr a char*?
> 
> then you can do just
> 
> 	access_ptr += PAGE_SIZE;
> 
> and you can keep the READ_ONCE and WRITE_ONCE as they are

Sure

> 
>> +		len -= PAGE_SIZE;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>   static struct cmd_list cmds[] = {
>>   	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
>>   	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
>> @@ -332,6 +358,10 @@ static void test_cpu_create(void)
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
>> @@ -430,6 +460,13 @@ static void test_config_create(void)
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

