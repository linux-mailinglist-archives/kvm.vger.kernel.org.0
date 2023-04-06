Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B506D8E16
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 05:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbjDFDtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 23:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjDFDti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 23:49:38 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D5C3ABC
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 20:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680752977; x=1712288977;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gUXgvChyZz8znFjsq1kUU1VIOn/+00OPiLIQMMh9ptQ=;
  b=XoNTf5EV4zNvAEbkx09a1iA+Gi8js4AKM8M1L0RiZv9LzKDyaIGV4k46
   8hRYLboRLb5wHpTwBQQEnC+ujPcZ9PL5FhNe3ELQ7dWvE5hSUf1nNakpU
   BoMYzbZgPtSLx2HiR8si7i8ipRJ5RR9cc4KVeuoWezl0M2d0A3nUm+7W3
   1WaKl9j1ivEzximN5uETbQ2oF735QU/XApZf/axwyvP9YeuLbCupzPgQ2
   7V5kn7qz7OAARv3+vyi0IS60n9FZs8F3+1rjJXoWkfYyQ1x8wYI/AKB/v
   q0vqsfyv+V8UATOtX/SSbW+pSCpQG2wFLJ3sDlU3CY1zEnIq7FiYjlCb4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="342644137"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="342644137"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 20:49:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="810844565"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="810844565"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 05 Apr 2023 20:49:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 20:49:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 20:49:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 20:49:35 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 20:49:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHYFISrkXg4/1ZQB5VSzPhGuhfoDzROc7odwFOszdunxYye6iv1eGhnOSXB4LB6PT0m8ra+TEogSjm4UmWR8HpceYYRNbPBYlmI4D34eKUs1dQZUkV1F0FQtUtbklpE9GytNnrx1zvkdm0Yc173preJyQEacYYIqEu/ep1gNLNQfdYJIug5MXxaiBz8xWT03OEsetwNZez8QYN5cRqpYO1EGWaaSTPNEPxBXT+65oi0BTRNPTXQTB0IalOLYH8Q/DZ5c6ub/CGI1SojeteTFbGH1IKYLxL8iv76Cqk+bcBgCHy2R8Rez4aofyQJBOIEMmL3C+Fc4zsbUsm/OmvCm5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=un8Ps+CQsbW87wqMMblsejC0bxUf8xVtBCbDuK1cc1U=;
 b=nQHWEvtWKSk0BBWvDJ2qwKH7hI3EaJppXayrPhdFckDbpEFLOQdNfWh9YIWeghD+p5oYjHU8ocn2d3uspdNvGLlpAdaLNrTQYz4KnAh1Sfo4KjElvnK7Erdrc9qCSgWhSLPkVZfirCOh7CzGHhHBK4qc7GDw5NDOt1+XVirIB0lrNoPB646na4bftDTMps9MgzO4CU5ioFTBJk26azfw43enMGop4xicM9TR5JAnXpmOD4nIDuWiLPoYsWybcAHz4yaYAk0uOpPPGeoiNcTRsL9X/gwHPr+QQOFHVFBh078SfBY3fq/CQDDQDf4BVZpO2s6UYgYSuMddZZgAmMM8dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CO1PR11MB5172.namprd11.prod.outlook.com (2603:10b6:303:6c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 6 Apr
 2023 03:49:33 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%6]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 03:49:32 +0000
