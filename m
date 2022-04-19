Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC1D507A33
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 21:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351477AbiDST10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 15:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbiDST1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 15:27:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036703BF83
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 12:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdwxNtsbfENAbuJy6E2G512JKviopGCxGO5fBkPEnHPdUZbhV9gjud90vPVqZUV6Aq4gACtG7goxpHFaDytnOuX0Fg+YkNVk6ZR6CoG0Z76hw+RkEIRj28nrgYnS0xieYdniBO15zjfeZVRKGe1moThPH3C/uniwzPDQsPRdClvSlxjWz8ClDlbuwiXNotjAX6aS02OB4X4v07gvhqbbr72OjbYAfDxoW4Qg7xhETp8s95pDflwnxydYOQnC4lhpkhhRlntdaT3JRxYCLR0iCQMTL686VRm3W098NCnnV0ePAuWTK+qcRSRC2/hRi4t8ROdTefOZYqQP39ob7czW7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRwKTe93ClI3o9qXXV5k4mdjrkvOvJ4Q8oElN7J4yFk=;
 b=LnhwH0xy4O1CQI4IHf545y/z0uEPnXBdjsRZOfpXHmXlgzVWKDP3ucFcDrQK8COGFqVndAHfp4n4DCTKWl/EakBaz91KxtACTEpBcNkoAXmwTp6PWrbhUu7BNgxi5lQxImsA5Gv4lJRcIKhv2iGE1RngBPitSBxaic7dwO6V4fwYok8R/035Qde/Db2FBX2tL3Tq/Rgn25NJ58H/dY7DLZXx9CKQOklqOkev42XOWzeiDhg9JWnqlpFL1aXvH0at8ZLaoUDTtcvIfv7CLBWRIipSBzaVjnTzqsOy/Fl+NtU2wgPp6G2PIcuc1H5knQzioo93nGKBZYaxhE/ajV4BUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRwKTe93ClI3o9qXXV5k4mdjrkvOvJ4Q8oElN7J4yFk=;
 b=BCLPLhA6BLYUK/MeTBxcYJB7w4rKlP2IGZI8zavgIesWuZ79a6WzN4FvOkQMfx00PwO4tUxQqA5OdndOA05CxqJraZzj6am1/LLJECBOrfDZjKudQ3en+qBErpK1+L4PWZZPBxX5fF1i5i5wCGqqucClNbawSNMg8YBN6IuCkZDqi0CdqLPCcQieEjoLIYCCVYtHD2nW481Ud1d3k2cEfU0uFuuypDm+pv/HXS63q1jp7ybrhKxA78ptkFoRg72+46WISb7joZsNw7KY7G8t1GH6uCtaUzWLtSDQth+HkPl2GlP/7tscdr+Nf2pO2aLwKbR8vWhK/uLaxt6NAsLnWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR1201MB0223.namprd12.prod.outlook.com (2603:10b6:301:58::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 19 Apr
 2022 19:24:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 19:24:39 +0000
Date:   Tue, 19 Apr 2022 16:24:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 03/10] kvm/vfio: Store the struct file in the
 kvm_vfio_group
