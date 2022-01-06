Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50899486572
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 14:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239673AbiAFNnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 08:43:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53166 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbiAFNnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 08:43:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4324161ABD
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 13:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD337C36AED
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641476610;
        bh=q8XwvzMl/2Nq8DR78C4zeCPhTJrgM4P2kPRw7GjpgCA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vAqlStzDhLF0sqsjW4uBUjCU19yHkI9mW2/4uUswEKHS2dhxOLzQkpTMix5BdowBt
         DkZ+ZU9O9ljFPbaPZxMN7xFTqzZmjNlnQKPtQgUO9OyOusMh2PER2YsrfK34qyhxAJ
         02tujnhX8QQNWkQQzAlnutNR5WKyxdi94W8jJFfNg9ttoWCqSrp84BA+2lhGgVDDks
         zwTa4dLUrEc+Xf0xgG3+bXVrAQmQoXsyLaPYgm+8LV9tUxLIx+bSohVZML050UCbiB
         3IFCw5POliDpLSGikYykAHSFRH9G1sB9N+/KlgiHGTU3AFLd1Lfva0oeAchlnmxvoS
         9biRJqt5UDqSw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 957FFC05FF7; Thu,  6 Jan 2022 13:43:30 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Thu, 06 Jan 2022 13:43:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215459-28872-Pko0SaFk1s@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215459-28872@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215459

--- Comment #3 from mlevitsk@redhat.com ---
On Thu, 2022-01-06 at 13:12 +0000, bugzilla-daemon@bugzilla.kernel.org wrot=
e:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215459
>=20
> --- Comment #2 from th3voic3@mailbox.org ---
> (In reply to mlevitsk from comment #1)
> > On Thu, 2022-01-06 at 11:03 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D215459
> > >=20
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
> > >=20
> > > Created attachment 300234 [details]
> > >   --> https://bugzilla.kernel.org/attachment.cgi?id=3D300234&action=
=3Dedit
> > > qemu.hook and libvirt xml
> > >=20
> > > Hi,
> > >=20
> > > starting with kernel 5.15 I'm experiencing freezes in my VFIO Windows=
 10
> > VM.
> > > Downgrading to 5.14.16 fixes the issue.
> > >=20
> > > I can't find any error messages in dmesg when this happens and compar=
ing
> > the
> > > dmesg output between 5.14.16 and 5.15.7 didn't show any differences.
> > >=20
> > >=20
> > > Additional info:
> > > * 5.15.x
> > > * I'm attaching my libvirt config and my /etc/libvirt/hooks/qemu
> > > * My specs are:
> > > ** i7-10700k
> > > ** ASUS z490-A PRIME Motherboard
> > > ** 64 GB RAM
> > > ** Passthrough Card: NVIDIA 2070 Super
> > > ** Host is using the integrated Graphics chip
> > >=20
> > > Steps to reproduce:
> > > Boot any 5.15 kernel and start the VM and after some time (no specific
> > > trigger
> > > as far as I can see) the VM freezes.
> > >=20
> > > After some testing the solution seems to be:
> > >=20
> > > I read about this:
> > > 20210713142023.106183-9-mlevitsk@redhat.com/#24319635">
> > >=20
> > >=20
> >
> https://patchwork.kernel.org/project/kvm/patch/20210713142023.106183-9-ml=
evitsk@redhat.com/#24319635
> > > And so I checked
> > > cat /sys/module/kvm_intel/parameters/enable_apicv
> > >=20
> > > which returns Y to me by default.
> > >=20
> > > So I added
> > > options kvm_intel enable_apicv=3D0
> > > to /etc/modprobe.d/kvm.conf
> > >=20
> > >=20
> > > cat /sys/module/kvm_intel/parameters/enable_apicv
> > > now returns N
> > >=20
> > > So far I haven't encountered any freezes.
> > >=20
> > > The confusing part is that APICv shouldn't be available with my CPU
> >=20
> > I guess you are lucky and your cpu has it?=20
> > Does /sys/module/kvm_intel/parameters/enable_apicv show Y on 5.14.16 as
> well?
> Yep just checked again.
>=20
> > I know that there were few fixes in regard to posted interrupts on inte=
l,
> > which might explain the problem.
> I tried checking with
> for i in $(find /sys/class/iommu/dmar* -type l); do echo -n "$i: "; echo =
$((
> (
> 0x$(cat $i/intel-iommu/cap) >> 59 ) & 1 )); done
> cat: /intel-iommu/cap: No such file or directory
> /sys/class/iommu/dmar0: 0
> /sys/class/iommu/dmar1: 0
>=20
>=20
> So posted interrupts don't work on my system anyways?

Yes and no.

APICv consists of 4 parts:

1. virtualization of host->guest interrupts.

That allows KVM to deliver interrupts to a vCPU without VMexit,
interrupts that can be sent from say main qemu thread or from iothread,
or from in-kernel timers, etc.
As long as the sender runs on a different core, you get VMexit less interru=
pt.
If enable_apicv is true, your cpu ought to have this.

2. virtualization of apic registers.
That allows to avoid VM exits on some guest apic acceses like writing EOI
register, and such. Very primitive support for this exits even without APIV=
c,
called FlexPriority/TPR virtualization.

3. virtualization of IPIs (inter process interrupts)
Intel currenlty only supports self-ipi, where a vCPU sends an interrupt to
itself,
and it seems that finally they on track to support ful IPI virtualization.

4. Delivery of interrupts from passed-through devices to VM through virtual
apic.
That feature apparently you don't have enabled. Its optional but still very
nice to
have.

So you are lucky to have quite working APICv, and once it works for you
it should help with latency overall.

I think that this might be related to
"KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU =3D=3D this vC=
PU"


There was a thread on the mailing list about exact same issue you are facing
APICv enabled but have a pass through device which doesn't use posted
interrupts
Can't seem to find the thread now.

This patch actualy fixed the issue, but I haven't fully followed on what
commit introduced the issue.

I also wonder if the same issue can happen on AVIC.

Best reards,
        Maxim Levitsky


>=20
>=20
> > You might want to try 5.16 kernel when it released.
> I will definitely check again thanks.
>=20
> Assuming I really do have APICv: is there anything I need to change in my=
 XML
> to really make use of this feature or does it work "out of the box"?
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
