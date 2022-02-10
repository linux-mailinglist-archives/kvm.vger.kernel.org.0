Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F984B1184
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 16:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243512AbiBJPTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 10:19:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240962AbiBJPTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 10:19:43 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1D21B3;
        Thu, 10 Feb 2022 07:19:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHXe1uq6kxpOcjYmE7nhUMs7TAG8M0fs75bcykeIHy61MieNgHQlg6Ju2cAXc3yg8B5z6Qr6E44DNO0cll/B7SUgHJ/UWG7pK2hN/qfYG2RxoJTHIW/aSswZ8GCpCL4JQ8tl9SPZ4fbiPuH0Xg/WO4ZByjAA81YuZs3EXiN1IQFVJigffroiMyu2hiKvTJKmnOlPQHO5O2Piz5ajvG4y68w0tC5v5wVDCV9uACF0q7kXSSCn3oUzyVKb+Zm4D6YWC6iPv0moaSkbU5IOSciiHfTHtH83zUlnOYSHGbn29O6V7PudbFehSZ1tU8hxvKIipEat6qe850oOKw4n/gP31w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JahQeji3OuvM56DoxaAVbiIPaY6NuaZsESyUFpu0Ld4=;
 b=gR46qjnsuDX9C2bAvhfauk0OgIoc7bZZrlmpSWq+Av9K72DaQyFRiiezp4K0XodupiAYbBpydBJTn4fxhoYYTSncG8rsuBXeBZyxCxFoLkbTdxKoPhrsyKplMNOQnl2BI2AxCNNOb7OTOL0KW9WQlVhI4hWfRInRyeq5dLC8VzI7w4fV8rOQzZ4lPYCXJaJ5OG19ZThuorHaVfzIpPQjtylRlxuGAV2aPCCcWwyDCfhUoh6Da3dWNE8qS2Ldtje8fhWWvTMZSfiY+ciaeXwcxVoX95HIb88K95L36CknaiGYs1egBlOqzUQFJczlRYH4vxvpV1yL8SJkHmul1gYH7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JahQeji3OuvM56DoxaAVbiIPaY6NuaZsESyUFpu0Ld4=;
 b=lq9B0mGkJ0kKBEnQ4BdPSKou1lGmtImYgHozqNcUaE5QrinUKySdSHjLXU7h3cq+3fDNmnxl1jrY3T3e17DvcoVtDJfT4kDqMTNUEa8c6dKNOEQbR3iilpuTICihKbmnNj0e/uCsLPGaz4SdqvasHzcbcpW2dV67EeFYvK7ilATXiFVt7ikBYhcct9qwxma+fPxrJwHwyvKIrTfb1/X9PZuWGv5XJDKvSaO++2odUI8krljhxyhDaPUGAoNr8QkaQ45EUXhml8Ecc0Iyfd3EcZAXuy8nm5KzoCScT2FrvnzbJ97abU+kqveOSPf/54h4fAGdhYMo82dkwuh7tHDNWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3355.namprd12.prod.outlook.com (2603:10b6:5:115::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 15:19:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 15:19:42 +0000
Date:   Thu, 10 Feb 2022 11:19:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v4 5/8] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Message-ID: <20220210151940.GA446748@nvidia.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
 <20220208133425.1096-6-shameerali.kolothum.thodi@huawei.com>
 <20220209144137.3770d914.alex.williamson@redhat.com>
 <5269a28bf55f4a44b23e6f59d0d5b86b@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5269a28bf55f4a44b23e6f59d0d5b86b@huawei.com>
