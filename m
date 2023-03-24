Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA3D6C7E0F
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjCXMae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjCXMaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:30:05 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B215F1AC
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:30:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id le6so1641065plb.12
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1679661002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apFBTWSyzAJiPFzHjxLpQLz1tYroNFSD6YjL/Usszn8=;
        b=MafEXQ82Om3+nKdMBthFOKALKOe+0AXY9zee9TCKA6WTaI47fVHYXlnFubhMIisvfW
         4yNYEONEcIv8lBcyLWfBPt7Wr1wKfXPM41BsdUq6t3U72oGrJNV5pZuS227cvPAYIrR+
         e/k9hUaiaFhTeyHXhhukLuoHYeGdF6VcdAWawhCw1f+MP6tEOnDWnC17AqnzKai9KuBQ
         EUyHECThBErnjoM5D0EfDbLkQ53WpqZWZCTRkHtXgh4XNw9/Puq32hFn4DmrFEqs6iW5
         g2lxgT2jP1ZTkGTbIjYh6Up1WlkE53espB7Z+qWGoPU/bEPZn+UahzS0whkvSZ9RciU2
         mueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679661002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apFBTWSyzAJiPFzHjxLpQLz1tYroNFSD6YjL/Usszn8=;
        b=G+tVtmO5g5mF+PJ5ETYw6v92lPTON1PPjQ1Jec+23NIrLxGN+55/mrIEBnTEfUprKA
         2TFjeiK6+PziYVkNv9cbvnHd2O06WXEolZjgTt8m7BadqjSEm1RUQfxlAIs41GxYZNoi
         0wQbGQVXFEoXLU1rhgu41r2WVrt6R/12+UOvcU0GDSW1EDv5D6caRODg9mQ5y2CDNm63
         cHAzSqzVhmU5AnZGiYeLPpMMDoqgLlU0Og0nsmwb0/k2ypmF5M+i1aHV4gUEarKS68d0
         w+Rzt3PSBmyGEwqUKDDqeXreWE1GM5ZbDthJMsUxSPnsBi8e9pkr7NAUjNLfSZG3Usib
         fP/Q==
X-Gm-Message-State: AAQBX9eWu3nGcys01VkUSGIr5ffMvA4YyDJv/L60zrpmdf3sjSTauYL4
        lGFLEQ28ZNoIrWpnkNdobjx0eyd5r5cE0KNWqqWkMw==
X-Google-Smtp-Source: AKy350YOj0FdFN3+uWdSyAoCHwk+Xb/wQaXyg7YzmHkezqvGszd+JaRSfbUyyDzGOV5hzaWe8AXJwVRjCLjx/79A4Hc=
X-Received: by 2002:a17:902:d885:b0:1a0:4933:c6ad with SMTP id
 b5-20020a170902d88500b001a04933c6admr991444plz.3.1679661001986; Fri, 24 Mar
 2023 05:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230307220553.631069-1-jaz@semihalf.com> <20230307164158.4b41e32f.alex.williamson@redhat.com>
 <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
 <20230308104944.578d503c.alex.williamson@redhat.com> <CABUrSUD6hE=h3-Ho7L_J=OYeRUw_Bmg9o4fuw591iw9QyBQv9A@mail.gmail.com>
 <20230308130619.3736cf18.alex.williamson@redhat.com> <CABUrSUBBbXRVRo6b1EKBpgu7zk=8yZhQ__UXFGL_GpO+BA4Pkg@mail.gmail.com>
 <20230308163803.6bfc2922.alex.williamson@redhat.com> <CAH76GKP+W9JUvQpqvjLHADMeRORPUf0d8vn5gCgE5fjxz0YkPQ@mail.gmail.com>
 <20230323110709.6cc80b8c.alex.williamson@redhat.com>
In-Reply-To: <20230323110709.6cc80b8c.alex.williamson@redhat.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Fri, 24 Mar 2023 13:29:50 +0100
Message-ID: <CAH76GKMA-90Ce9XLYUDJEFp4HPkwnS9PVwwdvPjTS-U8Sfq63A@mail.gmail.com>
Subject: Re: [PATCH] vfio/pci: Propagate ACPI notifications to the user-space
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Dominik Behr <dbehr@google.com>, Dominik Behr <dbehr@chromium.org>,
        linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        upstream@semihalf.com, dtor@google.com, jgg@ziepe.ca,
        kevin.tian@intel.com, cohuck@redhat.com, abhsahu@nvidia.com,
        yishaih@nvidia.com, yi.l.liu@intel.com, kvm@vger.kernel.org,
        libvir-list@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

