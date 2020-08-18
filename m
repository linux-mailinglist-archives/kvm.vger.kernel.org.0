Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF7D2481D7
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 11:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgHRJZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 05:25:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42942 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgHRJZh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 05:25:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597742735;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eeB+hN1zCN47COQrIpjM7VIX4w9eY1mJ1G21fPz14lw=;
        b=fFIS52NsO+w7i22jSGk6gNpRufkazoCQkLr8VILA1XWVFsNUB8lLwoZqIxACYgJhpFAudV
        Kcnhz8XkgexY9XLo4ZqIGb330OxqNKidX4Ez4zaLuxXkZ4yhq9iZFy4NdIeDuCP7IhOh9f
        PBX3PR2a0UgO709O3SLGJmMPXe+G8Oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-jjuG8ppIN9-XvLxq3nqeZA-1; Tue, 18 Aug 2020 05:24:54 -0400
X-MC-Unique: jjuG8ppIN9-XvLxq3nqeZA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C76231014DEE;
        Tue, 18 Aug 2020 09:24:51 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B5F82617B;
        Tue, 18 Aug 2020 09:24:35 +0000 (UTC)
Date:   Tue, 18 Aug 2020 10:24:33 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        eskultet@redhat.com, smooney@redhat.com,
        intel-gvt-dev@lists.freedesktop.org,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200818092433.GD20215@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040>
 <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <20200818110617.05def37c.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200818110617.05def37c.cohuck@redhat.com>
User-Agent: Mutt/1.14.5 (2020-06-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 11:06:17AM +0200, Cornelia Huck wrote:
> On Tue, 18 Aug 2020 09:55:27 +0100
> Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> > On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > > Another point, as we discussed in another thread, it's really hard to make
> > > sure the above API work for all types of devices and frameworks. So having a
> > > vendor specific API looks much better.  
> > 
> > From the POV of userspace mgmt apps doing device compat checking / migration,
> > we certainly do NOT want to use different vendor specific APIs. We want to
> > have an API that can be used / controlled in a standard manner across vendors.
> 
> As we certainly will need to have different things to check for
> different device types and vendor drivers, would it still be fine to
> have differing (say) attributes, as long as they are presented (and can
> be discovered) in a standardized way?

Yes, the control API and algorithm to deal with the problem needs to
have standardization, but the data passed in/out of the APIs can vary.

Essentially the key is that vendors should be able to create devices
at the kernel, and those devices should "just work" with the existing
generic userspace migration / compat checking code, without needing
extra vendor specific logic to be added.

Note, I'm not saying that the userspace decisions would be perfectly
optimal based on generic code. They might be making a simplified
decision that while functionally safe, is not the ideal solution.
Adding vendor specific code might be able to optimize the userspace
decisions, but that should be considered just optimization, not a
core must have for any opertion.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

