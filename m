Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7FA6B25A6
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 14:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjCINls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 08:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjCINlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 08:41:39 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AC9F208B
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 05:41:35 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id y19so1049489pgk.5
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 05:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1678369295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oemPlzgbeOP+LaJlWnc7H/h3NtkUUX5eQ/vQ7NKduH0=;
        b=oCWVYTdaDl+snWip7z9t9KrFNNtYXzKO4XjFoI19aoZyhWoVBRLQOxgH2j9ikLgAAh
         NqK+moCofKYOm21RuHnIzu1liCIjcNOhTQknVFNE63WBBeiRQi6g2WrYtnnwPl+Ovo1K
         QrkyLDTogWW2muXSYEzMZbKAChV3M07eCqYFyE/niadIiW0aN3G87EJAXWLInJ3d1D5f
         LnVYYugP1krQFJXsWR5Xs4/4K9RVbPnkuXPzN497ihAxt6dh35AEFQi6w1PxalR1VMHb
         5F0eJTP3Fr9JQ7iwPs88+VCGNdR4zF5STbl87HoGawwhxCuEf9boaJo1gITCAv8HCA1T
         LK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678369295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oemPlzgbeOP+LaJlWnc7H/h3NtkUUX5eQ/vQ7NKduH0=;
        b=4Hp6PwO65lzBYVpw1QoXsKHDgg3APWt/xtFeuZ6sL1yp9lkdKukkU4x9jyiBBMYE3M
         JhoxHdTIVV8VBIQ8s1sma/yxSZwAZd/6RlHA9plqdDaEOI1nfp14KxieWRLEKZIioOzy
         5jT96/WH95rY/SmI2+KDJOnTgZo0nUkQHJy3mymqL0qTpd6sMSoMYE545FKy0cMc/yYo
         p8SknMH35Car3LQTioORhplh5bXWUvFQQ6KNf8Y0G6jwTFSiFYWU1FCR75ATD5yPN+mo
         7sFMV+AQZP6/ZBW6vjOtNt5vXmpbH4BXFDTAZ9/Qyl9T6ooGP+8exRBQ0KimAmGE4Rq6
         eYRA==
X-Gm-Message-State: AO0yUKWDPVxIo7PA9qxSEfZzZGJ8Zz/dx6kmltWgswdYBiaxziDAZVAb
        2clwWTGfJNpSLTBO4a68V/1FS/f3qJMs9grfoRhuBA==
X-Google-Smtp-Source: AK7set+XewqVl7hGYJHZyRKh26yXQmq1zgZ0ZKt4f85XZfFkbkQg0aP5gSBd7qoePG5+IGsylZSFhgSwxuk9atznIYw=
X-Received: by 2002:a05:6a00:1955:b0:592:5696:89ee with SMTP id
 s21-20020a056a00195500b00592569689eemr9147098pfk.3.1678369294730; Thu, 09 Mar
 2023 05:41:34 -0800 (PST)
MIME-Version: 1.0
References: <20230307220553.631069-1-jaz@semihalf.com> <20230307164158.4b41e32f.alex.williamson@redhat.com>
 <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
 <20230308104944.578d503c.alex.williamson@redhat.com> <CABUrSUD6hE=h3-Ho7L_J=OYeRUw_Bmg9o4fuw591iw9QyBQv9A@mail.gmail.com>
 <20230308130619.3736cf18.alex.williamson@redhat.com> <CABUrSUBBbXRVRo6b1EKBpgu7zk=8yZhQ__UXFGL_GpO+BA4Pkg@mail.gmail.com>
 <20230308163803.6bfc2922.alex.williamson@redhat.com>
In-Reply-To: <20230308163803.6bfc2922.alex.williamson@redhat.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Thu, 9 Mar 2023 14:41:23 +0100
Message-ID: <CAH76GKP+W9JUvQpqvjLHADMeRORPUf0d8vn5gCgE5fjxz0YkPQ@mail.gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

