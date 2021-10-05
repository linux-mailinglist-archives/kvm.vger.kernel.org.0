Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99371422A93
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 16:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhJEOPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 10:15:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236039AbhJEOOz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 10:14:55 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195E8jw6014963;
        Tue, 5 Oct 2021 10:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ahhevMSQVbcaZDQFL9ujVBjSdb3OBb62fpPWDZp0cYA=;
 b=XzEsPyjyX29J7rfw7oaMocLCMNcL1T6vviEGBE/4gOPJj9/ySk0y04uf83o+/Xe4vhAF
 BjfaXqYCc+3DOlLySpuKCGO9RMq/Ntmb+Yk0gNwTRHD/uJ5+GkDb3yTlWTKgSxSNlV5e
 o80zmi6xUGOSKdgNDqp0Cj8FMwfhrHWgfQO/JHRbJiXOxvwPakBEYZ+CNaaOillHhS+l
 u7HJtYEvTAuMP0YH09AwfWg8F202UW9fT8BahPxLKWr8hMvzcUrBEMtbV6VM7RDH5v9o
 DIMB75Yooz8U6fLYU+mb/Y82X6pMB2RFLykkZWuD8Vs1tBUI8SgAL1XfUjW8juP5pNZL hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgr7984gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 10:13:04 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195E9Cgh016045;
        Tue, 5 Oct 2021 10:13:04 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgr7984fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 10:13:04 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195ECkx5007665;
        Tue, 5 Oct 2021 14:13:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3bef29h5tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 14:13:01 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195ECvDU4653672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 14:12:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF10B52054;
        Tue,  5 Oct 2021 14:12:57 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.6.58])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3D99B52065;
        Tue,  5 Oct 2021 14:12:57 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: Add specification exception
 interception test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
 <20211005091153.1863139-3-scgl@linux.ibm.com>
 <20211005150919.04425060@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <c4826f20-f501-4c51-1109-40692ce8b1c7@linux.vnet.ibm.com>
Date:   Tue, 5 Oct 2021 16:12:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211005150919.04425060@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TEG-Q5tZKZbBgeLUdSbvITrRjUc2sXm8
X-Proofpoint-ORIG-GUID: Ry59FPdwoD3ppGNQGWgPm4ACjFjwH7Kn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 spamscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 3:09 PM, Claudio Imbrenda wrote:
> On Tue,  5 Oct 2021 11:11:53 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Check that specification exceptions cause intercepts when
>> specification exception interpretation is off.
>> Check that specification exceptions caused by program new PSWs
>> cause interceptions.
>> We cannot assert that non program new PSW specification exceptions
>> are interpreted because whether interpretation occurs or not is
>> configuration dependent.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  s390x/Makefile             |  2 +
>>  lib/s390x/sie.h            |  1 +
>>  s390x/snippets/c/spec_ex.c | 20 +++++++++
>>  s390x/spec_ex-sie.c        | 83 ++++++++++++++++++++++++++++++++++++++
>>  s390x/unittests.cfg        |  3 ++
>>  5 files changed, 109 insertions(+)
>>  create mode 100644 s390x/snippets/c/spec_ex.c
>>  create mode 100644 s390x/spec_ex-sie.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index ef8041a..7198882 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>>  tests += $(TEST_DIR)/uv-host.elf
>>  tests += $(TEST_DIR)/edat.elf
>>  tests += $(TEST_DIR)/mvpg-sie.elf
>> +tests += $(TEST_DIR)/spec_ex-sie.elf
>>  
>>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>  ifneq ($(HOST_KEY_DOCUMENT),)
>> @@ -85,6 +86,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>>  # perquisites (=guests) for the snippet hosts.
>>  # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>>  $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>> +$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>>  
>>  $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>>  	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> index ca514ef..7ef7251 100644
>> --- a/lib/s390x/sie.h
>> +++ b/lib/s390x/sie.h
>> @@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
>>  	uint8_t		fpf;			/* 0x0060 */
>>  #define ECB_GS		0x40
>>  #define ECB_TE		0x10
>> +#define ECB_SPECI	0x08
>>  #define ECB_SRSI	0x04
>>  #define ECB_HOSTPROTINT	0x02
>>  	uint8_t		ecb;			/* 0x0061 */
>> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
>> new file mode 100644
>> index 0000000..bdba4f4
>> --- /dev/null
>> +++ b/s390x/snippets/c/spec_ex.c
>> @@ -0,0 +1,20 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * © Copyright IBM Corp. 2021
>> + *
>> + * Snippet used by specification exception interception test.
>> + */
>> +#include <stdint.h>
>> +#include <asm/arch_def.h>
>> +
>> +__attribute__((section(".text"))) int main(void)
>> +{
>> +	struct lowcore *lowcore = (struct lowcore *) 0;
>> +	uint64_t bad_psw = 0;
>> +
>> +	/* PSW bit 12 has no name or meaning and must be 0 */
>> +	lowcore->pgm_new_psw.mask = 1UL << (63 - 12);
> 
> you can use the BIT or BIT_ULL macro
> 
>> +	lowcore->pgm_new_psw.addr = 0xdeadbeee;
> 
> if the system is broken, it might actually jump at that address; in
> that case, will the test fail?

Broken how? If interpretation is overzealous the test might hang.

[...]
