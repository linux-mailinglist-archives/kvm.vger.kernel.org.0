Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E170A25DAE9
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgIDOEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:04:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51135 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730680AbgIDOBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 10:01:11 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-Tjc3KzjjOqqKb73piTdldg-1; Fri, 04 Sep 2020 10:01:09 -0400
X-MC-Unique: Tjc3KzjjOqqKb73piTdldg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B8111029C80
        for <kvm@vger.kernel.org>; Fri,  4 Sep 2020 14:01:08 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8286B5D9CC;
        Fri,  4 Sep 2020 14:01:05 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Compile some jobs
 out-of-tree
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com
References: <20200731094139.9364-1-thuth@redhat.com>
 <e2b61ffa-fc82-ebae-fab3-0b5022c11296@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <edc0affb-786c-ced5-db02-c7647b51dc8d@redhat.com>
Date:   Fri, 4 Sep 2020 16:01:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e2b61ffa-fc82-ebae-fab3-0b5022c11296@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/2020 13.24, Paolo Bonzini wrote:
> On 31/07/20 11:41, Thomas Huth wrote:
>> So far we only compiled all jobs in-tree in the gitlab-CI. For the code
>> that gets compiled twice (one time for 64-bit and one time for 32-bit
>> for example), we can easily move one of the two jobs to out-of-tree build
>> mode to increase the build test coverage a little bit.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  .gitlab-ci.yml | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>> index 1ec9797..6613c7b 100644
>> --- a/.gitlab-ci.yml
>> +++ b/.gitlab-ci.yml
>> @@ -19,7 +19,9 @@ build-aarch64:
>>  build-arm:
>>   script:
>>   - dnf install -y qemu-system-arm gcc-arm-linux-gnu
>> - - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
>> + - mkdir build
>> + - cd build
>> + - ../configure --arch=arm --cross-prefix=arm-linux-gnu-
>>   - make -j2
>>   - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
>>       selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
>> @@ -31,7 +33,9 @@ build-arm:
>>  build-ppc64be:
>>   script:
>>   - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
>> - - ./configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
>> + - mkdir build
>> + - cd build
>> + - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
>>   - make -j2
>>   - ACCEL=tcg ./run_tests.sh
>>       selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
>> @@ -77,7 +81,9 @@ build-x86_64:
>>  build-i386:
>>   script:
>>   - dnf install -y qemu-system-x86 gcc
>> - - ./configure --arch=i386
>> + - mkdir build
>> + - cd build
>> + - ../configure --arch=i386
>>   - make -j2
>>   - ACCEL=tcg ./run_tests.sh
>>       cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
>>
> 
> Applied, thanks.

... but never pushed?

 Thomas

