Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4F4132EBF
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 19:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgAGS4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 13:56:20 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728358AbgAGS4U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jan 2020 13:56:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578423378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eC2tkBULAWqXhye0bf//BBmsWkRf4gna7XuvdCNzRnI=;
        b=Nb5tv+MIr9jnarbSndVBc1TLD07JuxmOUIzDGTlka0tgndQJ4gMOCAWZhLIYgTq4yaEXC6
        UqYvGfKiu8R0Azs5Fh0JPZ9nFje96xVoFxkM8XGGrErOgKfmb7A/t/0HK6zMXDR+qEgCI1
        YeajLJm8IMEr36VBPeHcct40ecPxuKg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-ICI4B1HNM-eKDbFSompWvQ-1; Tue, 07 Jan 2020 13:56:15 -0500
X-MC-Unique: ICI4B1HNM-eKDbFSompWvQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB65C801E72;
        Tue,  7 Jan 2020 18:56:12 +0000 (UTC)
Received: from w520.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76B785C1B0;
        Tue,  7 Jan 2020 18:56:02 +0000 (UTC)
Date:   Tue, 7 Jan 2020 11:56:02 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <jonathan.davies@nutanix.com>, <eauger@redhat.com>,
        <aik@ozlabs.ru>, <pasic@linux.ibm.com>, <felipe@nutanix.com>,
        <Zhengxiao.zx@alibaba-inc.com>, <shuangtai.tst@alibaba-inc.com>,
        <Ken.Xue@amd.com>, <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20200107115602.25156c41@w520.home>
In-Reply-To: <08b7f953-6ac5-cd79-b1ff-54338da32d1e@nvidia.com>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
        <1576527700-21805-2-git-send-email-kwankhede@nvidia.com>
        <20191216154406.023f912b@x1.home>
        <f773a92a-acbd-874d-34ba-36c1e9ffe442@nvidia.com>
        <20191217114357.6496f748@x1.home>
        <3527321f-e310-8324-632c-339b22f15de5@nvidia.com>
        <20191219102706.0a316707@x1.home>
        <928e41b5-c3fd-ed75-abd6-ada05cda91c9@nvidia.com>
        <20191219140929.09fa24da@x1.home>
        <20200102182537.GK2927@work-vm>
        <20200106161851.07871e28@w520.home>
        <ce132929-64a7-9a5b-81ff-38616202b757@nvidia.com>
        <20200107100923.2f7b5597@w520.home>
        <08b7f953-6ac5-cd79-b1ff-54338da32d1e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jan 2020 23:23:17 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 1/7/2020 10:39 PM, Alex Williamson wrote:
> > On Tue, 7 Jan 2020 12:58:22 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 1/7/2020 4:48 AM, Alex Williamson wrote:  
> >>> On Thu, 2 Jan 2020 18:25:37 +0000
> >>> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> >>>      
> >>>> * Alex Williamson (alex.williamson@redhat.com) wrote:  
> >>>>> On Fri, 20 Dec 2019 01:40:35 +0530
> >>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>>>         
> >>>>>> On 12/19/2019 10:57 PM, Alex Williamson wrote:
> >>>>>>
> >>>>>> <Snip>
> >>>>>>         
> >>>>
> >>>> <snip>
> >>>>     
> >>>>>>
> >>>>>> If device state it at pre-copy state (011b).
> >>>>>> Transition, i.e., write to device state as stop-and-copy state (010b)
> >>>>>> failed, then by previous state I meant device should return pre-copy
> >>>>>> state(011b), i.e. previous state which was successfully set, or as you
> >>>>>> said current state which was successfully set.  
> >>>>>
> >>>>> Yes, the point I'm trying to make is that this version of the spec
> >>>>> tries to tell the user what they should do upon error according to our
> >>>>> current interpretation of the QEMU migration protocol.  We're not
> >>>>> defining the QEMU migration protocol, we're defining something that can
> >>>>> be used in a way to support that protocol.  So I think we should be
> >>>>> concerned with defining our spec, for example my proposal would be: "If
> >>>>> a state transition fails the user can read device_state to determine the
> >>>>> current state of the device.  This should be the previous state of the
> >>>>> device unless the vendor driver has encountered an internal error, in
> >>>>> which case the device may report the invalid device_state 110b.  The
> >>>>> user must use the device reset ioctl in order to recover the device
> >>>>> from this state.  If the device is indicated in a valid device state
> >>>>> via reading device_state, the user may attempt to transition the device
> >>>>> to any valid state reachable from the current state."  
> >>>>
> >>>> We might want to be able to distinguish between:
> >>>>     a) The device has failed and needs a reset
> >>>>     b) The migration has failed  
> >>>
> >>> I think the above provides this.  For Kirti's example above of
> >>> transitioning from pre-copy to stop-and-copy, the device could refuse
> >>> to transition to stop-and-copy, generating an error on the write() of
> >>> device_state.  The user re-reading device_state would allow them to
> >>> determine the current device state, still in pre-copy or failed.  Only
> >>> the latter would require a device reset.
> >>>      
> >>>> If some part of the devices mechanics for migration fail, but the device
> >>>> is otherwise operational then we should be able to decide to fail the
> >>>> migration without taking the device down, which might be very bad for
> >>>> the VM.
> >>>> Losing a VM during migration due to a problem with migration really
> >>>> annoys users; it's one thing the migration failing, but taking the VM
> >>>> out as well really gets to them.
> >>>>
> >>>> Having the device automatically transition back to the 'running' state
> >>>> seems a bad idea to me; much better to tell the hypervisor and provide
> >>>> it with a way to clean up; for example, imagine a system with multiple
> >>>> devices that are being migrated, most of them have happily transitioned
> >>>> to stop-and-copy, but then the last device decides to fail - so now
> >>>> someone is going to have to take all of them back to running.  
> >>>
> >>> Right, unless I'm missing one, it seems invalid->running is the only
> >>> self transition the device should make, though still by way of user
> >>> interaction via the reset ioctl.  Thanks,
> >>>      
> >>
> >> Instead of using invalid state by vendor driver on device failure, I
> >> think better to reserve one bit in device state which vendor driver can
> >> set on device failure. When error bit is set, other bits in device state
> >> should be ignored.  
> > 
> > Why is a separate bit better?  Saving and Restoring states are mutually
> > exclusive, so we have an unused and invalid device state already
> > without burning another bit.  Thanks,
> >   
> 
> There are 3 invalid states:
>   *  101b => Invalid state
>   *  110b => Invalid state
>   *  111b => Invalid state
> 
> why only 110b should be used to report error from vendor driver to 
> report error? Aren't we adding more confusions in the interface?

I think the only chance of confusion is poor documentation.  If we
define all of the above as invalid and then say any invalid state
indicates an error condition, then the burden is on the user to
enumerate all the invalid states.  That's not a good idea.  Instead we
could say 101b (_RESUMING|_RUNNING) is reserved, it's not currently
used but it might be useful some day.  Therefore there are no valid
transitions into or out of this state.  A vendor driver should fail a
write(2) attempting to enter this state.

That leaves 11Xb, where we consider _RESUMING and _SAVING as mutually
exclusive, so neither are likely to ever be valid states.  Logically,
if the device is in a failed state such that it needs to be reset to be
recovered, I would hope the device is not running, so !_RUNNING (110b)
seems appropriate.  I'm not sure we need that level of detail yet
though, so I was actually just assuming both 11Xb states would indicate
an error state and the undefined _RUNNING bit might differentiate
something in the future.

Therefore, I think we'd have:

 * 101b => Reserved
 * 11Xb => Error

Where the device can only self transition into the Error state on a
failed device_state transition and the only exit from the Error state
is via the reset ioctl.  The Reserved state is unreachable.  The vendor
driver must error on device_state writes to enter or exit the Error
state and must error on writes to enter Reserved states.  Is that still
confusing?

> Only 3 bits from 32 bits are yet used, one bit can be spared to 
> represent error state from vendor driver.

I just don't see that it adds any value to use a separate bit, we
already have more error states than we need with the 3 bits we have.
Thanks,

Alex