czw., 9 mar 2023 o 00:38 Alex Williamson <alex.williamson@redhat.com>
napisa=C5=82(a):
>
> On Wed, 8 Mar 2023 14:44:28 -0800
> Dominik Behr <dbehr@google.com> wrote:
>
> > On Wed, Mar 8, 2023 at 12:06=E2=80=AFPM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > >
> > > On Wed, 8 Mar 2023 10:45:51 -0800
> > > Dominik Behr <dbehr@chromium.org> wrote:
> > >
> > > > It is the same interface as other ACPI events like AC adapter LID e=
tc
> > > > are forwarded to user-space.
> > > >  ACPI events are not particularly high frequency like interrupts.
> > >
> > > I'm not sure that's relevant, these interfaces don't proclaim to
> > > provide isolation among host processes which manage behavior relative
> > > to accessories.  These are effectively system level services.  It's o=
nly
> > > a very, very specialized use case that places a VMM as peers among th=
ese
> > > processes.  Generally we don't want to grant a VMM any privileges bey=
ond
> > > what it absolutely needs, so letting a VMM managing an assigned NIC
> > > really ought not to be able to snoop host events related to anything
> > > other than the NIC.
> > How is that related to the fact that we are forwarding VFIO-PCI events
> > to netlink? Kernel does not grant any privileges to VMM.
> > There are already other ACPI events on netlink. The implementer of the
> > VMM can choose to allow VMM to snoop them or not.
> > In our case our VMM (crosvm) does already snoop LID, battery and AC
> > adapter events so the guest can adjust its behavior accordingly.
> > This change just adds another class of ACPI events that are forwarded
> > to netlink.
>
> That's true, it is the VMM choice whether to allow snooping netlink,
> but this is being proposed as THE solution to allow VMMs to receive
> ACPI events related to vfio assigned devices.  If the solution
> inherently requires escalating the VMM privileges to see all netlink
> events, that's a weakness in the proposal.  As noted previously,
> there's also no introspection here, the VMM can't know whether it
> should listen to netlink for ACPI events or include AML related to a
> GPE for the device.  It cannot determine if either the kernel supports
> this feature or if the device has an ACPI companion that can generate
> these events.

To be precise the VMM doesn't listen to all netlink events: it listens
only to "acpi_event" family and acpi related multicast group, which
means it listens to all events generated through
acpi_bus_generate_netlink_event.

Before sending this patch I thought about using eventfd instead
netalink which will actually provide a channel associated with a given
device and therefore such notifications will be received only by the
VMM associated with such a device. Nevertheless, it seems like eventfd
will allow to signalize events happening (notify on a given device)
but is not capable of sending any payload so in our case there is no
room for propagating notification value via eventfd. Maybe there is
other mechanism eventfd-like which will allow to achieve above?

If there is no such mechanism, maybe instead of using existing acpi
netlink events, which are associated with "acpi_event" netlink family
and acpi multicast group, we could create per vfio-pci a different
netlink family or probably reuse "acpi_event" family but use different
multicast group, so each device will have dedicated netlink family.
Does it seem reasonable?

