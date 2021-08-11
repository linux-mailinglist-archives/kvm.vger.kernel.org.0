Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65E23E8FEB
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 13:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbhHKL5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 07:57:45 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:46465
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236777AbhHKL5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 07:57:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2KMNCu5bFpAMLF168N8dufK/npptM2KuLpkZtGoSL4Kf07AAaeMnuhXM2/wLP2CL56TYG2UrlzBYuWV6fQeVR5eVIidVUJfjNL43KIJNncRGToU6ndxKkSBB4XH3dKtrUZUlZZSyhhv13WhZn+GKYyxtkqyj2TUxlN6UuwuIbKnxidAYk3IQgUQK1h6yQNYgUv6sZrB3C+I1EHyp+iU5ey7vrOANzKmgczARZ2l0gOgHoLlpZWjSOIYlW01rja3KotPU0OZgVtisFamzbjptjYGtdSBS0nkN6iv2HPw6AhuJRcXVMPj0+jQpSWcj1UhOiZhKQLgmeIlKwKlRF8DsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJR1/3yi0xCDuPDEIeiWCm+iSCn+iW0Q9rRQnKjw+J4=;
 b=ThLTIp01tl4gQz8sG8MKLRw+G6Ixah6OXpkpOWtdW3LUcrJ8gMN/1EB8BmvB8mLt1XpNX0hLWhfGbCIl16wXQgturEuCpNbzc+0r8Ec3XyE9UX4hYboCJ3m4J0zXOtSA0pQZdXJNs1VLcJEW24Aob4wnclkQtnl+ggrJUX0Bcyrcu9oGL7lDipPopfbffRP6iQGO1UzNtMrR5CIH5lpdF3HHdHFWon1sXCEmoi/tVxdAR47KdR7HCySPJvp4fDI+XSul7jUB/vLXgBDWtDr2zDVi98TonnqwEORwiNsk9L4WBSEwpOLbXhfKGm+zdhtYvIoTIhI6IrOMPkK6uGQdUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJR1/3yi0xCDuPDEIeiWCm+iSCn+iW0Q9rRQnKjw+J4=;
 b=tIC06yhFGOsM5wDsJhIgbIYXf67IgD8M1oa5+hX0GJX+4OFSo3Qn3eLhVOBLaohMtvjrGlTn7eOkQKHzZz3gYkEurviv9TgGpSJlsRqEBbFHQVi7AQsEYGb8h4bPj9ojeYL+furw6QjdnHYTBAmtOsQbpD1XV2X6w1FXV5YrP6t1YuYPRnHH80/OEJcT6kIikRhN2+TuypexzS2m2vlS9qcNW3Zp936XS46wAknVAyXQ+7U2kZm9Zxp+lkJnyw5FszPEo2jI/0ppNFK7xwRhLVMT/ma8m7Gdxvd6iGJ5oDHIu0se7sMNkAkMh8j+uR/i6jKQwtd7NV0w/GMussfVMA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5078.namprd12.prod.outlook.com (2603:10b6:208:313::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 11 Aug
 2021 11:57:17 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%7]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 11:57:17 +0000
Date:   Wed, 11 Aug 2021 08:57:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <20210811115714.GB7008@nvidia.com>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
 <20210806010418.GF1672295@nvidia.com>
 <20210806141745.1d8c3e0a.alex.williamson@redhat.com>
 <YRI9+7CCSq++pYfM@infradead.org>
 <20210810115722.GA5158@nvidia.com>
 <YRJ3JD7gyi11x5Hw@infradead.org>
 <20210810155058.4199a86b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810155058.4199a86b.alex.williamson@redhat.com>
