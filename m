Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638F9318DBF
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhBKOzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 09:55:48 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13151 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbhBKOuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 09:50:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602543f90000>; Thu, 11 Feb 2021 06:49:29 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 14:49:29 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 14:49:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzqM86tay4hV/V/HPORinh9SVEGz1ZkNMaPdNHoIZgQgtsm+yL2jUMo7IYFt3JxRNeQJ2mHmEGaWVTb5WnkcYJjV+0ls02ZjKm9GNlEiY0zlN6HbH3C34zhks773tRYWHnJFeGu8a67+Q1oWqAjfRzvVXnEI5D/gGrdkFuBViz/KcPD2C6iT2kAPSoHYSMWwLJp5RTu7zABc8cvMZDxBKvC1rvgQgV9Uv/bx9q4+SCLDzJ+AuYTmZAR+QA4SkI9JidbniLhL6NArN72XGMByObW6MBmoC7zMkNG9W2tWTshK/RKKsmwpT3gxYVqQcI+BVCNy34T6UMj3ijrNqjuBzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErIPf6mjysjaYOMJQ1I+4T189UbJl5Ac4YEWLaoX1aE=;
 b=R/t+zfufRh9qszA2A9fCP6hc11MddC5Mxrc4cDCcsZmboKiWJT/t9P+YsUXWB55PPZm3wtoCPZEr9Q0/qJ35M0AGpEbfpIstHJJwLkC0GqLl7kKst1YoY9qczKZIeVrZMV68UpxIlZd/wk6UkFSH7LdPzEQ70Hc1EvZB8A8Q3vur6t12bvcGBt160Fag11MXdeLdCZLslsKRovML2JnC4643dX1qOSx3GbBHECWX9/yA8h/GxpsaEA84wqmJJ7CZ91UhfT5G0SjyyD3FO+zVm91OWUzuRLc+W5nlKBHTxjqknI/fswN0ol8Fs6G6vv0UagUU/pIMCY7vEUfSrgMZew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BY5PR12MB4855.namprd12.prod.outlook.com (2603:10b6:a03:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Thu, 11 Feb
 2021 14:49:24 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::10d:e939:2f8f:71ca]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::10d:e939:2f8f:71ca%7]) with mapi id 15.20.3846.027; Thu, 11 Feb 2021
 14:49:24 +0000
Date:   Thu, 11 Feb 2021 10:49:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210211144922.GM4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <806c138e-685c-0955-7c15-93cb1d4fe0d9@ozlabs.ru>
 <6c96f41a-0daa-12d4-528e-6db44df1a5a6@nvidia.com>
 <20210211085021.GD2378134@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210211085021.GD2378134@infradead.org>
X-ClientProxiedBy: BL0PR02CA0077.namprd02.prod.outlook.com
 (2603:10b6:208:51::18) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0077.namprd02.prod.outlook.com (2603:10b6:208:51::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 14:49:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lADHW-006YHq-B7; Thu, 11 Feb 2021 10:49:22 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613054969; bh=ErIPf6mjysjaYOMJQ1I+4T189UbJl5Ac4YEWLaoX1aE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=g11EzGwuHh4fAN+RX1sq/2DW5gOEMsmdB7Y6jfcYmVFJYnbTQIQhE6dYMkJicMT4o
         iJ9fYqxwipOIguAvwpbWmRkVd8gmwKGvXrmzsXbjRU2W6zxF5Z8k+xiM7ea2PJJur2
         Mrr/lV2ptNmNpd7IN0hTRaGakV4E1pJ2D8ALrZZga3Y3JLPPJyzcy4yE37dHp0ReBs
         WYUloxQ2m7Q6ZpYPGbQHKgwJul3YKBQacvCkZyrn9Fwxx41Mt/kut3in1WYZE7A5Kb
         jP/1IubY1hy8F8NDOhIppc0E193JxUJbvlEEr9yF409o3hokUvNQuDCIUAaP8zmhlE
         taKiPJpyvKTRg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 11, 2021 at 08:50:21AM +0000, Christoph Hellwig wrote:
> On Thu, Feb 04, 2021 at 11:12:49AM +0200, Max Gurtovoy wrote:
> > But the PCI function (the bounded BDF) is GPU function or NVLINK function ?
> > 
> > If it's NVLINK function then we should fail probing in the host vfio-pci
> > driver.
> > 
> > if its a GPU function so it shouldn't been called nvlink2 vfio-pci driver.
> > Its just an extension in the GPU vfio-pci driver.
> 
> I suspect the trivial and correct answer is that we should just drop
> the driver entirely.  It is for obsolete hardware that never had
> upstream

The HW is still in active deployment and use. The big system, Summit,
only went to production sometime in 2019, so it is barely started on
its lifecycle. Something around a 5-10 year operational lifetime would
be pretty typical in this area.

> support for even using it in the guest.  It also is the reason for
> keeping cruft in the always built-in powernv platform code alive that
> is otherwise dead wood.

Or stated another way, once vfio-pci supports loadable extensions the
non-upstream hardware could provide the extension it needs out of
tree.

Jason
