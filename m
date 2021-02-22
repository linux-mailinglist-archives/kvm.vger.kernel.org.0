Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E4F321EBC
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 19:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhBVSBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 13:01:36 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11902 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhBVSBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 13:01:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6033f1450003>; Mon, 22 Feb 2021 10:00:37 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 18:00:36 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 18:00:35 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 22 Feb 2021 18:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEyE5Foyx+LzFgedN5t4danpXvj94WoA0xlnZL3tfSGgFPcMEHGtxaKik0K9wBp+wCBOZIDVjrNk0eLbA/qse+G2r3gaZ8G043ieB7Zw2uLeP++X1QwAUjeTycLwy1qnvt/tcYeqJqvJ5Siqn4vxeAxjBkE7BP35u4nKoE8EmWMAcrGld0cql7W5mjWUaJRFCxL7gddLKflvob+FTmoo9dA3xURJvtrE6wZtL8dByNR9FiPYKOXJ5BkAkkZ8UJ0/5uJ/LWGjhg7cAICewmj6puGGINUSf7k3/x/lZb8rLBxuVMQg7ZXTpsaBz9LtbSgur2PW2hEPDZfh+qYjp0aPEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xMU25c5qARPtud9sssUX2OPCpeDLepzDuGHSJoSGz8=;
 b=oa3jsq2xAd7TAFPhPezwB8iz+gZZHJrltHCDLNFsl5AOd5RRp7zJV2Rn7WCThby82PFZStEAI/w6iBR8gR1o9SxKtF3HjvYRuXPSDUA4t8tb/r6PGAHpEB58QW0j/Qd9NKbMJbqA3fsKwyQrDWAyKGHm37CwBkTK+4CVijpQ8iYGaC2TOWbPAGgMcBrFEWhklqWZQ2z/A2IVfiXAedgKqIW+8NuxSFlChs5Jvg0g5j6lj/enfGwW1RByURvQepZAEkfkoVD8+qu/S5xGaOLg3662W0qG13DK/3P7MhGGabpVuFUZKcuamZ0ktGtpVf1eEL4nTDlwuNDC7srVNbJUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4497.namprd12.prod.outlook.com (2603:10b6:5:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30; Mon, 22 Feb
 2021 18:00:32 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.045; Mon, 22 Feb 2021
 18:00:32 +0000
Date:   Mon, 22 Feb 2021 14:00:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 00/10] vfio: Device memory DMA mapping improvements
Message-ID: <20210222180031.GR4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161401167013.16443.8389863523766611711.stgit@gimli.home>
X-ClientProxiedBy: BL0PR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:207:3c::43) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0030.namprd02.prod.outlook.com (2603:10b6:207:3c::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 18:00:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEFVX-00ETGP-Ds; Mon, 22 Feb 2021 14:00:31 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614016837; bh=/xMU25c5qARPtud9sssUX2OPCpeDLepzDuGHSJoSGz8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=msGmGPpziq2wJhyYVNFv+IBLQhCRHBQ6GKORP/uy376hauC/NccVj92T9p85ahlRN
         jJog9RgNA1fvx9NvMkWrxelopAs/34kcGKmr7+mMyp4R3vXldQgB5JH/Lzg2LJFHZR
         bRvXr7rdoQ0OeoPjBnhh/P3arpiBdlsUSr0Xb6iDBJ/7JV5txD8gDJeqQDwRYIOXHY
         MWFAqWnNVfkhrXwKopsbT8XrQRvGefSrOmDviw6ZrBzniYb7aJ9vyJrYN2PH17YB4g
         PUZ6UHKW/8FrupEWMJCBAEAWtzHJHf/wtNvkn0OR0YU+7wGx2HE9COsaNZApxzEaNg
         /9CHVrcAPpfsg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 09:50:22AM -0700, Alex Williamson wrote:
> This is a re-implementation of [1] following suggestions and code from
> Jason Gunthorpe.  This is lightly tested but seems functional and
> throws no lockdep warnings.  In this series we tremendously simplify
> zapping of vmas mapping device memory using unmap_mapping_range(), we
> create a protocol for looking up a vfio_device from a vma and provide
> an interface to get a reference from that vma, using that device
> reference, the caller can register a notifier for the device to
> trigger on events such as device release.  This notifier is only
> enabled here for vfio-pci, but both the vma policy and the notifier
> trigger should be trivial to add to any vfio bus driver after RFC.
> 
> Does this look more like the direction we should go?

Yep, it seems pretty good already, see my remarks in each patch

For security only vfio_device's that have been enabled for P2P, set
the vm_pgoff to the pfn, and trigger invalidation, should be used with
this mechanism.

I'd add some global opt-in so vfio_device_get_from_vma() will refuse
to return vfio_device's that don't declare they have support.

Add a flags member to vfio_device_ops would get it done fairly cleanly

Jason
