Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8971C63CF30
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 07:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiK3G3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 01:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiK3G3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 01:29:51 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330A23383;
        Tue, 29 Nov 2022 22:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669789789; x=1701325789;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QVM3VJbjjzPhfKz4vtHvSrs4KnfbVuc9wxw4FglCOg4=;
  b=Q6a+BiVzGVF314JI44DoEQiU+05Pj0TIJyBz6Bjo93GDaNdpJg5JDHmC
   3wzIIr7K7zqnqCFmdE9HgJH7vlEa+TA49so/Dt0dX5ZQner1bU5QC0813
   m2tKRGDLlcNbLeNKh6MKWH8CNvXOUISciaxhtoFBuSWtsJLQqDEdepv7Y
   jAWRi88FJw5KfZbluq3c3JOf1ewdYkJD6+oVRyKDTEuxjM4XWh/sstDkU
   ifR3znN4LwmQ9PzLffoac7+kiCmF8BXppB57XU0iQeNOA7pTn8wJPlXJl
   3+vU5n+vMCc9QXJ+tqVBb4V0LWXgXmejfmpJZs7uugk7c6sDPTsO3vYrY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="295013599"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="295013599"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 22:29:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="621766133"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="621766133"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 29 Nov 2022 22:29:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 22:29:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 22:29:46 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 22:29:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJg2AOaaYGdoRZElxousoWSqdho//tvepx89Q+qHwre+c4BDeo4CzMtjqAGBaAXxo3IYJPB2WRCxBmCt10OHiUYlUrmbrCHpdIVtUC2qHTrZ7nhMycwL3gogbfCIXKWdzxdpkDLxNqj71VpLbx2jg3X8b8B2UPqemrY2jvxwnv99goR+K79Dxqq8A0qj//77A3h7SZvxa1788yXOFl0AyOa6x/hE2+BwnDOMu7KvOQgS4uTCILT0rrEISkyVL3nBiMwGVJx44gkFqZyz4zCheMEakSd/QDCYSFcikBBLXidPDh7DExL50fRXypopsobTJeOosOSxLt49F/XTyPBh/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Wi+HXYmA5/oLtNL/vsOWOuLDOksRLhap7b8VblmXf8=;
 b=PxBQmqIbvnPcm4a4qA+ZlVOTOWoEign65JeSUvEXHwnsqDOPg1fXVqsnLQhPhcIPaLn+R3ND4fifSfvdpvopVCuQSClYrgSpCHkiqqTDTIvprDseayaA5j+M07QQzwgDBxzeo/W3FeblPtp10booz/2hX68I7UPpmNj8vtomFWC0eFj/WxjaY/tyvkd/2DZTrRiBVdkB32VLVsJd/KaFLFRABiN0wm7LLiHgAhHW/VoxV+nqzrfwEVMEv09d9FctujpADd3teaZu0Le6uEw0ERtpa6WWXli+40ndx3vrETWfVcvIZM/0Rt71kJnTp0ot/t18Q7mwohqMWhVoOSvnlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by PH7PR11MB7432.namprd11.prod.outlook.com
 (2603:10b6:510:272::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 06:29:37 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::5cf5:bbad:8442:f2b4]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::5cf5:bbad:8442:f2b4%2]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 06:29:37 +0000
