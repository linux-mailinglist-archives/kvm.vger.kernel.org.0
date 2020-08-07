Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF80C23ED07
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 14:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHGMAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 08:00:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24296 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726293AbgHGMAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 08:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596801603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IVwqKyqW50wYrrH5JlBPTOAfT6+kzPwRmFuVW8KPOc8=;
        b=ZJe7+cUr2hHbv116RmvWIS2dQtyLoNjHfmbvEEQ3cCX52i1N6CvNHs5aE13ez3QBT7bUgR
        8Z9k4NUnZHHewGo2yOzGksdysAXTwEOqP8SHHO0fprnWNRsKwZwzu9SP9myZmaRdLcMR/C
        IAA0QTKfwRcDLqNZjgs9Fc5427IBt/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-KrXRZ7ZLMsSPqWzO7L0ebg-1; Fri, 07 Aug 2020 08:00:01 -0400
X-MC-Unique: KrXRZ7ZLMsSPqWzO7L0ebg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92E8F100960F;
        Fri,  7 Aug 2020 11:59:59 +0000 (UTC)
Received: from gondolin (ovpn-112-214.ams2.redhat.com [10.36.112.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E0A865C94;
        Fri,  7 Aug 2020 11:59:45 +0000 (UTC)
Date:   Fri, 7 Aug 2020 13:59:42 +0200
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
        Parav Pandit <parav@mellanox.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200807135942.5d56a202.cohuck@redhat.com>
In-Reply-To: <4cf2824c803c96496e846c5b06767db305e9fb5a.camel@redhat.com>
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
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 05 Aug 2020 12:35:01 +0100
Sean Mooney <smooney@redhat.com> wrote:

> On Wed, 2020-08-05 at 12:53 +0200, Jiri Pirko wrote:
> > Wed, Aug 05, 2020 at 11:33:38AM CEST, yan.y.zhao@intel.com wrote:  

(...)

> > >    software_version: device driver's version.
> > >               in <major>.<minor>[.bugfix] scheme, where there is no
> > > 	       compatibility across major versions, minor versions have
> > > 	       forward compatibility (ex. 1-> 2 is ok, 2 -> 1 is not) and
> > > 	       bugfix version number indicates some degree of internal
> > > 	       improvement that is not visible to the user in terms of
> > > 	       features or compatibility,
> > > 
> > > vendor specific attributes: each vendor may define different attributes
> > >   device id : device id of a physical devices or mdev's parent pci device.
> > >               it could be equal to pci id for pci devices
> > >   aggregator: used together with mdev_type. e.g. aggregator=2 together
> > >               with i915-GVTg_V5_4 means 2*1/4=1/2 of a gen9 Intel
> > > 	       graphics device.
> > >   remote_url: for a local NVMe VF, it may be configured with a remote
> > >               url of a remote storage and all data is stored in the
> > > 	       remote side specified by the remote url.
> > >   ...  
> just a minor not that i find ^ much more simmple to understand then
> the current proposal with self and compatiable.
> if i have well defiend attibute that i can parse and understand that allow
> me to calulate the what is and is not compatible that is likely going to
> more useful as you wont have to keep maintianing a list of other compatible
> devices every time a new sku is released.
> 
> in anycase thank for actully shareing ^ as it make it simpler to reson about what
> you have previously proposed.

So, what would be the most helpful format? A 'software_version' field
that follows the conventions outlined above, and other (possibly
optional) fields that have to match?

(...)

> > Thanks for the explanation, I'm still fuzzy about the details.
> > Anyway, I suggest you to check "devlink dev info" command we have
> > implemented for multiple drivers.  
> 
> is devlink exposed as a filesytem we can read with just open?
> openstack will likely try to leverage libvirt to get this info but when we
> cant its much simpler to read sysfs then it is to take a a depenency on a commandline
> too and have to fork shell to execute it and parse the cli output.
> pyroute2 which we use in some openstack poject has basic python binding for devlink but im not
> sure how complete it is as i think its relitivly new addtion. if we need to take a dependcy
> we will but that would be a drawback fo devlink not that that is a large one just something
> to keep in mind.

A devlinkfs, maybe? At least for reading information (IIUC, "devlink
dev info" is only about information retrieval, right?)

