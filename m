Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D18012A634
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 06:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfLYFjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Dec 2019 00:39:18 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35773 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfLYFjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Dec 2019 00:39:18 -0500
Received: by mail-pf1-f195.google.com with SMTP id i23so6217341pfo.2
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2019 21:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Kr75G0dJMpzW2xt1gSy/8q0zSaUTw7HkCjIQQDeq6VQ=;
        b=V8nQPF1sfLH2JAe4P5RCePSJEX2JpUUHDsTrpMAB+I0upYI1xR19lj9g7KMXSaQAHU
         Je1djGxU1k+PG9Zx4sBt5uVm9PDgUHCe5g3fUFcTzCLPjZmnUyTNMX2fCEVe+zV/xpC8
         qVutP1L4AzgPjuvZfhWoIxDCjDOuSAuTqkTWzf8e756TfpONv/knGeturzOz3oIdu37R
         4ZuLRZt/BYnXZvy1TbNupqh6jYMhT4PxFsWDyUmcF/K8i3LfvOigBrNRnv4Gbdx3KIpU
         b3nGmJi8g8lv7x4CSQbR+b4epZ2Qf6i8eVNR11fKo35rhWG1npIynwqy2+IiKLsMVrXi
         /J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Kr75G0dJMpzW2xt1gSy/8q0zSaUTw7HkCjIQQDeq6VQ=;
        b=gqPY+GeHObwiJ2+86m8hXSZ1YxqypDgaVbWaVmcrhnUBVQRCv/V1EDUgzg9wTz2lga
         IyOBatimVQUFQF+7W1VBOZD8uIUfxiHp69LZnMW3DlsDRY8r1esw9ttex9yIZtSDcP+Q
         blk/a/GCM4WHVVyANVg5Xww5z89GnhLgRRgUI70/Kox11JphhxC3DdAcLSji43ZLjNVr
         WxMRpX+YWA64hpSCJWOC+ENk6Wdj5OVfxbc/mNrQUxHxXjEaHhPCITaGgc52/73nMUY/
         Ypc77dTTxZVQnUXQqOItDrJmFuOeA6r6Vbn9QCgFS0SweGBpESeyBWrYHpCrBFmne7WV
         gopQ==
X-Gm-Message-State: APjAAAVvTeT5rtCGY+tQvbnvAl8Di9Efzzzn9PKFGMgvZWSkI4LCSyud
        E0taFaXdBc/YH78LWYSeHuldVIk=
X-Google-Smtp-Source: APXvYqxRK2hrmz6k6KMy9zjtPV/aBxYhizRGpC2wWL5D5nBXjx/N5tEqkWQ3xCM0Hxt26JlsL4QTkg==
X-Received: by 2002:a63:4b49:: with SMTP id k9mr41086988pgl.269.1577252357718;
        Tue, 24 Dec 2019 21:39:17 -0800 (PST)
Received: from [127.0.0.1] ([203.205.141.53])
        by smtp.gmail.com with ESMTPSA id a14sm29967852pfn.22.2019.12.24.21.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 21:39:17 -0800 (PST)
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [kvm-unit-tests] ./run_tests.sh error?
Message-ID: <46d9112f-1520-0d81-e109-015b7962b1a7@gmail.com>
Date:   Wed, 25 Dec 2019 13:38:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When i run ./run_tests.sh, i get output like this:

SKIP apic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No 
such file or directory)
SKIP ioapic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': 
No such file or directory)
SKIP apic (qemu: could not open kernel file '_NO_FILE_4Uhere_': No such 
file or directory)
......

Seems like the code below causing of "SKIP" above.

file: scripts/runtime.bash

# We assume that QEMU is going to work if it tried to load the kernel
premature_failure()
{
     local log="$(eval $(get_cmdline _NO_FILE_4Uhere_) 2>&1)"

     echo "$log" | grep "_NO_FILE_4Uhere_" |
         grep -q -e "could not load kernel" -e "error loading" &&
         return 1

     RUNTIME_log_stderr <<< "$log"

     echo "$log"
     return 0
}

get_cmdline()
{
     local kernel=$1
     echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel 
$RUNTIME_arch_run $kernel -smp $smp $opts"
}

function run()
{
...
     last_line=$(premature_failure > >(tail -1)) && {
         print_result "SKIP" $testname "" "$last_line"
         return 77
     }
...
}

Is that proper? What can i do?

What i did:

1. git clone git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
2. cd kvm-unit-tests/
3. git checkout -b next origin/next
4. ./configure
5. make
6. ./run_test.sh

Related config file:

# cat config.mak
SRCDIR=/data/kvm-unit-tests
PREFIX=/usr/local
HOST=x86_64
ARCH=x86_64
ARCH_NAME=x86_64
PROCESSOR=x86_64
CC=gcc
CXX=g++
LD=ld
OBJCOPY=objcopy
OBJDUMP=objdump
AR=ar
ADDR2LINE=addr2line
API=yes
TEST_DIR=x86
FIRMWARE=
ENDIAN=
PRETTY_PRINT_STACKS=yes
ENVIRON_DEFAULT=yes
ERRATATXT=errata.txt
U32_LONG_FMT=
