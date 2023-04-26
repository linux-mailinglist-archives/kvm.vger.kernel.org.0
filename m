Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674D16EEC8D
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 05:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbjDZDF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 23:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjDZDFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 23:05:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765E8AB
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 20:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682478323; x=1714014323;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jkOxuEG28n2L9PmmfBbSvENYn3B2ulX4wUahEzcOkak=;
  b=WN4WS7XaehLKheqj2VFcZdk5o9yDcXf/HwJhz4lsHmMKKn15ovIK7tKA
   kpW5Zc05AW9B/t14vkq0umMNd93DVdNawzL94dcBjaUmX5OXY/cpdRg8D
   CK5HaXXAx9UQkPcpe9E1cH0gPzzLiv7Qba6EbbVQhHlNnGIn7VD57JGyg
   V6mNgR6hKqrloOEXp8RJUjfwTnOBlY9aHseXDhAKHiQJO/L7iJg5OgsrV
   fMUd5tixeBSw5DSVKTthB8Fg4/wTVjl/5TqnhxaTD036G37Li1m4SG4Wc
   xQ6jjWIkN2LIIkY46ms1Q3ZtaOvRSqrOvGCQ5z8b/cvYKWe3ZhnDp+8Sv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="345725204"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="345725204"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 20:05:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="724239529"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="724239529"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 25 Apr 2023 20:05:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 20:05:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 25 Apr 2023 20:05:22 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 25 Apr 2023 20:05:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1MXHiu+QY4iWOlMkJWjZmO6ALConVNdl1ItQdtUtB0GmLfH1ik1OTkmVdXy1LqCUeLTcZ6ejBIlq16E5UvwtgNV87pDGn3mdEUPV+IxYy3yZc5SBSnDGyRKi0q2pk4okUeQI1HGl9dgv0kRHWfTuaVM60ArRY2fINRfGuB1iYGl4a/5AVAHkxUx3rmNIfZeLnGwiFOHsnBr6dBEP6u6T7O1YEXv6hKwJw8jdj57YVm+x6y4KXJk/DMlYESiQjh/hdqG7F1Pd78ai/rdvB+MIXBwjU+YUZRI8zMpa0jFs+8qVLiUQ4VGt9qe8GfcGX1Izy4lgwGWKOVbfrl7uMgPbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kY9CJ6RjQJ2wK8YkIeRRptNsItuc98RZMi3qslSMMSM=;
 b=k/6CvOsu+LkxzEWf9yUkwtndf1LbQBM/GE2IUHIKqQXojm7e4ZtZQr2Se5FJ7XA3nN1omvwsekUsLaRl8MZxemx9Idp35v1jUGXvaXWdnziYWdfkYlpOJAIVRtfFfNdz+XwmiJPoYd0IqUaDq5UE0W6tKZp+YKa/0tYhWpb6VmiYTMdkgU5OUrTNgVEKXrlPq6fUIKH8CXFwlUE2kioNLxj/MyDq+Xo5Mqzc/m+M7mf8VfWBvCIKbG0ZZYcpNCZm2yeIJVZHXafsGosvnNYKI9mU1+u8tngI3SKPlnptya7eIwYpEvSHcZygWuuUlp97uKhj6VLX+kfvJiSxdyjljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH0PR11MB5128.namprd11.prod.outlook.com (2603:10b6:510:39::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 26 Apr
 2023 03:05:20 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 03:05:20 +0000
Date:   Wed, 26 Apr 2023 11:05:09 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Message-ID: <ZEiU5Rln4uztr1bz@chao-email>
References: <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
 <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
 <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
 <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
 <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
 <14e019dff4537cfcffe522750a10778b4e0f1690.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <14e019dff4537cfcffe522750a10778b4e0f1690.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0182.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::20) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH0PR11MB5128:EE_