czw., 23 mar 2023 o 18:07 Alex Williamson <alex.williamson@redhat.com>
napisa=C5=82(a):
>
> On Thu, 9 Mar 2023 14:41:23 +0100
> Grzegorz Jaszczyk <jaz@semihalf.com> wrote:
>
> > czw., 9 mar 2023 o 00:38 Alex Williamson <alex.williamson@redhat.com>
> > napisa=C5=82(a):
> > >
> > > On Wed, 8 Mar 2023 14:44:28 -0800
> > > Dominik Behr <dbehr@google.com> wrote:
> > >
> > > > On Wed, Mar 8, 2023 at 12:06=E2=80=AFPM Alex Williamson
> > > > <alex.williamson@redhat.com> wrote:
> > > > >
> > > > > On Wed, 8 Mar 2023 10:45:51 -0800
> > > > > Dominik Behr <dbehr@chromium.org> wrote:
> > > > >
> > > > > > It is the same interface as other ACPI events like AC adapter L=
ID etc
> > > > > > are forwarded to user-space.
> > > > > >  ACPI events are not particularly high frequency like interrupt=
s.
> > > > >
> > > > > I'm not sure that's relevant, these interfaces don't proclaim to
> > > > > provide isolation among host processes which manage behavior rela=
tive
> > > > > to accessories.  These are effectively system level services.  It=
's only
> > > > > a very, very specialized use case that places a VMM as peers amon=
g these
> > > > > processes.  Generally we don't want to grant a VMM any privileges=
 beyond
> > > > > what it absolutely needs, so letting a VMM managing an assigned N=
IC
> > > > > really ought not to be able to snoop host events related to anyth=
ing
> > > > > other than the NIC.
> > > > How is that related to the fact that we are forwarding VFIO-PCI eve=
nts
> > > > to netlink? Kernel does not grant any privileges to VMM.
> > > > There are already other ACPI events on netlink. The implementer of =
the
> > > > VMM can choose to allow VMM to snoop them or not.
> > > > In our case our VMM (crosvm) does already snoop LID, battery and AC
> > > > adapter events so the guest can adjust its behavior accordingly.
> > > > This change just adds another class of ACPI events that are forward=
ed
> > > > to netlink.
> > >
> > > That's true, it is the VMM choice whether to allow snooping netlink,
> > > but this is being proposed as THE solution to allow VMMs to receive
> > > ACPI events related to vfio assigned devices.  If the solution
> > > inherently requires escalating the VMM privileges to see all netlink
> > > events, that's a weakness in the proposal.  As noted previously,
> > > there's also no introspection here, the VMM can't know whether it
> > > should listen to netlink for ACPI events or include AML related to a
> > > GPE for the device.  It cannot determine if either the kernel support=
s
> > > this feature or if the device has an ACPI companion that can generate
> > > these events.
> >
> > To be precise the VMM doesn't listen to all netlink events: it listens
> > only to "acpi_event" family and acpi related multicast group, which
> > means it listens to all events generated through
> > acpi_bus_generate_netlink_event.
> >
> > Before sending this patch I thought about using eventfd instead
> > netalink which will actually provide a channel associated with a given
> > device and therefore such notifications will be received only by the
> > VMM associated with such a device. Nevertheless, it seems like eventfd
> > will allow to signalize events happening (notify on a given device)
> > but is not capable of sending any payload so in our case there is no
> > room for propagating notification value via eventfd. Maybe there is
> > other mechanism eventfd-like which will allow to achieve above?
>
> Reading an eventfd returns an 8-byte value, we generally only use it
> as a counter, but it's been discussed previously and IIRC, it's possible
> to use that value as a notification value.

It seems possible to re-use the eventfd counter to pass the
notification value but it will require some synchronization: the
kernel's eventfd_signal() simply adds value to the eventfd internal
counter. So if two or more ACPI notifications (for a single device)
are received and propagated one by one by the host kernel, VMM could
read one coalesced value and will be unable to retrieve the
notification values. We could probably register two eventfd: one for
host kernel to VMM and the second from the VMM to host kernel: so the
second one will be used in a similar way as resample enventfd for
level triggered interrupts. Or some other serialization mechanism will
have to be applied.

>
> > If there is no such mechanism, maybe instead of using existing acpi
> > netlink events, which are associated with "acpi_event" netlink family
> > and acpi multicast group, we could create per vfio-pci a different
> > netlink family or probably reuse "acpi_event" family but use different
> > multicast group, so each device will have dedicated netlink family.
> > Does it seem reasonable?
> >
> > >
> > > > >
> > > > > > > > > What sort of ACPI events are we expecting to see here and=
 what does user space do with them?
