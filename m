Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13566FBA12
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 21:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKMUkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 15:40:41 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60138 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbfKMUkk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 15:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573677638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gpi6XeaEVLYmonRBi//O4W78pt3J9hw3wKdlpJkcI+M=;
        b=asUf3IBeT/mBeY4ydyIMJyJyFjLi/VYSg87wY9JaAaUKycXgwDV+ltDXSP2raUacQd/0s0
        CCiXz1+aJdDnk6NGtbcXNZX3kHhqhRp0B2Gf1+SPbJFzU0YJMlHflpee+10I7sixo/h8by
        csUMCmI59AiB5vS2nuad0zjMyqFxtek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-ru1TB6JlPiu7Wxmy6u0fjg-1; Wed, 13 Nov 2019 15:40:35 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F59110557DF;
        Wed, 13 Nov 2019 20:40:33 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5958660257;
        Wed, 13 Nov 2019 20:40:05 +0000 (UTC)
Date:   Wed, 13 Nov 2019 13:40:04 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v9 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20191113134004.528063a9@x1.home>
In-Reply-To: <f0673bfe-7db9-d54d-ce2a-c4b834543478@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-2-git-send-email-kwankhede@nvidia.com>
        <20191112153005.53bf324c@x1.home>
        <20191113112417.6e40ce96.cohuck@redhat.com>
        <20191113112733.49542ebc@x1.home>
        <94592507-fadb-0f10-ee17-f8d5678c70e5@nvidia.com>
        <20191113124818.2b5be89d@x1.home>
        <f0673bfe-7db9-d54d-ce2a-c4b834543478@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: ru1TB6JlPiu7Wxmy6u0fjg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 01:47:04 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 11/14/2019 1:18 AM, Alex Williamson wrote:
> > On Thu, 14 Nov 2019 00:59:52 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >  =20
> >> On 11/13/2019 11:57 PM, Alex Williamson wrote: =20
> >>> On Wed, 13 Nov 2019 11:24:17 +0100
> >>> Cornelia Huck <cohuck@redhat.com> wrote:
> >>>     =20
> >>>> On Tue, 12 Nov 2019 15:30:05 -0700
> >>>> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>>>    =20
> >>>>> On Tue, 12 Nov 2019 22:33:36 +0530
> >>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>>>        =20
> >>>>>> - Defined MIGRATION region type and sub-type.
> >>>>>> - Used 3 bits to define VFIO device states.
> >>>>>>       Bit 0 =3D> _RUNNING
> >>>>>>       Bit 1 =3D> _SAVING
> >>>>>>       Bit 2 =3D> _RESUMING
> >>>>>>       Combination of these bits defines VFIO device's state during=
 migration
