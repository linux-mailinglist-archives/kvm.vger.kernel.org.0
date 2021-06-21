Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712823AE91D
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 14:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhFUMe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 08:34:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41313 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhFUMe5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 08:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624278762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HGMUbfnGyMMTYCkdzbsRQAbBw7iAtTsxA7NUShiOjV8=;
        b=hjF7CS5y3UNZ0RetqCAXAtvwh70CcKElZlGQtTQZ+RddgJcjhTMAIkEfFzx1mlWPnTEwdR
        6XYzdSs7k2530yytRjYLitHsRUbH6YuGRbG++UVSRu9f3YYqhhAnSQDOmOEn+gKiFiLRpQ
        0YXwmgXooXf3F46QtiHrfc0OW2gubw8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-heO4kubiNx2vtFfzNKpQ3A-1; Mon, 21 Jun 2021 08:32:39 -0400
X-MC-Unique: heO4kubiNx2vtFfzNKpQ3A-1
Received: by mail-wr1-f69.google.com with SMTP id d5-20020a0560001865b0290119bba6e1c7so8382627wri.20
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 05:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HGMUbfnGyMMTYCkdzbsRQAbBw7iAtTsxA7NUShiOjV8=;
        b=DN7j1Ggx0uh6S7xToW1lhOPnLEkcR/OmqyijlEyWcN8kTSDqoWj0C2plc/GC2T6cGZ
         nApXB5JXoWHfR1KiG+lyRckYEKpsfxpmbPR1ipwmxMb6uPYhJSf04nht+83/A2f72DDi
         K6WUp//HPvdcDatJBI8YMbtAZDDUYT8elGMtIle2t2rXaMkG5Q0sDXMhg3M2C8gjRTr+
         LvSG9Vu1z2mCgbtnkrURL8I/p6EVQ5C1z5il+3Wnwsu0WTYfz0nmzVZOrMr1vhiJGCPY
         jKFtpy1p47GlzPKxZ50gRt+VK56JGU8a2ox+5iGjSLHwcYCE14OVuDBFPIeZUoNiFhxm
         TJUQ==
X-Gm-Message-State: AOAM532crxs7UyaTYpv6rcmK32xIzcQSaHdTf950D7VbTGz/zVeLqYJO
        /CfbqorJVkLdYL25R4jhMTcaUxcTs/rCL9MLI8UJUkWwpj/pBe2V6Hy71dnEGcUPBnTE33isU7s
        35c/cKuxdCia5
X-Received: by 2002:adf:c790:: with SMTP id l16mr28684559wrg.121.1624278758691;
        Mon, 21 Jun 2021 05:32:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0Pu4Md5BGN+GMcXUudxysZZePKneAHE0UWjhUhVHFjY8rZs/njwyRama1WyTFbF6RFmX5vQ==
X-Received: by 2002:adf:c790:: with SMTP id l16mr28684531wrg.121.1624278758453;
        Mon, 21 Jun 2021 05:32:38 -0700 (PDT)
Received: from thuth.remote.csb (pd9575fcd.dip0.t-ipconnect.de. [217.87.95.205])
        by smtp.gmail.com with ESMTPSA id y189sm3959076wmg.6.2021.06.21.05.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 05:32:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC 1/2] s390x: Add guest snippet support
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210520094730.55759-1-frankja@linux.ibm.com>
 <20210520094730.55759-2-frankja@linux.ibm.com>
 <b5171773-afb6-e148-a82f-ea78877206ce@redhat.com>
 <d20e7f88-dcca-67ca-17e0-7c45982aa5ff@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <304a297a-c366-9d61-9d13-fc1f86dd4f50@redhat.com>
Date:   Mon, 21 Jun 2021 14:32:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d20e7f88-dcca-67ca-17e0-7c45982aa5ff@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/06/2021 14.19, Janosch Frank wrote:
> On 6/21/21 12:10 PM, Thomas Huth wrote:
>> On 20/05/2021 11.47, Janosch Frank wrote:
>>> Snippets can be used to easily write and run guest (SIE) tests.
>>> The snippet is linked into the test binaries and can therefore be
>>> accessed via a ptr.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    .gitignore                |  2 ++
>>>    s390x/Makefile            | 28 ++++++++++++++++++---
>>>    s390x/snippets/c/cstart.S | 13 ++++++++++
>>>    s390x/snippets/c/flat.lds | 51 +++++++++++++++++++++++++++++++++++++++
>>>    4 files changed, 91 insertions(+), 3 deletions(-)
>>>    create mode 100644 s390x/snippets/c/cstart.S
>>>    create mode 100644 s390x/snippets/c/flat.lds
>>>
>>> diff --git a/.gitignore b/.gitignore
>>> index 784cb2dd..29d3635b 100644
>>> --- a/.gitignore
>>> +++ b/.gitignore
>>> @@ -22,3 +22,5 @@ cscope.*
>>>    /api/dirty-log
>>>    /api/dirty-log-perf
>>>    /s390x/*.bin
>>> +/s390x/snippets/*/*.bin
>>> +/s390x/snippets/*/*.gbin
>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>> index 8de926ab..fe267011 100644
>>> --- a/s390x/Makefile
>>> +++ b/s390x/Makefile
>>> @@ -75,11 +75,33 @@ OBJDIRS += lib/s390x
>>>    asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
>>>    
>>>    FLATLIBS = $(libcflat)
>>> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>>> +
>>> +SNIPPET_DIR = $(TEST_DIR)/snippets
>>> +
>>> +# C snippets that need to be linked
>>> +snippets-c =
>>> +
>>> +# ASM snippets that are directly compiled and converted to a *.gbin
>>> +snippets-a =
>>
>> Could you please call this snippets-s instead of ...-a ? The -a suffix looks
>> like an archive to me otherwise.
> 
> Sure
> 
>>
>>> +snippets = $(snippets-a)$(snippets-c)
>>
>> Shouldn't there be a space between the two?
> 
> Yes, already fixed that a long while ago
> I thought I had sent out a new version already, maybe that was an
> illusion as I can't seem to find it right now.
> 
>>
>>> +snippets-o += $(patsubst %.gbin,%.o,$(snippets))
>>> +
>>> +$(snippets-a): $(snippets-o) $(FLATLIBS)
>>> +	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>>> +
>>> +$(snippets-c): $(snippets-o) $(SNIPPET_DIR)/c/cstart.o  $(FLATLIBS)
>>> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds \
>>> +		$(filter %.o, $^) $(FLATLIBS)
>>> +	$(OBJCOPY) -O binary $@ $@
>>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>>> +
>>> +%.elf: $(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>>>    	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
>>>    		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
>>>    	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
>>> -		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
>>> +		$(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
>>
>> Does this link the snippets into all elf files? ... wouldn't it be better to
>> restrict it somehow to the files that really need them?
> 
> Yes it does.
> I'd like to avoid having to specify a makefile rule for every test that
> uses snippets as we already have more than the mvpg one in the queue.
> 
> So I'm having Steffen looking into a solution for this problem. My first
> idea was to bring the used snippets into the unittests.cfg but I
> disliked that we then would have compile instructions in another file.
> Maybe there's a way to include that into the makefile in a clever way?

I haven't tried, but maybe you could replace the $(snippets) in the last 
line with

  $(wildcard snippets/$@.gbin)

or something similar?

  Thomas

