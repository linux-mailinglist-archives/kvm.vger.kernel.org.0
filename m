Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25733310BC
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCHOZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:25:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229972AbhCHOZB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:25:01 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128E3wf3066677
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:25:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2IEc2zBKrf4zhq3nCnvE3+HVQ0KtqjsZp4MaeffCj9c=;
 b=jHYMPGKCK8qVS+zuHCMgR08PJW+DEF3cUt/uQvNblsgMe9fad/TQnhYw5u+dfHggoa9H
 wPUTqKPwDVAAhExh+FnVby6Eq8PBMbD60bB0TtX8E2Wl0Zyc79U+XpR00iIJ+3eHAW4t
 fIi+qnOjxQHkBdPbWTqhciV0X3V3AfXbRQb2Serh4P7fcxtP+FmATYj0mfF4uj0DWmHK
 NpaQKfOFqkBhG3g06NBaQeqZ+V5Zxe/EcDg5aCivMd6UHpJTArTBtdK4gBWLVs343mqI
 gIB9jDpFmNF8PwzCRv99e9+pC/4YQsIU2p16VBnAOe5NxvyiUQuj8ULUcTnDX5NUjxp8 Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375muahgqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 09:25:00 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128E4oJa069498
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:25:00 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375muahgp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:25:00 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EItOH002797;
        Mon, 8 Mar 2021 14:24:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 37410h908d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:24:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EOrYn45220240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:24:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9190AE053;
        Mon,  8 Mar 2021 14:24:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B20FAE055;
        Mon,  8 Mar 2021 14:24:53 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.232])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:24:53 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 4/6] s390x: css: implementing Set
 CHannel Monitor
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-5-git-send-email-pmorel@linux.ibm.com>
 <65d91b9d-861a-bc37-6dcf-418ff05dc7ff@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <791f92de-bc69-b096-6914-08629dc951aa@linux.ibm.com>
Date:   Mon, 8 Mar 2021 15:24:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <65d91b9d-861a-bc37-6dcf-418ff05dc7ff@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/1/21 4:32 PM, Janosch Frank wrote:
> On 3/1/21 12:47 PM, Pierre Morel wrote:
>> We implement the call of the Set CHannel Monitor instruction,
>> starting the monitoring of the all Channel Sub System, and
>> initializing channel subsystem monitoring.
>>
>> Initial tests report the presence of the extended measurement block
>> feature, and verify the error reporting of the hypervisor for SCHM.
> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   lib/s390x/css.h | 12 ++++++++++++
>>   s390x/css.c     | 35 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 47 insertions(+)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 1cb3de2..b8ac363 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -310,6 +310,7 @@ struct chsc_scsc {
>>   	uint32_t res_04[2];
>>   	struct chsc_header res;
>>   	uint32_t res_fmt;
>> +#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
>>   	uint64_t general_char[255];
>>   	uint64_t chsc_char[254];
>>   };
>> @@ -360,6 +361,17 @@ bool chsc(void *p, uint16_t code, uint16_t len);
>>   #define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
>>   #define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
> 
> css_test_general_feature(bit)
> css_test_chsc_feature(bit)
> 
> ?


Yes,

Thanks,
Pierre
-- 
Pierre Morel
IBM Lab Boeblingen