X-MS-Office365-Filtering-Correlation-Id: dec7dffe-03d1-4d2f-92e1-08db46031176
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoG6i/OmH2SzdfbbSCTdzcdBaCoS6/bi7JYq+pBlw+Kus7odO4WfeX2OjwPtm2gt1UaqFrg7jWE29heMbVYsf95X+lsbnpvFfELpzOx/9SWLCaH6gwx3A3F8wGsoEYLHzv67YvBu0pKlNt/UKmWOuhvjVA3fjAbInNpOeWj7PlZAoGge2q1y8AMbucvBDyaVlXEnWRJCjyuwjl1etNEWG7S/7tgij3xPgjSPuWvI0T7Q7ez968PpDa0InTzuvQcc+ArhWkszDgISKr+TEwFETmkpqHdry0Wqlyp5mhpG+KeRWb2rYXmQq4yJUJd6U5NOWpIuO7v60Hhyc/4DjKwWtlz0vlNotcnaF0ywP04u0yr6jWLUD03ng2Ukp5r2/9bNxYZU9HSl/3y/0rJZt6Ao2XLON9IOjcFVQKroLXzL8B47fzHyxTLHVTnjeE2TYRxIgCtvkM1Yo6qcz3pthO0Xv5cE4P0XoKHbD5qC9ewGVn3cQ/EIBBItsM14Qqdqrmpbn7GkVfW0xhgwfvk8wGta+ZvGy4/J0e731Mu6MA+Wnxdi1aCJ0aWYLhUVu6iEVGOi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199021)(82960400001)(316002)(38100700002)(66556008)(4326008)(66946007)(66476007)(54906003)(44832011)(41300700001)(33716001)(86362001)(6636002)(5660300002)(478600001)(83380400001)(2906002)(6666004)(6486002)(26005)(6506007)(9686003)(6512007)(8676002)(8936002)(6862004)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3/GRxVtUMR9rq+LLir6TPKU25s732sWN0XJrhpWlYaiImu9xUS1wvaxhcWuk?=
 =?us-ascii?Q?8TRqKwdRuT788614sRqYWYJ0UUu5y+6MpU2kZYLHUJgvyANzW9SbNyFQ+yUy?=
 =?us-ascii?Q?X6E+HMIvc9s2hpsH5tHZ7hBtPr9ATdxYHlQhcqDvDEwkNFgZ6EAVY/XcUy+x?=
 =?us-ascii?Q?HoypDGKQJNdj4DwFgXP6FinoJfjatGCnP54bfFPdKLSwyxRqDySrjH6uZEDX?=
 =?us-ascii?Q?moNEWgDd4ocGZaF6spFm3Ew9dV2o36QnG9o/Hdh46HjmNCTO/RXdage3KM6/?=
 =?us-ascii?Q?igqQgOupKKAkof4KXqIWfkc0/PkvECsGwLwiOsYEGMA8gyNS++A+GEHCFMXM?=
 =?us-ascii?Q?aRg+7q2lh0krQ22eaE8erxq2qHWixlXvCnxdz7beQMtp3iV1wRQVdjXsgY2q?=
 =?us-ascii?Q?AYvPIqgHaQ6k72y7/Db0VYwIPpsO2Ikc++rOpqukHTr+thq1njcGH1Pjsi95?=
 =?us-ascii?Q?JF4bIdQZquo4AlOB9T8g3FJ6V5ahmXTrNPdOrIpFJFAmo9Xq7Tn3yDuGvYnC?=
 =?us-ascii?Q?GxUpKDS6EGq2DNu0whGDDQ8frbBbSQ8Zj4VMNrzWprBHZm7mg+D+1k9J0Jz/?=
 =?us-ascii?Q?/HODONi3v5oDs1FsnF6ktCXIVHxejcE28akETirTksugEZoiwPanb7Kr7JjP?=
 =?us-ascii?Q?40VPSSNQi8+rXBN8oorWbktweWoCw40bkkWjhC9lAii1mtc+beOAWe27jwPe?=
 =?us-ascii?Q?xwFYip4Ujp4v/wNxdi0Lh2azlkLYHLBUfQlTVhnO6qz9LEF6CqOhR9kp2/2s?=
 =?us-ascii?Q?d0sHoFPqvPdyWHCGIL1imb0Q9k7vODWeGv8B8PsOqNgKT9BQbJMeUAws9/I6?=
 =?us-ascii?Q?H1GFIjE2Ne+RMAnwI7l+dE9akE5l9lDehCxqZjBAJpFXv8vF9NimkHtbQkd6?=
 =?us-ascii?Q?K4U0MPJy15n1t0YOeegeTAqW0DOUIoMmeu21gg7yYjKvqQVypRXbzMuSPz/4?=
 =?us-ascii?Q?WYteIfldLd7WA3Tj5s8Y3sdMbSubDxfd6nnh3x7yiHaT3TYw+Oq/c5qWxog6?=
 =?us-ascii?Q?2ojmVro/gDxe6iSS7LcVdWUcvRNbb/RxrcFhvZBUllp8DwkY6Ri4rSj3Ujew?=
 =?us-ascii?Q?mOwDAL72ztcs2U+Snt5/ik1c2b3v4TA0iRIXaikwFYe56lRipVBcEue6l5OX?=
 =?us-ascii?Q?RJ5CF+E6oG+adulAZYSL4553xozQVJvrNZLbCKNR3xrcOC2m6TsKlWQeviv0?=
 =?us-ascii?Q?R5VXviEsw0w6oGDYdEfYjoXhL+iA9fam59CMgAN30wo2IjNdd72xajEKajWs?=
 =?us-ascii?Q?bhPXbIL4YiUwNYcpna//1CuFAWHkDp3/FeK4KMiHatlUSUM6t1aOfM08S/lf?=
 =?us-ascii?Q?9oqLxZ1cBw0MYk+Cp324Ip7ezMzgjE1Wrw+0wQIvZXRkJ5ubDNUzRS79DqGk?=
 =?us-ascii?Q?a8/XZTAiV0CuogF2PaLvmcWHoChOgHTpY0OBXZ2iU7LUXnRv7AadnaaHcC+0?=
 =?us-ascii?Q?7QU4Bi+vqI5JssEldKLIksQXI2HDf2hV88OAHUObGKCu/usJb+uxwlQ8uYZN?=
 =?us-ascii?Q?aZsUcTENRPxIL9jmdXptt68qehs5AdSQA5EJBjP4e4DqWoC/5ogdrPERApfq?=
 =?us-ascii?Q?RHKz1bfdoeFMkZEETGXWIJfq24sDwji//nDBjCFh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dec7dffe-03d1-4d2f-92e1-08db46031176
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 03:05:19.8266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMS6ZuMWCs+gG9UylPVZtg/ZL9HmfaKa/dLj1SqEbPpnFYpWcqjTPA0MnIRg3oi9Alv+lAnNsjFuC2T2a25C/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5128
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023 at 06:48:21AM +0800, Huang, Kai wrote:
>... when EPT is on, as you mentioned guest can update CR3 w/o causing VMEXIT to
>KVM.
>
>Is there any global enabling bit in any of CR to turn on/off LAM globally?  It
>seems there isn't because AFAICT the bits in CR4 are used to control super mode
>linear address but not LAM in global?

