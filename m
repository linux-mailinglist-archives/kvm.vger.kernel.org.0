Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369921B73C1
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 14:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgDXMUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 08:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgDXMUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 08:20:35 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9582FC09B045;
        Fri, 24 Apr 2020 05:20:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b11so10533455wrs.6;
        Fri, 24 Apr 2020 05:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=P8xGO6FvtwsKZcy/9M7ngHRBNxButYM6Sd7Wr0NzqAM=;
        b=LODAtqybFfeVD7pi/3KfbPvl/yQHMQ1WeN/BimMkrFKmFwDAleRV4VsbYm8oYi+hAS
         f7wjEEpqdgeDiQ4ojaCUn+ioNkEX0D/I78/dp2EDSgNwlQoJtG5mlfNaUrBpTFXqUQ8w
         B06lLAauxAfb3hjainhxP1TALEXhinNMgNVfosPcAKxeGAOpW1a90TQ78wsih35OYOd3
         KDo9TJbM1s/OT9ZDH8pZLSt+e3KJqz6JaJptV9z60dw3F5/bPSEgEmtUcbaxuik/PdNb
         aakMZ+kQeoHqDbzRtKbNCFgWhxrN1lcRw85M5cwwi46pitXEK0JUtOx/ldVQjcm1IdY8
         kSTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=P8xGO6FvtwsKZcy/9M7ngHRBNxButYM6Sd7Wr0NzqAM=;
        b=trcYNZ8xWey5x44fYYoMMf/ahwcqvpbdUZnsnckK7owIPCtgs0tbDfb68wLsPMvU2D
         G2dIcXaAx/EgalVhS4/uTVfcDDHyQxA608NbiX4ei0RDLxLtFQEfE5HGgCKDWLXWEUkD
         YiyGugj+ihJ9OYFcw7Pu5lxyNgGrYkp3qYylIdnQAmPhNieovPPs6uoY1vKEAqQV4+GX
         Jcl+tGaKzpiG/4cH6UrskRUEWeJPzJps3rZ/dYhGbC4KgLZvJISDFS2YjaJV+DPubiaj
         ouRz4V4B6XvW6RrNbwxNliBzfNkLBLxjqqYJv7PqbEZGgsWqk2pAf4c2dwEOQtXLqR1q
         vOEQ==
X-Gm-Message-State: AGi0PuYepjJeBlC6siQiMxBiQImpij3N8drVBjdos9dCrVcFnDCzlLg0
        Rr8IBfaNdG5cQCYcXgeV6do=
X-Google-Smtp-Source: APiQypIgi/JP7UB+NS4VGbRiov8ReSLjYkP2pYkJfdgNuZVX137+z2nGMGaolZ/0vhgJQXj7kghi7Q==
X-Received: by 2002:adf:f8c6:: with SMTP id f6mr11796994wrq.276.1587730834226;
        Fri, 24 Apr 2020 05:20:34 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id z15sm7815562wrs.47.2020.04.24.05.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 05:20:33 -0700 (PDT)
Date:   Fri, 24 Apr 2020 15:20:32 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200424122032.GE1917435@jondnuc>
References: <20200416083847.1776387-1-arilou@gmail.com>
 <20200416120040.GA3745197@rvkaganb>
 <20200416125430.GL7606@jondnuc>
 <20200417104251.GA3009@rvkaganb>
 <20200418064127.GB1917435@jondnuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200418064127.GB1917435@jondnuc>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/04/2020, Jon Doron wrote:
