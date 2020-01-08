Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F829134F8D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 23:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbgAHWoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 17:44:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726548AbgAHWoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 17:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578523476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Ce7iZ/TvYsErucJW9xUbmo6R4UGv0zMfYGiP22GnZw=;
        b=HWSGJDPoP12JdLwhPZngsHGxn3+lhKc7H6zNKUs4SxS8csl4i4Aa7RU7aGmQNjHL8+VFFg
        HwbMC+YsYzBmhZDeIfTE3LbH4Q9lelFVjk4FJJw8wDVnunBzav8ieN62kdAQg1pRg+Z8ww
        L9x7HhXi/+jIkBwPnzWNUlzhBuynG+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-m9eHdCQpO628d-yNeO_pKw-1; Wed, 08 Jan 2020 17:44:33 -0500
X-MC-Unique: m9eHdCQpO628d-yNeO_pKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 923821005502;
        Wed,  8 Jan 2020 22:44:30 +0000 (UTC)
Received: from w520.home (ovpn-118-62.phx2.redhat.com [10.3.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C87E19C58;
        Wed,  8 Jan 2020 22:44:28 +0000 (UTC)
Date:   Wed, 8 Jan 2020 15:44:28 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <jonathan.davies@nutanix.com>, <eauger@redhat.com>,
        <aik@ozlabs.ru>, <pasic@linux.ibm.com>, <felipe@nutanix.com>,
        <Zhengxiao.zx@alibaba-inc.com>, <shuangtai.tst@alibaba-inc.com>,
        <Ken.Xue@amd.com>, <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20200108154428.02bb312d@w520.home>
In-Reply-To: <46ac2d9e-4f4e-27d5-2a96-932c444e3461@nvidia.com>
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
        <20200107115602.25156c41@w520.home>
        <20200108155955.78e908c1.cohuck@redhat.com>
        <20200108113134.05c08470@w520.home>
        <46ac2d9e-4f4e-27d5-2a96-932c444e3461@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jan 2020 02:11:11 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 1/9/2020 12:01 AM, Alex Williamson wrote:
> > On Wed, 8 Jan 2020 15:59:55 +0100
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> >> On Tue, 7 Jan 2020 11:56:02 -0700
> >> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>  
> >>> On Tue, 7 Jan 2020 23:23:17 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:  
> >>  
> >>>> There are 3 invalid states:
> >>>>    *  101b => Invalid state
> >>>>    *  110b => Invalid state
> >>>>    *  111b => Invalid state
> >>>>
> >>>> why only 110b should be used to report error from vendor driver to
> >>>> report error? Aren't we adding more confusions in the interface?  
> >>>
> >>> I think the only chance of confusion is poor documentation.  If we
> >>> define all of the above as invalid and then say any invalid state
> >>> indicates an error condition, then the burden is on the user to
> >>> enumerate all the invalid states.  That's not a good idea.  Instead we
> >>> could say 101b (_RESUMING|_RUNNING) is reserved, it's not currently
> >>> used but it might be useful some day.  Therefore there are no valid
> >>> transitions into or out of this state.  A vendor driver should fail a
> >>> write(2) attempting to enter this state.
> >>>
> >>> That leaves 11Xb, where we consider _RESUMING and _SAVING as mutually
> >>> exclusive, so neither are likely to ever be valid states.  Logically,
> >>> if the device is in a failed state such that it needs to be reset to be
> >>> recovered, I would hope the device is not running, so !_RUNNING (110b)
> >>> seems appropriate.  I'm not sure we need that level of detail yet
> >>> though, so I was actually just assuming both 11Xb states would indicate
> >>> an error state and the undefined _RUNNING bit might differentiate
> >>> something in the future.
> >>>
> >>> Therefore, I think we'd have:
> >>>
> >>>   * 101b => Reserved
> >>>   * 11Xb => Error
> >>>
> >>> Where the device can only self transition into the Error state on a
> >>> failed device_state transition and the only exit from the Error state
> >>> is via the reset ioctl.  The Reserved state is unreachable.  The vendor
> >>> driver must error on device_state writes to enter or exit the Error
> >>> state and must error on writes to enter Reserved states.  Is that still
> >>> confusing?  
> >>
> >> I think one thing we could do is start to tie the meaning more to the
> >> actual state (bit combination) and less to the individual bits. I.e.
> >>
> >> - bit 0 indicates 'running',
> >> - bit 1 indicates 'saving',
> >> - bit 2 indicates 'resuming',
> >> - bits 3-31 are reserved. [Aside: reserved-and-ignored or
> >>    reserved-and-must-be-zero?]  
> > 
> > This version specified them as:
> > 
> > 	Bits 3 - 31 are reserved for future use. User should perform
> > 	read-modify-write operation on this field.
> > 
> > The intention is that the user should not make any assumptions about
> > the state of the reserved bits, but should preserve them when changing
> > known bits.  Therefore I think it's ignored but preserved.  If we
> > specify them as zero, then I think we lose any chance to define them
> > later.
> >   
> >> [Note that I don't specify what happens when a bit is set or unset.]
> >>
> >> States are then defined as:
> >> 000b => stopped state (not saving or resuming)
> >> 001b => running state (not saving or resuming)
> >> 010b => stop-and-copy state
> >> 011b => pre-copy state
> >> 100b => resuming state
> >>
> >> [Transitions between these states defined, as before.]
> >>
> >> 101b => reserved [for post-copy; no transitions defined]
> >> 111b => reserved [state does not make sense; no transitions defined]
> >> 110b => error state [state does not make sense per se, but it does not
> >>          indicate running; transitions into this state *are* possible]
> >>
> >> To a 'reserved' state, we can later assign a different meaning (we
> >> could even re-use 111b for a different error state, if needed); while
> >> the error state must always stay the error state.
> >>
> >> We should probably use some kind of feature indication to signify
> >> whether a 'reserved' state actually has a meaning. Also, maybe we also
> >> should designate the states > 111b as 'reserved'.
> >>
> >> Does that make sense?  
> > 
> > It seems you have an opinion to restrict this particular error state to
> > 110b rather than 11Xb, reserving 111b for some future error condition.
> > That's fine and I think we agree that using the state with _RUNNING set
> > to zero is more logical as we expect the device to be non-operational
> > in this state.
> > 
> > I'm also thinking more of these as states, but at the same time we're
> > not doing away with the bit definitions.  I think the states are much
> > easier to decode and use if we think about the function of each bit,
> > which leads to the logical incongruity that the 11Xb states are
> > impossible and therefore must be error states.
> >   
> 
> I agree on bit definition is better.
> 
> Ok. Should there be a defined value for error, which can be used by 
> vendor driver for error state?
> 
> #define VFIO_DEVICE_STATE_ERROR			\
> 		(VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RESUMING)

Seems like a good idea for consistency.  Thanks,

Alex

