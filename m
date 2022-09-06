Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C845AF838
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 01:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiIFXGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 19:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIFXGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 19:06:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD7885ABD
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 16:06:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/C853nhfg4wIZpxLuzn4ioMnySZd2hMicL2SH4Nid7fPz8imuhYG9uYqgm3ZU8+jLtEwEyOy9o1Q97tmdirpBQeNWRj6dVn3y29ZCaETGGTJd1ngY8oNvhnOTJ4VfY0rE7jIY8WlnYIOGTmcGdW/viNUtTFOpHT5KpO0lgUHQCepb3Qijbo8Ib8L6FwvxiGZIWrfz4LM1fgWagIlFwMeQwxVfzC6c59zErmzOLcMQrTlprABviwiRDgOduJKwVG6gURFiPHroFfUwtDMfQwpaNj5AG4lfW7dcnBi7bNUUz26QTFO/A5QXMBDz+Ojo4o+9DzsyNOyS8fXfHeeBchgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQWI0C51xhJmp49JM7UTMzJBM4ZLQU56U8EbO/ZYgwc=;
 b=ZATRK7499jncEB5zKBnsn3SEoyrww9Wl9587MxbR8G1qK3E34LkcpVYdgIpoLOsbbIEOmZ7EkqdCMNoPjEgy860f4J5QDmhUBIskwYM0ersD2k5gHe0D72x0biqkAWAm3LDzw7tz8Epp/D4VfnbJzON/nI8eMEODoHdfHfW/phKCl7Nv0yPZJ7Jaey4WMuqa8/Zl5xpd0GMly+d2n82RYYTRIX6XVIT+NpE+7TsG79W9Ek8Eg+8DZI5jEtPYIzBAj2D2DC9rK7sFVOM+Jl04qMTKu7KemUnYSx5TMJaeRQLkxPucq1XFLoS7inRVJtmrp56ixNf9gsZ4ZaSvZOUXww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQWI0C51xhJmp49JM7UTMzJBM4ZLQU56U8EbO/ZYgwc=;
 b=apzPFrqawj70GglLQBbk10CnvHNamuq/R/L3aDChTUu3y2fsyx773wsR32OISuIOuf2i4Po1jO56k+w25lk85cIEMtJpj0D0rjX9nrIMg7YtLOxQ0zhF7191eGnNXaLkBIabDnvlMQ5qbvaS09Adudghh0F7TnwaOE4dEQLhvCGrdrsx2Vh7tLEsQioFVNQc9n7HFyuiiwd0O+5diY7nRPTuYK4p4EfpxwRLM8S8MXVeRFGFhrgypHjBn+GYtSnwKkWS4oG2XrRZR6zcXB54mFtWE7Pm/StoNZ0dDjAKgBWHoC8jrZ0nn+JETewQKBj/J2n4g/n35gTQlQGm+tFvpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5082.namprd12.prod.outlook.com (2603:10b6:408:133::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Tue, 6 Sep
 2022 23:06:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 23:06:32 +0000
Date:   Tue, 6 Sep 2022 20:06:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Message-ID: <YxfSdsfux0NEYmNW@nvidia.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxFOPUaab8DZH9v8@nvidia.com>
 <BN9PR11MB5276122C4CBAACB295DD15E78C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220902083934.7e6f6438.alex.williamson@redhat.com>
 <YxIuTF0qfy8c3cDj@nvidia.com>
 <BN9PR11MB5276FCB0DCB4E741CCCD48318C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220906133811.16031613.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906133811.16031613.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:208:d4::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a73d2a90-5491-4775-fc89-08da905c7018
X-MS-TrafficTypeDiagnostic: BN9PR12MB5082:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htejo+dX46y8GCdU4xNMbioKBL9m0RYKAeDJXMaDE/pKp+6O+2+TEDICzPuPhcwSnOiGOIB0NcsaplgYFfOUI0cpLUgy5XDelSF96mbKyzalNcVWYjyTkWGyZv2QPM0o0MyhOfojTnVCzr2pObVaWq16M0KX9zcyHQZ2g5Z3madjxSAQHjit9T5yIUxFFOkitccNqpvbUGzCpx6EEqbqY2xqn6Qfw8HLFdhMiDjunhtQbaXKPrDPEXpwveQ/vzYBFQ9xD333FFUBdX3tul0Vb33fb46XgQQ4F2EHe5gFcUGOler2sYGdLpjpYP1axHnQ5TI8rrHbcyHUXr84uKpi9/LeK/HuWeXyIOXI31ZBbH2nLFX+pIAxICLus1IBvf1Hj/yXPx0nZWEfTYwn9LDDKRRVsha9a/tAXdQ0oKTVvkNo/5BghKXZJOJNJL4Dlim+DHyQeiYvvj7ijDitsWoYCeIYNK5s60wrtCIfsoKJe37N3CT21/i1IvmwswcozumAJU2Jyox901FXy05AlP2/Zwcuy4HcYLwLJTxs0UOqRPGdbEowVxYbaPEi3UK2dUy+GjXYEpDOn/zD11avCxmfYrEIjOMz8XTUbDqdJjULGQ0Iecl7LbHGnyy3Qa8n9t4xib+qfdZ9xi1WRxzphKCj4IIuHsKipMx3FLnr5T0fsexYPNxzt/tV+bGlPm9emr6ER4kpXKPvyZM64LkbYGzGUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(38100700002)(83380400001)(66556008)(66946007)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(5660300002)(86362001)(6506007)(26005)(186003)(6512007)(2616005)(478600001)(41300700001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oz6z0v27aidcbZvxImss8KFQB9SDZYOJJ3tHzw9ZSPrvJSColdZLtL/EvyBH?=
 =?us-ascii?Q?0tQGnT6/jXlwihNMv3QWkzno5XmLjVL1VN3cOUb/pAtt+B5bVQrOfxG7urxM?=
 =?us-ascii?Q?ZI/sDsKMUrrNE/26D1IbcWkD/dFIxS/v/M+jVxZQiczPUzUDAXhKB/7W33iY?=
 =?us-ascii?Q?TU4jroFeeaRogjqHBdtms1AdT8JuUETk1M/V19+u3dta4WvDc1zudhcDnwAI?=
 =?us-ascii?Q?kADnllO4sa9rnHj4CeWBK0bLNEZmw9hpoiwxsbf0cYW4+I/x83XeW30dQ3Go?=
 =?us-ascii?Q?x7h7bTK+soCFD40YDiWH9RFCdlReNbSPSpDOf9RktGCXNOhdE9h5zBVLY9ZH?=
 =?us-ascii?Q?vA1OKYD8qOjVvU12zzljhb3v4IbaNCuQOUbDtrx566oLsLReoOxbXvfq11ob?=
 =?us-ascii?Q?+NdbuF2Xl3LVGCgsqjK+GvAXvPHfjthcwsWEhnr+TXDNDSo+uN7yWDZRFBYA?=
 =?us-ascii?Q?iEF4gF0yLnzOPu6Kej/EpVnm0TS48yf8Ul38X0GNormTyTG5gPQvZWQZ+TCg?=
 =?us-ascii?Q?MkHxwGOR3Sf4UQ7tx/z+oh6M0FpNuBMnvCdvlUWzpvKFVEHuZtBkOJjFTCGY?=
 =?us-ascii?Q?6TfcPy/nMbwXTfk+KXYUD+EMLbtQeiMFssGL+VPvni3qggX8eWr1tJ0dSCYo?=
 =?us-ascii?Q?CZPyjFZscko6CY9vTPEZTTpLpgGsrzlmw+ql66C8iQLjc99D/E+0QSbld+SG?=
 =?us-ascii?Q?cjw6R3Q0Lc/7VVzVknFUP0tV+9TgpvEOo8zwx15RCJDQcpgFzfYGwNX+5MUx?=
 =?us-ascii?Q?2c8opBp0aqKMaz4D1ZRhv72t5O85qZL/pXu/70cIOKQqXd01THbcCIej0tdE?=
 =?us-ascii?Q?A14CtXFJURFQzkE26mp8V9ceOIAUJ85MSkTPTisOxwSYHD/75aAZHB+fUbu5?=
 =?us-ascii?Q?89kRV/0aGMdRpaWaPuyu3GakdT9IGCD0cwRPD4MzdjzPYcS+2NE02eky4Lsh?=
 =?us-ascii?Q?kphiKOoFlE0hggyDwB7aERPJc/ww81TOnmC05VMOuCWUYDDurCUECj5cYvzH?=
 =?us-ascii?Q?oGg0SV5tCrpdPzNKex1r1RH24ERiUQ76LLQePtlkED0cpgglwBJ53BqdoQ/Z?=
 =?us-ascii?Q?Bk20bqVcvaStHmFNT6/PL3TbW8NBXO1xHZd2FZiwX4BSrSCR5LzDkbJAVxVg?=
 =?us-ascii?Q?nLxzpC6NrlJZGzOyFdh0Y4Kx6ZjEkIOID9KBOJ8EY2KOzWUhvSvDw72Xb18X?=
 =?us-ascii?Q?MQpeOA5yQl+p1mtl3xTYa6Ex0MY8K2LO2AM5UDq5fbxRgduLTPJbUqFHEnxR?=
 =?us-ascii?Q?WX5TVADP6SoWMGx+AnJSS2u9dZhzkqDUkzEafUseedttyZMQ9enu/9eg544X?=
 =?us-ascii?Q?huewjsnpScMNQXh3Gm9OYqMiO++W5s7VTBHCTytdBAfkfYQb3FjK2x4dxoBZ?=
 =?us-ascii?Q?W5LRLANrpm/TUKAm83ZuwEgqzDYPQMZ+vdeKR0s+SxP6b7FWAUyenSsXdMZK?=
 =?us-ascii?Q?g6LclEXWFDesVTw3kEx97Ltgh8V/fZgXFTp2UlRgsNlGzWXNiH7m3MLFjjWn?=
 =?us-ascii?Q?6LJaatHUxC4ISdTy6WhKUBbG33j/WkJlORzGeVu66cE9dS9FoFuuZyg/MioR?=
 =?us-ascii?Q?2eEOO3V1KCPRINdbw3FfYypUHNuPi/+omEYs0r4z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73d2a90-5491-4775-fc89-08da905c7018
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 23:06:32.0610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y08BI1/nqvzrVVTX/gGkh+dBW07XZTGjjoBXtvw4nYf6YXoWP4K/Lz/SY+fVk25v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5082
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 01:38:11PM -0600, Alex Williamson wrote:

> I might refine these to:
> 
> struct vfio_container *vfio_container_from_file(struct file *filep);
> 
> int vfio_group_use_container(struct vfio_group *group);
> void vfio_group_unuse_container(struct vfio_group *group);
> 
> int vfio_container_attach_group(struct vfio_container *container,
> 				struct vfio_group *group);
> void vfio_group_detach_container(struct vfio_group *group);

IMHO it is weird to sacrifice the clear pair'd naming, keep the group
first?

> void vfio_device_container_register(struct vfio_device *device);
> void vfio_device_container_unregister(struct vfio_device *device);
> 
> long vfio_container_ioctl_check_extension(struct vfio_container *container,
>  					  unsigned long arg);

I'm fine with all of these, if you like it I'll change it - it is a
lot of work to change the names and rebase everything so please lets
all agree first.

> int vfio_device_pin_container_pages(struct vfio_device *device, dma_addr_t iova,
> 				    int npage, int prot, struct page **pages);
> void vfio_device_unpin_container_pages(struct vfio_device *device, dma_addr_t
> 				       iova, int npage);
> 
> int vfio_device_dma_rw_container(struct vfio_device *device, dma_addr_t iova,
> 				 void *data, size_t len, bool write);

These are exported symbols and I don't want to mess with them. The
fact they are in container.c is temporary artifact, as they do touch
the struct vfio_container. The iommufd series puts a wrapper in main.c
and the above can have signatures that only take in a container * -
which is what you suggest below. So lets leave them alone here.

> Overall, I'm still not really on board with sacrificing a "the name
> tells you how to use it" API in order to break down devices, groups,
> and containers into their own subsystems.  We should not only consider
> the logical location of the function, but the usability and
> intuitiveness of the API.

Sure, I'm not set on any particular naming scheme.

> Are we necessarily finding the right splits here?  The {un}use,
> {un}pin, and dma_rw in particular seem like they could be decomposed
> further.  

I can't think how to do anything better for {un}use. They are in
container.c because the entire container_users mechanism is gone when
the container code is gone, even though the mechanism is part of the
struct vfio_group. unuse doesn't even touch the vfio_container..

Lets just leave them with their group names and they slightly oddly
stay in container.c

> vfio_container_{un}use() with a vfio_container object.  Or a
> vfio_device intermediary that can call vfio_container_ functions for
> {un}pin/rw, also with a container object.  Thanks,

Some of the split is an artifact of how the code is right now. I don't
think you'd end up with exactly this interface if you designed it from
scratch, but we have what we have, and I don't have a lot of
enthusiasm to restructure significantly for the sake of naming..

Thanks,
Jason
