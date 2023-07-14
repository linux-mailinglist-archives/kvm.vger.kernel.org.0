Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F7E753337
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbjGNHhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235432AbjGNHhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:37:53 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D992D74;
        Fri, 14 Jul 2023 00:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689320271; x=1720856271;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=wHKxCZkoykJoIg3Aoc2Ic0URuBzoi/tP1ZDzjSTCsrU=;
  b=AtswHey9P5NU+UK2bz2lZrwPT1rDnsZD+PAzA4eiJnAj+nIzjrHJK2WE
   40VfAX1/N2kQsNCgqFecH3qcLCOFpz6nlxcUsXjshjo5/mmXgA0wgdjN9
   fLdNJLemMGGNhvzlCyxW355QUd+9Y8AwXEp4GsmmYxbkS7N0P2HFunLXu
   Y7KxjJFq+VbQKMmiwBPCuMsAupZlBxjT+YWef3WlkZ7Hb7qRf5H4amXbC
   CCU8yL5xniIGCmwuzsO6li4tzuNoB9uH+2XRdwG9BXjRFAY88TRKiKPUi
   lIkhq61tCc95jfUtf0vnxMOSWooI0FCzXA01oCf7U4gaw/4Omai+BoSoL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="396225974"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="396225974"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:37:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="812333701"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="812333701"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jul 2023 00:37:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 00:37:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 14 Jul 2023 00:37:49 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 14 Jul 2023 00:37:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecFhEDb8SckrHp4uui6S5wc8LOmVqdsKf3BkwQ+dTFgFYNblJyhrxeJ0qabsl7NN5w3zXk2TPRbChZ5n6Q3pnd7s6dWYhmV+3VsQWkvZn1b0L5jDtzca+exNjlICBKdJ/PzPNeBagTHLeAWmn9LiE9cELJ1byFFf3N+bRt7IUcVe7DjmBIMj4eMxTgTzaF949oaDtJraclxBoyckMbSANmjsui2fsnAWvqas6D5HNwx7BkmbHbfvZHukJm51b4P/VxZX2EpzB/Xyof2fdfwkdBJfSbd1FlIp8/jSM3C4K5sV43V0nO53RXfWOMXiWxDnwDuB10dhfYA23FHcz6P5og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HHpfQfK87dnyFxTMGhnatNwioF2kASk/9y56BxRvZaM=;
 b=ZucTVb51DzpUA1zU8eaf2OphOuDOtjm2k3azCuMSg0/umtAPGdhzLORSiJAy5iHfwP6yH8qIkoIsaxiDG+Cwe/M8bMIFynqftZrsrnMkssgi7iPUJVilQNH9ORRCprgg3GV5bnFapwDQ1tVyWdexfQoScr+JRMj1SXbzGbRpW4mkhDAndkf/SdhgbmuABzaK9rC51kLPaJV0Wx/nWASo2OXwEDUnUTygtpE5InCoiTg7I1RoCUhJ9nX50Ne7UBNx+bE0dBfgt4Hwe1VgKjeJp/Kl8DoF/P1CkgGXWc7MXjGpmxUJcx63wgwiN8bX/Q+O2JVzmnOAaGGQJPARf1G+UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6588.27; Fri, 14 Jul 2023 07:37:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::c7b3:8ced:860d:6fe6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::c7b3:8ced:860d:6fe6%4]) with mapi id 15.20.6588.027; Fri, 14 Jul 2023
 07:37:47 +0000
