Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A9785CE3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 10:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbfHHI3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 04:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731677AbfHHI3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 04:29:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 29FD030A00AB;
        Thu,  8 Aug 2019 08:29:37 +0000 (UTC)
Received: from gondolin (dhcp-192-181.str.redhat.com [10.33.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A02C75C219;
        Thu,  8 Aug 2019 08:29:33 +0000 (UTC)
Date:   Thu, 8 Aug 2019 10:29:31 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wankhede@nvidia.com" <wankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCH v1 2/2] vfio/mdev: Removed unused and redundant API for
 mdev UUID
Message-ID: <20190808102931.40c6b4ae.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB48664379F91C8FA3D0035B41D1D40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190806141826.52712-1-parav@mellanox.com>
        <20190806141826.52712-3-parav@mellanox.com>
        <20190807112801.6b2ceb36.cohuck@redhat.com>
        <AM0PR05MB48664379F91C8FA3D0035B41D1D40@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 08 Aug 2019 08:29:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Aug 2019 16:33:11 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Wednesday, August 7, 2019 2:58 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: kvm@vger.kernel.org; wankhede@nvidia.com; linux-
> > kernel@vger.kernel.org; alex.williamson@redhat.com; cjia@nvidia.com
> > Subject: Re: [PATCH v1 2/2] vfio/mdev: Removed unused and redundant API for
> > mdev UUID
> > 
> > On Tue,  6 Aug 2019 09:18:26 -0500
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > There is no single production driver who is interested in mdev device
> > > uuid. Currently UUID is mainly used to derive a device name.
> > > Additionally mdev device name is already available using core kernel
> > > API dev_name().  
> > 
> > Well, the mdev code actually uses the uuid to check for duplicates before
> > registration with the driver core would fail... I'd just drop the two sentences  
> Yes, it does the check. But its mainly used to derive a device name.
> And to ensure that there are no two devices with duplicate name, it compares with the uuid.
> 
> Even this 16 bytes storage is redundant.
> Subsequently, I will submit a patch to get rid of storing this 16 bytes of UUID too.
> Because for duplicate name check, device name itself is pretty good enough.
> 
> Since I ran out of time and rc-4 is going on, I differed the 3rd simplification patch.

I'm not sure why we'd want to ditch the uuid; it's not like it is
taking up huge amounts of space... and I see the device name being
derived from the unique identifier that is the uuid, and not as the
unique identifier itself.

> 
> Commit message actually came from the thoughts of 3rd patch, but I see that without it, its not so intuitive.
> 
> > talking about the device name, IMHO they don't really add useful information;
> > but I'll leave that decision to the maintainers.
> >   
> > >
> > > Hence removed unused exported symbol.
> > >
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > ---
> > > Changelog:
> > > v0->v1:
> > >  - Updated commit log to address comments from Cornelia
> > > ---
> > >  drivers/vfio/mdev/mdev_core.c | 6 ------
> > >  include/linux/mdev.h          | 1 -
> > >  2 files changed, 7 deletions(-)  
> > 
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>  
> Thanks for the review.

