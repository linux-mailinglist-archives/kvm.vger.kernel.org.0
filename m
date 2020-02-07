Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E302155BFD
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgBGQlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 11:41:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44814 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726899AbgBGQlD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 11:41:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581093661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KLw84JamFXxTYOYT1lI/KNTbP0GLtRLhI/CF9cl/vAU=;
        b=BGbhNcLgMidI2S0PghD6dnwpNizkjomyr5ubTzoeSUlCa11CaPxEqriSkt4e0yOrAKH8A+
        07xjCCG9lr0fk2PaD2fU6RPv+jM8OnqvIHTf3J+oNuH+i+j5Ym+mYnNMfcJIk1pfI8318X
        4wHMO7nU5t57UXY9zvWOdLb+7VZofkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-XPhO6Dh_PYqgWkAdJOj71Q-1; Fri, 07 Feb 2020 11:40:57 -0500
X-MC-Unique: XPhO6Dh_PYqgWkAdJOj71Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2D0F10054E3
        for <kvm@vger.kernel.org>; Fri,  7 Feb 2020 16:40:56 +0000 (UTC)
Received: from paraplu.localdomain (ovpn-116-47.ams2.redhat.com [10.36.116.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D5685DA87;
        Fri,  7 Feb 2020 16:40:56 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id 39C223E048C; Fri,  7 Feb 2020 17:40:54 +0100 (CET)
Date:   Fri, 7 Feb 2020 17:40:54 +0100
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH] docs/virt/kvm: Document running nested guests
Message-ID: <20200207164054.GB30317@paraplu>
References: <20200207153002.16081-1-kchamart@redhat.com>
 <20200207160157.GI3302@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207160157.GI3302@work-vm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 04:01:57PM +0000, Dr. David Alan Gilbert wrote:
> * Kashyap Chamarthy (kchamart@redhat.com) wrote:

[...]

> > +Running nested guests with KVM
> > +==============================
> > +
> > +A nested guest is a KVM guest that in turn runs on a KVM guest::
> 
> Note nesting maybe a little more general; e.g. L1 might be another
> OS/hypervisor that wants to run it's own L2; and similarly
> KVM might be the L1 under someone elses hypervisor.

True, I narrowly focused on KVM-on-KVM.

Will take this approach: I'll mention the generic nature of nesting, but
focus on KVM-on-KVM in this document.
 
> I think this doc is mostly about the case of KVM being the L0
> and wanting to run an L1 that's capable of running an L2.
>
> > +              .----------------.  .----------------.
> > +              |                |  |                |
> > +              |      L2        |  |      L2        |
> > +              | (Nested Guest) |  | (Nested Guest) |
> > +              |                |  |                |
> > +              |----------------'--'----------------|
> > +              |                                    |
> > +              |       L1 (Guest Hypervisor)        |
> > +              |          KVM (/dev/kvm)            |
> > +              |                                    |
> > +      .------------------------------------------------------.
> > +      |                 L0 (Host Hypervisor)                 |
> > +      |                    KVM (/dev/kvm)                    |
> > +      |------------------------------------------------------|
> > +      |                  x86 Hardware (VMX)                  |
> > +      '------------------------------------------------------'
> 
> This is now x86 specific but the doc is in a general directory;
> I'm not sure what other architecture nesting rules are.

Yeah, x86 is the beast I knew, so I stuck to it.  But since this is
upstream doc, I should bear in mind to clearly mention s390x and other
architectures. 
 
> Woth having VMX/SVM at least.

Will add.

[...]

> > +
> > +Use Cases
> > +---------
> > +
> > +An additional layer of virtualization sometimes can .  You
> > +might have access to a large virtual machine in a cloud environment that
> > +you want to compartmentalize into multiple workloads.  You might be
> > +running a lab environment in a training session.
> 
> Lose this paragraph, and just use the list below?

That was precisely my intention, but I didn't commit the local version
before sending.  Will fix in v2.

> > +There are several scenarios where nested KVM can be Useful:
> > +
> > +  - As a developer, you want to test your software on different OSes.
> > +    Instead of renting multiple VMs from a Cloud Provider, using nested
> > +    KVM lets you rent a large enough "guest hypervisor" (level-1 guest).
> > +    This in turn allows you to create multiple nested guests (level-2
> > +    guests), running different OSes, on which you can develop and test
> > +    your software.
> > +
> > +  - Live migration of "guest hypervisors" and their nested guests, for
> > +    load balancing, disaster recovery, etc.
> > +
> > +  - Using VMs for isolation (as in Kata Containers, and before it Clear
> > +    Containers https://lwn.net/Articles/644675/) if you're running on a
> > +    cloud provider that is already using virtual machines

The last use-case was pointed out by Paolo elsewhere.  (I should make
this more generic.)

> Some others that might be worth listing;
>    - VM image creation tools (e.g. virt-install etc) often run their own
>      VM, and users expect these to work inside a VM.
>    - Some other OS's use virtualization internally for other
>      features/protection.

Yeah.  Will add; thanks!

> > +Procedure to enable nesting on the bare metal host
> > +--------------------------------------------------
> > +
> > +The KVM kernel modules do not enable nesting by default (though your
> > +distribution may override this default).
> 
> It's the other way;  see 1e58e5e for intel has made it default; AMD has
> it set as default for longer.

Ah, this was another bit I realized later, but forgot to fix before
sending to the list.  (I recall seeing this when it came out about a
year ago:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1e58e5e)

Will fix.  Thanks for the eagle eyes :-)

> > +Additional nested-related kernel parameters
> > +-------------------------------------------
> > +
> > +If your hardware is sufficiently advanced (Intel Haswell processor or
> > +above which has newer hardware virt extensions), you might want to
> > +enable additional features: "Shadow VMCS (Virtual Machine Control
> > +Structure)", APIC Virtualization on your bare metal host (L0).
> > +Parameters for Intel hosts::
> > +
> > +    $ cat /sys/module/kvm_intel/parameters/enable_shadow_vmcs
> > +    Y
> > +
> > +    $ cat /sys/module/kvm_intel/parameters/enable_apicv
> > +    N
> > +
> > +    $ cat /sys/module/kvm_intel/parameters/ept
> > +    Y
> 
> Don't those happen automatically (mostly?)

