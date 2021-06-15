Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0EC3A861D
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 18:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhFOQO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 12:14:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230120AbhFOQOZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 12:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623773540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1h4oaOaNjcSHr4pWVXRGjORB7JTz/dPNT4qeEP5NqE=;
        b=IJ248b/DuuANqKw+4VlRegMZGgI61vI+uNQKwbx3A7F+VjeqjDKVK3TJa+CjEhOSEH39jd
        aJ6mVKmdkqQBX1XkAkFhSN5oEAnaMNc6gWwQ0UawkrV3p1+RFVOdoRdM0AceAbKmqnNvkC
        6u9D+mdFHdu91gmEPM9qEUIRvo2qgDk=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-xUiI4O9RPYKZng1m0lXV8w-1; Tue, 15 Jun 2021 12:12:19 -0400
X-MC-Unique: xUiI4O9RPYKZng1m0lXV8w-1
Received: by mail-ot1-f70.google.com with SMTP id m20-20020a0568301e74b02903e419b82f75so9684405otr.23
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=t1h4oaOaNjcSHr4pWVXRGjORB7JTz/dPNT4qeEP5NqE=;
        b=d0BO89crQF2RBAIfoS7HYCXwUBufhBL8VTMKbWPJhlZzVnHc1MffYy9j4kA1Tg92HV
         r4b4eW8EDffJdz/XrpFCsFXsxRzc3jv0erkg41aDy1sdjsJrRwRv+P1vOZiy9CQp3KQ1
         d6ckduUxHEPTFrcY7qjGVPsiOlhF76fev/MLG1ykI3FpZqu8CSKYeVb6FrkgB5+VjoyW
         N2OibSmDO8Unki5aj6NnKzPfekfdOIKtDwWXANALJ71NMwXvwslTXxe6fVRCmBqgkzDE
         SNM5hbqyZOhjRlst4naF0DJIVbabC6ZN/5F6JlnDgs0N0Xw+VhlGpH86TxVRWm0y7+eY
         3jhQ==
X-Gm-Message-State: AOAM533IdqRLH45oC009Yqzg5LGoS0I00HrDj3cKgMUJcEjeV0zet8Wt
        6cyvHB7PLR/i/S65njluhNSZfYidBKrndR61K7KLrWNvKcnAWrEzqGtlFrRyAPqu3xbdW77m1jw
        r4kgn12OY9cvL
X-Received: by 2002:a05:6808:1285:: with SMTP id a5mr3881784oiw.135.1623773538190;
        Tue, 15 Jun 2021 09:12:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywdycWyypsQ+NgzKG3B8q8Z4V3YXX5WMl7m7rmxWMexxqdhxjANJ6c7RhDJcxfIwMnlsSa5Q==
X-Received: by 2002:a05:6808:1285:: with SMTP id a5mr3881757oiw.135.1623773538003;
        Tue, 15 Jun 2021 09:12:18 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p1sm3953745oou.14.2021.06.15.09.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 09:12:17 -0700 (PDT)
Date:   Tue, 15 Jun 2021 10:12:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210615101215.4ba67c86.alex.williamson@redhat.com>
In-Reply-To: <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <20210611164529.GR1002214@nvidia.com>
        <20210611133828.6c6e8b29.alex.williamson@redhat.com>
        <20210612012846.GC1002214@nvidia.com>
        <20210612105711.7ac68c83.alex.williamson@redhat.com>
        <20210614140711.GI1002214@nvidia.com>
        <20210614102814.43ada8df.alex.williamson@redhat.com>
        <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Jun 2021 02:31:39 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 15, 2021 12:28 AM
