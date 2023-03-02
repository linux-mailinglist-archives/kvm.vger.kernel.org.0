Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413C26A7BB8
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 08:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCBHRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 02:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCBHRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 02:17:32 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777F93B648
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 23:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677741452; x=1709277452;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tHQAjgS9lwd5yv8Em0MPoyDkWha9blbR7qx1E1qq6gA=;
  b=RZPYKDd1gjIUXQcCgah1KxWqO5C33AcDRvloTegJUrBXciZM2foF0IBH
   f9DL3D93j7EId7qd3vKn/30iAOqhud5BKTyfJMIzam+mKHuYPegLMfDrQ
   DeU1mqjZF1UHwisOxEoH/PuvDJ5TOyULu6bSyuzz+dkriDhhAQFe5oqL4
   wCRuRpqq7QeBY949V+d2Nn5R5q6Ip2QqClK2+zVvJ8LfmY9wD8mFXhmy9
   sn/3ZNDXo99GhYEyRtOMcKVZeEwPCQC5OhLj4TIi0a8R6aFeQQb4JPOfR
   5TzJCiwHKEL3a2JkJMWUlkjtmW+kWu+AAMWe7zAx47bvptdudg67kJwcK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="315060646"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="315060646"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 23:17:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="784683968"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="784683968"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 01 Mar 2023 23:17:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 23:17:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 23:17:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 23:17:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2zjIWrOxXUgEOtGJ5EOiCSZHQnNKWGUEGaq4UrEPaKMGmyaBo3X/RqBdHfEwLjoMiKOERXseyH2IuxQq5dvyLGN8lkwIRhRSXtt25DSesOl6y56w3tr+9pWOzNvcfWuRjInTOgPKB65ZGwrvmaWTFVCSIcvI+9cwIB52qMD4KNPCXSQf6WsrlGIACTEaVfvC51XOgEkdkGbhJluA3rX4ipawwCQprS+uN0j3252Y+HT3560BD6BIkSy+AjL7KBlu2/UtypoZRG/5Uu4cc5f5AbdGIg0UrXeqVWnYlUUK1GtqA0bzLNwjYq4Fe6y0xVXeTbPqquqPlra+emo2izfzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXZc85jp7XDX2DEKNJjpc+cul7HCpZW4G/3zZjZmhG0=;
 b=XUdDyFWSqGExt9mZpWok+JZl5BNGfi62kCUtKmTG8i5mhbHZmv7U1vc8hSb4E0+teGc7hVs30XmoZFVjhtJ8hKWW2bRweAisSgPQrmdqbyzvOdTM0HMpe7FL0HbcKotXHb6TJdkzD4KG0uYkZm0f5BKRQkJhHkaFThfAS17FnOFEcrajdWjelBuyCk+XefAWxu/ZFswyFg0JLQeiJi8GnUS4XrboxtKcMylaOF8y+TCguM0HAUJvbFKW+KL8o3CU9S8/Ezh9SJIYDXXUNR4OzlFFa7MQpVsYAEl/lQoB6HKbQJF6le0GC319BOFlz0mwv0H+IToJzuuYTEN5ROgq+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH0PR11MB5689.namprd11.prod.outlook.com (2603:10b6:610:ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 07:17:13 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6134.028; Thu, 2 Mar 2023
 07:17:13 +0000
Date:   Thu, 2 Mar 2023 15:17:36 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/5] KVM: x86: Virtualize CR4.LAM_SUP
Message-ID: <ZABNkFpypTK5tvYW@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-2-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230227084547.404871-2-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0213.apcprd04.prod.outlook.com
 (2603:1096:4:187::11) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH0PR11MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 443b57e7-f721-4b4b-671d-08db1aee24be
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1zwb6z+qmVdCQchN3gUtzga5TgXdfEqWARFlJA/DihIOWhFgQSYBr5xMjlYzfmlTCPq55hBsi2S6+1XetVy8eFAAc7sVL52JEew5z9pTn4Tf66JhWKRz3448ZwJRWiPhuF+9MH7m4r0Aksf70U3UIskMc/YV10pwTzJyc5U2nfp3NJjiXuxI/xc3h0NbzUEzDMAz0ZTO/PWQdq0VoUcu2plRQbSdbWzTwJUPoVRQaTZA7UvUCNkWo2eykM3v4fEoLMvV4Ydczk+JBzsTffGOvGUyQ1sEoeHrA3GlffrDbehsRzofSvnJcmxvrBN4afIAXGxB054QY9RKpeA9NNypUUpGqGdTlxpjsDtS70gFDgLZmmlkWgaHwZTGuEKHuY0xn8K0rg7fzIhIcpg/dxLaQM9k3qk2MLnrMefpeW/eQAcfxjtfaovucNe9oBXwJtrSQQYtdhKXr1Td62MGEc2TZiJYSoWxLh2t+ptA26rdoqf5NVrYl/gK21wmMM3RuRkgjK0mzoR7/vfCpB/IpgWJU7h4oTPVK85jaRS2CrC9mTD6sJXho7yhqc1xkM7c6zFUvmHEuLwrJDmpcJAMzgtZuYUaeFKygPt06DT69DZ1PMpJ2knXgWiE//NgvjBSQ5EM3EnrebhqmCZNly9AbC+GlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(83380400001)(6666004)(38100700002)(33716001)(8936002)(5660300002)(82960400001)(478600001)(86362001)(66946007)(9686003)(186003)(26005)(6512007)(6486002)(6506007)(66476007)(66556008)(2906002)(8676002)(44832011)(6916009)(316002)(4326008)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7AXsWzkO7DK+H/JvfI7iZ0RoGLQ/lna3X8TU5J8YspeA45643+duZLAP5xsq?=
 =?us-ascii?Q?MQCpcYb/02E8kCGMLePQ0hlElrHQZyzwdZTpUVJavrHDW3PwQSARxzBBhVR8?=
 =?us-ascii?Q?x40RpsYObszNwTqITgFw6zQWooGu3Gm6x98mUHLaGDUwcjn7AHwWuY6Vf3Y8?=
 =?us-ascii?Q?f7gj+196KGhA4Vqeivr5/EfWYE4JvGsc1seGHzPogvtXO2XM60qKCm5Oy+tW?=
 =?us-ascii?Q?5ar4xqY7RDkuQjAv5Chis7VTVbrvVSMnJFAu4EbKQXguv55cq3o5VLz6ralE?=
 =?us-ascii?Q?4MHGvF5ZE8SzyKWRb+OqgUDROS3ravmlzteNu6liqmY8MwIBKH/mEEvPaD2+?=
 =?us-ascii?Q?4usZ0UTf8YOF9MCpgvHCuyT37NbNlUiZrMB+H/hpaSRjg1trPODf/2Y/VoKs?=
 =?us-ascii?Q?Dn7L08QjSvOV6URf5EMk5xQpXru7gvn2syi17pMkLyt/Zo1lkVxSw8UmMvdi?=
 =?us-ascii?Q?UW+VhEm2HfGI7NDy0BUcXp5343Bf2i5qxgNr7H8+kpU8zNM7DWFHaYt0kOPH?=
 =?us-ascii?Q?F1Sf9B31amb8J9qH7VUPO5t59wPQt9QNBOciCInHtgM28Ilxhe7ip0yfNbYr?=
 =?us-ascii?Q?orQktKjVej/ispYL9l8mCmvz+2zK47fyBrh+2EwPMmfnS1OEGVaGwr2O973C?=
 =?us-ascii?Q?tanOHWTy6583+Y5KasUhXbFAki7GHntJZLuzoKF+MXFAhOqQg6X7enRAvbC6?=
 =?us-ascii?Q?pUd3+wJdqeArHKcajtc9m+dpDWC9x0+F2pJhin6UBKVpp9yjZDZSlKCbzI2w?=
 =?us-ascii?Q?hRwptOXXc9pPDIgRKc6yK1oes1+Szgc3MJdB8KV7PCL2yFh6Q+31WusM2U9s?=
 =?us-ascii?Q?++TGy6E8eLOqyusBDyWplkVj4tC01enloTqgI4oCKGtIoyT258Ns3nf4MQko?=
 =?us-ascii?Q?fXfFoy3APWI9b6G/ttU1//ZT43C6wdfXCf14ck/m+5E7Tw6Lb8Jx0A8M3c2S?=
 =?us-ascii?Q?MwSLzsA46wnWCKvHY4JEJpTVEtxjoV28B5U2miBhGoOQTkpGNMf3Z92kvIHm?=
 =?us-ascii?Q?ub3guBd1LVOlBffq6RTlMiCEAsT1RUPIWOiWidqIdRPe2gcDUWsZOoK57d9s?=
 =?us-ascii?Q?0J/DzbHemnPAb1l6ulpttMsfjea5FM5T1Tml2G718+VqfUG/Eo+7Zrp7MZdP?=
 =?us-ascii?Q?zptrlJ6PHnW4mO8G+7dLLbuhOv06Bd0zlVrnqo+j+4VPjKMQ8peMbDTQHthR?=
 =?us-ascii?Q?7aNS+t3nI9oa8gRg2o0laTSZe7ll0DKCJtU1EKEzKls43K2Z9D4oH1zG4nTX?=
 =?us-ascii?Q?CpycU2Pnz8WKeef0lLexFMU7uqRucnq6JzgSf7WwbIIjF/ACfF7GxL9aupFI?=
 =?us-ascii?Q?Tz2s2qZ/HLjLNYMlM+MYvQSsuEiWA3UX+BUoQEQoBekwfakoguiuqLqm+8rG?=
 =?us-ascii?Q?uP5qLesc5iirdmGVbpGBbbNHpSyqHlg/2EnooexnSHrHTI3/jnCBjdFq1ekW?=
 =?us-ascii?Q?o+I90xJaWIA/AKkSshgPzPzkTtUSUhBSGAVzLcEa2QPYIiYhmBLHMBIynFSg?=
 =?us-ascii?Q?8FN6LQCm1asvDLkTTUlrb1Yrr4DV1Ss6u+cHn+3tORMsvA2wYAhOLOOY65pK?=
 =?us-ascii?Q?LmStL6tSv6bJmGjXq3vtKjd4WkkN0L654L18bQrL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 443b57e7-f721-4b4b-671d-08db1aee24be
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 07:17:12.7178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VzKV0FvABQRVVp/b+bSMhI6r1n41Gi8BwiJD7BfUd4qq9OFbNwRtOndX8vErd347dZlq4SUQu57APXF1ixsQiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5689
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 04:45:43PM +0800, Robert Hoo wrote:
>LAM feature uses CR4 bit[28] (LAM_SUP) to enable/config LAM masking on
>supervisor mode address. To virtualize that, move CR4.LAM_SUP out of
>unconditional CR4_RESERVED_BITS; its reservation now depends on vCPU has
>LAM feature or not.
>
>Not passing through to guest but intercept it, is to avoid read VMCS field
>every time when KVM fetch its value, with expectation that guest won't
>toggle this bit frequently.
>
>There's no other features/vmx_exec_controls connections, therefore no code
>need to be complemented in kvm/vmx_set_cr4().
>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>---
> arch/x86/include/asm/kvm_host.h | 3 ++-
> arch/x86/kvm/x86.h              | 2 ++
> 2 files changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index f35f1ff4427b..4684896698f4 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -125,7 +125,8 @@
> 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
> 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
> 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
>-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
>+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
>+			  | X86_CR4_LAM_SUP))
> 
> #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
> 
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index 9de72586f406..8ec5cc983062 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -475,6 +475,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
> 		__reserved_bits |= X86_CR4_VMXE;        \
> 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
> 		__reserved_bits |= X86_CR4_PCIDE;       \
>+	if (!__cpu_has(__c, X86_FEATURE_LAM))		\
>+		__reserved_bits |= X86_CR4_LAM_SUP;	\
> 	__reserved_bits;                                \
> })

Add X86_CR4_LAM_SUP to cr4_fixed1 in nested_vmx_cr_fixed1_bits_update()
to indicate CR4.LAM_SUP is allowed to be 0 or 1 in VMX operation.

With this fixed,

Reviewed-by: Chao Gao <chao.gao@intel.com>