Date:   Fri, 14 Jul 2023 15:11:06 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 00/11] KVM: x86/mmu: refine memtype related mmu zap
Message-ID: <ZLD1Cv9bNE9rmanj@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <ZJy77R5dQE3uFymG@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJy77R5dQE3uFymG@google.com>
X-ClientProxiedBy: SG2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096::24) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6365:EE_
X-MS-Office365-Filtering-Correlation-Id: fba293f3-b529-467d-530c-08db843d380f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9WzHW+zQs411/QexUqzzVOC9xOLdRlKuF+u8tSmjTxuVb265lCYedXvjLMI4geCXqPWVbaQO+iM/PJ/a7y/+tC9M+ofeiHA+pAr2R430lTRw4nAkZlgsk58u4Yr9TwdqviTXFxrTjaQJdwJOyT2gAJ1JbxU1kJWOUn/reKP/6C3rNBPSeU+u8JL53cRtxVU2jFv/q/cY0T0/ja97YgeG5qG18w5IppELqWjbCw5rGiFEt0F7BK+xoJr9p9h3FZjeI5d04nRHmLrv4VI1QY3BjcHAafoU/V2S5pR4xub2yBepc8Q8wpFxzwWR/ZZ/TPjZHSyDh69BOgRAvqlRvrzyhlkldbVtKAgIGIuacmSbbGepNC5yAO2u9xxJF6Op7u9K3v4EKjjfBxnieBYJnSdd7IL835dbPxsVbzZdJrxx87LBvyo2mAAmFd/2gski9posh9kDelBeVDPhcE3XjXnv7i/+dcRWrbpEZthMKarXBvfOFVXfs2TNspNF/BpTWZOsKuY3dhXN8q/1WQGR6JKnicDVaVAxyQpyqdaPjo+64Vo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199021)(2906002)(478600001)(6486002)(6666004)(8676002)(3450700001)(8936002)(316002)(66946007)(41300700001)(6916009)(66556008)(4326008)(66476007)(6512007)(82960400001)(83380400001)(38100700002)(966005)(6506007)(5660300002)(86362001)(26005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FexJsGyWnDw545Xi6dyOe+SaiJT87A/TQqH6rN1NjoNaqPb2ibmNxEcX40SF?=
 =?us-ascii?Q?I9I2srR8wJlAlmluJd9Z6gJ+etl6swLeNy58aOBCUd2jyUhs1nzCQ9Behfjv?=
 =?us-ascii?Q?+rYJipcYXeDohmHAmRNg/UDbG4tJH1Ipf1roTe6pC462YFzCTZhO7SXz0HVm?=
 =?us-ascii?Q?V1fVMC8yNwFJC4Yih8crwNcmPJb3SSF3mcauQVPRszU87fAohzxTb1//XoL4?=
 =?us-ascii?Q?uO94+tigDZbTIFbvF3mCIb+tR64t9diZg0KJiM9SALjaGLfCRNURVCs8+cCb?=
 =?us-ascii?Q?HyJPoQ0vzv+81s3hE4YX7+PVF0H32plXLDoazdghz6NOaHEXCHikkljCJu/g?=
 =?us-ascii?Q?QlIIfvFsuEvxKvveOVoND29OF9ZynEOb8E7pLhGTBvmS6K+S7pCg6a06cjWV?=
 =?us-ascii?Q?q1NS4YqrxOzc9pMw3MBt6tjKkLmcFqCiztVwCWH2gMfPTc9Bph6JaD52ezFD?=
 =?us-ascii?Q?z83LTmbTe2mBvfHQ56EwTHIjz3obhQJrOlD1z+lB01XIf4tQ0aG7/xCsB27T?=
 =?us-ascii?Q?aoaipyjHvNhgGcayIvlotZDRT34FDtJuSh/veJwGtzI6CN690QjoeYR4zIWl?=
 =?us-ascii?Q?syzsxs/T1kkN/f6ZC1yze2BCZCSC9k7A8pEdojRehKyYVIJcNIvS4ShyYG36?=
 =?us-ascii?Q?gJbBy/DvvwbHgwsWbajHpBoTGAa0M2Z3gcUuYcHEJlv4Z7WVXl2u+wyQfArV?=
 =?us-ascii?Q?4sqkVZdDf+aTx8CsmtXmuVG/elOHoNDaFyxp1j17brCpRDcIIUmsUOmVqbCj?=
 =?us-ascii?Q?2hgQOe332WZ7UEH9ZgxXgdHOTYamEGIqv2L50Bl3ZUrFOKhuZp6yBqv4Stnc?=
 =?us-ascii?Q?v/8uoHFyBFTBBvqqvbJ6WIqJcK23DENPl2clXqvW9jmnNzzyKAW8K4ZvNEbk?=
 =?us-ascii?Q?mWnR8cNYwhQbJZfRMYaHlPoK9Kkhrz2Z2qJZoEI5xeret9fBmBxmrO+EtbHS?=
 =?us-ascii?Q?b/A67uqhqrIzwEZLBmJiTVYXvy3B2rrT0wX2hM+FwuQZ8BgS+Bjhr0sJdQca?=
 =?us-ascii?Q?GxtWoqKkuub8PHPByDqQrQyd88w3CVfX6vHkiVGIQCkSk7QK3Xo5tGQkz4cl?=
 =?us-ascii?Q?uyEjBkr+2mePj564ROqJiPeu+zXi/NF0jupXos0f+dPd0TkLDYAGDiFympSg?=
 =?us-ascii?Q?t7UMMNsQ4WPwXdTxX35sUC0N+YiWxeJOH75XRst8WudQ1XzDyxsLslwgdtFw?=
 =?us-ascii?Q?dG22d/kRnohrjeoUG1UlQbWkWgd4Q8a3sKJqaK+q2G3H3XW0ftFaGD0+ti8K?=
 =?us-ascii?Q?+We231b7WcAjK3RiBXfFb/jf9H+k1JKTE8SSpzjxhm4/NkFg1YqMMnr16SfE?=
 =?us-ascii?Q?foYEX3R9lNLHdgQpbdro0eOk/YHNcMU9j66SdsKs9p44e5eneuBhAbOHPP1H?=
 =?us-ascii?Q?w4O+cBdDPEVjs9JMdiewh2MX5FmcVcrwE1wyUHK7S0/5LdWBr0BC8N95kRiG?=
 =?us-ascii?Q?/ICD68ZuvXWoo7MmYdEAgpOk1dP6IqkTqtrgbmkE281Xg222mLNK/tyR1hRV?=
 =?us-ascii?Q?WpeZ3CNs0O2ZwFcgoMO2Pq5W5+lAD/tY6XQAMa5SthZxuJlChooDOInk5qQE?=
 =?us-ascii?Q?UYchPEq9Gp7mpxh4YGZnzmleg7JtutxFT+DctD5y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fba293f3-b529-467d-530c-08db843d380f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 07:37:47.3013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SH2KiMry3I/26lHhr9TyxtT08j7AnnUVGtQ6kqad5T2cRjpBT7vwWSBIUuN9yewxve0v2kwaH9SVqaiOeZsC8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6365
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 04:02:05PM -0700, Sean Christopherson wrote:
> On Fri, Jun 16, 2023, Yan Zhao wrote:
> > This series refines mmu zap caused by EPT memory type update when guest
> > MTRRs are honored.
> 
> ...
> 
> > Yan Zhao (11):
> >   KVM: x86/mmu: helpers to return if KVM honors guest MTRRs
> >   KVM: x86/mmu: Use KVM honors guest MTRRs helper in
> >     kvm_tdp_page_fault()
> >   KVM: x86/mmu: Use KVM honors guest MTRRs helper when CR0.CD toggles
> >   KVM: x86/mmu: Use KVM honors guest MTRRs helper when update mtrr
> >   KVM: x86/mmu: zap KVM TDP when noncoherent DMA assignment starts/stops
> >   KVM: x86/mmu: move TDP zaps from guest MTRRs update to CR0.CD toggling
> >   KVM: VMX: drop IPAT in memtype when CD=1 for
> >     KVM_X86_QUIRK_CD_NW_CLEARED
> >   KVM: x86: move vmx code to get EPT memtype when CR0.CD=1 to x86 common
> >     code
> >   KVM: x86/mmu: serialize vCPUs to zap gfn when guest MTRRs are honored
> >   KVM: x86/mmu: fine-grained gfn zap when guest MTRRs are honored
> >   KVM: x86/mmu: split a single gfn zap range when guest MTRRs are
> >     honored
> 
> I got through the easy patches, I'll circle back for the last few patches in a
> few weeks (probably 3+ weeks at this point).
Thanks for this heads-up.
I addressed almost all the comments for v3 currently, except about
where to get memtype for CR0.CD=1, and feel free to decline my new
proposal in v4 as explained in another mail :)
v4 is available here
https://lore.kernel.org/all/20230714064656.20147-1-yan.y.zhao@intel.com/
Please review the new version directly.

Thanks!
