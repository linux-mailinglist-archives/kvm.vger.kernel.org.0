Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E224E721CA6
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 05:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjFEDr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 23:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjFEDrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 23:47:55 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951B5BD;
        Sun,  4 Jun 2023 20:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685936874; x=1717472874;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=R0rpYcUaw0euASXvlOxLAfqv2nWskRX4HVQGMZx/t3s=;
  b=OyuaM9tSxTG4UsMftyCjPY9RO8o4q2lD8hZT+DgiHbVpjei8z2z7TRv2
   0xgcL/K99JAqSkLQoRy8DkXf7sAloW3kRnlaLY7hHkEDMtSY6sjIDP1b7
   jbPxBUC1qykTm55W/79bw4CddVHvlKSWIcFtnZ+2iw15hhv0PK8jTDvtw
   G7o3ee0O+bhrduQoqByHGjwBqKZrTiFucsC/MlJYhx/4BVZ7aqnAx/Eux
   5Xh8LBH7FhmIj09xDTd8EmrYZpsq3zofaJcGCqW9HX0njCr1yfb1vg0yT
   rqKaZx5nvP+lw/Q7vfI4MXyay9CPTq1IRe9QM7bV3SJcpHCZa42iO8I+J
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="358720387"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="358720387"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 20:47:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038623491"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038623491"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jun 2023 20:47:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 4 Jun 2023 20:47:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 4 Jun 2023 20:47:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 4 Jun 2023 20:47:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRbr6xbSuNDTrmJthqyJbcK1GtzXJ8GWNFZxjBS1sQqZwrODMeU66mY8n6YxB8Gy9SYQwXvUJnYB4gg1PQ8qN41W6aPKXV87LkdhGmpnxa/HIH2QRsgHyaF54yb0ea9b8ULliGnEhzLQkFAoDt3CnySoKpi2PlbHZ5vOk1NCJQoxTsXMqWvBcFVtZsXDxg7lcMhaBAMI7+psxkTWq/0URryU/MyPd7S1u2NszclAN6Hi6ujrIpdBqpihQn9kUOqrHBSB0g9uUjBm23vxoK7foO/65T2ARnPwTdgdueVpnneFKDqwfqEG5ZfJPwRmhMalCHaXhxQptG7T5ATUgX+zog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hx1DIM/kkFMAoF5+bxgGRp6+2mkdjP+3UhXFjKcfKkI=;
 b=mr9S76V5UpI7845xrQr8AdIbQqO92RoKVPZwSrSziTG7iNRAkRNf638BuiPFSfnhFF5FCMdRbAIPXspdGW0K9xDxl3Tq0oJJ23wNK7BWyIi7gTXu0y6EICN32mdVKNisgy1cRfrjQRiWrUFsVd8j09Qld/M6DgPnjKDv1mQwPb2o0aPs1YVLT9zdmKQAPjfdi6d0GW9etXtHHME7NRPQ6fvGHb+G5l28YLyY+HAA8z8QeJosJU8E03rIH0wMCLQIhv6iEuSpz/QvtYVRSbR8vTyBgRX3J1pHIH9X+pb66cezmUKpM5issfEjXrIWIbBYqQyak+Y2iWTaRi3oAULxJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB7323.namprd11.prod.outlook.com (2603:10b6:610:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 03:47:50 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Mon, 5 Jun 2023
 03:47:49 +0000
Date:   Mon, 5 Jun 2023 11:47:37 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
Message-ID: <ZH1a2ep4o2xiI5wO@chao-email>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-4-guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230601142309.6307-4-guang.zeng@intel.com>
X-ClientProxiedBy: SI2P153CA0026.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::18) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: ff7c9197-02e1-4526-e224-08db6577a19d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjcSNRavpFadr2R4LDVTnQQGCP8r95dcgttLxsbw4t6+0vVipTb8NKB5JlzwwF0KfOgSTwCB6hLvBsZxCGcjkRu7GA0V+arV3gYm1AjDMlcVymFEcELd3BcpzulPp404BY68Z7oAWpJ++ZrbB+2L6i4xP2tt5NLFZq9oZcj3T8LsKraB4o10JPUzc+6FIwqj8CK/OrwiOBqkufcNBgeXTG8AXtfMgU+AhF7/xn//zpdLe0TBzDP2H5tmB0bwLJ+6ywfl/T2/D8RJRvnPyLhiN3o0e9JRa8Gj9PNX78FEalju7sgNp/CQa0Xn8Z+Z26BucoSxAw8m9zx1/Zu5XL8YW4RWdSHCFpYLpI5GrAAoT0Imj76cRD8TzCqEq4mPS2h4OYUOheSCcPLrhX8XO6nDvzQVaHQe4nKWcA6D0+hg7enmIqQLI2sp4v1ZR4S0RAvfEzjb+ZpN5IMIYFCIzsXcB/gh0ouvgB1MDV9jeQUzLJOYR6374PdQUh0SlTKlhX/H6ocK7R/LmmyCb5P+aBR5078nVVGv4L/wKQtprjXwjpB5bERFSSDPyNzoBmGgGPfc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199021)(8676002)(6862004)(7416002)(8936002)(4326008)(6636002)(66556008)(66476007)(66946007)(5660300002)(316002)(41300700001)(54906003)(44832011)(4744005)(2906002)(478600001)(38100700002)(82960400001)(33716001)(9686003)(6512007)(6506007)(26005)(86362001)(186003)(6486002)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5PTeuFBp0AXVgigwjm6DiPKSzueQZw2yZal0LH80IrPQqNGBAlb80KYd2rrE?=
 =?us-ascii?Q?js1yqHLzN/NBC5C7aWoPcSRenQdxLhb3+jJ0UIRBCwaHCk4a91PLJzzcF1yk?=
 =?us-ascii?Q?UC9mgyKnTXjpoIzCHSzOAJeQ8kT97PGlgsKQnkQO3YpSY0cA3+3NnoYVIbwG?=
 =?us-ascii?Q?iypxt1G7+PDOiSlknvEXAM1evBOtSKKOX0EA4NAaXGo6g+C/x5JaFPpngK7g?=
 =?us-ascii?Q?rljwunIJjG7YBaxCv0Mgua3bTxAs/wrSq1enJRtcJRSJYW0rq8ZKTMpie5DP?=
 =?us-ascii?Q?l24BeMt9pBBFEpTv38k1yZvBeRxiBkfmyAgut+45QHbHXQ2ke/yKV24vadV8?=
 =?us-ascii?Q?XFMokuAuaTiKvkDadjZIYe+4S9HyLj+k7qkwohI+MYTNfLrdYKG/kk9/fdiZ?=
 =?us-ascii?Q?a5hCiL1+88OI1HIFjIPUwqP573KBa98vcsBi3QfF863myEVljfYV5VZI4Ptz?=
 =?us-ascii?Q?KA98M9epNIzCVwRtM/V6DWOHidhi8hwa+0S415FoX6lWOq0uypigm1KvRR/p?=
 =?us-ascii?Q?TjnpJb3o5Y3GOVHlM3v4UPtS/Pb8ErOXXWJCk7ba30hFsRw/YbwWIZh/tR8H?=
 =?us-ascii?Q?HkqQ/b2/sp85FR28zEqVrmhXv44yocNzmrjPwBR5AmeZmtMLfwHEmKwXV2kf?=
 =?us-ascii?Q?K+rUESxiE/HxjWruz6VRlR8ebo2cuOMGHDAR4wIWcck3zhEo7geTrlRSjldR?=
 =?us-ascii?Q?0pYrZs3pFl8PjXydlOB7cQzP2VWgKgkDNYCNyc2sTCx8lqbA3L2Xlv31L5R5?=
 =?us-ascii?Q?IhknOA7qsUlxgIsz2dVKMku2xM/yB3zrmRXlKtpT2/le8sYk9NRMI1w4OOYz?=
 =?us-ascii?Q?IC8Zs/a5LB1Sy12RaSmtnR5ib8xv0xDPnbhtDmY5qBrkJf/U8btXycSg2vjh?=
 =?us-ascii?Q?MQsJzu9XLl9Cyh94ZHHj/lwF4k002xsZd9FOXfS3aTlHPwr9xoHOS4YHpbTN?=
 =?us-ascii?Q?tAbbd5SHLgFpYs65BflJMPXVF6qaI8+MUorSkd9VZsBUEeGlH1xgC3NjHS5i?=
 =?us-ascii?Q?D/WmaNXwnCYDgAhAS+pK2qA38ATnBOny6CFYL6SY6tYWQNQd28SG1qcoRbvU?=
 =?us-ascii?Q?ICzKpn9xWMR/Naq0HbmD/3X6K/1RGfVUSeAWdgBUN9YwtpoBeTILhYD1hGav?=
 =?us-ascii?Q?qQM57UBEdyxoIzMEm8AbOf3l2IoSXDa0ld1Ri0+m5toS8SJ/3XMsyIr3dl/X?=
 =?us-ascii?Q?xPldfTg6kL3LiVV/qwcIbSaxFMp4V8oNjRjUfQ3+jrSTT9tJtGXJhLTsxEvh?=
 =?us-ascii?Q?l64qufeOewNzP52E7rQ84ro8ECHrHC3aA8B9HDJb4eXVeZ8F9u6QAk0cBvFL?=
 =?us-ascii?Q?kK0XaW2ciYXpoDkOgk5RUYz6ubyrINY0vzFjCYJ1GDE7C59novUgT7V5LNIN?=
 =?us-ascii?Q?WiqpmfgzKYkTEIWJNeqjHagwPBKwbAyZjM+5o3nnJSRZoxD5F/8+++SBXqxa?=
 =?us-ascii?Q?ECwfY38yToBRjbveLErfBubeT41c85kDceMrqPKYWQoJb5farf2x9LInVYfc?=
 =?us-ascii?Q?qB9dKaiSc6rtt7UtRX+bTv+As/M5GuhcLjfaAvt1ZbsYFbL70Bki7TN8p/c+?=
 =?us-ascii?Q?cnt6MrvLxHi3rVzp5Pz0QWUG60hg0u5wkaPmGUaG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff7c9197-02e1-4526-e224-08db6577a19d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 03:47:49.4219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wr1JuiVfhgML8XgN5AwHGD889MhrLLTy8F+4bN+hHCx+i+iS4sW6d6tZSbRr+B4Dls+YUVwvZOuxb7ZY+vZbZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7323
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 10:23:06PM +0800, Zeng Guang wrote:
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 92d8e65fe88c..98666d1e7727 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> 	 * Returns vCPU specific APICv inhibit reasons
> 	 */
> 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>+
>+	bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags);

It is better to declare the @la as gva_t since the address is a virtual address.

Both @access and @flags provide additional informaiton about a memory access. I
think we can drop one of them e.g. adding a new bit X86EMUL_F_IMPLICIT_ACCESS.

Or maybe in the first place, we can just extend PFERR_? for SKIP_LASS/LAM
behavior instead of adding another set of flags (X86EMUL_F_?). The benefit of
adding new flags is they won't collide with future hardware extensions. I am not
sure.
