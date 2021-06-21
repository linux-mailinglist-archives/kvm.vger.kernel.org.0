Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272493AEB9E
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFUOpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 10:45:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229747AbhFUOpR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 10:45:17 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LEXp0I166349;
        Mon, 21 Jun 2021 10:43:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mz0lUImqCTb2piSLiSzqZ5+vZRDqR9KRbKRO1kycDX0=;
 b=K/dgfHfPXfbV2YgHhC4qzOyCZ7WriEmZpeMJi5M4OL4TFVixt6z6LIgBC4giilSoEjGL
 K2Yde39LYgAUzt6ZrvDapTBFBJkhVxY0T4cXGsPvQRZQ5h6oRCcql+U6+Sb/z8cB9fO3
 8SnCqN4sNVfmLTzJkChnscmsXPg50aLX55ta0Nd40YPU/YnGX7SGWeLnQsrzmLF4k8vu
 LSaUkrOwcNQMEHDmx+JOaVTqk35o1vB7L0hVAH7cm32CNIekGGp0uGt3JGtGhtr/sMiV
 cBHb1IekW6Gk09W0r7+CGlgpQMO7yCevWynzj1ayoL5ZhYEKCrTAlkr4vHjGXBx11KiF yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39at7cdnsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 10:43:02 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LEZB7J176485;
        Mon, 21 Jun 2021 10:43:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39at7cdnr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 10:43:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LEgsih030153;
        Mon, 21 Jun 2021 14:42:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3998788y3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 14:42:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LEfdan24576452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 14:41:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E17E42041;
        Mon, 21 Jun 2021 14:42:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E01C44204B;
        Mon, 21 Jun 2021 14:42:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Jun 2021 14:42:56 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210520094730.55759-1-frankja@linux.ibm.com>
 <20210520094730.55759-2-frankja@linux.ibm.com>
 <b5171773-afb6-e148-a82f-ea78877206ce@redhat.com>
 <d20e7f88-dcca-67ca-17e0-7c45982aa5ff@linux.ibm.com>
 <304a297a-c366-9d61-9d13-fc1f86dd4f50@redhat.com>
 <19e99dfe-6730-194b-a0c5-87455f446625@linux.ibm.com>
 <5149db0e-8372-6054-da0d-fc8f85ac4038@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests RFC 1/2] s390x: Add guest snippet support
