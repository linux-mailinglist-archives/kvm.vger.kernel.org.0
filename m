Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB66A136F33
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgAJOVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:21:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57740 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727746AbgAJOVh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 09:21:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578666095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGXWI3monwW6hEW9z+N5Xg8fGIxYQC8MXY9UwxRNWf8=;
        b=UpAtD92WAvoyCIPlIyE3FVwtwQHeVxB2K7WmdN6dP1HPbee3OWuJHS14aD8qAVgq+l59zB
        YHAa54lSDHTEUYeXfk56YyNJ34GDGiRCJq5xZ9G/UAnb7Xn3RTt6o0MAqbuJoTrIb1TFjd
        CyM4lfWELi2drK0XkBpCHH3N7+zKblo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-3p3V5eZ6M_yHk9YIo3GFMg-1; Fri, 10 Jan 2020 09:21:22 -0500
X-MC-Unique: 3p3V5eZ6M_yHk9YIo3GFMg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FDD218C35BC;
        Fri, 10 Jan 2020 14:21:20 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C70EE87EC0;
        Fri, 10 Jan 2020 14:21:13 +0000 (UTC)
Date:   Fri, 10 Jan 2020 15:21:11 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
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
Message-ID: <20200110152111.74c87595.cohuck@redhat.com>
In-Reply-To: <20200108154428.02bb312d@w520.home>
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
        <20200108154428.02bb312d@w520.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 15:44:28 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 9 Jan 2020 02:11:11 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > On 1/9/2020 12:01 AM, Alex Williamson wrote:  
> > > On Wed, 8 Jan 2020 15:59:55 +0100
> > > Cornelia Huck <cohuck@redhat.com> wrote:

> > >> I think one thing we could do is start to tie the meaning more to the
> > >> actual state (bit combination) and less to the individual bits. I.e.
> > >>
> > >> - bit 0 indicates 'running',
> > >> - bit 1 indicates 'saving',
> > >> - bit 2 indicates 'resuming',
> > >> - bits 3-31 are reserved. [Aside: reserved-and-ignored or
> > >>    reserved-and-must-be-zero?]    
> > > 
> > > This version specified them as:
> > > 
> > > 	Bits 3 - 31 are reserved for future use. User should perform
> > > 	read-modify-write operation on this field.
> > > 
> > > The intention is that the user should not make any assumptions about
> > > the state of the reserved bits, but should preserve them when changing
> > > known bits.  Therefore I think it's ignored but preserved.  If we
> > > specify them as zero, then I think we lose any chance to define them
> > > later.

Nod. What about extending the description to:

"Bits 3-31 are reserved for future use. In order to preserve them, a
read-modify-write operation on this field should be used when modifying
the specified bits."

?

> > >     
> > >> [Note that I don't specify what happens when a bit is set or unset.]
> > >>
> > >> States are then defined as:
> > >> 000b => stopped state (not saving or resuming)
> > >> 001b => running state (not saving or resuming)
> > >> 010b => stop-and-copy state
> > >> 011b => pre-copy state
> > >> 100b => resuming state
> > >>
> > >> [Transitions between these states defined, as before.]
> > >>
> > >> 101b => reserved [for post-copy; no transitions defined]
> > >> 111b => reserved [state does not make sense; no transitions defined]
> > >> 110b => error state [state does not make sense per se, but it does not
> > >>          indicate running; transitions into this state *are* possible]
> > >>
> > >> To a 'reserved' state, we can later assign a different meaning (we
> > >> could even re-use 111b for a different error state, if needed); while
> > >> the error state must always stay the error state.
> > >>
> > >> We should probably use some kind of feature indication to signify
> > >> whether a 'reserved' state actually has a meaning. Also, maybe we also
> > >> should designate the states > 111b as 'reserved'.
> > >>
> > >> Does that make sense?    
> > > 
> > > It seems you have an opinion to restrict this particular error state to
> > > 110b rather than 11Xb, reserving 111b for some future error condition.
> > > That's fine and I think we agree that using the state with _RUNNING set
> > > to zero is more logical as we expect the device to be non-operational
> > > in this state.

Good.

> > > 
> > > I'm also thinking more of these as states, but at the same time we're
> > > not doing away with the bit definitions.  I think the states are much
> > > easier to decode and use if we think about the function of each bit,
> > > which leads to the logical incongruity that the 11Xb states are
> > > impossible and therefore must be error states.

Yes, that's fine.

> > >     
> > 
> > I agree on bit definition is better.
> > 
> > Ok. Should there be a defined value for error, which can be used by 
> > vendor driver for error state?
> > 
> > #define VFIO_DEVICE_STATE_ERROR			\
> > 		(VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RESUMING)  
> 
> Seems like a good idea for consistency.  Thanks,
> 
> Alex

Agreed, I like that as well.

