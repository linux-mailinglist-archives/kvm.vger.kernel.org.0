Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7D6B73C8
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 11:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjCMKWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 06:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCMKWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 06:22:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C27C53722;
        Mon, 13 Mar 2023 03:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678702924; x=1710238924;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=HOYnHKAGww0dpTXx1j/Q3ov2hQbxh4HAyDNXvT86Wl8=;
  b=MlYvJN3mYKkat3tBLZsBqGOGipUk/rXJZjnyCJnQ11VmX+JIBKoJr643
   rO5oOqvF5gwIHEntimhYEHvf39G3go2Ff6ttI6ZTo8okpdlov/4NBTmVG
   xuPtuWncoDz/G7TcEujzoPXCFlObKx7/PGKvcBEAMAsrZeWNOzlIytLHu
   XaGqYXBgkpo8FSfY1FoeZhnkl1S7M9/RyAWVcQALKblq0CiId77OxlRbX
   HkLaE/K5goTwrdtscft1o5110rOKr6M1Lvq3Iw9DqQ4niu20KlDQ+HXwj
   sO3qR5ABLjKAd2hK7jdjS5ckWOGFy+PziWq/10oeByEE20J6NLjNcydHO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="337131126"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="337131126"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 03:22:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="821903932"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="821903932"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 13 Mar 2023 03:22:03 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 03:22:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 03:22:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 03:22:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtyGYviPEL2xGp5GqtkCiTwvMLTbEM5OS2vsYJhSjQdAxBO1WdBrR0Pc5I6CVScfQlvYnwchw8LtaHACZUbKhaiM92Z1UPunI36cFHMVwrgJxVizZXRicWmxjjN3ADn9cdxMDY5GPVMHLQp9Vgtx7uH+uXaFXxYJsCHnJisaI88WMj0aRwZKDxy/QU4HZJdIZx2xg5/3DfLBr37HKl1ueGCvDAYAN3baEbQsyDUomwthvYeVlAncMhTIFuUYhUekIRYtXxYlXPq7XkW378T21bopFn9k9H2AXsXbSNFuIhxRCONAsIJ99U8uSyMRqS/SmzMd5SZlFuLjGIOm+bBKKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/9hhRZnrGSLrbFPLzEFUmk6R7Q4WgfOqCB+jeQefLo=;
 b=bMyzanMPfW5sOUFQX+FUud1XVwr4k03uO5Ln9N/EVlrhwjfs4cao0sPDaSx/EMOeD+MS3u8y5WNVhF8vwnZsfM6sC/XRY22pIWxJ8V3eHzY8obL++9zLAFLAmgqa0ZRIssitJtcdDuyFHbwt7+Ahqde10Y9OyySLkSSmPipQZax/Yh9C5osjV89iGLEhl0bLgBeVxnODEo8rSWRA/CRm/q0nCT2mnimFcEhnb/eDiUFuwMtFV8zKaec7nyGquOrEWM/nCdQgRvHhvuMbRV7+wB+GbaI4BYkRiWc5PcUA9oDtTnNj7GAcyN7/TlC9z91+210NFoyIiKuRikmrnVY44w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8142.namprd11.prod.outlook.com (2603:10b6:610:18c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 10:22:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%8]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 10:22:00 +0000
Date:   Mon, 13 Mar 2023 17:58:08 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        <intel-gvt-dev@lists.freedesktop.org>
Subject: Re: [PATCH v2 00/27] drm/i915/gvt: KVM: KVMGT fixes and page-track
 cleanups
