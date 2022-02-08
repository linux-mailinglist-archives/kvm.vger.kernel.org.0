Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4263A4AE180
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 19:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385415AbiBHSvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 13:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385388AbiBHSvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 13:51:45 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F14C0612C1;
        Tue,  8 Feb 2022 10:51:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGXNzfN/NTiWmxzB4Fe+8M+hDW9QjH+Pk0z+mIRNLLVFTzFPxI+usVdD9rQoFWQnEBAvxKwwmSzRSM9zQB8RKWI+UI4grCMr+GGtXGBL+JzkMSOXTSbaBo6/o1z5Lijnkna/YUg0T7anhraQz2U6aIw03fsKqWILmV1U3uz49BqHI3iX8rNYHsxP/4Kxx1MRA6Fto7YoRSucPCedcZnlO274RUCtTg/c0sKR514qr8PnqyU0rJ08f9Aw+q+F0j+M9ccOdR0CxiL3OOvfLBHwZN5Bh3EI1YW+zNY5AKXOy7GDyya9W2UzcG/GSPpG6GvqzwEYzP2UfyoGCFW+dZzQQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qt6VL/53xRCwC+Ij0Phq1k8ruOTxcZn6SGaeWuGkmV0=;
 b=leaAzgOS5ds3y/rFlTtrQ+R8wFxiUW2Kh3+SO9t8r19Tyi9Jp2L7s0nU43yq/6bg/AoRLIOIKg/i/BKCjV0excbZtaUQRIuxTQCSBl+WvJX2VxJnsYZdJxgZ22Rc7L3GMpbpZwaMCshXiDLTHK35xvdh+tHtgRq0NmDGmNxCq/qz5OrpdI4Ds3tSCPZiGUZgqOkf5/0UJHLsLRVNhEymXx8eAM33R7gIJ680VZFobX8HqJDuUN6SMgi56BPWo6VxtuozYsT1KXHbRVeKVFKoZ5KCjmOAh0kKPjak+pK7t2uPmIO6+2rI+aNLktdJ9a2NRyK6p/ezWW2VcR266nHoZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qt6VL/53xRCwC+Ij0Phq1k8ruOTxcZn6SGaeWuGkmV0=;
 b=HW694PkckygpSGOmnYuWnBg/Bib51mPTRbJYwV6Ulnobiz/m95Re8z1UW91Snohe5hbRjjZ4FaOEPStXm9AX6GYOfzA5JBIfWb2c0YZMAfOqdPw8JJ6UPX4W7QB+JtKw/gzS/Q+Vv44lsXRYd+Q8dBkQ/fupv2yyaWAXgzEO79zZRhuNg7FCPFr1MOpvCtMpeYaT9QVdXlFD0tjU4drJ4QGiaT2XLesXPoUbEmgdupFbjIPXAWTNqyHy9myjNb8/minuEJdNir4lgdpnqwvQShitdGQQVqtFZF4+SmGXnxPs6FT1nO/uPkEXuXwrCEN19Rk0+Z3PPUcZcPPGrTNRiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 18:51:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 18:51:43 +0000
