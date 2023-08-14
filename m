Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D566777B3D1
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 10:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbjHNITu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 04:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbjHNITa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 04:19:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070A4A6;
        Mon, 14 Aug 2023 01:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692001169; x=1723537169;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=rVCjc/6zsnoZ46Q+4P+okxXcPzawKudDJ9ym6nw1LL0=;
  b=fJLGTtr4c+Qj2WQCM1/NepQPKQYC/zOxR25X+BcCmFbef9UhAVrEADT+
   UKJU/a0t/uKMgwH83UsmePEhNREOclP9fhR1F+OirCLVfNZ4r1whhZ9fB
   4EDemaoT6msitK8uG8dwbad7aTxVIUIPlJK73DZntkr6VM2VyGB1iqWeO
   QO+X4w3c3RncwVJ7v8MrNO1onVBKkkT7lg9Bt30AzbjOXSwvVLSQzFRKR
   CGAgD41kkGKCxQxro2GNQaC5n0fj4OzeLqwWmWVRpo9NJMtithKp9US+W
   U5nzmVfSfYOHVHCTWFS2+fmndvtt44u2f2CRqBuw8rFRldzNs+r6gyFqH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="351587117"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="351587117"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 01:19:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="876872038"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 14 Aug 2023 01:19:32 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 01:19:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 01:19:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 01:19:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiuVKWoMw5fMPgTgS3aEjQ60j6ecAr92X1vRPDXxhLT1B34VYu4XHbxAyt/K18rtRCJPbJvcPvYDwpn8L8OrLC1cKkffgnbt9bLMQaqdM+fmAFMh4+nzrTzGwjoTCrw/R/IN32zkbcuxqsU2QVALkPnHTL55PaK8Ry+XmJsjr5Jb5p9xKvBYK6KrAgq+eDoKE97TaDXOzA8e/VM4NSYG9nOQ5DqXisgF2gNSYh2dYTr2lLiKtBPP2wWKgwqmA/Nuj2b3yhFBlyydOcsgvNrQ2wo39+wEXJA039MbhDwwvuSjnfM470L8chJz9rLAfjehNB4s1xCfM1nz9AaorJzDJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kv1g5OAGtqH13XBtMDiogm+44Yp3oZ746WbQ85Trac8=;
 b=B177voqi6lUuFOx1MWsxWw1RFWaT/tEC9zKGWRrS3h2EUOCuaW3r3G7v6ltrVRcgAnVmJOW6fTttxXEbZ0NOF8PiLRCWYVteH5P1TTE2lMxGd5arHW6O/Bc6JfnIpiiDzLnLGMUWortV2awBgu2rldQGvnhYaj3Y2LPnJCU454HSrE4WkGlc6ZjylkmoWzG1ezlfuxxckXIQfn0dGgphm65zcRCQMsu6dbRfP2fY7BhM2h8DJHA6ML8QscrOPSVbZK0pX+t+u+lVi8mcCNbKGNh46PiXr0jKaVKwlZMlOhE5EsvAi8h7v3C/D+awiTJGCYbAMt2CBE648bdlAsND+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6651.namprd11.prod.outlook.com (2603:10b6:510:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 08:19:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Mon, 14 Aug 2023
 08:19:26 +0000
Date:   Mon, 14 Aug 2023 15:52:26 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
CC:     linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>, <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, <david@redhat.com>
Subject: Re: [RFC PATCH v2 4/5] mm/autonuma: call .numa_protect() when page
 is protected for NUMA migrate
Message-ID: <ZNndOm4EW5eIokJJ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090048.26184-1-yan.y.zhao@intel.com>
 <8735E3A2-795B-4D52-9634-D48C68645A5D@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8735E3A2-795B-4D52-9634-D48C68645A5D@gmail.com>
X-ClientProxiedBy: KL1PR01CA0091.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c3964fb-aa30-468c-7bd2-08db9c9f2c6e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4jw677mQmVwLngqbxH3XBye9g2S8iKT9rXQntFcMqPmJS9yKc13SMBizMJrxCUuYhfJ0ScSsOCOaCy2Q452X4VGSQJCqZQMXJOoMcD58qXffgx9J1ZfntBtX9V7Mq34Ms+BgrUihYRLLrbu8JUVipjWTiHSZxR/hOYhOwGXUMm7Y2e9RfNDzpUSwUFJKvRY/nuxIyrOUaD6Qj9eayNzdC4Z1z4TJEwoZyE71vQMk99IVe53SVffoU2uqz7+3pxYL7MKyp61bFca91Glevcy8Qy/Ko5zhlhPYbnCBsuZxTCbv/BPSMr+M4eTBU//+i75iEZKyg+ou2Pca5HnFadO/RQ7rMmBr9OXVoeqmSOs8u4vvgTKoYLGynh1z8KLHBl7gZfHFdxeUUtio8wryFf2/8Ef39eC4yAhavDH5dA9rgNcH90TMcxP3Bhfz9BxUgZxXEIveD4Gi9qjNp/Gct4YrnUTNnWTN6fIlaY6yoC6KoJrsYdR5HSOqA7U9P9/HCnxOWQP66i0r1jWneOZPYhDEyzE/AGoRfjbjRYxDk97dpCdtkixyEh1RGsBU92PTjczeP2pEwQWQsQVm6f7TLZsBlTrxdC4icRqq5gCOyCVnebNHCOOs71BOR7a8oKIsQmre
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(366004)(136003)(186006)(1800799006)(451199021)(6506007)(6512007)(53546011)(6486002)(478600001)(3450700001)(4744005)(2906002)(26005)(7416002)(54906003)(6916009)(41300700001)(66556008)(316002)(66946007)(66476007)(5660300002)(4326008)(8676002)(8936002)(86362001)(38100700002)(82960400001)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REZWSm9GSTNZUThMV3ZYRnQ5T1ZMeEJUMkc3YVdvRU9NMW10Ynk0YThzdmRJ?=
 =?utf-8?B?aWZqYlRhb2JoWTRtSGFVV3l2eTBuSXlKSHRhc3FubHBrUW10S2l1cm9NVTNR?=
 =?utf-8?B?TDdvdXMvakxyWmY1S2dtaWYxdi9MQUdpWnJySFJHK0E1bkJ2azJPVTdWeWZL?=
 =?utf-8?B?Y0JwQW1abTN0MmkvYnpDcS9aZXRyQlU1L1NxOTlnblVDYmMwT1pNTVRYd2ND?=
 =?utf-8?B?Ukg0YWtNVmxhQy94OXE1cHl6QkFxYS9qT0gveldvNWNJUkhkbHh5OTRlemJR?=
 =?utf-8?B?QXR5dGhUQmlEQlZEYTVUdkprbWo1VUlRU0t6clZqNkF1Q3BYeGxlMEdmb0xL?=
 =?utf-8?B?czBQSXFDK2tHV2k0Z00weTMxamIxSHRkSWthR2ZCWFQ0NHlHYXp6RTJOTndL?=
 =?utf-8?B?YTIyMHFEWmVWVkYyZGI4TDg2NGNYWXg0ZG05amdnM3IvU285OCtOOFFSZURz?=
 =?utf-8?B?czlxWFdlTTc5dytWTkhoMGRqcXdXZHFSZkcvSktOdXE1NGRuR1grUzFBUGRD?=
 =?utf-8?B?RGZrTW5BQ3pQTEF0RkJ0c1hQNTU4Z0V0MEQ3Ny9LVllNeUtkOVVHVHJiR2Iv?=
 =?utf-8?B?cVRFbXc2MjdKcDhiVFpiR2JTYjBGY1RaL045WkFta0hHNXcrRmsrcTFNYWpp?=
 =?utf-8?B?RXk0cnVZbXp4YnNidm55My93L1I5VHcwaUdpTmNqNW5CL1BDK1d0SEdCWWZH?=
 =?utf-8?B?bDhJelVMU25IWjU4VFEvb3lQQjEyandtUHNjY283STVscHVZajN3bVhEbURB?=
 =?utf-8?B?OTl2Wm1haXc3YTR3YU16TEdtNUpmcVJweXdzNWpyRWVRQjk0T0xQbzBXNlhN?=
 =?utf-8?B?Q0xoYnI3Q1pxUDF0RjBIZW5mVEtkY0hmK3R6NDdkN2pIYXRNTUloazllMDhR?=
 =?utf-8?B?ZEpqZ0EzVWVnUXUrYUw2bXpPUFVNQXhUamZ6dC9MNlBGbEU5T1BpOTNUcjNy?=
 =?utf-8?B?S25vUWhHUXhpdGUxSDkxT1pteGtwWGo1VUFTNWRIdVg5a21QY20xWlREM2Uv?=
 =?utf-8?B?bTJJOXVpQUFRN282Z2VBOENFK2FPZHBYbk9nVExCcVhBak1ONFVicGlJaGx2?=
 =?utf-8?B?SWNuNFVJNU85NjZxd1VhLzBkVHVNQWhuQjVZSG9QWHcrRFBqQTdjakZrUHUw?=
 =?utf-8?B?bzlyWnNYaFAyeUtzRHZhU1ZrQW1ESWhJLzd3YmdQZ2hwNThLZUZHblJOQ0xs?=
 =?utf-8?B?SDdLTkRYMnBCeFpoNjlaSyticVkxeHdDOXcvbWFnU3lXbFlxQS9CZmlCY0FE?=
 =?utf-8?B?Vzc5ZDBrUEU4QkhvaXEvck5Tc3B0RmZVWE1WWWlEd2RPYlB6WmFIb2dhNU9T?=
 =?utf-8?B?Vi9sbHZvdmY0c2FMVTF1SGY3RU02NXBoSFVjbnJqUXhRemc5Zld6M0JrV2k2?=
 =?utf-8?B?M0c3NnVIQkE2NjdxK2lnT1VCWS94WmFmcUhpR1l0MWxRRWtnY3Y3bWNzQmE2?=
 =?utf-8?B?ZXhCeTFsR0RieTAvWlR5cjY1YnJMcnJmRG84N1EyQVFCVVhFVTBuczIvSlk2?=
 =?utf-8?B?OGdaZTAwYjJsM0svL2ppTkpkdWZ1d25mN1pFZVdnQzFuOGlwSmNwRWNtYXhl?=
 =?utf-8?B?RmVmQmpvWjlvclZaRzVLRERsa3ltbXRDQW5iS0NseVFjVzVmeXh5ZFNGOU9B?=
 =?utf-8?B?bDEwcXNxSjRHMXZ2UitPVURnQXIxTHRXS2FoZk9Vd2lpNW9xdm1HTkRJMUVV?=
 =?utf-8?B?cnJzd0RWbkQ5Vnk1eXpPcWhuekRJc0dXYTN0QmE1bytmeGgyY09zUTRvZWdK?=
 =?utf-8?B?TEpNZ0d6TnAwSkVaU2R3RnpaeGl5dXRXMmxRWVlId3FwalZZWk5ETUhIZzR5?=
 =?utf-8?B?VWtTTkc2ODBKaE5hRW8wU2tFNEw3RlY3ME9ULzZTS3lXNXJ1cUxSaTJLWGVn?=
 =?utf-8?B?dnJVVXhRbnpiRTdPTC82VE1FQjZSOVFVd09rci9CcFNYYzBrMXpVWU1ZN1hn?=
 =?utf-8?B?aGQvQnZzdEQ0YlBWbEJPVDJHb2loNVhEc2k5aU9uTHFDVVgzSTVCZmhXMlA3?=
 =?utf-8?B?MWZUN3dmZWtKMXlNOGRaRU10TWhBQkpiVjFiK2djaktlWi9Rd0kvazdTMW5m?=
 =?utf-8?B?elBQQ1V4T3ViRDZRTHJkYlpvT25IenF1ODY1anV3SmlncFhWZkk4Z3ZURm1a?=
 =?utf-8?Q?1mvyHgDozkwH27HKr3EXItx3a?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3964fb-aa30-468c-7bd2-08db9c9f2c6e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 08:19:26.3656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oQei/v9f6PBUhzYO1KbQbDyuUSWG/2fn0nDCRny5ocm9F+jGAX88SYBlOxRTymhQ2OYwfkaBLk8cDIeKyB/81g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6651
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

On Fri, Aug 11, 2023 at 11:52:53AM -0700, Nadav Amit wrote:
> 
> > On Aug 10, 2023, at 2:00 AM, Yan Zhao <yan.y.zhao@intel.com> wrote:
> > 
> > Call mmu notifier's callback .numa_protect() in change_pmd_range() when
> > a page is ensured to be protected by PROT_NONE for NUMA migration purpose.
> 
> Consider squashing with the previous patch. It’s better to see the user
> (caller) with the new functionality.
> 
> It would be useful to describe what the expected course of action that
> numa_protect callback should take.
Thanks! I'll do in this way when I prepare patches in future :)

