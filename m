Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27E2637B70
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 15:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiKXO25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 09:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKXO2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 09:28:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF9C7213E;
        Thu, 24 Nov 2022 06:28:54 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOE2Vfw009688;
        Thu, 24 Nov 2022 14:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RxpA2WxefXUKCSi5nWC2pe/i6J0nMuHHZOEV7LcwEw0=;
 b=s8wjf1Xdxc3XNoaMCg9J7HHV5auvx3gGbN0qDcBQsqqyd4Jh4g5aTAgNFW4+/MYq4rWq
 8eXF+hlUxrdYWZqEQzKBcKZUh0LKJ1HUx5Hx9CAkr9+sWsmXrzKRJYONI9IY9lAfXZul
 TQ3pGnDMe7FU+M4sqw26t7hpD+TerKbfCHEj5xyU8CQWdeSIqdBh7oErsX1Pto5Sg8eV
 niIGw1T3mIkqEWvAneN0RrDQ71ZILpsZ3EQ+K5llG9cWzu7cND8xVUyhhjOy97/PIThm
 5jG34ncAyWzF86be+shcPWAmNbBwBFPDxMS8H/7i9oVm9afEpGw2R6Jd7eTY19aO9jM4 ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2a1d0jhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 14:28:53 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AOE3sul015043;
        Thu, 24 Nov 2022 14:28:53 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2a1d0jh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 14:28:53 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AOELG5a006783;
        Thu, 24 Nov 2022 14:28:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8nyva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 14:28:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AOEMVkZ65536286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 14:22:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C2D552051;
        Thu, 24 Nov 2022 14:28:48 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 50FD95204E;
        Thu, 24 Nov 2022 14:28:48 +0000 (GMT)
Message-ID: <4354acda-f809-4c83-55c7-6407640cbdd2@linux.ibm.com>
Date:   Thu, 24 Nov 2022 15:28:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: Add a linker script to assembly
 snippets
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20221123084656.19864-1-frankja@linux.ibm.com>
 <20221123084656.19864-2-frankja@linux.ibm.com>
 <20221123134523.5af2b5ab@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221123134523.5af2b5ab@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0IWpJMAhADiLHDRyDhMKP3CR5bnkQbZy
X-Proofpoint-ORIG-GUID: tMw7s8ZmHXJq5bDz473Wt3Q7O8ds-uWp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_10,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211240106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/22 13:45, Claudio Imbrenda wrote:
> On Wed, 23 Nov 2022 08:46:52 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> A linker script has a few benefits:
>> - Random data doesn't end up in the binary breaking tests
>> - We can easily define a lowcore and load the snippet from 0x0 instead
>> of 0x4000 which makes asm snippets behave like c snippets
>> - We can easily define an invalid PGM new PSW to ensure an exit on a
>> guest PGM
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> looks good in general, but I have a few questions
> 
>> ---
>>   lib/s390x/snippet.h         |  3 +--
>>   s390x/Makefile              |  5 +++--
>>   s390x/mvpg-sie.c            |  2 +-
>>   s390x/pv-diags.c            |  6 +++---
>>   s390x/snippets/asm/flat.lds | 43 +++++++++++++++++++++++++++++++++++++
>>   5 files changed, 51 insertions(+), 8 deletions(-)
>>   create mode 100644 s390x/snippets/asm/flat.lds
>>
>> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
>> index b17b2a4c..57045994 100644
>> --- a/lib/s390x/snippet.h
>> +++ b/lib/s390x/snippet.h
>> @@ -32,8 +32,7 @@
>>   
>>   #define SNIPPET_PV_TWEAK0	0x42UL
>>   #define SNIPPET_PV_TWEAK1	0UL
>> -#define SNIPPET_OFF_C		0
>> -#define SNIPPET_OFF_ASM		0x4000
>> +#define SNIPPET_UNPACK_OFF	0
>>   
>>   
>>   /*
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index bf1504f9..bb0f9eb8 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -135,7 +135,8 @@ $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>>   	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>>   
>>   $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
>> -	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
>> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $(patsubst %.gbin,%.o,$@)
> 
> I think you can simply use $< instead of the patsubst expression

Right, I'll fix that momentarily.

[...]

>> +	.text : {
>> +		*(.text)
>> +		*(.text.*)
>> +	}
>> +	. = ALIGN(64K);
> 
> any reason to align to 64k? (instead of e.g. 4k)

Well, I've copied that from s390x/flat.lds...
I'll have a look at the required alignments when I find time.

> 
>> +	etext = .;
>> +	. = ALIGN(16);
> 
> do you need the ALIGN? I would think we are already aligned here
> 
>> +	.data : {
>> +		*(.data)
>> +		*(.data.rel*)
>> +	}
>> +	. = ALIGN(16);
>> +	.rodata : { *(.rodata) *(.rodata.*) }
>> +	. = ALIGN(16);
>> +	__bss_start = .;
>> +	.bss : { *(.bss) }
>> +	__bss_end = .;
>> +	. = ALIGN(64K);
> 
> same question as above regarding 64k
> 
>> +}
> 

