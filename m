Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1097B0F84
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 01:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjI0XQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 19:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjI0XQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 19:16:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B958F4
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 16:16:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEqKqQp2M5NHsTFFkDWAkVshfVQNsD0AWddcye8BxlzX6NRqRQcc+ZRLMjMiUuP9y3r9LCfIFiNqDdsogPnzjmi6Dko0HLAsp2fpxi/fhtQ57zKSei2nVCzVJFJJdgF2TZ5Xv8twZ7y8+KOyVFHCU9xG5qTjNy3z0e0w0HA6IZVhnAoR4Ej9LqWIzM//5uH4XpQIqegOqXvTckJbyD0ZTN6RpTElcPYdQKP18G7fk7A/oMY5N2nEqkqgMljaQazT40RMlgbSc6dTnCI0yRg0as+KfRPmDq6EkSThiJgIZKzhry1/oxsIBDNZsV5zpA/HxEZMrHu1UO7bZ8b8Hwej1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E006YMQK/0noKg8WyHMjN0qHqfVEZLJ8FSUlS1YwU9s=;
 b=BGwMtRwCdJzYfFTe56CLOkAFfcANTYLTOLuDtGX81B3w79o72/EysQlbzYWW/yQYP3Z1q7fHmUJBAii12xGwimqolm6BjKm06g/g40+cFbNLI4FHUX0SNnAddDdSTz5Sa+wQ6JAMCBdvRmNLHEGWJk3QOIwppXyzJ+o3hKqlN1lz5mSwSRLf1Dl6WzzGztuFTB3HqSZbGZmR1sz7695+/wZeFnJxMUmpGQBJDXKWE1GPCTOS8fxRcyzKmkkQzbOSlTiAzcKWc2PReUXtwjRkDWOVwHbAcZuxoX/Qx/xcDfDORvMtZq/horlTX2CaHF0B1qlniddprZm36+D5s1/yHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E006YMQK/0noKg8WyHMjN0qHqfVEZLJ8FSUlS1YwU9s=;
 b=GSCM6GTmWXvwmmqqhWQqWEnCP1bYLzC2nscCRt8Anf8MumQth48a+S4CLLRnlABxpAWLdpclIcDQ9jfyIkC9nnyS0CP0g+g4L7FgaBiqupPxBQ9ZphABVgxk3tRbUYv/J4+zJZk3rCnDB1CAWwJkPs9m6OwsKZPY8xg6THN/FYhcw318Uthv32R6blHi6vqkuW8NtXdqyf5JeRHjvghfeKB56e929QjHOt/zeer2PfVgIn6OqPsvvscULXpHsIvh0K8qK5jOb7HCNAnyqPYN8mvii0uD6dK8SMmqMSW6hvG6h1TlDQqDApqXbwdGcJJUcVQiifwdhzo9X6qdgvMe7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6704.namprd12.prod.outlook.com (2603:10b6:806:254::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.25; Wed, 27 Sep
 2023 23:16:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%5]) with mapi id 15.20.6838.016; Wed, 27 Sep 2023
 23:16:02 +0000
Date:   Wed, 27 Sep 2023 20:16:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, virtualization@lists.linux-foundation.org,
        jiri@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20230927231600.GD339126@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <20230927131817.GA338226@nvidia.com>
 <20230927172806-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927172806-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0300.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6704:EE_
