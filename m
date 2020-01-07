Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D048E132312
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 10:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgAGJ54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 04:57:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgAGJ54 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jan 2020 04:57:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578391075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bQMunk6FWbY32TzqInyBs1x6t0/E59W8Q2+Xg/4U8tA=;
        b=Pp8SIOeoBXKAfObrXbBtR4CHk4DcUA7ankGzXMqwxLRnVuuu3fbUErCvQpqux6nALQbtLW
        ue84ujVq+1ErECs41OWGAxDVKCjwOmYKAeMYTQqbw8W4sbxQQQGOWxXUiaROVGYzw9OTzJ
        DL2QsVAdsv+KVxXJwUlz/SIK+GU3lw0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-nleKyKxMNbqFHBsHkOsVpw-1; Tue, 07 Jan 2020 04:57:52 -0500
X-MC-Unique: nleKyKxMNbqFHBsHkOsVpw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76DAB1800D4E;
        Tue,  7 Jan 2020 09:57:49 +0000 (UTC)
Received: from work-vm (ovpn-117-52.ams2.redhat.com [10.36.117.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C9541036D1B;
        Tue,  7 Jan 2020 09:57:42 +0000 (UTC)
Date:   Tue, 7 Jan 2020 09:57:40 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, jonathan.davies@nutanix.com, eauger@redhat.com,
        aik@ozlabs.ru, pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, yan.y.zhao@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v10 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20200107095740.GB2778@work-vm>
References: <1576527700-21805-2-git-send-email-kwankhede@nvidia.com>
 <20191216154406.023f912b@x1.home>
 <f773a92a-acbd-874d-34ba-36c1e9ffe442@nvidia.com>
 <20191217114357.6496f748@x1.home>
 <3527321f-e310-8324-632c-339b22f15de5@nvidia.com>
 <20191219102706.0a316707@x1.home>
 <928e41b5-c3fd-ed75-abd6-ada05cda91c9@nvidia.com>
 <20191219140929.09fa24da@x1.home>
 <20200102182537.GK2927@work-vm>
 <20200106161851.07871e28@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106161851.07871e28@w520.home>
User-Agent: Mutt/1.13.0 (2019-11-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> On Thu, 2 Jan 2020 18:25:37 +0000
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
> > * Alex Williamson (alex.williamson@redhat.com) wrote:
> > > On Fri, 20 Dec 2019 01:40:35 +0530
> > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >   
> > > > On 12/19/2019 10:57 PM, Alex Williamson wrote:
> > > > 
> > > > <Snip>
> > > >   
> > 
> > <snip>
> > 
> > > > 
> > > > If device state it at pre-copy state (011b).
> > > > Transition, i.e., write to device state as stop-and-copy state (010b) 
> > > > failed, then by previous state I meant device should return pre-copy 
> > > > state(011b), i.e. previous state which was successfully set, or as you 
> > > > said current state which was successfully set.  
> > > 
> > > Yes, the point I'm trying to make is that this version of the spec
> > > tries to tell the user what they should do upon error according to our
> > > current interpretation of the QEMU migration protocol.  We're not
> > > defining the QEMU migration protocol, we're defining something that can
> > > be used in a way to support that protocol.  So I think we should be
> > > concerned with defining our spec, for example my proposal would be: "If
> > > a state transition fails the user can read device_state to determine the
> > > current state of the device.  This should be the previous state of the
> > > device unless the vendor driver has encountered an internal error, in
> > > which case the device may report the invalid device_state 110b.  The
> > > user must use the device reset ioctl in order to recover the device
> > > from this state.  If the device is indicated in a valid device state
> > > via reading device_state, the user may attempt to transition the device
> > > to any valid state reachable from the current state."  
> > 
> > We might want to be able to distinguish between:
> >   a) The device has failed and needs a reset
> >   b) The migration has failed
> 
> I think the above provides this.  For Kirti's example above of
> transitioning from pre-copy to stop-and-copy, the device could refuse
> to transition to stop-and-copy, generating an error on the write() of
> device_state.  The user re-reading device_state would allow them to
> determine the current device state, still in pre-copy or failed.  Only
> the latter would require a device reset.

OK - but that doesn't give you any way to figure out 'why' it failed;
I guess I was expecting you to then read an 'error' register to find
out what happened.
Assuming the write() to transition to stop-and-copy fails and you're
still in pre-copy, what's the defined thing you're supposed to do next?
Decide migration has failed and then do a write() to transition to running?

> > If some part of the devices mechanics for migration fail, but the device
> > is otherwise operational then we should be able to decide to fail the
> > migration without taking the device down, which might be very bad for
> > the VM.
> > Losing a VM during migration due to a problem with migration really
> > annoys users; it's one thing the migration failing, but taking the VM
> > out as well really gets to them.
> > 
> > Having the device automatically transition back to the 'running' state
> > seems a bad idea to me; much better to tell the hypervisor and provide
> > it with a way to clean up; for example, imagine a system with multiple
> > devices that are being migrated, most of them have happily transitioned
> > to stop-and-copy, but then the last device decides to fail - so now
> > someone is going to have to take all of them back to running.
> 
> Right, unless I'm missing one, it seems invalid->running is the only
> self transition the device should make, though still by way of user
> interaction via the reset ioctl.  Thanks,
> 
o
Dave
> Alex
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

