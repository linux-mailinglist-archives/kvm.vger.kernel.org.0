Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA82C762DD9
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 09:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjGZHgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 03:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjGZHfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 03:35:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE8630DD;
        Wed, 26 Jul 2023 00:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690356816; x=1721892816;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RBemq7HeQlaz3WkKir1s0WT8fb8kxYarvB0aKCWgxCY=;
  b=Lou8zTw5O1YJbvjJi8lUXrWb5fpvjsDfjUjZc91aEMzsZge3cada1BEK
   TzqpM4y2jyFCeutMAswhhhkZRqJLsAsWlTUIJOzuLcUe1Toae0NU+qx9c
   0ucZLgTzzNl4MVw1qKXVRKQVFFQYrXojqN8Tm120oJJMncgF4QdtavEjy
   Jhr2EqeTy8unmFmF5JY/gVgH5MOVco/R6wun4EVoYmp/wEWLzaun13CTO
   HZ/Kt3jjm59lhoMM/4kf1HxCznv1q6beO9yPY0bfu1BcMcuRSGoLjw+Tf
   z9ILm8YBM0/f7xsf3tisGAtizGACv5V31497gCgJU/twLYG/MicyBln9S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="398874665"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="398874665"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 00:33:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="796455539"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="796455539"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jul 2023 00:33:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 00:33:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 00:33:33 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 00:33:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNEnmBEC7JIJ2gQo8p5w0n+wk5yWJ5pKvu6cw3isA3qk/R73pMMhZP4VTZerdchqha6noh7xdYXNAJB3ENP1t2vLmNdV04Lp47G9td/8m0xSbHED7ij61JH49ksdtfS7VraIfG2iE35jTJXkAfgMhI/sZd+ydbJpF0kepzKIsyy1V/WzjqgVe2IgjaXUCMXtYLqe1IVsz3X3ZMid/dZaOB87qX55jL7SGacpGiktPowfHQTo5gVP5UQdF80MeHGVYB7PfrqS0aXHQHSw79hc8WJIEVarfvY5+vYT6T2jZZ2uHkaGyAAmnl6He/D7RJtowtVNtQbvB+KI//VbYkgE9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNNbd00QSfoPsUmLVcetZRp3wd3uPhT0hLyNzxJsk5A=;
 b=i/WCb70+IpKw3mbdsTz2xq+06UTHS7EPUHZDU6yy0d4quGGQyvSGl3XEsLTs8vQtx9J49otn4v99Sy/vOxFl1iWpli3ppRgMigpo4WJGXmiHavuR6GLJFZsFfjAVteYVroHbYq/s7ddEiokqEx4qqncXGqgxISgMWTAQZKsbqN37ki+mHyyr53/wxKHpAGsFCkC3jq4/2nHcIDTrbVWiLqyG1Pyl3U82mNDNYQpTDNJ1K3DMQ76kb//PEBuHHXU+WRkx4uAdxqYXLTaU/otZCpPZf/EH5jHjVqQrrMGCCeoFVcyp6l19+ZaywYX6/nJkRp2qdC/r1loR/ZjnHZeLuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by LV8PR11MB8748.namprd11.prod.outlook.com (2603:10b6:408:200::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Wed, 26 Jul
 2023 07:33:31 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 07:33:30 +0000
