Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24F27ACD1A
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 02:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjIYAcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 20:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjIYAcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 20:32:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB5FC4;
        Sun, 24 Sep 2023 17:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695601930; x=1727137930;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nw1rRmCtx801Hijh7M/9wANQF7knObkitY92hBNbbrA=;
  b=TMZDi9E4DzNTAjzbVh049p/xtEIXtPAjYl7c+SL8K9VgeQMbLRU7zrI6
   cuXaD3LWO6stRKtac0oFEmbfWAlZfKr1OH8MVFOVuNwfmCkqXF9OwF37i
   obXzUuOCDBweKZUfql+j9IE5Bo1OpIU0wiYCILiYr9nuJHfdn6FKuYGSE
   K9vaZLr6naLkqHpAcjTtjMLT05khsJTp9OUjeK00ewCGaj/hhcn2Mu82F
   XMKbRR8LhEViMNYMdqApFLR2ES8ASj4+OGqHpAld4qEZyha9dZM68U6C7
   M/IJppQo1yfgJ/02+8gzKGoe/QtXOjrIXnmqjGSdB7rv0M06CvF3EWPJU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="360522833"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="360522833"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 17:32:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="871874435"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="871874435"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2023 17:32:10 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 17:32:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 24 Sep 2023 17:32:08 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 24 Sep 2023 17:32:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBDiuooGE5UDHeWXs/S/jgCUKwRv/ccOX3PrBerE7L0vyFN5BB6iOXqMTqpwSmLwH90HYqLyJ0bnaUXdGH+Q1h6/K72qTE5+/qBkXjP9ktxe2YROiH46z4yZlqzQkB5llILRSz4GJNDNSF/z3+fQuTAv0ceTT1y9eB3uPbpxy6z0UTAiIRB9MIqCbTSoDcDOM8KWjanrLoUSm8I6lN61tC4Xs/xxPVblDneiRQqybF6d8QN/BjpMWB2AXp9lId8bGKyrYXuMRkQP1v/U1KE5Nd22s6NI9vHHZiIMwdvq7C4GA0r80EdDTd16TDp3kKaW6VVT5/t2+rD3GNFI8oOu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fewzVzmnJI2mnD2chpbS6htxQIvLcY2BN2LoJa2qLuk=;
 b=cyQMmSQBPs5/62WD7bumspdnCDjalMsSXERpHKbapCZ+0RARI1rJUA6h8uXAqkBiKavk6gCT8V2Lv+zPOIWj1De2WxPFAKdiKzOGewE1mVN8rJ/G5iHC5R/S9eOJyqLIDYbaAlUdhZEWhnM3ZISX5++8BqWitxQ3u+etEmKPZS8RXewCIjbi9WiTrCgf+4zYPijvlnGlliMtIa9KaT+F94+Iq7jKfBIFmToL6qGGSRreTY1es7NX2yO/IBWXXGHBqV2Lrd2+wks0w2jCnDvv1Oce5MyMSUQL5w1KGvGOg45owIpDQE8hgDFqNHRjSfo3iqbpCt+YOqkBSxhcrOkTrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7804.namprd11.prod.outlook.com (2603:10b6:8:f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Mon, 25 Sep
 2023 00:32:04 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6813.018; Mon, 25 Sep 2023
 00:32:04 +0000
Message-ID: <5a71297f-c333-46a5-1215-082366a732a5@intel.com>
Date:   Mon, 25 Sep 2023 08:31:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 00/25] Enable CET Virtualization
Content-Language: en-US
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <dave.hansen@intel.com>, <peterz@infradead.org>,
        <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0195.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7804:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d613673-11b8-4f32-fe65-08dbbd5ed78e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +F0JD5rmKECkkzADItftbSztSdosZfBfh/WgWC4jGK/aLJ6PDhPu/nV5igfLmXpwyDWMHEX958EouDDE4ZB25PRLdjpYW1Kx1EnOjlkziTdWmvcakOPLrdbBdhsaIFKOHxAHuZN2j4x2hbTzrzTReKIhvhzZpk5/835kEbySCHQURDDVAFYuWbvpzBN/MwfSvy62E7wnU3MuJwL/L1GZ0ptkC6z8Ea0Yk2cXMOlxseaLhCx7+P6zXJonXONwM7R6ezuqUctsQbInFKfvyu/UIYVPkWmFPsSRpf5joJgRiIgWWoSaZv6lZhOzwtJJW4jxv/ROWx15ZYxejDigcAykgl6AiZSecdFAaM3x8aHaG6/qcz/a82Q4wN4l1cDDM6C1e8+YcnJ+cP06PdyYI1KHVBwuIhDtmOg4GWSAciFl7jOtpKIXL7+CXTBktQ5Df1zWbVhKe1AqlC9ZJSLqk4GxueqUMzQH2HZRaiZNhuh+YadR7x/9vQCfwF4dEMDoQTG9vUDIoHITosCkfBqIwsP859PchvgTX+g9kwT2nmLJpaoU7/L0tZCeJez9G3KuPbxNwzCmry5czkhKFk8mR5DPeqnjPniLDRVc281TxxRyWniPBiVrD89fPLbBS5I9TQlEuX26OhMGNLrQZ6kC5lMqIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(1800799009)(186009)(451199024)(6486002)(6506007)(53546011)(6512007)(6666004)(82960400001)(26005)(66946007)(66556008)(66476007)(2616005)(31696002)(86362001)(478600001)(38100700002)(2906002)(8676002)(4326008)(36756003)(8936002)(316002)(5660300002)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGJEdWlVb2ZYaEUybGpIcHB4NjdCUlZCdEVad1VUbFZDNkxGakFUNGZ1K0g5?=
 =?utf-8?B?MlZ3TXNVYVRnV3pZMWcxSTkvRlpSVWRCUWJ3YVlrUHRHb2lVK0xqaUNUUzBF?=
 =?utf-8?B?Z2dtSDJhZGxjTlFOMVRQT0NuUFMvb2NGYlNid2RwYXJjNytQdkFJTFRoUVZl?=
 =?utf-8?B?TStHQWQvVWNMaFdGeCsvNXBOekpYUXFUMVA1MktrT0J6d3FqWmJFMDFBNXlK?=
 =?utf-8?B?ejRqVjVHWVdmNHpjSy9XRm5JTUpRS1orMEp4Nlo3c05qckl3bzY2RnhuVUV4?=
 =?utf-8?B?VmJkTGlHQ3lDT0xDNmp4ejhQc1EydTFtR1lsS2p6WitKTmdoZW1ORE5UWHZw?=
 =?utf-8?B?MGNodStWbmExUGJwUUFYUWdwenN3RHBMbFFCZXg4MlJCbE1EL1d3N0ZTLzNa?=
 =?utf-8?B?UVhmT0ZkekUrWUFxWnlkS1lHR0JJU0JiY2JmVU52WW93RHlYenZZbHJPK0pQ?=
 =?utf-8?B?UDRxZG5JWldoYWJndk1zaURVbUg2dHErZ2p3Y1RabkwvRk5BMjUwU1p5SFhU?=
 =?utf-8?B?dmh1WmVOeU1hUlFEWmt4WndaS3BSNTVmSyt4RmxmMld1aFlzdG1QU0puOVFU?=
 =?utf-8?B?djYwaU81TkptU01QdVRLMDRFU0VsOTBpRmViRUhjWW5mU1pIWGNXaEE5VkZN?=
 =?utf-8?B?UFJQVnVERlduT0FRK0VDb0hsL1VhbzgxajN6dVNhMisxV3hDL01ZelJXa3RK?=
 =?utf-8?B?SDAxYmtSenlKV1FadWJ5ZFdxRm0vTmQ2c1BmVWp1aEFIQVBIRkdrTEd1d3Nw?=
 =?utf-8?B?M0txN3VQYVFXRlVkK3oxeFFGUFN3cDZjYXJhbE5ObmV3RDlJdU5lMkRtdGcr?=
 =?utf-8?B?c0M5bndvUWxHQnBFY0RsTHJ4Um94a2QwMURMZWhpQ3lkVDEvQU5lN3grN2Ix?=
 =?utf-8?B?RGVlRTdHUU5WYUNNREQzS3BMSy9uQjZvaFpwQ2xyc21Bc0FqQTJ2ait2UHEy?=
 =?utf-8?B?d0RNYjlyS1V3bzNlSjBNdk5UVC9rWEZndnpIWU9rRjY4YjNCV29zeTFqQllN?=
 =?utf-8?B?TG1DNjkzKzlmZ3BvbFowRWVkV1phaFJ0d0NxZkM4WXgxTzdjWUZMYU82a0Fa?=
 =?utf-8?B?ZUJVUlZXQWlhU0xBRmE0NVBqNlZsSjVNQTc2SmlXaFpmUldSYXRaSEV3d29p?=
 =?utf-8?B?YWRzOWdCenpEa2JGUFJOR3ZhcEpaTHVpSTE0aS9RQXV5K1kxaFlybHlzTzJL?=
 =?utf-8?B?Z1ZneXlQdjdCNm1lY1hqdW5rejFZNGx3V2ZVUUR6K2dERVlISCtyMWM3WGFE?=
 =?utf-8?B?SW4wR0xqbGNpVG5zZnUxb012L0M0VWRoS1g3SHJ4VUk2TEVzamI0bUJRTVRl?=
 =?utf-8?B?c0RGQ1Q4WDhDMFRER214cVBqcmQ0MXdCWHYyRzJXcDdXUHF4Y1ZnTXZNTDg1?=
 =?utf-8?B?NG9GKzUyZkRuSjhZZSs5T1lKMmFVYXpXODMxSlJwaS9KNW5xWUJaODFWMmJl?=
 =?utf-8?B?dEdJQ1dwdy9WRXgrZ1l2R3BVYVROTFIyOGoxV01YbXFrRnlaaTVEL2VlV1k2?=
 =?utf-8?B?K3hRdnFTRXI4WEN4T3h0NjFMODdtZ1ZPRFNWeGh1UitQcUMwbzNud0RrNXB5?=
 =?utf-8?B?ZHJ6b2JsMjU3ZWd6M3Y2UFpHSmJnVTRZdEJDYVEvVXlKMjRQeWxaRmpwZ1o4?=
 =?utf-8?B?KzY1ZDZSeEw3VCtrdi8vOGRmaWFQTWlJSVhnbkREeFdVdW1FaE9yWTE4ZHEz?=
 =?utf-8?B?ZUxsTzZRRDR0SkxZU2gxazlPamdQem0xc1ZCaUJreUpKMlJUN2pYR28rQktD?=
 =?utf-8?B?NStYVXRGdSttemRnanZHeFAzZmNJY3FHNzRzOXoyOFZWZmU1cE9NU01BcnlP?=
 =?utf-8?B?K1lpN2VBTTlKZFAvZ25yVmwzcDJIMDJrT2JtZE9oaEJRNjlUWlphTk5sdE1n?=
 =?utf-8?B?VUJUOTlvWEYybEdSRG0yRkZNcEpxODdPSW1IWDFNTWlYTE81RVFaMWh5cEZF?=
 =?utf-8?B?S05OdGJzV3F4RFM0bjlTZzFKZGRBeC9zYldZNStvR1pKMjFQTC82Sm41TTFM?=
 =?utf-8?B?emZxMzhtTUMzOTFRNE9tcm9BWGxBSjJrVEU1M3pVdWtDNm5nbkY5NDg5MVRO?=
 =?utf-8?B?QURrOWpMSCtFZko2YjZ4enc5WmRReSttbzN5amMwdE5UWEFsYlBpdU9ZeTJP?=
 =?utf-8?B?M1FGZFpmSnVORC9VTTZ1Z3V2OFRnbTJoS1lHTEJtRTgxOHloV2w3cVJuWTFj?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d613673-11b8-4f32-fe65-08dbbd5ed78e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 00:32:04.7236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpFD9K1pWlpw97OBJc2EBQjsAS0h7h7iZ8e8ckr3SBMIOf3idV7ZPL1793cP5R/Gybh2Cp/A0Z7UzU9xUH7hgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7804
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Kindly ping maintainers for KVM part review, thanks!

On 9/14/2023 2:33 PM, Yang Weijiang wrote:
> Control-flow Enforcement Technology (CET) is a kind of CPU feature used
> to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
> It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
> style control-flow subversion attacks.
>
> Shadow Stack (SHSTK):
>    A shadow stack is a second stack used exclusively for control transfer
>    operations. The shadow stack is separate from the data/normal stack and
>    can be enabled individually in user and kernel mode. When shadow stack
>    is enabled, CALL pushes the return address on both the data and shadow
>    stack. RET pops the return address from both stacks and compares them.
>    If the return addresses from the two stacks do not match, the processor
>    generates a #CP.
>
> Indirect Branch Tracking (IBT):
>    IBT introduces new instruction(ENDBRANCH)to mark valid target addresses of
>    indirect branches (CALL, JMP etc...). If an indirect branch is executed
>    and the next instruction is _not_ an ENDBRANCH, the processor generates a
>    #CP. These instruction behaves as a NOP on platforms that doesn't support
>    CET.
>
>
[...]
