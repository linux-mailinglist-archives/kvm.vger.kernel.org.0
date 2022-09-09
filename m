Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6ED5B2EEB
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 08:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiIIGaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 02:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiIIGaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 02:30:19 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF8C4830;
        Thu,  8 Sep 2022 23:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662705018; x=1694241018;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7jm07O0TMdHzuWv5LsldJlu3tQB9OEuwFOho+NFBNVA=;
  b=Gz7AQowwckjLRBQc0hLbjHFCrnpaBaq3AD1IE3b4eEyzUAClrocsaNWm
   PyezemR0V7z579H+OyQv8PpIkf6759n5d0mnbJgEtZGoR37rO6PuzppIk
   X3tZJCvZVdZwOcUDBEuDd7aDPoUdM4CFc9piL99IJKLZAN6+cA/Afk9NZ
   inLhgyeXU9hCpmyM8teGYkzsJKBYn0zN0PD7Nf71UXcH+DNlx3YVmfwYi
   iufw54kzMJ9nRY2HaJu5mBkK895hwwt0sLkWQs7p4RxG6hs7xeBGDSFgR
   MXQaUmA1a9Iyu7ccng7o9dBdjPfyDTH8rE9abKwEYOF5gNzm8DYNq3MgK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="294989964"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="294989964"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 23:30:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="566259361"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 08 Sep 2022 23:30:16 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 23:30:16 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 23:30:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 23:30:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 23:30:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaF8iULr41EnVrypQunt4DzNbJN4krSKtIuXJ+zpoh5I5t3elY54ZQ4ZUu8bthS02A6fBZ4nG+e2oVM/H8s/NQ0xpQmc3osS+SIneT50xbVNDKa3xQvBzgIN1aY0Lv/xWRyJal9EEUbot6SJmwmEYYFqximjMn/pOzfMDEpdhCchpcl9Zg+95Krpibwr8ljPF/qr1p2/sZaxA3ULS8V/iVCzxCitrGEDRjeqJAEDhRnpzeJo5CJalZuSGDXx8Ry+08sfGzgVBw/B8SMrvzuCkOWGr5OKt81gjYs07TPzuHq83/mX31kzA0nFVUUisrWhoJmZvhvDHDGMwxy3jQWr8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UO8RS+hF7ON41njzO/ZagIDBfYXuzfI69c1WW6taDM=;
 b=FjaMabMLBKx5XNMxDbjO20z87TSUERftfBpXXzhVjorNfNSOjgEKOTRHiUxLG+SSs/NyGlEj4QvM41cRZelYMmRO5ywtdID8Hz6DQ2ANlo3ylhljbyfLJJ1PjUtBrEw1udqIu6PuKT249rHkzyi11pNE4nGOkRj+91m+i+tZGWVzcOb0NvcRuG4hXSbDSvqI6cu9p0BeFZ1vM/nGWcVDB94KEnKZ+wJF70reiyRdeA30Z+UkSdsx9uaecjk8mC853T6ND/Y9nka/AZnrsvkRhh/JM3vzYL1P8czkRQyUiYlfQFPePn3td+5RZY7uCJMiX5Zy5W9uUC0G0uuR8lCJyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by MN0PR11MB6230.namprd11.prod.outlook.com
 (2603:10b6:208:3c5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Fri, 9 Sep
 2022 06:30:13 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 06:30:13 +0000
Date:   Fri, 9 Sep 2022 14:30:07 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        <isaku.yamahata@gmail.com>, Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Huang Ying" <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 15/26] KVM: kvm_arch.c: Remove _nolock post fix
Message-ID: <YxrdbyDnYLVM7CxR@gao-cwp>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <c3f1840c3e41a4496de14ae22b8a9bce79dc7a53.1662679124.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c3f1840c3e41a4496de14ae22b8a9bce79dc7a53.1662679124.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR01CA0186.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::14) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|MN0PR11MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a83ee64-c567-4417-07c1-08da922cc041
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3bllCirf2hV/5QY1lvexRTO+Zr3RUkMjMgNSTPItYRr7X4B6U1GrJg2FyoSvvc3rPJbEbPaCr0XU5c7NSGLQUwyPgKsLLwrQUXXeN/WGIqnNKawZADL1OlbSJDaURM4+xGSUk+QrOgbGMGFmFxHsAMTbqvQklt7T2zSfTbUU4U3Q+FOTdimodJoFODxWF+YhNAAdwrvsvmwWQneQXi1S01lZT9zfdyqwANpxqlbugM2qedTszgdqOM6PErzeFBikLLpx/rEnBHcmAW/brHahknBmnRz4/xLf3Hu7N9Wa3+wx2Ss2nkVqgwM1DJcnY5vYULnrIy3E4xzKvMRWobTqGHp0ZBfJxAQDAZssoC7UnESsZnEXR3wevfsLaZEDrnYqJa60CCc1LRDKmJNbY5IeviHin7tsMpfJbb4ooAqEnYyqELWE26rMw9JQGDw/tuO8NgfUEK+Rn2ekWfnw7hhghJTKeCqFXbTlRCCLJ56X6Ka9Fvj9Glli8wpaYfqzVFJBRzNucqjSJ6IRtSE3d3adc6yVJcZC1jvLolAPf+rDTQA2MRmeYesCMFKJI+mCMdM9zHAWEm5ZVGNS00RsBMwmIszFbGVLjBb0PmHJ9ykQGap6JdxZFuLvIRONBX98HZbXB50l26OEVr2hdjD4BUPtYaW0HQz9PmoSf7x0PuVHw/oPwbwya/5Khm3t1p3qgsE4KzvshXpI8P11sd2W2vHN6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(86362001)(66946007)(66556008)(6666004)(6636002)(54906003)(26005)(6512007)(478600001)(6506007)(41300700001)(66476007)(9686003)(83380400001)(316002)(38100700002)(44832011)(33716001)(5660300002)(34206002)(8676002)(8936002)(7416002)(82960400001)(6486002)(2906002)(4326008)(4744005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S6ExqctLoLpXAC7ja0g3TihQp1sjBIOthqII7JrjHE9WgxVshEIA+S4H+Ajv?=
 =?us-ascii?Q?bT9J+0O+GB/Oa/atnpg5aQovg9usot8Yk2EpzMUlzaPccqeOZO8RWZgpZCmu?=
 =?us-ascii?Q?z2qakUr4CMHmfroiEpjNAonyZfR2vQEs4Erjq7NIzA29QCuZgVzyKHQY1hQZ?=
 =?us-ascii?Q?Gf/H4z41qGPXlPXgs5w7IEaAm+IZ+QIyYiltS/0s9z0RKXAw2ytobSWpB7Jh?=
 =?us-ascii?Q?Alz+chYLu4lFidQlQt/0doH3DDQdoBOZIzak959MLe7bATQOwjeHp1iyzoHW?=
 =?us-ascii?Q?PAzEf1Suf/Ag6P45Sesux+lSq466QiWdND/6LdD4S8qUxmRcj7irWfOeuMRl?=
 =?us-ascii?Q?CrXcRSLjHhrxvrBP3Oz649pW3bDPhxmQmGxr1iAvWp6sTMxauLkXO52Gf64C?=
 =?us-ascii?Q?IfA/ZoTmoh3vZey3H7KV5fndCe2N2oHGYdj8DviVRnl+xB6/90pbGKA0UgPS?=
 =?us-ascii?Q?dOeaX1vNwN6pjUaFnzb6uAYe6euv1wwv4Cz2eMZilMPu1GIeOdSh0RHOlgw2?=
 =?us-ascii?Q?mVWhbw/qM3L9Koh/zTUTJNUWn5K9TC4dg58IMuY8I4AXTo++gdmyQKAVjFrU?=
 =?us-ascii?Q?IKsW0/8a90C+//vsJCr1QO1PIoCz7silWvIgHTaiqoC2R3z/wp3AV+Xkfk7n?=
 =?us-ascii?Q?4F27RrnEy+rYXzdu+qdWWMUzKZYrTcBxy7TDUBwHJzRURBGDKvbv7M3GE5ag?=
 =?us-ascii?Q?9AFDbzONxh4+fLRSkqFU4dq4j+Z/PvUxv2AHLOAUOccGcgjZFfRdwRvSwEXf?=
 =?us-ascii?Q?NjtEjmOrkfFWB28E7PZoJnCCX9VGA5KqdJbqHVUwjgwSsN8rWXdpQV0mqA8m?=
 =?us-ascii?Q?OLzfkmHClVhC1U2/HNihJW2uD9d965DIzj0+VC+vobyx0Kxup1tftViX0cT3?=
 =?us-ascii?Q?hXQiEqDMY0TlxU4V0SdSXL22pzOLI365JOxBMNxTxJGTKC+iTVT48QLQcD/o?=
 =?us-ascii?Q?m9HrgYGYisSWUjUhdxRbj0istaPL5fndv6eayN7igUPS5mYBOrAO5FZ7qpIW?=
 =?us-ascii?Q?WK7T1V7aU5qQ28YWPq3PZkEKIPXNShC9u8TiNBHPRt9j9uNfTQx/C4OPMxHF?=
 =?us-ascii?Q?JAp3Cst3v7YkSLr8JoIZcefCSKGegyg7hMmi0Uhmrrfg/wZy4Sr6fLog8vKk?=
 =?us-ascii?Q?qZlNvjDdzy1uw95HGB0tUV3N2tz+/DfoK+EJKYaI4npfsqsp7EWg/O6m2vfu?=
 =?us-ascii?Q?Jb/tvsiQ854YXDOxp5Km0VrJa3FNguOY8JPK7j7drWjQ9V7PZab41TeaNH30?=
 =?us-ascii?Q?UFfs5H62zFsaNaRR0egKH/fBVwk4MrbOstpdPqUgAFM1jz+EBRRi9ckT/uXd?=
 =?us-ascii?Q?vrWOhdIFrt3ylU0AHKYwusuEOTWSnRO0Y3j58wEpxetFwOL+5r7uEtLfWTVr?=
 =?us-ascii?Q?3dJW7IgIulpTHh5bMlhxUM4BfKoCM6w5td9EfQA/2mQo1WdfkcQoHJ7xebVs?=
 =?us-ascii?Q?XawNhvIQmh3aMfHj/QJCHoTcdJAZqVfRpVQKTpLrw/hrldh6sis4+SY3LFvH?=
 =?us-ascii?Q?9IqR/w3HvoXiir8zlOLNUJsWHjiwrWNvVZGW201+XkdShJpdlEb1rCG9Ks3H?=
 =?us-ascii?Q?OI/FijKbGB2zHZRd/wzgDzSyN143132LZT8k+wrw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a83ee64-c567-4417-07c1-08da922cc041
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 06:30:12.8987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+/yUMLbvKOqQbi99td79nhKDhmGM2xAJjwVfKnDvjt/utOw8+cuZOU4TgtFXyu527cnRnp2B1GsGuj+m/QFYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6230
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 04:25:31PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Now all related callbacks are called under kvm_lock, no point for _nolock
>post fix.  Remove _nolock post fix for readability with shorter function
>names.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>
