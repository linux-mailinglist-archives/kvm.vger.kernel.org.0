Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675913AEBE4
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhFUPBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 11:01:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230165AbhFUPBd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 11:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624287558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UZLJmw8eGYXnhmh6V4iZaqFXsIhAiyXib6kymsQkEv0=;
        b=WJXFIb9BMktiBUXyHPMwwujtBVXFRVzfZ4xtDo17qtr9gOAM8v0Nfs6F+NcHvLPYFBDl5C
        hhU08ji4EPbtj1NkS7g7jwv2PZmuA1S8etA5emYxScUKVHFTLkmLqiYGE87aHQoXz4T1Mj
        GhyC3eOBmg/S1TdkFkL4WWKNBkGTqCQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-c5zZE4oPOFKPr8kkF_9WbA-1; Mon, 21 Jun 2021 10:59:17 -0400
X-MC-Unique: c5zZE4oPOFKPr8kkF_9WbA-1
Received: by mail-wr1-f71.google.com with SMTP id l13-20020adfe9cd0000b0290119a0645c8fso8535522wrn.8
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 07:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UZLJmw8eGYXnhmh6V4iZaqFXsIhAiyXib6kymsQkEv0=;
        b=Yk+WCD1arf/wbeS+3/cDJ0LtjiFlVRaYsZdWDY6ogx3KuHyBQrw2xWxUuV9w28MKo5
         7wGNFAhPWTrFAukzooRyqHhp2qpPMOTKo5UQFmWi4vPkLnUT4No+dwjF4f2wt0JMhDIw
         Lw88ZZnNmfLSNBov0HwIrUGsP4IDf+RAOgz48eSf0AqgjHo7OJqfmVoQns1YU+Ad3sRK
         sSY/SU0bH50jhZtMfbeCrh0jyNu12SkTboAsNW7JaCJH88ka//jcLBnHfY5KxZwmyptp
         wrkLitUkGLYKU+B5sHgKL7ta+NPmjHLdE/OOwFDwbZtGEn3+G5GjIOaOZWtFo7TDm5WE
         VP8g==
X-Gm-Message-State: AOAM531JhUc2EWLgcNmo7q0lx3uD0A2tNmkz4EQxgpGDIwIw83oI315n
        SfyVwT2cQU623BkjYzBpmdPXq5YAjo15sKLcuunn+9jZCiafyDZ0AgtXFYnJPFie8l8BgRQT4KA
        z/4ayJKvizfrL
X-Received: by 2002:a5d:6da4:: with SMTP id u4mr29625101wrs.164.1624287556346;
        Mon, 21 Jun 2021 07:59:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcgbP8FMKFc7DiOUAFxof8dUnFlRKyB47BWAjypMdnBBgdHStbh8MWCMzMXsXum6DKRmMUlg==
X-Received: by 2002:a5d:6da4:: with SMTP id u4mr29625075wrs.164.1624287556134;
        Mon, 21 Jun 2021 07:59:16 -0700 (PDT)
Received: from thuth.remote.csb (pd9575fcd.dip0.t-ipconnect.de. [217.87.95.205])
        by smtp.gmail.com with ESMTPSA id p16sm18337758wrs.52.2021.06.21.07.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 07:59:15 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC 1/2] s390x: Add guest snippet support
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210520094730.55759-1-frankja@linux.ibm.com>
 <20210520094730.55759-2-frankja@linux.ibm.com>
 <b5171773-afb6-e148-a82f-ea78877206ce@redhat.com>
 <d20e7f88-dcca-67ca-17e0-7c45982aa5ff@linux.ibm.com>
 <304a297a-c366-9d61-9d13-fc1f86dd4f50@redhat.com>
 <19e99dfe-6730-194b-a0c5-87455f446625@linux.ibm.com>
 <5149db0e-8372-6054-da0d-fc8f85ac4038@redhat.com>
 <68698aa3-d207-9260-197e-9d906cc6704f@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a74f86e1-6fc9-e2fd-12f9-4670c1290355@redhat.com>