> >>>>>>       _RUNNING =3D> Normal VFIO device running state. When its res=
et, it
> >>>>>> =09=09indicates _STOPPED state. when device is changed to
> >>>>>> =09=09_STOPPED, driver should stop device before write()
> >>>>>> =09=09returns.
> >>>>>>       _SAVING | _RUNNING =3D> vCPUs are running, VFIO device is ru=
nning but
> >>>>>>                             start saving state of device i.e. pre-=
copy state
> >>>>>>       _SAVING  =3D> vCPUs are stopped, VFIO device should be stopp=
ed, and =20
> >>>>>
> >>>>> s/should/must/
> >>>>>        =20
> >>>>>>                   save device state,i.e. stop-n-copy state
> >>>>>>       _RESUMING =3D> VFIO device resuming state.
> >>>>>>       _SAVING | _RESUMING and _RUNNING | _RESUMING =3D> Invalid st=
ates =20
> >>>>>
> >>>>> A table might be useful here and in the uapi header to indicate val=
id
> >>>>> states: =20
> >>>>
> >>>> I like that.
> >>>>    =20
> >>>>>
> >>>>> | _RESUMING | _SAVING | _RUNNING | Description
> >>>>> +-----------+---------+----------+---------------------------------=
---------
> >>>>> |     0     |    0    |     0    | Stopped, not saving or resuming =
(a)
> >>>>> +-----------+---------+----------+---------------------------------=
---------
> >>>>> |     0     |    0    |     1    | Running, default state
> >>>>> +-----------+---------+----------+---------------------------------=
---------
> >>>>> |     0     |    1    |     0    | Stopped, migration interface in =
save mode
> >>>>> +-----------+---------+----------+---------------------------------=
---------
> >>>>> |     0     |    1    |     1    | Running, save mode interface, it=
erative
> >>>>> +-----------+---------+----------+---------------------------------=
---------
> >>>>> |     1     |    0    |     0    | Stopped, migration resume interf=
ace active
> >>>>> +-----------+---------+----------+---------------------------------=
---------
> >>>>> |     1     |    0    |     1    | Invalid (b)
> >>>>> +-----------+---------+----------+---------------------------------=
---------
> >>>>> |     1     |    1    |     0    | Invalid (c)
> >>>>> +-----------+---------+----------+---------------------------------=
---------
> >>>>> |     1     |    1    |     1    | Invalid (d)
> >>>>>
> >>>>> I think we need to consider whether we define (a) as generally
> >>>>> available, for instance we might want to use it for diagnostics or =
a
> >>>>> fatal error condition outside of migration.
> >>>>>
> >>>>> Are there hidden assumptions between state transitions here or are
> >>>>> there specific next possible state diagrams that we need to include=
 as
> >>>>> well? =20
> >>>>
> >>>> Some kind of state-change diagram might be useful in addition to the
> >>>> textual description anyway. Let me try, just to make sure I understa=
nd
> >>>> this correctly:
> >>>>    =20
> >>
> >> During User application initialization, there is one more state change=
:
> >>
> >> 0) 0/0/0 ---- stop to running -----> 0/0/1 =20
> >=20
> > 0/0/0 cannot be the initial state of the device, that would imply that
> > a device supporting this migration interface breaks backwards
> > compatibility with all existing vfio userspace code and that code needs
> > to learn to set the device running as part of its initialization.
> > That's absolutely unacceptable.  The initial device state must be 0/0/1=
.
> >  =20
>=20
> There isn't any device state for all existing vfio userspace code right=
=20
> now. So default its assumed to be always running.

Exactly, there is no representation of device state, therefore it's
assumed to be running, therefore when adding a representation of device
state it must default to running.

> With migration support, device states are explicitly getting added. For=
=20
> example, in case of QEMU, while device is getting initialized, i.e. from=
=20
> vfio_realize(), device_state is set to 0/0/0, but not required to convey=
=20
> it to vendor driver.

But we have a 0/0/0 state, why would we intentionally keep an internal
state that's inconsistent with the device?

> Then with vfio_vmstate_change() notifier, device=20
> state is changed to 0/0/1 when VM/vCPU are transitioned to running, at=20
> this moment device state is conveyed to vendor driver. So vendor driver=
=20
> doesn't see 0/0/0 state.

But the running state is the state of the device, not the VM or the
vCPU.  Sure we might want to stop the device if the VM/vCPU state is
stopped, but we must accept that the device is running when it's opened
and we shouldn't intentionally maintain inconsistent state.
=20
> While resuming, for userspace, for example QEMU, device state change is=
=20
> from 0/0/0 to 1/0/0, vendor driver see 1/0/0 after device basic=20
> initialization is done.

I don't see why this matters, all device_state transitions are written
directly to the vendor driver.  The device is initially in 0/0/1 and
can be set to 1/0/0 for resuming with an optional transition through
0/0/0 and the vendor driver can see each state change.

> >>>> 1) 0/0/1 ---(trigger driver to start gathering state info)---> 0/1/1=
 =20