X-ClientProxiedBy: YT2PR01CA0001.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (24.114.84.178) by YT2PR01CA0001.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:38::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Wed, 11 Aug 2021 11:57:16 +0000
Received: from jgg by jggl with local (Exim 4.94)       (envelope-from <jgg@nvidia.com>)        id 1mDmrC-00022w-A5; Wed, 11 Aug 2021 08:57:14 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bff2a96a-65cb-4c1f-562d-08d95cbf2a67
X-MS-TrafficTypeDiagnostic: BL1PR12MB5078:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5078E3280B6D211AD9F2858EC2F89@BL1PR12MB5078.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qt9bYkltQIJcsUb1YI1acgvfhRO/C8Z3dcaUdWvv+s85VDYtoKD30khuhCiTAKVgW7nZ/SPhhAnUz3TPkDbUpbnfjKdSf+AISGcG4qFgiaKzUuQhfQPCstTVaLn4omeV29NUS6IM83EXMW/AIxMheZjdym0lD/3iwYtXbGVKCrmj/5hnb9m5B/9UCYvU76M1FW307EA7LOMNKDngatHoi6FVCcvONmfswDganqQXhXevkSIHsd5PakwlT0oGd1BUN+E4x+1QCF+HTcvOBlVM3/t7II/I2eVBprUeWDHwVa2AYtb1oCKzK6HK+6gHjUh8qe1yIy34wE0BWZP7tQbWTO+LNfRG1xBek7Reof6PrrZUFBRYCfa2Dp2csXk7xzlfA1vypUC8cUrBh4P5hkpxlKH3QgdnAAGl48nXzbj/ansYa7y72RkM/62dyN0y6unefnkWgwBXlcU72J4K25naEirqGrpIQH+AOHbCoazaHDlMAQYqBEe6st35svIXbFSp2Zcewh4vKOCb2dXYS0za0g2wL0UFzoTFgZ7+obMu5xPhJxoGYqTB1YrVLCx+j+XGzfHnEKV36g7Ki3iLyf/SrNq+SgKlY9Ki9XMNrupD9BIRbK6CeAYiHOMsvYo2S60kjmM0uC7pGRrAMvhdu2+iOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(6916009)(5660300002)(33656002)(4326008)(83380400001)(86362001)(8936002)(8676002)(66476007)(66556008)(2906002)(316002)(36756003)(66946007)(426003)(26005)(1076003)(2616005)(9746002)(186003)(9786002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AZaKXvSC1gn04r5sV9CRJYj/uOacfKpMYVte+2y+xc8RJxLHIz1QNZ6Ob0kr?=
 =?us-ascii?Q?ksUxMXOuoOIVg4ac82dfAtdnw+blAWZE2JwqI0tMc1tgp508cTS7dcaftk3o?=
 =?us-ascii?Q?QYEGGtjAPTSSqS8ahBx9zlMni9z/EH+g+wGGfkBhTZbRDBNVVWKnQteKHsu1?=
 =?us-ascii?Q?RLuSee4aWKZ2JcqMlyRflFV/94kylAvAa348xy/I79s4Yfdv5Xi7o/Stp0Jd?=
 =?us-ascii?Q?JVMnyLeDxPePLcL5EEjpfk4sASOBd+wAM0LWiLBYuwC28yMBnJsytr22A27L?=
 =?us-ascii?Q?dOrruzJtqdIrtU/B3U5zfwD8kmkpHX9ZqIeadLpriX8ecGYPcPX0R89ZNXP+?=
 =?us-ascii?Q?NBl/0QZTePfhWZW+xhtbVM8KwgcuwLKhAXJff+mANa9rvZqkA/csaKhzFje7?=
 =?us-ascii?Q?RZRSRyrEPhQSLSZJgok3H8svM7bUvXARfMFU4v8IBW+5pUWjvljtf6yo8UOV?=
 =?us-ascii?Q?PIhlVP5B7KIqVp8GArTq7RaHqLkLz6OvjF6qTY7GdN90yluEfo3HM4bYxEVt?=
 =?us-ascii?Q?aK7IQ6o97GtfK/e+5ULxZ7l3XG6pl5hRsfty/AoDETTLMSbQNe5+5xVuwswA?=
 =?us-ascii?Q?uYe0oZvatgpYAEo5AhmXoLhm8r+cwriwUUFeso1myHThXi37fw2/wUrkC2TJ?=
 =?us-ascii?Q?v03FaIwT9mmL/jG5iOb0AtaMCPvFX9PBkWBo5+IJgcTIVbWb/tkjers1XyY5?=
 =?us-ascii?Q?BBo4lqUlhaM4RecwGzOITJMVMKrBjuvOpj6znuALZ/hOUFE+FlG8VXfTXFMa?=
 =?us-ascii?Q?adC7FnTvZRm+hrAYZby27gpO/hjNP5N6hinRqY7pyKCTh+gD9X84Sqdffhqo?=
 =?us-ascii?Q?hYIMWzCLDZt+EZ0KxAsoWm6bt0g8bCI4sZiTdd9wibnkD7m/zCCSfGLnLCyL?=
 =?us-ascii?Q?ZzQYjRwXEUjRb1cxzsI00+x27MTMH2SvHmDEl26FWc7rGuk7LVUkh3ZQ3D2l?=
 =?us-ascii?Q?HFGgjABJkZCnxeTThTRC5+xtlledPFlhnCkDfaV5OPIHgtUQ9GyjGRzZRT1H?=
 =?us-ascii?Q?d6QuctX4B1wOmFXnm7Y1vWxGvtNcqq/GyqfNVfTtWSFOy5alyqgnRAzo+jdl?=
 =?us-ascii?Q?IV4wpeNyJjk+vWDtdNRZlVY5PUwgIGKyvo56XBGPy4AIp6EbDFsxFan6cFoL?=
 =?us-ascii?Q?FXrSUVt79FmImZT/jM3H18BcFYizf5oNzDuGH9V5B3/WVVi0c5aGqYEz1lqT?=
 =?us-ascii?Q?3jwI/FqFgE6DXeBjxGQEnAuBiQI6SkQQbUcgXR60fr6HItWAyXllmFJEbQH2?=
 =?us-ascii?Q?PhKuk1DY7RKayHAaosg8N7HZd4JZfVnyN6xO+t3RcUQToBhEkAMtAJsLb7GA?=
 =?us-ascii?Q?SD42QtNrm9Qsbt3eidZO1mLC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bff2a96a-65cb-4c1f-562d-08d95cbf2a67
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 11:57:17.2064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfcMzHGoXFPXvaOdheqDx3oricV7WI9DngJQALxM9Zxz+DftiSpBArDIGkwzclkY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 03:50:58PM -0600, Alex Williamson wrote:
> On Tue, 10 Aug 2021 13:55:00 +0100
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Tue, Aug 10, 2021 at 08:57:22AM -0300, Jason Gunthorpe wrote:
> > > I'm not sure there is a real performance win to chase here? Doesn't
> > > this only protect mmap against reset? The mmap isn't performance
> > > sensitive, right?
> > > 
> > > If this really needs extra optimization adding a rwsem to the devset
> > > and using that across the whole set would surely be sufficient.  
> > 
> > Every mmio read or write takes memory_lock.
> 
> Exactly.  Ideally we're not using that path often, but I don't think
> that's a good excuse to introduce memory access serialization, or even
> dependencies between devices.  Thanks,

But a cross device rwsem seems OK to me?? It won't contend unless we
are trying to reset and the upgrade to a percpu rwsem to optimize
the atomic doesn't seem warranted since this path already has a vmexit
and a syscall in it?

Jason
