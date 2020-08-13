Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD903243C9B
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgHMPeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 11:34:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51548 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726679AbgHMPeX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 11:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597332862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J23PbI5Z1GJaE4z5vFx4HSX5EA2ITg6BdXAol9Sx6UQ=;
        b=jKVREhTlFnW5kQTt3Gk6+pErC48igFcexr5ELHRzS1qCcsMPqaoPBaLgHI02g7elpst9ff
        CsHnTnbNcFtIFY+R+JgejUeUw82XASEZGLDUlxqKQFNbfERAaTF4CdVJlKDsYeGfnRKh8O
        JfeEX3Zk13s8zH4LKBKzjsk6xY6e0ZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-6m1jfj4qMD6kA-M_xaKmEA-1; Thu, 13 Aug 2020 11:34:18 -0400
X-MC-Unique: 6m1jfj4qMD6kA-M_xaKmEA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C46CD807320;
        Thu, 13 Aug 2020 15:34:15 +0000 (UTC)
Received: from gondolin (ovpn-112-216.ams2.redhat.com [10.36.112.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4127F5C1A3;
        Thu, 13 Aug 2020 15:33:50 +0000 (UTC)
Date:   Thu, 13 Aug 2020 17:33:47 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Mooney <smooney@redhat.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        dinechin@redhat.com, devel@ovirt.org,
        Parav Pandit <parav@mellanox.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200813173347.239801fa.cohuck@redhat.com>
In-Reply-To: <20200807135942.5d56a202.cohuck@redhat.com>
References: <20200727072440.GA28676@joy-OptiPlex-7040>
        <20200727162321.7097070e@x1.home>
        <20200729080503.GB28676@joy-OptiPlex-7040>
        <20200804183503.39f56516.cohuck@redhat.com>
        <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
        <20200805021654.GB30485@joy-OptiPlex-7040>
        <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
        <20200805075647.GB2177@nanopsycho>
        <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
        <20200805093338.GC30485@joy-OptiPlex-7040>
        <20200805105319.GF2177@nanopsycho>
        <4cf2824c803c96496e846c5b06767db305e9fb5a.camel@redhat.com>
        <20200807135942.5d56a202.cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Aug 2020 13:59:42 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 05 Aug 2020 12:35:01 +0100
> Sean Mooney <smooney@redhat.com> wrote:
> 
> > On Wed, 2020-08-05 at 12:53 +0200, Jiri Pirko wrote:  
> > > Wed, Aug 05, 2020 at 11:33:38AM CEST, yan.y.zhao@intel.com wrote:    
> 
> (...)
> 
> > > >    software_version: device driver's version.
> > > >               in <major>.<minor>[.bugfix] scheme, where there is no
> > > > 	       compatibility across major versions, minor versions have
> > > > 	       forward compatibility (ex. 1-> 2 is ok, 2 -> 1 is not) and
> > > > 	       bugfix version number indicates some degree of internal
> > > > 	       improvement that is not visible to the user in terms of
> > > > 	       features or compatibility,
> > > > 
> > > > vendor specific attributes: each vendor may define different attributes
> > > >   device id : device id of a physical devices or mdev's parent pci device.
> > > >               it could be equal to pci id for pci devices
> > > >   aggregator: used together with mdev_type. e.g. aggregator=2 together
> > > >               with i915-GVTg_V5_4 means 2*1/4=1/2 of a gen9 Intel
> > > > 	       graphics device.
> > > >   remote_url: for a local NVMe VF, it may be configured with a remote
> > > >               url of a remote storage and all data is stored in the
> > > > 	       remote side specified by the remote url.
> > > >   ...    
> > just a minor not that i find ^ much more simmple to understand then
> > the current proposal with self and compatiable.
> > if i have well defiend attibute that i can parse and understand that allow
> > me to calulate the what is and is not compatible that is likely going to
> > more useful as you wont have to keep maintianing a list of other compatible
> > devices every time a new sku is released.
> > 
> > in anycase thank for actully shareing ^ as it make it simpler to reson about what
> > you have previously proposed.  
> 
> So, what would be the most helpful format? A 'software_version' field
> that follows the conventions outlined above, and other (possibly
> optional) fields that have to match?

Just to get a different perspective, I've been trying to come up with
what would be useful for a very different kind of device, namely
vfio-ccw. (Adding Eric to cc: for that.)

software_version makes sense for everybody, so it should be a standard
attribute.

For the vfio-ccw type, we have only one vendor driver (vfio-ccw_IO).

Given a subchannel A, we want to make sure that subchannel B has a
reasonable chance of being compatible. I guess that means:

- same subchannel type (I/O)
- same chpid type (e.g. all FICON; I assume there are no 'mixed' setups
  -- Eric?)
- same number of chpids? Maybe we can live without that and just inject
  some machine checks, I don't know. Same chpid numbers is something we
  cannot guarantee, especially if we want to migrate cross-CEC (to
  another machine.)

Other possibly interesting information is not available at the
subchannel level (vfio-ccw is a subchannel driver.)

So, looking at a concrete subchannel on one of my machines, it would
look something like the following:

<common>
software_version=1.0.0
type=vfio-ccw          <-- would be vfio-pci on the example above
<vfio-ccw specific>
subchannel_type=0
<vfio-ccw_IO specific>
chpid_type=0x1a
chpid_mask=0xf0        <-- not sure if needed/wanted

Does that make sense?