>
> > >
> > > > > > > What sort of ACPI events are we expecting to see here and wha=
t does user space do with them?
> > > > The use we are looking at right now are D-notifier events about the
> > > > GPU power available to mobile discrete GPUs.
> > > > The firmware notifies the GPU driver and resource daemon to
> > > > dynamically adjust the amount of power that can be used by the GPU.
> > > >
> > > > > The proposed interface really has no introspection, how does the =
VMM
> > > > > know which devices need ACPI tables added "upfront"?  How do thes=
e
> > > > > events factor into hotplug device support, where we may not be ab=
le to
> > > > > dynamically inject ACPI code into the VM?
> > > >
> > > > The VMM can examine PCI IDs and the associated firmware node of the
> > > > PCI device to figure out what events to expect and what ACPI table =
to
> > > > generate to support it but that should not be necessary.
> > >
> > > I'm not entirely sure where your VMM is drawing the line between the =
VM
> > > and management tools, but I think this is another case where the
> > > hypervisor itself should not have privileges to examine the host
> > > firmware tables to build its own.  Something like libvirt would be
> > > responsible for that.
> > Yes, but that depends on the design of hypervisor and VMM and is not
> > related to this patch.
>
> It is very much related to this patch if it proposes an interface to
> solve a problem which is likely not compatible with the security model
> of other VMMs.  We need a single solution to support all VMMs.
>
> > >
> > > > A generic GPE based ACPI event forwarder as Grzegorz proposed can b=
e
> > > > injected at VM init time and handle any notification that comes lat=
er,
> > > > even from hotplug devices.
> > >
> > > It appears that forwarder is sending the notify to a specific ACPI
> > > device node, so it's unclear to me how that becomes boilerplate AML
> > > added to all VMs.  We'll need to notify different devices based on
> > > different events, right?
> > Valid point. The notifications have a "scope" ACPI path.
> > In my experience these events are consumed without looking where they
> > came from but I believe the patch can be extended to
> > provide ACPI path, in your example "_SB.PCI0.GPP0.PEGP" instead of
> > generic vfio_pci which VMM could use to translate an equivalent ACPI
> > path in the guest and pass it to a generic ACPI GPE based notifier via
> > shared memory. Grzegorz could you chime in whether that would be
> > possible?
>
> So effectively we're imposing the host ACPI namespace on the VM, or at
> least a mapping between the host and VM namespace?  The generality of
> this is not improving.

Yes, in the example VMM implementation we have mapping between the
host pci device address and guest pci device. Therefore VMM knows,
based on device name (BDF) sent via netlink, to which guest device
this notification should be propagated. The boilerplate AML is added
to each vfio-pci device which belongs to VMM and each vfio-pci device
has associated pre-allocated GPE so the VMM knows which GPE should be
triggered to replicate notification for a given device. BTW this is
only current WIP VMM implementation - this could probably be optimized
if needed.

Handling hotplug devices is more problematic. I see that the kernel
provides some runtime ACPI patching mechanism:
https://www.kernel.org/doc/html/latest/firmware-guide/acpi/method-customizi=
ng.html
(which I never tried) but not even sure how VMM could take advantage
of it. BTW this realized me that the same problem with hotplug applies
to other vfio-pci use-cases e.g. runtime PM, which relies on guest
virtual ACPI method:
https://patchwork.kernel.org/project/linux-pm/patch/20220829114850.4341-5-a=
bhsahu@nvidia.com/.
Generating virtual ACPI content for hotplug devices seems like a more
generic issue.

>
> > > > > The acpi_bus_generate_netlink_event() below really only seems to =
form a
> > > > > u8 event type from the u32 event.  Is this something that could b=
e
> > > > > provided directly from the vfio device uAPI with an ioeventfd, th=
us
> > > > > providing introspection that a device supports ACPI event notific=
ations
> > > > > and the ability for the VMM to exclusively monitor those events, =
and
> > > > > only those events for the device, without additional privileges?
> > > >
> > > > From what I can see these events are 8 bit as they come from ACPI.
> > > > They also do not carry any payload and it is up to the receiving
> > > > driver to query any additional context/state from the device.
> > > > This will work the same in the VM where driver can query the same
> > > > information from the passed through PCI device.
> > > > There are multiple other netflink based ACPI events forwarders whic=
h
> > > > do exactly the same thing for other devices like AC adapter, lid/po=
wer
> > > > button, ACPI thermal notifications, etc.
> > > > They all use the same mechanism and can be received by user-space
> > > > programs whether VMMs or others.
> > >
> > > But again, those other receivers are potentially system services, not
> > > an isolated VM instance operating in a limited privilege environment.
> > > IMO, it's very different if the host display server has access to lid
> > > or power events than it is to allow some arbitrary VM that happens to
> > > have an unrelated assigned device that same privilege.
> > Therefore these VFIO related ACPI events could be received by a system
> > service via this netlink event and selectively forwarded to VMM if
> > such is a desire of whoever implements the userspace.
> > This is outside the scope of this patch. In our case our VMM does
> > receive these LID, AC or battery events.
>
> But this is backwards, we're presupposing the choice to use netlink
> based on the convenience of one VMM, which potentially creates
> obstacles, maybe even security isolation issues for other VMMs.  The
> method of delivering ACPI events to a VMM is very much within the scope
> of this proposal.  Thanks,
>
> Alex
>