Message-ID: <68698aa3-d207-9260-197e-9d906cc6704f@linux.ibm.com>
Date:   Mon, 21 Jun 2021 16:42:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5149db0e-8372-6054-da0d-fc8f85ac4038@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C4EBwLbQYql7gmfsdVZzkFY5lymXSU1a
X-Proofpoint-ORIG-GUID: Dxb-77BulN6NzTgUqshbk7FzVS1y30xg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_06:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106210086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/21 3:28 PM, Thomas Huth wrote:
> On 21/06/2021 14.39, Janosch Frank wrote:
>> On 6/21/21 2:32 PM, Thomas Huth wrote:
>>> On 21/06/2021 14.19, Janosch Frank wrote:
>>>> On 6/21/21 12:10 PM, Thomas Huth wrote:
>>>>> On 20/05/2021 11.47, Janosch Frank wrote:
>>>>>> Snippets can be used to easily write and run guest (SIE) tests.
>>>>>> The snippet is linked into the test binaries and can therefore be
>>>>>> accessed via a ptr.
>>>>>>
>>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>>> ---
>>>>>>     .gitignore                |  2 ++
>>>>>>     s390x/Makefile            | 28 ++++++++++++++++++---
>>>>>>     s390x/snippets/c/cstart.S | 13 ++++++++++
>>>>>>     s390x/snippets/c/flat.lds | 51 +++++++++++++++++++++++++++++++++++++++
>>>>>>     4 files changed, 91 insertions(+), 3 deletions(-)
>>>>>>     create mode 100644 s390x/snippets/c/cstart.S
>>>>>>     create mode 100644 s390x/snippets/c/flat.lds
>>>>>>
>>>>>> diff --git a/.gitignore b/.gitignore
>>>>>> index 784cb2dd..29d3635b 100644
>>>>>> --- a/.gitignore
>>>>>> +++ b/.gitignore
>>>>>> @@ -22,3 +22,5 @@ cscope.*
>>>>>>     /api/dirty-log
>>>>>>     /api/dirty-log-perf
>>>>>>     /s390x/*.bin
>>>>>> +/s390x/snippets/*/*.bin
>>>>>> +/s390x/snippets/*/*.gbin
>>>>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>>>>> index 8de926ab..fe267011 100644
>>>>>> --- a/s390x/Makefile
>>>>>> +++ b/s390x/Makefile
>>>>>> @@ -75,11 +75,33 @@ OBJDIRS += lib/s390x
>>>>>>     asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
>>>>>>     
>>>>>>     FLATLIBS = $(libcflat)
>>>>>> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>>>>>> +
>>>>>> +SNIPPET_DIR = $(TEST_DIR)/snippets
>>>>>> +
>>>>>> +# C snippets that need to be linked
>>>>>> +snippets-c =
>>>>>> +
>>>>>> +# ASM snippets that are directly compiled and converted to a *.gbin
>>>>>> +snippets-a =
>>>>>
>>>>> Could you please call this snippets-s instead of ...-a ? The -a suffix looks
>>>>> like an archive to me otherwise.
>>>>
>>>> Sure
>>>>
>>>>>
>>>>>> +snippets = $(snippets-a)$(snippets-c)
>>>>>
>>>>> Shouldn't there be a space between the two?
>>>>
>>>> Yes, already fixed that a long while ago
>>>> I thought I had sent out a new version already, maybe that was an
>>>> illusion as I can't seem to find it right now.
>>>>
>>>>>
>>>>>> +snippets-o += $(patsubst %.gbin,%.o,$(snippets))
>>>>>> +
>>>>>> +$(snippets-a): $(snippets-o) $(FLATLIBS)
>>>>>> +	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>>>>>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>>>>>> +
>>>>>> +$(snippets-c): $(snippets-o) $(SNIPPET_DIR)/c/cstart.o  $(FLATLIBS)
>>>>>> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds \
>>>>>> +		$(filter %.o, $^) $(FLATLIBS)
>>>>>> +	$(OBJCOPY) -O binary $@ $@
>>>>>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>>>>>> +
>>>>>> +%.elf: $(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>>>>>>     	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
>>>>>>     		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
>>>>>>     	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
>>>>>> -		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
>>>>>> +		$(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
>>>>>
>>>>> Does this link the snippets into all elf files? ... wouldn't it be better to
>>>>> restrict it somehow to the files that really need them?
>>>>
>>>> Yes it does.
>>>> I'd like to avoid having to specify a makefile rule for every test that
>>>> uses snippets as we already have more than the mvpg one in the queue.
>>>>
>>>> So I'm having Steffen looking into a solution for this problem. My first
>>>> idea was to bring the used snippets into the unittests.cfg but I
>>>> disliked that we then would have compile instructions in another file.
>>>> Maybe there's a way to include that into the makefile in a clever way?
>>>
>>> I haven't tried, but maybe you could replace the $(snippets) in the last
>>> line with
>>>
>>>    $(wildcard snippets/$@.gbin)
>>>
>>> or something similar?
>>
>> That starts falling apart when multiple tests use the same snippet, no?
> 
> That's true ... Maybe something like:
> 
>   $(filter %.gbin,$^)

That filters all files that are not gbins from the prereqs, right?
In what way is that different to linking all the snippets? After all
they are currently a prereq for %.elf or am I missing something here?

Just to expand our use-case a bit more with an example since the code is
still too rough to post right now:

We test diagnose handling for Secure Execution / PV in one host test
where we have a gbin each for most diagnose codes 0x44, 0x9c, 0x288,
0x500 (0x308 needs a whole test and possible multiple gbins on its own
due to its complexity).
Other test bundles are PV IO, misc (stsi, sthyi, ...) and of course
other VSIE instruction handling tests in the future.

> 
> ?
> 
>   Thomas
> 

