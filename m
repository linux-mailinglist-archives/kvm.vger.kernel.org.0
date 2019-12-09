Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF30B11728F
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfLIROy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:14:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55998 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726354AbfLIROy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 12:14:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575911693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=81K9bk24zoPyAKtnlaGcX5+8D/p6g2e+305UVJ3n048=;
        b=ctq4W623DR7ELPqdu5vweMjdmmUWEb+KNWmkCZtWCxIpNwoqfhgG0Gxb/2HhMYSSeEg2Mg
        ziKGxc6qs+BKXNqESa8e5PphrxWZQ7cnVRbdvIcKQbQ6iG8gundo3Rt+z1/+M+euyoj5Yl
        ut/jh8u2MB6GKe5QmxkUDP1scpApFIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-pJcBidh4MdKserb27lQu-g-1; Mon, 09 Dec 2019 12:14:51 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3A26DBCE
        for <kvm@vger.kernel.org>; Mon,  9 Dec 2019 17:14:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A895C219;
        Mon,  9 Dec 2019 17:14:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Run 32-bit tests with KVM, too
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20191205170439.11607-1-thuth@redhat.com>
 <699a350a-3956-5757-758c-0e246d698a7d@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e319993e-4732-d3ed-bca6-054c78103a61@redhat.com>
Date:   Mon, 9 Dec 2019 18:14:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <699a350a-3956-5757-758c-0e246d698a7d@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: pJcBidh4MdKserb27lQu-g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/12/2019 18.07, Paolo Bonzini wrote:
> On 05/12/19 18:04, Thomas Huth wrote:
>> KVM works on Travis in 32-bit, too, so we can enable more tests there.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  .travis.yml | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/.travis.yml b/.travis.yml
>> index 4162366..75bcf08 100644
>> --- a/.travis.yml
>> +++ b/.travis.yml
>> @@ -34,15 +34,19 @@ matrix:
>>        env:
>>        - CONFIG="--arch=i386"
>>        - BUILD_DIR="."
>> -      - TESTS="eventinj port80 sieve tsc taskswitch umip vmexit_ple_round_robin"
>> +      - TESTS="asyncpf hyperv_stimer hyperv_synic kvmclock_test msr pmu realmode
>> +               s3 sieve smap smptest smptest3 taskswitch taskswitch2 tsc_adjust"

taskswitch and taskswitch2 are here ----------------^

>> +      - ACCEL="kvm"
>>  
>>      - addons:
>>          apt_packages: gcc gcc-multilib qemu-system-x86
>>        env:
>>        - CONFIG="--arch=i386"
>>        - BUILD_DIR="i386-builddir"
>> -      - TESTS="vmexit_mov_from_cr8 vmexit_ipi vmexit_ipi_halt vmexit_mov_to_cr8
>> -               vmexit_cpuid vmexit_tscdeadline vmexit_tscdeadline_immed"
>> +      - TESTS="tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ipi_halt
>> +               vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
>> +               vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall"
>> +      - ACCEL="kvm"
>>  
>>      - addons:
>>          apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
>>
> 
> Applied, thanks.  But there are also some 32-bit specific tests
> (taskswitch, taskswitch2, cmpxchg8b) that we may want to add.

cmpxchg8b seems to be missing in x86/unittests.cfg ... so I think it
should be added there first?

 Thomas

