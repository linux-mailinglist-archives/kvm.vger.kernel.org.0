Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241D942DE7A
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhJNPpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 11:45:08 -0400
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:3647
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230199AbhJNPpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 11:45:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtuDF3ccRPtP/oFq59vbuFEHwatj7XA52mcp32hkZ0OgEDq+TBJcfpuSP57Wcue083mfUjCRL/k1vGBMQ365LFExhVvfQ62MEAO85nnyR0FGmsQnqAgZqVyaoB2o2POaxyJONUTgCBChR7pYtC6IMTqsAIYIcvbGJyxQp0gHhbU3vFbro+fboIr5QuV6H2JvV9eUSdgVn4zgpRl8cPRs1iRUTOeRN8Vu+TrWOudjMCu/yZmO56D0E29LREx/i9mDaQHbwy2PEciJNhxOm/46QaLIQ+rj8a9JGF1lW8wvAQo7GqJ25p8CkMaj7yeN8i7/jJTq6Ko0hAEvQMfoXCNfFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K4gSYglmvuoWeNUMfL4GjumqmeG8BOxWpOsMAkOXKE=;
 b=Brl+TY4wvAL/UR4fOQhm1oclFUXOFnThvTMmF9qJo1FLIVPExG//+sqpEjudE+3aLm27VIHuJzQd6/wz/Cvar9KNCcIllTMGDKPJDzL4Kjl8DfW+2cgz/bY7QXUOxcs/IKwxZ5VVOe9vjSMOOmzROR7xf8Bjk7KgF4+Ih8vS36jeRsxmfTN94v67omQey4NgdjldO27xLKrIRoqj6wj1+s37RtMh4vAyrYQCvnqv/faAKBB2A0GxPCSm9jvP5cDoo30gAcNpZi9bs+IIfQBTB6hByKw+vlQmE/opxNHiiUijcUgKE/Ceb95s8N1NU6qpp+SPm+XEOAPt+QgkLW/uXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K4gSYglmvuoWeNUMfL4GjumqmeG8BOxWpOsMAkOXKE=;
 b=Z+C8OdmlULHBJxSiuY/7aVv08s+g/hK8DDkB6s4hDN1ODEXW47dhHqP6YpdzPB/IIsrCkgeg8XHMIYDVOdiTH5bJ3q2FuQw1T2qgMgjporAKX2zDyDPswJUObY8BwTYciPbUocfJLVbtkbATUacdMC16f008/v4EY+NbLhKMYmdTW2VKH0RpgwXNeDo1vhjcXEgkKwA9JLr13DcThId4sg59wz70bjJXAnqGbRkXO4u0wbHlh5BWtQ3MImdojTVSedFcW2tGKTQlzwcrAMJFPu0tURhHmOiDNoej/2B3ZvbyD468qysoyYOL2XW88GnZx/z6K4+mJW7FyAAo6xxJhQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 15:43:01 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Thu, 14 Oct 2021
 15:43:01 +0000
