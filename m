Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBDC2492FB
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 04:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgHSCqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 22:46:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33647 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726605AbgHSCqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 22:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597805182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YHzwrXrXbLwizcmmmBRfV2cYeOLa+iyjDJxZ2l+hNLM=;
        b=V1QK719Ad0Tx6SjM3hFNcukadhH/ZCKgMmuwJX8BaBba+e1ORdIq6T6hyfyRA7MtquegNe
        11quf+6NDrF1n4DO/z/OuQuwXN+JOqmoXxYL5bxjJJHo5Sx+Xy+D37wFywnb1LaSBQZjuj
        SIhWEFEVEhdYmoOoc7wkYn8ZhtowSqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-6L_flAJUOaWxJy5I7WQLeA-1; Tue, 18 Aug 2020 22:46:20 -0400
X-MC-Unique: 6L_flAJUOaWxJy5I7WQLeA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8390F81F028;
        Wed, 19 Aug 2020 02:46:18 +0000 (UTC)
Received: from [10.72.13.88] (ovpn-13-88.pek2.redhat.com [10.72.13.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 759E15D9E4;
        Wed, 19 Aug 2020 02:45:59 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Parav Pandit <parav@nvidia.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "xin-ran.wang@intel.com" <xin-ran.wang@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "openstack-discuss@lists.openstack.org" 
        <openstack-discuss@lists.openstack.org>,
        "shaohe.feng@intel.com" <shaohe.feng@intel.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "jian-feng.ding@intel.com" <jian-feng.ding@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "hejie.xu@intel.com" <hejie.xu@intel.com>,
        "bao.yumeng@zte.com.cn" <bao.yumeng@zte.com.cn>,
        Alex Williamson <alex.williamson@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "smooney@redhat.com" <smooney@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
References: <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040> <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <BY5PR12MB43222059335C96F7B050CFDCDC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <934c8d2a-a34e-6c68-0e53-5de2a8f49d19@redhat.com>
Date:   Wed, 19 Aug 2020 10:45:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43222059335C96F7B050CFDCDC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/18 下午5:32, Parav Pandit wrote:
> Hi Jason,
>
> From: Jason Wang <jasowang@redhat.com>
> Sent: Tuesday, August 18, 2020 2:32 PM
>
>
> On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
> On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> On 2020/8/14 下午1:16, Yan Zhao wrote:
> On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> On 2020/8/10 下午3:46, Yan Zhao wrote:
> driver is it handled by?
> It looks that the devlink is for network device specific, and in
> devlink.h, it says
> include/uapi/linux/devlink.h - Network physical device Netlink
> interface,
> Actually not, I think there used to have some discussion last year and the
> conclusion is to remove this comment.
>
> [...]
>
>> Yes, but it could be hard. E.g vDPA will chose to use devlink (there's a long debate on sysfs vs devlink). So if we go with sysfs, at least two APIs needs to be supported ...
> We had internal discussion and proposal on this topic.
> I wanted Eli Cohen to be back from vacation on Wed 8/19, but since this is active discussion right now, I will share the thoughts anyway.
>
> Here are the initial round of thoughts and proposal.
>
> User requirements:
> ---------------------------
> 1. User might want to create one or more vdpa devices per PCI PF/VF/SF.
> 2. User might want to create one or more vdpa devices of type net/blk or other type.
> 3. User needs to look and dump at the health of the queues for debug purpose.
> 4. During vdpa net device creation time, user may have to provide a MAC address and/or VLAN.
> 5. User should be able to set/query some of the attributes for debug/compatibility check
> 6. When user wants to create vdpa device, it needs to know which device supports creation.
> 7. User should be able to see the queue statistics of doorbells, wqes etc regardless of class type


Note that wqes is probably not something common in all of the vendors.


>
> To address above requirements, there is a need of vendor agnostic tool, so that user can create/config/delete vdpa device(s) regardless of the vendor.
>
> Hence,
> We should have a tool that lets user do it.
>
> Examples:
> -------------
> (a) List parent devices which supports creating vdpa devices.
> It also shows which class types supported by this parent device.
> In below command two parent devices support vdpa device creation.
> First is PCI VF whose bdf is 03.00:5.
> Second is PCI SF whose name is mlx5_sf.1
>
> $ vdpa list pd


What did "pd" mean?


> pci/0000:03.00:5
>    class_supports
>      net vdpa
> virtbus/mlx5_sf.1


So creating mlx5_sf.1 is the charge of devlink?


>    class_supports
>      net
>
> (b) Now add a vdpa device and show the device.
> $ vdpa dev add pci/0000:03.00:5 type net


So if you want to create devices types other than vdpa on 
pci/0000:03.00:5 it needs some synchronization with devlink?


> $ vdpa dev show
> vdpa0@pci/0000:03.00:5 type net state inactive maxqueues 8 curqueues 4
>
> (c) vdpa dev show features vdpa0
> iommu platform
> version 1
>
> (d) dump vdpa statistics
> $ vdpa dev stats show vdpa0
> kickdoorbells 10
> wqes 100
>
> (e) Now delete a vdpa device previously created.
> $ vdpa dev del vdpa0
>
> Design overview:
> -----------------------
> 1. Above example tool runs over netlink socket interface.
> 2. This enables users to return meaningful error strings in addition to code so that user can be more informed.
> Often this is missing in ioctl()/configfs/sysfs interfaces.
> 3. This tool over netlink enables syscaller tests to be more usable like other subsystems to keep kernel robust
> 4. This provides vendor agnostic view of all vdpa capable parent and vdpa devices.
>
> 5. Each driver which supports vdpa device creation, registers the parent device along with supported classes.
>
> FAQs:
> --------
> 1. Why not using devlink?
> Ans: Because as vdpa echo system grows, devlink will fall short of extending vdpa specific params, attributes, stats.


This should be fine but it's still not clear to me the difference 
between a vdpa netlink and a vdpa object in devlink.

Thanks


>
> 2. Why not use sysfs?
> Ans:
> (a) Because running syscaller infrastructure can run well over netlink sockets like it runs for several subsystem.
> (b) it lacks the ability to return error messages. Doing via kernel log is just doesn't work.
> (c) Why not using some ioctl()? It will reinvent the wheel of netlink that has TLV formats for several attributes.
>
> 3. Why not configs?
> It follows same limitation as that of sysfs.
>
> Low level design and driver APIS:
> --------------------------------------------
> Will post once we discuss this further.

