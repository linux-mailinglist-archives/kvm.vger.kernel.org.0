Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9FD6B1572
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 23:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCHWpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 17:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCHWoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 17:44:46 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF57FCF0C9
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 14:44:40 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id bo10so233800qvb.12
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 14:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678315480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2BACJ9o1GpsXQRNH/d2FnPzz3XG8R9/bHT2tgvw3dw=;
        b=eOTA6apLmzNFQXX21R5IlRVVYq21JBjAWXbXm59nv416Z0NnTiCLjaLcJCEnEUzxyw
         H3OIJyiLmFo6a2YU6DsXG844x8ZdAUYoNcgnNGOBwGhVHeHKyHd7RWI1cg7TuC+2rvSl
         KpioIFNbdBNlJher0hJNNtT7mRiViItnSLg9Q7AXvLHv51y3PZvbs/h19mViysULqVzz
         K8DFzYktcwEDOIqJdpr5Up5crrP1Z1bnVw4oI6eukDp6OGcyCYbA80xjXlzOZdpiYdZc
         i1P09yRTkTjkQBfmB7CqA/AkPi3PUHqoJEsTBmF9qDz0YNNQm6eaprg+hOqiBEwlulQj
         b2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678315480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s2BACJ9o1GpsXQRNH/d2FnPzz3XG8R9/bHT2tgvw3dw=;
        b=Qlg62ZyLGgKA47du8Bl0Pl78kWt7TK1y9FV7KbSg/geB5OFoONPwXCTXdLVSnteUWv
         ajYHWT/HPw2a+y0z9MPWSPy/1OzZ0skr1jO/q9YRwmYvIBFZHImLK4zhW6KVAxp00s4m
         DtQHHv8h2+dkxetgqD8aMzdq8b0au2QjUqgmyO7WqhAYJ+88BMEfuSS9jgu/kY7TVhsx
         1CMxXiU4ngeLOOI8j+GmcVKmLiVrx45xcWLtK1fx3pV4d7EQe0DqMMN5JWegYHwsHZGK
         ZM7syQqs+4iMiFGSKQF7OdjnH/3C5ZLzTtnY17WmHXw/UJWq6CX3DSikK37BbBe+9d1a
         ldhQ==
X-Gm-Message-State: AO0yUKXELzFIens55ttzjKlxNuEGchVKobdnvimvpbkFjwPKxSL1mGBE
        RaKV6SCfwEvvlEUGymlTVECCqRoUm8HHMXCIaN2SWA==
X-Google-Smtp-Source: AK7set8IT1lzqjPrzi3FVc/V4dNU6D1GC8S5JbhRVk/O9v+Pfs4GAozcKKy1xMATFTfmg5Mn38NdWUXKjeqXJ0ZCHxw=
X-Received: by 2002:ad4:5a0e:0:b0:571:e9d3:24a9 with SMTP id
 ei14-20020ad45a0e000000b00571e9d324a9mr4843039qvb.10.1678315479749; Wed, 08
 Mar 2023 14:44:39 -0800 (PST)
MIME-Version: 1.0
References: <20230307220553.631069-1-jaz@semihalf.com> <20230307164158.4b41e32f.alex.williamson@redhat.com>
 <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
 <20230308104944.578d503c.alex.williamson@redhat.com> <CABUrSUD6hE=h3-Ho7L_J=OYeRUw_Bmg9o4fuw591iw9QyBQv9A@mail.gmail.com>
 <20230308130619.3736cf18.alex.williamson@redhat.com>
