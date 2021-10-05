Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2F1422B19
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 16:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhJEOgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 10:36:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233705AbhJEOgt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 10:36:49 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195EBg6R012581;
        Tue, 5 Oct 2021 10:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V3sMFETCp4+ejPDlRO53DfeO6zBY9xAm4q8hZKx26aY=;
 b=Sxer2pTl1+jmXvmmYZjhzxTdZEiF3uETFvM+vFLPz+Us081W1sZM2XYTk5+Irw5BHmag
 9YOahtCQXKfOxARadf7MBTGEARQNVB/Afn+G96F/JzMR8rwFjmEstrS4HcZe7q7isbgW
 TUFMzIshz/zPMwYO4JZE0MfR5t7UNKAtDZvCwPv8jtdcesOwGPlHTX8Nt48rD9WY+w+9
 fFcxl505Z/N2XVVbdWJ6K6azerwIt6Y5D2hfmOOhZHYjCYNce5eNr34uFwWIlDV5IdxB
 4blIWCjNVPE019jPTgbFTT55fJh39IESJuqIKIAE9SRqnRo8FyBIYjym+wlHOx1pmn8r NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgr8g0np9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 10:34:58 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195EDvie022105;
        Tue, 5 Oct 2021 10:34:58 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgr8g0nna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 10:34:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195ESZwI023622;
        Tue, 5 Oct 2021 14:34:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3beepjkkg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 14:34:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195EYqNN47317396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 14:34:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1763752059;
        Tue,  5 Oct 2021 14:34:52 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.6.58])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A418252065;
        Tue,  5 Oct 2021 14:34:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: Add specification exception
 interception test
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
 <20211005091153.1863139-3-scgl@linux.ibm.com>
 <d49ea774-2e3b-aea7-6c7a-9dd3cc744283@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <da14a4b1-d16e-843b-f001-5002b4d0e3fd@linux.vnet.ibm.com>
Date:   Tue, 5 Oct 2021 16:34:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d49ea774-2e3b-aea7-6c7a-9dd3cc744283@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QOVtYpZyH0GvRJgdZCFWPedo8dxQ58J_
X-Proofpoint-GUID: ljaJtlPHTxdMI-FQZjQdqoGOv_P5CgSi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 2:49 PM, Janosch Frank wrote:
> On 10/5/21 11:11, Janis Schoetterl-Glausch wrote:
>> Check that specification exceptions cause intercepts when
>> specification exception interpretation is off.
>> Check that specification exceptions caused by program new PSWs
>> cause interceptions.
>> We cannot assert that non program new PSW specification exceptions
>> are interpreted because whether interpretation occurs or not is
>> configuration dependent.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> Reviewed-by: Janosch Frank <frankja@de.ibm.com>
> Minor nit below.
> 
>> ---
>>   s390x/Makefile             |  2 +
>>   lib/s390x/sie.h            |  1 +
>>   s390x/snippets/c/spec_ex.c | 20 +++++++++
>>   s390x/spec_ex-sie.c        | 83 ++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg        |  3 ++
>>   5 files changed, 109 insertions(+)
>>   create mode 100644 s390x/snippets/c/spec_ex.c
>>   create mode 100644 s390x/spec_ex-sie.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index ef8041a..7198882 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>>   tests += $(TEST_DIR)/uv-host.elf
>>   tests += $(TEST_DIR)/edat.elf
>>   tests += $(TEST_DIR)/mvpg-sie.elf
>> +tests += $(TEST_DIR)/spec_ex-sie.elf
>>     tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   ifneq ($(HOST_KEY_DOCUMENT),)
>> @@ -85,6 +86,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>>   # perquisites (=guests) for the snippet hosts.
>>   # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>>   $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>> +$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>>     $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>>       $(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> index ca514ef..7ef7251 100644
>> --- a/lib/s390x/sie.h
>> +++ b/lib/s390x/sie.h
>> @@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
>>       uint8_t        fpf;            /* 0x0060 */
>>   #define ECB_GS        0x40
>>   #define ECB_TE        0x10
>> +#define ECB_SPECI    0x08
>>   #define ECB_SRSI    0x04
>>   #define ECB_HOSTPROTINT    0x02
>>       uint8_t        ecb;            /* 0x0061 */
>> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
>> new file mode 100644
>> index 0000000..bdba4f4
>> --- /dev/null
>> +++ b/s390x/snippets/c/spec_ex.c
>> @@ -0,0 +1,20 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + *Copyright IBM Corp. 2021
> 
> I'd replace that copyright symbol with the (C) that we have usually.

IBM guidelines say to just drop it if not available. Will do that.

> Also, don't you want to add your name/mail in an authors list?

Eh, I don't see the point. Git tracks authorship and having a single source
of truth is preferable IMO. Thanks for the reminder, tho.

[...]
