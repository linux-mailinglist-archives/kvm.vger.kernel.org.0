Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1BB3D7654
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 15:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhG0N1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 09:27:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9536 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236682AbhG0NXg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 09:23:36 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RD43DL191043;
        Tue, 27 Jul 2021 09:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lYeGq5erQMl2R+AaqCRsBkCp1M6AGhPYfNnsT3zY5xg=;
 b=AiR2wBFuTPp53K7M145kmGbM1sGW02WEYF+bnxDt/rvByyvb5OZy/zDqnkAnRqaL9L/H
 otI4qtjHZpoCuo7Q/gXdAyoLzxlOTE2Zhud07u6YZ5Zb9evJZVK0WmC/6v3IKhuRP6Wq
 kvMuI979MYytk5LP8cViuDihJOAfPNM1tw0HIXUMI5irLJ6sbtc1lramESAhes05swIh
 15GrmQ82Mn90EUNZ7v18XGhGRwig1JrzY+mxJ0cWf8bj8vhSbYfcPWplwwEIyzfm1fhG
 fhLFM8wN0dyLf4xAb5Gd/6fKa6pQ4TIFjy+2le8S1upSQCybBfRImS9IH71depJaaIJz 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2hhnupuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 09:23:36 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16RD57nE009640;
        Tue, 27 Jul 2021 09:23:35 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2hhnuptg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 09:23:35 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16RDJHOw027084;
        Tue, 27 Jul 2021 13:23:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235kgems-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 13:23:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16RDNTnT20447556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 13:23:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC9CFAE055;
        Tue, 27 Jul 2021 13:23:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9FBBAE056;
        Tue, 27 Jul 2021 13:23:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.20.110])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 13:23:28 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210706115724.372901-1-scgl@linux.ibm.com>
 <709f6326-efcb-d359-bfac-59a162473c91@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception
 interception test
Message-ID: <4507bf8e-6eda-2cb3-f014-f0931c963ccd@linux.ibm.com>
Date:   Tue, 27 Jul 2021 15:23:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <709f6326-efcb-d359-bfac-59a162473c91@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DdfLUNaDNEGpr5QMVhHAkyyTF35vQd15
X-Proofpoint-ORIG-GUID: EAGhwUMqg-7VkrU1k3Ok2o0f3IO0l-wA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_07:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/21 11:28 AM, Thomas Huth wrote:
> On 06/07/2021 13.57, Janis Schoetterl-Glausch wrote:
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
>> The patch is based on the following patch sets by Janosch:
>> [kvm-unit-tests PATCH 0/5] s390x: sie and uv cleanups
>> [kvm-unit-tests PATCH v2 0/3] s390x: Add snippet support
>>
>>   s390x/Makefile             |  2 +
>>   lib/s390x/sie.h            |  1 +
>>   s390x/snippets/c/spec_ex.c | 13 ++++++
>>   s390x/spec_ex-sie.c        | 91 ++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg        |  3 ++
>>   5 files changed, 110 insertions(+)
>>   create mode 100644 s390x/snippets/c/spec_ex.c
>>   create mode 100644 s390x/spec_ex-sie.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 07af26d..b1b6536 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>>   tests += $(TEST_DIR)/uv-host.elf
>>   tests += $(TEST_DIR)/edat.elf
>>   tests += $(TEST_DIR)/mvpg-sie.elf
>> +tests += $(TEST_DIR)/spec_ex-sie.elf
>>   
>>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   ifneq ($(HOST_KEY_DOCUMENT),)
>> @@ -84,6 +85,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>>   # perquisites (=guests) for the snippet hosts.
>>   # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>>   $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>> +$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>>   
>>   $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>>   	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> index 6ba858a..a3b8623 100644
>> --- a/lib/s390x/sie.h
>> +++ b/lib/s390x/sie.h
>> @@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
>>   	uint8_t		fpf;			/* 0x0060 */
>>   #define ECB_GS		0x40
>>   #define ECB_TE		0x10
>> +#define ECB_SPECI	0x08
>>   #define ECB_SRSI	0x04
>>   #define ECB_HOSTPROTINT	0x02
>>   	uint8_t		ecb;			/* 0x0061 */
>> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
>> new file mode 100644
>> index 0000000..f2daab5
>> --- /dev/null
>> +++ b/s390x/snippets/c/spec_ex.c
> 
> Please add a short header comment with the basic idea here + license 
> information (e.g. SPDX identifier). Also in the other new file that you 
> introduce in this patch.
> 
>> @@ -0,0 +1,13 @@
>> +#include <stdint.h>
>> +#include <asm/arch_def.h>
>> +
>> +__attribute__((section(".text"))) int main(void)
>> +{
>> +	uint64_t bad_psw = 0;
>> +	struct psw *pgm_new = (struct psw *)464;
> 
> Is it possible to use the lib/s390x/asm/arch_def.h in snippets? If so, I'd 
> vote for using &lowcore->pgm_new_psw instead of the magic number 464.

I think it should be, we don't print in arch_def.h and that's usually
the biggest problem for snippets.

But even if it doesn't work we can still use GEN_LC_PGM_NEW_PSW from
asm-offsets.h

> 
>> +	pgm_new->mask = 1UL << (63 - 12); //invalid program new PSW
> 
> Please add a space after the //
> (also in the other spots in this patch)
> 
>> +	pgm_new->addr = 0xdeadbeef;
> 
> Are we testing the mask or the addr here? If we're testing the mask, I'd 
> rather use an even addr here to make sure that we do not trap because of the 
> uneven address. Or do we just don't care?

If I remember correctly then the odd address would be a late exception
and an invalid mask is an early exception. The whole topic of PSW
exceptions is rather complex especially if you add the instructions that
change the PSW into the consideration.

> 
>> +	asm volatile ("lpsw %0" :: "Q"(bad_psw));
>> +	return 0;
>> +}
> 
>   Thomas
> 

