Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3394039B583
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 11:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFDJLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 05:11:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37544 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhFDJLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 05:11:31 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8AAFA1FD4C;
        Fri,  4 Jun 2021 09:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622797784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXJAdLmHZiklaDXBmI+ZwwQjv1UO+sMym3L2Js7/B54=;
        b=j2l/sEV6o5PYy/D/rHWl+BVUx6SrNPPQtZ5p7zuiNwgdNUi0Cf0fFFy8/CsTjnbCbokNWW
        Y8p3mGhEnS4q4rpRRevyLIQpett6A9o/tmz8MnrtX/EC1r3N9N6VKpcLZ1sRxRztMsFwrs
        CZBFfvP4XnKD6nXiROqcyzUVeQXaEXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622797784;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXJAdLmHZiklaDXBmI+ZwwQjv1UO+sMym3L2Js7/B54=;
        b=TmZ1tZh2QhPWuZ2jccsF6zPfPOXMQ+pzvEAo4INVVxMDRMaW4ou7TEEMVbnKESl+cX/tux
        emixfx09IKT0hfBA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id D8629118DD;
        Fri,  4 Jun 2021 09:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622797784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXJAdLmHZiklaDXBmI+ZwwQjv1UO+sMym3L2Js7/B54=;
        b=j2l/sEV6o5PYy/D/rHWl+BVUx6SrNPPQtZ5p7zuiNwgdNUi0Cf0fFFy8/CsTjnbCbokNWW
        Y8p3mGhEnS4q4rpRRevyLIQpett6A9o/tmz8MnrtX/EC1r3N9N6VKpcLZ1sRxRztMsFwrs
        CZBFfvP4XnKD6nXiROqcyzUVeQXaEXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622797784;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXJAdLmHZiklaDXBmI+ZwwQjv1UO+sMym3L2Js7/B54=;
        b=TmZ1tZh2QhPWuZ2jccsF6zPfPOXMQ+pzvEAo4INVVxMDRMaW4ou7TEEMVbnKESl+cX/tux
        emixfx09IKT0hfBA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 4kmKMdftuWBEZQAALh3uQQ
        (envelope-from <cfontana@suse.de>); Fri, 04 Jun 2021 09:09:43 +0000
Subject: Re: [PATCH v2 0/2] Fixes for "Windows fails to boot"
From:   Claudio Fontana <cfontana@suse.de>
To:     Cleber Rosa Junior <crosa@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210603123001.17843-1-cfontana@suse.de>
 <1da75e95-1255-652e-1ca3-d23a8f6bf392@suse.de>
 <CA+bd_6K1BOSeswTszBGJrq4Z9F_KpPsSuOL-cLbYWGAfvjPEMA@mail.gmail.com>
 <2e5edcf2-6958-82db-511c-724165a8ddfb@suse.de>
 <dd1eb78c-9534-3d00-1a51-c03f1fd3ad16@suse.de>
Message-ID: <6fb2de83-755f-f373-b0df-d72b274a33df@suse.de>
Date:   Fri, 4 Jun 2021 11:09:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <dd1eb78c-9534-3d00-1a51-c03f1fd3ad16@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/21 9:01 AM, Claudio Fontana wrote:
> On 6/4/21 8:32 AM, Claudio Fontana wrote:
>> On 6/3/21 5:10 PM, Cleber Rosa Junior wrote:
>>> On Thu, Jun 3, 2021 at 10:29 AM Claudio Fontana <cfontana@suse.de> wrote:
>>>
>>>> On 6/3/21 2:29 PM, Claudio Fontana wrote:
>>>>> v1 -> v2:
>>>>>  * moved hyperv realizefn call before cpu expansion (Vitaly)
>>>>>  * added more comments (Eduardo)
>>>>>  * fixed references to commit ids (Eduardo)
>>>>>
>>>>> The combination of Commits:
>>>>> f5cc5a5c ("i386: split cpu accelerators from cpu.c"...)
>>>>
>>>>> 30565f10 ("cpu: call AccelCPUClass::cpu_realizefn in"...)
>>>>>
>>>>> introduced two bugs that break cpu max and host in the refactoring,
>>>>> by running initializations in the wrong order.
>>>>>
>>>>> This small series of two patches is an attempt to correct the situation.
>>>>>
>>>>> Please provide your test results and feedback, thanks!
>>>>>
>>>>> Claudio
>>>>>
>>>>> Claudio Fontana (2):
>>>>>   i386: reorder call to cpu_exec_realizefn in x86_cpu_realizefn
>>>>>   i386: run accel_cpu_instance_init as instance_post_init
>>>>>
>>>>>  target/i386/cpu.c         | 89 +++++++++++++++++++++++++--------------
>>>>>  target/i386/kvm/kvm-cpu.c | 12 +++++-
>>>>>  2 files changed, 68 insertions(+), 33 deletions(-)
>>>>>
>>>>
>>>> Btw, CI/CD is all green, but as mentioned, it does not seem to catch these
>>>> kind of issues.
>>>>
>>>>
>>> Hi Claudio,
>>>
>>> Not familiar with the specifics of this bug, but can it be caught by
>>> attempting to boot an image other than Windows?  If so, we can consider
>>> adding a test along the lines of tests/acceptance/boot_linux_console.py.
>>>
>>> Thanks,
>>> - Cleber.
>>
>> Hello Cleber,
>>
>> yes, all that seems to be required is the "host" cpu, q35 machine, and the firmware ./OVMF_CODE.secboot.fd and ./OVMF_VARS.secboot.fd :
>>
>> ./build/x86_64-softmmu/qemu-system-x86_64 \
>>         -cpu host \
>>         -enable-kvm \
>>         -m 4G \
>>         -machine q35,smm=on \
>>         -drive if=pflash,format=raw,readonly=on,unit=0,file="./OVMF_CODE.secboot.fd" \
>>         -drive if=pflash,format=raw,unit=1,file="./OVMF_VARS.secboot.fd"
>>
>> With the bugged code, the firmware does not boot, and the cpu does not get into 64-bit long mode.
>> Applying the patches the firmware boots normally and we get the TianoCore Logo and text output.
>>
>> Adding something like -display none -serial stdio would also generate text in the OK case that could be "expected" by a test:
>>
>> BdsDxe: failed to load Boot0001 "UEFI QEMU DVD-ROM QM00005 " from PciRoot(0x0)/Pci(0x1F,0x2)/Sata(0x2,0xFFFF,0x0): Not Found
>>
>>>> Start PXE over IPv4.
>>
>> even without using any guest to boot at all, just the firmware.
>> I used this Fedora package for the test, containing the firmware: edk2-ovmf-20200801stable-1.fc33.noarch.rpm
>>
>> I looked briefly at tests/acceptance/boot_linux_console.py, but did not see where such a test of firmware could be inserted,
>> could you advise?
> 
> 
> Nm I think I got it, will create a new boot_OVMF_fc33.py test.
> 
> Thanks, C

Question: do all of these acceptance tests require manual launch?

At least this is what I got in my CI at:

https://gitlab.com/hw-claudio/qemu

I seem to have to explicitly click on the acceptance tests to manually launch them.
Or am I missing something?

Thanks,

Claudio
