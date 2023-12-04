Return-Path: <kvm+bounces-3391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD2A803B8E
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D12F01C20A8C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 17:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560CF2E843;
	Mon,  4 Dec 2023 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YwVTfPu7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2056.outbound.protection.outlook.com [40.107.212.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3633DC0;
	Mon,  4 Dec 2023 09:30:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Db2qQJPF9rZqemYT464A/fOdU028w9fdikXFomhmgirdr60gmgS1ZjF6A89am1OJh5rEhxzUUBK8ydL6SrYnw7a5btYXZ95gvUUdUqhjF2E2J29cbxFbbm4qp52nYxDn4NRMhoFVx9yuop7aFILTCYrr3nnSwq5cdWH+E2Y8XCMuZ5Ti/mNJjCDf+IEV/ApuJEwpI2cA05N6C9CEwYMY3uHkaKXb80Oals4hWiJrgyXcMe1fUKq5OGmw6VI3DMsxOk2V2mljfjVvNOIFuYEDTNrd5RNLZ50mPrZRRfCYF17+NPc/r5vt+AxyUpZSW+sHlk55Z8h8ebinbJzeMc5RxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VAT1mPhTSEAPwE1fvGIjV6jQxeJGVrGepcj52ejD5w=;
 b=mbmYx1eH9GIEoKQDXB1IIlXziL3hcHi2oz+8MLWH4n9IN5nrRQcsj8kNRk6TMnQev8DoDjTm4P5n0gG63Y6WKnKMgiAgPytIb7JmlxyDsz3DwYOr7SigfRHQymTDe5T4Rb4ueujqy0AKbATKUuC5Ncy70u+pQ+YHcMhM/bR4SHW31avT158Dp+0RIvq3NooBzFxM5JCcMYoQu37B/V4t8pxPvwTRefPXsHr11N3si7n6VIQPNG7iS4om9K6TD2qPynnHFL2YEN7VHWSQRM3AVL4l6tXDBatUPkJPCMu6lQjIZtKLqBKNEz9w2WVSNZ2NdDzUDuP1Fm0hpQiFo4lQ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VAT1mPhTSEAPwE1fvGIjV6jQxeJGVrGepcj52ejD5w=;
 b=YwVTfPu7CSuS94Fe80UXgOkPsDknigxPQLuk4s1y5apUvax4D7kpQFXJ95z6NtAciUsKk4VWGB3kjDqHsrc4noWDeXM/Sx5ODXn5DcElESWsKqLsr9vvtmdpRnOWABLixMLlfAgKXKfovVvvrEAd0vCpVThZOY5UqYFsiHvU79fAcdHV7J6XDb/MLRiOvA6fXH0uUIMAHwoooWFiGbvSgKVeIm4E40b/H76WWMXy2ay91usOc0HY1E5Ra+piSjsA5odQeqzwldOFHYCkYPiCn+CxxsD9DoM2b+N0H9CC00+1QNfc3L2KfpD6YkY1pOadC9ZQbnqHEYtCJQybVSeVng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7801.namprd12.prod.outlook.com (2603:10b6:8:140::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 17:30:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 17:30:29 +0000
Date: Mon, 4 Dec 2023 13:30:28 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com, pbonzini@redhat.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Message-ID: <20231204173028.GJ1493156@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <ZW4Fx2U80L1PJKlh@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW4Fx2U80L1PJKlh@google.com>
X-ClientProxiedBy: BLAPR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:32b::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7801:EE_
X-MS-Office365-Filtering-Correlation-Id: ef126a39-f212-4e8b-eb6e-08dbf4eeb573
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kEyTG2DG6OUQ6eJ/8vepvgtrXblJ+uxZ0yURjWJB5CXh6OBnLdZgk6NmCW9pc3jlCtFDo1nrbfSFCSkybZgYWjxzEAFkWwbfL17SwL3xjY53Mu2izwS2fgRAUoBIW3IWdthGO+kiI4OUJ4H/oCZemR/WVibtkWCNhqrMenuImw/GO1Ywfp1RcgWTvOWBKYpc910yIEbthGDVdAvis+iLnLxaHM15maP1fmutWACA3QGSj4Ppcc+6hMxocW84D1mm9J1RyO+JOICkOXHo2kr6k4VOY5Xalea3TS357GPDm0nxIv7YcSPOIkup57cSh5fggmgM+gEjcfaIbQGbUy6b4xs3cI3oDAragDa+bmdfuKxy+e0QMwBWwPpL9aMFQGic4LSphybKhkIgO0ItNKziznW5+57//Qkcj3JpHHew5262nb29NQ1g7K7Ki9Nt0tqch1JTESGz5xJp3iecMDqyZm5l8IAggSIbC9OiZ4xweeWtWdeI/nB7Wn3cyoXk/lN6Rm4ejyKlaXmqCEaBiyhjXsMoJUpwaoiDolMKrBsEuMGQBqp2NGTkftiooVXBXGH4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(39860400002)(396003)(376002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(66556008)(66476007)(66946007)(316002)(6916009)(478600001)(6486002)(38100700002)(7416002)(5660300002)(36756003)(41300700001)(2906002)(33656002)(86362001)(4326008)(8676002)(8936002)(1076003)(2616005)(83380400001)(26005)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4mtBC+LyVR3NsbGHNuJRz6AEMrAEPgkSfbSdDs0G0VK2wIC4j52vVTMwIxqM?=
 =?us-ascii?Q?QI5Vml2VkgXK/VYQTXZWIsy2qy4KNpr9FMPVcxHZny0lRlirR3oB+4bnwLw6?=
 =?us-ascii?Q?tvVorqNiMvOY/U/Og0I8MMj3kZPCG5sej+mlCRk5Vdd+9VjK/HlCQnW52UGn?=
 =?us-ascii?Q?UQ1k8kiq6TfBWrwHOFaggxb7y2N8mt8jZ6e4QZfyHg/XjE1cvR2YhEQYHHUd?=
 =?us-ascii?Q?tLaWKmGilbO2QSswDypfRz4FeETqwrS2C2IGiYfEZcBhu2hONiJF08XeIc+H?=
 =?us-ascii?Q?J7/qgM2saGkOV+PIshthKuC0hNdiSUTGUYzOC0GxRAg3ybq9FK+vXWo00o0J?=
 =?us-ascii?Q?/HTt0bt4uKr1UKTk8qy0vx9dkaH0xikak4UvaROvldJ6ZlXG02J1Xm4oButk?=
 =?us-ascii?Q?EN2P2E/npst9EwHQ2wB5kmbhvYa1cPBixXetDYrxmTMTxHYd/w7n/KRi+zoy?=
 =?us-ascii?Q?2cXDqex2+Cln2bAGYpKs1o2Tk1zhxodSNArUzDfnxye+6gmcJ12aAPABGR1e?=
 =?us-ascii?Q?8JyVeU2Dsxa9JVJ/l48Sug85TG6WAHc2MtG1tYnBYhV6F0EjFCKc9sfxnb5X?=
 =?us-ascii?Q?8qYvkBcTepnEwa/TEZK2WeRg6Y88lujRhVYt6mBn4I4ZNdZdET/SnzPDwUDk?=
 =?us-ascii?Q?mexCnw2uVpVVPz12MF8w2Xbv+JHm+8/ku6+j3eLBXRm2Fr8/pNpiCcqHvQiQ?=
 =?us-ascii?Q?nyPqIcabU6GIjQw2GIUllUOKMbhcKS8FZWRHJ+uyugeRT+PbJNf7nSNyawoZ?=
 =?us-ascii?Q?R+dsJeNbOVW5KgFVJaaPgcj8cNd9UOiuTHBbe3ZkgwlxDDT/bggt4lHZ+IFY?=
 =?us-ascii?Q?XiYqLTlLSAYEyfObTyhGc5qKsFRTMRwS5w+eElkOSaloSWOeJDhNy+5shO0z?=
 =?us-ascii?Q?+iM1X6iMJT5U48tAiuyAu6cvBosrols8LgsxVxTdrZWJy2SwJfPKJcuWbs0W?=
 =?us-ascii?Q?iVV7zXIlShh8AC6tjJd37TST6r0hY1cYcSehS/gm7Zr7f9TSSGogvy922GXk?=
 =?us-ascii?Q?hkq1YdeCC9cHdXnnf8vWfmbmwo9mLY7NzR8rW0nVsGE9uQmukmeL19REneXA?=
 =?us-ascii?Q?zHzx2gtpQ05hIjtm/h0GktUCeQ5C0mU9029p7cGkDDyUXbsVJgEkP1B52rmp?=
 =?us-ascii?Q?JvWSpaA/6lrSHnv3omuy0MJs0MWlYHeCJq+GN7lbWxiPw4rtLVD46fbh0xiq?=
 =?us-ascii?Q?RYzPidH8RT7K3h3mwqLthI6680ltQfhpFAJoGgg75b+uwoB09Bi7zH3wIVtb?=
 =?us-ascii?Q?HJzxnjJo2fhv0JNgdb6EwSua3jbPwqjNlMEVarb7WAIp/QqDfvLpyuWt6knz?=
 =?us-ascii?Q?rEzB5kYItErRh6yxC9VWcbU/vjNFi6+KW8NZCVI+WtDWY3FRCMAHUN38d41e?=
 =?us-ascii?Q?HtfxEKRDgFjRTTqvwQLGZlT5FmAarYLKYleJt734Q3ov6ld3wrhFjMKSHxdg?=
 =?us-ascii?Q?CDjHguHTXnh1Z4P32XyfREqWGIi3ATuPhGkdLZwxTVmb1GNaLBFK+raWyy3L?=
 =?us-ascii?Q?aAgLMQ9tfSz5JIXZYNjF0vQEmjOeZ7e9bVEGGZMnBs+D/KsrJyhfnsA06WIx?=
 =?us-ascii?Q?aScHO8Wqi/tW1XwLCEplaz6zJn8QlazWQYjjT9NX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef126a39-f212-4e8b-eb6e-08dbf4eeb573
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 17:30:28.8949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Il8tgf+oO+OsXttnjHkN8e4mSLdxGk8cRVmDy/z1iJinSy6RJJ8vEL9WGky9WANZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7801

On Mon, Dec 04, 2023 at 09:00:55AM -0800, Sean Christopherson wrote:

> There are more approaches beyond having IOMMUFD and KVM be
> completely separate entities.  E.g. extract the bulk of KVM's "TDP
> MMU" implementation to common code so that IOMMUFD doesn't need to
> reinvent the wheel.

We've pretty much done this already, it is called "hmm" and it is what
the IO world uses. Merging/splitting huge page is just something that
needs some coding in the page table code, that people want for other
reasons anyhow.

> - Subjects IOMMUFD to all of KVM's historical baggage, e.g. the memslot deletion
>   mess, the truly nasty MTRR emulation (which I still hope to delete), the NX
>   hugepage mitigation, etc.

Does it? I think that just remains isolated in kvm. The output from
KVM is only a radix table top pointer, it is up to KVM how to manage
it still.

> I'm not convinced that memory consumption is all that interesting.  If a VM is
> mapping the majority of memory into a device, then odds are good that the guest
> is backed with at least 2MiB page, if not 1GiB pages, at which point the memory
> overhead for pages tables is quite small, especially relative to the total amount
> of memory overheads for such systems.

AFAIK the main argument is performance. It is similar to why we want
to do IOMMU SVA with MM page table sharing.

If IOMMU mirrors/shadows/copies a page table using something like HMM
techniques then the invalidations will mark ranges of IOVA as
non-present and faults will occur to trigger hmm_range_fault to do the
shadowing.

This means that pretty much all IO will always encounter a non-present
fault, certainly at the start and maybe worse while ongoing.

On the other hand, if we share the exact page table then natural CPU
touches will usually make the page present before an IO happens in
almost all cases and we don't have to take the horribly expensive IO
page fault at all.

We were not able to make bi-dir notifiers with with the CPU mm, I'm
not sure that is "relatively easy" :(

Jason