Date:   Wed, 26 Jul 2023 15:33:20 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 09/20] KVM:x86: Add common code of CET MSR access
Message-ID: <ZMDMQHwlj9m7C39s@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-10-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-10-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:4:197::9) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|LV8PR11MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: c2fb50b5-6879-416f-7841-08db8daa9bf8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /DNeuK92JmuHOrgNou4/TfO+sVBfkmpGqpOS81FlmM7F7a5ulmIqlR2Xvs3InGr48A6P8zjtD0Oxoz8zsNgeVzoYX8iF4xeSjuV39gIgZjR5oduhhhcOJnO5AdubR4wY6GYhsqiLNx1GebK1K8EigL1EynMexlr1HgpjnoMRantU9PTCBEX+1rIkBA2GkcE3CpqB7i6pKSNpR/56dO/6D2dKgQSKOkT2cmwq+Lbz42ZWkDpwzcui1t22yFai8UAPfjyIFBd1+jTbdOnOsP7QO+OyASD/uWnXJ9TG3vwx9oSi0hQWyMdLo9dDHRzxDHD9MWvIG5uXyR47DFyI3eYXWoT5kaCCoISKBhuJvd/xiyvPfiVBd+NxmXi0L4I8CNQr8xAVwzBY1njHCjH/Z4akAu5TJ4u6Jl2n3rkAN+fAyONZc1U4FgJqx8Y1e1Z07sVhuDd+NSpKj02VSFWwmhU6NDTAuuYgO/0JfG53ySLc0VZf2/bqkeosAf9PAmOnxNWn5U0NjdpKJFavyt9pvP8pQiXAR0K7ufgHMIH7BUWRX7HBduUWNn0zA5S/dJ2I42+5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199021)(86362001)(82960400001)(478600001)(2906002)(33716001)(38100700002)(186003)(26005)(6506007)(41300700001)(5660300002)(44832011)(9686003)(6486002)(8676002)(6666004)(8936002)(6512007)(66556008)(6636002)(66476007)(83380400001)(4326008)(66946007)(316002)(6862004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g548oib88JMz/herhejNYWCMRio2HLVlUEYTI+x+rY4z8YkVR3OHxcW0IJbj?=
 =?us-ascii?Q?SSNRriZxYOwxjW8AvTzRFDVkpsDvcRntSelLiXeKa0OWOukMvtdRY3aCQr5V?=
 =?us-ascii?Q?NiRVXy2bWBafptNYQrgtVGRY385NfoligvMggVm3qpfTuJHamFlkI0lj5oPf?=
 =?us-ascii?Q?mBttt7NDuvmF1o5GDQZy06RXHI3r4JlUqEgFhCOxl0LhpRN2u1vFLJdvVoH5?=
 =?us-ascii?Q?o/ndAclayOMgXrf7uopRnshxTdjbgqlL0DoReT6wyg1leLkTwEKalua5Zrki?=
 =?us-ascii?Q?fcHQ7HrAeERB5B4WwsxHWYbhkZBglQvjthVk6LxIDIaqXxSUMQJlR5lijMSb?=
 =?us-ascii?Q?4Lh5+0xPB5/V9nwVVh+IG6PViE6426A0oDXefJlp978HTeJvstQZbttJaJFg?=
 =?us-ascii?Q?r/GmYc6TANobFAF7Vy/c1sTXAfi8PY6qemqyIQhmf9mM+RQj2xHqNwHnhN0g?=
 =?us-ascii?Q?DPb/ref+AWfLx2tnXlL/GlyF0L84pPi6re0YJ+g+NQvPn0w3GSPfsvWN3+f5?=
 =?us-ascii?Q?F21UrWdozotU7FA8p8U3v03LM2k9tfB5AKD9nspZSvI6AcoR7UOwV6CCVTC/?=
 =?us-ascii?Q?UHIoKMzZhWJwuoffYMETDvvJQd8RTg7NsLFXXr+kw4048aWHN6Rrog8dDeX7?=
 =?us-ascii?Q?qORQqsHe3ZTaOvpH6mnVQ7eLowRMj0gQCBhPRc0KM38OZEThRvnkJJUh4e7F?=
 =?us-ascii?Q?y6JDorQzpdjtnePsGLBQxyEqXtmAIZoPF0/YLynw3iUiQ5+rNtg52dSFLn6t?=
 =?us-ascii?Q?WYP4B874u50vdlXxHEFBoeTU4fXWvdhTdryO3wp6lsNpw8UmVYuQe7NrGC9U?=
 =?us-ascii?Q?wWD1cCA+BNH8rznPLO+QK9UAfRfM7uExeAv5ZI+Q3oJ3QJQ8RVZyOXdTtSRI?=
 =?us-ascii?Q?lc4L50agdMOMQbQHjXQLoWLqmsRTGg4KH8ai7PDkVlBLqbgDm0UwfT8qNDW+?=
 =?us-ascii?Q?MqOt4Pj6rQILKB8UHTtxg4zCDOqc37TOyz4yZYolFpJWbThq4AtPZ5oJ55z+?=
 =?us-ascii?Q?dx2RQbJSpKl+jUf+L/ucMLSPOiHBw/fnEKXg2Pke+h0xRzylVaFVKGCLycMO?=
 =?us-ascii?Q?IZTCgRm56B7JvG7zHNUoTYf9ZymXix6y8zIP5PswQbi73e22/d6UfH/uEUgG?=
 =?us-ascii?Q?PbQR3nE15MDvTvqSDXgZagT3PUHUaxr4VARWOhbjKFGnZWs4V0hRdWYFWviH?=
 =?us-ascii?Q?UmXzTYQM3+tjxcZJnNcNvM8cduz0gG1v+ebw6beB2Idz0gWdIdNsfO0gG3A3?=
 =?us-ascii?Q?ehCVJLpsqR9t0+ruspulRvGd12/v2AvY3FNqj5YepxgBzUUbRWPuBD76QRgf?=
 =?us-ascii?Q?NX60lX50Za5rsd7aFtLQr8rw9OF16WRSrpM17f+k8Ty4aut5/zOKbtxbRYIx?=
 =?us-ascii?Q?tT8MXlBLw4nx7p1Gx+G5pzEPgD7EOxd0xgOunWeJwt9jsN8MVNU7rn+GtbGO?=
 =?us-ascii?Q?hATmj17RFTEr5cuG55jqfOe2gn/Uw6VLgUBKIkcl6sbbni1RLPebwpI/MqXS?=
 =?us-ascii?Q?JzlsqlOQVnKvpOonf6VwqAD5WlSsFfODZ0m01M2scQdp/Jyer8feUwUM8MBa?=
 =?us-ascii?Q?Nsxn+PYGu5NMM0AiB+AmJSzb+u4L6dTcKTArZ3sJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2fb50b5-6879-416f-7841-08db8daa9bf8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 07:33:30.5036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmxXw3v7aIB56XnilS3AiTp0SY6+qZbGNf1kyDJlVCeFl4V/Z4JMaA2YBafk634kU7fb60umIFlqOUF62IY0hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8748
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

On Thu, Jul 20, 2023 at 11:03:41PM -0400, Yang Weijiang wrote:
>+static inline bool is_shadow_stack_msr(struct kvm_vcpu *vcpu,

remove @vcpu since it isn't used. And I think it is better to accept
an MSR index than struct msr_data because whether a MSR is a shadow
stack MSR is entirely decided by the MSR index; other fields in the
struct msr_data are irrelevant.

>+				       struct msr_data *msr)
>+{
>+	return msr->index == MSR_IA32_PL0_SSP ||
>+		msr->index == MSR_IA32_PL1_SSP ||
>+		msr->index == MSR_IA32_PL2_SSP ||
>+		msr->index == MSR_IA32_PL3_SSP ||
>+		msr->index == MSR_IA32_INT_SSP_TAB ||
>+		msr->index == MSR_KVM_GUEST_SSP;
>+}
>+
>+static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
>+				      struct msr_data *msr)
>+{
>+
>+	/*
>+	 * This function cannot work without later CET MSR read/write
>+	 * emulation patch.

Probably you should consider merging the "later" patch into this one.
Then you can get rid of this comment and make this patch easier for
review ...

> int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> {
> 	u32 msr = msr_info->index;
>@@ -3982,6 +4023,35 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		vcpu->arch.guest_fpu.xfd_err = data;
> 		break;
> #endif
>+#define CET_IBT_MASK_BITS	GENMASK_ULL(63, 2)

bit9:6 are reserved even if IBT is supported.

>@@ -12131,6 +12217,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
> 	vcpu->arch.cr3 = 0;
> 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>+	memset(vcpu->arch.cet_s_ssp, 0, sizeof(vcpu->arch.cet_s_ssp));

... this begs the question: where other MSRs are reset. I suppose
U_CET/PL3_SSP are handled when resetting guest FPU. But how about S_CET
and INT_SSP_TAB? there is no answer in this patch.
