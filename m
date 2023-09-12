Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21579C41C
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbjILD0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbjILD0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:26:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BFE4681;
        Mon, 11 Sep 2023 20:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694488171; x=1726024171;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=faoYgBoqo0LPoDVb9cOOmpchLhvj06ANruhvLU2T2Z8=;
  b=IV0pxKtNqKOZGjlkRhq9t8qtAeZALrjdi9tcYFx2chxRtE+oCKmN1ril
   +enzJKHXNL0CabgXbkKend6hFDehZBfShfZJihYFbOfwsTYAAERUT/kUM
   sRdqRl9Wf/AOz1rWL7bxAaCjwlSPYYpsvo/EDb7hxmUjpdZB6B0yBmMGt
   X9wZPajgZE7+CqT/8zo5GUfgGXd7a21Wk1F4OmhUTrkengGWB/JPB7pjA
   xuW028P8TZk4bY1BJ3CFCXdO0HA+f2+z43TgrCBDWgPXFndw8dHZ51pcK
   sods8ribMrA8VEevZBX5Q4ToCgMBvCWOVuzjH0utQu1S7QOfcfA/7I+sc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="442275145"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="442275145"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 20:09:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="858609194"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="858609194"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 20:09:26 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 20:09:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 20:09:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 20:09:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T22cdtnGn+4CZhrm8bwAaNyMqz68Y5WkiL8cnjae05OlsvimLtLSDZnVlyy0S23Fw4jE/8bRJaRmA+h0uNqm5ZlCwDAh0wPYQxu6cda4ChdVqYLryI9vw1uBOy/NECDd26WY2BRSoLa9INFlpKzP5Px87/XwlfZEq1ZuXnStz46UExlfFK6WErvCFQ+APLr9/4A7GGNcI56X4hSUnMty7m911kibxJg4oQkKtOhUQz4G2XMj2cgwpuxRch8bYsDoFQGE7TB1E17bRCfWVjVeevVWrVmMWBUbtS24RsbNn4cHyLA/sbBZ148teijf2ewjY26jfkQDUp9B0fzPprxvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIRZlNYv+gvxkue5T4vlrrJkUxlbyV84l773l5AkgFo=;
 b=cZJUAJBwWvVaWCf3oFIDmFqHAjkLEHHanxXsbkQ4l8nwb9clKvnXkd5GmrQ5vG6c/Dng6gDVh6GgVZGux+ncNp8irVD3xINfIFPbu3DvdXuet+BlMRUHz3iXjKc4j1CVp0h4GjNE3SQ+y14KGQLAhaR7VEML2SIBkIzIOMVI3LY19no+FH92RgjK0Ef2CRVtZSE3iQOY6pJljYlV8aW+iZKlVjMZTCq8Etk0jxrqHfoD5h2iKh7eUhaoPWr1gAGQ0DhIN4RPsqePi60G6777ChJAjybMKT2lKYiTFj0DqB2EOLWXXsHSue+MMOlmgfbUmigbNtNQexat1Wd3ZcCavg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS7PR11MB7740.namprd11.prod.outlook.com (2603:10b6:8:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Tue, 12 Sep
 2023 03:09:18 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%7]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 03:09:18 +0000
Date:   Tue, 12 Sep 2023 11:09:06 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Manali Shukla <manali.shukla@amd.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>,
        <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>
Subject: Re: [PATCH 09/13] KVM: SVM: add support for IBS virtualization for
 non SEV-ES guests