X-ClientProxiedBy: BLAPR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:208:32d::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d749f466-115b-4f33-979c-08d9eca8c2df
X-MS-TrafficTypeDiagnostic: DM6PR12MB3355:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB33558635D74758AEFF51968BC22F9@DM6PR12MB3355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wm2/LV2CUj4+fHLJNOUwDGs1afdj6YIMtgVL5Mt4mHfMEA0DA2CQwElEpjys1CNAuEdtoIKPw+5pfRbSiTZAahVrM3azaM71ux4D5+/1o3PKWCqjy5xgvGGh3zIeIcVpfaDzVskaWNIY+X/M8lKV//og/TkfQAqhdAgG9i/oPJvi3Kv/nYMBLSLHN4EOQ3TJ0S7rRIiwkqwzkPx0JvRoPtEXKZ+/k9v2we2j31iD3Fi0THQYIbI/5v/B3VHbTM3GjIqZWn1YRgZUPQs/Awqe5ZryeMY3cNpOrbkz4+uQv/4P8g4gajwHc1x9xnX+Ct1ZPXXLKI+7OsawQPe4mldqx5PtL2AP65AXfdgGfWsHNnOTREGwSiAeZj+dgdxOURZyqorhxQJJ7ovTLpCNM/LG31h5AbIlphTO6iHnJNwqLF/fnB/HhCbpsqHtxjP1WCZcFLFAJurEiSzGC7gERc05ZaX7HFX0KGemmWv0uVkySld4E1+BaqttSLoyzsdziqPyhEC8cpUUgjb3o/i3p7BBJeQwyPBOC58kEtsecF0JjwdlvGVKWXRW/ElGce/alntCf+Pk7KtSnQrNYETNW1WiRZM5y+7XVfAStkJs4HW+wdmYvxJWktfBf5tKLcj3zURgmhmJHISp6zZw+rd6MZtcjN5Ug2em/qE4oo6jRoyLKHnd1HGJyewBgmFxpxE0lrdxPTZed5UYk4ksLdVxmXtOgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(7416002)(38100700002)(508600001)(1076003)(8936002)(33656002)(186003)(26005)(86362001)(2616005)(6506007)(2906002)(4744005)(6512007)(66946007)(6486002)(36756003)(316002)(83380400001)(6916009)(54906003)(66556008)(66476007)(8676002)(4326008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JH1hjd1XBttRsSS7bwy3gDj63e/rmQh4yfG/fFDJjyBSJXL+Ia1wMAiNhZku?=
 =?us-ascii?Q?HIKqjmRBY1kfIyjz62SxtyTpGs1tXt4ZAly7qe5XFWQEtFddGyYLy/Hvc7Vk?=
 =?us-ascii?Q?p2BtlR60n1QlMZ2PZ6Hov0pl1+KQX7vhHn/ao26ICN3JIB7EhKKNRkKovwTV?=
 =?us-ascii?Q?FMu7ovm3R3gPXfhijm1ovHQtlypYBgunbf5OvubWkADKNeL7cywYnrjqAb4d?=
 =?us-ascii?Q?KlLgpBS8xu2rG+5hDofF7HDp9QjaL+sD3DdhAUAHdh1+StMfSL2aE1GtzGj0?=
 =?us-ascii?Q?c1y05VmhvsXSp/zC8yIs3W/KF45bxTc/swbRUMev/K5lPiWM+StdySFUUEmD?=
 =?us-ascii?Q?8/J9Dspa/P/HrTq8nasM0HDUbwv7my1KliQQ3NyOcFjIvXtXoc9kTo5lrvak?=
 =?us-ascii?Q?TVz/54RU0SpRz7vC0KHEvoWx3zGZFAzljq2miKYtpn0VVN347K5f/VKYihhz?=
 =?us-ascii?Q?MSJqzEnVZMCDqFol+fWTAR5do6YycMHLQ5/v5xV2YaaUBshjcr14WpjtMrPo?=
 =?us-ascii?Q?CjgabVud83Y6np/CT9BVgiQzMU0MEz/v3W6IadwLl5BxFwa+cUhTH9ZbN+La?=
 =?us-ascii?Q?0rZIAi/rpn5hjl6MydVX6FgnojaJVhbT1WQo9ceLPgjMRrU/SBkwIRlvrdmd?=
 =?us-ascii?Q?zlKT5++ny4s0JjERr02rEBh7XEmt5MKacA7DMc5XsEs21aAm0wok4MCXw6zE?=
 =?us-ascii?Q?Fo7W88UHLBqUuf3qkwl3grHSOYJlI50xrqjae5LdxWCcAwzLJNx01WSTiAnE?=
 =?us-ascii?Q?OF6qtAfyNxCPOSrbqF6VJP/CG4X69j8IjZhvwcluSjp0uv9sLgq77ayQ45Rk?=
 =?us-ascii?Q?LFh9ECOj3xyFsprpcrIvRkbrSMUhli/43ieDrAS1YxBzqKqTS+hxwfjzXasD?=
 =?us-ascii?Q?68Wkq4Xz8mHf24ERQk64HfhalpPQNj1iTIe33L99EwOnT+CYtGL0vYaQ5m8t?=
 =?us-ascii?Q?uRVGU7WU5ScFE3L0U6X144HKTryG0L1SsKDa8tcYa0llGjH/+A2zqWtxLLQS?=
 =?us-ascii?Q?BhmDLVf2H2z7YHzWXPpFO6n8Ec+1SVtGa02qWNN1ZfSKlmKGDl26vMk1x0HT?=
 =?us-ascii?Q?pdBjsF3TqTsXTIbimFDo/WMwFxwMFxNVU8sYIbAoldx69UZ3nar6RJI3Cuc0?=
 =?us-ascii?Q?RQmKFnVTdq/ndOPLwtL/y6WUUSAiqLZYDACP0Hz4cYec1Avgv/gl37BXqSWA?=
 =?us-ascii?Q?PV1n9GDOidXOCAJGeqZgzMi2sVtnBkQxZ8vw5P3tNhIq/JUClPf8jBFRGRiw?=
 =?us-ascii?Q?LuC8HSTH9Lp/W5q4hyBQm2kdxqOe5d/54Ks9nm8PG9ZT3UxqO8uP0QIXO7oQ?=
 =?us-ascii?Q?PeDFEeRhmC8FZXbrCbXYOxZEBX+YiEQvr8oRsWbWCiw44XUJ3kBMbLFiE2VB?=
 =?us-ascii?Q?YdByg5ff+TAf97peQqJU4zEGUqg+nb4xkTAWfitqXwcdZyASQmZ4Jst8wFHN?=
 =?us-ascii?Q?01mw0Tn+1Ji4ZUitjoS/a5IrAZEIcYfDXc0c1bUkwe563RbyI8XIzl6B1Q92?=
 =?us-ascii?Q?gSER2/8TF8CSr4ta/2mpfcYGlEAzSAMD2EgIG+tNvFqUBT/gaWSfywiAcVtJ?=
 =?us-ascii?Q?wV6Y+mLPpG4v0aG5RNM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d749f466-115b-4f33-979c-08d9eca8c2df
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:19:41.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vsFwncXj9d1hzxiZNuiyZeW7Rt3hiiJ8/ASoh0QKvnaOgr1vYRzWK7ELgEd9Ql6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3355
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022 at 03:01:50PM +0000, Shameerali Kolothum Thodi wrote:
> > > +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> > > +	struct vfio_pci_core_device *vdev =
> > > +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > > +
> > > +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> > > +		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> > > +		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
> > 
> > Be careful here, there are nested assignment use cases.  This can only
> > survive one level of assignment before we've restricted more than we
> > intended.  If migration support is dependent on PF access, can we use
> > that to determine when to when to expose only half the BAR and when to
> > expose the full BAR?
> 
> Ok. I will add a check here.

You might be better to just install a different ops when migration is
not supported, none of this stuff should be actived in that case.

Jason