Date:   Mon, 21 Jun 2021 16:59:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <68698aa3-d207-9260-197e-9d906cc6704f@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/06/2021 16.42, Janosch Frank wrote:
> On 6/21/21 3:28 PM, Thomas Huth wrote:
>> On 21/06/2021 14.39, Janosch Frank wrote:
>>> On 6/21/21 2:32 PM, Thomas Huth wrote:
>>>> On 21/06/2021 14.19, Janosch Frank wrote:
>>>>> On 6/21/21 12:10 PM, Thomas Huth wrote:
>>>>>> On 20/05/2021 11.47, Janosch Frank wrote:
>>>>>>> Snippets can be used to easily write and run guest (SIE) tests.
>>>>>>> The snippet is linked into the test binaries and can therefore be
>>>>>>> accessed via a ptr.
>>>>>>>
>>>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>>>> ---
>>>>>>>      .gitignore                |  2 ++
>>>>>>>      s390x/Makefile            | 28 ++++++++++++++++++---
>>>>>>>      s390x/snippets/c/cstart.S | 13 ++++++++++
>>>>>>>      s390x/snippets/c/flat.lds | 51 +++++++++++++++++++++++++++++++++++++++
>>>>>>>      4 files changed, 91 insertions(+), 3 deletions(-)
>>>>>>>      create mode 100644 s390x/snippets/c/cstart.S
>>>>>>>      create mode 100644 s390x/snippets/c/flat.lds
>>>>>>>
>>>>>>> diff --git a/.gitignore b/.gitignore
>>>>>>> index 784cb2dd..29d3635b 100644
>>>>>>> --- a/.gitignore
>>>>>>> +++ b/.gitignore
>>>>>>> @@ -22,3 +22,5 @@ cscope.*
>>>>>>>      /api/dirty-log
>>>>>>>      /api/dirty-log-perf
>>>>>>>      /s390x/*.bin
>>>>>>> +/s390x/snippets/*/*.bin
>>>>>>> +/s390x/snippets/*/*.gbin
>>>>>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>>>>>> index 8de926ab..fe267011 100644
>>>>>>> --- a/s390x/Makefile
>>>>>>> +++ b/s390x/Makefile
>>>>>>> @@ -75,11 +75,33 @@ OBJDIRS += lib/s390x
>>>>>>>      asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
>>>>>>>      
>>>>>>>      FLATLIBS = $(libcflat)
>>>>>>> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>>>>>>> +
>>>>>>> +SNIPPET_DIR = $(TEST_DIR)/snippets
>>>>>>> +
>>>>>>> +# C snippets that need to be linked
>>>>>>> +snippets-c =
>>>>>>> +
>>>>>>> +# ASM snippets that are directly compiled and converted to a *.gbin
>>>>>>> +snippets-a =
>>>>>>
>>>>>> Could you please call this snippets-s instead of ...-a ? The -a suffix looks
>>>>>> like an archive to me otherwise.
>>>>>
>>>>> Sure
>>>>>
>>>>>>
>>>>>>> +snippets = $(snippets-a)$(snippets-c)
>>>>>>
>>>>>> Shouldn't there be a space between the two?
>>>>>
>>>>> Yes, already fixed that a long while ago
>>>>> I thought I had sent out a new version already, maybe that was an
>>>>> illusion as I can't seem to find it right now.
>>>>>
>>>>>>
>>>>>>> +snippets-o += $(patsubst %.gbin,%.o,$(snippets))
>>>>>>> +
>>>>>>> +$(snippets-a): $(snippets-o) $(FLATLIBS)
>>>>>>> +	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>>>>>>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>>>>>>> +
>>>>>>> +$(snippets-c): $(snippets-o) $(SNIPPET_DIR)/c/cstart.o  $(FLATLIBS)
>>>>>>> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds \
>>>>>>> +		$(filter %.o, $^) $(FLATLIBS)
>>>>>>> +	$(OBJCOPY) -O binary $@ $@
>>>>>>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>>>>>>> +
>>>>>>> +%.elf: $(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>>>>>>>      	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
>>>>>>>      		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
>>>>>>>      	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
>>>>>>> -		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
>>>>>>> +		$(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
>>>>>>
>>>>>> Does this link the snippets into all elf files? ... wouldn't it be better to
>>>>>> restrict it somehow to the files that really need them?
>>>>>
>>>>> Yes it does.
>>>>> I'd like to avoid having to specify a makefile rule for every test that
>>>>> uses snippets as we already have more than the mvpg one in the queue.
>>>>>
>>>>> So I'm having Steffen looking into a solution for this problem. My first
>>>>> idea was to bring the used snippets into the unittests.cfg but I
>>>>> disliked that we then would have compile instructions in another file.
>>>>> Maybe there's a way to include that into the makefile in a clever way?
>>>>
>>>> I haven't tried, but maybe you could replace the $(snippets) in the last
>>>> line with
>>>>
>>>>     $(wildcard snippets/$@.gbin)
>>>>
>>>> or something similar?
>>>
>>> That starts falling apart when multiple tests use the same snippet, no?
>>
>> That's true ... Maybe something like:
>>
>>    $(filter %.gbin,$^)
> 
> That filters all files that are not gbins from the prereqs, right?
> In what way is that different to linking all the snippets? After all
> they are currently a prereq for %.elf or am I missing something here?

Sorry, I meant we could then add the prereqs manually for each tests that 
require it, e.g. add a single line like:

mvpg-sie.elf: snippets/mvpg.gbin

(without specifying a rule, just the dependency)

... not sure whether that works, though...

  Thomas

