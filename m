Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4755179BD
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 00:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387819AbiEBWKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 18:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387839AbiEBWIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 18:08:36 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EF8DEEA
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 15:04:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmaYNIJf4thmzR3QuSjfMmJRxIslF/3Pk2r7wXLmX2ikVlN5Pvsu15RCVIpJYAK9XjtU3TfzWqvkwQ0bfkXS/kl7GhLyp1PSkGv/GaAQRojMGxAwOD7JjKEuqzEOa87e6/GaWlh9Vw2hGW/eLMLeaR9xWHrkdBOWQnJbtlzjjUGkJQEZyjBmT+Oi2miLw8OWsXFAEgm4JNQkRBY/pL4BE2Pni0179mLnWaMLnq8f0l7NY72PJfYmwnHHvViybr4UL5RTWYOtj0TZdFK6nEfg4EFGbc3g3enL4/qQd44YTWtTcsuMWg04s/meISskhngjdQMgHqpw+3IzPz/rEMwyow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZJ3PQeqEegv28+kEX+mC5xphog5UUaHTbuSHZ2OjXE=;
 b=kTmEipK6UxGhXNs7I0+VnE94ueWK3+8ImVtKZ5Bh6HwFYIVN9zY424zYNTGeBNwnAoXqk4p8bDLodDeWT2W5TYgVykjWxP1JW9Or0ZbnVlcIOA+HElH/iMrQ0BpsLUwd/QTZiT5aHzQz/vGXMdkolHppApWFAFLABMjypo7YWZt4Qj8SG2Il0Oai3aZo1olTzsJcIERcYfqFmVKbBnz+S9bEk8SOOA7AWULXO5fFtJ+D9qAq3aHN/xTdMnr6aJWiXFL+HiiuTjZ4SsAsM77IySW4rKBIExtpcAn1kAxaLOe5xjgUVsWNMvChzr0zDncHKdeyLTgw+fuBa2CGOqgNMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZJ3PQeqEegv28+kEX+mC5xphog5UUaHTbuSHZ2OjXE=;
 b=RKL+qswL0zDrHQsJCcRijOwHxKhOzwi3Z4iOvpKbfQ2CwotPBe1iIgLQ/tyXrzhrRO5nc7gSrveBRzNCdB3lW2puui/mpsltq3k18bFNPUb+SicGaXR9Co3g9pwac6aELHXOL/dmvisjYTDzCR37NPx85ZP3FlEP7zfMSsOmGkTNLoRu3IFGxoORgStB9j5bWUcXFhojV49Hytf5Tkf6iKwTA78NShRffKDHxXodnjsEhlLH2FfQbRoDdd1bD+UKuq1tgCNOyv8puG2cgR/N/DE9sKEIefH5ttLIgLMUHMlsLjibzyBYVheU35kZ63/dUOtr97hxIAH2PY/W2d0xXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4278.namprd12.prod.outlook.com (2603:10b6:610:ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 2 May
 2022 22:04:48 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 22:04:48 +0000
Date:   Mon, 2 May 2022 19:04:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, cohuck@redhat.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        eric.auger@redhat.com
Subject: Re: [PATCH RFC] vfio: Introduce DMA logging uAPIs for VFIO device
Message-ID: <20220502220447.GT8364@nvidia.com>
References: <20220501123301.127279-1-yishaih@nvidia.com>
 <20220502130701.62e10b00.alex.williamson@redhat.com>
 <20220502192541.GS8364@nvidia.com>
 <20220502135837.49ad40aa.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502135837.49ad40aa.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0034.prod.exchangelabs.com
 (2603:10b6:207:18::47) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ec0307c-cdd1-4c00-971e-08da2c87c643
X-MS-TrafficTypeDiagnostic: CH2PR12MB4278:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB42784F480DA2548934CD9172C2C19@CH2PR12MB4278.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TMu7+wBIiAwC+HmROey4PErh11+JA7ntfx2F9TSbtg9muPgDLHkkI7MllB1sDDnD0cvO8xZ3bS6cyygJRr8MjhbNO3oJkU5z8gSr+8tz7zHWRWvAYbeWx9aHM8i0D1ZGjETwoPdZ5n4zntj0m4kv0hyUjTz2YWyPYcdtOwwoVN3rBE+nfWSNLAm7KNyQaeh4eXxFLMhSCfs9j9VAJFUoMnZ/W6X72EaxyFWU5iCLyOZWLVmc+ogpn1SK5qmdwrcenjLdFouddxn711vIG3I3OfKLY416oZLUV8KyTw7MXFF5ZKtWL/2gY56dvaabFXztgArqITbyRrEAizTH2H0X94HduwzttOBO54CPsqlG22HG1oIexmAbFANKzTyC+1jJ/VsrkTx2OIDuhZFQ2O25RNfWbCnPngg4JJx/dyxn1WywGNHQzhkshJVUBjLNtrxr+rxcXOeNo2Y0g+v0TBUNA/EYL3mYuPytynxvGX4sPn5j1fSD7snA933lCNOSFowHBQi1wLWcL1hCKcUGnzpvy/08MdoLK6CYWVCgItEuHY6/4fy/zeIf/DMoCDLXotnx8Zr0hy9dlFDKJo9heVG6/5WN1fRcv/CehVb918jIv2LcFFwn+r0QZ07i4FxOzYZ4ng/QoA39uWq6Ue7Qt+gHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(83380400001)(6916009)(8936002)(5660300002)(36756003)(33656002)(2906002)(86362001)(66946007)(1076003)(508600001)(186003)(2616005)(66556008)(6486002)(38100700002)(6506007)(4326008)(66476007)(8676002)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FwFtLK+nxCMN/1mh5tJnIYFgI+LxlHZNAOMqV0YbRqQdPdbP9FAPU1lzlRM5?=
 =?us-ascii?Q?nkRop1kXciGyGastxjJsgPbXsA5b8g6CJYkN5mFCb3o7PQ/ieYU7EACR/ELH?=
 =?us-ascii?Q?l5hA/JY10ah6rRgNV4umkAjDK704aOeYeh7BRx0wbgTwmy/FYODTlWstf95I?=
 =?us-ascii?Q?lhcHWq3GP2khe5rl6GnIHZKxhq/lYEKTGvM0IBYpxUn0Dek3eWlmy2Ursb13?=
 =?us-ascii?Q?SUo3X2Zir+2q2qsFDk2e46DxPEMj93Vr6HetKuI2ivjCq4I+75cjTw8W0HB2?=
 =?us-ascii?Q?iAWNZ8+s1L1goprZiYOCvIXvHPGOTlxqy3nMYoyY7eS7QUU3ohKdY8X6otxl?=
 =?us-ascii?Q?u+KOWWKNnFyIM+SV3qmdGd8rvJw0D4H3ShXuSJzRc8GHI3F5VX4f1VlCvA+0?=
 =?us-ascii?Q?mRPBL9C0dYzT3nHsbB8yaHyzOvJ0nWFhCmOJJL1R4ckab4O73ACqT50+w3dr?=
 =?us-ascii?Q?ia6x2V5g+TlBL+thFHWLvDDFsVXtIhQaKEJh3TuwOWPcElhuqwlTKWatHAlx?=
 =?us-ascii?Q?/Bwz/pPVmI+j5H++Y+epV/80RcwEaIfCKotHjTKMIf9SPV4hRCiY5BJDA3Cz?=
 =?us-ascii?Q?OnbFmr4WUMwx43HovLv275Am+WcqMY2RVNFkGcf4XxEeXYddDy5SVoQsDG3/?=
 =?us-ascii?Q?X7f57MfidFpB/5x/bV+dg91yx5NzXACJBT1jMPW6GTgOPOEzMTZr1eORQu9d?=
 =?us-ascii?Q?oAlLuEiC5e0zfPvnrBRj7EeEIjswxmKux8z2T2dyG7N/Z4J7e2+QP09ieVrK?=
 =?us-ascii?Q?U9Ym0lKDT5WeACbozYxIiA91d0CSiG/Cd0eUU1Wi5vP2FPJDQlbmwSw9hKhz?=
 =?us-ascii?Q?2s2aliAxflZ/1A+psvsGbuJYjxcC69JQQNTTT3DdgxopiEr4mQw1mixJv4Lg?=
 =?us-ascii?Q?+AYqae6r0ITneRPDqxsetayV/Bt5qP/2JUFRiLg2Al940RqaEFgyN/abx5cr?=
 =?us-ascii?Q?xJP5LI9kMjvaH0JIMCUDC/7syZCSf4+tgkYtc+4NSXySlyCwtyHPrUFlmE9T?=
 =?us-ascii?Q?OwJkB2ZdYMGXLGdVpOQEVmiHm5nIqFqOI+J0XFkejQ5dDLqQKgbfhzRRMk4z?=
 =?us-ascii?Q?8C5LqomNcriDAqK23mkeZ0tgBHu16CoSbb+Kn7q/68tP0NIsJfrtgR48YORx?=
 =?us-ascii?Q?y5m3++9QZ+Ebhj95VBbo1yifXu9r56MJeZXl5qYyb21RX/KABgpo/JbXTj+L?=
 =?us-ascii?Q?cLB0Wgq5aSPz6wYkvKPiyQCu1bqIwmsGxDZnP1ZD3VaPSP78YQf0MyUJC3k+?=
 =?us-ascii?Q?HgZXNGEIlVWjWIRKScnQL8YrpVCYk6gAF0LzXGseJf0UqnVCKshAGXXxvAVY?=
 =?us-ascii?Q?OL19OworwM90x7fP890fXaIbN4HKaFqmXiC84DoG5sv4yFlORw18BVxBfiMY?=
 =?us-ascii?Q?b1mBWEbpU0v9wrB+gbmkuEsOqcyg6t1H38G0NBjds7oRsmqzoWwNIPXV/Z+y?=
 =?us-ascii?Q?/KWucj8XrWjdsoJ3+UVAqUZifPZ0vDTKYtb6ZmbS21nBeBGtLy3MzybKBuzc?=
 =?us-ascii?Q?7PLqLQ6XqKpKVBtbzHOmz7ZIEmPjXejQTQfMdsFvHaHG6mRjKqJ8h0ULbZ+D?=
 =?us-ascii?Q?5KlBOzbMqZ+qKDPu7VR1ninmBfRdPVbGT7txMr5BDQArgJmnE1KNhRC7DP1M?=
 =?us-ascii?Q?P6VI0VTAxjol2I0CwHcc5pu5kpLudRmExmSnSqaSWvsyBlV6vW69+dIUWQJb?=
 =?us-ascii?Q?wogd7n4HTebmLWUjmruDOqcRY7qA1u9eQl3Y5+Gmmccd/TcT8lVTj89j7HkV?=
 =?us-ascii?Q?DkTjfzLwbQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec0307c-cdd1-4c00-971e-08da2c87c643
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 22:04:48.6590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWp7w/rEHae8h+PnMP5VR6uACk10z20COr8Iwks2yu5AWTa71rzVqnnKTaPLDhxF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4278
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022 at 01:58:37PM -0600, Alex Williamson wrote:
> On Mon, 2 May 2022 16:25:41 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, May 02, 2022 at 01:07:01PM -0600, Alex Williamson wrote:
> > 
> > > > +/*
> > > > + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> > > > + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> > > > + */
> > > > +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4  
> > > 
> > > This seems difficult to use from a QEMU perspective, where a vfio
> > > device typically operates on a MemoryListener and we only have
> > > visibility to one range at a time.  I don't see any indication that
> > > LOGGING_START is meant to be cumulative such that userspace could
> > > incrementally add ranges to be watched, nor clearly does LOGGING_STOP
> > > appear to have any sort of IOVA range granularity.    
> > 
> > Correct, at least mlx5 HW just cannot do a change tracking operation,
> > so userspace must pre-select some kind of IOVA range to monitor based
> > on the current VM configuration.
> > 
> > > Is userspace intended to pass the full vCPU physical address range
> > > here, and if so would a single min/max IOVA be sufficient?    
> > 
> > At least mlx5 doesn't have enough capacity for that. Some reasonable
> > in-between of the current address space, and maybe a speculative extra
> > for hot plug.
> 
> Ah great, implicit limitations not reported to the user that I hadn't
> even guessed!  How does a user learn about any limitations in the
> number of ranges or size of each range?

There is some limit of number of ranges and total aggregate address
space, you think we should report rather than try-and-fail?

I guess total address space and total number of ranges is easy to
report, but I don't quite know what userspace will do with it?

> > > How does this work with IOMMU based tracking, I assume that if devices
> > > share an IOAS we wouldn't be able to exclude devices supporting
> > > device-level tracking from the IOAS log.  
> > 
> > Exclusion is possible, the userspace would have to manually create
> > iommu_domains and attach devices to them with the idea that only
> > iommu_domains for devices it wants to track would have dma dirty
> > tracking turned on.
> 
> Well yeah, but that's the separate IOAS solution.

Sure, you can't disable tracking done at the iommu_domain level
without creating different iommu_domains. The IOAS can be shared,
userspace just has to be aware of, or perhaps explicitly control, the
assignment of iommu_domains to devices under the IOAS.

> > I'm expecting VFIO devices to use the same bitmap library as the IOMMU
> > drivers so we have a consistent reporting.
> 
> I haven't reviewed that series in any detail yet, but it seems to
> impose the same bitmap size and reporting to userspace features as
> type1 based in internal limits of bitmap_set().  Thanks,

It goes page by page, so the bitmap_set() can't see more than 4k of
bitmap at a time, IIRC.

Jason