> >>
> >> not just gathering state info, but also copy device state to be
> >> transferred during pre-copy phase.
> >>
> >> Below 2 state are not just to tell driver to stop, those 2 differ.
> >> 2) is device state changed from running to stop, this is when VM
> >> shutdowns cleanly, no need to save device state =20
> >=20
> > Userspace is under no obligation to perform this state change though,
> > backwards compatibility dictates this.
> >    =20
> >>>> 2) 0/0/1 ---(tell driver to stop)---> 0/0/0 =20
> >> =20
> >>>> 3) 0/1/1 ---(tell driver to stop)---> 0/1/0 =20
> >>
> >> above is transition from pre-copy phase to stop-and-copy phase, where
> >> device data should be made available to user to transfer to destinatio=
n
> >> or to save it to file in case of save VM or suspend.
> >>
> >> =20
> >>>> 4) 0/0/1 ---(tell driver to resume with provided info)---> 1/0/0 =20
> >>>
> >>> I think this is to switch into resuming mode, the data will follow > =
=20
> >>>> 5) 1/0/0 ---(driver is ready)---> 0/0/1
> >>>> 6) 0/1/1 ---(tell driver to stop saving)---> 0/0/1 =20
> >>>    =20
> >>
> >> above can occur on migration cancelled or failed.
> >>
> >> =20
> >>> I think also:
> >>>
> >>> 0/0/1 --> 0/1/0 If user chooses to go directly to stop and copy =20
> >>
> >> that's right, this happens in case of save VM or suspend VM.
> >> =20
> >>>
> >>> 0/0/0 and 0/0/1 should be reachable from any state, though I could se=
e
> >>> that a vendor driver could fail transition from 1/0/0 -> 0/0/1 if the
> >>> received state is incomplete.  Somehow though a user always needs to
> >>> return the device to the initial state, so how does device_state
> >>> interact with the reset ioctl?  Would this automatically manipulate
> >>> device_state back to 0/0/1? =20
> >>
> >> why would reset occur on 1/0/0 -> 0/0/1 failure? =20
> >=20
> > The question is whether the reset ioctl automatically puts the device
> > back into the initial state, 0/0/1.  A reset from 1/0/0 -> 0/0/1
> > presumably discards much of the device state we just restored, so
> > clearly that would be undesirable.
> >    =20
> >> 1/0/0 -> 0/0/1 fails, then user should convey that to source that
> >> migration has failed, then resume at source. =20
> >=20
> > In the scheme of the migration yet, but as far as the vfio interface is
> > concerned the user should have a path to make use of a device after
> > this point without closing it and starting over.  Thus, if a 1/0/0 ->
> > 0/0/1 transition fails, would we define the device reset ioctl as a
> > mechanism to flush the bogus state and place the device into the 0/0/1
> > initial state?
> > =20
>=20
> Ok, userspace applications can be designed to do that. As of now with=20
> QEMU, I don't see a way to reset device on 1/0/0-> 0/0/1 failure.

It's simply an ioctl, we must already have access to the device file
descriptor to perform the device_state transition.  QEMU is not
necessarily the consumer of this behavior though, if transition 1/0/0
-> 0/0/1 fails in QEMU, it very well may just exit.  The vfio API
should support a defined mechanism to recover the device from this
state though, which I propose is the existing reset ioctl, which
logically implies that any device reset returns the device_state to
0/0/1.

> >>>> Not sure about the usefulness of 2). =20
> >>
> >> I explained this above.
> >> =20
> >>>> Also, is 4) the only way to
> >>>> trigger resuming? =20
> >> Yes.
> >> =20
> >>>> And is the change in 5) performed by the driver, or
> >>>> by userspace?
> >>>>    =20
> >> By userspace.
> >> =20
> >>>> Are any other state transitions valid?
> >>>>
> >>>> (...)
> >>>>    =20
> >>>>>> + * Sequence to be followed for _SAVING|_RUNNING device state or p=
re-copy phase
> >>>>>> + * and for _SAVING device state or stop-and-copy phase:
> >>>>>> + * a. read pending_bytes. If pending_bytes > 0, go through below =
steps.
> >>>>>> + * b. read data_offset, indicates kernel driver to write data to =
staging buffer.
> >>>>>> + *    Kernel driver should return this read operation only after =
writing data to
> >>>>>> + *    staging buffer is done. =20
> >>>>>
> >>>>> "staging buffer" implies a vendor driver implementation, perhaps we
> >>>>> could just state that data is available from (region + data_offset)=
 to
