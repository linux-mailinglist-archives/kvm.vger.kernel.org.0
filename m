Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB8C23C96A
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgHEJor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:44:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56239 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726041AbgHEJop (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Aug 2020 05:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596620683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zb5KxUrGvImBssm2BT3ZVy2Vf0v+WxPnapjazE+JgIo=;
        b=gqQ6Zr5OKLOlUPhGF7kN8LNHo3AesXBx3HGxw7Fff6CkmbI859vqz/eHe+wtjaQp42EJpP
        5VonZ4eH0TL6w1r2PKkI0rHPSsGfyuKa7zpAK40dHQD+MuP9X0KxxmF9TdAuw1sW1OI7C+
        0246ZMZAqp24ZgcJ/mR3q+SSQdgdsng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-nZZ3dcD_N1SEgD8P21T3kw-1; Wed, 05 Aug 2020 05:44:41 -0400
X-MC-Unique: nZZ3dcD_N1SEgD8P21T3kw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48726101C8A0;
        Wed,  5 Aug 2020 09:44:39 +0000 (UTC)
Received: from work-vm (ovpn-114-87.ams2.redhat.com [10.36.114.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BDBE760BF3;
        Wed,  5 Aug 2020 09:44:25 +0000 (UTC)
Date:   Wed, 5 Aug 2020 10:44:23 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Mooney <smooney@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Jason Wang <jasowang@redhat.com>,
        qemu-devel@nongnu.org, kwankhede@nvidia.com, eauger@redhat.com,
        xin-ran.wang@intel.com, corbet@lwn.net,
        openstack-discuss@lists.openstack.org, shaohe.feng@intel.com,
        kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, zhenyuw@linux.intel.com,
        hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200805094423.GB3004@work-vm>
References: <20200717101258.65555978@x1.home>
 <20200721005113.GA10502@joy-OptiPlex-7040>
 <20200727072440.GA28676@joy-OptiPlex-7040>
 <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <e8a973ea0bb2bc3eb15649fb1c44599ae3509e84.camel@redhat.com>
 <20200729131255.68730f68@x1.home>
 <20200730034104.GB32327@joy-OptiPlex-7040>
 <20200730112930.6f4c5762@x1.home>
 <20200804083708.GA30485@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804083708.GA30485@joy-OptiPlex-7040>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Yan Zhao (yan.y.zhao@intel.com) wrote:
> > > yes, include a device_api field is better.
> > > for mdev, "device_type=vfio-mdev", is it right?
> > 
> > No, vfio-mdev is not a device API, it's the driver that attaches to the
> > mdev bus device to expose it through vfio.  The device_api exposes the
> > actual interface of the vfio device, it's also vfio-pci for typical
> > mdev devices found on x86, but may be vfio-ccw, vfio-ap, etc...  See
> > VFIO_DEVICE_API_PCI_STRING and friends.
> > 
> ok. got it.
> 
> > > > > > 	device_id=8086591d  
> > > > 
> > > > Is device_id interpreted relative to device_type?  How does this
> > > > relate to mdev_type?  If we have an mdev_type, doesn't that fully
> > > > defined the software API?
> > > >   
> > > it's parent pci id for mdev actually.
> >
> > If we need to specify the parent PCI ID then something is fundamentally
> > wrong with the mdev_type.  The mdev_type should define a unique,
> > software compatible interface, regardless of the parent device IDs.  If
> > a i915-GVTg_V5_2 means different things based on the parent device IDs,
> > then then different mdev_types should be reported for those parent
> > devices.
> >
> hmm, then do we allow vendor specific fields?
> or is it a must that a vendor specific field should have corresponding
> vendor attribute?
> 
> another thing is that the definition of mdev_type in GVT only corresponds
> to vGPU computing ability currently,
> e.g. i915-GVTg_V5_2, is 1/2 of a gen9 IGD, i915-GVTg_V4_2 is 1/2 of a
> gen8 IGD.
> It is too coarse-grained to live migration compatibility.

Can you explain why that's too coarse?

Is this because it's too specific (i.e. that a i915-GVTg_V4_2 could be
migrated to a newer device?), or that it's too specific on the exact
sizings (i.e. that there may be multiple different sizes of a gen9)?

Dave

> Do you think we need to update GVT's definition of mdev_type?
> And is there any guide in mdev_type definition?
> 
> > > > > > 	mdev_type=i915-GVTg_V5_2  
> > > > 
> > > > And how are non-mdev devices represented?
> > > >   
> > > non-mdev can opt to not include this field, or as you said below, a
> > > vendor signature. 
> > > 
> > > > > > 	aggregator=1
> > > > > > 	pv_mode="none+ppgtt+context"  
> > > > 
> > > > These are meaningless vendor specific matches afaict.
> > > >   
> > > yes, pv_mode and aggregator are vendor specific fields.
> > > but they are important to decide whether two devices are compatible.
> > > pv_mode means whether a vGPU supports guest paravirtualized api.
> > > "none+ppgtt+context" means guest can not use pv, or use ppgtt mode pv or
> > > use context mode pv.
> > > 
> > > > > > 	interface_version=3  
> > > > 
> > > > Not much granularity here, I prefer Sean's previous
> > > > <major>.<minor>[.bugfix] scheme.
> > > >   
> > > yes, <major>.<minor>[.bugfix] scheme may be better, but I'm not sure if
> > > it works for a complicated scenario.
> > > e.g for pv_mode,
> > > (1) initially,  pv_mode is not supported, so it's pv_mode=none, it's 0.0.0,
> > > (2) then, pv_mode=ppgtt is supported, pv_mode="none+ppgtt", it's 0.1.0,
> > > indicating pv_mode=none can migrate to pv_mode="none+ppgtt", but not vice versa.
> > > (3) later, pv_mode=context is also supported,
> > > pv_mode="none+ppgtt+context", so it's 0.2.0.
> > > 
> > > But if later, pv_mode=ppgtt is removed. pv_mode="none+context", how to
> > > name its version? "none+ppgtt" (0.1.0) is not compatible to
> > > "none+context", but "none+ppgtt+context" (0.2.0) is compatible to
> > > "none+context".
> > 
> > If pv_mode=ppgtt is removed, then the compatible versions would be
> > 0.0.0 or 1.0.0, ie. the major version would be incremented due to
> > feature removal.
> >  
> > > Maintain such scheme is painful to vendor driver.
> > 
> > Migration compatibility is painful, there's no way around that.  I
> > think the version scheme is an attempt to push some of that low level
> > burden on the vendor driver, otherwise the management tools need to
> > work on an ever growing matrix of vendor specific features which is
> > going to become unwieldy and is largely meaningless outside of the
> > vendor driver.  Instead, the vendor driver can make strategic decisions
> > about where to continue to maintain a support burden and make explicit
> > decisions to maintain or break compatibility.  The version scheme is a
> > simplification and abstraction of vendor driver features in order to
> > create a small, logical compatibility matrix.  Compromises necessarily
> > need to be made for that to occur.
> >
> ok. got it.
> 
> > > > > > COMPATIBLE:
> > > > > > 	device_type=pci
> > > > > > 	device_id=8086591d
> > > > > > 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}    
> > > > > this mixed notation will be hard to parse so i would avoid that.  
> > > > 
> > > > Some background, Intel has been proposing aggregation as a solution to
> > > > how we scale mdev devices when hardware exposes large numbers of
> > > > assignable objects that can be composed in essentially arbitrary ways.
> > > > So for instance, if we have a workqueue (wq), we might have an mdev
> > > > type for 1wq, 2wq, 3wq,... Nwq.  It's not really practical to expose a
> > > > discrete mdev type for each of those, so they want to define a base
> > > > type which is composable to other types via this aggregation.  This is
> > > > what this substitution and tagging is attempting to accomplish.  So
> > > > imagine this set of values for cases where it's not practical to unroll
> > > > the values for N discrete types.
> > > >   
> > > > > > 	aggregator={val1}/2  
> > > > 
> > > > So the {val1} above would be substituted here, though an aggregation
> > > > factor of 1/2 is a head scratcher...
> > > >   
> > > > > > 	pv_mode={val2:string:"none+ppgtt","none+context","none+ppgtt+context"}  
> > > > 
> > > > I'm lost on this one though.  I think maybe it's indicating that it's
> > > > compatible with any of these, so do we need to list it?  Couldn't this
> > > > be handled by Sean's version proposal where the minor version
> > > > represents feature compatibility?  
> > > yes, it's indicating that it's compatible with any of these.
> > > Sean's version proposal may also work, but it would be painful for
> > > vendor driver to maintain the versions when multiple similar features
> > > are involved.
> > 
> > This is something vendor drivers need to consider when adding and
> > removing features.
> > 
> > > > > > 	interface_version={val3:int:2,3}  
> > > > 
> > > > What does this turn into in a few years, 2,7,12,23,75,96,...
> > > >   
> > > is a range better?
> > 
> > I was really trying to point out that sparseness becomes an issue if
> > the vendor driver is largely disconnected from how their feature
> > addition and deprecation affects migration support.  Thanks,
> >
> ok. we'll use the x.y.z scheme then.
> 
> Thanks
> Yan
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

