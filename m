Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEF5225CC2
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 12:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgGTKjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 06:39:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60559 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728001AbgGTKjV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 06:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595241559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sklRsRTSQU9Hiyxm0q5Mr8YUheq3vmnY8+P0vWizCkA=;
        b=PJxtnPzP+EJeqYgbG1bjbrUCEhMGz7aO7YdOzclfSJxXm6QAahEuYpuffcyH0KnTuPZ5CK
        zvmsbF/CLSBxo+mh+irdk6EhegTO9qvMP/0g3zr62GAoCDYekK59N2nnbSpYrgO1BQfJAz
        38YPu6Kk+P76Gl6Uh3Izdb858kw3s0A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-Sq8W_RviOxeA6CKD_UTI0A-1; Mon, 20 Jul 2020 06:39:17 -0400
X-MC-Unique: Sq8W_RviOxeA6CKD_UTI0A-1
Received: by mail-wm1-f70.google.com with SMTP id g6so14124156wmk.4
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 03:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sklRsRTSQU9Hiyxm0q5Mr8YUheq3vmnY8+P0vWizCkA=;
        b=emxCyHksl7NVbQr9FN5i9VgUWGeDoYPBKuEftUn7KmAFY7X2ajs6uL7O9k7AMuaqh9
         XFVBcbOR5ddEZjm47td2navTeRZf+8HjJsTKLgX9CyU6vu32eYeqNRxLCd9zd50LQZAJ
         MPUFtSuJ9Uyesf7bewXvKbtHiNlX3SNZmMPUbRG0IHuBL16uURfJ53EErTDn0Q9Gq4fo
         1WNU5yQdHD9lDEVs0EBmv5AY1AlWLFG6TxoPHoHJxPFmQyYKZMt1tNyY/UHy9eA1P3re
         oQCgFS1bUmpKNJnAwLipfnUBbDiZu90AxHOd5jqnFlAECAkVstv11sUPNUreAT9ezp8N
         npmQ==
X-Gm-Message-State: AOAM533XTE798Cx9BB6E2RgVawW1/kY7YsjnZrRzVbSp6LfREahPNXQ9
        7h0OT97J8UHIcnifyvq/Zk7K6rqVF1AG1FiD64JGQxrUoD/yA2AizRysUZnjJwwMkg2U2rE1CIz
        2ULso3rKhlLlw
X-Received: by 2002:adf:a11d:: with SMTP id o29mr3508129wro.421.1595241556144;
        Mon, 20 Jul 2020 03:39:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwl8UsImJLC98sdzsBmUeXUpIS1hPMSxtTVUgonzL8XKvJioH4iWMe8CewSGE+efnYGdkopJQ==
X-Received: by 2002:adf:a11d:: with SMTP id o29mr3508112wro.421.1595241555829;
        Mon, 20 Jul 2020 03:39:15 -0700 (PDT)
Received: from pop-os ([51.37.88.107])
        by smtp.gmail.com with ESMTPSA id t13sm8425187wru.65.2020.07.20.03.39.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Jul 2020 03:39:15 -0700 (PDT)
Message-ID: <60d5c1609aaef72f2877aaacff04dc7187e4b3a5.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Cc:     devel@ovirt.org, openstack-discuss@lists.openstack.org,
        libvir-list@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, berrange@redhat.com,
        eskultet@redhat.com, cohuck@redhat.com, dinechin@redhat.com,
        corbet@lwn.net, kwankhede@nvidia.com, dgilbert@redhat.com,
        eauger@redhat.com, jian-feng.ding@intel.com, hejie.xu@intel.com,
        kevin.tian@intel.com, zhenyuw@linux.intel.com,
        bao.yumeng@zte.com.cn, xin-ran.wang@intel.com,
        shaohe.feng@intel.com
Date:   Mon, 20 Jul 2020 11:39:14 +0100
In-Reply-To: <95c13c9b-daab-469b-f244-a0f741f1b41d@redhat.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
         <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
         <20200716083230.GA25316@joy-OptiPlex-7040>
         <20200717101258.65555978@x1.home>
         <95c13c9b-daab-469b-f244-a0f741f1b41d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-07-20 at 11:41 +0800, Jason Wang wrote:
> On 2020/7/18 上午12:12, Alex Williamson wrote:
> > On Thu, 16 Jul 2020 16:32:30 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > 
> > > On Thu, Jul 16, 2020 at 12:16:26PM +0800, Jason Wang wrote:
> > > > On 2020/7/14 上午7:29, Yan Zhao wrote:
> > > > > hi folks,
> > > > > we are defining a device migration compatibility interface that helps upper
> > > > > layer stack like openstack/ovirt/libvirt to check if two devices are
> > > > > live migration compatible.
> > > > > The "devices" here could be MDEVs, physical devices, or hybrid of the two.
> > > > > e.g. we could use it to check whether
> > > > > - a src MDEV can migrate to a target MDEV,
> > > > > - a src VF in SRIOV can migrate to a target VF in SRIOV,
> > > > > - a src MDEV can migration to a target VF in SRIOV.
> > > > >     (e.g. SIOV/SRIOV backward compatibility case)
> > > > > 
> > > > > The upper layer stack could use this interface as the last step to check
> > > > > if one device is able to migrate to another device before triggering a real
> > > > > live migration procedure.
> > > > > we are not sure if this interface is of value or help to you. please don't
> > > > > hesitate to drop your valuable comments.
> > > > > 
> > > > > 
> > > > > (1) interface definition
> > > > > The interface is defined in below way:
> > > > > 
> > > > >                __    userspace
> > > > >                 /\              \
> > > > >                /                 \write
> > > > >               / read              \
> > > > >      ________/__________       ___\|/_____________
> > > > >     | migration_version |     | migration_version |-->check migration
> > > > >     ---------------------     ---------------------   compatibility
> > > > >        device A                    device B
> > > > > 
> > > > > 
> > > > > a device attribute named migration_version is defined under each device's
> > > > > sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/migration_version).
> > > > 
> > > > Are you aware of the devlink based device management interface that is
> > > > proposed upstream? I think it has many advantages over sysfs, do you
> > > > consider to switch to that?
> > 
> > Advantages, such as?
> 
> 
> My understanding for devlink(netlink) over sysfs (some are mentioned at 
> the time of vDPA sysfs mgmt API discussion) are:
i tought netlink was used more a as a configuration protocoal to qurry and confire nic and i guess
other devices in its devlink form requireint a tool to be witten that can speak the protocal to interact with.
the primary advantate of sysfs is that everything is just a file. there are no addtional depleenceis
needed and unlike netlink there are not interoperatblity issues in a coanitnerised env. if you are using diffrenet
version of libc and gcc in the contaienr vs the host my understanding is tools like ethtool from ubuntu deployed
in a container on a centos host can have issue communicating with the host kernel. if its jsut a file unless
the format the data is returnin in chagnes or the layout of sysfs changes its compatiable regardless of what you
use to read it.
> 
> - existing users (NIC, crypto, SCSI, ib), mature and stable
> - much better error reporting (ext_ack other than string or errno)
> - namespace aware
> - do not couple with kobject
> 
> Thanks
> 

