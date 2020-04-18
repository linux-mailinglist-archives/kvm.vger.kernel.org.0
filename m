Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9A71AEA3F
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 08:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDRGlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 02:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgDRGlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 02:41:32 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25F6C061A0C;
        Fri, 17 Apr 2020 23:41:31 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z6so5185150wml.2;
        Fri, 17 Apr 2020 23:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RmVpyVm4tvMIRqBwICzWZmFyQ8dvMOobXgPmm9CFolw=;
        b=SeEQ97pwDDS2QG18YxpVPoshyHL7hEdORYYYNTVUMDNt+ne561pzFLM+erblFHvUr8
         YNMa+4UEj/gfAGhAVWlnYuQpSho8LHOX6knIHVXfMusuP6clHPpOTbae/NIHLIc+j7ge
         zX0tumx2Vf3zpb4g40yQobkatc8cCThQdlXqOD3pk0vWGl5cg2mOSVvQeB77kzhkDOnO
         ARo5mHQgdOfWFYwyzr1vkETvcyOrZa1WZ14L/eWHENOK+pctdDDL3k7YhuENQWGLG+ih
         qvFNBfM1KNcxbR3BvDLVKxxkZd2Th1zUjiRUN3+lEUfxrcCS0L97vmlIG8ggjC5I0uYp
         +r7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RmVpyVm4tvMIRqBwICzWZmFyQ8dvMOobXgPmm9CFolw=;
        b=K31X6QaJaEe3t938MBynEsNuEjw0E5DK0Rgjje1v4eH1upFgyGekK1AxeUucOLQuhT
         m9Cb0LIc279f91/HeoTGA7mUGbJ0KDnaL6+IEwi8TAIcqM5ftCcMYXS8YctgPHm/4HnO
         XmMNx47anbyn2OeZwTH3WDpbnPU7rxbYT2wo3EkVuy5v0C4UbyZHbQh6FWmGOF05k8Wa
         3w+Ex9XYuyAB0yHcET442IcVlkQSHXowB7E2SchLztI1tEfyMdrdvJGvUc3CUq4HinU2
         x/6bHZYdY+O+R6vi3goInKO3e6DgL9oM5NhPmWJtguf5iqD1/BzY87D3QrFTMkte1xkC
         sCEw==
X-Gm-Message-State: AGi0PuZfGK4wWHaHMwqfevUGCKYVEw9244u1YXDkcCxi5IpOGtVJQPCV
        DY75dq49+6YbtlbF75GyazQ=
X-Google-Smtp-Source: APiQypJkQOBmxHegjic0tKnLgjpcEJMBGH4biKB+ewHzx6ZgBAIlNCIIxvr4qL7kzdAm+zvJPg4iKA==
X-Received: by 2002:a7b:c74d:: with SMTP id w13mr6573652wmk.36.1587192090020;
        Fri, 17 Apr 2020 23:41:30 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-55.inter.net.il. [84.229.155.55])
        by smtp.gmail.com with ESMTPSA id p5sm37945282wrg.49.2020.04.17.23.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 23:41:29 -0700 (PDT)
Date:   Sat, 18 Apr 2020 09:41:27 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200418064127.GB1917435@jondnuc>
References: <20200416083847.1776387-1-arilou@gmail.com>
 <20200416120040.GA3745197@rvkaganb>
 <20200416125430.GL7606@jondnuc>
 <20200417104251.GA3009@rvkaganb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200417104251.GA3009@rvkaganb>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/04/2020, Roman Kagan wrote:
>On Thu, Apr 16, 2020 at 03:54:30PM +0300, Jon Doron wrote:
>> On 16/04/2020, Roman Kagan wrote:
>> > On Thu, Apr 16, 2020 at 11:38:46AM +0300, Jon Doron wrote:
>> > > According to the TLFS:
>> > > "A write to the end of message (EOM) register by the guest causes the
>> > > hypervisor to scan the internal message buffer queue(s) associated with
>> > > the virtual processor.
>> > >
>> > > If a message buffer queue contains a queued message buffer, the hypervisor
>> > > attempts to deliver the message.
>> > >
>> > > Message delivery succeeds if the SIM page is enabled and the message slot
>> > > corresponding to the SINTx is empty (that is, the message type in the
>> > > header is set to HvMessageTypeNone).
>> > > If a message is successfully delivered, its corresponding internal message
>> > > buffer is dequeued and marked free.
>> > > If the corresponding SINTx is not masked, an edge-triggered interrupt is
>> > > delivered (that is, the corresponding bit in the IRR is set).
>> > >
>> > > This register can be used by guests to poll for messages. It can also be
>> > > used as a way to drain the message queue for a SINTx that has
>> > > been disabled (that is, masked)."
>> >
>> > Doesn't this work already?
>> >
>>
>> Well if you dont have SCONTROL and a GSI associated with the SINT then it
>> does not...
>
>Yes you do need both of these.
>
>> > > So basically this means that we need to exit on EOM so the hypervisor
>> > > will have a chance to send all the pending messages regardless of the
>> > > SCONTROL mechnaisim.
>> >
>> > I might be misinterpreting the spec, but my understanding is that
>> > SCONTROL {en,dis}ables the message queueing completely.  What the quoted
>> > part means is that a write to EOM should trigger the message source to
>> > push a new message into the slot, regardless of whether the SINT was
>> > masked or not.
>> >
>> > And this (I think, haven't tested) should already work.  The userspace
>> > just keeps using the SINT route as it normally does, posting
>> > notifications to the corresponding irqfd when posting a message, and
>> > waiting on the resamplerfd for the message slot to become free.  If the
>> > SINT is masked KVM will skip injecting the interrupt, that's it.
>> >
>> > Roman.
>>
>> That's what I was thinking originally as well, but then i noticed KDNET as a
>> VMBus client (and it basically runs before anything else) is working in this
>> polling mode, where SCONTROL is disabled and it just loops, and if it saw
>> there is a PENDING message flag it will issue an EOM to indicate it has free
>> the slot.
>
>Who sets up the message page then?  Doesn't it enabe SCONTROL as well?
>

KdNet is the one setting the SIMP and it's not setting the SCONTROL, ill 
paste output of KVM traces for the relevant MSRs

>Note that, even if you don't see it being enabled by Windows, it can be
>enabled by the firmware and/or by the bootloader.
>
>Can you perhaps try with the SeaBIOS from
>https://src.openvz.org/projects/UP/repos/seabios branch hv-scsi?  It
>enables SCONTROL and leaves it that way.
>
>I'd also suggest tracing kvm_msr events (both reads and writes) for
>SCONTROL and SIMP msrs, to better understand the picture.
>
>So far the change you propose appears too heavy to work around the
>problem of disabled SCONTROL.  You seem to be better off just making
>sure it's enabled (either by the firmware or slighly violating the spec
>and initializing to enabled from the start), and sticking to the
>existing infrastructure for posting messages.
>

I guess there is something I'm missing here but let's say the BIOS would 
have set the SCONTROL but the OS is not setting it, who is in charge of 
handling the interrupts?

>> (There are a bunch of patches i sent on the QEMU mailing list as well  where
>> i CCed you, I will probably revise it a bit but was hoping to get  KVM
>> sorted out first).
>
>I'll look through the archive, should be there, thanks.
>
>Roman.

I tried testing with both the SeaBIOS branch you have suggested and the 
EDK2, unfortunately I could not get the EDK2 build to identify my VM 
drive to boot from (not sure why)

Here is an output of KVM trace for the relevant MSRs (SCONTROL and SIMP)

QEMU Default BIOS
-----------------
  qemu-system-x86-613   [000] ....  1121.080722: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
  qemu-system-x86-613   [000] ....  1121.080722: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
  qemu-system-x86-613   [000] .N..  1121.095592: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
  qemu-system-x86-613   [000] .N..  1121.095592: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