> > > > > > The use we are looking at right now are D-notifier events about=
 the
> > > > > > GPU power available to mobile discrete GPUs.
> > > > > > The firmware notifies the GPU driver and resource daemon to
> > > > > > dynamically adjust the amount of power that can be used by the =
GPU.
> > > > > >
> > > > > > > The proposed interface really has no introspection, how does =
the VMM
> > > > > > > know which devices need ACPI tables added "upfront"?  How do =
these
> > > > > > > events factor into hotplug device support, where we may not b=
e able to
> > > > > > > dynamically inject ACPI code into the VM?
> > > > > >
> > > > > > The VMM can examine PCI IDs and the associated firmware node of=
 the
> > > > > > PCI device to figure out what events to expect and what ACPI ta=
ble to
> > > > > > generate to support it but that should not be necessary.
> > > > >
> > > > > I'm not entirely sure where your VMM is drawing the line between =
the VM
> > > > > and management tools, but I think this is another case where the
> > > > > hypervisor itself should not have privileges to examine the host
> > > > > firmware tables to build its own.  Something like libvirt would b=
e
> > > > > responsible for that.
> > > > Yes, but that depends on the design of hypervisor and VMM and is no=
t
> > > > related to this patch.
> > >
> > > It is very much related to this patch if it proposes an interface to
> > > solve a problem which is likely not compatible with the security mode=
l
> > > of other VMMs.  We need a single solution to support all VMMs.
> > >
> > > > >
> > > > > > A generic GPE based ACPI event forwarder as Grzegorz proposed c=
an be
> > > > > > injected at VM init time and handle any notification that comes=
 later,
> > > > > > even from hotplug devices.
> > > > >
> > > > > It appears that forwarder is sending the notify to a specific ACP=
I
> > > > > device node, so it's unclear to me how that becomes boilerplate A=
ML
> > > > > added to all VMs.  We'll need to notify different devices based o=
n
> > > > > different events, right?
> > > > Valid point. The notifications have a "scope" ACPI path.
> > > > In my experience these events are consumed without looking where th=
ey
> > > > came from but I believe the patch can be extended to
> > > > provide ACPI path, in your example "_SB.PCI0.GPP0.PEGP" instead of
> > > > generic vfio_pci which VMM could use to translate an equivalent ACP=
I
> > > > path in the guest and pass it to a generic ACPI GPE based notifier =
via
> > > > shared memory. Grzegorz could you chime in whether that would be
> > > > possible?
> > >
> > > So effectively we're imposing the host ACPI namespace on the VM, or a=
t
> > > least a mapping between the host and VM namespace?  The generality of
> > > this is not improving.
> >
> > Yes, in the example VMM implementation we have mapping between the
> > host pci device address and guest pci device. Therefore VMM knows,
> > based on device name (BDF) sent via netlink, to which guest device
> > this notification should be propagated. The boilerplate AML is added
> > to each vfio-pci device which belongs to VMM and each vfio-pci device
> > has associated pre-allocated GPE so the VMM knows which GPE should be
> > triggered to replicate notification for a given device. BTW this is
> > only current WIP VMM implementation - this could probably be optimized
> > if needed.
> >
> > Handling hotplug devices is more problematic. I see that the kernel
> > provides some runtime ACPI patching mechanism:
> > https://www.kernel.org/doc/html/latest/firmware-guide/acpi/method-custo=
mizing.html
> > (which I never tried) but not even sure how VMM could take advantage
> > of it. BTW this realized me that the same problem with hotplug applies
> > to other vfio-pci use-cases e.g. runtime PM, which relies on guest
> > virtual ACPI method:
> > https://patchwork.kernel.org/project/linux-pm/patch/20220829114850.4341=
-5-abhsahu@nvidia.com/.
> > Generating virtual ACPI content for hotplug devices seems like a more
> > generic issue.
>
> I don't think this is an equivalent case, the AML object is at the
> slot, not the device and the direction is reversed.  The VMM can
> implement PCI slot power control regardless of the host capabilities.
> This is more like ACPI eject behavior, the guest triggers an event
> which is processed by the VMM to perform an action.  The VMM doesn't
> need to dynamically add slot power control capabilities based on the
> features of the plugged device.