Message-ID: <ZP/WUpKgpqMRiEpZ@chao-email>
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-10-manali.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904095347.14994-10-manali.shukla@amd.com>
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS7PR11MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: c40d859d-8e4c-464d-0f0b-08dbb33da6cd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQEjN+Vbj0Ao9l0NkWyk9Qx17ZqP7rQqINXErbpnztHABPL2EMs/mGcTwD4m6eGTilT9vYvLsgsZ2xkJM0rHHcdscQ1X2IeYQt6+B7nKQnGoKUQ0sJLgirJ0UFwpC9JByzTfhhDuF33vv1gsihrFO5WXGscLohqcazfGzvmBty8y/JSJcb2Ng1bfql3x4VL9Y80D7J6KQU80XSJt+M9/nP3c5VfLhw1HZDfSk1NNSMzptCBZ303Bo44fnF+8L83tftbAIb+gtF5pP5TcTpZsBwEZQkazplyFA6e94gdDYnPoBwgEYFHu4ne7CrkqODM74btgg0KIKAdyYRKF9p5RV9VyS1DmUiZOW5olBjQ1NOfnEho0ytYMpRgUSx1u3u8ghfKqYNJSCGwVdeGKb/unx1AqdyqMoxSeAYdas/6N/ZieQGl2fOlqZS7nFSSIuAy0U1BHZFLYIzVvwf1jY87OXorP57L0tAt65oxTXZAJUZ5U0Ap9TzLA8K6/Gn85XfkigTTOxBRuvV+dzbqfjaG6WMf1j8Gn484fyyLdIzAx2AQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199024)(186009)(1800799009)(86362001)(2906002)(9686003)(478600001)(26005)(966005)(6666004)(6512007)(6506007)(6486002)(83380400001)(33716001)(38100700002)(82960400001)(41300700001)(8676002)(8936002)(5660300002)(4326008)(7416002)(316002)(6916009)(66476007)(66556008)(66946007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8lFITqGZWQscG4EJO0kdiGpK1QIlCSDy61dMm+YqDcOxC25zDWWnc+tZrQHj?=
 =?us-ascii?Q?2lLr1jtKAnNvz58JgMEQobDSd8GfIT7vqdIBCsIgm4F5ENbovMhp8bgedsED?=
 =?us-ascii?Q?aWBguarRvRoLJ3yv9WpDZ71fxW5V2KhDafpUwChSugpna+k4x+n/QzTJyxph?=
 =?us-ascii?Q?37Bmzgng1j0wRI8knqlLzHuzuTRWSB4e3Bd33zETTzhVGOVQ6kHWVgWZUR4Y?=
 =?us-ascii?Q?aGlTyBBGWKPG9xx7+Z33LoeddBQ82Wt9jtUDR4GjJq9srvJmnDsWkBaQBA5J?=
 =?us-ascii?Q?cOP/EeImqQMn/HfFb0cD+6WUl31pSFzDYU8loyVeSHY4p9yDThcuwZNymYWq?=
 =?us-ascii?Q?+5FgtRygfx0TGN+0jcOCURwGsF2ruXJluxZlUhgLBshtVhhb7FVDlz0bZ/SB?=
 =?us-ascii?Q?QGPr4Q1eD+9qMVHJkB8I5UJaB1XaiZO1yuaedyvgX7Xhfwj2g6tIBBLvcwMH?=
 =?us-ascii?Q?0wpcLVbfIi27Iwp0Ac+P/FsZWS8wm9Kc4o208cgkVcQe/Bos1neLgndwnkLT?=
 =?us-ascii?Q?xz9k1FWlWZfOVmVa56DBQh+1UgLij2Zme5zlsIZYZD+1wzZ8hd3KRNEBoFnt?=
 =?us-ascii?Q?G3v+efaNHwlBOh6yrtPbSWrKTbws9FjG7Ien3rhylJjTJclhy7KbkYaQ5uxi?=
 =?us-ascii?Q?0smUjYbiTXlMhUqnAHZ/3Pukk0k6mWt0PEzHfoxoU2t9ytz2oBhKNwrIBSys?=
 =?us-ascii?Q?l1KDzZevqYpQ6uzKiXu080Sm8Fwtzf9yuZzMOm8J2jkap4kldOxl8kdeQ9Bh?=
 =?us-ascii?Q?BZXILEaWFKchZiEAmLVTnGhMJ2/lUXCFLA9pdtism9va1sBPwVyxpqZvP6XG?=
 =?us-ascii?Q?06RqN/RAO5y3HVkUpJC9bvJiji9Kc4vcmLw6J/gDdZytkHhGxjljtjVh6lOx?=
 =?us-ascii?Q?ZIEU3PpLogmYaiIF5qRDd5wgbHoTyGYX92oVzD8y87U5vDKQZhPwB5VJYjii?=
 =?us-ascii?Q?EbPUxoT7c0eYgxKr66ob9LvQ3UsBUHcFunzgCZdNGUAP5he7bCs/bp5Iys85?=
 =?us-ascii?Q?wvjwxSMIRFoIfwkyrOYHrsNf12PxdA/UAjZL+OCQv8M+/61JE92G+juzZud3?=
 =?us-ascii?Q?bHoXqtiTHg3ryB1JQzZXjA59jbgFfEZLdbL1SAtSW9UP8VQYigqz61lYXdCS?=
 =?us-ascii?Q?xHEskaPXbu39ud8+XmMtCdn3lfSovmOcbr4i/XDDXvtrvOjE3QDSRGWEs4fN?=
 =?us-ascii?Q?r440wMnKmZV6hqtLyCV9N3J+hhAuGBeEV90gDu4XwO5Rqt6siMYuJKFqpxz3?=
 =?us-ascii?Q?WEFhv3gnQZmP6asoKz10ktAp9bpVJzY6YABD9Fhgo/xJxuBPScfnG3ughnoh?=
 =?us-ascii?Q?N6hiJ7WRXMHIqv6LBtQKdoowZWUbg44w5dM2EJBX2pR82TQ34XOUvP1mjUyS?=
 =?us-ascii?Q?yfq2dCndy82b+VKwGK51RpUV5NVvHFuo1PLE/KP6sCnr5W/fW8LTe3XFPI8q?=
 =?us-ascii?Q?BZtb5bYzCheTX6MoxpShIXBL4+HTRgMj6ubVFEpGcPT8HGxZN3jAz0QsdRSd?=
 =?us-ascii?Q?4lZktkkt4sP4hU5fEkV+KkbX8kSGhldyvCu3Q7k9qIAGoLYhxMfEQ7FEyMnM?=
 =?us-ascii?Q?/gNUZsitEEVBX6RlR4sQRmDVhQQPNT7Bge4jHIR3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c40d859d-8e4c-464d-0f0b-08dbb33da6cd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 03:09:17.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmq7i87W1inbafx2PaCt9bsNzXCbLCMYVY1etxGMKty9bpW/o0J3iyMEs8GWU+PJsi+iOVUXIzuqyPA7sR7vRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7740
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:53:43AM +0000, Manali Shukla wrote:
>@@ -1207,6 +1241,29 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
> 		/* No need to intercept these MSRs */
> 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
> 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
>+
>+		/*
>+		 * If hardware supports VIBS then no need to intercept IBS MSRS
>+		 * when VIBS is enabled in guest.
>+		 */
>+		if (vibs) {
>+			if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_IBS)) {
>+				svm_ibs_msr_interception(svm, false);
>+				svm->ibs_enabled = true;
>+
>+				/*
>+				 * In order to enable VIBS, AVIC/VNMI must be enabled to handle the
>+				 * interrupt generated by IBS driver. When AVIC is enabled, once
>+				 * data collection for IBS fetch/op block for sampled interval
>+				 * provided is done, hardware signals VNMI which is generated via
>+				 * AVIC which uses extended LVT registers. That is why extended LVT
>+				 * registers are initialized at guest startup.
>+				 */
>+				kvm_apic_init_eilvt_regs(vcpu);
>+			} else {
>+				svm->ibs_enabled = false;

The interception should be enabled for IBS MSRs in the else branch. see:

https://lore.kernel.org/all/ZJYzPn7ipYfO0fLZ@google.com/

>+			}
>+		}
> 	}
> }
> 
>@@ -2888,6 +2945,11 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 	case MSR_AMD64_DE_CFG:
> 		msr_info->data = svm->msr_decfg;
> 		break;
>+
>+	case MSR_AMD64_IBSCTL:
>+		rdmsrl(MSR_AMD64_IBSCTL, msr_info->data);
>+		break;

"When AVIC is enabled, IBS LVT entry (Extended Interrupt 0 LVT) message type
should be programmed to INTR or NMI."

It implies that AVIC always uses extended LVT 0 when issuing IBS interrupts if
IBS virtualization is enabled. Right? If yes, KVM should emulate the LvtOffset
in guest's IBS_CTL MSR as 0. Returning the hardware value here is error-prone.
