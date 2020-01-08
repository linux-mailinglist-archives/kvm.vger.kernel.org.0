Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82958134583
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 16:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgAHPAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 10:00:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50326 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726556AbgAHPAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 10:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578495611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lxa/kWRQEkiOz7sBIo3ceOTr8QumRNMa49cKsp3Y8Xk=;
        b=PEEXmeD0ObL5pKWwH3UirWCJzolG/G3Dj/buogj2pkxqVLWaYT7VnD5mtSYhTEbgVjdhli
        i1O+v8M9a2D510fnTzz5dD9zAKKTmAH8Fh2QqJQQKWfKnS3fqmNuW+sm7+DCyZPP2ja+yN
        eOniTF4p3mMBIfFF7nzqx5pEfcD8/54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-AemsO7ccOuSy8JUg1pUO4w-1; Wed, 08 Jan 2020 10:00:08 -0500
X-MC-Unique: AemsO7ccOuSy8JUg1pUO4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18483DB62;
        Wed,  8 Jan 2020 15:00:05 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12CA35D9E5;
        Wed,  8 Jan 2020 14:59:57 +0000 (UTC)
Date:   Wed, 8 Jan 2020 15:59:55 +0100
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
Message-ID: <20200108155955.78e908c1.cohuck@redhat.com>
In-Reply-To: <20200107115602.25156c41@w520.home>
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
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jan 2020 11:56:02 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 7 Jan 2020 23:23:17 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:

> > There are 3 invalid states:
> >   *  101b => Invalid state
> >   *  110b => Invalid state
> >   *  111b => Invalid state
> > 
> > why only 110b should be used to report error from vendor driver to 
> > report error? Aren't we adding more confusions in the interface?  
> 
> I think the only chance of confusion is poor documentation.  If we
> define all of the above as invalid and then say any invalid state
> indicates an error condition, then the burden is on the user to
> enumerate all the invalid states.  That's not a good idea.  Instead we
> could say 101b (_RESUMING|_RUNNING) is reserved, it's not currently
> used but it might be useful some day.  Therefore there are no valid
> transitions into or out of this state.  A vendor driver should fail a
> write(2) attempting to enter this state.
> 
> That leaves 11Xb, where we consider _RESUMING and _SAVING as mutually
> exclusive, so neither are likely to ever be valid states.  Logically,
> if the device is in a failed state such that it needs to be reset to be
> recovered, I would hope the device is not running, so !_RUNNING (110b)
> seems appropriate.  I'm not sure we need that level of detail yet
> though, so I was actually just assuming both 11Xb states would indicate
> an error state and the undefined _RUNNING bit might differentiate
> something in the future.
> 
> Therefore, I think we'd have:
> 
>  * 101b => Reserved
>  * 11Xb => Error
> 
> Where the device can only self transition into the Error state on a
> failed device_state transition and the only exit from the Error state
> is via the reset ioctl.  The Reserved state is unreachable.  The vendor
> driver must error on device_state writes to enter or exit the Error
> state and must error on writes to enter Reserved states.  Is that still
> confusing?

I think one thing we could do is start to tie the meaning more to the
actual state (bit combination) and less to the individual bits. I.e.

- bit 0 indicates 'running',
- bit 1 indicates 'saving',
- bit 2 indicates 'resuming',
- bits 3-31 are reserved. [Aside: reserved-and-ignored or
  reserved-and-must-be-zero?]

[Note that I don't specify what happens when a bit is set or unset.]

States are then defined as:
000b => stopped state (not saving or resuming)
001b => running state (not saving or resuming)
010b => stop-and-copy state
011b => pre-copy state
100b => resuming state

[Transitions between these states defined, as before.]

101b => reserved [for post-copy; no transitions defined]
111b => reserved [state does not make sense; no transitions defined]
110b => error state [state does not make sense per se, but it does not
        indicate running; transitions into this state *are* possible]

To a 'reserved' state, we can later assign a different meaning (we
could even re-use 111b for a different error state, if needed); while
the error state must always stay the error state.

We should probably use some kind of feature indication to signify
whether a 'reserved' state actually has a meaning. Also, maybe we also
should designate the states > 111b as 'reserved'.

Does that make sense?