EPT, yes.  I forget if `enable_shadow_vmcs` and `enable_apivc` are.
I'll investigate and update.

[...]

> > +Limitations on Linux kernel versions older than 5.3
> > +---------------------------------------------------
> > +
> > +On Linux kernel versions older than 5.3, once an L1 guest has started an
> > +L2 guest, the L1 guest would no longer capable of being migrated, saved,
> > +or loaded (refer to QEMU documentation on "save"/"load") until the L2
> > +guest shuts down.  [FIXME: Is this limitation fixed for *all*
> > +architectures, including s390x?]
> > +
> > +Attempting to migrate or save & load an L1 guest while an L2 guest is
> > +running will result in undefined behavior.  You might see a ``kernel
> > +BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
> > +Such a migrated or loaded L1 guest can no longer be considered stable or
> > +secure, and must be restarted.
> > +
> > +Migrating an L1 guest merely configured to support nesting, while not
> > +actually running L2 guests, is expected to function normally.
> > +Live-migrating an L2 guest from one L1 guest to another is also expected
> > +to succeed.
> 
> Can you add an entry along the lines of 'reporting bugs with nesting'
> that explains you should clearly state what the host CPU is,
> and the exact OS and hypervisor config in L0,L1 and L2 ?

Yes, good point.  I'll add a short version based my notes from here
(which you've reviewed in the past):

https://kashyapc.fedorapeople.org/Notes/_build/html/docs/Info-to-collect-when-debugging-nested-KVM.html#what-information-to-collect

Thanks for the review.

-- 
/kashyap

