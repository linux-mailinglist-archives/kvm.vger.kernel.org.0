Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA75E67573C
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 15:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjATOd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 09:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjATOd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 09:33:58 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540156A331
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 06:33:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNnOz6YbN9g0fGguWYN98jvIgr0aUkMMnCduuDC3xY6uOonMcHBhuLy0RHxVzJzyDtqo7wvuG3T4ji/IdKQ6qrtGtXGFut5YvchmPb0x9mY3hCXA6/580XmRO7kfxmDfKEHOdLBji2R6GVhw1o+/E4w4niw8TYTkAV6FCYkSk/D8yFpmCB0UceYz7i/+byB5r2HBMQmjavlOm7CS401DZV/F2L47p7By+7TYlVsy7AQp1ok2EsFnxzy9WfveBfOlufXYbw+sEmtRkZ5dbNT8Z4rb8dAm76tfH2pwWBDKFVUtUfaq9/6qjOqw/r8t3xOm+oH0daugudqy2PdMO9GUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytm9Kx4t9igM+C4190hC8Kuj4Xf14Uid4Y52/6YP6Gk=;
 b=hwQ6zqEwYvBW+1Ij7PyiYN6RQFdAHUfDsDa5k8YummnEkM6eNaVf59793k4Ki4Yv2wo5XCjafKyEq47IjRRFYwpXZHGCfczHxddfuqGgLv7cuwa5gNMZfK8mjAvMtBWq7L0Ymm9VtbzXe4zmjCdxQNQ9pL7NpzG9C2MaTkMEYaxKCPdTtXCQxyk9M9Ubwq4Ud/b4DHz8EPexGkwkMapSTriy+vW2nCY4dXNexIxwOxjEJyo3GFQKBzCfseANkwhuBJC1ZXOZ87HFMvAQ9lgzwOO8UuMZLWPNl1Gooboyt1e0gDpXejuiSpjCCWpMdtCpVN4xmnUfJ0v4wH3yuQIKZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytm9Kx4t9igM+C4190hC8Kuj4Xf14Uid4Y52/6YP6Gk=;
 b=S3yJTsSfz7haxGARPg0PrqinIpVpBYS/cjQABzFxcbNUrQKv+kYnOEfxupC7SeV93WxIgjypJU+BpO/hjTHYpjBMtppM+WEhHaSis07pDJTTlkEsbIEsM4GGcJR5dWs1yh6zgG0utB8eRLxxqoRUTjf7GGsIK9MWOTgcH24JpIlFlJ4kHBVhklNDDtJl62KD8fa6ZcWjL5pPMJZ3+SG3em3Ujmu4oAoe8XJAdacnf8OxPSBXWCqS6MWxlFNJYyDwtoeXdvdt3pf1JeeZhcV40YQ+cdS6G1LJCONDdUJotdsjrOVUc5kdzOv9d/HTFTv7aOkZoKMaFqfd32eGC+M+fg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB5630.namprd12.prod.outlook.com (2603:10b6:510:146::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 14:33:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Fri, 20 Jan 2023
 14:33:54 +0000
Date:   Fri, 20 Jan 2023 10:33:53 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Message-ID: <Y8qmUa5RORED9Wd/@nvidia.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com>
 <Y8mU1R0lPl1T5koj@nvidia.com>
 <DS0PR11MB752914C92FEFC0DB5278D8D1C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752914C92FEFC0DB5278D8D1C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:208:256::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB5630:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c73ef04-464b-4a3a-d361-08dafaf35b2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tO0BvLdF2sz4iGVoudaWra8ln3UM/szoQfpG6vV+w7OdsAteRzWNOndLTlEVhR3vIT408sVimBQDOXzOtIjG+qboSFVzN5NSeRHUbbMZIM3K3xQmfkJ60j9xYbajUZJCefHxdPuf7guuSwocUkUI6GMiPIalzdl5QKXtAFOKqj3TMEpQoqF9O2RQKaRo7QrCnZUJs13G5xiTKgtBpdv2jSfsfhl+S3oUxrIPhpfpby3/kYlxM8ytN9pjMzL9SlbNiGGamITwQ3llxGwqhYO0v+7HLqGAP1rQNbQxdWsF6NrLFnGTgGYxbFESgnyQqa+yjzSl6GcJHklEoB59YuovmzKNIrUszXW+94xms0DfEveLYQk/fFAelJGBEydA7w1buFvYZ8s5vQ6ZbEVcIWcvIUrobLKrwFVZWI1yOLTUsTN1I7C3bY7cxRY2yJ+tUkLiBQPgLAX9jgSBcPE2mbN7G/yoES3QN39MHjo7d2xi5lNUFdQEE7a9IEH7IPKaJX4ybuc7p4gI1u7wm6ZIG/UhZmGm2N5LZx1esIPBhx/bUibbw4UdiOVtbWHrnln06IeCSw6N9idj1QEI1z1Xa//FLsZsohBXK0OnW4pzMiRQpAnOEy13wAb+Yy6gGPAZrenzHgsQMYzufZVkQQE+Fsf7bQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(451199015)(4744005)(5660300002)(8936002)(4326008)(7416002)(66556008)(8676002)(66946007)(66476007)(6916009)(38100700002)(6506007)(186003)(26005)(6512007)(2906002)(6486002)(36756003)(478600001)(316002)(2616005)(54906003)(83380400001)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CPgr0zGb5kpCZrv/zH4jtI5zmdZwrGGpfAQ/05z56bC5PNm6H5itZcudbxX6?=
 =?us-ascii?Q?65LTlGJ2tCmKE9IYMk+hIpsGSkmgR7yzLhpe7opimJ8FpeZeVqXv9ANO5Bqf?=
 =?us-ascii?Q?2fpYeXRs1FbABvpFHiU+8V6Ltjs3I1sMVTytHzs7eoepyzLvG88LaOxRx34i?=
 =?us-ascii?Q?MOa9+Xs3fWdR+EXc2/Zv29f+c+JQ9NgitQatBIMpuYzIbPWwgL7Ffy2Bf6QP?=
 =?us-ascii?Q?Rj4Km4pk2swkE08mBVE73VTk+i8sYcIffm2U0aIGNcggBDEihXsaNnKZbkgX?=
 =?us-ascii?Q?cKAqWeSrqVCqJFb5+8YhmFo0QgKhfmjwANoP+mNr7ZcDlEO7oBo7yDuRS7nJ?=
 =?us-ascii?Q?P/qLegFu5N+QMWjRM5J8PG2CeDJ3xZ/ZDehkKuEhQIfBwfg15lCbjstdwYMZ?=
 =?us-ascii?Q?aXsu7q3/EzIh9FFDV9fyeQSMm7NmGwJlC17nI5nH2k0adWNXewusRepRuBVn?=
 =?us-ascii?Q?zRe5OKFWxaIgdau6jFy9BWdI7sO4ybpEp91YNqvpx7LoCilG1b7DNVmV5QxI?=
 =?us-ascii?Q?YeaHWQEPK/ItE5SHtmcSLcxG7hR856X9ff+h6J5v+2h8lJKxDMAWs0w2LZLx?=
 =?us-ascii?Q?LmzYDu0OILcDu2t/SS18hPgN7vsjIn5Ppr7JmF36TDqiD9TiRZkdlm9emzt4?=
 =?us-ascii?Q?AIaS2EsYE+7/Fv5XCWkWoQP9Z8mr5h4sgIMSeQHT2WRUc6LM6Rfsi9Xat6Wi?=
 =?us-ascii?Q?jqWl/uDWaRPUOausDH4i+vIZJPVWzzwm6MK3fmZW6Jy7nKDg72YqUww0yIU5?=
 =?us-ascii?Q?SgP8tcrFVx7nXiVzufJ7i8Nk89P4waQR53Po2fHKpYKXcAeyYZOl0XlVb+rO?=
 =?us-ascii?Q?ajA2shI/y2u/F0O4/9NjMwkjnKPkflbQrb7+/hfqXschLR2AVakK2/+kcfkV?=
 =?us-ascii?Q?NpyOZxs+IXIZqzXbByP7sE/CKJa04t02o7LGFPEUPrx4gFHyEXX1HYPZT0t6?=
 =?us-ascii?Q?YL4OM383w8O4B3J+PhmIMQTaXE5Ql8FT3ivxcWdS9mhghsUzFPWdwGBoOZQi?=
 =?us-ascii?Q?LrBbEYlF2tVP0JeBerHRl/dPlffRu9jCNIzr1UGWNILADn/Bkb50ImvzyyQA?=
 =?us-ascii?Q?Gs2Jpni6OWwaE0y/IzU0CMGR+i+f/26WlFRsGAf3At/pwsIkVawB9RC+KjrC?=
 =?us-ascii?Q?seH4uLmvx//GbK3l3y9DEKPr9yHq3KROPo3pDhIG59/7/d7vKAZa8wWfEdyJ?=
 =?us-ascii?Q?FSdi8Y+mZIavtcyDe3i1bHL6/aAodDAWRCPKa22T6KM1ZaQzS685yYG5MsNa?=
 =?us-ascii?Q?Tf20EyJh8gmfKw4WcRijSPpIrvLRZBtPvVIYXT1ryFORM5qX+SV61ShQfUZJ?=
 =?us-ascii?Q?wFNSjpqkFVuFBZYiXQo3tvZaURrvYhYDk2B/CixXr/NQ25C4GeTiR4jQpDdz?=
 =?us-ascii?Q?plec1VTUJM+nRvg+n1yMVo3U6gVT5GhaN9FYMVpOEqhiwMMjp6fZFhuBFXwY?=
 =?us-ascii?Q?0wrglcnszxnAbuAAU0EWttcst8aCLx8IQysTWXsSwS10PT5nmtUxxtCZd7oM?=
 =?us-ascii?Q?nP2LZVp873CFYNFjms2slf/Lbsztkhsg6VQbjrN7WN0SGeCnv0E6uJ0+Kfm6?=
 =?us-ascii?Q?DyA4VXWDc08YJkB28dAEwt4zhHZg15SrdoqJdxtC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c73ef04-464b-4a3a-d361-08dafaf35b2b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:33:54.1348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BxuXyGg8x7zOVKxqjBi2s0wcCYn+F584RzizpwGaZR7FN4aDCXnEOmGCTWkDkXPd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5630
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 02:00:26PM +0000, Liu, Yi L wrote:
> Say in the same time, we have thread B closes device, it will hold
> group_lock first and then calls kvm_put_kvm() which is the last
> reference, then it would loop the kvm-device list. Currently, it is
> not holding kvm_lock. But it also manipulating the kvm-device list,
> should it hold kvm_lock? 

No. When using refcounts if the refcount is 0 it guarantees there are
no other threads that can possibly touch this memory, so any locks
internal to the memory are not required.

Jason
