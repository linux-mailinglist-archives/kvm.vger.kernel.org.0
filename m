Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15FD452F6C
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhKPKsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:48:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234415AbhKPKsh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 05:48:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637059539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bJ0yxpYWqFgGYpyQ9Uz4am/w+VLqvG2OeDs3vE5Tjm8=;
        b=W2uY/OT98dWo1yOGF2fUPkK03fj5LpUhV5zSHq0EXhKu9maWlca9UkoCpFLU8DalQXvc8q
        8LlGiORNXqHxoVnamKecpvbdEbe2QmZW5wQhbWJCWFTK1sbvrraVqP+vhz/0lDysC4Gt6u
        x/Lam78wlIGkZAaLBgAFsa1TUtGLddo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-j4ZqkTLYOtyHvNspPNVS6Q-1; Tue, 16 Nov 2021 05:45:36 -0500
X-MC-Unique: j4ZqkTLYOtyHvNspPNVS6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 153EA18D6A2A;
        Tue, 16 Nov 2021 10:45:35 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10C6F77E26;
        Tue, 16 Nov 2021 10:45:33 +0000 (UTC)
Message-ID: <74308670-758a-a11b-7951-262f9d5025f9@redhat.com>
Date:   Tue, 16 Nov 2021 11:45:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Test PMU virtualization on
 emulated instructions
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org
References: <20211112235652.1127814-1-jmattson@google.com>
 <d0e12764-d426-d38f-5530-a1ee9795a285@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d0e12764-d426-d38f-5530-a1ee9795a285@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 11:04, Like Xu wrote:
>>
>> +check = /sys/module/kvm_intel/parameters/force_emulation_prefix=Y
> 
> It's "/sys/module/kvm/parameters/force_emulation_prefix=Y",
> 
> If it's N, we need a output like "FAIL: check_emulated_instr"
> rather than:
> 
> Unhandled exception 6 #UD at ip 0000000000401387
> error_code=0000      rflags=00010046      cs=00000008
> rax=0000000000000000 rcx=00000000000000c2 rdx=00000000ffffffff 
> rbx=00000000009509f4
> rbp=0000000000513730 rsi=0000000000000020 rdi=0000000000000034
>   r8=0000000000000000  r9=0000000000000020 r10=000000000000000d 
> r11=0000000000000000
> r12=000000000000038e r13=0000000000000002 r14=0000000000513d80 
> r15=0000000000008603
> cr0=0000000080010011 cr2=0000000000000000 cr3=0000000001007000 
> cr4=0000000000000020
> cr8=0000000000000000
>      STACK: @401387 400384
> 
>> +check = /proc/sys/kernel/nmi_watchdog=0 

Only one check is supported.  However, this test does not need all 
counters, so we can remove the NMI watchdog line.  I'll send a patch 
shortly.

Paolo

