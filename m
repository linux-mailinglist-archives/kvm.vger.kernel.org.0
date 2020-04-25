Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAAB1B83EA
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 08:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgDYGQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 02:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgDYGQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 02:16:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED6BC09B049;
        Fri, 24 Apr 2020 23:16:42 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so14061713wrs.9;
        Fri, 24 Apr 2020 23:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oQFch5Mo9N49j0eQY83jVPMzuSBVPNC8cjNDHo3wmIY=;
        b=Ge8Q3a5yJjczxhprkNx/bhI56q2KOBw/CWJts5LiD2qoMh/7A9I+w9Z2YgGv/e8kfL
         hAK/fC+NWLlK17cPBJU+FjMRZoO8QhlF6mPSQwGbkbch9iuBUhMMHCAJl+99DYvOVT31
         EyC3TmuvKSnbf7jZkq7fHg2XcYDzzT6GnnTl5s5dDTh2OQTsTjJP8TjUEg6MbTmMF/a0
         0lPexu2UOtSC2qtSqtmNDy/ZPYuWTri0CTxbJgxUI4R/tBb6Y6GdyOnzqQ1IRFQXA4lf
         pZ2iY7Pe2dqjVrzhuetbP3kLvgnusDz78Znw7PFKpgSTGtMRyrQ5DforZ0EhXxmYBZGi
         hrIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oQFch5Mo9N49j0eQY83jVPMzuSBVPNC8cjNDHo3wmIY=;
        b=Twp2kNMUdQg+EQyu4G77zxMKVIb0JA9Ji2mzrnNFs7kyW0c1xkrcdwY2voKch6wPWz
         l7FuN5SgU9kSuHt4NWF5KUoZzMpas0TjZtfxgv/OcKsSdgQujGaTHNx9HITHiwMva5jk
         CHydRSM3JqgvC8baL6b/OQhI7S15C6HpcAFWI/RPyxZ6RSfDqLLObqgK1U3WoCwrkdSe
         6FNIl7oFmSVo1P86WTxOR0nEx7SBs4Wh2USG7/bd/EoH7lxWMKL8hZ/uLNOLPnNQ2PTQ
         0F6DDm6iNZTj1yOZDwvaZtgr4s7W34OO8Xqk8nKDU7cLYFK+EHAmmN7kWBlUyK25d29z
         HD8Q==
X-Gm-Message-State: AGi0PubqU7pm5mifbz40vIuyIwNrhetcrmYTDKlPcdjbehykYNZVE6fd
        EPNzoY+ObF7eUyGanWZ4WK6+7v8IY5WKCQ==
X-Google-Smtp-Source: APiQypIS1X7qC4NthVH0sIGNk6C6TE6XJN1MXCHTugC8qip6VVyiPbKnAwmKUGzYwTnfGGONn3GNNw==
X-Received: by 2002:a5d:4dd1:: with SMTP id f17mr14618066wru.383.1587795399783;
        Fri, 24 Apr 2020 23:16:39 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id s14sm5581886wmh.18.2020.04.24.23.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 23:16:39 -0700 (PDT)
Date:   Sat, 25 Apr 2020 09:16:37 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200425061637.GF1917435@jondnuc>
References: <20200416083847.1776387-1-arilou@gmail.com>
 <20200416120040.GA3745197@rvkaganb>
 <20200416125430.GL7606@jondnuc>
 <20200417104251.GA3009@rvkaganb>
 <20200418064127.GB1917435@jondnuc>
 <20200424133742.GA2439920@rvkaganb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200424133742.GA2439920@rvkaganb>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/2020, Roman Kagan wrote:
>On Sat, Apr 18, 2020 at 09:41:27AM +0300, Jon Doron wrote:
>> On 17/04/2020, Roman Kagan wrote:
>> > On Thu, Apr 16, 2020 at 03:54:30PM +0300, Jon Doron wrote:
>> > > On 16/04/2020, Roman Kagan wrote:
>> > > > On Thu, Apr 16, 2020 at 11:38:46AM +0300, Jon Doron wrote:
>> > > > > According to the TLFS:
>> > > > > "A write to the end of message (EOM) register by the guest causes the
>> > > > > hypervisor to scan the internal message buffer queue(s) associated with
>> > > > > the virtual processor.
>> > > > >
>> > > > > If a message buffer queue contains a queued message buffer, the hypervisor
>> > > > > attempts to deliver the message.
>> > > > >
>> > > > > Message delivery succeeds if the SIM page is enabled and the message slot
>> > > > > corresponding to the SINTx is empty (that is, the message type in the
>> > > > > header is set to HvMessageTypeNone).
>> > > > > If a message is successfully delivered, its corresponding internal message
>> > > > > buffer is dequeued and marked free.
>> > > > > If the corresponding SINTx is not masked, an edge-triggered interrupt is
>> > > > > delivered (that is, the corresponding bit in the IRR is set).
>> > > > >
>> > > > > This register can be used by guests to poll for messages. It can also be
>> > > > > used as a way to drain the message queue for a SINTx that has
>> > > > > been disabled (that is, masked)."
>> > > >
>> > > > Doesn't this work already?
>> > > >
>> > >
>> > > Well if you dont have SCONTROL and a GSI associated with the SINT then it
>> > > does not...
>> >
>> > Yes you do need both of these.
>> >
>> > > > > So basically this means that we need to exit on EOM so the hypervisor
>> > > > > will have a chance to send all the pending messages regardless of the
>> > > > > SCONTROL mechnaisim.
>> > > >
>> > > > I might be misinterpreting the spec, but my understanding is that
>> > > > SCONTROL {en,dis}ables the message queueing completely.  What the quoted
>> > > > part means is that a write to EOM should trigger the message source to
>> > > > push a new message into the slot, regardless of whether the SINT was
>> > > > masked or not.
>> > > >
>> > > > And this (I think, haven't tested) should already work.  The userspace
>> > > > just keeps using the SINT route as it normally does, posting
>> > > > notifications to the corresponding irqfd when posting a message, and
>> > > > waiting on the resamplerfd for the message slot to become free.  If the
>> > > > SINT is masked KVM will skip injecting the interrupt, that's it.
>> > > >
>> > > > Roman.
>> > >
>> > > That's what I was thinking originally as well, but then i noticed KDNET as a
>> > > VMBus client (and it basically runs before anything else) is working in this
>> > > polling mode, where SCONTROL is disabled and it just loops, and if it saw
>> > > there is a PENDING message flag it will issue an EOM to indicate it has free
>> > > the slot.
>> >
>> > Who sets up the message page then?  Doesn't it enabe SCONTROL as well?
>> >
>>
>> KdNet is the one setting the SIMP and it's not setting the SCONTROL, ill
>> paste output of KVM traces for the relevant MSRs
>>
>> > Note that, even if you don't see it being enabled by Windows, it can be
>> > enabled by the firmware and/or by the bootloader.
>> >
>> > Can you perhaps try with the SeaBIOS from
>> > https://src.openvz.org/projects/UP/repos/seabios branch hv-scsi?  It
>> > enables SCONTROL and leaves it that way.
>> >
>> > I'd also suggest tracing kvm_msr events (both reads and writes) for
>> > SCONTROL and SIMP msrs, to better understand the picture.
>> >
>> > So far the change you propose appears too heavy to work around the
>> > problem of disabled SCONTROL.  You seem to be better off just making
>> > sure it's enabled (either by the firmware or slighly violating the spec
>> > and initializing to enabled from the start), and sticking to the
>> > existing infrastructure for posting messages.
>> >
>>
>> I guess there is something I'm missing here but let's say the BIOS would
>> have set the SCONTROL but the OS is not setting it, who is in charge of
>> handling the interrupts?
>
>SCONTROL doesn't enable the interrupts, it enables SynIC as a whole.
>The interrupts are enabled via individual SINTx msrs.  This SeaBIOS
>branch does exactly this: it enables the SynIC via SCONTROL, and then
>specific SynIC functionality via SIMP/SIEFP, but doesn't activate SINTx
>and works in polling mode.
>
>I agree that this global SCONTROL switch seems redundant but it appears
>to match the spec.
>
>> > > (There are a bunch of patches i sent on the QEMU mailing list as well  where
>> > > i CCed you, I will probably revise it a bit but was hoping to get  KVM
>> > > sorted out first).
>> >
>> > I'll look through the archive, should be there, thanks.
>> >
>> > Roman.
>>
>> I tried testing with both the SeaBIOS branch you have suggested and the
>> EDK2, unfortunately I could not get the EDK2 build to identify my VM drive
>> to boot from (not sure why)
>>
>> Here is an output of KVM trace for the relevant MSRs (SCONTROL and SIMP)
>>
>> QEMU Default BIOS
>> -----------------
>>  qemu-system-x86-613   [000] ....  1121.080722: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
>>  qemu-system-x86-613   [000] ....  1121.080722: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
>>  qemu-system-x86-613   [000] .N..  1121.095592: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
>>  qemu-system-x86-613   [000] .N..  1121.095592: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
>> Choose Windows DebugEntry
>>  qemu-system-x86-613   [001] ....  1165.185227: kvm_msr: msr_read 40000083 = 0x0
>>  qemu-system-x86-613   [001] ....  1165.185255: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1001 host 0
>>  qemu-system-x86-613   [001] ....  1165.185255: kvm_msr: msr_write 40000083 = 0xfa1001
>>  qemu-system-x86-613   [001] ....  1165.193206: kvm_msr: msr_read 40000083 = 0xfa1001
>>  qemu-system-x86-613   [001] ....  1165.193236: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1000 host 0
>>  qemu-system-x86-613   [001] ....  1165.193237: kvm_msr: msr_write 40000083 = 0xfa1000
>>
>>
>> SeaBIOS hv-scsci
>> ----------------
>>  qemu-system-x86-656   [001] ....  1313.072714: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
>>  qemu-system-x86-656   [001] ....  1313.072714: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
>>  qemu-system-x86-656   [001] ....  1313.087752: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
>>  qemu-system-x86-656   [001] ....  1313.087752: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
>
>Initialization (host == 1)
>
>>  qemu-system-x86-656   [001] ....  1313.156675: kvm_msr: msr_read 40000083 = 0x0
>>  qemu-system-x86-656   [001] ....  1313.156680: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x7fffe001 host 0
>> Choose Windows DebugEntry
>
>I guess this is a bit misplaced timewise, BIOS is still working here
>
>>  qemu-system-x86-656   [001] ....  1313.156680: kvm_msr: msr_write 40000083 = 0x7fffe001
>
>BIOS sets up message page
>
>>  qemu-system-x86-656   [001] ....  1313.162111: kvm_msr: msr_read 40000080 = 0x0
>>  qemu-system-x86-656   [001] ....  1313.162118: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x1 host 0
>>  qemu-system-x86-656   [001] ....  1313.162119: kvm_msr: msr_write 40000080 = 0x1
>
>BIOS activates SCONTROL
>
>>  qemu-system-x86-656   [001] ....  1313.246758: kvm_msr: msr_read 40000083 = 0x7fffe001
>>  qemu-system-x86-656   [001] ....  1313.246764: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 0
>>  qemu-system-x86-656   [001] ....  1313.246764: kvm_msr: msr_write 40000083 = 0x0
>
>BIOS clears message page (it's not needed once the VMBus device was
>brought up)
>
>I guess the choice of Windows DebugEntry appeared somewhere here.
>
>>  qemu-system-x86-656   [001] ....  1348.904727: kvm_msr: msr_read 40000083 = 0x0
>>  qemu-system-x86-656   [001] ....  1348.904771: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1001 host 0
>>  qemu-system-x86-656   [001] ....  1348.904772: kvm_msr: msr_write 40000083 = 0xfa1001
>
>Bootloader (debug stub?) sets up the message page
>
>>  qemu-system-x86-656   [001] ....  1348.919170: kvm_msr: msr_read 40000083 = 0xfa1001
>>  qemu-system-x86-656   [001] ....  1348.919183: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1000 host 0
>>  qemu-system-x86-656   [001] ....  1348.919183: kvm_msr: msr_write 40000083 = 0xfa1000
>
>Message page is being disabled again.
>
>I guess you only filtered SCONTROL and SIMP, skipping e.g. SVERSION,
>GUEST_OS_ID, HYPERCALL, etc., which are also part of the exchange here.
>