Date:   Wed, 30 Nov 2022 14:29:37 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Jon Kohler <jon@nutanix.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Message-ID: <Y4b4UURccshroVV9@gao-cwp>
References: <20221129182226.82087-1-jon@nutanix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221129182226.82087-1-jon@nutanix.com>
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|PH7PR11MB7432:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bc0a009-c191-48ac-2e48-08dad29c4108
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: riGOwj12vcu2JxBbJnW8ZCrlFVsDo2lBEkgBd5UQlBY5SwqyylW98cq9YZ5d7BrPzqOqPLLOpRlhXTx698S3fYtHJbQOIxl2mFZ7K9PkvWtG74qRBLFEJZLaH2WuyisnH8/kGHyEJNmBhCzKC+13b6DOhM5QlzR31sPhs0LNqLNpb4jh1BeMq8yIGmfG0kJ606zzeBMqZUSy7jOy8d3xXIgYc6YyzvyJFZRygqkY6iNwB94qqvQiRwVdS0Ubu7tFkNwCv1OAdNLmgj+8tLnZ2LobFBsNq1ELKi2M2eyNFYs9NSfjvDhhgVr8bU1NqA/nIpIluUpDqJowciWrDIZdJd9SHB3CwxLPGMDWze9f+U9v7194KGSEcKIvC0G/Jc8omjocGhoaLKUw2d5efqCA5gxOgnpENi8BU/jKJQTQaBVjAACbeK+fnsYJet7NN39iDpj/h0N//lENKuyp91AwtOrnn3Ow6TfmWcq9hg+fPE9gKlJWI4vw4pwdddvol+M3LslzpOzH+PDswz9xzrjCP3tLEcAO+hgJiJxckS03/5wSI9zM37vHTRNhh+Ifz+X9cydYCQG2P2IB4N0rsCb/jggJZzlcDmfQn8lAs0JLwL5BWF8vknbsF7GlvTHJJVQ+r2t+UenbaZm4oKcW6iIwjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(6506007)(478600001)(66476007)(5660300002)(82960400001)(7416002)(2906002)(66556008)(6486002)(33716001)(38100700002)(66946007)(8936002)(86362001)(8676002)(4326008)(6916009)(54906003)(316002)(296002)(83380400001)(44832011)(41300700001)(66899015)(186003)(6512007)(9686003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sWSH45gECvE0zjjVqXnQc7ZcBoAn0a4p5b666qmMmgA8AkIbr2ADBvOEur/U?=
 =?us-ascii?Q?8vUa595z0BAPd6wBmsJES3Q52P7ENyMyaJ1+OCkIHPLC+M4chlvby2CqdU0/?=
 =?us-ascii?Q?wHNEVW1T7nYPeC/FkmmK8nGgKP7JAwZ5iWXm6CuBR+erYuo/a1ks4AoPKZ4s?=
 =?us-ascii?Q?GSqXG/J3+Mj0m6sFSIPBiv7mEe8fksUWJh2z4V/ePxdFz9XZX6TOxh1eeGn8?=
 =?us-ascii?Q?Usnfv7eBB0KfUVrrVkahClLA2dF9hEWCdkBrWSj2+1KRXscXyzBz1L42ixF0?=
 =?us-ascii?Q?rw+miHwKT/T+umUdoof1f7zErVIsQy9pxDfOadaRxK+E2dpsHEbSrUVthVFO?=
 =?us-ascii?Q?o9UwyvpGHRUowBkaGsDFSWXaKtMoIK3zZC9qDwgTYECEXzLUEVw4N6hwVOcq?=
 =?us-ascii?Q?1W2F/xFuG/atVnwncip5hfe30H9uz9g6nrdxJDueMF7R7Drt4vrSvluWSD/5?=
 =?us-ascii?Q?3fHHIB8Y4gChKrLxrUgMOorPVLmjY3fEp3DSPrEx/YjS88t/SdIktpM0PJDG?=
 =?us-ascii?Q?HK0yR5foLO3qCMtBX8brgyYULq/xcpmikYRkigSjgijH0lvfiRRqhE9z/L5v?=
 =?us-ascii?Q?WBvbk9B47RaUEwsVJpnyx0n4RTMhxFBLe4RLSHeQWeRMUB69Dtg5/MsSSHKL?=
 =?us-ascii?Q?239lkrSgC4eqMKLaSTvIm3gz1t0Xwy947mPq4o4jGY6SiVdbk5jf6kLy+aLW?=
 =?us-ascii?Q?2cmHuh+VHV9HaDjJDmUE1btsEy7ftKiixVHO9V54900v2sPLY8WK1B1lR7JR?=
 =?us-ascii?Q?EQtZktAwTShJDsGm2ie4MvuXI3u1qibdJevWWVXX9CzRYQn/QBpwJ9C69Te1?=
 =?us-ascii?Q?KvUBciTvqSjJ7VIGIPlHijGhFbjLeEN3UQWOAKdmSSsmmfGpYRoAkR4Cg350?=
 =?us-ascii?Q?vxLDIJXSHIRAHsokr0mO6JsywJkhSVcXsXtEC0RgKM+u6JKtYq6wxobcuY9e?=
 =?us-ascii?Q?/M2vw7EKikFhtxgho5WO25IWz5xtv6lMS1b4nKr24WkdGnARfYs4P05yZlDV?=
 =?us-ascii?Q?VKJTkYkx0MPZlLQ4tWrUCEY9JEYkvY5eS0upGsA/v0HE1fZtuL6N9M9AipmL?=
 =?us-ascii?Q?T1EueRZGmNlrTJblTU0OzfGsA4NtzxCjJRg8tXeAKrdf/oUdHwvjQzOTRhBo?=
 =?us-ascii?Q?i08nN2cQgjZHOZvzgafitk8gqB29+T50a+M5AAPYzUf+Aj8mITF+Reshw4C8?=
 =?us-ascii?Q?7DGab5/fLYZLZsYYoyoHzSHOMn52Dh0PJYJTfoIoMlNhIKwcPcOQQpIwkNOK?=
 =?us-ascii?Q?06M1Wa0xIMGI+A49ROma80F9df1pC1Ji6NpaxkY+HRgYfzb/AGPZWlxVp4VC?=
 =?us-ascii?Q?N/cTF8vX3EJjUG8BddBSpa9JJq4jWk846NSdis4sK6/jIBZQ+MSlJGRbHyOd?=
 =?us-ascii?Q?EJ7TBgdaj5JwelhNNJh3ToQOBMXf2moBgsMYBDUArrwfhZBxpMjs7CWNzkS/?=
 =?us-ascii?Q?MIQTBg95SGcUcRt+btRr/6b/SLsRCOIRl3URBWw6Nvxzm3MEk9Qh0q61SuEz?=
 =?us-ascii?Q?ZQ5A+j2Iw+HOf2N7hbO1V9/g66mbxpGFonGUDa/DxvGaCBL3qPOwMUUN5lP6?=
 =?us-ascii?Q?cU79RVNn00OfIlAy36oYDQcx/oyXGwRvBSoWB6cG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc0a009-c191-48ac-2e48-08dad29c4108
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 06:29:37.6945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EU/6qRzSDg4dqSitO5LE481hRYGOfJqjpPK2o21ZFyn0gRKM7BiRUtfff2KMkYWCaWRclzVv/HOpGRSaaKN5uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7432
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 01:22:25PM -0500, Jon Kohler wrote:
>@@ -7031,6 +7042,18 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
> void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
> 					unsigned int flags)
> {
>+	struct kvm_vcpu *vcpu = &vmx->vcpu;
>+
>+	/* Optimize IPI reduction by setting mode immediately after vmexit
>+	 * without a memmory barrier as this as not paired anywhere. vcpu->mode
>+	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memory
>+	 * barrier, after the host is done fully restoring various host states.
>+	 * Since the rdmsr and wrmsr below are expensive, this must be done
>+	 * first, so that the IPI suppression window covers the time dealing
>+	 * with fixing up SPEC_CTRL.
>+	 */
>+	vcpu->mode = EXITING_GUEST_MODE;

Does this break kvm_vcpu_kick()? IIUC, kvm_vcpu_kick() does nothing if
vcpu->mode is already EXITING_GUEST_MODE, expecting the vCPU will exit
guest mode. But ...

>+
> 	u64 hostval = this_cpu_read(x86_spec_ctrl_current);
> 
> 	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 2835bd796639..0e0d228f3fa5 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -2160,6 +2160,14 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
> 		data = kvm_read_edx_eax(vcpu);
> 		if (!handle_fastpath_set_tscdeadline(vcpu, data)) {
> 			kvm_skip_emulated_instruction(vcpu);
>+			/* Reset IN_GUEST_MODE since we're going to reenter
>+			 * guest as part of this fast path. This is done as
>+			 * an optimization without a memory barrier since
>+			 * EXITING_GUEST_MODE is also set without a memory
>+			 * barrier.
>+			 */
>+			if (vcpu->mode == EXITING_GUEST_MODE)
>+				vcpu->mode = IN_GUEST_MODE;

... the vCPU enters guest mode again.

I believe mode transition from EXITING_GUEST_MODE to IN_GUEST_MODE
directly isn't valid for current KVM.