Choose Windows DebugEntry
  qemu-system-x86-613   [001] ....  1165.185227: kvm_msr: msr_read 40000083 = 0x0
  qemu-system-x86-613   [001] ....  1165.185255: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1001 host 0
  qemu-system-x86-613   [001] ....  1165.185255: kvm_msr: msr_write 40000083 = 0xfa1001
  qemu-system-x86-613   [001] ....  1165.193206: kvm_msr: msr_read 40000083 = 0xfa1001
  qemu-system-x86-613   [001] ....  1165.193236: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1000 host 0
  qemu-system-x86-613   [001] ....  1165.193237: kvm_msr: msr_write 40000083 = 0xfa1000


SeaBIOS hv-scsci
----------------
  qemu-system-x86-656   [001] ....  1313.072714: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
  qemu-system-x86-656   [001] ....  1313.072714: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
  qemu-system-x86-656   [001] ....  1313.087752: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
  qemu-system-x86-656   [001] ....  1313.087752: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
  qemu-system-x86-656   [001] ....  1313.156675: kvm_msr: msr_read 40000083 = 0x0
  qemu-system-x86-656   [001] ....  1313.156680: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x7fffe001 host 0
Choose Windows DebugEntry
  qemu-system-x86-656   [001] ....  1313.156680: kvm_msr: msr_write 40000083 = 0x7fffe001
  qemu-system-x86-656   [001] ....  1313.162111: kvm_msr: msr_read 40000080 = 0x0
  qemu-system-x86-656   [001] ....  1313.162118: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x1 host 0
  qemu-system-x86-656   [001] ....  1313.162119: kvm_msr: msr_write 40000080 = 0x1
  qemu-system-x86-656   [001] ....  1313.246758: kvm_msr: msr_read 40000083 = 0x7fffe001
  qemu-system-x86-656   [001] ....  1313.246764: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 0
  qemu-system-x86-656   [001] ....  1313.246764: kvm_msr: msr_write 40000083 = 0x0
  qemu-system-x86-656   [001] ....  1348.904727: kvm_msr: msr_read 40000083 = 0x0
  qemu-system-x86-656   [001] ....  1348.904771: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1001 host 0
  qemu-system-x86-656   [001] ....  1348.904772: kvm_msr: msr_write 40000083 = 0xfa1001
  qemu-system-x86-656   [001] ....  1348.919170: kvm_msr: msr_read 40000083 = 0xfa1001
  qemu-system-x86-656   [001] ....  1348.919183: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1000 host 0
  qemu-system-x86-656   [001] ....  1348.919183: kvm_msr: msr_write 40000083 = 0xfa1000


  I could not get the EDK2 setup to work though
  (https://src.openvz.org/projects/UP/repos/edk2 branch hv-scsi)

It does not detect my VM hard drive not sure why (this is how i  
configured it:
  -drive file=./win10.qcow2,format=qcow2,if=none,id=drive_disk0 \
  -device virtio-blk-pci,drive=drive_disk0 \

(Is there something special i need to configure it order for it to 
  work?, I tried building EDK2 with and without SMM_REQUIRE and 
  SECURE_BOOT_ENABLE)


But in general it sounds like there is something I dont fully 
understand when SCONTROL is enabled, then a GSI is associated with this 
SintRoute.

Then when the guest triggers an EOI via the APIC we will trigger the GSI 
notification, which will give us another go on trying to copy the 
message into it's slot.

So is it the OS that is in charge of setting the EOI? If so then it 
needs to be aware of SCONTROL being enabled and just having it left set 
by the BIOS might not be enough?

Also in the TLFS (looking at v6) they mention that message queueing has 
"3 exit conditions", which will cause the hypervisor to try and attempt 
to deliver the additional messages.

The 3 exit conditions they refer to are:
* Another message buffer is queued.
* The guest indicates the “end of interrupt” by writing to the APIC’s 
   EOI register.
* The guest indicates the “end of message” by writing to the SynIC’s EOM 
   register.

Also notice this additional exit is only if there is a pending message 
and not for every EOM.

Thanks,
-- Jon.
