Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88C3486571
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 14:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbiAFNnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 08:43:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230323AbiAFNn3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 08:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641476608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vwu9jNYrNnolW/E72Q9BsJxRzWddMKgn695+ZFMGqxQ=;
        b=U8r6XfsIQNJSoiRIy+8+Z+EPKU/VE9IMNPft4LBBlHBZEtOjql/r0LOLptIv8BCg5A8kI5
        yU+RiF2ZEjoFSsR7+OEVlY/UXpfzLF/EZg/lQHuaOPZY7nuV0Qs1Mha5MDDOLdu3H3ekD+
        h0C1ioVsMiisO0lnxqA/mxxa9Bp/vNA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-8R-JiD8POS6iDQFOEH6KPQ-1; Thu, 06 Jan 2022 08:43:25 -0500
X-MC-Unique: 8R-JiD8POS6iDQFOEH6KPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 244C0100CCC6;
        Thu,  6 Jan 2022 13:43:24 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D583172417;
        Thu,  6 Jan 2022 13:43:22 +0000 (UTC)
Message-ID: <deb5cbc0a5dff445de9d3d5ae7b4d33b9f362c67.camel@redhat.com>
Subject: Re: [Bug 215459] VM freezes starting with kernel 5.15
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
Date:   Thu, 06 Jan 2022 15:43:21 +0200
In-Reply-To: <bug-215459-28872-vsF1SPQyry@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
         <bug-215459-28872-vsF1SPQyry@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-01-06 at 13:12 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215459
> 
> --- Comment #2 from th3voic3@mailbox.org ---
> (In reply to mlevitsk from comment #1)
> > On Thu, 2022-01-06 at 11:03 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=215459
> > > 
> > >             Bug ID: 215459
> > >            Summary: VM freezes starting with kernel 5.15
> > >            Product: Virtualization
> > >            Version: unspecified
> > >     Kernel Version: 5.15.*
> > >           Hardware: Intel
> > >                 OS: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: kvm
> > >           Assignee: virtualization_kvm@kernel-bugs.osdl.org
> > >           Reporter: th3voic3@mailbox.org
> > >         Regression: No
> > > 
> > > Created attachment 300234 [details]
> > >   --> https://bugzilla.kernel.org/attachment.cgi?id=300234&action=edit
> > > qemu.hook and libvirt xml
> > > 
> > > Hi,
> > > 
> > > starting with kernel 5.15 I'm experiencing freezes in my VFIO Windows 10
> > VM.
> > > Downgrading to 5.14.16 fixes the issue.
> > > 
> > > I can't find any error messages in dmesg when this happens and comparing
> > the
> > > dmesg output between 5.14.16 and 5.15.7 didn't show any differences.
> > > 
> > > 
> > > Additional info:
> > > * 5.15.x
> > > * I'm attaching my libvirt config and my /etc/libvirt/hooks/qemu
> > > * My specs are:
> > > ** i7-10700k
> > > ** ASUS z490-A PRIME Motherboard
> > > ** 64 GB RAM
> > > ** Passthrough Card: NVIDIA 2070 Super
> > > ** Host is using the integrated Graphics chip
> > > 
> > > Steps to reproduce:
> > > Boot any 5.15 kernel and start the VM and after some time (no specific
> > > trigger
> > > as far as I can see) the VM freezes.
> > > 
> > > After some testing the solution seems to be:
> > > 
> > > I read about this:
> > > 20210713142023.106183-9-mlevitsk@redhat.com/#24319635">
> > > 
> > > 
> > https://patchwork.kernel.org/project/kvm/patch/20210713142023.106183-9-mlevitsk@redhat.com/#24319635
> > > And so I checked
> > > cat /sys/module/kvm_intel/parameters/enable_apicv
> > > 
> > > which returns Y to me by default.
> > > 
> > > So I added
> > > options kvm_intel enable_apicv=0
> > > to /etc/modprobe.d/kvm.conf
> > > 
> > > 
> > > cat /sys/module/kvm_intel/parameters/enable_apicv
> > > now returns N
> > > 
> > > So far I haven't encountered any freezes.
> > > 
> > > The confusing part is that APICv shouldn't be available with my CPU
> > 
> > I guess you are lucky and your cpu has it? 
> > Does /sys/module/kvm_intel/parameters/enable_apicv show Y on 5.14.16 as well?
> Yep just checked again.
> 
> > I know that there were few fixes in regard to posted interrupts on intel,
> > which might explain the problem.
> I tried checking with
> for i in $(find /sys/class/iommu/dmar* -type l); do echo -n "$i: "; echo $(( (
> 0x$(cat $i/intel-iommu/cap) >> 59 ) & 1 )); done
> cat: /intel-iommu/cap: No such file or directory
> /sys/class/iommu/dmar0: 0
> /sys/class/iommu/dmar1: 0
> 
> 
> So posted interrupts don't work on my system anyways?

Yes and no.

APICv consists of 4 parts:

1. virtualization of host->guest interrupts.

That allows KVM to deliver interrupts to a vCPU without VMexit,
interrupts that can be sent from say main qemu thread or from iothread,
or from in-kernel timers, etc.
As long as the sender runs on a different core, you get VMexit less interrupt.
If enable_apicv is true, your cpu ought to have this.

2. virtualization of apic registers.
That allows to avoid VM exits on some guest apic acceses like writing EOI
register, and such. Very primitive support for this exits even without APIVc,
called FlexPriority/TPR virtualization.

3. virtualization of IPIs (inter process interrupts)
Intel currenlty only supports self-ipi, where a vCPU sends an interrupt to itself,
and it seems that finally they on track to support ful IPI virtualization.

4. Delivery of interrupts from passed-through devices to VM through virtual apic.
That feature apparently you don't have enabled. Its optional but still very nice to
have.

So you are lucky to have quite working APICv, and once it works for you
it should help with latency overall.

I think that this might be related to
"KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU"


There was a thread on the mailing list about exact same issue you are facing
APICv enabled but have a pass through device which doesn't use posted interrupts
Can't seem to find the thread now.

This patch actualy fixed the issue, but I haven't fully followed on what
commit introduced the issue.

I also wonder if the same issue can happen on AVIC.

Best reards,
	Maxim Levitsky


> 
> 
> > You might want to try 5.16 kernel when it released.
> I will definitely check again thanks.
> 
> Assuming I really do have APICv: is there anything I need to change in my XML
> to really make use of this feature or does it work "out of the box"?
> 