> >   
> [...]
> > > IOASID. Today the group fd requires an IOASID before it hands out a
> > > device_fd. With iommu_fd the device_fd will not allow IOCTLs until it
> > > has a blocked DMA IOASID and is successefully joined to an iommu_fd.  
> > 
> > Which is the root of my concern.  Who owns ioctls to the device fd?
> > It's my understanding this is a vfio provided file descriptor and it's
> > therefore vfio's responsibility.  A device-level IOASID interface
> > therefore requires that vfio manage the group aspect of device access.
> > AFAICT, that means that device access can therefore only begin when all
> > devices for a given group are attached to the IOASID and must halt for
> > all devices in the group if any device is ever detached from an IOASID,
> > even temporarily.  That suggests a lot more oversight of the IOASIDs by
> > vfio than I'd prefer.
> >   
> 
> This is possibly the point that is worthy of more clarification and
> alignment, as it sounds like the root of controversy here.
> 
> I feel the goal of vfio group management is more about ownership, i.e. 
> all devices within a group must be assigned to a single user. Following
> the three rules defined by Jason, what we really care is whether a group
> of devices can be isolated from the rest of the world, i.e. no access to
> memory/device outside of its security context and no access to its 
> security context from devices outside of this group. This can be achieved
> as long as every device in the group is either in block-DMA state when 
> it's not attached to any security context or attached to an IOASID context 
> in IOMMU fd.
> 
> As long as group-level isolation is satisfied, how devices within a group 
> are further managed is decided by the user (unattached, all attached to 
> same IOASID, attached to different IOASIDs) as long as the user 
> understands the implication of lacking of isolation within the group. This 
> is what a device-centric model comes to play. Misconfiguration just hurts 
> the user itself.
> 
> If this rationale can be agreed, then I didn't see the point of having VFIO
> to mandate all devices in the group must be attached/detached in
> lockstep. 

In theory this sounds great, but there are still too many assumptions
and too much hand waving about where isolation occurs for me to feel
like I really have the complete picture.  So let's walk through some
examples.  Please fill in and correct where I'm wrong.

1) A dual-function PCIe e1000e NIC where the functions are grouped
   together due to ACS isolation issues.

   a) Initial state: functions 0 & 1 are both bound to e1000e driver.

   b) Admin uses driverctl to bind function 1 to vfio-pci, creating
      vfio device file, which is chmod'd to grant to a user.

   c) User opens vfio function 1 device file and an iommu_fd, binds
   device_fd to iommu_fd.

   Does this succeed?
     - if no, specifically where does it fail?
     - if yes, vfio can now allow access to the device?

   d) Repeat b) for function 0.

   e) Repeat c), still using function 1, is it different?  Where?  Why?

2) The same NIC as 1)

   a) Initial state: functions 0 & 1 bound to vfio-pci, vfio device
      files granted to user, user has bound both device_fds to the same
      iommu_fd.

   AIUI, even though not bound to an IOASID, vfio can now enable access
   through the device_fds, right?  What specific entity has placed these
   devices into a block DMA state, when, and how?

   b) Both devices are attached to the same IOASID.

   Are we assuming that each device was atomically moved to the new
   IOMMU context by the IOASID code?  What if the IOMMU cannot change
   the domain atomically?

   c) The device_fd for function 1 is detached from the IOASID.

   Are we assuming the reverse of b) performed by the IOASID code?

   d) The device_fd for function 1 is unbound from the iommu_fd.

   Does this succeed?
     - if yes, what is the resulting IOMMU context of the device and
       who owns it?
     - if no, well, that results in numerous tear-down issues.

   e) Function 1 is unbound from vfio-pci.

   Does this work or is it blocked?  If blocked, by what entity
   specifically?

   f) Function 1 is bound to e1000e driver.

   We clearly have a violation here, specifically where and by who in
   this path should have prevented us from getting here or who pushes
   the BUG_ON to abort this?

3) A dual-function conventional PCI e1000 NIC where the functions are
   grouped together due to shared RID.

   a) Repeat 2.a) and 2.b) such that we have a valid, user accessible
      devices in the same IOMMU context.

   b) Function 1 is detached from the IOASID.

   I think function 1 cannot be placed into a different IOMMU context
   here, does the detach work?  What's the IOMMU context now?

   c) A new IOASID is alloc'd within the existing iommu_fd and function
      1 is attached to the new IOASID.

   Where, how, by whom does this fail?

If vfio gets to offload all of it's group management to IOASID code,
that's great, but I'm afraid that IOASID is so focused on a
device-level API that we're instead just ignoring the group dynamics
and vfio will be forced to provide oversight to maintain secure
userspace access.  Thanks,

Alex