> >>>>> (region + data_offset + data_size) upon return of this read operati=
on.
> >>>>>        =20
> >>>>>> + * c. read data_size, amount of data in bytes written by vendor d=
river in
> >>>>>> + *    migration region.
> >>>>>> + * d. read data_size bytes of data from data_offset in the migrat=
ion region.
> >>>>>> + * e. process data.
> >>>>>> + * f. Loop through a to e. Next read on pending_bytes indicates t=
hat read data
> >>>>>> + *    operation from migration region for previous iteration is d=
one. =20
> >>>>>
> >>>>> I think this indicate that step (f) should be to read pending_bytes=
, the
> >>>>> read sequence is not complete until this step.  Optionally the user=
 can
> >>>>> then proceed to step (b).  There are no read side-effects of (a) af=
aict.
> >>>>>
> >>>>> Is the use required to reach pending_bytes =3D=3D 0 before changing
> >>>>> device_state, particularly transitioning to !_RUNNING?  Presumably =
the
> >>>>> user can exit this sequence at any time by clearing _SAVING. =20
> >>>>
> >>>> That would be transition 6) above (abort saving and continue). I thi=
nk
> >>>> it makes sense not to forbid this.
> >>>>    =20
> >>>>>        =20
> >>>>>> + *
> >>>>>> + * Sequence to be followed while _RESUMING device state:
> >>>>>> + * While data for this device is available, repeat below steps:
> >>>>>> + * a. read data_offset from where user application should write d=
ata.
> >>>>>> + * b. write data of data_size to migration region from data_offse=
t.
> >>>>>> + * c. write data_size which indicates vendor driver that data is =
written in
> >>>>>> + *    staging buffer. Vendor driver should read this data from mi=
gration
> >>>>>> + *    region and resume device's state. =20
> >>>>>
> >>>>> The device defaults to _RUNNING state, so a prerequisite is to set
> >>>>> _RESUMING and clear _RUNNING, right? =20
> >>>>    =20
> >>
> >> Sorry, I replied yes in my previous reply, but no. Default device stat=
e
> >> is _STOPPED. During resume _STOPPED -> _RESUMING =20
> >=20
> > Nope, it can't be, it must be _RUNNING.
> >  =20
> >>>> Transition 4) above. Do we need =20
> >>
> >> I think, its not required. =20
> >=20
> > But above we say it's the only way to trigger resuming (4 was 0/0/1 ->
> > 1/0/0).
> >  =20
> >>>> 7) 0/0/0 ---(tell driver to resume with provided info)---> 1/0/0
> >>>> as well? (Probably depends on how sensible the 0/0/0 state is.) =20
> >>>
> >>> I think we must unless we require the user to transition from 0/0/1 t=
o
> >>> 1/0/0 in a single operation, but I'd prefer to make 0/0/0 generally
> >>> available.  Thanks,
> >>>     =20
> >>
> >> its 0/0/0 -> 1/0/0 while resuming. =20
> >=20
> > I think we're starting with different initial states, IMO there is
> > absolutely no way around 0/0/1 being the initial device state.
> > Anything otherwise means that we cannot add migration support to an
> > existing device and maintain compatibility with existing userspace.
> > Thanks,
> >  =20
> Hope above explanation helps to resolve this concern.

Not really, I stand by that the default state must reflect previous
assumptions and therefore it must be 0/0/1 and additionally we should
not maintain state in QEMU intentionally inconsistent with the device
state.  Thanks,

Alex

