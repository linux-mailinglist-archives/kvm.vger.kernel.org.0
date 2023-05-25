Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE20710593
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 08:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbjEYGKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 02:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjEYGKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 02:10:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1443E6;
        Wed, 24 May 2023 23:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684995025; x=1716531025;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=raZliX21fsLMvljBUB2fEbeToyOCAeOsxdSotZJV8eo=;
  b=TxN7AP/iWq+a7XPS60/MVtFU6O6zqPjvrifCrL/ztc6c1HUBT4JW0EAq
   kal0Rj5QTFbBkVchHI/fJrWZ36KxydaWFn4XiTG0jJ9wictcDWcgccj0C
   dex8iWniXfhOF/MF+Rx98dXJ4I2hCqk3moTVzM/VPqOlqXZ744H+8XFKl
   1j5CfJsIPv/D1ROcmyAKXiR/MGdYXOW0qsuHpr9Lt0sUZqSl9xHio64py
   9SD40kfg9KTA5XPHJgQGyKRTcJz9UnNStYeqQ524JpDefeuT/XNjobWwr
   344zElOAKKtzv3R4bWXIT6VhA1gYwNx3pm+nqvGRl62J/4HfmLGZFLHhG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="419514531"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="419514531"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 23:10:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="704677654"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="704677654"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 24 May 2023 23:10:25 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 23:10:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 23:10:24 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 23:10:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7dWpetTvr4EcnNeLuB+YzIPRbLCMuGI5GGszWEtGYY+nykNDW/bssH8gs2nbwocgtBQq47KbrxvMpDIM8ICZeBQsn1PixrvC2WYyNTzkQ1P+OrcMt5FHqH9vXacqIKxN/isnOo9wWUlC4w0/kypi/bF0zM8KebnqXZYnfod4xqFkZkQcNhIBxHx52+Wk28twuI/tO+grXmAApd66f19TkLNc0lLafqHt4OoEMH6emV6u5roekgiQ1loubl5kEHPkt15aRhW8VWTxWZea31LJlYrxu0pGGNInwRxDSy4yzOb0qMygNFRIFSt9dTI9fQR3srgjtZkB68V/XIL0J3EsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUIh7yuUmqzjyUwrlajAw+ifseVBS2/QlX8ryDsJ8fE=;
 b=ei4n1er4ZUxlf+J2sTyEuLRgFOCxgxAfRnrx2pqsYLQAeoUciPPTRDvAGj9sbhy4FGPoHuM7gi1jQI3aPKnKfh+Yrs45G118DSXsJGD87C2LiDqAuF8QpqfaJ3jCAmczaz3dwtVK9ggo1lU5QrU2NlIcdyXldHslxKykQz+8cBqKsdzELmosUkCVmiFsmXzSoZ8GHBEF4LF9gGnLcBpt/dyGyV+aCBmG4c9ajwyUaBfIZNtNVmJOw2P2nOlCeqonrW0YdfN6nd0ZK6KuPyOPJzFtce7m0awq3cY9DdinGmbpEXPqZvIKgAhH0IASaZZjFoLg+YgUqWh8Z1RY07WoVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB7359.namprd11.prod.outlook.com (2603:10b6:8:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 06:10:21 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6411.028; Thu, 25 May 2023
 06:10:21 +0000
Date:   Thu, 25 May 2023 14:10:10 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Message-ID: <ZG77wu4PyBn1z587@chao-email>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-8-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230511040857.6094-8-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2P153CA0035.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::22)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f344ee-80b6-4376-d8c4-08db5ce6b87a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oJZ1XkCWryAjK5OhuFp6yE3iC2Bk2dS+ZtfVfeL9S+6Z49tmGi5/S/lSqc30qGuO45srs3pjyCXn1ioyBcuIp1dV4R0ZH4OfTpgQt1Bz6uGtoCVjbDpckfkbPbVFM1MvxZMZD4RJ92U/t3UcEojpyB2Z4SpilD4yA4W3MGL+m5hdYKFVm48tgHgI8LSFk/BImqj5qIPyzONQISEA4pMHyBWWT5dbvehM9vuSX1UPwosXzeOpmQnnUs4L234xCT/EY2s5OG1TneC4S4jtGqzD6Wy0gg+kvNBypBkUVZL3F4lDqjEKY7ZdD5E8wXuIbRXDvL/w7mb78XXZxffhaMetzxQ8bcdhxYjiE2/aEaz7S6CyueLripQ8BK6vZ/ledGwvbM2s2/bE2sXtN8dubEYMXbvo+mKCDHJZ9IX5GE7WkmI0lkh5qjFMVIpIxHpZh5BAt2QIjxB8H1epS/4Uafljfpqto45wapuE2e5b6FBtvSZ89nAtrq2144usedzRwVW6d9iAkitbZM+W03+6m/O+D7G8WLmsV3jc/hiPj+4DWAcL2jK3AxHq2/xr+q8+CE0D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199021)(33716001)(41300700001)(9686003)(6512007)(6506007)(8936002)(6862004)(8676002)(44832011)(186003)(26005)(86362001)(4326008)(2906002)(478600001)(66946007)(6636002)(66556008)(66476007)(5660300002)(316002)(83380400001)(38100700002)(6486002)(6666004)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JrZRjt5KeFGIpyrrk9cWi061g8CvthrNghd4TQRNOGuiMnIgKvhUGnJzKqav?=
 =?us-ascii?Q?BqeVr/YobIEjjg1GRgcTXIv3narwGhgcz+YEFTdjEo0Gzysb63Sdz8EJD6Zz?=
 =?us-ascii?Q?kOeuSD39q6GuqQvwbvES1O8Rfs7rBSVvBFEkvQuplKK49kpD8wxOPupt+sm6?=
 =?us-ascii?Q?aCGCzBcWwtlMxwqXvOV1gHiaQqZk/o1bmpsjGjbfKp2W20laTy0e0AC1/VQw?=
 =?us-ascii?Q?2FaIF+vzUMSVB6UetPspNFad2XPnAqch9tiEskwNeQrhqdznSzW4x1L0pYPB?=
 =?us-ascii?Q?+YGlm+50HcBOLzy9tG9hguFV8vfuUsJbBEXi/5g6E7LT0txRlx+EHPji15d7?=
 =?us-ascii?Q?HM76XQdb0cTdVf8VL7+y5TYvQhy9f1OVGUehTGrP5oJkz7ryfvXqxkDNIpOh?=
 =?us-ascii?Q?UpGNTxwQHYypDOq241AhsQ7zGe14kmwIXxDJkbIyF3ML18ieVKs2J5ZNjRVm?=
 =?us-ascii?Q?KmnxgKJDIILKhPaMQE9JFfCoMziIDmoYqmYXq0VF00DM3Jd1j0YFSUljl8F+?=
 =?us-ascii?Q?5d30B2kDkNiSUrlB6SwDi/I3hM3Wye3RfVBDy81NpxLkHJJTd+O/w2P80Oqr?=
 =?us-ascii?Q?MPouBUqZTb5PAikGSQOpNw7w4oekRJen4DoMHpOW24O3qtgRcF7L3F/rsWqA?=
 =?us-ascii?Q?Ro1jEI7/UheI7eTV55ifO4dmxHHa2nD3NUI2/iGry4oGCxpMSKwSMPzu5vzd?=
 =?us-ascii?Q?J377d/r1HMFbtcJafAQ+SODWND+UthxHzqURB3HCIUf/z9EKS2n4a0elrBCl?=
 =?us-ascii?Q?fDxTpR2r0Hu2xZB+PecRV8B1z0NJWXCF0qd+HK+8x/2Yi8gsEK2DWtS8qPca?=
 =?us-ascii?Q?x5mhg0jQMj29EynTo9YySrWXmzOgitU1O8ZKEyb0PUN2o1Cilv8eVgV1AgTj?=
 =?us-ascii?Q?06O6ZMVyPKRGgoLcdiPCOGEKmeXYRXfSdg7JfDortK3Mls6yChskRk5bnskH?=
 =?us-ascii?Q?sk7J8yQgjkKz/RHJh4tXK5nhEPCqfvoR+xyLpy58pcO9nsEe881hXlyG5ClG?=
 =?us-ascii?Q?s63fZW16YbIh8Y2RHKS6crzM/3eLd+yKWR6Dq5QiI0FfmZ14C1hqolnsZ86c?=
 =?us-ascii?Q?D2qNKiAMIP1xk0KYwJG0gBYXzYpTvr/Bw0K5IPLCN77koGb1QMvhnYwo9WOh?=
 =?us-ascii?Q?9Ey76OytuasZDosi2aUPRljphbM7lIQ4i8XXgjp8i4tZdUg9XNamg3YlNAht?=
 =?us-ascii?Q?MsMiU4bUjMliS2MPyU+0ALnWfwvcpvi6gj5756axsf7cMo1p5rqlMlcGmcCI?=
 =?us-ascii?Q?be5IH6ELZLfAVQXjHqI4sJDXMtPDV3ZnFFp4zV0/KNeodubDGwe8A48tArgL?=
 =?us-ascii?Q?lX17amhIvQfPGY2UFwSdBCBc8SUCdYaM8Frd46AaDGWJQFOMLPWCuWWSel9k?=
 =?us-ascii?Q?yM9tx1U9FTtNoZE2MyDH2NPebSQf6y9DkpJoxNMrCmIIIi6Fn/C0fxVkbzjW?=
 =?us-ascii?Q?jZrX53HvYh/6ifRIww3+ITyi1ojftS1pQ9CMAojSMl6z2PViN87I3M3rpYqG?=
 =?us-ascii?Q?EvjYmPJcS0MnRO9O/M/vbs8M+aDdGszRsVDefsz1ZqRJonLp6/Xhbs9vRSHu?=
 =?us-ascii?Q?bxz9AeSfjEK0YjPBe9s8m9Gp7z+nWL6x6KWxhwAM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f344ee-80b6-4376-d8c4-08db5ce6b87a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 06:10:21.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ms4+hpYTWGufqbRWtKMtJSxFryduUZkisgprpNZNDbkV0//JzQM7ul/IHDzAepTVoHDTqvwowjB2wnaDFtqUvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7359
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 12:08:43AM -0400, Yang Weijiang wrote:
>Update CPUID(EAX=0DH,ECX=1) when the guest's XSS is modified.
>CPUID(EAX=0DH,ECX=1).EBX reports current required storage size for all
>features enabled via XCR0 | XSS so that guest can allocate correct xsave
>buffer.
>
>Note, KVM does not yet support any XSS based features, i.e. supported_xss
>is guaranteed to be zero at this time.
>
>Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/cpuid.c | 7 +++++--
> arch/x86/kvm/x86.c   | 6 ++++--
> 2 files changed, 9 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index 123bf8b97a4b..cbb1b8a65502 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -277,8 +277,11 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
> 
> 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
> 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>-		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>+		cpuid_entry_has(best, X86_FEATURE_XSAVEC))) {

Align indentation.

 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
		     cpuid_entry_has(best, X86_FEATURE_XSAVEC))) {

>+		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
>+
>+		best->ebx = xstate_required_size(xstate, true);
>+	}
> 
> 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 33a780fe820b..ab3360a10933 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		 */
> 		if (data & ~kvm_caps.supported_xss)

Shouldn't we check against the supported value of _this_ guest? similar to
guest_supported_xcr0.

> 			return 1;
>-		vcpu->arch.ia32_xss = data;
>-		kvm_update_cpuid_runtime(vcpu);
>+		if (vcpu->arch.ia32_xss != data) {
>+			vcpu->arch.ia32_xss = data;
>+			kvm_update_cpuid_runtime(vcpu);
>+		}
> 		break;
> 	case MSR_SMI_COUNT:
> 		if (!msr_info->host_initiated)
>-- 
>2.27.0
>
