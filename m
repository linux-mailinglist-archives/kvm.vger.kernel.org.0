Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F9F6E736D
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 08:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjDSGnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 02:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjDSGnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 02:43:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA6855BE
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 23:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681886618; x=1713422618;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oVfRfyIbWkktHL2PM9qGTjZ37SiB+PooN+X/lyLCn9c=;
  b=EMsvZA/pvcPmBG2VRe3Wx0twNEOMCMaRurecUYK/oH4objEHmpDWC4gj
   y3VdcmraO3EtNMWdnVwdiz90p9UCPHZVqZ44TAc8ZZaMXGGSEr5c/pTV+
   uR+amJ+7nhescBHjAix7LG3RFmIIhgp0j+vmZQIVzVBciaN+mW7OEyJwI
   k5X13kI0+IpCIdQnRhRfBFtmzGag6jKjb0knCjw/K4P4D20qH+y6iFfeq
   gYLjCrKHwyxQItsArTKujhVwuqflcYXRSz1x9N5v5ClYoLlvgaqPDZ6Ft
   Cyvg341oIVnZXawU738m9F2asSydMztGyQ2bFmUX622hJO1G81pf+IxLo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="373246663"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="373246663"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 23:43:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="780745755"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="780745755"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Apr 2023 23:43:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 23:43:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 18 Apr 2023 23:43:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 18 Apr 2023 23:43:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASa9PoJrIgVYlfwELa/+GNzz7K3gI/VL7gSnSICChNhtGKXeIjf7k43L/J/EFK52kFRUhfeCM6tGWKBU8zkdBuHn0dHPxa6W54+awBJ1APv8nmfMWUgtkUTnTYzU+33WLZbYTPDDoj2DQY4DAUNdpCs+/PjRPbzvKMuKGUU6m5atHJDbSdAQipt9FdIZYafq5kUCB79E7cWaL+yqmpmotm/0ulluJXNWMQqeH1Nh0+XOgNBZz7BfVO3D/tN7TQMVCZSf5/rS+DLfgbRAoGuspZjvJ2nJDfaUwFKf0kMwI1IzzDNUOBcOxO5hnFZC+f6QwNydCvzVRHVGmQIEvEUNew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oo5qi3GLIZDfLjxfwAU3FR9mXC8Lvb73AZouBsVDVUQ=;
 b=YqPUYFMVSa2q5atVKFBUwf1NOX63C1FbSkUNl93LAayTgYNaPLm+JA+XUN8ohUvz5Moje8dIKZFJ191QUB8xqngzKkl/EZsgP+0Cv4IJVLG58UO3u77LTkhsgsXYzcsdPh64gdwRjjMR2aGIVLMXyjG7eyRmGDELzv82LU74Xn8jQJiG+HWe8N7MCiC4uZJ7hd2Ydh1G9ulwwU1csjIXOJTIbYY1SmfIkktl/Q2EFqALYbePmgoIE7/0lcN78sWkW7rwB64oz+qi9kxME+Hno96IsOHigJsQ9HbBsBNv+f3H/e2WDySUKPw1tNU68/wZKNKwDypG+DaRUaWt3QmPow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW3PR11MB4652.namprd11.prod.outlook.com (2603:10b6:303:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 06:43:31 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 06:43:31 +0000
Date:   Wed, 19 Apr 2023 14:43:20 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <kai.huang@intel.com>, <xuelian.guo@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
Message-ID: <ZD+NiODiAiIY55Fx@chao-env>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230404130923.27749-5-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR03CA0098.apcprd03.prod.outlook.com
 (2603:1096:4:7c::26) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW3PR11MB4652:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a62402-8092-435c-e85f-08db40a16375
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PbUNdaZzDZ9DVPontU7XI9DSKR6RSIkJXDS2Pe8p+NZXzPEQkBNOonM3w/hpD4SDWUHh8w7lr3mVzAJYsySuBQWjKTLCUMpDm9C2aq5OrFogsJf8dapWzkWKfnIDj2dtrbCXkOSeo13xle4ynRCHuim2mcZqapPyd1ZbDIjBwCQN/tY6M4/LznQ8k6f2DQ1yQmfnsqTfUDojJSFosDaRhx07wb3DQ1pccCkETUSoPKUoPeb/kF++K5j3yTC0lZ6Q4jmW55+K5md/DZAh/nkNBk2LbIoUGFCm7Dl1l51aBxu7HVtxrkxlh2zKBKRmrivUywT/3SWw+X6xq3m1WFp6/CI9/jARbWQHkP7oxwZ2dAnNc3QWqpwIFTCKPn2CX7My000QeVGQznyTPvAqPWaxTl5NiGEie8pcWNVcPAUw5zaPLvESjvN1KR+Qmfc3lkcxjzV9W58Dm1hDbRnAT5CqiTLuhagWAKeRindytPZChL/wejUI6hfpJpYiMqbFAWIOWkqw42DbYw8fRd67SQgUQ4aXBmIOQxFDCN2zxI6my5UNhvNhq7JR+3YJsQN1FAkTxgQ91kE3v6EVFr6SE38CZpqPg9FNm4o9gRoG83v17wY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199021)(2906002)(44832011)(478600001)(6666004)(86362001)(26005)(6512007)(6506007)(33716001)(9686003)(6486002)(186003)(82960400001)(41300700001)(38100700002)(8676002)(8936002)(4326008)(66556008)(66476007)(83380400001)(66946007)(316002)(6916009)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8rdhcGKHKhbzSuqsdqeNfObtX4R/eFbNtM6CTsgC/R3g3G2spmP7/bQG5fZc?=
 =?us-ascii?Q?f5yutJD6jos3FSZdZcn2Iwf3f+Mhad5x6ggiCx1qJkLT71zKNC/mAA2oil3M?=
 =?us-ascii?Q?7yO5CuO/jB+uCWVHNZk02i5B/x28TGrhAzvctfWesGqeOy7dWJTHIiM8hqcp?=
 =?us-ascii?Q?sPc4pYmjLF/JgmLDDvO5b4VSOAVNiZv69CIxl85pOlpJQosLF4+efw+GtOf0?=
 =?us-ascii?Q?am3H9jD0bAtd03qB1hgoG+/Zs3s0qLIm8DLT36AhaUVgTi26Dty49t6GZiP4?=
 =?us-ascii?Q?GXordTRs4HNAKdBNWj/8CbWOQVLfJAq9oXmJrRqoipIBAWVlwdTPhncW2iQh?=
 =?us-ascii?Q?H8ktExRVAjE+Gu4URgD4c3KHSXr6lA/tqqx9BDLkblTZkSy0YQq/4tKO04zW?=
 =?us-ascii?Q?MdukB6CHoLIxNU/DlKVCy3mZTOH0LoY8bqbt4VAw2tBoQPZbWbrpG1oOOlpi?=
 =?us-ascii?Q?lAHVz2X+lN9coTjYS1ErKJX/uvMz6ZQbJYuiScseQNN4TEwQfEHjWL/4GAt5?=
 =?us-ascii?Q?j/UDgXU2HUkStpQzvKSj3WjoLeK+h8OfsBdP8sjo/p9B2HnVYpdl59NCb8VY?=
 =?us-ascii?Q?dyHxJhzfgQOOogYtuRxNZVwwQ3Qaz6dIcRAANIAbHjLbtzlEDN3NBFZM1QW1?=
 =?us-ascii?Q?ZcDJv6DXMj9wXzTNKfghGwHPxITtxiTInKrF0BC5fCmy894inxNC4MuhPSQ3?=
 =?us-ascii?Q?KhjNGvcOqAMduyqcJ6oPWT7MMvMKouTWK6vL133uSamc/v2ORrysk5doRk0L?=
 =?us-ascii?Q?mLAF98D5Lwas36pxyrIpVKMBQ5aoptFqqfFvRjYVj1vwF59mfLsuf+CkiYku?=
 =?us-ascii?Q?HiuSgeetIwP6NFXgamaZ/6IfIirHCllnZVqsCiOJI7r8Frb9h7xLC5Pu1muP?=
 =?us-ascii?Q?Nh046s3mdcCE7p7U+VWbBl8JbkYOMiAy7te8MaoaIg0wM/F9t2ezvCQTHljt?=
 =?us-ascii?Q?qIaJsH8xOdn3buRWCBgDmvx2Y4wreSFksR1YW8UXKK6Le5uz26QNIOeZto+5?=
 =?us-ascii?Q?p/Pk4ogD/+r5nzt5eBl6BjhTAv2lIyxd2H90t+IK4j5Oc7FcN2jG3463jWAS?=
 =?us-ascii?Q?h4rQf6klnCTXyAPO34GCdk1sji4tfXXlsP/FUvJGZdVdkC5sPNsN8IxKXecz?=
 =?us-ascii?Q?Q8AKSBGSoYtbdzkg2mxNmJAUYKfT2tEW9sZzOEc4uSBDLFod0hMc35JsfWO4?=
 =?us-ascii?Q?7v7X6eZjxP5o3gRcd/5Q6r6Ne5+FGq+gjz+5Kn2sfs4mKCXuH1xdTpC+Z1nv?=
 =?us-ascii?Q?X3FAblYEBIB6ftkxdwqXLjEYf2u0DH6kTMj565oQoFteBsMN8c5/JkowQeML?=
 =?us-ascii?Q?VwsehqdsfFd9GNs/9ik8T+Eg4o92SaRLvAu7FCw9df/DQqQg3xmoqOCbsTxf?=
 =?us-ascii?Q?BnYFZm2v1arGU4cn3MotB0NbRPco+x5w8+Y1czr4/6MT2Jbi4oJjsj5grocr?=
 =?us-ascii?Q?iAaNfXWkeF1QQaeHX8N8pmuJMEhs+Hvm0MJ3U1AkaLP7cKaVyzSDNp4VmSfl?=
 =?us-ascii?Q?ojlI0VQnZRu0t+esX8/RGLqKSuZn3jvWUx8DPLuY/haBqQ+eStERFe9JAMCK?=
 =?us-ascii?Q?rjveJfFuXj+zAX43UPgPvu3jibpAdttugqc0sBfL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a62402-8092-435c-e85f-08db40a16375
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 06:43:30.7730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NX6nvjvDPMhcvV0NkyK7PEPzOVquNcRj0BONYSuFVba6Cz5+TdaxWaxpR/3KqmoAuyVtPv2uSGDf+xoAiHwJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4652
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 09:09:22PM +0800, Binbin Wu wrote:
>Untag address for 64-bit memory/mmio operand in instruction emulations
>and vmexit handlers when LAM is applicable.
>
>For instruction emulation, untag address in __linearize() before
>canonical check. LAM doesn't apply to instruction fetch and invlpg,
>use KVM_X86_UNTAG_ADDR_SKIP_LAM to skip LAM untag.
>
>For vmexit handlings related to 64-bit linear address:
>- Cases need to untag address
>  Operand(s) of VMX instructions and INVPCID
>  Operand(s) of SGX ENCLS
>  Linear address in INVVPID descriptor.
>- Cases LAM doesn't apply to (no change needed)
>  Operand of INVLPG
>  Linear address in INVPCID descriptor
>
>Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>---
> arch/x86/kvm/emulate.c     | 23 ++++++++++++++++++-----
> arch/x86/kvm/kvm_emulate.h |  2 ++
> arch/x86/kvm/vmx/nested.c  |  4 ++++
> arch/x86/kvm/vmx/sgx.c     |  1 +
> arch/x86/kvm/x86.c         | 10 ++++++++++
> 5 files changed, 35 insertions(+), 5 deletions(-)
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index a20bec931764..b7df465eccf2 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
> 				       struct segmented_address addr,
> 				       unsigned *max_size, unsigned size,
> 				       bool write, bool fetch,
>-				       enum x86emul_mode mode, ulong *linear)
>+				       enum x86emul_mode mode, ulong *linear,
>+				       u64 untag_flags)

@write and @fetch are like flags. I think we can consolidate them into
the @flags first as a cleanup patch and then add a flag for LAM.