Right my bad :( if you want I can re-run the test with the others as 
well (do you need me to?)

>>  I could not get the EDK2 setup to work though
>>  (https://src.openvz.org/projects/UP/repos/edk2 branch hv-scsi)
>>
>> It does not detect my VM hard drive not sure why (this is how i  configured
>> it:
>>  -drive file=./win10.qcow2,format=qcow2,if=none,id=drive_disk0 \
>>  -device virtio-blk-pci,drive=drive_disk0 \
>>
>> (Is there something special i need to configure it order for it to  work?, I
>> tried building EDK2 with and without SMM_REQUIRE and  SECURE_BOOT_ENABLE)
>
>No special configuration I can think of.
>
>> But in general it sounds like there is something I dont fully understand
>> when SCONTROL is enabled, then a GSI is associated with this SintRoute.
>>
>> Then when the guest triggers an EOI via the APIC we will trigger the GSI
>> notification, which will give us another go on trying to copy the message
>> into it's slot.
>
>Right.
>
>> So is it the OS that is in charge of setting the EOI?
>
>Yes.
>
>> If so then it needs to
>> be aware of SCONTROL being enabled and just having it left set by the BIOS
>> might not be enough?
>
>Yes it needs to be aware of SCONTROL being enabled.  However, this
>awareness may be based on a pure assumption that the previous entity
>(BIOS or bootloader) did it already.
>
>> Also in the TLFS (looking at v6) they mention that message queueing has "3
>> exit conditions", which will cause the hypervisor to try and attempt to
>> deliver the additional messages.
>>
>> The 3 exit conditions they refer to are:
>> * Another message buffer is queued.
>> * The guest indicates the “end of interrupt” by writing to the APIC’s   EOI
>> register.
>> * The guest indicates the “end of message” by writing to the SynIC’s EOM
>> register.
>>
>> Also notice this additional exit is only if there is a pending message and
>> not for every EOM.
>
>This meaning of "exit" doesn't trivially correspond to what we have in
>KVM.  A write to an msr does cause a vmexit.  Then KVM notifies resample
>eventfds for all SINTs that have them set up, no matter if there's a
>pending message in the slot.  It may be slightly more optimal to only
>notify those having indicated a pending message, but I don't see the
>current behavior break anything or violate the spec, so, as EOMs are not
>used on fast paths, I woudn't bother optimizing.
>
>Roman.

Hi Roman,

So based on your answer I got to the following conclusions (correct if 
they are wrong).

First of the one in charge of setting the SCONTROL in the 1st place is 
the BIOS (I dont have a real Hyper-V setup so I cannot really debug it 
and see, not sure which BIOS they have or if we can "rip" it out and run 
it through KVM and see how things look like this way).

If the BIOS has not set the SCONTROL I would expect the OS to have 
something along the lines:
if (!(get_scontrol() & ENABLED))
     set_scontrol(ENABLED);

So I started looking through the entire Windows system looking what can 
set SCONTROL, I believe I have found the flow to be the following:

VMBus.sys imports winhv.sys (which is an export library) winhv.sys will 
set the SCONTROL prior to VMBus DriverEntry starting here is the 
complete flow:
winhv!DllInitialize -> winhv!WinHvpInitialize -> 
winhv!WinHvReportPresentHypervisor -> winhv!WinHvpConnectToSynic -> 
winhv!WinHvpEnableSynic

Eventually WinHvpEnableSynic will simply set SCONTROL (for future 
reference if anyone needs to look into how HyperV register access works 
in Windows it seems like there is an enum representing all the HyperV 
registers and to access it there are helper functions to Get/Set.
SCONTROL value in the enum is 0x0a0010 .

winhv.sys simply provides very simple API to access the Sints i.e 
(WinHvSetSint / WinHvSetEndOfMessage / WinHvSetSintOnCurrentProcessor / 
  WinHvGetSintMessage / etc.)

So basically it seems like the OS does not really care if the BIOS has 
setup the SCONTROL or not, and does so always (if it can) unfortunately 
in my flow (via kdnet) VMBus is not loaded yet and so does winhv.sys so 
they "fallback" into this Polling mode.

So that covers the OS part, after that I have tried looking for relevant 
code in bootmgr and winload (which are Windows boot loader part (like 
grub) and I could not find any code that might setup SCONTROL.

 From your experience with this did you see Hyper-V BIOS simply setting 
the SCONTROL? Perhaps if that's the case then the correct fix needs to 
be in the SeaBIOS and the EDK .

I tried to see if Hyper-V supports giving it a BIOS but could not find 
anyway of doing this, so it just might be that Hyper-V assumes the BIOS 
is in charge of setting up SCONTROL for all the boot loader components.

But in a way it sounds weird because I would expect to see KDNet working 
with the ACPI to trigger the GSI but I could not find any relevant code 
that might do that.

As I write this I think I'm starting to get your point just to make sure 
I understand it:

1. When a new SintRoute is created we associate it with a GSI
2. When an EOM is set, we trigger all the GSIs so QEMU will get 
    execution time and send all pending messages if it can.

So basically like you said everything "works" from our perspective 
regardless if the system has setup SCONTROL or not, because you trigger 
the interrupt to QEMU regardless of SCONTROL so it can clear the pending 
message.

If that's indeed the case then probably the only thing needs fixing in 
my scenario is in QEMU where it should not really care for the SCONTROL 
if it's enabled or not.

Sounds about right?

Thanks,
-- Jon.