Date:   Thu, 6 Apr 2023 11:50:02 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v2 2/4] x86: Add test case for LAM_SUP
Message-ID: <ZC5BavtkM5TRa55a@gao-cwp>
References: <20230319082225.14302-1-binbin.wu@linux.intel.com>
 <20230319082225.14302-3-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319082225.14302-3-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0166.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::22) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CO1PR11MB5172:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b9afd08-532f-4fb2-e731-08db3651ee33
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aa5pjgHQ4hQTcDbN2Z3I/cKeN0tAFoP2SwR5UfuG1hrpzpvfjP3lymc+hhYH9DGKvVbWv2qIa2VY9Cid8JtU/Oo097RPvjavfLUNkZbEa2G5MZ6TODm3myqmwTLQX1KCctz2DWurIC13BRhGI47u99YdPMteV0yuyt/qP1x47KinsdUz0yxaQk0kNRkhQ8b0hvPjE/h1DhMNQ75wYstO25xlJe3JiBtX1ojHvh2quDGTPN/7Hhd8UMorpTA04LjSZgKWyk94n34iS0ZYcVCWoSOJCXqtd9oMODUfABtvQY+znhnFX87R5XMdp9YCxXIA+57SRJqqCF31a8MHHpy3ZK4L/G9lcKWG/pK2Y3ksD4RQ6U5rv8gSsoXetawv4PMH60/AlQUXsHPiSBK8cl7z/pwkDylJE4AYcdL3hV4a7eQHndeJ2AHpM/6hdEcdGbsvXyx3llC6s8zIQRdh43+3jnj6SXAtNn8FGGkAscZJm0DafoNOpWsyy8j+DCIyUzaVSLyGeFotHJ5ZloR/ALEXmNueyxhkTJH+rbQ2d2eiiz/ng8rAoQuBO5+XsiqAD6Q4I33SGPHFyq5HPzA8LztB6jGU74uFvfB12RV7QYyu0hs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199021)(8936002)(33716001)(26005)(186003)(5660300002)(2906002)(6916009)(83380400001)(316002)(4326008)(6506007)(8676002)(66556008)(66946007)(6512007)(478600001)(66476007)(6486002)(82960400001)(41300700001)(38100700002)(86362001)(44832011)(9686003)(6666004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B1q9CbWBwKnREjaSnkfkMFXAhDDKMHtrGwbiKG9zlw4CX4PcgVAnjdOehm5u?=
 =?us-ascii?Q?JBAq8AudZFEtY8PzxEOLL0vt50aT8W5xn6bZYmA/zIylrJXB4Y7uiWyuQc3g?=
 =?us-ascii?Q?p34WOG1zQDeg+Osnz9SuaFAQnZbd696z1DWxAHucaFkXzn8pEBn0T31EuMUv?=
 =?us-ascii?Q?jofXNyTG6nv52NTRTmJ22BL7GzecAlDZranfBBHYc1++prwsP6JbmsNFYtsM?=
 =?us-ascii?Q?04z7jUy7k4SpK/PyCxrzz13OuUTryvJ/7k6T0MGQRTCmGpuEOKt/iwqNEqWW?=
 =?us-ascii?Q?bCfU0YWDKt+cHHmIToV9rnsr0ULMQX5L5eBNVPRY5SlSwBr8zWq0G3dkRXSR?=
 =?us-ascii?Q?T0QV0q2AN3CLACsQcjdC/vdXYIL87Kd68WL1Pz5dx9vqTSgp+Rznwql/bP+b?=
 =?us-ascii?Q?qIpXWKhkaq8SHFAGf87DqtZ8jYqzgSZjufWPV8vjH+5dio1BtuHCXWUOP0oF?=
 =?us-ascii?Q?IlGRrsrnOMyPGxJzcc9BVLTeVBtsTZESmxjFwYKWhUjK00NkOATEPlZrABKn?=
 =?us-ascii?Q?To1zxr3OJRP0CUXHq7ksKR6n/A0cFfabnPGmT/M2Ouob2doj1v8Tm4bL9Dx0?=
 =?us-ascii?Q?scI0YPp2xzSQB54W/cqeXIp6sAFZCz7L60THyI7LT+4tzVKinab7mVu0hKBX?=
 =?us-ascii?Q?V4ZOiI2aaTrJ43AjG1Jlo3/u5xsQ8YG4fXBL89Q1uCap26q40UTe3ssLn259?=
 =?us-ascii?Q?XNxTx3nCIP697i81DkHHDE66UsYbRIkZfcMACLNsq3mzqERj4lS9V5Uy1QQQ?=
 =?us-ascii?Q?jjKl1hWznxzpSUv2+KVhcs8a+R3B9ATs81DOMCcDjOOhMBuF3T7WaySah7iH?=
 =?us-ascii?Q?Ccsx+EBW2ln+Ntyn/qLaMbXNjlgBIm5ybGszMhh2xCmHTjBVQznAFUTP3vTX?=
 =?us-ascii?Q?SePEagPphziheXEXbHGy5AH2auyP1Cw7MtwCQ8wjZeGwDZk5wj0/uVo2Si2m?=
 =?us-ascii?Q?0nyADlJOB6d9g8BqR3eu3dkRKfiwnJpSKYPohHZMLg7COPv/Mc9woCScaDr4?=
 =?us-ascii?Q?RMG09AUtpyDfPUzpe87V/kTfYz9JNnu37fm8RJdcqit05rX6iO9dnT/wBwWZ?=
 =?us-ascii?Q?ifL4V7CO5W+cpEXsw3llmLFy6TDzg/Tgp0oVdXFl9AIBB/1IaKmNkoGpgWQT?=
 =?us-ascii?Q?II/Kgke1NZH7zeqq7QhQJYQTr0hSh5SYB598Udjr1XUB+62YmwVqSixv98bu?=
 =?us-ascii?Q?UUdq4tsQXgOgDfnptjPhcuHzqX9HQT66yAGQkbeyA68xdWpfl1MfXIgmmZ6+?=
 =?us-ascii?Q?lXTQ5Nc/0WM8StVEEdFgJJojeVZyl3QOKI0nI4DuW1/vXxaS7Jk9qk1/K8rb?=
 =?us-ascii?Q?sXSh4FZaAJ4WT9WqFhcvmAhBfqwa32oIxW/LTvYPhFk9Mda6l1Pw2MIlt8UE?=
 =?us-ascii?Q?BR7EoxLuzZfjHLnl7i3N5KYUYROrn1SABM/TFYImN81p3u/1ggzbCtJpKV1E?=
 =?us-ascii?Q?xvxzhCrFBbKtI6p/8HRfPX9tN0qred7aHSkNQRNLg/+vYUgX49ZoI3Stivjc?=
 =?us-ascii?Q?Zfc/zP+IvJi4++LU646P3iA3Ty0pNIl+/+MhKOsZcXt+5njV75dd3hFbzoRa?=
 =?us-ascii?Q?kyB6ZvOmnF2CTEprPPNf4dM3uuP3ikKlMm+U7oCP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9afd08-532f-4fb2-e731-08db3651ee33
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 03:49:32.2962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ML2JjMTqHR6b9yHzAhIEEkcwUOIIiQVWWy3DMv6VfxlWLu8NEUU8/RVVE38BD7FvXNrfL0Se0NKgulXaR0kZcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5172
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 19, 2023 at 04:22:23PM +0800, Binbin Wu wrote:
>+#define LAM57_BITS 6
>+#define LAM48_BITS 15
>+#define LAM57_MASK	GENMASK_ULL(62, 57)
>+#define LAM48_MASK	GENMASK_ULL(62, 48)
>+
>+struct invpcid_desc {
>+    u64 pcid : 12;
>+    u64 rsv  : 52;
>+    u64 addr : 64;

u64 addr;

>+
>+};
>+static int get_sup_lam_bits(void)
>+{
>+	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
>+		return LAM57_BITS;
>+	else
>+		return LAM48_BITS;
>+}
>+
>+/* According to LAM mode, set metadata in high bits */
>+static u64 set_metadata(u64 src, unsigned long lam)
>+{
>+	u64 metadata;
>+
>+	switch (lam) {
>+	case LAM57_BITS: /* Set metadata in bits 62:57 */
>+		metadata = (NONCANONICAL & ((1UL << LAM57_BITS) - 1)) << 57;
>+		metadata |= (src & ~(LAM57_MASK));

this can be simplified to

	return (src & ~LAM47_MASK) | (NONCANONICAL & LAM47_MASK);

and you can pass a mask to set_metadata() and set mask to 0 if LAM isn't
enabled. Then set_metadata() can be further simplified to

	return (src & ~mask) | (NONCANONICAL & mask);

>+		break;
>+	case LAM48_BITS: /* Set metadata in bits 62:48 */
>+		metadata = (NONCANONICAL & ((1UL << LAM48_BITS) - 1)) << 48;
>+		metadata |= (src & ~(LAM48_MASK));
>+		break;
>+	default:
>+		metadata = src;
>+		break;
>+	}
>+
>+	return metadata;
>+}
>+
>+static void cr4_set_lam_sup(void *data)
>+{
>+	unsigned long cr4;
>+
>+	cr4 = read_cr4();
>+	write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
>+}
>+
>+static void cr4_clear_lam_sup(void *data)
>+{
>+	unsigned long cr4;
>+
>+	cr4 = read_cr4();
>+	write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
>+}
>+
>+static void test_cr4_lam_set_clear(bool lam_enumerated)
>+{
>+	bool fault;
>+
>+	fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
>+	if (lam_enumerated)
>+		report(!fault && (read_cr4() & X86_CR4_LAM_SUP),
>+		       "Set CR4.LAM_SUP");
>+	else
>+		report(fault, "Set CR4.LAM_SUP causes #GP");
>+
>+	fault = test_for_exception(GP_VECTOR, &cr4_clear_lam_sup, NULL);
>+	report(!fault, "Clear CR4.LAM_SUP");
>+}
>+
>+static void do_strcpy(void *mem)
>+{
>+	strcpy((char *)mem, "LAM SUP Test string.");
>+}
>+
>+static inline uint64_t test_tagged_ptr(uint64_t arg1, uint64_t arg2,
>+	uint64_t arg3, uint64_t arg4)
>+{
>+	bool lam_enumerated = !!arg1;
>+	int lam_bits = (int)arg2;
>+	u64 *ptr = (u64 *)arg3;
>+	bool la_57 = !!arg4;
>+	bool fault;
>+
>+	fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
>+	report(!fault, "strcpy to untagged addr");
>+
>+	ptr = (u64 *)set_metadata((u64)ptr, lam_bits);
>+	fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
>+	if (lam_enumerated)
>+		report(!fault, "strcpy to tagged addr");
>+	else
>+		report(fault, "strcpy to tagged addr causes #GP");

...

>+
>+	if (lam_enumerated && (lam_bits==LAM57_BITS) && !la_57) {
>+		ptr = (u64 *)set_metadata((u64)ptr, LAM48_BITS);
>+		fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
>+		report(fault, "strcpy to non-LAM-canonical addr causes #GP");
>+	}
>+
>+	return 0;
>+}
>+
>+/* Refer to emulator.c */
>+static void do_mov_mmio(void *mem)
>+{
>+	unsigned long t1, t2;
>+
>+	// test mov reg, r/m and mov r/m, reg
>+	t1 = 0x123456789abcdefull & -1ul;
>+	asm volatile("mov %[t1], (%[mem])\n\t"
>+		     "mov (%[mem]), %[t2]"
>+		     : [t2]"=r"(t2)
>+		     : [t1]"r"(t1), [mem]"r"(mem)
>+		     : "memory");
>+}
>+
>+static inline uint64_t test_tagged_mmio_ptr(uint64_t arg1, uint64_t arg2,
>+	uint64_t arg3, uint64_t arg4)
>+{
>+	bool lam_enumerated = !!arg1;
>+	int lam_bits = (int)arg2;
>+	u64 *ptr = (u64 *)arg3;
>+	bool la_57 = !!arg4;
>+	bool fault;
>+
>+	fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
>+	report(!fault, "Access MMIO with untagged addr");
>+
>+	ptr = (u64 *)set_metadata((u64)ptr, lam_bits);
>+	fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
>+	if (lam_enumerated)
>+		report(!fault,  "Access MMIO with tagged addr");
>+	else
>+		report(fault,  "Access MMIO with tagged addr causes #GP");

Maybe make this (and other similar changes) more dense, e.g.,

	report(fault != lam_enumerated, "Access MMIO with tagged addr")

>+	if (lam_enumerated && (lam_bits==LAM57_BITS) && !la_57) {
>+		ptr = (u64 *)set_metadata((u64)ptr, LAM48_BITS);
>+		fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
>+		report(fault,  "Access MMIO with non-LAM-canonical addr"
>+		               " causes #GP");

don't break long strings.

>+	}

please add a comment to explain the intention of this test.

>+
>+	return 0;
>+}
>+
>+static void do_invlpg(void *mem)
>+{
>+	invlpg(mem);
>+}
>+
>+static void do_invlpg_fep(void *mem)
>+{
>+	asm volatile(KVM_FEP "invlpg (%0)" ::"r" (mem) : "memory");
>+}
>+
>+/* invlpg with tagged address is same as NOP, no #GP */
>+static void test_invlpg(void *va, bool fep)
>+{
>+	bool fault;
>+	u64 *ptr;
>+
>+	ptr = (u64 *)set_metadata((u64)va, get_sup_lam_bits());
>+	if (fep)
>+		fault = test_for_exception(GP_VECTOR, do_invlpg_fep, ptr);
>+	else
>+		fault = test_for_exception(GP_VECTOR, do_invlpg, ptr);
>+
>+	report(!fault, "%sINVLPG with tagged addr", fep?"fep: ":"");
>+}
>+
>+static void do_invpcid(void *desc)
>+{
>+	unsigned long type = 0;
>+	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)desc;
>+
>+	asm volatile("invpcid %0, %1" :
>+	                              : "m" (*desc_ptr), "r" (type)
>+	                              : "memory");
>+}
>+
>+static void test_invpcid(bool lam_enumerated, void *data)
>+{
>+	struct invpcid_desc *desc_ptr = (struct invpcid_desc *) data;
>+	int lam_bits = get_sup_lam_bits();
>+	bool fault;
>+
>+	if (!this_cpu_has(X86_FEATURE_PCID) ||
>+	    !this_cpu_has(X86_FEATURE_INVPCID)) {
>+		report_skip("INVPCID not supported");
>+		return;
>+	}
>+
>+	memset(desc_ptr, 0, sizeof(struct invpcid_desc));
>+	desc_ptr->addr = (u64)data + 16;

why "+16"? looks you try to avoid invalidating mapping for the descriptor itself.

how about using a local invpcid_desc?

	struct invpcid_desc desc = { .addr = data };

>+
>+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
>+	report(!fault, "INVPCID: untagged pointer + untagged addr");
>+
>+	desc_ptr->addr = set_metadata(desc_ptr->addr, lam_bits);
>+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
>+	report(fault, "INVPCID: untagged pointer + tagged addr causes #GP");
>+
>+	desc_ptr->addr = (u64)data + 16;
>+	desc_ptr = (struct invpcid_desc *)set_metadata((u64)desc_ptr, lam_bits);
>+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
>+	if (lam_enumerated && (read_cr4() & X86_CR4_LAM_SUP))
>+		report(!fault, "INVPCID: tagged pointer + untagged addr");
>+	else
>+		report(fault, "INVPCID: tagged pointer + untagged addr"
>+		              " causes #GP");
>+
>+	desc_ptr = (struct invpcid_desc *)data;
>+	desc_ptr->addr = (u64)data + 16;
>+	desc_ptr->addr = set_metadata(desc_ptr->addr, lam_bits);
>+	desc_ptr = (struct invpcid_desc *)set_metadata((u64)desc_ptr, lam_bits);
>+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
>+	report(fault, "INVPCID: tagged pointer + tagged addr causes #GP");
>+}
>+
>+static void test_lam_sup(bool lam_enumerated, bool fep_available)
>+{
>+	void *vaddr, *vaddr_mmio;
>+	phys_addr_t paddr;
>+	bool fault;
>+	bool la_57 = read_cr4() & X86_CR4_LA57;
>+	int lam_bits = get_sup_lam_bits();
>+
>+	vaddr = alloc_vpage();
>+	vaddr_mmio = alloc_vpage();
>+	paddr = virt_to_phys(alloc_page());
>+	install_page(current_page_table(), paddr, vaddr);
>+	install_page(current_page_table(), IORAM_BASE_PHYS, vaddr_mmio);
>+
>+	test_cr4_lam_set_clear(lam_enumerated);
>+
>+	/* Set for the following LAM_SUP tests */
>+	if (lam_enumerated) {
>+		fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
>+		report(!fault && (read_cr4() & X86_CR4_LAM_SUP),
>+		       "Set CR4.LAM_SUP");
>+	}
>+
>+	test_tagged_ptr(lam_enumerated, lam_bits, (u64)vaddr, la_57);
>+	test_tagged_mmio_ptr(lam_enumerated, lam_bits, (u64)vaddr_mmio, la_57);
>+	test_invlpg(vaddr, false);
>+	test_invpcid(lam_enumerated, vaddr);
>+
>+	if (fep_available)
>+		test_invlpg(vaddr, true);
>+}
>+
>+int main(int ac, char **av)
>+{
>+	bool lam_enumerated;
>+	bool fep_available = is_fep_available();
>+
>+	setup_vm();
>+
>+	lam_enumerated = this_cpu_has(X86_FEATURE_LAM);

has_lam?

>+	if (!lam_enumerated)
>+		report_info("This CPU doesn't support LAM feature\n");
>+	else
>+		report_info("This CPU supports LAM feature\n");
>+
>+	if (!fep_available)
>+		report_skip("Skipping tests the forced emulation, "
>+			    "use kvm.force_emulation_prefix=1 to enable\n");
>+
>+	test_lam_sup(lam_enumerated, fep_available);
>+
>+	return report_summary();
>+}
>diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>index f324e32..34b09eb 100644
>--- a/x86/unittests.cfg
>+++ b/x86/unittests.cfg
>@@ -478,3 +478,13 @@ file = cet.flat
> arch = x86_64
> smp = 2
> extra_params = -enable-kvm -m 2048 -cpu host
>+
>+[intel-lam]
>+file = lam.flat
>+arch = x86_64
>+extra_params = -enable-kvm -cpu host
>+
>+[intel-no-lam]
>+file = lam.flat
>+arch = x86_64
>+extra_params = -enable-kvm -cpu host,-lam
>-- 
>2.25.1
>