regarding:
> > > On my laptop, I see multiple _GPE scopes, each apparently very unique
> > > to the devices:
> > >
> > >    Scope (_GPE)
> > >    {
> > >        Method (_L0C, 0, Serialized)  // _Lxx: Level-Triggered GPE, xx=
=3D0x00-0xFF
> > >        {
> > >            Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
> > >        }
> > >
> > >        Method (_L0D, 0, Serialized)  // _Lxx: Level-Triggered GPE, xx=
=3D0x00-0xFF
> > >        {
> > >             Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
> > >        }
> > >
> > >        Method (_L0F, 0, Serialized)  // _Lxx: Level-Triggered GPE, xx=
=3D0x00-0xFF
> > >        {
> > >             Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
> > >         }
> > >     }
> > >
> > >     Scope (_GPE)
> > >     {
> > >         Method (_L19, 0, NotSerialized)  // _Lxx: Level-Triggered GPE=
, xx=3D0x00-0xFF
> > >         {
> > >             Notify (\_SB.PCI0.GP17, 0x02) // Device Wake
> > >             Notify (\_SB.PCI0.GP17.XHC0, 0x02) // Device Wake
> > >             Notify (\_SB.PCI0.GP17.XHC1, 0x02) // Device Wake
> > >             Notify (\_SB.PWRB, 0x02) // Device Wake
> > >         }
> > >
> > >         Method (_L08, 0, NotSerialized)  // _Lxx: Level-Triggered GPE=
, xx=3D0x00-0xFF
> > >         {
> > >            Notify (\_SB.PCI0.GP18, 0x02) // Device Wake
> > >             Notify (\_SB.PCI0.GPP0, 0x02) // Device Wake
> > >             Notify (\_SB.PCI0.GPP1, 0x02) // Device Wake
> > >             Notify (\_SB.PCI0.GPP5, 0x02) // Device Wake
> > >         }
> > >     }
> > >
> > > At least one more even significantly more extensive, calling methods
> > > that interact with OpRegions.  So how does a simple stub of a
> > > GPE block replicate this sort of behavior in the host AML?  Thanks,

The simple stub of GPE block will work to replicate the ACPI
notification only: as mentioned earlier GPE handler will be generated
per-vfio device so in your example if let assume that only:
- \_SB.PCI0.GPP0.PEGP
- \_SB.PCI0.GP17.XHC1
will be pass-through to the guest, the generated AML code for VM will
look more-less like below:

        Scope (_GPE)
        {
            Method (_E00, 0, NotSerialized)
            {
                Local0 =3D  \_SB.PCI0.GPP0.PEGP.NOTY
                Notify ( \_SB.PCI0.GPP0.PEGP, Local0)
            }
        }
        Scope (_GPE)
        {
            Method (_E01, 0, NotSerialized)
            {
                Local0 =3D\_SB.PCI0.GP17.XHC1.NOTY
                Notify (\_SB.PCI0.GP17.XHC1, Local0)
            }
        }

So each pass-through device will have associated GPE (0 for
\_SB.PCI0.GPP0.PEGP and 1 for \_SB.PCI0.GP17.XHC1). The path in Notify
could actually be different and related to guest pci hierarchy (but
associated to those host devices). Please also note that in this case
we use GPE in order to "inform" guest about notification coming and we
do not try to replicate host GPE scope description.

Above we assumed that other devices (like \_SB.PCI0.GPP0/1) are not
pass-through to the guest and notification are handled in host as
usual (they are not binded to pci-vfio) and there is no need to
generate AML code, allocate GPE for them and so on.

Thank you,
Grzegorz