>On 17/04/2020, Roman Kagan wrote:
>>On Thu, Apr 16, 2020 at 03:54:30PM +0300, Jon Doron wrote:
>>>On 16/04/2020, Roman Kagan wrote:
>>>> On Thu, Apr 16, 2020 at 11:38:46AM +0300, Jon Doron wrote:
>>>> > According to the TLFS:
>>>> > "A write to the end of message (EOM) register by the guest causes the
>>>> > hypervisor to scan the internal message buffer queue(s) associated with
>>>> > the virtual processor.
>>>> >
>>>> > If a message buffer queue contains a queued message buffer, the hypervisor
>>>> > attempts to deliver the message.
>>>> >
>>>> > Message delivery succeeds if the SIM page is enabled and the message slot
>>>> > corresponding to the SINTx is empty (that is, the message type in the
>>>> > header is set to HvMessageTypeNone).
>>>> > If a message is successfully delivered, its corresponding internal message
>>>> > buffer is dequeued and marked free.
>>>> > If the corresponding SINTx is not masked, an edge-triggered interrupt is
>>>> > delivered (that is, the corresponding bit in the IRR is set).
>>>> >
>>>> > This register can be used by guests to poll for messages. It can also be
>>>> > used as a way to drain the message queue for a SINTx that has
>>>> > been disabled (that is, masked)."
>>>>
>>>> Doesn't this work already?
>>>>
>>>
>>>Well if you dont have SCONTROL and a GSI associated with the SINT then it
>>>does not...
>>
>>Yes you do need both of these.
>>
>>>> > So basically this means that we need to exit on EOM so the hypervisor
>>>> > will have a chance to send all the pending messages regardless of the
>>>> > SCONTROL mechnaisim.
>>>>
>>>> I might be misinterpreting the spec, but my understanding is that
>>>> SCONTROL {en,dis}ables the message queueing completely.  What the quoted
>>>> part means is that a write to EOM should trigger the message source to
>>>> push a new message into the slot, regardless of whether the SINT was
>>>> masked or not.
>>>>
>>>> And this (I think, haven't tested) should already work.  The userspace
>>>> just keeps using the SINT route as it normally does, posting
>>>> notifications to the corresponding irqfd when posting a message, and
>>>> waiting on the resamplerfd for the message slot to become free.  If the
>>>> SINT is masked KVM will skip injecting the interrupt, that's it.
>>>>
>>>> Roman.
>>>
>>>That's what I was thinking originally as well, but then i noticed KDNET as a
>>>VMBus client (and it basically runs before anything else) is working in this
>>>polling mode, where SCONTROL is disabled and it just loops, and if it saw
>>>there is a PENDING message flag it will issue an EOM to indicate it has free
>>>the slot.
>>
>>Who sets up the message page then?  Doesn't it enabe SCONTROL as well?
>>
>
>KdNet is the one setting the SIMP and it's not setting the SCONTROL, 
>ill paste output of KVM traces for the relevant MSRs
>
>>Note that, even if you don't see it being enabled by Windows, it can be
>>enabled by the firmware and/or by the bootloader.
>>
>>Can you perhaps try with the SeaBIOS from
>>https://src.openvz.org/projects/UP/repos/seabios branch hv-scsi?  It
>>enables SCONTROL and leaves it that way.
>>
>>I'd also suggest tracing kvm_msr events (both reads and writes) for
>>SCONTROL and SIMP msrs, to better understand the picture.
>>
>>So far the change you propose appears too heavy to work around the
>>problem of disabled SCONTROL.  You seem to be better off just making
>>sure it's enabled (either by the firmware or slighly violating the spec
>>and initializing to enabled from the start), and sticking to the
>>existing infrastructure for posting messages.
>>
>
>I guess there is something I'm missing here but let's say the BIOS 
>would have set the SCONTROL but the OS is not setting it, who is in 
>charge of handling the interrupts?
>
>>>(There are a bunch of patches i sent on the QEMU mailing list as well  where
>>>i CCed you, I will probably revise it a bit but was hoping to get  KVM
>>>sorted out first).
>>
>>I'll look through the archive, should be there, thanks.
>>
>>Roman.
>
>I tried testing with both the SeaBIOS branch you have suggested and 
>the EDK2, unfortunately I could not get the EDK2 build to identify my 
>VM drive to boot from (not sure why)
>
>Here is an output of KVM trace for the relevant MSRs (SCONTROL and SIMP)
>
>QEMU Default BIOS
>-----------------
> qemu-system-x86-613   [000] ....  1121.080722: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
> qemu-system-x86-613   [000] ....  1121.080722: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
> qemu-system-x86-613   [000] .N..  1121.095592: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
> qemu-system-x86-613   [000] .N..  1121.095592: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
>Choose Windows DebugEntry
> qemu-system-x86-613   [001] ....  1165.185227: kvm_msr: msr_read 40000083 = 0x0
> qemu-system-x86-613   [001] ....  1165.185255: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1001 host 0
> qemu-system-x86-613   [001] ....  1165.185255: kvm_msr: msr_write 40000083 = 0xfa1001
> qemu-system-x86-613   [001] ....  1165.193206: kvm_msr: msr_read 40000083 = 0xfa1001
> qemu-system-x86-613   [001] ....  1165.193236: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1000 host 0
> qemu-system-x86-613   [001] ....  1165.193237: kvm_msr: msr_write 40000083 = 0xfa1000
>
>
>SeaBIOS hv-scsci
>----------------
> qemu-system-x86-656   [001] ....  1313.072714: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
> qemu-system-x86-656   [001] ....  1313.072714: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
> qemu-system-x86-656   [001] ....  1313.087752: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
> qemu-system-x86-656   [001] ....  1313.087752: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
> qemu-system-x86-656   [001] ....  1313.156675: kvm_msr: msr_read 40000083 = 0x0
> qemu-system-x86-656   [001] ....  1313.156680: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x7fffe001 host 0
>Choose Windows DebugEntry
> qemu-system-x86-656   [001] ....  1313.156680: kvm_msr: msr_write 40000083 = 0x7fffe001
> qemu-system-x86-656   [001] ....  1313.162111: kvm_msr: msr_read 40000080 = 0x0
> qemu-system-x86-656   [001] ....  1313.162118: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x1 host 0
> qemu-system-x86-656   [001] ....  1313.162119: kvm_msr: msr_write 40000080 = 0x1
> qemu-system-x86-656   [001] ....  1313.246758: kvm_msr: msr_read 40000083 = 0x7fffe001
> qemu-system-x86-656   [001] ....  1313.246764: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 0
> qemu-system-x86-656   [001] ....  1313.246764: kvm_msr: msr_write 40000083 = 0x0
> qemu-system-x86-656   [001] ....  1348.904727: kvm_msr: msr_read 40000083 = 0x0
> qemu-system-x86-656   [001] ....  1348.904771: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1001 host 0
> qemu-system-x86-656   [001] ....  1348.904772: kvm_msr: msr_write 40000083 = 0xfa1001
> qemu-system-x86-656   [001] ....  1348.919170: kvm_msr: msr_read 40000083 = 0xfa1001
> qemu-system-x86-656   [001] ....  1348.919183: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1000 host 0
> qemu-system-x86-656   [001] ....  1348.919183: kvm_msr: msr_write 40000083 = 0xfa1000
>
>
> I could not get the EDK2 setup to work though
> (https://src.openvz.org/projects/UP/repos/edk2 branch hv-scsi)
>
>It does not detect my VM hard drive not sure why (this is how i  
>configured it:
> -drive file=./win10.qcow2,format=qcow2,if=none,id=drive_disk0 \
> -device virtio-blk-pci,drive=drive_disk0 \
>
>(Is there something special i need to configure it order for it to  
>work?, I tried building EDK2 with and without SMM_REQUIRE and  
>SECURE_BOOT_ENABLE)
>
>
>But in general it sounds like there is something I dont fully 
>understand when SCONTROL is enabled, then a GSI is associated with 
>this SintRoute.
>
>Then when the guest triggers an EOI via the APIC we will trigger the 
>GSI notification, which will give us another go on trying to copy the 
>message into it's slot.
>
>So is it the OS that is in charge of setting the EOI? If so then it 
>needs to be aware of SCONTROL being enabled and just having it left 
>set by the BIOS might not be enough?
>
>Also in the TLFS (looking at v6) they mention that message queueing 
>has "3 exit conditions", which will cause the hypervisor to try and 
>attempt to deliver the additional messages.
>
>The 3 exit conditions they refer to are:
>* Another message buffer is queued.
>* The guest indicates the “end of interrupt” by writing to the APIC’s   
>EOI register.
>* The guest indicates the “end of message” by writing to the SynIC’s 
>EOM   register.
>
>Also notice this additional exit is only if there is a pending message 
>and not for every EOM.
>
>Thanks,
>-- Jon.

Hi Roman

Any other thoughts/suggestions about this?

Thanks,
-- Jon.
