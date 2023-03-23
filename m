Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0917D6C6A64
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCWOEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjCWOEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:04:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63B4199C9
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:03:31 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NBvNlk030018
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pPVGsAyG7CO9/U5Tx57ugQiSwdh9ZxCGd14RS/bMYCw=;
 b=kXFZkXAtEuZFaVFISDpkyAKU21GWEWNKTx8rKosov5JJp5xE1qSVQGtYRz1Bx1s+LkYC
 eY9k1F50oFtsSxRWJTaZ/G48ePRYOfv545qp0TandVZ6XKJ/zhefqTnGQFHft4GSCkSy
 v5m3je2chgymF4VSpW6S2Bg1cH5hXgxr9sicLJs83ToY9C/d0H3rGhhhKdw2oqNFwnr7
 8a/YdQ00CnX5m/zAnNF9pNu+Xok8zt60X3B7Hpwe9uWlav1PPR37ijGDuvA/JrhIZfOF
 ou8ulcKLnEC+aEJc59qulniw+/crqN7h15mhOmOg3yKsf2VTjDEPpmmxt6Q4tUbkKhOd MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgm2bewqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:03:29 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NCu6LM017448
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:03:26 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgm2bevy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 14:03:26 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NDl8VL003981;
        Thu, 23 Mar 2023 14:02:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pd4x668tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 14:02:09 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NE26Mq26149484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 14:02:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E6D620040;
        Thu, 23 Mar 2023 14:02:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF4D120043;
        Thu, 23 Mar 2023 14:02:05 +0000 (GMT)
Received: from [9.171.93.165] (unknown [9.171.93.165])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 14:02:05 +0000 (GMT)
Message-ID: <db6090cc-a21e-96ad-ff82-7933687c4a93@linux.ibm.com>
Date:   Thu, 23 Mar 2023 15:02:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
References: <20230323103913.40720-1-frankja@linux.ibm.com>
 <20230323103913.40720-8-frankja@linux.ibm.com>
 <167957758513.13757.3801977482458852875@t14-nrb>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 7/8] s390x: uv-host: Properly handle config
 creation errors
In-Reply-To: <167957758513.13757.3801977482458852875@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zILgqqE-Lab7dB5uBLsderynuLJBqwg9
X-Proofpoint-ORIG-GUID: 2Utjm4wSNMvzydnLvPQF-GqwG8apberq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-23_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230106
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/23/23 14:19, Nico Boehr wrote:
> Quoting Janosch Frank (2023-03-23 11:39:12)
> [...]
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index d92571b5..b23d51c9 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -370,6 +370,38 @@ static void test_cpu_create(void)
>>          report_prefix_pop();
>>   }
>>   
>> +/*
>> + * If the first bit of the rc is set we need to destroy the
>> + * configuration before testing other create config errors.
>> + */
>> +static void cgc_destroy_if_needed(struct uv_cb_cgc *uvcb)
> 
> Is there a reason why we can't make this a cgc_uv_call() function which performs the uv_call and the cleanups if needed?

I'd much rather put the destroy into the cleanup area after the report.

> 
> Mixing reports and cleanup activity feels a bit odd to me.
> 
> [...]
>> +/* This function expects errors, not successes */
> 
> I am confused by this comment. What does it mean?
> 
>> +static bool cgc_check_data(struct uv_cb_cgc *uvcb, uint16_t rc_expected)
> 
> Rename to cgc_check_rc_and_handle?
> 
>> +{
>> +       cgc_destroy_if_needed(uvcb);
>> +       /*
>> +        * We should only receive a handle when the rc is 1 or the
>> +        * first bit is set.
> 
> Where is the code that checks for rc == 1?
> 
> Ah OK, so that's what you mean with the comment above, this function only works if the UVC fails, right?
> 
>> +        */
>> +       if (!(uvcb->header.rc & UVC_RC_DSTR_NEEDED_FLG) && uvcb->guest_handle)
>> +               return false;
> 
> It would be nicer if I got a proper report message that tells me that we got a handle even though we shouldn't destroy.

We can report_info() or report_abort().
