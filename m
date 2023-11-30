Return-Path: <kvm+bounces-3033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF857FFE32
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 23:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3312B281981
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 22:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9A361696;
	Thu, 30 Nov 2023 22:00:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF19FD48;
	Thu, 30 Nov 2023 14:00:37 -0800 (PST)
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1r8p5E-0006p6-49; Thu, 30 Nov 2023 23:00:32 +0100
Message-ID: <b3aec42f-8aa7-4589-b984-a483a80e4a42@maciej.szmigiero.name>
Date: Thu, 30 Nov 2023 23:00:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Allow XSAVES on CPUs where host doesn't use it
 due to an errata
Content-Language: en-US, pl-PL
To: Maxim Levitsky <mlevitsk@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
 <ZWTQuRpwPkutHY-D@google.com>
 <9a8e3cb95f3e1a69092746668f9643a25723c522.camel@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <9a8e3cb95f3e1a69092746668f9643a25723c522.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.11.2023 18:24, Maxim Levitsky wrote:
> On Mon, 2023-11-27 at 09:24 -0800, Sean Christopherson wrote:
>> On Thu, Nov 23, 2023, Maciej S. Szmigiero wrote:
>>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>>
>>> Since commit b0563468eeac ("x86/CPU/AMD: Disable XSAVES on AMD family 0x17")
>>> kernel unconditionally clears the XSAVES CPU feature bit on Zen1/2 CPUs.
>>>
>>> Since KVM CPU caps are initialized from the kernel boot CPU features this
>>> makes the XSAVES feature also unavailable for KVM guests in this case, even
>>> though they might want to decide on their own whether they are affected by
>>> this errata.
>>>
>>> Allow KVM guests to make such decision by setting the XSAVES KVM CPU
>>> capability bit based on the actual CPU capability
>>
>> This is not generally safe, as the guest can make such a decision if and only if
>> the Family/Model/Stepping information is reasonably accurate.
> 
> Another thing that really worries me is that the XSAVES errata is really nasty one -
> AFAIK it silently corrupts some registers.

It's not unconditional state corruption, but corruption in specific set
of conditions, all of which have to be true for it to occur [1]:
* All XMM registers were restored to the initialization value by the most
recent XRSTORS instruction because the XSTATE_BV[SSE] bit was clear.
* The state save area for the XMM registers does not contain the
initialization state.
* The value in the XMM registers match the initialization value when the
XSAVES instruction is executed.
* The MXCSR register has been modified to a value different from the
initialization value since the most recent XRSTORS instruction.

According to [2] this issue was fixed in the microcode update released on
2022-08-09.
[2] also says it is not present anymore in (at least) version 0x08301055.

> Is it better to let a broken CPU boot a broken OS (OS which demands XSAVES blindly),
> and let a silent data corruption happen than refuse to boot it completely?

It is possible that, for example, Windows only uses safe subset of this
instruction or just verifies its presence but doesn't actually use it -
it's Hyper-V (L1) that throws this HV_STATUS_CPUID_XSAVE_FEATURE_VALIDATION_ERROR
but I presume it's Windows (L2) kernel which chooses which XSAVE-family
variant to actually use.

At least in the Linux guest case the guest won't use XSAVES anyway due
to this errata.

For other guests we also don't make situation any worse than on bare metal
- if they would use XSAVES anyway in KVM they would do it when running on
bare metal too.

> I mean I understand that it is technically OS fault in this case (assuming that we
> do provide it the correct CPU family info), but still this seems like the wrong thing to do.
> 
> I guess this is one of those few cases when it makes sense for the userspace to
> override KVM's CPUID caps and force a feature - in this case at least that
> won't be KVM's fault.

I am not against making the decision in QEMU instead of doing this in KVM,
but as I said to Sean it looks like this will still require some KVM
changes since KVM seems to make various decisions depending on presence
of XSAVES bit in KVM caps and boot_cpu_has(XSAVES) rather that exclusively
based on what VMM has set in CPUID.

That's why some KVM changes will be necessary even if the actual decision
logic will be in QEMU.

My point is to make this work out-of-the box for QEMU "-cpu host" and
similar CPU models that have support for XSAVES.

The reason for this is simple:
It's not like such Windows guests throw a big error screen saying
"Please enable XSAVES or disable XSAVEC for successful boot".

Instead, they simply hang at boot leaving the user wondering what could
be wrong.

Users can get very frustrated with situation like this since they don't
know what to do - on Intel side of things look for example how people
are unable to boot recent Windows versions (both server and client) on
Intel Core 12th gen or later in KVM and how people still try random
things to fix it [3] (it's Hyper-V being picky about extended topology
information in CPUID btw).

Cloud providers often know which guest type is going to be launched in
a VM so there's no problem adding a extra QEMU "-cpu" flag for
particular cloud VM.

But for individual users having to guess which magic flags are necessary
to make particular KVM guest work makes for miserable user experience.

I think that if particular guest would work on bare metal it should
work on "-cpu host" too - no tinkering should be required for such
basic functionality as being able to successfully finish booting.

> 
> Best regards,
> 	Maxim Levitsky

Thanks,
Maciej

[1]: https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revision-guides/56323-PUB_1_01.pdf
[2]: https://google.github.io/security-research/pocs/cpus/errata/amd/1386/
[3]: https://lore.kernel.org/kvm/MN2PR12MB3023F67FF37889AB3E8885F2A0849@MN2PR12MB3023.namprd12.prod.outlook.com/
https://bugzilla.kernel.org/show_bug.cgi?id=217307
https://forums.unraid.net/topic/131838-windows-11-virtual-machine-platform-wsl2-boot-loop/


