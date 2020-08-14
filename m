Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370032449C1
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgHNMaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 08:30:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51845 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728080AbgHNMaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 08:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597408210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1es+FhXf2z4s1o6I95UCtDQxtUvu4w172t+j0+i0n8o=;
        b=cANsGgRImAlfXI4T3iieulp+71Li+jbblthuG1s9UQyYhG/HJjo9xu1LVIJRovpqpJuJ3R
        gGsBFEFam7ltoiKrUydie6mOdLnAhwNHQf6Vb91LrV8TGXhtepQh5RHey3iXdbJBmWFw/e
        9APLBFPohyEjvXU+E+WfDhsujaMy8sQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545---y2vRhoMbq2ir_F210oSA-1; Fri, 14 Aug 2020 08:30:05 -0400
X-MC-Unique: --y2vRhoMbq2ir_F210oSA-1
Received: by mail-wr1-f72.google.com with SMTP id 89so3313041wrr.15
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 05:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1es+FhXf2z4s1o6I95UCtDQxtUvu4w172t+j0+i0n8o=;
        b=MPfARpiH34Iiwp13r6rZMop/smQbIQoE96+dEWs3jWSsPEat+s1Qa9AkODcsZsIiGh
         66HdQCYrZp1tyxx8g0Bb3oppq+rHZVHrCClof4lq7hnAhDZyoSZwq+r21Jjs3+qA0hcQ
         noe4gJO2QctWkjA2RNqlWj+ZxXlTq1HAyMTMSbBjiqhE7AxFKD61OTXAuFJOECGyGmxD
         fBg8Y9P0yP9wEZKczW8KFnD2lKUcVtl9g3VA72s9DRAvRuehGWHj2jVn0kp2pN9nhKAl
         Y63f0ALPC7/kbymZFcO+aPMKz9ETT1jU14h1um2myhiOS3aLaG0dRb4xCZw5QyPMoAeP
         +Tig==
X-Gm-Message-State: AOAM533C9GwLua2MuGI/SPq+UZ4ueNfJS4TSrtZmjDnrkTH8TAW4X9Uc
        jgNMnnTq2EAuxsjQWedNzur4ae9YS8EeeY/zSjC5Zrk/859fsdLkwDqYEYd0v3iuRe5g25GD3ta
        4hi6NPYTyoGRW
X-Received: by 2002:a1c:9909:: with SMTP id b9mr2354768wme.98.1597408204294;
        Fri, 14 Aug 2020 05:30:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgh08eJQ+zuIOVbZA25ftPbBneCLgohlliBAPXoRqIxCkWEgig17fG/vnPhy7CGR0+dWUICw==
X-Received: by 2002:a1c:9909:: with SMTP id b9mr2354734wme.98.1597408203987;
        Fri, 14 Aug 2020 05:30:03 -0700 (PDT)
Received: from pop-os ([2001:470:1f1d:1ea:4fde:6f63:1f5a:12b1])
        by smtp.gmail.com with ESMTPSA id v8sm14694061wmb.24.2020.08.14.05.30.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Aug 2020 05:30:03 -0700 (PDT)
Message-ID: <a4f4a3cf76b87346a4cc4c39c116f575eaab9bac.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>, Jason Wang <jasowang@redhat.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        eskultet@redhat.com, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        corbet@lwn.net, dinechin@redhat.com, devel@ovirt.org
Date:   Fri, 14 Aug 2020 13:30:00 +0100
In-Reply-To: <20200814051601.GD15344@joy-OptiPlex-7040>
References: <20200804183503.39f56516.cohuck@redhat.com>
         <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
         <20200805021654.GB30485@joy-OptiPlex-7040>
         <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
         <20200805075647.GB2177@nanopsycho>
         <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
         <20200805093338.GC30485@joy-OptiPlex-7040>
         <20200805105319.GF2177@nanopsycho>
         <20200810074631.GA29059@joy-OptiPlex-7040>
         <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
         <20200814051601.GD15344@joy-OptiPlex-7040>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-08-14 at 13:16 +0800, Yan Zhao wrote:
> On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > 
> > On 2020/8/10 下午3:46, Yan Zhao wrote:
> > > > driver is it handled by?
> > > 
> > > It looks that the devlink is for network device specific, and in
> > > devlink.h, it says
> > > include/uapi/linux/devlink.h - Network physical device Netlink
> > > interface,
> > 
> > 
> > Actually not, I think there used to have some discussion last year and the
> > conclusion is to remove this comment.
> > 
> > It supports IB and probably vDPA in the future.
> > 
> 
> hmm... sorry, I didn't find the referred discussion. only below discussion
> regarding to why to add devlink.
> 
> https://www.mail-archive.com/netdev@vger.kernel.org/msg95801.html
> 	>This doesn't seem to be too much related to networking? Why can't something
> 	>like this be in sysfs?
> 	
> 	It is related to networking quite bit. There has been couple of
> 	iteration of this, including sysfs and configfs implementations. There
> 	has been a consensus reached that this should be done by netlink. I
> 	believe netlink is really the best for this purpose. Sysfs is not a good
> 	idea
> 
> https://www.mail-archive.com/netdev@vger.kernel.org/msg96102.html
> 	>there is already a way to change eth/ib via
> 	>echo 'eth' > /sys/bus/pci/drivers/mlx4_core/0000:02:00.0/mlx4_port1
> 	>
> 	>sounds like this is another way to achieve the same?
> 	
> 	It is. However the current way is driver-specific, not correct.
> 	For mlx5, we need the same, it cannot be done in this way. Do devlink is
> 	the correct way to go.
im not sure i agree with that.
standardising a filesystem based api that is used across all vendors is also a valid
option.  that said if devlink is the right choice form a kerenl perspective by all
means use it but i have not heard a convincing argument for why it actually better.
with tthat said we have been uing tools like ethtool to manage aspect of nics for decades
so its not that strange an idea to use a tool and binary protocoal rather then a text
based interface for this but there are advantages to both approches.
> 
> https://lwn.net/Articles/674867/
> 	There a is need for some userspace API that would allow to expose things
> 	that are not directly related to any device class like net_device of
> 	ib_device, but rather chip-wide/switch-ASIC-wide stuff.
> 
> 	Use cases:
> 	1) get/set of port type (Ethernet/InfiniBand)
> 	2) monitoring of hardware messages to and from chip
> 	3) setting up port splitters - split port into multiple ones and squash again,
> 	   enables usage of splitter cable
> 	4) setting up shared buffers - shared among multiple ports within one chip
> 
> 
> 
> we actually can also retrieve the same information through sysfs, .e.g
> 
> > - [path to device]
> 
>   |--- migration
>   |     |--- self
>   |     |   |---device_api
>   |	|   |---mdev_type
>   |	|   |---software_version
>   |	|   |---device_id
>   |	|   |---aggregator
>   |     |--- compatible
>   |     |   |---device_api
>   |	|   |---mdev_type
>   |	|   |---software_version
>   |	|   |---device_id
>   |	|   |---aggregator
> 
> 
> 
> > 
> > >   I feel like it's not very appropriate for a GPU driver to use
> > > this interface. Is that right?
> > 
> > 
> > I think not though most of the users are switch or ethernet devices. It
> > doesn't prevent you from inventing new abstractions.
> 
> so need to patch devlink core and the userspace devlink tool?
> e.g. devlink migration
and devlink python libs if openstack was to use it directly.
we do have caes where we just frok a process and execaute a comannd in a shell
with or without elevated privladge but we really dont like doing that due to 
the performacne impacat and security implciations so where we can use python bindign
over c apis we do. pyroute2 is the only python lib i know off of the top of my head
that support devlink so we would need to enhacne it to support this new devlink api.
there may be otherss i have not really looked in the past since we dont need to use
devlink at all today.
> 
> > Note that devlink is based on netlink, netlink has been widely used by
> > various subsystems other than networking.
> 
> the advantage of netlink I see is that it can monitor device status and
> notify upper layer that migration database needs to get updated.
> But not sure whether openstack would like to use this capability.
> As Sean said, it's heavy for openstack. it's heavy for vendor driver
> as well :)
> 
> And devlink monitor now listens the notification and dumps the state
> changes. If we want to use it, need to let it forward the notification
> and dumped info to openstack, right?
i dont think we would use direct devlink monitoring in nova even if it was avaiable.
we could but we already poll libvirt and the system for other resouce periodicly.
we likely wouldl just add monitoriv via devlink to that periodic task.
we certenly would not use it to detect a migration or a need to update a migration database(not sure what that is)

in reality if we can consume this info indirectly via a libvirt api that will
be the appcoh we will take at least for the libvirt driver in nova. for cyborg
they may take a different appoch. we already use pyroute2 in 2 projects, os-vif and
neutron and it does have devlink support so the burden of using devlink is not that
high for openstack but its a less frineadly interface for configuration tools like
ansiable vs a filesystem based approch.
> 
> Thanks
> Yan
> 

