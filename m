Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0DA392A2B
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 11:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhE0JDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 05:03:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235392AbhE0JDP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 05:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622106102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CiivE3Vnn0R5qTnBTFv6hBLIZ7Lvp+YBUi/WevVtdA=;
        b=dAvlHuPeu3ejahEiI5a7OQvfjtiJCoLJ+rOSXZQb9oNgUhImWarcrmVpQ7CAyz0FoBVppg
        0bOqp2eaCDmnIABZUmGwiHC8EQTPwiXNgKBfoQCo4wP/muUn+W5UAQPDVAaFw28M65jpMM
        IuHoe20rV8XnYFD47nNkzMRQnad2yC8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-oOq3_iOVNo-yhwi26e4UPA-1; Thu, 27 May 2021 05:01:39 -0400
X-MC-Unique: oOq3_iOVNo-yhwi26e4UPA-1
Received: by mail-wr1-f72.google.com with SMTP id u5-20020adf9e050000b029010df603f280so1473343wre.18
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 02:01:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5CiivE3Vnn0R5qTnBTFv6hBLIZ7Lvp+YBUi/WevVtdA=;
        b=QLQGZi8ncdwK4nWwD76LS5yIxwGuuyq0kT1VWIPjvbNlLoJuZ2P3m1NIgkqlyc5eh6
         lXdPUzKDjzKsIXA87Jhg78goc7+52DxMVIsPJrIYW4TKLk+b3tc5QxtRkoPiZLCTBA+H
         Sufp080WBuO3Moeu5Y8BvSg8IY++9GKLcQ5Jxv+mpoxf8SirrBuJqGzAFZeaCU+b8Shy
         OArFFgZCmuUxtx/np/X0FoUNxeHmbtM4EDGWL2UPV4SA6RYN6cYpt5sSwjNXM6YIdQNE
         dSudCRT6OB143bhvkY1VNzarXdKng5Nu1upjakrEjVhhwfSW46i6cgdtnkOhqRCAD2du
         KBQQ==
X-Gm-Message-State: AOAM532MffKT6BsSVWq2MfIFs5WzdY9uHn43P9R4qh2sGxSPqgVAyUzC
        S2XE+aXhrtlWhuuzc1pkNmcrJp44o/M0DguNNxO5ecynNthKLxKjtXhRm/WPZVJfq8GGML5APPc
        3Plvg/vdZYP0N
X-Received: by 2002:a5d:618f:: with SMTP id j15mr2159471wru.273.1622106098655;
        Thu, 27 May 2021 02:01:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6t06kgGMpsbHr3NQEiAmofF4RM5HNwsCcMMtfwPaaXZQqEnPOl+QpNlz9weesFO43T00x5A==
X-Received: by 2002:a5d:618f:: with SMTP id j15mr2159453wru.273.1622106098492;
        Thu, 27 May 2021 02:01:38 -0700 (PDT)
Received: from [192.168.1.36] (235.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.235])
        by smtp.gmail.com with ESMTPSA id y22sm11306208wma.36.2021.05.27.02.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 02:01:37 -0700 (PDT)
Subject: Re: Windows fails to boot after rebase to QEMU master
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20210521091451.GA6016@u366d62d47e3651.ant.amazon.com>
 <20210524055322-mutt-send-email-mst@kernel.org> <YK6hunkEnft6VJHz@work-vm>
 <d71fee00-0c21-c5e8-dbc6-00b7ace11c5a@suse.de> <YK9Y64U0wjU5K753@work-vm>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <16a5085f-868b-7e1a-f6de-1dab16103a66@redhat.com>
Date:   Thu, 27 May 2021 11:01:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YK9Y64U0wjU5K753@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/27/21 10:31 AM, Dr. David Alan Gilbert wrote:
> * Claudio Fontana (cfontana@suse.de) wrote:
>> On 5/26/21 9:30 PM, Dr. David Alan Gilbert wrote:
>>> * Michael S. Tsirkin (mst@redhat.com) wrote:
>>>> On Fri, May 21, 2021 at 11:17:19AM +0200, Siddharth Chandrasekaran wrote:
>>>>> After a rebase to QEMU master, I am having trouble booting windows VMs.
>>>>> Git bisect indicates commit f5cc5a5c1686 ("i386: split cpu accelerators
>>>>> from cpu.c, using AccelCPUClass") to have introduced the issue. I spent
>>>>> some time looking at into it yesterday without much luck.
>>>>>
>>>>> Steps to reproduce:
>>>>>
>>>>>     $ ./configure --enable-kvm --disable-xen --target-list=x86_64-softmmu --enable-debug
>>>>>     $ make -j `nproc`
>>>>>     $ ./build/x86_64-softmmu/qemu-system-x86_64 \
>>>>>         -cpu host,hv_synic,hv_vpindex,hv_time,hv_runtime,hv_stimer,hv_crash \
>>>>>         -enable-kvm \
>>>>>         -name test,debug-threads=on \
>>>>>         -smp 1,threads=1,cores=1,sockets=1 \
>>>>>         -m 4G \
>>>>>         -net nic -net user \
>>>>>         -boot d,menu=on \
>>>>>         -usbdevice tablet \
>>>>>         -vnc :3 \
>>>>>         -machine q35,smm=on \
>>>>>         -drive if=pflash,format=raw,readonly=on,unit=0,file="../OVMF_CODE.secboot.fd" \
>>>>>         -drive if=pflash,format=raw,unit=1,file="../OVMF_VARS.secboot.fd" \
>>>>>         -global ICH9-LPC.disable_s3=1 \
>>>>>         -global driver=cfi.pflash01,property=secure,value=on \
>>>>>         -cdrom "../Windows_Server_2016_14393.ISO" \
>>>>>         -drive file="../win_server_2016.qcow2",format=qcow2,if=none,id=rootfs_drive \
>>>>>         -device ahci,id=ahci \
>>>>>         -device ide-hd,drive=rootfs_drive,bus=ahci.0
>>>>>
>>>>> If the issue is not obvious, I'd like some pointers on how to go about
>>>>> fixing this issue.
>>>>>
>>>>> ~ Sid.
>>>>>
>>>>
>>>> At a guess this commit inadvertently changed something in the CPU ID.
>>>> I'd start by using a linux guest to dump cpuid before and after the
>>>> change.
>>>
>>> I've not had a chance to do that yet, however I did just end up with a
>>> bisect of a linux guest failure bisecting to the same patch:
>>>
>>> [dgilbert@dgilbert-t580 qemu]$ git bisect bad
>>> f5cc5a5c168674f84bf061cdb307c2d25fba5448 is the first bad commit
>>> commit f5cc5a5c168674f84bf061cdb307c2d25fba5448
>>> Author: Claudio Fontana <cfontana@suse.de>
>>> Date:   Mon Mar 22 14:27:40 2021 +0100
>>>
>>>     i386: split cpu accelerators from cpu.c, using AccelCPUClass
>>>     
>>>     i386 is the first user of AccelCPUClass, allowing to split
>>>     cpu.c into:
>>>     
>>>     cpu.c            cpuid and common x86 cpu functionality
>>>     host-cpu.c       host x86 cpu functions and "host" cpu type
>>>     kvm/kvm-cpu.c    KVM x86 AccelCPUClass
>>>     hvf/hvf-cpu.c    HVF x86 AccelCPUClass
>>>     tcg/tcg-cpu.c    TCG x86 AccelCPUClass

Well this is a big commit... I'm not custom to x86 target, and am
having hard time following the cpu host/max change.

Is it working when you use '-cpu max,...' instead of '-cpu host,'?

