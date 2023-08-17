Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5A777F037
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 07:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348091AbjHQFc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 01:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348063AbjHQFcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 01:32:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26078198E;
        Wed, 16 Aug 2023 22:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692250335; x=1723786335;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TexmDdrWcJNTLmeGnLXsJY9dzgZ1oU6KJkucO4WWx3A=;
  b=fb4+kNc1WRlwlIOZZH68rfD42cz4x7YCFU4KPTc7jzMCoqd18R8zFDP6
   OvK6InplHYTQXHplzvBdGVJjv9q6SY2y+fklgV9uwJDGWEFhfYUmqM8Xg
   lm1ahyrosz6cfJmQDnzr2fABuRAE/EvvB0iIwqQXAn6PENgmBXUbYimM2
   Dfj+eNjJaEB59/FHBqkJ7loaQ2gwGQ4HT9c+1TA4fVdawNd2H9RV6S3Ul
   GhIhiTAtVs7nSYHvphmglsQ16Fh2WTMTgMRgoPLC84ItVwVcPazpvEClM
   2azJSF48skxuIlSsA92b0N27JXHd0pp9OvjXfkrr0dNpUa0ubcwMNPMdd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="376452935"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="376452935"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 22:32:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="804498772"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="804498772"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 16 Aug 2023 22:32:12 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 22:32:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 22:32:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 22:32:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeLOztkkjq78L0yw6uQLht68oyynw1fFtrrflbgdBD0C247SOzYoFR+eZRQWIlvvAZXADzKWUnXi560MFDVSrJW2JGvjR4NqI+UJZbqdP+37tt5l1W1g+byIckuunqKUYTC1BYXgYQcWSxwtFW4TKXiKV7dZRiGiSZXiz6cPbZwr6nGgDpkAY4knlU4oBZ5sPgcJluWbcaFMlNbGMwanIfuq9BqSqbGGOnFVf9zT8bM/G0zEmypgDDzjXJUlLdP/Ksb3p+P1nXfXlxzcpzRJSdxQeuD+CJzizMHGqbB81+LxtgXIRyQsxeYub7oHQ701LwBqRcDed9DYlPvHyGdY1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=keKgCO5OtbMBMCoT655Vjfq5w6ocqAvV5Jx1EYLc+90=;
 b=a9ymQNby2vdWcHcMlt3zQ2HBQG67MIw3k6gY2uwnqsULkn63r93kW3y/43Kqp1LovIPrRBwDkt2/7wN0L04snbFevWSCh2LLkLMdc5wRYKr+R3KTomHm6QDY/3eO2eWrED5iG2BtnfzVcuhn/YnJ/8ccdRr5jBgWjQDopq9UPaDgPM8UHI9vY1cWrOcNTkX3czeKru+olibMPAiQYSmbq9W/4oRlrRFyt+vJY6A2WhJ5z8o/EpbEU63E6W86rlqYA1CCCcy700GvlypAfj9p2FogRGerM/V/YIPpCDtgkcZnGQGdmOq+nuyvot29LeUuex0M2wJw9/s1mVvTor1lXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5181.namprd11.prod.outlook.com (2603:10b6:a03:2de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Thu, 17 Aug
 2023 05:32:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6678.029; Thu, 17 Aug 2023
 05:32:09 +0000
Date:   Thu, 17 Aug 2023 13:05:07 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     John Hubbard <jhubbard@nvidia.com>
CC:     David Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, Mel Gorman <mgorman@techsingularity.net>,
        <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZN2qg4cPC2hEgtmY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
 <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
 <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
 <ded3c4dc-2df9-2ef2-add0-c17f0cdfaf32@redhat.com>
 <37325c27-223d-400d-bd86-34bdbfb92a5f@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <37325c27-223d-400d-bd86-34bdbfb92a5f@nvidia.com>
X-ClientProxiedBy: SG2PR03CA0091.apcprd03.prod.outlook.com
 (2603:1096:4:7c::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b3b1896-4e6c-48ef-92fc-08db9ee34d45
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fxW9rwpUV+eEFsVbp3F2WvMAzmjYB6fAjgHL30X9wIoDbq2o2D3aHgT3iNTqDK4qtZ2p84TtzbcEUJ6HniByrbRFltaYISyOcTPISwgDbsiuVBwQEunhOxFXTbj9uL2rlIxuRymb6j7phTVQDa2HYtjcL0pTfafPlTLieQfnYFvplwX7Wz9dFgPT+lo4hterBcvtmXEYAfs+VyOh9ltuFJKkl2lzi629rZCGooCCRL4I49yCHKcIZ/zSCLH8/P343mjAvWTwD/JWAmv3tLT4YqauUKI1F/z6xPpaX0wCbBXXVWjeQ4mJL1mXMzZh8bmTsimAZ9f24QZcIHLTKGsHNksdslS9/Q9mqC3AzWKswTM/sIuvfCnbnHBER/GE9jXCJL+tk17EdgM8zJ+9AKn54SOgEvIlo08JvtNNp5VS6nwaNjyvqLx0QK3WvFDSWdxIscudAWjQJ/Z1X6sc+Gw60KPl8jw7L1xC66VZKZaGdiFGIO4QwyQY6UOf6emwNSt8ABBBEAvoc0eiJXAhKp0XYk4ynwO31Pz9PvO2KH1FPSIaBL0h/XBMZ65LUwQqA/So
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(346002)(376002)(1800799009)(451199024)(186009)(2906002)(3450700001)(4744005)(26005)(7416002)(86362001)(478600001)(6506007)(6486002)(6512007)(53546011)(5660300002)(41300700001)(54906003)(316002)(66946007)(66556008)(66476007)(6916009)(4326008)(8676002)(8936002)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lMa3TUzW4rv02GRL8FPdOGvFy/3F/XDWQMrApOsV6KvmInwBGodf256q/ssP?=
 =?us-ascii?Q?IqnX3NfRXWICqo9c/75cYYqMBpHSjCcDQ/R6i9Sbz5IohO/brCL3Hg/gcMV4?=
 =?us-ascii?Q?E8zgYmSvQ2cX1XhRrogacLrkC1C4MIpaftnQrM8vHhnY8AjoHiSMdu1k8YUK?=
 =?us-ascii?Q?20SWbezvEsmlCHwjsGplzVNizdrrucOunyknr0zqIpCUMhxm3aia4dvDPsSh?=
 =?us-ascii?Q?L+yRmWrNyzQCg1eFIQrP4ol8k1PnausWC/7em/L6h4UtiVoU91/ceyj8sPGo?=
 =?us-ascii?Q?GaFz3SlTJD3Cr/bZFEHVD9kBnxy2vxqmVN8MhicJNmS/vDuq211I/Hsr7VHI?=
 =?us-ascii?Q?gNsyAB9tKJuELVJPM+vL0tnHzVwO4XFZCrzL2TpccRL6GOwnE4ZO3qsGPHBN?=
 =?us-ascii?Q?nfwjw+jA4EfqIRlW8sd1vKx6JUUM+H3kJRl6xmYYt5NPGhLC1d/ImiF5TWq9?=
 =?us-ascii?Q?pc/r3CE83Pj9sLaM+BkHmwZgt0441ZWaimUlgfzo7UefAiCGtgFdOta6fQQd?=
 =?us-ascii?Q?gf/f5mh8u09CdOyfuPq7G77rmbR9SvzfYwvZvarXqRJJbZ0P3RTD0eP1DdZP?=
 =?us-ascii?Q?T4XQSnzqJQYbB7q+sOQVcKMQR8AZyoRDvG1W/VGMqig32z5EyLNdDzGSXJOw?=
 =?us-ascii?Q?H7+psr4n6UAufZMx/KlKDeqzVNIf1LS3rXPSbI/lkK3sYoA0tWUT3Fp1a9T1?=
 =?us-ascii?Q?XAIBpnt4yVrVlJWJS2ai2rt5uFmQeKe1lEdiDkCtE03YSZHQoUGKORpqXkBd?=
 =?us-ascii?Q?SJ1z9pNPTZ0iPGUIcKZxfp7haFwF4aj+SyOIoxVeVtkkez/NPLdtHgzlygrc?=
 =?us-ascii?Q?r2j04VcQ+4wF/Xwe7dtsrnN/G34f9D/qiEK0uv4YwKNabv2cyGYwT6ZNkecT?=
 =?us-ascii?Q?ZvQOPbLobjv7EfIMP3LLik50XjFHN9XvgLLwW7aa3KXCEImtqfPI8B+RrvS4?=
 =?us-ascii?Q?e+fYABYxS0pZm65hmQYQ0PUW1ib6CNTCN8uzGlK3S9VWYXaw0S/V2ZADs4Ie?=
 =?us-ascii?Q?iNs91zw2JBqcSCnHIBYPHhz8AHb3C+VmNgpzsTH2uvHTBFxu5DT6pGG0kWfe?=
 =?us-ascii?Q?mvgaaPAnDZXacZns5EtAkYsY4PI9Hcopj2qjJ/YKiBhOnQNOlbVTAxHGxTfy?=
 =?us-ascii?Q?UGig3L6UpgqIecPUyk+TFgaD2ar/uvQz0zYstvgKYKvzZCfR75Dzjg40HqAs?=
 =?us-ascii?Q?T0l6NKp7lxE+bpYZSJEXddERAXqGF0O103Qj5fOHEdqG9ZkWSake0Hkz5/TY?=
 =?us-ascii?Q?xwMESZhfU3SbM42QkCFBaWWu/F9Yr3I4FWBOzZ+bj2FsVK3h6eu9FMUL4TIY?=
 =?us-ascii?Q?SlSvKxT8Jm7YwLPX1NWqLDwxoZexegMuQlgPu3e/x4xPP9ntOVPkO1FhpK6H?=
 =?us-ascii?Q?5yHid66gW1GzR0xFvZ4+36RYLWD4J0BMUN5R5O+Ub43fKx0203QJk90fx9F7?=
 =?us-ascii?Q?SPLNeGKJTUS7N/pn5E+MgQSKewleCcxlJcMFSxIfDsKuI5lFmR0o3ECGmp9c?=
 =?us-ascii?Q?sM5kYTwxkPcOi63fUguAvu9XCCkNptjw5GrVh++puZ6DDsVRu+Jkvd8ze9c5?=
 =?us-ascii?Q?do9uql2GTKH+19xTJ1LliVKP/C8yQUePUxCgM3R5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3b1896-4e6c-48ef-92fc-08db9ee34d45
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 05:32:09.6345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ma5CCtaRDwuGUAOL0m+lTfXA48GYj93BRH9RgNUb6iRepuFOZlj2oj6WteM/3vwLMQ+y5rlw57G/M8CaoKOTOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023 at 11:00:36AM -0700, John Hubbard wrote:
> On 8/16/23 02:49, David Hildenbrand wrote:
> > But do 32bit architectures even care about NUMA hinting? If not, just
> > ignore them ...
> 
> Probably not!
> 
> ...
> > > So, do you mean that let kernel provide a per-VMA allow/disallow
> > > mechanism, and
> > > it's up to the user space to choose between per-VMA and complex way or
> > > global and simpler way?
> > 
> > QEMU could do either way. The question would be if a per-vma settings
> > makes sense for NUMA hinting.
> 
> From our experience with compute on GPUs, a per-mm setting would suffice.
> No need to go all the way to VMA granularity.
> 
After an offline internal discussion, we think a per-mm setting is also
enough for device passthrough in VMs.

BTW, if we want a per-VMA flag, compared to VM_NO_NUMA_BALANCING, do you
think it's of any value to providing a flag like VM_MAYDMA?
Auto NUMA balancing or other components can decide how to use it by
themselves.