Message-ID: <ZA7zsAIekNA+ty0x@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0116.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8142:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c09832-dd67-46ef-5615-08db23acc7fc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+YNZ4Vflblk7q9NzB7OkDk3w9Dn6BFw/ImYTBkZ3+GCtRoKdWeDABd67FZjIDFIynfFcrCisVI3V3qzeNQFZ3OfwDKjpgzObxPmSw7jxV+tCurF5/qlrNiEKCRjSpUhjRguLx/7o/hNWmp3aBEpmEElFjlRBPFezAQoJ/FnSxxeKgkVhnW6P5yFCLN+8LolFL9W1WXipNYf4Eib9kZ6RyxBI5cXcq4Ygpw3a+asDivYqKJPNfHWW2Lm6vRfKU4/0q/lKfABUqtT9L+jPBq4FAwRVAirObN9EleExvF5NWL0LhgywgPzuYzd0ZaHPqhcqZU33Q+LAl5kwP4S+wPLxC2Je0Q5uIgVQ3TCtCKgG5mbIpblD+26gInRG1P3eBQ7BlK9rCYOid7yMQRR+EzfhiWEXpNxfPPJmIDfFIAY+ggJMTaD/CFkVQKxN/dTXQo8kl+85qZIVGhHVKewAbxnXUy82lqXL8VRu2paYhmqV4KiDPdD2KaLj7dUY4G0KG3+P7e04a7Fj/cO3TESJ+y9VE2G7pi/CTSdzHvxJ1GWGQvpDuedlWDziz4pCvTl0eQwrQ2uTHHgV2Pe2XgZNGqd2BGqFkYg1KZ9ZM2Q9duu6l4uUUBxW0JvP0cbQZn46whmvsC272N7UKQn9xkdlJutg1iPD3NJXSbZ7Jt5OnIzRiylSgchttbg4UNIR+B7gmcH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199018)(86362001)(41300700001)(4326008)(66476007)(5660300002)(8676002)(8936002)(6916009)(66556008)(66946007)(3450700001)(2906002)(38100700002)(82960400001)(26005)(6486002)(6506007)(6512007)(316002)(54906003)(478600001)(83380400001)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1hk2D2RmNmBfibMNENVMvNJ/cVFsRnQ9yox8fLh5cNcIrjJEvSVRXpsvyKSO?=
 =?us-ascii?Q?JPwj1++sKzYNFDlC8mcjsxQc4NXpIvdQh3EXwC74LO0dJ0lxKID9Gq50+phX?=
 =?us-ascii?Q?KD4vmv7PmnIyeiEuUmr2ktJ1BTZpXcSL+8PefkCNcW8CAxH+5SAHojBh6Pfc?=
 =?us-ascii?Q?cC5MoNUHowXBp8J3Yv7cvK9UdeGhltotfBhfFd3hFETY6FUP8r67WJu+U79d?=
 =?us-ascii?Q?DiwhPGmg386dPAmWM/oVyAbLI8X6Czd5PeI0+DbSGz1cExPc2Vt8Jw2cknEH?=
 =?us-ascii?Q?NNdDwNnXdIqo9Wj7PF0ROYsM1ggITH9Kla/CFoGzarElUhbmO1RpneInoHii?=
 =?us-ascii?Q?/uZFVeXcA6XTIy5AvbQndtVv1QILBO8UVQoaBLn+4Ddj/DaUV8sBqx7xpeeI?=
 =?us-ascii?Q?svapKipKQXLB8zC9hCXeOxkNDB78T0r2wMNM7N43wyCaNdNcbhzDOCIl+dpY?=
 =?us-ascii?Q?dCCY/oRA6R35UFLBUbsQ3bz1X1MekleDovkjmYpaFxNxeJesg4DanwiS1dfO?=
 =?us-ascii?Q?dXhyn2X4FabdI+OkgVfBwsOfPlgmVacZg5fJz4NPgqtoGxodJQa7vklgOUF8?=
 =?us-ascii?Q?MDIlStWTrVm1DIlx9r+VJst5ts5cTmAApQjSKHcn8B6faOhGZ5+nIj/vUR1l?=
 =?us-ascii?Q?r26mMqrSz5iaQ1JET6Mnbk7DPj1eMN3t/Rcr94iLhYq6dRW9sVBK8lYDyrkV?=
 =?us-ascii?Q?wZ45YDMZcA420ymXUYL5I31Ps+CmfPUkRxlFDJe24fO6kGeUjgUgIXiggnQa?=
 =?us-ascii?Q?ZGwieQfsV71BRsUlLNwDheT/M23sBuO7jFvbk2Rb0eSx3f6+XL0WE4ONs+nh?=
 =?us-ascii?Q?x8oHH/WbFbfJkdpOvnCCLZqJUTxtWFtfMOGJGP6VbXIE8+PG8c137cOao8z4?=
 =?us-ascii?Q?87QYdBcNm/uKMJfE52sfHGBx+EFi3IFPTnSXVugAiukWQbidk9GNYpoE5J05?=
 =?us-ascii?Q?BSiWXCiUbGopemyO2KrGokwwLTNvKZGjWOrGZkmov69LrKlt40F/rG3Y9dM2?=
 =?us-ascii?Q?/2hHRP61wDaXuJ4nC7j+akZxoDdfYLZmo9s5vT9zQu12BGRj18Q4Nl8fCxp+?=
 =?us-ascii?Q?742NIS2ZzMis3TFBA8B6xDsxT9FqNq4sKBeytLzPrjE2WF15ziflo4E6h2M3?=
 =?us-ascii?Q?ldGaH9opxPcyPNl0MUeHZFog6F5zQWHgI6nd7E8H2cSouEUvIp5H13ncqqBd?=
 =?us-ascii?Q?K0Q93+OC4giA/StoIusJ8xv6m+J5TYmhZFIRPLblnLqx4hGlAM1EG1BHEfaw?=
 =?us-ascii?Q?EqspkxV7aJTwm7cne4GzO2BF1Rczv6c87iHZQwts7d4JqHARi1OGfPr16+cZ?=
 =?us-ascii?Q?MCPShgt+xzQB/5GjwfVJXHgmEzYNiJ1IJOF1fCfx9exbirRgDwABPqkVeNnx?=
 =?us-ascii?Q?8YkcxwMEYbPQwLKl9rspLtijOWfXv482nwtabAriHuulDIFRMtuDtkvQSwPz?=
 =?us-ascii?Q?jkH7qVsljGhwixc2wf/0avsZaaWBy5ARLWW7KyTyicUlk5jqdtB3msgXmT/T?=
 =?us-ascii?Q?AWsb1CH4ct0XNqeeaXe7Vg6DTf/bLG2eZ6eqaIcvHL4WqQQdnan/8Ppt2t/Z?=
 =?us-ascii?Q?cB5+rjFztdk+dtChUq2OdDePJKOdAiWTheiEfhg0o9K2pY3N5zElRNwou0yP?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c09832-dd67-46ef-5615-08db23acc7fc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 10:22:00.1951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RgDb/+VgKGrqI15oKGB+Aexiv7mcvhQBsrCnybGbk4UjayFkWtQsTxCQDOINJ6lwY4JwLIvDbHqNKWxY1uy3gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8142
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 04:22:31PM -0800, Sean Christopherson wrote:
> Fix a variety of found-by-inspection bugs in KVMGT, and overhaul KVM's
> page-track APIs to provide a leaner and cleaner interface.  The motivation
> for this series is to (significantly) reduce the number of KVM APIs that
> KVMGT uses, with a long-term goal of making all kvm_host.h headers
> KVM-internal.
> 
> As was the case in v1, tThe KVMGT changes are compile tested only.
> 
> Based on "git://git.kernel.org/pub/scm/virt/kvm/kvm.git next".
> 
> v2:
>  - Reuse vgpu_lock to protect gfn hash instead of introducing a new (and
>    buggy) mutext. [Yan]
>  - Remove a spurious return from kvm_page_track_init(). [Yan]
>  - Take @kvm directly in the inner __kvm_page_track_write(). [Yan]
>  - Delete the gfn sanity check that relies on kvm_is_visible_gfn() instead
>    of providing a dedicated interface. [Yan]
> 
> base-commit: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
> -- 
Thanks for the update!
It passed basic tests (gvt in a single vm) at my side.
Will do detailed review tomorrow.

Thanks
Yan
