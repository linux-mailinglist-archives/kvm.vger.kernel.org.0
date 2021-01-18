Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37B62FA6C4
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 17:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405707AbhARQxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 11:53:51 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:33132 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392608AbhARPLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 10:11:10 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6005a4e10000>; Mon, 18 Jan 2021 23:10:25 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 15:10:25 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 15:10:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=By3J64JF3VjwngPCGYNg+KfRk+nBG/3djRYQlzaS/aAcRhwfTRFmaApRxe7sbNGDo9W6453CswdV8cwrhAi1HsFnF0fDS+9YTS2KfwtnD5qOZY6pD0G8KIrP1Sb3AW9mdV34m11hXLSOL9oDD5uV5F+elZDQmyudSpv5vp9DfUUunv1U47JigkKCT5/iGFDNOg4Qixp55HxS6i+yXMQPdX8omd8BVgkR+CLdVnimMCY/jIiLLXLT1QE06Vwa1chdGq00GwX8MLEty1gvLrlUZFylaACHOsZkvHYVtwHiefRYSObHEJODolk5f87Mo6eqT6SOIpLZzcI0RONiGO3fJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zp2nJWf58scXc0afBue44ww+YYq51czW6B5CBcS/vu0=;
 b=d3Tw4Q0AR4bx5stTQZBRBS8hW4WqG845b0EXas017w7hgRVG2mJd7CXypWqF/4hg14lUBEmZP4J4JoBXyhdyfReim+Xqb1cHZQWr3GNuA0Bj2RhJwo0An8u6f2AiEWcjUDh/arW1j3WaKlgwQVVht/Vxb2YsuGMZjwFkHEUbVW8m5HArltpfH3eci7jhKrReIbf8sAJBWU16DnlNkVoUXS/FgptyFFkdzdaoKVyX6rEoHHoICnY9sXDgrirFpRcqeICMT+nkAf3oIzYVIijR1NIw5FkM47KzeyjzKq9hsM12AGAgKaR00u8ZiwLL8YenM+KdYLuGCWCN27XU/HADvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3514.namprd12.prod.outlook.com (2603:10b6:5:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Mon, 18 Jan
 2021 15:10:22 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 15:10:22 +0000
Date:   Mon, 18 Jan 2021 11:10:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>, <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210118151020.GJ4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210118143806.036c8dbc.cohuck@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210118143806.036c8dbc.cohuck@redhat.com>
X-ClientProxiedBy: BL1PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:208:257::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0057.namprd13.prod.outlook.com (2603:10b6:208:257::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.9 via Frontend Transport; Mon, 18 Jan 2021 15:10:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l1WAe-002y4q-S5; Mon, 18 Jan 2021 11:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610982625; bh=zp2nJWf58scXc0afBue44ww+YYq51czW6B5CBcS/vu0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=qLLGAgc64qkskmjLvhhreZGI71df9up6Y9Izoko5k5FScv5LVuxBjIU+cGPc7N2HI
         soWCZFnwzCGfSk2G61bPnucg7tqSBgH8/FEyaI2tKbNrxp0pisyZ0wUdUnsjk2nXMN
         y2DSMK+1RMMPEXKcti2NLrOhk11p5ZH6TSGZAz/JFOP5bv1r5Voz6HNISCNIFq2VC5
         2BYhW4dUYgEoW0wly+h5rRk6aQWoNeQJWrC67TMh6/BttzfYP34LuibzBjdchkYASA
         ksDxiboeUjGOCeyh5svXiBYI/kgniMopLEQ2sj5Xno4K1cHcAVaSnbymZiE0hNVsEr
         ygVy2eLpM/vpg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 02:38:06PM +0100, Cornelia Huck wrote:

> > These devices will be seen on the Auxiliary bus as:
> > mlx5_core.vfio_pci.2048 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05:00.0/0000:06:00.0/0000:07:00.0/mlx5_core.vfio_pci.2048
> > mlx5_core.vfio_pci.2304 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05:00.0/0000:06:00.0/0000:07:00.1/mlx5_core.vfio_pci.2304
> > 
> > 2048 represents BDF 08:00.0 and 2304 represents BDF 09:00.0 in decimal
> > view. In this manner, the administrator will be able to locate the
> > correct vfio-pci module it should bind the desired BDF to (by finding
> > the pointer to the module according to the Auxiliary driver of that
> > BDF).
> 
> I'm not familiar with that auxiliary framework (it seems to be fairly
> new?); 

Auxillary bus is for connecting two parts of the same driver that
reside in different modules/subystems. Here it is connecting the vfio
part to the core part of mlx5 (running on the PF).

> but can you maybe create an auxiliary device unconditionally and
> contain all hardware-specific things inside a driver for it? Or is
> that not flexible enough?

The goal is to make a vfio device, auxiliary bus is only in the
picture because a VF device under vfio needs to interact with the PF
mlx5_core driver, auxiliary bus provides that connection.

You can say that all the HW specific things are in the mlx5_vfio_pci
driver. It is an unusual driver because it must bind to both the PCI
VF with a pci_driver and to the mlx5_core PF using an
auxiliary_driver. This is needed for the object lifetimes to be
correct.

The PF is providing services to control a full VF which mlx5_vfio_pci
converts into VFIO API.

> >  drivers/vfio/pci/Kconfig            |   22 +-
> >  drivers/vfio/pci/Makefile           |   16 +-
> >  drivers/vfio/pci/mlx5_vfio_pci.c    |  253 +++
> >  drivers/vfio/pci/vfio_pci.c         | 2386 +--------------------------
> >  drivers/vfio/pci/vfio_pci_core.c    | 2311 ++++++++++++++++++++++++++
> 
> Especially regarding this diffstat... 

It is a bit misleading because it doesn't show the rename

Jason