Date:   Thu, 14 Oct 2021 12:42:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20211014154259.GT2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
 <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0011.prod.exchangelabs.com (2603:10b6:208:10c::24)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0011.prod.exchangelabs.com (2603:10b6:208:10c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Thu, 14 Oct 2021 15:43:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mb2sl-00ExaX-JG; Thu, 14 Oct 2021 12:42:59 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07271f29-8153-46c9-0d97-08d98f294da0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5127E8D5F183EDAEF60216A8C2B89@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koaViU9VbI/DN5eHZpzQDS/VjNxQ7r5PuRMyu+uxkd1/Onk7H0tk7X53UR1ziURGTbIbdyREQXGAkPAKCSrVu7PL0OOdUiXLueK8y+xe7GDEfuWVuGSmcTLtNhyhvw4XXib+Ik8JO/3PCN4DVmTVF8f9P6UNmiHOsubs5L/Jryq+G8VxYgFe3Zuj+RJRburltHhx+VgajXsFn5IlDDUqrjobgWKCYh6mxLlckzp0tfjnpz+eydxWHrfHu8LsDFW8c/Z5W5NaNum4zRMVQiTWWgHxKhPZA8EK9jYsSKoijbu+rf7FVKtBP5w4LXCnM78eX+O9UKov2Dq6M1oB7cxU9mmqtcVb7MHM8VvOhCbGrNpr7dq6K9QDgeWBcefmOhtTAqX9p6AnrGAcWBaLY13v96pmIdmyBIw2Y63d0jNOVyW0TSPILVuDa39NP9rVh0vemQjiC/aHT1NltvKk7bhUMCZWsDpSeG3IwCpNekOuKXoMiAUyTyzrltopw6lSL68mpAMPXla4aOqPmkTWzFg5Foih3/ibUkHJqx9u7aZ51hjlxexnzfVurDzSCq/wfm+4ugv35ELJfqaoQ8myhgn+kQHBdveeoDt/ZJVJiYwvHL2P+7VMtbiJsE+sCCoptymJP/grcFTYjU0lDU02l527nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(426003)(7416002)(66946007)(6916009)(86362001)(26005)(2616005)(107886003)(1076003)(186003)(83380400001)(508600001)(66556008)(36756003)(4326008)(38100700002)(316002)(5660300002)(8936002)(54906003)(8676002)(66476007)(9746002)(9786002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4jijM/pUAM3BOr10awphRrYFl//SZ1cvMRlMy1IQjRnd1Tez3p5Jg2eemWnc?=
 =?us-ascii?Q?fyZwI6l7tIPIoTDUUF4lEk7MqkK9y1DSBkVs0k2OgIZg//TPAcPuNoXGRYkx?=
 =?us-ascii?Q?p3OALXZk7r4ukDwOSIK4oxdtLM/OB459WinsGCpCmBRVxaGi7zSJvq+v6exm?=
 =?us-ascii?Q?dIsHt9PbPFHgMhsqjJlkdwZehttFXnKi+UaISvu59ApxJ9jAaYJX5mPex94l?=
 =?us-ascii?Q?zvtg0OxTuf0jmxCPSvZYCIhCAtF53yZ96BR2QGK4gp2BCVFcSkUK5Jc6wHDn?=
 =?us-ascii?Q?l9gcqmLYEtzMmobhDWiad8e19FdhSSHn1UkIXMDdAaC6MCZGQKvhRmKIv8ZJ?=
 =?us-ascii?Q?uyKlOGc3kTR5TsglTNWq7tIX4Q+G6KhQQd7s6I+QiesyQiMLs0L8TFWaURUG?=
 =?us-ascii?Q?4vJ6nsGcF3jThQQlP2tPRKNDsL0MBlbphqSVmUJ9LKGVMMxZHdcf/T6yS7zh?=
 =?us-ascii?Q?+mDCHUXnk0+i4ubLpPCmEvIMzc8bDMqyd4JkhKL2nAeAp9cLLUv43hbLGz7l?=
 =?us-ascii?Q?d0FIm9wZ6MMiBovUi+9cFbxlnjZeYaD6ujCgwkklWhpqqxDTOLYUZTHGFaaV?=
 =?us-ascii?Q?WMUHIGjQbEMrl8b9QvSSQKei4jA6YoHKaPpAeL+x+zdufC3dp2H/thPRS1Rn?=
 =?us-ascii?Q?L0F3zEgk4/evcgNrjI/tt6Nf8z09USKJorjwwzOtqRznPLRxnB5O0+fQfOdd?=
 =?us-ascii?Q?MrQkVQ/a9RMC3S5ru4jxq7xzPtT9IP30mCdde05NgBmSdjbSykZjlwQ2ZiTH?=
 =?us-ascii?Q?i68Jrr8roIc63EPR9SeKTvjfhzkLirR28D02R4UcaubAu9NfMV65CPcFSmqz?=
 =?us-ascii?Q?2giyKdDX/uPkyJGf4+yBHxcI/ZOBviYQA2U6erpeG+cgzvGCnp6QsZqt8kBt?=
 =?us-ascii?Q?RuIP3fP7Zc36SYo6dhfHzuyCib6L89Q5XEHwGJvvK7R53eU+3LBZ4O0xyLpS?=
 =?us-ascii?Q?jpzZbJBffE+xzIVdbFx7Eqcm8C4+8gzwQW7DGdthvdUJz+sajI9KRs7ahL2l?=
 =?us-ascii?Q?Zdz9NLnX7IcgKP2hW4s8+VQhcb4GSKqN7gtaeAjBuNLUUa6BtG1w5WiBmVuS?=
 =?us-ascii?Q?nIkKN9aS86kZovCLfeERPecDrrR9lMavfCK6+cn9G8nPZPEr1ZCb2MuRYQtH?=
 =?us-ascii?Q?gBsvy6z0snTNElraUg+5g2QiszJgS9nxFVnrbJma5SVn5nGDwd3syfh4NFC9?=
 =?us-ascii?Q?5vnVGL1hJsLY96agJyJZsq9ox5fwYOQ46oA2OG0mJ4XYud5N+ujC+Is30UsK?=
 =?us-ascii?Q?WO/nqylLUKz6/3+HCI5TwoCVedv9G8UgoGeNSa7fJ9cxGL9BWiYt8kNHsKik?=
 =?us-ascii?Q?3SvS7f0whYqmd/wEpKIj7r+zsOlibz7q15Q86X7pRH4bLA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07271f29-8153-46c9-0d97-08d98f294da0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 15:43:01.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i+vz/8pxeib3hRjb48UJHQM8Jie9CXu6kunKCCnXaeEhU5VoDWFt+aFhUADYdGYS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14, 2021 at 09:11:58AM +0000, Tian, Kevin wrote:

> But in both cases cache maintenance instructions are available from 
> guest p.o.v and no coherency semantics would be violated.

You've described how Intel's solution papers over the problem.

In part wbinvd is defined to restore CPU cache coherence after a
no-snoop DMA. Having wbinvd NOP breaks this contract.

To counter-act the broken wbinvd the IOMMU completely prevents the use
of no-snoop DMA. It converts them to snoop instead.

The driver thinks it has no-snoop. The platform appears to support
no-snoop. The driver issues wbinvd - but all of it does nothing.

Don't think any of this is even remotely related to what ARM is doing
here. ARM has neither the broken VM cache ops, nor the IOMMU ability
to suppress no-snoop.

> > > I think the key is whether other archs allow driver to decide DMA
> > > coherency and indirectly the underlying I/O page table format.
> > > If yes, then I don't see a reason why such decision should not be
> > > given to userspace for passthrough case.
> > 
> > The choice all comes down to if the other arches have cache
> > maintenance instructions in the VM that *don't work*
>
> Looks vfio always sets IOMMU_CACHE on all platforms as long as
> iommu supports it (true on all platforms except intel iommu which
> is dedicated for GPU):
> 
> vfio_iommu_type1_attach_group()
> {
> 	...
> 	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> 		domain->prot |= IOMMU_CACHE;
> 	...
> }
> 
> Should above be set according to whether a device is coherent?

For IOMMU_CACHE there are two questions related to the overloaded
meaning:

 - Should VFIO ask the IOMMU to use non-coherent DMA (ARM meaning)
   This depends on how the VFIO user expects to operate the DMA.
   If the VFIO user can issue cache maintenance ops then IOMMU_CACHE
   should be controlled by the user. I have no idea what platforms
   support user space cache maintenance ops.

 - Should VFIO ask the IOMMU to suppress no-snoop (Intel meaning)
   This depends if the VFIO user has access to wbinvd or not.

   wbinvd is a privileged instruction so normally userspace will not
   be able to access it.

   Per Paolo recommendation there should be a uAPI someplace that
   allows userspace to issue wbinvd - basically the suppress no-snoop
   is also user controllable.

The two things are very similar and ultimately are a choice userspace
should be making.

From something like a qemu perspective things are more murkey - eg on
ARM qemu needs to co-ordinate with the guest. Whatever IOMMU_CACHE
mode VFIO is using must match the device coherent flag in the Linux
guest. I'm guessing all Linux guest VMs only use coherent DMA for all
devices today. I don't know if the cache maintaince ops are even
permitted in an ARM VM.

Jason