IIUC the only concern with hotplug devices is how to generate the AML
code for them. If we theoretically could prepare an ACPI guest table
upfront for PCI PM even for hot pluggable devices (by providing the
kind of slot as you've described), why can't we do the same for ACPI
notifications? For both cases we have to associate such a generated
AML device object/slot with a specific PCI device anyway: at least VMM
will have to allocate some memory region for each of them upfront and
use this address during AML generation, which will allow to associate
address that guest access with real device on which we want to perform
operations: either perform PM operation or get ACPI notification
value.

>
> > > > > > > The acpi_bus_generate_netlink_event() below really only seems=
 to form a
> > > > > > > u8 event type from the u32 event.  Is this something that cou=
ld be
> > > > > > > provided directly from the vfio device uAPI with an ioeventfd=
, thus
> > > > > > > providing introspection that a device supports ACPI event not=
ifications
> > > > > > > and the ability for the VMM to exclusively monitor those even=
ts, and
> > > > > > > only those events for the device, without additional privileg=
es?
> > > > > >
> > > > > > From what I can see these events are 8 bit as they come from AC=
PI.
> > > > > > They also do not carry any payload and it is up to the receivin=
g
> > > > > > driver to query any additional context/state from the device.
> > > > > > This will work the same in the VM where driver can query the sa=
me
> > > > > > information from the passed through PCI device.
> > > > > > There are multiple other netflink based ACPI events forwarders =
which
> > > > > > do exactly the same thing for other devices like AC adapter, li=
d/power
> > > > > > button, ACPI thermal notifications, etc.
> > > > > > They all use the same mechanism and can be received by user-spa=
ce
> > > > > > programs whether VMMs or others.
> > > > >
> > > > > But again, those other receivers are potentially system services,=
 not
> > > > > an isolated VM instance operating in a limited privilege environm=
ent.
> > > > > IMO, it's very different if the host display server has access to=
 lid
> > > > > or power events than it is to allow some arbitrary VM that happen=
s to
> > > > > have an unrelated assigned device that same privilege.
> > > > Therefore these VFIO related ACPI events could be received by a sys=
tem
> > > > service via this netlink event and selectively forwarded to VMM if
> > > > such is a desire of whoever implements the userspace.
> > > > This is outside the scope of this patch. In our case our VMM does
> > > > receive these LID, AC or battery events.
> > >
> > > But this is backwards, we're presupposing the choice to use netlink
> > > based on the convenience of one VMM, which potentially creates
> > > obstacles, maybe even security isolation issues for other VMMs.  The
> > > method of delivering ACPI events to a VMM is very much within the sco=
pe
> > > of this proposal.  Thanks,
> > >
> > > Alex
> > >
> >
> > regarding:
> > > > > On my laptop, I see multiple _GPE scopes, each apparently very un=
ique
> > > > > to the devices:
> > > > >
> > > > >    Scope (_GPE)
> > > > >    {
> > > > >        Method (_L0C, 0, Serialized)  // _Lxx: Level-Triggered GPE=
, xx=3D0x00-0xFF
> > > > >        {
> > > > >            Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Chan=
ge
> > > > >        }
> > > > >
> > > > >        Method (_L0D, 0, Serialized)  // _Lxx: Level-Triggered GPE=
, xx=3D0x00-0xFF
> > > > >        {
> > > > >             Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Cha=
nge
> > > > >        }
> > > > >
> > > > >        Method (_L0F, 0, Serialized)  // _Lxx: Level-Triggered GPE=
, xx=3D0x00-0xFF
> > > > >        {
> > > > >             Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Cha=
nge
> > > > >         }
> > > > >     }
> > > > >
> > > > >     Scope (_GPE)
> > > > >     {
> > > > >         Method (_L19, 0, NotSerialized)  // _Lxx: Level-Triggered=
 GPE, xx=3D0x00-0xFF
> > > > >         {
> > > > >             Notify (\_SB.PCI0.GP17, 0x02) // Device Wake
> > > > >             Notify (\_SB.PCI0.GP17.XHC0, 0x02) // Device Wake
> > > > >             Notify (\_SB.PCI0.GP17.XHC1, 0x02) // Device Wake
> > > > >             Notify (\_SB.PWRB, 0x02) // Device Wake
> > > > >         }
> > > > >
> > > > >         Method (_L08, 0, NotSerialized)  // _Lxx: Level-Triggered=
 GPE, xx=3D0x00-0xFF
> > > > >         {
> > > > >            Notify (\_SB.PCI0.GP18, 0x02) // Device Wake
> > > > >             Notify (\_SB.PCI0.GPP0, 0x02) // Device Wake
> > > > >             Notify (\_SB.PCI0.GPP1, 0x02) // Device Wake
> > > > >             Notify (\_SB.PCI0.GPP5, 0x02) // Device Wake
> > > > >         }
> > > > >     }
> > > > >
> > > > > At least one more even significantly more extensive, calling meth=
ods
> > > > > that interact with OpRegions.  So how does a simple stub of a
> > > > > GPE block replicate this sort of behavior in the host AML?  Thank=
s,
> >
> > The simple stub of GPE block will work to replicate the ACPI
> > notification only: as mentioned earlier GPE handler will be generated
> > per-vfio device so in your example if let assume that only:
> > - \_SB.PCI0.GPP0.PEGP
> > - \_SB.PCI0.GP17.XHC1
> > will be pass-through to the guest, the generated AML code for VM will
> > look more-less like below:
> >
> >         Scope (_GPE)
> >         {
> >             Method (_E00, 0, NotSerialized)
> >             {
> >                 Local0 =3D  \_SB.PCI0.GPP0.PEGP.NOTY
> >                 Notify ( \_SB.PCI0.GPP0.PEGP, Local0)
> >             }
> >         }
> >         Scope (_GPE)
> >         {
> >             Method (_E01, 0, NotSerialized)
> >             {
> >                 Local0 =3D\_SB.PCI0.GP17.XHC1.NOTY
> >                 Notify (\_SB.PCI0.GP17.XHC1, Local0)
> >             }
> >         }
> >
> > So each pass-through device will have associated GPE (0 for
> > \_SB.PCI0.GPP0.PEGP and 1 for \_SB.PCI0.GP17.XHC1). The path in Notify
> > could actually be different and related to guest pci hierarchy (but
> > associated to those host devices). Please also note that in this case
> > we use GPE in order to "inform" guest about notification coming and we
> > do not try to replicate host GPE scope description.
> >
> > Above we assumed that other devices (like \_SB.PCI0.GPP0/1) are not
> > pass-through to the guest and notification are handled in host as
> > usual (they are not binded to pci-vfio) and there is no need to
> > generate AML code, allocate GPE for them and so on.
>
> I'm pretty lost here.  The GPE code to read the notify value and relay
> it to another AML object is relatively trivial, but that other AML
> object needs to do something of some significance with that notify.

It will do exactly the same thing that it would do on the host side.
Since device is pass-through to the guest and runs native driver
inside the guest, the notify handler will be registered by such driver
(e.g. via acpi_install_notify_handler). Now when a guest handles the
GPExx, it evaluates the ACPI handler for it: Method(_Exx..) [Method
(_E00, 0, NotSerialized) for GPE00, Method (_E01, 0, NotSerialized)
for GPE01 and so one]. Such a handler will call Notify()* which will
trigger the notify handler registered by the guest in the same way as
it would on the host.

*https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/19_ASL_Reference/ACPI_Source=
_Language_Reference.html?highlight=3Dnotify#notify-notify-object-of-event

> Minimally, it seems like the AML would need to establish the companion
> relationship with the device so that a driver in the guest receives
> that notify.

VMM establishes that connection by allocating per vfio-pci device a
unique GPE and generating AML for it. Once it is done and the VMM
wants to replicate ACPI notification on specific device it just
triggers specific, associated GPExx/SCI which in consequence evaluates
guest ACPI _Exx method
        Scope (_GPE)
        {
            Method (_E00, 0, NotSerialized)
            {
                Local0 =3D  \_SB.PCI0.GPP0.PEGP.NOTY
                Notify ( \_SB.PCI0.GPP0.PEGP, Local0)
            }
        }
which is generated per device.

> What does that look like, and can it be pre-seeded in the
> AML regardless of whether the device is cold- or hot-plugged into the
> VM?  Some specific examples would be useful.  It's not clear to me that
> there isn't significant out-of-band effort required to understand and
> replicate AML from host to guest to make this useful, so the generality
> of this feature is hard to grasp.  Thanks,

The use case we are looking at right now, as Dominick wrote, are
D-notifier events about the GPU power available to mobile discrete
GPUs.
Natively the firmware notifies the GPU driver to dynamically adjust
the amount of power that can be used by the GPU. It does it by
utilizing ACPI notification on a PCI device object and we want to
replicate this behaviour on the guest side.

Other common use case (although not related to pci-vfio) when ACPI
notification are used is AC adapter status change: firmware can
signalize ac adapter status change and as consequence evaluates:
Notify (AC, 0x80) // Status Change
which finally triggers registered ACPI notify handler (acpi_ac_notify)
for ac adapter.

There are many different notifications value:
https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/05_ACPI_Software_Programming_=
Model/ACPI_Software_Programming_Model.html#device-object-notifications
and as described in linked chapter: notification values above 0x80 are
device or hardware specific. The purpose of this patch is to replicate
such notifications to pass-through devices, so the guest device driver
can handle them in its specific ACPI notification handler way, nothing
more than that.

Thank you,
Grzegorz
