Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387A412BC7F
	for <lists+kvm@lfdr.de>; Sat, 28 Dec 2019 05:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfL1EEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Dec 2019 23:04:02 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43479 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfL1EEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Dec 2019 23:04:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id x6so14530911pfo.10
        for <kvm@vger.kernel.org>; Fri, 27 Dec 2019 20:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=unKwjVX58aHg8DMIrAURSwrvPo/ujt68tFteFFaRzT8=;
        b=JwNHlk4ss/e6emfRiXK21hJRZgIHuJ3WwUWjSe/ZAyt0JiXM4xE6HKMqFZTcw79s8l
         1whRAYVtU0WRSi//D8HganT0poO/iSGLjnBjCz2cFGzDddMhLNZjiQvMLb+jbdDKHz1a
         mhP5lUuGgSyakkCE+op+9k+9vTR3eJjJwkir0Y2Ovmk424DBWZodmEzJ9So1UDwTUI2h
         UpnC30q/XZeZXcQ3R0dYehLFJtlY2TzhChCdj4/5ERFnEm1iSpvcTPwRS2H2bkZvQFBN
         tf2K+S10tUmn3jVsNltXW2FaxE93Ik2ZLN2uiJ8o0D4HGpB2J2dhqRJM7pMzZ7iE3CNt
         uWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=unKwjVX58aHg8DMIrAURSwrvPo/ujt68tFteFFaRzT8=;
        b=Hhh0FmDgBygWSMaxNz+5C1+DGUSdA2YNBcl4905qrA3cdsrd329cvhnDcIEX31Ff0/
         LDwrC0UrDWC0Xn4l6ReWNRayZY9/KjzCvy10tVJVqLzvCWkEZmHYwiwMQivhr5cDxFHt
         2VH5X038VYF/JSSHFhUokpEKPmfwNGPQjzU2/uNrjOx8kDTmt7NcB7QbK8AwqvI34h88
         vYNB2R+0TsVR5Gumaf+iH6gkv+/Ckm+yNlRYqzKqYYXrFkBEV/hogQKL31v7dLaDhNCr
         C9kraqcoKAI7FiJFrIfwqH6A34339tPQ2ttrRqbVrjQdTSFveMAegvfRg6yrasY223ca
         4nYA==
X-Gm-Message-State: APjAAAVr3Le2c1rWp3QfoK1Ep779iM/uZB7bJXJq64F/RduCm9bBKr+K
        aquJfxQAO1zIiVSJ7BK3jD2d/V4=
X-Google-Smtp-Source: APXvYqx6YPuFp8f+ML3IpoBYtJ4hmsCzds5BQRDAKSyn1Q4ZWUh+JVUsmAHluRS4BEUxPm/X+bflcA==
X-Received: by 2002:a63:d041:: with SMTP id s1mr59037716pgi.363.1577505841933;
        Fri, 27 Dec 2019 20:04:01 -0800 (PST)
Received: from [127.0.0.1] ([203.205.141.40])
        by smtp.gmail.com with ESMTPSA id z13sm16119045pjz.15.2019.12.27.20.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2019 20:04:01 -0800 (PST)
Subject: Re: [kvm-unit-tests] ./run_tests.sh error?
To:     Andrew Jones <drjones@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <46d9112f-1520-0d81-e109-015b7962b1a7@gmail.com>
 <20191227124619.5kbs5l7gooei6lgp@kamzik.brq.redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <749f42d9-f8d1-8449-705e-2d5dff0d8b7b@gmail.com>
Date:   Sat, 28 Dec 2019 12:03:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191227124619.5kbs5l7gooei6lgp@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/12/27 20:46, Andrew Jones wrote:
> On Wed, Dec 25, 2019 at 01:38:53PM +0800, Haiwei Li wrote:
>> When i run ./run_tests.sh, i get output like this:
>>
>> SKIP apic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No
>> such file or directory)
>> SKIP ioapic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No
>> such file or directory)
>> SKIP apic (qemu: could not open kernel file '_NO_FILE_4Uhere_': No such file
>> or directory)
>> ......
>>
>> Seems like the code below causing of "SKIP" above.
>>
>> file: scripts/runtime.bash
>>
>> # We assume that QEMU is going to work if it tried to load the kernel
>> premature_failure()
>> {
>>      local log="$(eval $(get_cmdline _NO_FILE_4Uhere_) 2>&1)"
>>
>>      echo "$log" | grep "_NO_FILE_4Uhere_" |
>>          grep -q -e "could not load kernel" -e "error loading" &&
>>          return 1
>>
>>      RUNTIME_log_stderr <<< "$log"
>>
>>      echo "$log"
>>      return 0
>> }
>>
>> get_cmdline()
>> {
>>      local kernel=$1
>>      echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run
>> $kernel -smp $smp $opts"
>> }
>>
>> function run()
>> {
>> ...
>>      last_line=$(premature_failure > >(tail -1)) && {
>>          print_result "SKIP" $testname "" "$last_line"
>>          return 77
>>      }
>> ...
>> }
>>
>> Is that proper? What can i do?
>>
>> What i did:
>>
>> 1. git clone git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
>> 2. cd kvm-unit-tests/
>> 3. git checkout -b next origin/next
>> 4. ./configure
>> 5. make
>> 6. ./run_test.sh
>>
>> Related config file:
>>
>> # cat config.mak
>> SRCDIR=/data/kvm-unit-tests
>> PREFIX=/usr/local
>> HOST=x86_64
>> ARCH=x86_64
>> ARCH_NAME=x86_64
>> PROCESSOR=x86_64
>> CC=gcc
>> CXX=g++
>> LD=ld
>> OBJCOPY=objcopy
>> OBJDUMP=objdump
>> AR=ar
>> ADDR2LINE=addr2line
>> API=yes
>> TEST_DIR=x86
>> FIRMWARE=
>> ENDIAN=
>> PRETTY_PRINT_STACKS=yes
>> ENVIRON_DEFAULT=yes
>> ERRATATXT=errata.txt
>> U32_LONG_FMT=
>>
> 
> You need https://patchwork.kernel.org/patch/11284587/ for this issue. But
> I just tried a latest qemu on x86 and see tests are hanging. So that may
> not be enough to get you running.
> 
> drew
> 

Thanks a lot. It's ok to run. The qemu i use is based on the commit 
"2061735ff09f9d5e67c501a96227b470e7de69b1".

Haiwei Li