Right.

>
>So if it is true, then it appears hardware depends on CPUID purely to decide
>whether to perform LAM or not.
>
>Which means, IIRC, when EPT is on, if we don't expose LAM to the guest on the
>hardware that supports LAM, I think guest can still enable LAM in CR3 w/o
>causing any trouble (because the hardware actually supports this feature)?

Yes. But I think it is a non-issue ...

>
>If it's true, it seems we should trap CR3 (at least loading) when hardware
>supports LAM but it's not exposed to the guest, so that KVM can correctly reject
>any LAM control bits when guest illegally does so?
>

Other features which need no explicit enablement (like AVX and other
new instructions) have the same problem.

The impact is some guests can use features which they are not supposed
to use. Then they might be broken after migration or kvm's instruction
emulation. But they put themselves at stake, KVM shouldn't be blamed.

The downside of intercepting CR3 is the performance impact on existing
VMs (all with old CPU models and thus all have no LAM). If they are
migrated to LAM-capable parts in the future, they will suffer
performance drop even though they are good tenents (i.e., won't try to
use LAM).

IMO, the value of preventing some guests from setting LAM_U48/U57 in CR3
when EPT=on cannot outweigh the performance impact. So, I vote to
document in changelog or comments that:
A guest can enable LAM for userspace pointers when EPT=on even if LAM
isn't exposed to it. KVM doens't prevent this out of performance
consideration
