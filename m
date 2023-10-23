Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0215B7D381E
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 15:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjJWNd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 09:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjJWNdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 09:33:12 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCAF199A
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 06:24:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D90rd9fbofB//uGAuTo9U6Vftse4vT3TgsyKt2dm8P+QjN7Ov+hDIhrPQ8hRJiNzYrOofkLuK5JTzUgaq9+kFbGNWwwDyRg+6U+n54o0/n/n4J9JeuevYOf7j1CFY6+0b45zyfTmhxBjI01nUZBy94pNd3ZxPx70vvy54yIlwtnYfh8EQhufkhzwj6XxZVliYesvZr7mdzkDd6+YgRIeKIVOAsPcnRM1d1G5ImE6Z5zC+K0JhbYeb8qPoXxYGY0AE88fd2oA2fEZ/syhVduLJZAKpzc0Kd5l8nBTXrgJ3UluRMOsEIJEJqSr7AEzq6Zb3aH8PtwxkQmFz2z2a5FmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q9OUntM6Lub8OrKg87oe/Cp+HbtT2Wahk5z5c7cnXM8=;
 b=UadFeN8H12kDX+w1StOcYMkye8gHLw+zM/z62oq/9/elIjaSV/zyowueUYiJYenHSLJvmRiJRHf902PI57Y+sd9sLH6b5b/kxB5L5w3AuIw26/9HQFnKZoVDFJ7Suf1JeaMtNe4PGo5FQYOPSAIdWnG+LHX3bxd/uq+o1DAD69m/OMppm6fRnQDK9LUTpaHjcrFLW3F/i68ZNgr8Pwenfq/uQIPBwFu5xauXl/URK0gm1R6CnK3W5F4cRsTWlyQZKuELsJ3HxP2Vg9hSA+Ahfnt4Z+mf8/549q7LhI4vfRzPItFpKGDk3jnsrA2YcY9BnFvwvs7FTByQL9nPpHCNtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9OUntM6Lub8OrKg87oe/Cp+HbtT2Wahk5z5c7cnXM8=;
 b=rTEF9ASzsriW6Dl70sWIgUiV/6N8iXX5Mmdvg7gNcuXFCyPplOBonK1IQLfPZ+9zho/NHZjNEtXj22x8V0hi421JAD9NF4mLsNkbktOScseq5nPfbfXROIysu1wbMT+eliYl1JtJ4kWeK++l5eb58P7/h5z+JUJCvLNdiBMploJDE6PHCzoV4z+5xw6o1HNSch2bh5It0gNdmdHvqjY26+Mgy7O4Ed7G+lzW7q+FsxOW4SXDMXNDkz8lwqQlEw4tiqsNANI5Kp7yUsYnszJ3X+l8/G0bnLCjtibEdypfy6e8pf1RXdANrEPvSPSks+iOY2E6MNgvbDBQnyAcIyZY5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5754.namprd12.prod.outlook.com (2603:10b6:208:391::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 13:24:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 13:24:52 +0000
Date:   Mon, 23 Oct 2023 10:24:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Message-ID: <20231023132451.GU3952@nvidia.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com>
 <ZTXOJGKefAwH70M4@Asurada-Nvidia>
 <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
 <f6f13ff9-ec92-4759-bd0a-9d17a87509cc@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6f13ff9-ec92-4759-bd0a-9d17a87509cc@oracle.com>
X-ClientProxiedBy: SA9PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:806:21::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5754:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cde878b-8664-4597-9012-08dbd3cb70ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKCqFrdgfK4aTSAzSu7LhhRaNvfLmb2LR8k6YJKHBjmnS91wiuUdQy5+lSe4wu3kjp6hF55lwOPyc6B4PS4RDxd50H3QKc+/+KCU1Cu/nRncLCa0TIkyIcCegkNuumvc46nYO74oy5bYLBftaZzlJCexLdvtXTm2OV7LEwrA/NDpDOPiOeNxk3pn327xgPOlNHx8Rwln1QRm51QJrrmlP5rXuK2CW02WmpwI0kfPT/3/gw15xJdulvviPgmM+LMt51K0SvdKjn60mA/cbS6xbyRX1Dxc6o2cURGZ/qbmbhD65CNwRT4HbyYzUL1qF+vRSw5jGkQWvbq2yFGMdIOfs7K5YhqL5fhk1u4JUxPNhflkYeVagPbYJCuRWDPgxrHrzqO39HaKWmxmxvgA9rXmltT9VgUgfTXUaVAF0l+Rb/9NE3V+i2rh4IzlGe9Z6EV1uTe6y8t1oZrerXf5lC9ypDNJ8olLpsq4vagwp5gT5wr45AiDMaZDi1EdY63o1CXGZZzYe5L0Fj0YD2mhN8OgeN8j/Cz63s2BXhaNZ9MbRAcL92OeRe3xIHktvQYiuGwBqMWPsny5izJlXSh8EOF425VutV/yCXRdVd92+SUnGYo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(396003)(136003)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66556008)(5660300002)(2906002)(26005)(33656002)(36756003)(86362001)(7416002)(6506007)(6916009)(478600001)(316002)(6486002)(41300700001)(8676002)(6512007)(1076003)(2616005)(8936002)(4326008)(54906003)(38100700002)(66476007)(66946007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gNI5b8Fbwy1hKJhlbqVRDY6LtC9m63Vq9c7+FFtEk6SvED5gVedc+FXmiCWa?=
 =?us-ascii?Q?i4JD+MtD1pdVX8de0lGsLv6K2mEYzY8PZ+fpnR1Ik5g9c4KqGdGmWvQ5Yzdo?=
 =?us-ascii?Q?h4XLUCvU6jWiccdOl1SvAXrYzsyq5sIxy8u+y0lCjxB1/Syd7Gx0tlHmzs1x?=
 =?us-ascii?Q?D11faVTFvY1fgvzLg9asxrswefjG8+exRmuEkPOkTdwsUIafX3pxD3CJUU9Z?=
 =?us-ascii?Q?Mtny/AJ6mjvCsDoHUFP+QmG2tIYi5iopAckA0KLyKEvVziLrmQRJvzyQXyzj?=
 =?us-ascii?Q?7ycrFXV5JFAuob6mzZkpJ+Bh+cScsq4AWNyxywYGsoXdiIw9tkO1F2GO4uAH?=
 =?us-ascii?Q?tedtBGiNmKI1kwjnLDVp4kis33jGjyx7tFBlbJOF9bVqx0tiyfzpq2KvMfmK?=
 =?us-ascii?Q?RbAza1nlw709xAfLZuQytLVscCyKD2UpIBkZWj1ZRVxln7XrsabQnNAJXUIe?=
 =?us-ascii?Q?9rw7ERJdFIJi3nwJ1nf2Yh4+EVG10Axtc9RvBHp4cEUMTfdN4CAhSI0kdOF5?=
 =?us-ascii?Q?yJi80e8CEp3WuHgUeCgeqBleeI0woTg9y3dGpEJIEosHOOQsPDgUPk+4AocU?=
 =?us-ascii?Q?zcriwUd+kPyXa8fInerlzNZWFoMxElYJyVUaFSe5i6I8melKYLLXYEvoPdhM?=
 =?us-ascii?Q?/LAQIinymCAesV6CxTSqX/BPTmI8NKFTQzdYwz0aFfPuqXtIDgJP3aEFeW6H?=
 =?us-ascii?Q?XQ9u9yTFseh0h/t+RGzLG7r4kXIsx2FFyEuu6dG7wkaIuqQZhYjMsqUinjX7?=
 =?us-ascii?Q?ODU1MmeBa3sH1hnDT7hRsCvUuCfUs1DdTzJDsCMBGZ5iKWXXXBmASWpf9UOE?=
 =?us-ascii?Q?WBShlXSDgCJp+THwP4HsMOdtEePGOlqMFOwMkD3OA29dhcAd8waqYvPnjzzx?=
 =?us-ascii?Q?JsD0+kSAMYGAcSeBBSPYKn/i+op9Z78ufrfq62b837Ok8Nhjas6IzDzPW+To?=
 =?us-ascii?Q?XWz8ocvTQL3AgdAVgx6Ep6ERzmH73bldO3mms8f4lV4kZDYPzk7hCOD6pLI7?=
 =?us-ascii?Q?jj31sKTHLEOnN5V6hWjc1JCP/X2p7lnLaBOm7x2WU9LF/MeZd+RPzVdiQrET?=
 =?us-ascii?Q?Nx5GlqP5umiSkQsYm3s9UAt9gojCYW/Zfh6IKjUYSpUdVcYCOoHsRmWa1xru?=
 =?us-ascii?Q?p5tXE/SRffZjOI5sRTp4BsW+3uiN5XWuxuoKGGWJ46pyYeWuYHgZuWCWGmqP?=
 =?us-ascii?Q?DzzxzNYV0g5hReGk1yyBizJeH30hFn46IXxzoixNZ1PkNGmZp4SB4XxX0Yag?=
 =?us-ascii?Q?Nf21GKIT9O7ajTrXs9UvkKRi3dZw0Mbe8qzHIz++4VxCYtbcaltZbRgGbJ/i?=
 =?us-ascii?Q?hYO+fLAbQ7mIu14nA0osnv+aVPtK1fkpSnkL+X5zXyoWMxzv7U8/qhzQnkjt?=
 =?us-ascii?Q?mGbscIVd5QAF+FpqIikGY7mt+t5wla/UbNZoWgZmTGgY+UjwyozZJlZ5oARu?=
 =?us-ascii?Q?hlpRNZ1IcTGbOHRealRztEEgQe/iu6A9fmsEi8GpRJsMBSaW2u1sy4gp8fdC?=
 =?us-ascii?Q?9NcsUZ3NVc98X6r1zVG4u7yJ2RQDNJMpqV9JlfabVUja7aM1xyeSapjX0giJ?=
 =?us-ascii?Q?QW38cJhphnMXu9Gf3ao=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cde878b-8664-4597-9012-08dbd3cb70ca
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 13:24:52.8320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ozftb23a2QKhFRA5P8YRt90SBzJ+TBZP3l5J68WoUG/uMvy40PTPExXC3RoC3fy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5754
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 12:49:55PM +0100, Joao Martins wrote:

> diff --git a/tools/testing/selftests/iommu/iommufd_utils.h
> b/tools/testing/selftests/iommu/iommufd_utils.h
> index 390563ff7935..6bbcab7fd6ab 100644
> --- a/tools/testing/selftests/iommu/iommufd_utils.h
> +++ b/tools/testing/selftests/iommu/iommufd_utils.h
> @@ -9,8 +9,6 @@
>  #include <sys/ioctl.h>
>  #include <stdint.h>
>  #include <assert.h>
> -#include <linux/bitmap.h>
> -#include <linux/bitops.h>
> 
>  #include "../kselftest_harness.h"
>  #include "../../../../drivers/iommu/iommufd/iommufd_test.h"
> @@ -18,6 +16,24 @@
>  /* Hack to make assertions more readable */
>  #define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD
> 
> +/* Imported from include/asm-generic/bitops/generic-non-atomic.h */
> +#define BITS_PER_BYTE 8
> +#define BITS_PER_LONG __BITS_PER_LONG
> +#define BIT_MASK(nr) (1UL << ((nr) % __BITS_PER_LONG))
> +#define BIT_WORD(nr) ((nr) / __BITS_PER_LONG)
> +
> +static inline void set_bit(unsigned int nr, unsigned long *addr)
> +{
> +       unsigned long mask = BIT_MASK(nr);
> +       unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
> +
> +       *p  |= mask;
> +}
> +
> +static inline bool test_bit(unsigned int nr, unsigned long *addr)
> +{
> +       return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
> +}
> +
>  static void *buffer;
>  static unsigned long BUFFER_SIZE;

This is probably the good option..

Jason