In-Reply-To: <20230308130619.3736cf18.alex.williamson@redhat.com>
From:   Dominik Behr <dbehr@google.com>
Date:   Wed, 8 Mar 2023 14:44:28 -0800
Message-ID: <CABUrSUBBbXRVRo6b1EKBpgu7zk=8yZhQ__UXFGL_GpO+BA4Pkg@mail.gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 8, 2023 at 12:06=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Wed, 8 Mar 2023 10:45:51 -0800
> Dominik Behr <dbehr@chromium.org> wrote:
>
> > It is the same interface as other ACPI events like AC adapter LID etc
> > are forwarded to user-space.
> >  ACPI events are not particularly high frequency like interrupts.
>
> I'm not sure that's relevant, these interfaces don't proclaim to
> provide isolation among host processes which manage behavior relative
> to accessories.  These are effectively system level services.  It's only
> a very, very specialized use case that places a VMM as peers among these
> processes.  Generally we don't want to grant a VMM any privileges beyond
> what it absolutely needs, so letting a VMM managing an assigned NIC
> really ought not to be able to snoop host events related to anything
> other than the NIC.
How is that related to the fact that we are forwarding VFIO-PCI events
to netlink? Kernel does not grant any privileges to VMM.
There are already other ACPI events on netlink. The implementer of the
VMM can choose to allow VMM to snoop them or not.
In our case our VMM (crosvm) does already snoop LID, battery and AC
adapter events so the guest can adjust its behavior accordingly.
This change just adds another class of ACPI events that are forwarded
to netlink.
>
> > > > > What sort of ACPI events are we expecting to see here and what do=
es user space do with them?
> > The use we are looking at right now are D-notifier events about the
> > GPU power available to mobile discrete GPUs.
> > The firmware notifies the GPU driver and resource daemon to
> > dynamically adjust the amount of power that can be used by the GPU.
> >
> > > The proposed interface really has no introspection, how does the VMM
> > > know which devices need ACPI tables added "upfront"?  How do these
> > > events factor into hotplug device support, where we may not be able t=
o
> > > dynamically inject ACPI code into the VM?
> >
> > The VMM can examine PCI IDs and the associated firmware node of the
> > PCI device to figure out what events to expect and what ACPI table to
> > generate to support it but that should not be necessary.
>
> I'm not entirely sure where your VMM is drawing the line between the VM
> and management tools, but I think this is another case where the
> hypervisor itself should not have privileges to examine the host
> firmware tables to build its own.  Something like libvirt would be
> responsible for that.
Yes, but that depends on the design of hypervisor and VMM and is not
related to this patch.
>
> > A generic GPE based ACPI event forwarder as Grzegorz proposed can be
> > injected at VM init time and handle any notification that comes later,
> > even from hotplug devices.
>
> It appears that forwarder is sending the notify to a specific ACPI
> device node, so it's unclear to me how that becomes boilerplate AML
> added to all VMs.  We'll need to notify different devices based on
> different events, right?
Valid point. The notifications have a "scope" ACPI path.
In my experience these events are consumed without looking where they
came from but I believe the patch can be extended to
provide ACPI path, in your example "_SB.PCI0.GPP0.PEGP" instead of
generic vfio_pci which VMM could use to translate an equivalent ACPI
path in the guest and pass it to a generic ACPI GPE based notifier via
shared memory. Grzegorz could you chime in whether that would be
possible?

>
> > > The acpi_bus_generate_netlink_event() below really only seems to form=
 a
> > > u8 event type from the u32 event.  Is this something that could be
> > > provided directly from the vfio device uAPI with an ioeventfd, thus
> > > providing introspection that a device supports ACPI event notificatio=
ns
> > > and the ability for the VMM to exclusively monitor those events, and
> > > only those events for the device, without additional privileges?
> >
> > From what I can see these events are 8 bit as they come from ACPI.
> > They also do not carry any payload and it is up to the receiving
> > driver to query any additional context/state from the device.
> > This will work the same in the VM where driver can query the same
> > information from the passed through PCI device.
> > There are multiple other netflink based ACPI events forwarders which
> > do exactly the same thing for other devices like AC adapter, lid/power
> > button, ACPI thermal notifications, etc.
> > They all use the same mechanism and can be received by user-space
> > programs whether VMMs or others.
>
> But again, those other receivers are potentially system services, not
> an isolated VM instance operating in a limited privilege environment.
> IMO, it's very different if the host display server has access to lid
> or power events than it is to allow some arbitrary VM that happens to
> have an unrelated assigned device that same privilege.
Therefore these VFIO related ACPI events could be received by a system
service via this netlink event and selectively forwarded to VMM if
such is a desire of whoever implements the userspace.
This is outside the scope of this patch. In our case our VMM does
receive these LID, AC or battery events.

--
Dominik
