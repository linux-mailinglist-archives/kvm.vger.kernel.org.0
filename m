Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1D05B2C01
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 04:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiIICQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 22:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIICQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 22:16:25 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25951582B;
        Thu,  8 Sep 2022 19:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662689731; x=1694225731;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4idERgzDBD2t364gCssrn7vmsRyxeoanLp3+rgti+Ck=;
  b=g1K+7LYDeJm5mTZHj0/UV4zEhXFXC30GDR/FHytQ8SjhvYdBTUEJT7n2
   FvONIsL6f1+oqk5MCCklS5k7qEuBP5W98ZmjX8JDL8Zb9QjBFjF5/DbIo
   F7gVbHqQVnnND2N1tqxTwRBGkTKuIAGB9/yBwfzZpJ0Gl8V+fg3b/tgKJ
   v7cUwoCDPhBrzXxQCgGw35MmDiZDk5TY9VL2hK4qtBRcuG/QfjzK1EsO1
   M1qn6HyNp/xyyXlcI1JVeC209FjXiqm/1Voso9wx7tHyzQKKZR3wSTYj1
   zu9ap5Qvck+sUd6ZnZ8fcwoqbtIA9HDHxDsbCn1zp9HHEvj0xzblSxOQ8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="323578470"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="323578470"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 19:15:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="676966882"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 08 Sep 2022 19:15:31 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 19:15:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 19:15:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 19:15:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCMx5tA9hZ7+IggCfjRuPVjEu1rpasB6xQav1FBuk5xGLJOQqB/UdqB+gJZUJ9PgHxeThmg0UdZeXI4l+xHNZNgzkywqZ1DfFI1bU0WSLPi4UulN58VYqTuFKDEeaok+gEaasL5ySadu9IsQ4oBg2kmtYuAeyhYSGJR463XXgPoH3c5Cru3bRAB+Kaj4MviOvSipb6xEbNG3sxe8NCnckaS8yq+jx7B3yU8mOEKT4GKDiG1BAnfRj2Y0cdR2YNU/aJUecGxp4cicpmpygbwCPVNMveG2Cv2yKnvYl30ruGFJcUe+PrEAxZU4MJFoV6Nexo9jSLl6A35khfy0bgC4mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJ+u41ZCKHLysWYvXn51TIvc6e6vkIhfy6Qu7evAQQA=;
 b=R2PKPROkrBMFFuJYy4ZIEs4ak/p+cjlGivwHHLnvZVmWQxP25JhF7jjxM+O14XPnxdIZ6pgoy9f7TCpwNZkJxw/rjyE6+LlvfMCNZgRmfr6SyW4uN2vNcOGy0xS+D3aZ9YqEHFpZUAFjS/Fe1mF4dKu8RIuc7o/z0UNiMGZ2cbDbmHNGLeObY5Tz7tDkUwyEktuVzp3Ja+4BabRpHpt/dMzUkLJgy0NCWNbyjAVf4uNDzA8QNCkmF/bUhvYvJJFjaar3wYeGCy7lSgUg0GKvbSiB3YgNYGbis9nhaCTdjvnFAyvx7EkO2/XZmGXNLb3TUF9K+264zmfE0FZH2Oefbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by SA1PR11MB6845.namprd11.prod.outlook.com
 (2603:10b6:806:29f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Fri, 9 Sep
 2022 02:15:22 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 02:15:22 +0000
Date:   Fri, 9 Sep 2022 10:15:16 +0800
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
Subject: Re: [PATCH v4 09/26] KVM: Do processor compatibility check on resume
Message-ID: <YxqhtH2nOwfFV2zm@gao-cwp>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <1c302387e21e689f103bf954f355cf49f73d1e82.1662679124.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1c302387e21e689f103bf954f355cf49f73d1e82.1662679124.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR03CA0098.apcprd03.prod.outlook.com
 (2603:1096:4:7c::26) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|SA1PR11MB6845:EE_
X-MS-Office365-Filtering-Correlation-Id: d7708bb6-aee4-44a9-1d70-08da9209265e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gydYu0KxWxTe67Kxoj5uZXAIl+2qkcY2wKbvoS11zahCwzH7dURX2AnYm63Jnu4z1LWmAI+gPIqRWmKM54j4tD0LzIeGGFE1hqym8ZEAxnyI6zPKUGi0rs9PsJ2KOefsZunOO5BIH7nv6mPcCtxFN2TX49tWPsVmh/NChKEXO4/ELn4Vms783uwUpA2iLPTCErdJLUpYpLO+bWWU0/LVjpJB0IjnS1xcqwTSOhB4qkdYuRoP47yaEVImHdOawSnJd2m3F3LGodPnnjvsMnqoZmDCXKH+DwaTNwmfqomCMu8Cfu9dk/eG4SDaoAJB5AO7YUzUd+lthqMfuJ+lq1X4X3szn5Umg7gT3sgSlUHHjBRKol9AIt+ER0N93BnMYWW6gSq/jfaPLhCEpUdJ+FpwBlLt1ozfrV5weLY0nqXfI1MZYV0V7VNNHkT9S9rlkcyCayxaiyiIF4GVAT+Va4n3+7zny0ovkEh3o9SD6HgMxoriqzO+zkufbaPvXI8d1Xedj+2ThlRTZ7S2l2q8x/FSg9H0n8xyO0+I0mL/i5nLE0odqaZoXdwMevLJ6a41Epq78eVS4MmfXycIILYfJuXk9nPHhDbikag3gGVEWu89huj/BQotP539bGJ5YosFu8IX1Y6ogF5Mqajx3ENTwr1/U2nHFg5ZHVDrUN3d7YXMtHQHre+xlYDoAFSV2wl/oAWaNOnDoG+xx6kuEj62W/CMWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(366004)(396003)(346002)(376002)(136003)(9686003)(6512007)(26005)(186003)(2906002)(82960400001)(38100700002)(86362001)(33716001)(66556008)(66946007)(66476007)(4744005)(34206002)(41300700001)(4326008)(5660300002)(44832011)(8676002)(6486002)(6666004)(316002)(8936002)(7416002)(478600001)(54906003)(6506007)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fERtm+2oPvYGz4CRf5P1rOODHQc5qbdldGffZvaSgYHHDZ/LTktJxdDm9XEM?=
 =?us-ascii?Q?j6V9jtWm10+3saHQBjZSpJo9asrXWILaLP2RE/EHFNf3jZ/4FEwQDfhezSnr?=
 =?us-ascii?Q?iucP2cG0d5VpqaZnicdGp0x3ZNUrRt+V8j5lILM84c1y3h/dKeuoRf3qmH9S?=
 =?us-ascii?Q?StSzUiDptVV2u4HNW525C38nLCXeHd6uCEyDX2aof+i1bnJJGHO1A/XHncpd?=
 =?us-ascii?Q?3XQSSX8uH3m7A6/eOh6TmY+ogmrnHrqQMQm+MI6erVWmWvkD7BqI74/zrBZP?=
 =?us-ascii?Q?yjBR0joWK6KFAFXkomr02rECwMJ1iv5SYSOAvEsryAXUyAp1RZbXhvK6N8th?=
 =?us-ascii?Q?WwD5JIN0vecqaYSBJvEyiCyP/Oa9cFCCNJqO/sFTcM5YpHG3JP6lfM68/3nM?=
 =?us-ascii?Q?qLTssShRvX42STgFNRxEBJsWP053LBQaA5OmsPF3eb7SmwjEAju2Da04ixoc?=
 =?us-ascii?Q?145tUOzn4AS1XlbZmX/tVlftACXX7/thmZ2cdPex/+UI1ag2PEdGCCN0RFn3?=
 =?us-ascii?Q?QuHYglEd6i6n3lbVJXe2iAMHBtEj6WBJ3Hy53jib/de6PED5gL96CuO7V47+?=
 =?us-ascii?Q?033n3gQAul9zcg+FrOuAGAiXzFWUhnrjwCSBw6cpfwFNYsaAXCnrWPteqP54?=
 =?us-ascii?Q?rpB4UedZUAiERRX5Nv3mMmjMkuTAqIQnlcL2IvALCEoj77RVOiXMgQZeKKmr?=
 =?us-ascii?Q?Ez8PqjydQzgqbWtWLcAihkgCrUQqpJo9eip5OTv+j0YXPAcKntdjabbm1dem?=
 =?us-ascii?Q?bV6WOMJacWLz1v7Z1lGVJV6RURdyNXwpRtlnj2HbMdfcXLO/Yq+t4bXGAy7d?=
 =?us-ascii?Q?smfro2X2jqcrDtBHKovoPSgj4VYdT4rvz15Nfifqm6w+kpn4Pfq3HaASONfM?=
 =?us-ascii?Q?dbb2jQLCPE+S4ZM9TFCkHhdhtRNcF4JxjBP24xr7K5sW4P5M2aikmS6O1FOt?=
 =?us-ascii?Q?o/SiGtaAyZ11gBHPLnwtb6AxYTcfIexcdePq+KvDaZbeMj7WhOqypJEOKOLq?=
 =?us-ascii?Q?iHVcQ3fydCAUJghMqA5id1cZj69729w9UHtxKMjseTmZiPt9k5YLnyjdlMYs?=
 =?us-ascii?Q?JpkebmZ0EkY/Uv3HmX61jqpF9B53N6Fqjs76lZWwEEv+9996SN055PudZhs3?=
 =?us-ascii?Q?4vk1CvYqIfRcD/TBxXhfqOMZnbIM6l2MYsWYuhdkoaR11uWC7DkcszRHdA9d?=
 =?us-ascii?Q?45NgJjrVyoPBAP4eVSLUlQlXWfOW3mhqmSFRYQmc5fvf3Ll6F45DWyWLHJMO?=
 =?us-ascii?Q?xMSkl0Oyc/71I6wigLqrd8A7BwRIf5t3keHC0GdBdZt+F/Qs/VoT7INUP8Sq?=
 =?us-ascii?Q?p/1KqdkR83F7IBezmjHelEEXBAZReqOVFuT/Nb6Rr3iH4i8tsMK9HpNa7njK?=
 =?us-ascii?Q?gAZ4hqHJHaMcMBiTzJKpBn12/fpftTdy+VkDVxycdaAcukyUV01R9cGrjFhL?=
 =?us-ascii?Q?ERgy+bX9QX70Vtv1FxKpRZXV50/n3KeUvz0vzGfn/t9KDFh9jSvy2lvWHE59?=
 =?us-ascii?Q?C9s/Ew/GDvJXExlHt/JdRBQcPa+F5M651OS4Eh0Y02LMX5QcU2A60hr2roGw?=
 =?us-ascii?Q?uU039yZRku2nEmgCe24u/HamdTzXm3BegrXH2wnZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7708bb6-aee4-44a9-1d70-08da9209265e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 02:15:22.3347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEb/yGyDFHg6PRJnt+I9ot9M6pceRNNRFJbfJ5dX+eKYCQNxlhhpzHyBKQX4VFEFZRbRgmMVE8tuEVJ0opywVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6845
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

On Thu, Sep 08, 2022 at 04:25:25PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>So far the processor compatibility check is not done on resume. It should
>be done.  The resume is called for resuming from S3/S4.  CPUs can be
>replaced or the kernel can resume from S4 on a different machine.  So

Are they valid cases handled by other kernel components? Trying to
handle them in KVM only doesn't help as kernel is likely to fail
somewhere else.
