Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40C47876C2
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242530AbjHXRTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 13:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242877AbjHXRT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 13:19:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A57DE50;
        Thu, 24 Aug 2023 10:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692897567; x=1724433567;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A2beWjMBighyWStEZ4/zk5smuemmv2H6PoS6KLaCo2Q=;
  b=b1jPuwrB5io2EvTVA8wEtm60j0lch9jwgnRk8vCEY0PkIntIqDZ84Ww8
   irCE9Q4DMEkR7rlOnandTSjGMbpfeZ3b5ahSELd6yVgj+CMcLtITBONHM
   kZneZl8mMtXcINFjOF2cmsrLR7z4FhbfOOLajcbt0DefkfV2pYM8+y+L+
   gKlF6Bz5pqmLi8qO8FcseW1nreZGoNtGO/LkhpW4LCD7H3K5msOB+qquh
   icZT5LTsEtNLefsHqxAldZOC69hIsxK/x60SdcRfZ4+CFPGnh2xjhj56S
   8MwW4M4Tc3Ef+7z09MXTC5tSxWEkDKky9aI97tua3q6InLvlapT6NRNZ4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="373381124"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="373381124"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 10:19:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="827246382"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="827246382"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Aug 2023 10:19:16 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 10:19:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 10:19:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 10:19:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7ixD6pJIRoFJ2NdOGJGdgmiS6eQJ87eIsWPcOhpShH8E14trx7KBXM0Sr8OgwehuYCh3fukGqJNJe5uTcVU5gu5rf0rm9C2rhkVFiSKI+PeN+gYrXup3aP+u4gED29ttK7uK0ekF6FFRWfniN+mhDz/BdVnCSbqRAG2mFc/9cH9WjwoXSOOKTqHkH/tcyU00hfASgZvTKo59htQEeQCMKotu3g1hjfXFK+hsLBPgNIZO7kW6CqOx116SvWMKU+7L/UZ58ZTpRj08f3HN6XEPnamvGhZlLAjghtfGOSdQJxcfRRcOBRb22CwE2PFZ4kUm9XLCQetwMxZOcPQ+fqzag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hKMxWOwF0NZSvEJHn09Wps+QR7UnyL81up5F65Qh8c=;
 b=XH7Dx1DNwlk0rlce50iDgH3zPhYwyRROlOOmiKe4pjkHiusrAaYxHKJVO6zq2FhJLcfWHOXKLo7ncqhYuT/i14yIA6VZ0lif/pV0ulfgy1w/kYHWLC42kowJF/vhjqq6CJo1Y5H1QUxXQb9UEMz+xTiCh17r1+QWlp0LsRd0DSsjWZDX2QOGR6vr9h11z+PLANP/LOGngE6bwj1/gPmlVAoAaA3G1HZd/eg1N8m0+uag9Im01imePtXqMgnlNYrR8FK1rPITn46XNStI27mtGB2M4/oT6MEkMLhVvIxE3iPWVCDBhNLFvzwzgonZPHbKBeytAVdA9o6rpBn6KeBwKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB5455.namprd11.prod.outlook.com (2603:10b6:5:39b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 17:19:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::47e:3e1f:bef4:20e0]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::47e:3e1f:bef4:20e0%3]) with mapi id 15.20.6699.027; Thu, 24 Aug 2023
 17:19:06 +0000
Message-ID: <84629316-dafa-9f4e-89e9-40ccaee016de@intel.com>
Date:   Thu, 24 Aug 2023 10:19:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [RFC PATCH 2/3] vfio/ims: Support emulated interrupts
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <dave.jiang@intel.com>,
        <jing2.liu@intel.com>, <ashok.raj@intel.com>,
        <fenghua.yu@intel.com>, <tom.zanussi@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
