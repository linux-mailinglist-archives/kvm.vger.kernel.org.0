Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2955D1BB0D5
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 23:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgD0V44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 17:56:56 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:64514
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgD0V4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 17:56:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj+k0fubJhstaz77U9If1Wv1DP9fSzxxtccDrffNLD33jX2b/x227vcWzKrtp5gYThkD1wUo827xNv00RsW58TIAiUaEY6mc8QHNyH/UwVKT4vrLcj58zA9UXlBnwBylS2xVLONc3Rkw88LxOrs/PXYajszwfK8f3s+poYsG8X+E3/enu3WtnnDBLi7ZcqwmDtF6YKo8pSWMg1h8B+n1rkakPVTSnLmUU3L8wOOYjL1gzc0QhV/v24v5yPeVCL6xqhCMo/xK/GQgyvqPlbM3QoMbxo63g+pcIrBNDHhHdsbS+FYx+UV78ZxwXw9T5oLVt//ZRiXtjprTV8V40ZUJNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcnCmuEq8aZhzVNCCtMLAgc2n0RCv7GXGhRtXIrDMmw=;
 b=KIPDqd77jCwk/mFxo6Lf/mRw/nfRjZdCP8TYxXtyN1/ok2XCrRzkPArzV4q9nfIkxM9pGrCe/i5xXhH2Z6REHqaCXH5ls2WracLy3SC0pj51EJkYtNljad7jGGg9hsGJHCI8UFsPFzTrvvcy/MXKeYnskLQdp06itnMLwlSMPWA+M6LVJWocFFUrs2vGBgbcSeQWi/96Y6U8XRhG3aj6U6FhvXtysB+lEhqA6gsdItc+j6N6NgSRjiMR5ZViRBgYrY/n1AuBAZc2qhNV5NOVfA4xbWHQNm0RflNwVkxAgZbmOsH/+CHCbAV3fpkvynOGgs1nk/ONhnbr57dO+vTEPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcnCmuEq8aZhzVNCCtMLAgc2n0RCv7GXGhRtXIrDMmw=;
 b=qIbFevpERsNH4RZ4NaD/ecuA6/v7pYQGb2i7Kx8FbJKHeFZsyMKLF7kpgSyOsBFjPOqp1PzeYkwhhC+Tu6YyXqDbnoxtLehT6Js4gWREQj0hDF1IDJhnlvePROLOsAeFaZxV/qV8KPzSfsXpTfF2eUhe3bISq+lFcrkP+kaat1U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4399.eurprd05.prod.outlook.com (2603:10a6:803:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 21:56:51 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 21:56:51 +0000
Date:   Mon, 27 Apr 2020 18:56:47 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200427215647.GJ13640@mellanox.com>
References: <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <20200427081841.18c4a994@x1.home>
 <20200427142553.GH13640@mellanox.com>
 <20200427094137.4801bfb6@w520.home>
 <20200427161625.GI13640@mellanox.com>
 <e2cbba8b-e204-42bc-44cd-ebdb6be211e3@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2cbba8b-e204-42bc-44cd-ebdb6be211e3@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0121.namprd02.prod.outlook.com
 (2603:10b6:208:35::26) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0121.namprd02.prod.outlook.com (2603:10b6:208:35::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 21:56:51 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jTBk7-0007lf-Vy; Mon, 27 Apr 2020 18:56:47 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5e899449-4b63-4798-0bc9-08d7eaf5e42f
X-MS-TrafficTypeDiagnostic: VI1PR05MB4399:|VI1PR05MB4399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43991448B63195E8CB9B0ACACFAF0@VI1PR05MB4399.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(1076003)(6916009)(2616005)(8676002)(5660300002)(478600001)(36756003)(86362001)(26005)(9746002)(7416002)(81156014)(33656002)(8936002)(316002)(186003)(4744005)(52116002)(66556008)(66946007)(9786002)(66476007)(4326008)(2906002)(54906003)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzBr0K52EwP6yfOti/GLN66RYiZwvM6y2r7OLpRrxqbEFIcPmSWd/fvsHjVJw06BL7HvgNmafAfw3w+pNpWzeIqt+Sk82UBQX/3HRXX9TgQQrjPUfhRZzZ1D3eWofWgObIcJsIearqtqiINe3Vi1H3gtSvwkvLc06kwkly1P55GBieQB40+NKoRviwX0BZ1tRd9mMWQ5TFUIK+E2rp6bFgkSHvQnhE0K3QJHj5LzUs8+7NZn4pvRHv6a3BwM6qLhgtoYgGU1KxXZXjftqOOWWsY1hJHXclKgsq2E7RL9iQcsngLnZhhddjpywQkat+cs7QIdCkXwDghhxUUzXfxcmD+COHxhQT/fQ8U3WG25zIU4YI9lMIlYP93xkoB52vUs5dv5nTjQTz3pRqXb6Wssp9BsQKoSkvo4zkYH37yM4zpSI06V2xcEp9DJX1vp30J/khodJoB4X1Va66G/+d+zQMRp8Mbq5BXMHN6tMJYIlKI507va7qn0GGG0l2m0W6DX
X-MS-Exchange-AntiSpam-MessageData: HzkY/UJ4xQrPqNSS9PqTyAILONQM9/60paQtb8ySlCniFMX4lcXcrlfZTtCUAZDk3nJQ4BZmTNPGI7uA0iu1Xeuqp845hIb8MkGY6TTwt/NTno8N6TyJdDOYIHfrFn0RbOka2hctZwlUkIC+RuEPpoCNFgHjSl9Y3Xk78JDNnpqlILB93w5BRElGGpRQuKn8D5+HJucjTgGmklkggB4I3yiJnz7VHXR/fOV4reCkNrLTlqPbC4zjN7uaZnyb1vmopBfCIXVlCbWsa9m8jU1E/2filmF4euzoeIexbE7D5kRo4E/Ti2r2dUk3hx0tjIajfhGlEdBPUxbVoXZeObbI72S0ocsFsyld1OhG294vKiF+Y9oWyxkhq6Vu4hLkkvH37bGJyr1EsUacM/v8bYWqWG/e3601OkgGH048aDT+s6qJWaJY3RBVMWqPnKx1GfpVoXsIHS/nfmGduwFCrMkJ+r7qYDyD7cw7UgiocJ/UolO4S3BSt2elJioT1jxlmhGxJQ9fjl7aZC/wjq7DLsi6oqd/wlZkbeHBCz6RG/xhMvfTY4z4VNbwmMN/OpMm1YubltiAxuHSj5KwSRvXDRaz3nDFoZ4p92UtnQsXlbVwkQ1yKB41vThNQHnJHgCQAxjRU78+9CaAeopPnjbtVqRRFVzWNZ0EIZF6VrbeUIbON6I2zlgEr7bu4FDfD5xO27ZTgJNRMRFgpr4BKGqxF6YZMDjLF7dDgLTuJaN0hQv3l57Ws1gK6xrWk5guippYD5xNGLS9ydb8YaMS5lRfkabqBXesi2CWIHGXT92VHb30I+4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e899449-4b63-4798-0bc9-08d7eaf5e42f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 21:56:51.7486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKRnfwW4fbq065noJO3E9a5fvCj/cgw2uH5dzRWBTQC9CON3ruoUGzIoPqDB9J6hiI1oD+F09woxVRGM+XGzoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4399
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 09:25:58AM -0700, Dave Jiang wrote:
> > Also to avoid duplication, ie idxd proposes to have a char dev with a
> > normal kernel driver interface and then an in-kernel emulated MMIO BAR
> > version of that same capability for VFIO consumption.
> 
> The char dev interface serves user apps on host (which we will deprecate and
> move to the UACCE framework in near future). 

The point is the char dev or UACCE framework should provide enough
capability to implement the emulation in user space.

Jason
