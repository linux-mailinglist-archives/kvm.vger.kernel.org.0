Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C1EF5A5D
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 22:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbfKHVqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 16:46:10 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41592 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729896AbfKHVqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 16:46:10 -0500
Received: by mail-lj1-f196.google.com with SMTP id m9so7696869ljh.8
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 13:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=V7IrbNetsoavhbU9OEE3WMwpWTRbsYkBGa/l4GYX9RI=;
        b=guCNU8PKwMmuxFSdFwF3g+nQ6l/ZD+lVyLR0GID2qepOREoTczF8j3i7de+GeXGqU5
         ADFxCci32GfG0y7y49MozmwSkzCDMd874ecaFBkg/2haXr494a2Dr8Wv0v2hucI6Hk+/
         A7T97GyQ7uTrqcQU3N5IOjrtJMLtJMhi7LTZmb+lN7RgKoVvOgx7K+h2QUkh7VIVaClc
         xq4qplkDXyoG6fMjM4KiM+8PRIhtcyJ3GK95mla/CBH8RAK0Cfg3pRi7+0OmhYjs6joh
         XVT9j0vK1vyB+TW0QhQCNqqr7RaPHCjMw4bXcN2Zn8g0eVpmcq4IZkRao7NINmeVrU2P
         hfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=V7IrbNetsoavhbU9OEE3WMwpWTRbsYkBGa/l4GYX9RI=;
        b=ABYfQzXEbTJjjGkO9zJYmEP8+XceRMbHRd52wGY35Spvh2YFGgTKWdkyfmyjWfB39x
         gRePeKFMrvCzplWf4pRacQo87lKlUjMKKnXRDz1GjJz0o1s2gswuebNwI+YqYkfZZzjz
         SGxJySEMAZ6kKlK8cDGwrMJKREf94bJWx/9lQCKm5buGKYX/LMHVv34WyRa5aQy3HWp2
         8jU5zx8xUB5eNb0/DkBNsY+06/OACcCskpoCZtSSdCy3a9Doiak7mWSN9FX92Pjc44SK
         F9EcTPdGHjXxbOMDpe4ruUY9iZEu9VRf9FVwFlWhDA5ljXsEfXIFIS9C6TkvJ17rDZyw
         bLJg==
X-Gm-Message-State: APjAAAV+bP8eY31OdXPCU60AX6abr2UoPUxy/PRqnEbOShNUMDXix5aB
        fGdIfnR1TGZc4kCqKwRcgyFuHw==
X-Google-Smtp-Source: APXvYqyrege37Ouls78uB7mRTIJEkJTVh/ffAYiEeXT28n2qkUpTGaQSbs6K5Rb9EyR4Euj6o364Ng==
X-Received: by 2002:a2e:481:: with SMTP id a1mr8423397ljf.209.1573249568277;
        Fri, 08 Nov 2019 13:46:08 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c14sm2974058ljd.3.2019.11.08.13.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:46:08 -0800 (PST)
Date:   Fri, 8 Nov 2019 13:45:59 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108134559.42fbceff@cakuba>
In-Reply-To: <20191108201253.GE10956@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Nov 2019 16:12:53 -0400, Jason Gunthorpe wrote:
> On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:  
> > > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > > above it is addressing more use case.
> > > 
> > > I observed that discussion, but was not sure of extending mdev further.
> > > 
> > > One way to do for Intel drivers to do is after series [9].
> > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO
> > > RDMA driver mdev_register_driver(), matches on it and does the probe().  
> > 
> > Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> > muddying the purpose of mdevs is not a clear trade off.  
> 
> IMHO, mdev has amdev_parent_ops structure clearly intended to link it
> to vfio, so using a mdev for something not related to vfio seems like
> a poor choice.

Yes, my suggestion to use mdev was entirely based on the premise that
the purpose of this work is to get vfio working.. otherwise I'm unclear
as to why we'd need a bus in the first place. If this is just for
containers - we have macvlan offload for years now, with no need for a
separate device.

> I suppose this series is the start and we will eventually see the
> mlx5's mdev_parent_ops filled in to support vfio - but *right now*
> this looks identical to the problem most of the RDMA capable net
> drivers have splitting into a 'core' and a 'function'

On the RDMA/Intel front, would you mind explaining what the main
motivation for the special buses is? I'm a little confurious.

My understanding is MFD was created to help with cases where single
device has multiple pieces of common IP in it. Do modern RDMA cards
really share IP across generations? Is there a need to reload the
drivers for the separate pieces (I wonder if the devlink reload doesn't
belong to the device model :().

Or is it purely an abstraction and people like abstractions?