X-MS-Office365-Filtering-Correlation-Id: 80a25379-07b5-40cf-7367-08dbbfafb79a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwdx8fsO4QOo5aad35o6y/OWiePCRGJYALopEetX+hfryOhunGLz7g3cts0Yrd8aYdIdVGH3xo6ul7KyGEs/d5lGr3YdUe4XW1D4g0RLs5k0y6+2QgBJ3v9uiDSqiM93gk4ldLlwhAm+08wIh3XyKiA/Ifo4cZh3UvtMVXn6AWbgIXFSVOf42U9p5dzTk1lNfXryYGKBMGRRJ+0NT/xIwsPJ3uuhbt7Tp0iKlOHWRhCcx0YUorCvNyaAPAXOYrX90DnGaAdfR/5WKo34hC202/0HAlRQcTLSMGvAghfRUhxdFnD7692QtWU3XbzYkWHjvMnB6PmfvltA3Z7eBcCaW/wu/3JZHewGE1RcJw4aJ+RS3NeWDbXW/lp1q21yKEkyWzKx2Dj4mFiM3G7pKgpipoucJNNzuW6hWHc9QBi3seRvxGyp7nTark/a+VSrZqbBIRzA4tU3Dw5eGBm+KyT7UbVOWUs2kxJJzWt3PuW9WWlFnFUL2ax9ASQnFUBEvbv8P15oyp+/sYTegGBQsGoc0rQdFFve3Pmr5gM/K55J1vj55Y9hM4aqqIlMfM1nhvBMXYLeQYz0H8shcxMaMygR9BiwshNfztb3BjbdgDAIYAEXUKCviMaoE8POIcZlYuM8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(396003)(136003)(376002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(107886003)(6916009)(83380400001)(66556008)(66899024)(316002)(66476007)(26005)(1076003)(33656002)(36756003)(2616005)(6506007)(6486002)(86362001)(38100700002)(6512007)(66946007)(478600001)(2906002)(41300700001)(4326008)(8936002)(8676002)(5660300002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vnx4WzZ+zcm0NUXLPV03Ea/Laz75t156QZhEWg46Arqxw/ns8+WxD6Ess7iL?=
 =?us-ascii?Q?VdFFsYMyn4t2DYBy9fg/ZurA95UWZPxKbq9Nk8bfUlqCAmvkIIXwAsGGkIfD?=
 =?us-ascii?Q?OhDh3HsV3LJM+FmP1IRioGjoRgamD8u0z5HDOdZwalOoOH6Hl0/GJlsuM3vb?=
 =?us-ascii?Q?HWpcuSZh8+57URGr0OpTuvp0xjspvKKcIrMhNh4GSJcAA+SfxB8ex0YGaC+v?=
 =?us-ascii?Q?fEHUCc2M6CEMT9owZpV1IoElKAxe4ZoATVCgciBJbA4g9gjJ9prs2DUmkQwl?=
 =?us-ascii?Q?FRvX+SWp5JRkI+Z1esu/CqlxmbH4jv2pPY848XzuvQWnM1sSgeiGK8fRZo8U?=
 =?us-ascii?Q?4vLi2Qs/tTInNE6djvhCHf6Q4GpDReP5GFH0UjmYJh3YC5FdwJzfLVdPn2hf?=
 =?us-ascii?Q?sC2HU5Z3iA4SEdJTr9YSUDrW0HGsfqID8FFSXYCfZLOARIkTTBHd3T/IMWPm?=
 =?us-ascii?Q?Q3ebVc/AGQNNfD3iAacFvSxJNbzh5p4+4mSs47FkG+inC1TSimq1vgs/vSb0?=
 =?us-ascii?Q?V/zTzGQyKhYbtNX39Ur29RQDSXXg2cNN9ynrSMEc66qUtdf07uJZXWc2UGZE?=
 =?us-ascii?Q?kLdZ7QmMvOWjGrx2weQXbc18cQrh6mfLwdnpQEw5Hkb3oCk+Jh76xq0RQ0Vq?=
 =?us-ascii?Q?uTOYQYOT2Z0ARJU46Bhl9CVsHrhO6ED3/HEACKXKQKh6DvRMt1iFsk+MYbQy?=
 =?us-ascii?Q?NbZsLqpX9NBVLsvsbpxPKpSZGnD8bbZD4nroSJcKPD9wyvl0Pi+Db+xgLgY9?=
 =?us-ascii?Q?eKZaC7tICdVJ51HobqrFgRaOca71VCKUdaqGlsvud0/ardIxdot9Q7fPnW74?=
 =?us-ascii?Q?42WpAALywJ0xFRoR0Zem4vJWgoM+ahbaNM1a4nKGc6dE4xX5j95KvV1BH2Ur?=
 =?us-ascii?Q?BFnlZf2wfd/2fB9ExLauYWX+UU2KuML3XJSmy+5DWzw77t6PPfamlf2b1bYJ?=
 =?us-ascii?Q?ODooaT0QR7QSr059aGahMGcMwAtxoQ1wnDxt7B9oLRJzIh/vmHAzA8TxoEhy?=
 =?us-ascii?Q?N8WoIutj8wXJXa6dxJP/bWih7146KCbt4xSe+VyfJENQu34hTlU3AbOmHSA5?=
 =?us-ascii?Q?UyFXgeYYjN5JvyCgNy+jHcVExLjxb0ZAVtOgZhEbYlqU3ubBpBvvh6+zB2nd?=
 =?us-ascii?Q?anEWyqgcbEohMXXWS+/Cydt2ofPd6HBUEbgH4S4oWiDBerEcY7jKovKkFrAr?=
 =?us-ascii?Q?rbdfp+MEInQRUcEjCQF+mpJF0gS0mkSkDC7uiaZc3Vr9VlK5FlJfOyrDTtNU?=
 =?us-ascii?Q?2tjm6SIMmwvSJQImVuC7nJA/r8Su2+O7pIu3H2gQX5aTT7IBbOZjP4DDfbp+?=
 =?us-ascii?Q?XWHXMoqzOuMJv5Qoj1IuVE24q8JXpMckDR3TLAHyYA1VQ7cAY7RpTLlsObVQ?=
 =?us-ascii?Q?H7x2cFgx+o6CcUgov2er5BXVYGxz1ynCn9wjOmSq5/OsrJyskZ4bp1e96Q27?=
 =?us-ascii?Q?RsZf/sEmqko4Bf9tFPF6/M7EaZF5cY5I/7G2bdl0LYJCLT9xJvDlDQ1ubPsw?=
 =?us-ascii?Q?0QK0lRAYlU3BmfSDU/gfZsXnKjHVbt9th8zF1Lmpt0oPmpwnEaQayYWGogh7?=
 =?us-ascii?Q?WZw78AQKHLsCWuR7rASyC0OiDZT0t7cz+w+T+fqt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a25379-07b5-40cf-7367-08dbbfafb79a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 23:16:02.4954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PEcdB8YAtbmsozns6XDdAz2sXcM3lezqLgMIX/FleHCwC1EiYCg7HtFKHiCnM+w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6704
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 05:30:04PM -0400, Michael S. Tsirkin wrote:
> On Wed, Sep 27, 2023 at 10:18:17AM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 26, 2023 at 07:41:44AM -0400, Michael S. Tsirkin wrote:
> > 
> > > > By the way, this follows what was done already between vfio/mlx5 to
> > > > mlx5_core modules where mlx5_core exposes generic APIs to execute a command
> > > > and to get the a PF from a given mlx5 VF.
> > > 
> > > This is up to mlx5 maintainers. In particular they only need to worry
> > > that their patches work with specific hardware which they likely have.
> > > virtio has to work with multiple vendors - hardware and software -
> > > and exposing a low level API that I can't test on my laptop
> > > is not at all my ideal.
> > 
> > mlx5 has a reasonable API from the lower level that allows the vfio
> > driver to safely issue commands. The API provides all the safety and
> > locking you have been questioning here.
> > 
> > Then the vfio driver can form the commands directly and in the way it
> > needs. This avoids spewing code into the core modules that is only
> > used by vfio - which has been a key design consideration for our
> > driver layering.
> > 
> > I suggest following the same design here as it has been well proven.
> > Provide a solid API to operate the admin queue and let VFIO use
> > it. One of the main purposes of the admin queue is to deliver commands
> > on behalf of the VF driver, so this is a logical and reasonable place
> > to put an API.
> 
> Not the way virtio is designed now. I guess mlx5 is designed in
> a way that makes it safe.

If you can't reliably issue commmands from the VF at all it doesn't
really matter where you put the code. Once that is established up then
an admin command execution interface is a nice cut point for
modularity.

The locking in mlx5 to make this safe is not too complex, if Feng
missed some items for virtio then he can work to fix it up.

> > VFIO live migration is expected to come as well once OASIS completes
> > its work.
> 
> Exactly. Is there doubt vdpa will want to support live migration?
> Put this code in a library please.

I have a doubt, you both said vdpa already does live migration, so
what will it even do with a live migration interface to a PCI
function?

It already has to use full mediation to operate a physical virtio
function, so it seems like it shouldn't need the migration interface?

Regardless, it is better kernel development hygiene to put the code
where it is used and wait for a second user to consolidate it than to
guess.

Jason
