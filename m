Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45456B18EF
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 02:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjCIBvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 20:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCIBvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 20:51:46 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484906B33B
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 17:51:44 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id o9so215351qkh.6
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 17:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678326703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3gWq2KWwWeTeT4vJi002XPuT0w4S0agkfJiRSvLNdg=;
        b=Kb0Jt3/rkqdr8EsUwVAeQ59qswTdjGNo6iONanDNni3xiu8Qn/kPxLzovNp+cz4xuJ
         cM236NU906POUBqkNnr2AysArsQsFidVO6whC6vcKO++cDWkbcDB21z0pGh9qV5tAOVz
         7oCZTTF5gAJ6Xpp8nXAl3Lfj1GK6Suh4vS2/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678326703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q3gWq2KWwWeTeT4vJi002XPuT0w4S0agkfJiRSvLNdg=;
        b=6GgB7v9eUVDhL4kykwBFvR+WRcWPP7ZH45RjIyNy6MciuBo3dtIpWvVHUdixNXTIO/
         5boX+YgrvQ0pH1ByxwPezdmmovG+nb7Z7eLUIiFLQffb/tq/Ohf62U16zMEZY4r0+r79
         m8hsF+Pa7mx4CXzn3AaINxlm9FezuGh+RgGrsS2IeXK45NeTqMXcqk/lXLdfRre344/Z
         V6fJnyA0UU9OTHMrlAqRDGsOJ12Y2Ysyrb+ozCa6lqF02z/YCszFSz5YpakjshDdZOx5
         MuHQAGKeM27SL+Pvi5QqCDyK053Z4n5dtIEL+hRCBJejvj11Zzk7VcrfTdhzHD05Zr5M
         ryIw==
X-Gm-Message-State: AO0yUKVME1wJJ9rZSBqV/Haa27jf4cjmi3cBbsgkYr3fW7z2pYzZ5sxM
        Pco7S1ncHBssB2ZmlSpktDuNG1ckH2RGr3+3VJ7Nog==
X-Google-Smtp-Source: AK7set96jsF8W1fuTyQyux+cmSvjCWmllqfGQFSInipiA+zNdKUtK5r/hH9JloDBSMa3Wo8Ao8ojbYQ1MIvey6DJ9jA=
X-Received: by 2002:a37:5cf:0:b0:71f:b8e9:3631 with SMTP id
 198-20020a3705cf000000b0071fb8e93631mr5741085qkf.13.1678326703043; Wed, 08
 Mar 2023 17:51:43 -0800 (PST)
MIME-Version: 1.0
References: <20230307220553.631069-1-jaz@semihalf.com> <20230307164158.4b41e32f.alex.williamson@redhat.com>
 <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
 <20230308104944.578d503c.alex.williamson@redhat.com> <CABUrSUD6hE=h3-Ho7L_J=OYeRUw_Bmg9o4fuw591iw9QyBQv9A@mail.gmail.com>
 <20230308130619.3736cf18.alex.williamson@redhat.com> <CABUrSUBBbXRVRo6b1EKBpgu7zk=8yZhQ__UXFGL_GpO+BA4Pkg@mail.gmail.com>
 <20230308163803.6bfc2922.alex.williamson@redhat.com>
In-Reply-To: <20230308163803.6bfc2922.alex.williamson@redhat.com>
From:   Dominik Behr <dbehr@chromium.org>
Date:   Wed, 8 Mar 2023 17:51:32 -0800
Message-ID: <CABUrSUAbJJJfGYQuXe-k+partE8UebEvK47zuGXEAtdAjg-yPA@mail.gmail.com>
Subject: Re: [PATCH] vfio/pci: Propagate ACPI notifications to the user-space
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Dominik Behr <dbehr@chromium.org>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        upstream@semihalf.com, dtor@google.com, jgg@ziepe.ca,
        kevin.tian@intel.com, cohuck@redhat.com, abhsahu@nvidia.com,
        yishaih@nvidia.com, yi.l.liu@intel.com, kvm@vger.kernel.org,
        libvir-list@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All other ACPI events that are available to userspace are on netlink alread=
y.
As for translation of ACPI paths. It is sort of a requirement for VMM
to translate the PCI path from host to guest because the PCI device
tree in the guest is totally different already. The same follows for
ACPI paths.

What would you propose instead of netlink?
Sysfs entry for VFIO PCI device that accepts eventfd and signals the
events via eventfd? Or moving it into ACPI layer entirely and adding
eventfd sysfs interface for all ACPI devices?
--
Dominik



On Wed, Mar 8, 2023 at 3:38=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
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