References: <cover.1692892275.git.reinette.chatre@intel.com>
 <7a08c41e1825095814f8c35854d3938c084b2368.1692892275.git.reinette.chatre@intel.com>
 <ZOeGQrRCqf87Joec@nvidia.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZOeGQrRCqf87Joec@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0309.namprd03.prod.outlook.com
 (2603:10b6:303:dd::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB5455:EE_
X-MS-Office365-Filtering-Correlation-Id: 6872073e-7177-474c-ddc5-08dba4c63828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P0Lcx4IPWff1dGa53EBR+X+lytfJKkIUgfNK8icAmPr3SDH0nVq2XZVtYEAr+XDNuMoxhY6XToyZwosbbDeH1GprCjSw+NG1eHPVZ0Ee279FhJS1N8YVE9S1Ps1q6LYvYUHOfED5xPOYTlzXBh046/Xj8FH0f/GYYlMAoA/6IE6qHikETlEW8ZF5nLt4KiPNl/Q9LtsPA/elbiU4pgfALuvOc6yu2TzcRhsz3TsWdfRrgBZUHSq0eNftKd4Ytn10eBAfx33sFZt3UQPrHtg/Wh9kt+pB5qobDPRmrMCjlSDfkRDp9lu3ielwKlknsS5VEA0dZi3DOTt2TNmwnOf+Ty1llRbaXmewcy1gevGEpb/CtbEcwxqYE2eFif7wC0xBKq2I+z5Yc/MjMGsUqbFmPyawyIxe8WbKWszORI9bh5worE7FKinh6VopY7fm7/Pu6geQ4iJSKvS9+5J+sLWCMu7BaGQg4DR9jvWwH3YJ1uaerl4kFCfv02B+Oz8wt04njWu12LSHGdLTWnK4kZMFVa+8mdCrD8FNblyU+ZxSaH1n4IQo1qqH6tX97SMtsme2jNl8vr9J7SydKshS5+WS4A6pfkaTbupFRWj7Uze57dgLLt3Qfz0e4+T27qQymDm5hjOB7yj0Xha2bj4fkpXr8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(186009)(1800799009)(451199024)(2616005)(5660300002)(8676002)(8936002)(4326008)(36756003)(83380400001)(44832011)(26005)(38100700002)(6666004)(82960400001)(66556008)(66946007)(6916009)(66476007)(316002)(478600001)(31686004)(53546011)(41300700001)(6506007)(6512007)(2906002)(86362001)(6486002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDFEb000Vm1yUmdwRmFXN2NmQi81ZS9qQ0J2YXdxWGZHS21oU2svbGlseEtE?=
 =?utf-8?B?UXFvelNaUlQzdDhoeTFBenVPQXhBNTdHaE4wRFlISHZxZlVhUTlSVmQvTVNP?=
 =?utf-8?B?SlQzYkNSbHArS2hiMVJFU2xld1FDNW0xSVA1NzNYUWltS20xSTZzdEd2S2Jl?=
 =?utf-8?B?NmplU0JGYStybWQvVXBuY3pFOFB5dlpRY3lkVkxlN1EzSkpHZ3JKZVI2YUNr?=
 =?utf-8?B?aStJRC9OaldqVlZWVFBhWUxpN3Bpbko0WlpSakVXQzZjVDZMcEp0ZGZBV044?=
 =?utf-8?B?OXNJSStraHc2Z1R6K0RoczdiZVpBZ2RoUUtTY0ZiYXZHOWl3b3ptbWM0MUx6?=
 =?utf-8?B?WnRtVUZmbUhVZFlOWURQWm9qNmR6cXYzM1JxdTlkUVowRTYzTGwwai9qNGgw?=
 =?utf-8?B?T0lWVkVBaTlKSjE4MGFkYVVrandxS01JNFBjekV4cU43aG9XL1BhbVJGT283?=
 =?utf-8?B?WENiMXNCOHhhclBXU2tTMWw1MFFtYjFTRGFDa0JqQkU1TldITE5rVkdwVS9y?=
 =?utf-8?B?S2FTMDVXUllXRTZ2RzdIMUk2d2V5bWhQc05rTzNtN1NNNnBlRjgzUHI0elpw?=
 =?utf-8?B?VWIvSU5iRmk5bjZMSFZZSFBscFhyNjFMUHpFVXZ0WUhIbStGc3Z3eUNTdm9I?=
 =?utf-8?B?WlVSdWE2K0NRZW0rVUVGNkRUYy9zZjRhNXYwclgrWXY2L3ZrdkwxcjZXQk1Q?=
 =?utf-8?B?cjVJTUR2aHlsdlhVaDJZSWFpQnVYcDFjSW92UkNaZmI1dzlmdG5PWmlsdUpF?=
 =?utf-8?B?VFcwdHNPQUxydmV1eHdNQ01zOVFhQkROMWpady9yWVlDZW8wTStndHdIYTF4?=
 =?utf-8?B?V2hSQXFvMnk2dkN2bXhGTmpSODZLYWFBeU5ySnZWQnNpSk1NT2NxbFN4aE01?=
 =?utf-8?B?c3lTSzJKdHRZNnNsalZSM2Y4NVdDd1BZbmhzUXBHR0x4ZGd3K1MxR2tGdmpp?=
 =?utf-8?B?WkxMWldkSUMrMmpnZkVoQWwzbGxXTzRxakhzRm1TOTFHV0FqR0lTUlN4Zlcv?=
 =?utf-8?B?d1pQMnBTcHdOU0l3ak0zOE9mNDFSQlJkYnBtcEFwTDkvazNLWllJNjJRYmkw?=
 =?utf-8?B?YXdIeTNLY2UzS3lYSFUzOWFsaXc1eHcwQjA0c3NCOTV1MDRjR2NlUkI0QitO?=
 =?utf-8?B?R0VyUmNTNEJORkl4YnBmbEhnUkcxM2prRGswMU8xbXVaYTFQdXJwKzA0c0g5?=
 =?utf-8?B?QmxOcVV5cXVxVFI0dDNqdVhkTDdUQTVuTkpKMEdYZFduZk8yODhtS3hqZHFk?=
 =?utf-8?B?L2NOdVE1M1djckg1TkpBTUlxbllGQS82Rmg0Y2huVzVmdUIrZmEveEJ1YlFB?=
 =?utf-8?B?MzhiUGQ3RUVkMDJjY3hkMHFqeHJ1b2VCTGVEZzRETnZlb2wvQVlybUhteVVE?=
 =?utf-8?B?cWF0aGI4VDJVa2FXenJ2UkxYMmFVVEV2YXIyUlZqOElJR2I4OUtOL1hLaVlr?=
 =?utf-8?B?SHRXdFRDUVBrdnNkVVczWWkvekZEb01UNjN3MmFhNmRaTnFBN3pQTGs5U2pF?=
 =?utf-8?B?ZzMrUUx5blRFZEtZOGpRdzhHVXM4enhHMXNzUWE1SVpIMWJuc1BTaGZ6NSsz?=
 =?utf-8?B?b3pxY2Vxc2drQm5BNjdQMDZWK045eU55WG5odmsvS2JIWGFiZnRreXdIdmEr?=
 =?utf-8?B?UEh2Y2U2R0RYNk82VEpxMGhKQTBOcUJ2VkVwelpOc3hya2FIaGJBMXgyaUov?=
 =?utf-8?B?MDZnNSt4VXlGc0Y2Y2tFWGdHK0ttYUt2OTZzckZXTWlBZ203eUxXdUR3citX?=
 =?utf-8?B?aG1mSnNjS2lrUEVzdVZtZ3M1MEFCcnlqZnAzWC9aVGpUMTNJVk5QWjZENHd1?=
 =?utf-8?B?SjRnNDZqblFmR1ZlamN6ZXBUcmV6R0U1TFBSTUFWUUVYV21KdTZoTmg3ZlZs?=
 =?utf-8?B?R3dDN0JIcnZoditaM2JkRXVrUzBnamFhWERZb25Ib2ZiVlNYV3hBVlU0NFVG?=
 =?utf-8?B?dWRQVDl6OHFLTXB0bElvbW1jc2JFc2FpQ2dhV1dDTndUS2p2dWhSWG5zeWQ0?=
 =?utf-8?B?M3ZUc2FaR1BmOWFUa1JCZTZBdGhFTEZxU2ZPVnNMUW1LRmoxQTQwRThidFBh?=
 =?utf-8?B?dWh6TmFPcVRmRDBvL2NFeWNjSnk1ejdLUmgxdldkb0E2TXJ6MzNta1lZNFpG?=
 =?utf-8?B?RHppSElDdTdnQ3RadzRZMDN5QTI1Rnc5Tlo5eExtVWlsRC8veUxwYk52N3ox?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6872073e-7177-474c-ddc5-08dba4c63828
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2023 17:19:05.7503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdLZa6mktth7nEhgYF7yGYyL6zcct/m9ATK2lRzAFGZdzG+G/OLoz2aRvzhHbae3Nx8giSdCqv+dOXggROVLOW2FbSvT5dL1jkusHXV7Trs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5455
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 8/24/2023 9:33 AM, Jason Gunthorpe wrote:
> On Thu, Aug 24, 2023 at 09:15:21AM -0700, Reinette Chatre wrote:
>> Access from a guest to a virtual device may be either 'direct-path',
>> where the guest interacts directly with the underlying hardware,
>> or 'intercepted path' where the virtual device emulates operations.
>>
>> Support emulated interrupts that can be used to handle 'intercepted
>> path' operations. For example, a virtual device may use 'intercepted
>> path' for configuration. Doing so, configuration requests intercepted
>> by the virtual device driver are handled within the virtual device
>> driver with completion signaled to the guest without interacting with
>> the underlying hardware.
> 
> Why does this have anything to do with IMS? I thought the point here
> was that IMS was some back end to the MSI-X emulation - should a
> purely emulated interrupt logically be part of the MSI code, not IMS?

You are correct, an emulated interrupt is not unique to IMS.

The target usage of this library is by pure(?) VFIO devices (struct
vfio_device). These are virtual devices that are composed by separate
VFIO drivers. For example, a single resource of an accelerator device
can be composed into a stand-alone virtual device for use by a guest.

Through its API and implementation the current VFIO MSI
code expects to work with actual PCI devices (struct
vfio_pci_core_device). With the target usage not being an
actual PCI device the VFIO MSI code was not found to be a good
fit and thus this implementation does not build on current MSI
support.

Reinette