Date:   Tue, 8 Feb 2022 14:51:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Message-ID: <20220208185141.GH4160@nvidia.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-25-mjrosato@linux.ibm.com>
 <20220208104319.4861fb22.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208104319.4861fb22.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR10CA0018.namprd10.prod.outlook.com
 (2603:10b6:208:120::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d814342-e9b8-4685-c692-08d9eb340c4a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB449540EAE3CE62DE2C9BE027C22D9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ibOuPte++CMaSGBb9aCbpQU1H/ojJKMV+0QmeBlfMomWXZRNvg+Odml7T3S8+mZCyZmM85oFmucXjiD+g5+ufgHo26auzOGiLww93T0API6NUKl68xqyD7QpgBziahysQg125U+0CIErwD6WwVkO9YO5/DvDnYza5UDnqXmDZeRCGuehaS1W9SPyJcxY5JVasAXuLSEkkJUxTrp+xq9bohHLADgPTrMDhd5w2+GQXGOkGimxstIjsjIJTitUUsFKFTQhCwV2xH1GpU7IzHbRDqP/BoqZKSUNuv86sLEg1nIIyTVhTSw3vJ/MYtM2CTyQ7SVDiL6HYFPm4AhumEi2syC4c9BQcpGiWHdSWcTJAWHq4KcPYNwiTLGgkE0PqChBH9Op81J4cJ5U+0VzFnTO7i3knsJcWd2dfB/NJRM7YpMKmOdTbRoEtFo2RpAKl1aesZu4b8AGimdXzbNhl1Tx7eNxCl51KQk3+ylylQ3vv4htaxpXktJMY29oO3MKA+0G2nAmGLR/e/HSPnm0WVXOckD8kjjTED84B2DX967SqPjWY+dMrYPMKejBKFacj9+AjZGAex1RoVBr7zVHtgMbJJq69cfMGZTisKfSAtOOVGarUOcs6aHVsXSi9OdlxUjnb4EYAs3tyvWZN7ntsoxxaSIpX1YBdCvvte+D7IaovYRDpkqzRJdz6WS8m1gXJpjGWUXFv+4UDN2UPoUWtx8HK+AhMvShLLJyQfl6r9NE4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(26005)(6486002)(966005)(508600001)(6512007)(2616005)(83380400001)(7416002)(5660300002)(36756003)(33656002)(6916009)(66476007)(66946007)(6506007)(66556008)(86362001)(2906002)(8676002)(4326008)(8936002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y/XwfOuGXHPhbHmsEiRvwaazJ6UbxMYsqRMusDgJC6kJ0yfR7cnau5AUYF5X?=
 =?us-ascii?Q?SdgmY0f5CslqRhrem8sEmbieuMRxNAi1UT4CVe5dKkCbKYf04npnJ5Eeyl/A?=
 =?us-ascii?Q?nq3tv7h8vNpmuVgqqGq8Zq1oSsjL4YhDj6E615mpCDZRwxpRCAFTHPoEU0Fu?=
 =?us-ascii?Q?Dfet3w1i5L+qgmgMvmueMXTQu5s16xKIazP2J8RyYF5b7E94bykdxCt2m1z2?=
 =?us-ascii?Q?aRNWSkOSs43Yq6M+3cxsO+Tl5W8JTx9/OYUMIYc45Vm+9VHGiPiaj8LNBDlI?=
 =?us-ascii?Q?8qqAoqZFxt+XevbMV/dD16ljcUB23AHs7ZWnhmLo/UBjrKzKV/9luFuTpcY+?=
 =?us-ascii?Q?rvIo+Tu+ivvlYNsppxtvGJfFcrFsTy2O3gzTEAlhuQZ+wgF1UDIzQc+hXeJ1?=
 =?us-ascii?Q?QBB0WqAFHakUlunpycfBXhKL7J3RU36m1JpOEr4ENYSl1UvK4pQCi1K7oBIB?=
 =?us-ascii?Q?FLu21OOOSvRRHTEr10UZLLBPBKmrWI3zOrExWUQXuju4HqLrIU3OjYKOAilO?=
 =?us-ascii?Q?greoI9gAzKpIq4Qijz/5je8pr7EJ0qeX21/z7gV5U+8LSgDUEw98u6LtCZV1?=
 =?us-ascii?Q?bpvgylLu07TnzgW5MZlnTAir2qiyfGqyV43eQMXNC1RsPUeP8W5Hm4JaPKUZ?=
 =?us-ascii?Q?z4zio0HfOdTDaZwXFr1lD/07cBL+GsB5L5kfs0tjvjIbYeBoY3cyM6/cbUaN?=
 =?us-ascii?Q?qZ4xMsXGShtfxEAzqm3hVEAYd6ROTjZXaSJq5SmCmg/r0WX8ojYrOvMIcM+p?=
 =?us-ascii?Q?j5LTFQANOyAsf38luzowAjFAPgzc2cucbKKqej4c0iKQd9tEaTjhiZjtQTPu?=
 =?us-ascii?Q?X8Mk7w876AuZ7rh7JRNOuRw+EI+W/BtGqg2MiFN2Tmp4WloG9pha9KhxZBbk?=
 =?us-ascii?Q?Y0f6eI8KRNlVjLT1Sy2jquzmSCJfSO65GQZPEwF/a3XefevUZ+qHLEq1vONZ?=
 =?us-ascii?Q?HbyEdXT9Lg/CP90qb3RdPetIPKF0KJmUrbm5jeX8XUKkzOXm3ufA7qKk8EDo?=
 =?us-ascii?Q?QV+KnQQK8rDq/qRUPDmOyQTrTPhjCJBgC1q70JgviAbn43vh8YeCDByp1+mp?=
 =?us-ascii?Q?SoGKITcOBg4eklLdjzb3Qu8kYPMxd/fkLDL9qyrE+vkdg9ecvc8JLnP/h+t/?=
 =?us-ascii?Q?RheXKwipLBi4daoNJYL/DRegx1kDA3+D34207Vza5sqW2/rvUK4HdhdOqIOc?=
 =?us-ascii?Q?7MOsFRJCdyXolyDGrQtyxLcHV440jK9XK1Tuz92Q8pKgq/dQz45kbGJ9HVDN?=
 =?us-ascii?Q?fI0WCwJH5dY5EHHQFptFFc4Nd7NDhshVfsyeUlNmgBwlj7f9wXXBOedehubf?=
 =?us-ascii?Q?5kWw5ohYXHxbhSTsQ2igkl3VzPphxHhAv9RhTHVzpyCgf2CfPoTYPDTFOF3r?=
 =?us-ascii?Q?TEP0Lj/RB4WXeVklpEwk2HIVF1OGJ9cdGn65fnSxR4Wjmz4juryydCiOl6ks?=
 =?us-ascii?Q?y9F/tFBg9effcHaoZxTSCq+gppXfYCgT32tE0DFrPPaCIOrn0esuwIYRHcEF?=
 =?us-ascii?Q?ofeB8SaVN+fjvI/YKdMch7RZ7zyf5hbNY2CIdlUBsuqS47m8Ptcr27XklEGV?=
 =?us-ascii?Q?92dOrr5VCDmKzmWYUaM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d814342-e9b8-4685-c692-08d9eb340c4a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 18:51:42.8876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RcYLXCpTU3DqEpdPpzS9j8kcyJ+3tT6JzuzEbDwWxcNH+iJcEj9cxZtAshCmQNFF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 10:43:19AM -0700, Alex Williamson wrote:
> On Fri,  4 Feb 2022 16:15:30 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
> > KVM zPCI passthrough device logic will need a reference to the associated
> > kvm guest that has access to the device.  Let's register a group notifier
> > for VFIO_GROUP_NOTIFY_SET_KVM to catch this information in order to create
> > an association between a kvm guest and the host zdev.
> > 
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >  arch/s390/include/asm/kvm_pci.h  |  2 ++
> >  drivers/vfio/pci/vfio_pci_core.c |  2 ++
> >  drivers/vfio/pci/vfio_pci_zdev.c | 46 ++++++++++++++++++++++++++++++++
> >  include/linux/vfio_pci_core.h    | 10 +++++++
> >  4 files changed, 60 insertions(+)
> > 
> > diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> > index e4696f5592e1..16290b4cf2a6 100644
> > +++ b/arch/s390/include/asm/kvm_pci.h
> > @@ -16,6 +16,7 @@
> >  #include <linux/kvm.h>
> >  #include <linux/pci.h>
> >  #include <linux/mutex.h>
> > +#include <linux/notifier.h>
> >  #include <asm/pci_insn.h>
> >  #include <asm/pci_dma.h>
> >  
> > @@ -32,6 +33,7 @@ struct kvm_zdev {
> >  	u64 rpcit_count;
> >  	struct kvm_zdev_ioat ioat;
> >  	struct zpci_fib fib;
> > +	struct notifier_block nb;
> >  };
> >  
> >  int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index f948e6cd2993..fc57d4d0abbe 100644
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -452,6 +452,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
> >  
> >  	vfio_pci_vf_token_user_add(vdev, -1);
> >  	vfio_spapr_pci_eeh_release(vdev->pdev);
> > +	vfio_pci_zdev_release(vdev);
> >  	vfio_pci_core_disable(vdev);
> >  
> >  	mutex_lock(&vdev->igate);
> > @@ -470,6 +471,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
> >  void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
> >  {
> >  	vfio_pci_probe_mmaps(vdev);
> > +	vfio_pci_zdev_open(vdev);
> >  	vfio_spapr_pci_eeh_open(vdev->pdev);
> >  	vfio_pci_vf_token_user_add(vdev, 1);
> >  }
> 
> If this handling were for a specific device, I think we'd be suggesting
> this is the point at which we cross over to a vendor variant making use
> of vfio-pci-core rather than hooking directly into the core code. 

Personally, I think it is wrong layering for VFIO to be aware of KVM
like this. This marks the first time that VFIO core code itself is
being made aware of the KVM linkage.

It copies the same kind of design the s390 specific mdev use of
putting VFIO in charge of KVM functionality. If we are doing this we
should just give up and admit that KVM is a first-class part of struct
vfio_device and get rid of the notifier stuff too, at least for s390.

Reading the patches and descriptions pretty much everything is boiling
down to 'use vfio to tell the kvm architecture code to do something' -
which I think needs to be handled through a KVM side ioctl.

Or, at the very least, everything needs to be described in some way
that makes it clear what is happening to userspace, without kvm,
through these ioctls.

This seems especially true now that it seems s390 PCI support is
almost truely functional, with actual new userspace instructions to
issue MMIO operations that work outside of KVM. 

I'm not sure how this all fits together, but I would expect an outcome
where DPDK could run on these new systems and not have to know
anything more about s390 beyond using the proper MMIO instructions via
some compilation time enablement.

(I've been reviewing s390 patches updating rdma for a parallel set of
stuff)

> this is meant to extend vfio-pci proper for the whole arch.  Is there a
> compromise in using #ifdefs in vfio_pci_ops to call into zpci specific
> code that implements these arch specific hooks and the core for
> everything else?  SPAPR code could probably converted similarly, it
> exists here for legacy reasons. [Cc Jason]

I'm not sure I get what you are suggesting? Where would these ifdefs
be?

> Also, please note the DEVICE_FEATURE generalizations in the latest
> series from NVIDIA for mlx5 migration support:
 
> https://lore.kernel.org/all/20220207172216.206415-8-yishaih@nvidia.com/

Yes, please don't implement a bunch of new FEATURE code without taking
the cleanup patches for feature support from that series too.

I can put them on a branch for you if you needed.

Jason
