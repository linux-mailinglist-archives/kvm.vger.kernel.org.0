Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FAF719983
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 12:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjFAKTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 06:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbjFAKTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 06:19:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315FD1726;
        Thu,  1 Jun 2023 03:16:09 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351AEDW3023048;
        Thu, 1 Jun 2023 10:15:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tC1TqjQNa3WWHX+kKICqF/7enyZGiUtupnpo1NRBVuE=;
 b=MP/w1f4Ey2Ife73Z3rASa2VtJGNSi9EDECN/ihxHCD1CKBalWVWz/qEUeSaijQSW/+9M
 ic52KT8UNkOEzaXxQtCZBYnW7hYJwHa/iV4npW8jodxEhb0WtHc12tY6rWLAWTOuTly9
 Obx1GwecvQ1f8u7nxRuaalJfOeNKEaOinPtIuK2UO2c9RzABrdBRSDWFsF4a/FQ+kLyY
 33ZMTAh737Dk1bga99/9Xv71g2aN180snWaBseiL3pDsgiwvP2V9shn0nZtTMkbeW7g9
 zrRIuAtHgdj+5qHAQIyBHm9DsAHEuyV8FGfjudRE9uRJgtXj6WCFgsZu4/hieU7VUVnO AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxsd50109-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 10:15:09 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351AF9Qk027502;
        Thu, 1 Jun 2023 10:15:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxsd500y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 10:15:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3511luMW031867;
        Thu, 1 Jun 2023 10:15:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g52fhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 10:15:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351AF3T745089096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 10:15:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CF9D2004B;
        Thu,  1 Jun 2023 10:15:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0A6120040;
        Thu,  1 Jun 2023 10:15:02 +0000 (GMT)
Received: from [9.171.12.131] (unknown [9.171.12.131])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  1 Jun 2023 10:15:02 +0000 (GMT)
Message-ID: <1c24e467-3b57-d7a9-be28-fcaf5e265b80@linux.ibm.com>
Date:   Thu, 1 Jun 2023 12:15:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: sclp: Implement
 SCLP_RC_INSUFFICIENT_SCCB_LENGTH
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        cohuck@redhat.com
References: <20230530124056.18332-1-pmorel@linux.ibm.com>
 <20230530124056.18332-3-pmorel@linux.ibm.com>
 <3dc8e019-a3c1-8446-08ed-f76a9064f954@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3dc8e019-a3c1-8446-08ed-f76a9064f954@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uXhLKCU-KIV7ci1g5_0Jjy7lZ7Pxqk18
X-Proofpoint-GUID: q6SANgXBcejNP07lAojLLIKL3nCxr_Qw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_06,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010090
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/1/23 10:03, Janosch Frank wrote:
> On 5/30/23 14:40, Pierre Morel wrote:
>> If SCLP_CMDW_READ_SCP_INFO fails due to a short buffer, retry
>> with a greater buffer.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>
> You've been testing using all possible cpus, haven't you?


yes up to 248


>
>>   }
>>   -static void sclp_read_scp_info(ReadInfo *ri, int length)
>> +static bool sclp_read_scp_info_extended(unsigned int command, 
>> ReadInfo *ri)
>> +{
>> +    int cc;
>> +
>> +    if (!test_facility(140)) {
>> +        report_abort("S390_FEAT_EXTENDED_LENGTH_SCCB missing");
>
> That's the QEMU name for the facility, isn't it?
> "extended-length-SCCB facility is missing" might be better since 
> that's the name that the architecture specifies for that feature.


yes


>
>> +        return false;
>> +    }
>> +    if (ri->h.length > (2 * PAGE_SIZE)) {
>
> sizeof() would reduce the locations that we have to touch if we ever 
> want to increase the buffer in the future.


yes


>
>> +        report_abort("SCLP_READ_INFO expected size too big");
>> +        return false;
>> +    }
>> +
>> +    sclp_mark_busy();
>> +    memset(&ri->h, 0, sizeof(ri->h));
>> +    ri->h.length = 2 * PAGE_SIZE;
>
> Same here


OK


>
>> +
>> +    cc = sclp_service_call(command, ri);
>> +    if (cc) {
>> +        report_abort("SCLP_READ_INFO error");
>> +        return false;
>> +    }
>> +    if (ri->h.response_code != SCLP_RC_NORMAL_READ_COMPLETION) {
>> +        report_abort("SCLP_READ_INFO error %02x", ri->h.response_code);
>> +        return false;
>> +    }
>> +
>> +    return true;
>> +}
>> +
>> +static void sclp_read_scp_info(ReadInfo *ri)
>>   {
>>       unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
>>                       SCLP_CMDW_READ_SCP_INFO };
>> +    int length = PAGE_SIZE;
>>       int i, cc;
>>         for (i = 0; i < ARRAY_SIZE(commands); i++) {
>> @@ -101,19 +133,29 @@ static void sclp_read_scp_info(ReadInfo *ri, 
>> int length)
>>           ri->h.length = length;
>>             cc = sclp_service_call(commands[i], ri);
>> -        if (cc)
>> -            break;
>> -        if (ri->h.response_code == SCLP_RC_NORMAL_READ_COMPLETION)
>> +        if (cc) {
>> +            report_abort("SCLP_READ_INFO error");
>>               return;
>> -        if (ri->h.response_code != SCLP_RC_INVALID_SCLP_COMMAND)
>> +        }
>> +
>> +        switch (ri->h.response_code) {
>> +        case SCLP_RC_NORMAL_READ_COMPLETION:
>> +            return;
>> +        case SCLP_RC_INVALID_SCLP_COMMAND:
>>               break;
>> +        case SCLP_RC_INSUFFICIENT_SCCB_LENGTH:
>> +            sclp_read_scp_info_extended(commands[i], ri);
>> +            return;
>> +        default:
>> +            report_abort("READ_SCP_INFO failed");
>> +            return;
>> +        }
>>       }
>> -    report_abort("READ_SCP_INFO failed");
>>   }
>>     void sclp_read_info(void)
>>   {
>> -    sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
>
> Why did you remove that?
> You could have re-tried with the extended-length in 
> sclp_read_scp_info(). Or you could return the rc and introduce a tiny 
> function that tries both lengths depending on the rc.


Yes, I can let it here. I found it has little sense to give the length 
as parameter.

Retrying with extended length in sclp_read_scp_info() is what is done 
isn'it?

It does not change a lot to let the first used size here so I will let 
it here.


>
>> +    sclp_read_scp_info((void *)_read_info);
>>       read_info = (ReadInfo *)_read_info;
>>   }
>