Message-ID: <20220419192437.GC1251821@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <3-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <20220415072027.GB24824@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415072027.GB24824@lst.de>
X-ClientProxiedBy: BLAPR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:32b::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f72de56-ffe9-4777-319b-08da223a3f56
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0223:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0223FDC9F4CAC605019AB715C2F29@MWHPR1201MB0223.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMtAjk/r7jxf+chbERNdg/wdygsUgUMl6La326kE8k4lzsyu727M1tmVSdVRlpeDq0wBlKoafsewp3xquagXMZHUtwv1KI58vuLvYxTaPgKW0LYVcAPBjWgMvUOuDrJAy5ImgiLocsMRscFF4Cf0VU6L8R+1XhzwiBV5uOkzbNJiTGER8faqXqzCGxVutgph8dK4d9qo6tN8N4V4ysnYzB7y4DmOsKyzuptTLk1YA8lommT9Il9qhoCCC6VLtSF+CzYU1exzJarjuVWvTNHyjtv9mDrNu4MWisxpZCmPhdmzzE2DgYfdgMfOFHiSYV1zLZ21myZLhxLObKICupjwSnE4rjHsnkUwMUBt0e3q72uSXJnjYuLVIiSq002diq5ujH+9gpzQyQnIYTiSkBCzjw544wKyYYtICYTE6eEJBSs6HjQj4S7qqGVJrL3taCXqPTxjymqe6YOR3XGx7L0rS1IJ051AJsSynCRH5+CWlfMdoNX044xpVh/XhdQipETd+t8sXbIxG+57OBAfoLrdeKldtartjhqCQhFuAW5C2cUP86eurXtCKG/+TsGCM4j00qtKIYK0ZOpqKzCWUONdSqt9ylXbcxIOlnrYMvFkhAa+DupPoE9lSVCr5gUKf5xdfw3VuZ0LMVlqjKjR+HcImg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(2906002)(4326008)(5660300002)(26005)(316002)(36756003)(86362001)(6512007)(6506007)(38100700002)(66946007)(8936002)(6916009)(8676002)(1076003)(54906003)(558084003)(33656002)(186003)(2616005)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o9XCacs3Uf/BGecaXa92OwUP3OwNQ8cCK9KItF+9fctgyTvWCQe1TEsVQ8mO?=
 =?us-ascii?Q?/d/DyziH5jSFJnK+QL0qliYnwAlIWY3dCUVb70jHZSHVWLe+FuUv0Asorsku?=
 =?us-ascii?Q?C8a6qNnenNo635KOIcnrgv9e7OArpH0fkirASKAEH2SlFOCRv+cOIHBlCZIl?=
 =?us-ascii?Q?KYFxjK9hYLQbl/07huj837fdSclV+lw+LEehe1I/HwtQ9QoeGFOw1cTl0KWq?=
 =?us-ascii?Q?qzoamiiMO9QELh5T572U6h6MI3kWWrmWIyI8H41k7dijANON30q8k/leTkOV?=
 =?us-ascii?Q?VWZYYyDgXi91NA4rbMZjZzjwwmuzPhYwUNXWU8G4ENll74oc5VClJEhdNhKG?=
 =?us-ascii?Q?+yB3ICVmT9/OlYsqNDMx9kQMiGzLP6iMxV5iYLvS1SruyTBtu74wodq7zN0T?=
 =?us-ascii?Q?HRS++3H6CHG9yuQwTW8o+Qo0rI7+CQHwwX39zok3FJdQuNsLjg8Gwhoz3tHg?=
 =?us-ascii?Q?bX1YIWha4XSZ4cstHHTzAEUtae8q6HbfyyFCIQOygcMOiPIxuV3Uhx4OjF7C?=
 =?us-ascii?Q?bJ2xmF/PfUG8kyatcRiMLkE5lUhQis2fCPA2Woh+QMJmu+NCHcqn/27akbAr?=
 =?us-ascii?Q?foy25fnoumpamVRckGTPjHZNdPogRXPkj8VqaL9jMkRCsfgyl0+8ffBmdA7a?=
 =?us-ascii?Q?eB2/MIadjqtm8Q+20zrDnPh/JKW/evni8wNJE4htdQF6N3AVlMP4Smk6WObB?=
 =?us-ascii?Q?y8QffSoibpXpBSFvKMCKdmjRwzbhx26reVJmA0oaY07EsLWjUKdIEcYB7Nvg?=
 =?us-ascii?Q?6Wya5BCnUIKJVSdQmPn74cow9UnLlaHn7WCDYBdMW7MJHXsncfrL61BWDKE2?=
 =?us-ascii?Q?jQOyywdoeW1HYhMlID3wT1G5NGmq7+xoDjtf3bxUwySCkDIzQn+4mtAnkYmt?=
 =?us-ascii?Q?l3CkxY07P8OpsmkdZhT00ClcAB+3x7EG0csWTiLWXyCUPE9aUPAyx9b/aRFu?=
 =?us-ascii?Q?EkL1rVy/x0f2GYncGRBWR8S7ULEPv2XqqN2RQm2s0VdxMFWwQ05XYzVzxhWX?=
 =?us-ascii?Q?cSGWySJFEYZnoHghmxoSv+IGpKdFOaKJG2iZVCbUnz+aiR+1vGCtAsI7q6DD?=
 =?us-ascii?Q?KTBgv+JBIgm+iLzdnB+HKFfyoOpeA+LgTR6bkblh/gCIDlsuWbuzjtYlsA1y?=
 =?us-ascii?Q?u9xPa6z1G12cVLcLJUxWtjTjul94UUVuECTqleCTiavNxF/OOinLVNqxFa9J?=
 =?us-ascii?Q?IO7D7d8IHcUsOYMOXZvf3sI0Sw90JX3RUaQPjHxFjbcNjqL0cCWifsOqzMSw?=
 =?us-ascii?Q?pydziVIgMs8miSSpfuaC69D7AZKbykezDZgD0cq7q+5DyJH8o3jU2Hlk1ZrJ?=
 =?us-ascii?Q?KhOKOmebFQnA0OUDosivfMpExW2v1jDviTp1fFEckrtCBpB8m+lS0+soqwTz?=
 =?us-ascii?Q?25RW4Jos9NcjaZSRgPk5OGSrIJ/XIxqNKD+ewdy+X3TT5W69U8vBKsHE1HMz?=
 =?us-ascii?Q?OhAqf2emK/xCoG5p0vtuh5fO+27St3XOzwouiU6bII9phpOMjYpZ+iQiEhlF?=
 =?us-ascii?Q?9CYe1u4VyhQq/SiPoNSLlWaiwFtPRNBV0PQuEl2oo3V8f4YWi5KkG8cAlyZk?=
 =?us-ascii?Q?OCvAomzaEx0LZ7Q5Zei2ga7CJq+Rjtsew3qJlk4GNZPDfq9dWdlNCVVsMI1c?=
 =?us-ascii?Q?uF2UTBB58F9NjnvAa77Idqxg7Ems9WevQaeUetJ+TVo81Dn01vSOIIe+xGC1?=
 =?us-ascii?Q?Y0NtLrs/lT4D1UiuZvHDdC/mI/2tujlV/T0B4fUEo4CGQWYtsQFPz+DEgmp7?=
 =?us-ascii?Q?02Y8+mYUQA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f72de56-ffe9-4777-319b-08da223a3f56
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 19:24:39.4501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tykLZpUAt8WL2NRSvOj76gDpxV5R5UpTbO78ajm2TEqFm8SmCLpQuqxcxbUq8Kvg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0223
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 09:20:27AM +0200, Christoph Hellwig wrote:
> I'd name the field file instead of filp, but otherwise this looks good:

Done everywhere

Thanks,
Jason
