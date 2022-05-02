Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545F5517A4D
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbiEBXFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiEBXFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:05:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331C62E0A5
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:02:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGktvKI8CPXPIXr2rnJpF4uCntByIlQUEUI+9RZnz8eyOgpLec8RYhT58XLlvSlVWOtmM63Vr7tY9HbpJHbmx5FPPuXurtynKBRcxB5w8k6Hx8BiFAiXexU9u2Qh1QKFVn0yBieeModmftRawGYzuu2RO1twO5PMv4UWR8c8HhkYG7I2WPn39r4t6QwtEPH7USwf7o9J/549TffNKrsrDrURJsii94wcHCovGYZgz7qwUyC7EZlDldiKBcIEXFoZjauW6QB9knD9O8Au0XDw9NbU74fbblEgsCWy4vaABYOVVGaQFJ/aMtfUO99uZpbHbF/B9+nqQyz4+wxs3dyDgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJ8OQke3IgZHI0KCvVXdtFa1+7pD0CfOvp86WxOV/P8=;
 b=fkKVB9X7DVB/Pj4upLJvngQFcPay2fsSeJEQh0k0YSFhH3OP6j+oq85cSmhuh+frQ8e/bUrpI9zhfzqnlm9jy+55yvGYDS5hY/HqHwoXZft8ATj6+5NDxFCpvlyEhsdarf9+EKgKSLTxA/I/4ck5XQfuixuEt8KgIL/c75jlDcjGTRWgt5WtqNIFrCPZBhgd8QVnJqY3i5JQZvfJM4l84QtV1u35ZmhARHt/E+a6qfDFvq03Lzem6YXIiVs5C03TD2a1H0pIX5MkPf5rSCWaKTvfNxuOua8tnCjoriQnx8r4YXHYtb2pGyOEvPqbnrVXvpvbKKVydcK6iJHnVB+vkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJ8OQke3IgZHI0KCvVXdtFa1+7pD0CfOvp86WxOV/P8=;
 b=iG7FI6+27NVCBgVp22EA3UW/hhXusAhLV3b8IhBj1Ykmt5OZ5nb/HEjrP4IEl0Q+VP+BDWIpiCZzg4TKVHA0a9YwIe50MhVUJgc98o65s7NrEr+3enpQJ4F+JgiEpyVM+JZ1a6fO3BLOszcesZ2E5fJEJ1wWEarW8tXJBGrM7OV8V7iugEdQC2KOln9vXTSW+XFVtW2YFnwXdvSizYwzSYEHb1rqSpbKHG1sSVXRbB0a+SPsg3WO5bEz/vSvsQ5suuf7Hx8/olIY9MCzjR2F7QB8Tsx18wsHcdVmj7EC2jQxh1kD6jSqIGJXao5SJdhEJNtJ/osGw0IdAtG1CsvJTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5360.namprd12.prod.outlook.com (2603:10b6:5:39f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Mon, 2 May
 2022 23:02:15 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 23:02:14 +0000
Date:   Mon, 2 May 2022 20:02:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, cohuck@redhat.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        eric.auger@redhat.com
Subject: Re: [PATCH RFC] vfio: Introduce DMA logging uAPIs for VFIO device
Message-ID: <20220502230213.GU8364@nvidia.com>
References: <20220501123301.127279-1-yishaih@nvidia.com>
 <20220502130701.62e10b00.alex.williamson@redhat.com>
 <20220502192541.GS8364@nvidia.com>
 <20220502135837.49ad40aa.alex.williamson@redhat.com>
 <20220502220447.GT8364@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502220447.GT8364@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0069.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67ab3cfb-af9a-4487-74af-08da2c8fcc4d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5360:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB536069E8F163B5ADED55D18DC2C19@DM4PR12MB5360.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JHFW+5Ou4fKKCpd5kZ5tv5OA5QcW6hly6kftQs4eG+RK6MRB3RZmqCr25z9PldHqSUQqVS9h0CZn8eQJ74460/38v+u4FUvBtDCmn1tkkTj8yseh7m1DRt/6PuUeYsVT3+tL/68pb6l9yDFFbh+f4vgxUfoGTwoDMWzW3PiH/P1JeuRuj0v/dDHZ5rsSRSCrYLqHB1CxPDkBaPpLQ8LgQs34mlfMgQCDebp2KV3Dcx7oT3y1I0E5zAR2aaTJ2ngHEw4n5nF9Fz55DO1jBvrexkI821ZxbeAkFJzPz60m7kH8GMzynRS+3EWk2DYwGY5s1YFEb9UZYvqAY/NseeDpRLg9ANf+6BHupUcd0GWdvzZ1N2P0y8X+ZRvRSWzT8aitgSbSmhOdyC8xtQkJxfa4nXqz0jdL9i1AHCrEaW+wMRsVRx8iSl0f2IpVMVEo9HkfCAfNXe7wBRzEccH0fn+C3yOiS7lhXN07ra4AQE4dYVTmUbJ1XFEh1S1WjmriYSRtXZp20Pp6Kx/2WOWoNgD0eJ9BdcvD/3O4LUBvoxrKkXKcBh48gL85qZekQeNwXvfKtHKQOGOsYzRKGi4WRRg+lztQ1cqajsukZoPjlrjwUF3ZBepH98s1GSCbYLzvkNglXeCyaLRbed92Wz2fw9Ut0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(66556008)(66476007)(66946007)(33656002)(8676002)(4326008)(6916009)(2616005)(316002)(1076003)(186003)(86362001)(26005)(2906002)(6512007)(6506007)(36756003)(5660300002)(508600001)(38100700002)(6486002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c/qi/F3gLZvEPgeqEnNroZn25EgZI5TG5lDKyjdCfrdkX9cRKHBVeq9WqlKx?=
 =?us-ascii?Q?w74vB2hKjmEZby+uTiFF490AG5JND3YkCIb4debNf8VJLngfaPoNtFZ5iVmA?=
 =?us-ascii?Q?FtsZemwgMaorDrErzEfSRLKKsPsa9xwqAj1WxB54TkJQYmFT6MWTEELHhA3S?=
 =?us-ascii?Q?ohS7Nj5IhWX20n2mdp0Ci3Sr3rlqBRfllXDfqqTqh7d8fGmZ52l9xlDytF/5?=
 =?us-ascii?Q?wEc3GmW3LuFFILk88C9IWKcNUa2AIdDqvVXzbnRP791xk1E+O1M4P87uD4kS?=
 =?us-ascii?Q?Vj7g3Ix/zJ2ZGcFrbxaDXVBCFLn6sy43fBziT5mzDi8Ntz9/MdyneaxmXdZ5?=
 =?us-ascii?Q?gFezNp59jJtyA+DGWYsT66mzDl3B1kRQgnvUojBJjYYLYYUPsfk5FP0Kcoze?=
 =?us-ascii?Q?PpHicP8f9/NTwHdEnkoJjpmmoDRwtfcwKx/ORsWWaC9qjyUxBnY2Uwm98juE?=
 =?us-ascii?Q?hMtVfZpfkEaxhIjxX/Mt/DWElOCD01KJnv3HKuk0DjyQonRs+BArWT1ZP8J9?=
 =?us-ascii?Q?vrsNtXIXh3O2oih7JwU8qSfCmJVasD+zI0FogHuaYyjgISLakQq7iREMpjGB?=
 =?us-ascii?Q?hlAaH74shItC826AUOAzLUg4lHCxOSHm8Q+0ny3f8l9yguX6A5uPX5t84Ff+?=
 =?us-ascii?Q?oiM9oHXNIlBn9+8NSs7ZmEza5dLIQv6CvsthZT8hs9lposYeBYoG72Ou+SyO?=
 =?us-ascii?Q?DznaiO0HhIKsQ8OqpUojzteInqEQNz6CsVM/nYS33E8scI80ct5nMPOEhxMq?=
 =?us-ascii?Q?CO7gqyuHWSIvXBDO8ILBY2CyzgJANBe5sGEm/WmE/z1esGoK7/K4IS3s1Yx2?=
 =?us-ascii?Q?bxiruqELA8Y+2Ct4GyK4Y9F/EnaJZhxGSexcQwSy8YZHi0gLz/FitJgJBlIl?=
 =?us-ascii?Q?9LN5JCg0WCvH7w1FdVURzAChS5kQodOd6gJOzU/+DmXgJK4syezsVuuJlDez?=
 =?us-ascii?Q?DlwEUGRr112n4MxvUzkg97mGEEnNBieqE1OoZhYPljUi531VfSyBX2l8Orp3?=
 =?us-ascii?Q?3ldaDw7OPHkICvIghs1sV2FmtrwKMMSntokRoCujZntfF79YKAnTd1Nbou7u?=
 =?us-ascii?Q?8qGpFb0Heemdw4zVEP/DRqkjNyffbWqEIOujQ/RfAzHlhGsOXdyUk3UhXwoM?=
 =?us-ascii?Q?MMcMC+yft0TaV5j4Zxs0sEd47ZoVlOoW6gMEZHiSn/xCMItmFOP4us2TPA9c?=
 =?us-ascii?Q?DRuIoOIfr4SVtErIMUTA8Klra99eAsMZBiLTlhv9NoCc+zg5/3gnc/e20ldv?=
 =?us-ascii?Q?NoZBeHx2X9Lfhv8Gck8GaRQ/y9rHYBLxYeHdTJqVlVBtN8Y4MT0fTZgHlxUA?=
 =?us-ascii?Q?6R0yqYT9KcKf71CSBiyv9LyKpAjMFKP7Oe+6LHdDeFExu4Oa9PpumCBKYC0p?=
 =?us-ascii?Q?zoMJU/4AJiTuniENgaFj+ftLexFGM8TiY0Cz6XMz/nFwd38AdgMnvIaeYCQK?=
 =?us-ascii?Q?iutnLYxjKC3oIYgUmOM64HXlrg5huV9GL4Zoavm4QEgvPykpFLIDPgeI3BNv?=
 =?us-ascii?Q?uiyrnn6O/1vuvB5cLoyZS2aoqH/vHBkSJ0KikGmcn0riIUA/AwiQ3NV4vtrl?=
 =?us-ascii?Q?U8TXgVTarKWWHd2r44cxw+fGAX5agKZWQRac8IZGmcJZAsXj2MSxA8x5947p?=
 =?us-ascii?Q?ePvPfAOhX1kCZ0DqX3XXg1ZvAZg5QGJ+4iiFl9MA7yMFN5tgrtImy8Vz9PCj?=
 =?us-ascii?Q?Eob72OmGEVISeyNzRB2JivwHtxreHzwxm60EHstbE07MX2egO+TmbxeehUii?=
 =?us-ascii?Q?TYb238I4NA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ab3cfb-af9a-4487-74af-08da2c8fcc4d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 23:02:14.7951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2DE3sBOHCF9DK97LqsH5ndvR33Ud9suYD4F8BaNNbUudq2JlCu5SlMmHdRNQBTq0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5360
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022 at 07:04:47PM -0300, Jason Gunthorpe wrote:
> > Ah great, implicit limitations not reported to the user that I hadn't
> > even guessed!  How does a user learn about any limitations in the
> > number of ranges or size of each range?
> 
> There is some limit of number of ranges and total aggregate address
> space, you think we should report rather than try-and-fail?
> 
> I guess total address space and total number of ranges is easy to
> report, but I don't quite know what userspace will do with it?

Actually, I recall now, the idea was that the driver would sort this
out.

So, userspace would pass in whatever ranges it wanted and if the
device could do only. say 4, then the driver would merge adjacent
ranges till there were only 4 - and limit each range to any device
limit there may be and so on and so forth.

If the result was unfittable then it fails and the only thing
userspace can do is try with less.

So, if userspace wants to do 'minimal + extra for hotplug' then on
failure it should try 'minimal' and on failure of that give up
completely.

Then we don't have to try and catalog all the weird device choices we
might need into some query function.

Yishahi, this concept should be called out in the documentation, and
we probably need some core code to pull the ranges into an interval
tree and validate they are non-overlapping and so forth

Jason
