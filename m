Return-Path: <kvm+bounces-3885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 869808096C3
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 00:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A29901C20C84
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 23:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105F357339;
	Thu,  7 Dec 2023 23:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CaNz3L0+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974A210FC;
	Thu,  7 Dec 2023 15:48:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dc8+ZOmphu9wX8cISInbdzDONFFa4VOlMFafgC5ADig5F0VJhcYZtrO9EG0yGp4T7+UxLkE0g3jMJY9l+N3mGFcI7x3BU+2hCLaUGLDosR6WQ1GirXOl9gJ+iUWvOcznj+aZR7lt9hN0nkvXm+sJJMLWNEpJwHlfQWLtuT1xshBo7dem5EYBHVNllZ6YNvqUYajg81ZjfPCdC3zzlt41sTBbsU64y4KW0gQ8NAebzeeWk69/RHSl8A0uNBODfUU4v9O2nIly4vF8xAcrLLl1K2z6QS377mXRQChMvACiyMq0dv15Ob+hfzsfjve7ozOpb6BlwvtiImi5CenWElAuYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCvI73BQzhrqcU7Wj9PIZ9086f45EEqPxmldebc3fOY=;
 b=TTpt80d6WUNPqKzVQ9IrpYVgMlcrFO/XGrtQchOTcEAoyafG2++PXar3fWjpA03m5EPxepDGvlSs0sG5FBnNiv5bm6/1EvbOPrxw5zO7REfdi8Y6TdtX+Tm18nOCVMipTzVa24XhVhmxCWOxTvX5R67Vic7MR7uQdMmIUD3QgRKtmxNbJ/ez0oj0AWOGg7w3ViAKv3T0p1uHXHH9cY6SB8OzedBhGFSxEIzkOiz1V5RplvWZJ450xP3koJPgR0NK6b2BmeNFwpUzdIds9Scpz3mHHeflz9JDIzY7mSUViz8u2tVItIS2PU64Q2yue6oiDeOk1krqf8eI0XVNFQ/kNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCvI73BQzhrqcU7Wj9PIZ9086f45EEqPxmldebc3fOY=;
 b=CaNz3L0+hixwoIbBFvgDAdhkcEKMw1j8DyJC3MztF/LeRY1Ti4arQFSRP4fp+K1SMxdyexYlj22PMf6UogzJvg2AQrUvSUDGOrhGgxEmxEsfcibDTQ+MDdXNBJHXUsHC+FAPadF7h11C8MMmCUKBFQNlBTb6CCgXjhoDNkdf8NzNV6drPMsHB28FVBY2lHqpeSjQxF2alwqShNhuKf84+W9rTNTPnDF1XchxBe6LufN65fiB5WfIP1TRsb7gQ3TEjk0+NfbBQMLNE+AvoTS8JCeaqXM3DipV6J2xGMHa0QFVi/VXfkV35GdLdrtkAlPyjLiGJ/gjxmqsOQA0voeH6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV3PR12MB9214.namprd12.prod.outlook.com (2603:10b6:408:1a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Thu, 7 Dec
 2023 23:48:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.038; Thu, 7 Dec 2023
 23:48:11 +0000
Date: Thu, 7 Dec 2023 19:48:10 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jim Harris <jim.harris@samsung.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Message-ID: <20231207234810.GN2692119@nvidia.com>
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
 <ZXJI5+f8bUelVXqu@ubuntu>
 <20231207162148.2631fa58.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207162148.2631fa58.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0027.prod.exchangelabs.com
 (2603:10b6:207:18::40) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV3PR12MB9214:EE_
X-MS-Office365-Filtering-Correlation-Id: dd167181-f57a-420d-1c0d-08dbf77ef8fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FVPKmhSIGHiYTwg+O+LFpUc5lv5M0BoHJGP0jyOfptCkzE6oUCLJ1Qmp8IqOaIdtGajBChzY+yqirRsM1QBmiGhjlXtW0WJ9Uc61F2lCDFvDNlWkJ7DaZKJpMXLv0cG2fybJqPuzwGTRqp5Hv6lHJKZRjY0rmxuvX+zeN6cDGvn5OJznv1F/rv3WKWNr4c4/P3SLu0VoJIov3vYQvVqjPe4zc4cx7qxajY3P+i1MKsuF/yP3Vvv/56yhLncGCWyGVzAQPEofcWfTap0FIVjxeDunSBh6DtyKUwqi2+R+mi+zDLVkKUpn2wisp9b4WaJ0hjrh4mp0/DTnoAjd9NplRxzQ2jui8+PAFZ2VwpUkAy15LNO0UroG1pLnhP+2ddxggY0UxxIBkUm/jpaj4dI5K4utv9RgaHi5ulbjuIm9RcyA1g/NsmcgsCiUTGqvo8lLCJTBM76q53dySrCbOFk07UAmiRMbtmh2T3COsxdi+z+KOyHJI+vXrEAIsvWrWDu5BoFhp8Hz6EYk0A+JQf/iL7VhFYn9SWK8f3aluQpcTUjUSjj+dw1a6UhDLCg4zEpHhrNTVa8mXrBUggEB/r9FMr7n6tto1w7XduI472Kxesw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(396003)(366004)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(83380400001)(41300700001)(36756003)(26005)(86362001)(316002)(8676002)(4326008)(54906003)(8936002)(6486002)(6916009)(66946007)(66556008)(66476007)(33656002)(478600001)(107886003)(1076003)(6512007)(2906002)(5660300002)(2616005)(966005)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kqk9SIzbBfThcunazmMOP7GbLpiBWOndy4jtem/PBd+b06eMfW3w0uPJcBBq?=
 =?us-ascii?Q?bGjI3df5Zi40+tXox/sUaXIDkyyO6uo4dK3mx5D6cdVhG5O8c0Wzi6o5xi2n?=
 =?us-ascii?Q?2rD5xgppH66sLAWln9/ydwb4PNOOWyqBRvkIKfaU1t28Ds3zP7fXch6i7C8b?=
 =?us-ascii?Q?8DRFPdo5J//HML3Urep0CcmFlUqF0D4edbb04X8uGQOOOVzmNomq/IG1f333?=
 =?us-ascii?Q?RvOuSh7w1UJpTcl8bHuS3Ou3IEb0XBOpN3dZ6IbGeTCZRXagrB23O2Ew9puG?=
 =?us-ascii?Q?PR+vuJiFzkunnz9QWbOd/9UvjmxkUKDpxjpCkZFycwyDZ4EausLXNpRJIO3G?=
 =?us-ascii?Q?7CldyuLtkfkmhdoPV2TcjSaq3LClCstXlg42VX0WTZ4p23HyojieS1rx9z8S?=
 =?us-ascii?Q?3yhdFdS3kDxZX3r/o16Ie5tm80HQbapWsJ8Ho/xpVTG8Vpzdb31cybG71yiq?=
 =?us-ascii?Q?3U1bfF59wvdGdKDhg4RpQ3bkA7A5SeexRS/PXgDOB+boI0GUaKFZnihjz7hD?=
 =?us-ascii?Q?r9X2Oy6PxyKBz9fXLQQsBJJwh/wbcGUEKE4Y5uYIW2vqxtkWDF40tFiXpE2f?=
 =?us-ascii?Q?zmzAIhh1anLBZz0PbpstbyHW1cuM72TeDWmeNf8tjwC+R1X54X4AOmQ4L1v6?=
 =?us-ascii?Q?n69KvqWXlZq8qPGfafYsQZBQzxWCs+cQnowmM9hhcRtCsnUoZPjZnSQdkD2y?=
 =?us-ascii?Q?LOZ9TUcH0cFLPypKW+aQ4RS2nzLem9pejkliNjSYiCcC4LEBF04QGCipzKvX?=
 =?us-ascii?Q?3TWK3qFdXA6rG+WMKgnoHhYetHV/WTFWzCttUX9nULKAYWKUiR8uKAGFYlmn?=
 =?us-ascii?Q?o4SyMfVHZw6j3WoMrCj+LiSX2d4tvpM/Laqs3+nvuolLtngpfAISx/HM+55r?=
 =?us-ascii?Q?YOGc9xtUm4gM90sMhx+kfojJN2Ac97+dgkSA5E+UNSnxtSrj1E5n4RjV3t74?=
 =?us-ascii?Q?1Ew4ZKBSeCn2WSMC1jZWcDMD40fcr6Ot91YVTeiQlQWIdl3uDzwOz7iEX1dT?=
 =?us-ascii?Q?R/KlkFoDIg8yXaHBSYx3Az7pZFeohtfVSPWu+4X0may+WPG4NclVEMQtboxf?=
 =?us-ascii?Q?s/4WSoSvQYO9F7yMF+0W2pdbWuT6rttpByzcARUfCwe7LT+bLFG/kQBUpcBM?=
 =?us-ascii?Q?Jf1Na9Geuq9ELCwY7Jh9it7a1NRRMXGd2SCIaF0iAS0uLI/uaYX0jelg6DXx?=
 =?us-ascii?Q?az73AeFt4dcWocBb/qxsgrF85UIiykFr8rieCIAueFC5pah3+67Uanh9tpEe?=
 =?us-ascii?Q?MGmgOmRtuiTOBBQIPh7sOkGhFfu6Ht/kkEdPSksH5F+nFu9nSwI3BolW1CKb?=
 =?us-ascii?Q?rpyTan1VKJ09Zc1TL4IA5ST+rPz5HPVfj4rQ7gOhrLUyQk7YQXZC48XwpaxA?=
 =?us-ascii?Q?feXx40zAhtXjjqk6XfhT5zSEmaoXn8avBS09eZ9l8aTzmbAEgWI1cVdzkBms?=
 =?us-ascii?Q?7i1I6Hso4h1v/h+cJLPxdgBOZq1+KAAuVqsecMRyDVZVJnTvtjzPJMreJKDn?=
 =?us-ascii?Q?WWukmcxBzcdNGkctKdTPXRmnbpNALUJumTyIbFKMyW+jfdDR8lAbDEfgTT2K?=
 =?us-ascii?Q?C81Rvk4wJzO6oyysRUABZTky/7BH6ERnJCbinLv2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd167181-f57a-420d-1c0d-08dbf77ef8fc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 23:48:11.9324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lJjrGAHxouTgdZXue/Orph6fV9W4xQMUiBw4QV7vmkLVSOX1NP6Lgcm1hHwZv9yb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9214

On Thu, Dec 07, 2023 at 04:21:48PM -0700, Alex Williamson wrote:
> On Thu, 7 Dec 2023 22:38:23 +0000
> Jim Harris <jim.harris@samsung.com> wrote:
> 
> > I am seeing a deadlock using SPDK with hotplug detection using vfio-pci
> > and an SR-IOV enabled NVMe SSD. It is not clear if this deadlock is intended
> > or if it's a kernel bug.
> > 
> > Note: SPDK uses DPDK's PCI device enumeration framework, so I'll reference
> > both SPDK and DPDK in this description.
> > 
> > DPDK registers an eventfd with vfio for hotplug notifications. If the associated
> > device is removed (i.e. write 1 to its pci sysfs remove entry), vfio
> > writes to the eventfd, requesting DPDK to release the device. It does this
> > while holding the device_lock(), and then waits for completion.
> > 
> > DPDK gets the notification, and passes it up to SPDK. SPDK does not release
> > the device immediately. It has some asynchronous operations that need to be
> > performed first, so it will release the device a bit later.
> > 
> > But before the device is released, SPDK also triggers DPDK to do a sysfs scan
> > looking for newly inserted devices. Note that the removed device is not
> > completely removed yet from kernel PCI perspective - all of its sysfs entries
> > are still available, including sriov_numvfs.
> > 
> > DPDK explicitly reads sriov_numvfs to see if the device is SR-IOV capable.
> > SPDK itself doesn't actually use this value, but it is part of the scan
> > triggered by SPDK and directly leads to the deadlock. sriov_numvfs_show()
> > deadlocks because it tries to hold device_lock() while reading the pci
> > device's pdev->sriov->num_VFs.
> > 
> > We're able to workaround this in SPDK by deferring the sysfs scan if
> > a device removal is in process. And maybe that is what we are supposed to
> > be doing, to avoid this deadlock?
> > 
> > Reference to SPDK issue, for some more details (plus simple repro stpes for
> > anyone already familiar with SPDK): https://github.com/spdk/spdk/issues/3205
> 
> device_lock() has been a recurring problem.  We don't have a lot of
> leeway in how we support the driver remove callback, the device needs
> to be released.  We can't return -EBUSY and I don't think we can drop
> the mutex while we're waiting on userspace.

The mechanism of waiting in remove for userspace is inherently flawed,
it can never work fully correctly. :( I've hit this many times.

Upon remove VFIO should immediately remove itself and leave behind a
non-functional file descriptor. Userspace should catch up eventually
and see it is toast.

The kernel locking model just cannot support userspace delaying this
process.

Jason

