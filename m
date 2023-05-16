Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1A97043CA
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 05:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjEPDCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 23:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjEPDBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 23:01:55 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCB5BAA;
        Mon, 15 May 2023 20:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684206114; x=1715742114;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MOEY1/ItYTH0aATSPtlgrgH76Uuienatc9+jVCCKu7s=;
  b=P3AbF7jL9r7Y/fu24c4BY4L6xeuiJdjo/a45ZfB50o1vqYcVxXiNfhhh
   raCaevvmsdMtve/uj8bD4s4kCyPWhdCOv0VJx7zPPKf1pP7l8sG3qoQt1
   aF4NmG7juEjBtJ6mUdXl84UDImSqA+wKQvKsutpyfGLme0n+O3AEAOcNr
   RDZDPo6P78mFYsenrJzSGaFwXLcEXEnEuy9raltplnA33Kz7r50azO+d5
   LTN9DYLNopt8nT3yfyDYQdbCyY0yhvczDMVTTS3D37ITcIG2QXFTi0Rv2
   finioKPbPvp6KpRYP0ef4oIaq1PXw8YLFg0AIq11ONlNtCcazBjWugIcy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="437708300"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="437708300"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 20:01:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="770859772"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="770859772"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 15 May 2023 20:01:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 20:01:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 20:01:54 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 20:01:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oM5nt1M/3U3vZiikGrk7UJbuehuub/ErUO6iDgFbtyVwd0YaLP6+wqOnCxRZmC0aQwlZKYZUmaSWUwp12no/4Hl3JHI36gw4wXKQ3h0bKQHZ+qo3TKeZqVVXLvy75O1K9c9AB5s38UapFsp7H9654uTYsr+gVuhfgrLbH4iZXVkgzNB0aG0UhGy+/sFFnIverduOrz37wqsiJRRXku7vkhqPRG+voESNvL8z2CEnu9FwKmP7Yq8yXBAkgBWLs3Wwh1jpHN0HUkxiKk2zJqbf00ea+GmQTyaHDHb/qxo/v5vIyc+edLAu96d9sUf7Wie57SV8rCufXGInBpy5mZhkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yldc9p2LJzaTPY277qdHdyDKLZs30+ePqDOXBlmxixg=;
 b=ls5qez8O1+cWTNc/FdkIK5EZI7p07NEI+8uJg8Ld2kQiArDGlT80IBXTNhtBRBFcSq+K0F5QMiFtX+Flftudpe78XBQVNvSSaCsgdZkoTfYLg2rJcxAtebyt12jUx5IFxHC5wWr93GaXKTOgBe6tCmKqT9ypGRJojrlvYGmkOs9q+MHZjFsUME6BCFv+ttoBgmdyQDkw80ZhiVEqsWcQ3mE1UsyzxioP7Yklm9bmvCWAgVVvMi2y6R5dR4k6uYK5xdlqk9+cnzKH+JNSHVrZeDjgyPH8cP9NNT04zlJ63E4AD8aJgG7PWFb2EroHg2//DQVmLSbF9L0ePS8PAgls4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Tue, 16 May
 2023 03:01:50 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 03:01:50 +0000
Date:   Tue, 16 May 2023 11:01:38 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
Message-ID: <ZGLyEhKH+MoCY/R4@chao-email>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-3-chao.gao@intel.com>
 <a88b2504-b79b-83d6-383e-a948f9da662b@intel.com>
 <ZGLkvlx5W0JStTjD@chao-email>
 <9c75663c-6363-34e7-8341-d8f719365768@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9c75663c-6363-34e7-8341-d8f719365768@intel.com>
X-ClientProxiedBy: SG2PR01CA0153.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::33) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW5PR11MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: e4ea99e1-0993-436b-cb35-08db55b9e4ea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zmsgjsg+3eDMgqM6jTFpLBy7z/NSaK1Ws6LGuRPt9oxYEttmv983a2U/0Hyl3LMSgjzQYhMWeIlNuUEK2X4L4MtfnfuHqotWGBxfbLbO738ikqdJVKP4zEEoLhr4ZuDyWeTSnM8akMFmTuDKfLUQrZGSuQsb7MrxWWVkGgUXB+Rm5JtLAnpsjj50uq3pTieDr+EoMcsQTUynBCwO+aAeO5PUjKWkqiFDrZRtnTu9IweQ/YCDqGySm3GbgXzzevd3C8h70W7BznlGpfcbqgZzqO6Z3a5Bv7i4k4HFxUnJO1klycSxrPgFUeYuhi2ZHAXkxXbxNHKrs2kkIEqTWENMQVxjIvW80NfOftgU1IufdkPd3iBZDXhhUd7ZP9o9aIf5HW6fCyHJtFMawNnmq8BNT2D6Cg6x5Ti49T04zBHmGpMqAik8PxvmKY5do/a87gGNiuhKhzJesyj9batqwcU4OHlH/v6uh+zAJIgAQSix2UOZSg5zoZDtVqg616JQqZppVzJm6R4nsoTa5RtDRiBircFI/hnog65GxpNxZqY06SuAQT0M4SNzvTg55aRuRVrP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199021)(6666004)(316002)(54906003)(6486002)(66476007)(66556008)(4326008)(6636002)(38100700002)(66946007)(33716001)(478600001)(186003)(6506007)(44832011)(82960400001)(5660300002)(7416002)(6862004)(41300700001)(8676002)(8936002)(9686003)(6512007)(26005)(4744005)(2906002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?61i98dhUVBMx3z8zWZbX3R9s8tCdMNEdoKhii0hgJrh/US/ydAuCm+sBdJwF?=
 =?us-ascii?Q?wp+zZ2Rp+sH1yzLIGdFVPcsDSM0I9KsUoambCejaiJaUwEFeMfDswICXtSIQ?=
 =?us-ascii?Q?kj2gTxOQpKW+f+xvmBJvJJXSJ8pwXNciFm1qvygBY6dCQQN4eMxxjTBarUpQ?=
 =?us-ascii?Q?Ob/XSeZJ7Ha6obVMldSCAYR94EknHNXQtyimwbMEMOGv277ORPIt/1CKxRl1?=
 =?us-ascii?Q?5hw7lkIxg8duO5FOeDPAcd+k+zz7TMC3So9nmoi1zA/xZOTF/hnRGn2z543i?=
 =?us-ascii?Q?OkgrHGD7dVA7eKr1ph63HpP43Tmn8OAQKmXK/HtC4weVQHq6zI2MROYQsd6j?=
 =?us-ascii?Q?VUddTGUIb+jaD5IJ0UL3r9qS04G8NrGX6D3Tk6taG+nXFw1M60v7uVpwtzAp?=
 =?us-ascii?Q?IscivYgeADqGEXTHMoBgrnkATUGd1vZTzF6KLKCJOBWRFlShofQLGssO9tBL?=
 =?us-ascii?Q?L52ri90/4eApXixk7xAsNedtOZNZnptRadNapKVpitVZ40cr+eOIhvxO7+fU?=
 =?us-ascii?Q?JEkPkAhpe4iner/F15EKvmKJb2AMjIczfNX2F990sOVLyq7C861rfUDNax5Y?=
 =?us-ascii?Q?MnfLiwsq3GH10SGEJ7PQJhwzQik0+uBomjBIYxLN5RMtM2PwEjfwVmMOc2hg?=
 =?us-ascii?Q?mrRBSmCdV2Iz/fPzjC4vLyt9LQtd5fBb8Fs/RYH2sEIZ0iJxQYiSgX2CiT4e?=
 =?us-ascii?Q?xO6QuSgXcOJ9ju6M4IELtFP1ACHQbExJ6/lKh2nvwdKA7i3fRTZZ8UMFns14?=
 =?us-ascii?Q?HPpEg5agzti/K3xLbUm5IUW+yvCPFNkDwPZUx4rrY1JrmjXqsC5xACvSDa8f?=
 =?us-ascii?Q?IRPP12VTysyvLdnBtbhiympXCYLOwKoEx7q7jAnPpboBruFXecJt1+DKGghL?=
 =?us-ascii?Q?8izjJNYtDHTP0CUP/F5Yy/vdu1oFNMmQZ+bzaZ+3M5bMF1Df6oLmLFdv7yff?=
 =?us-ascii?Q?04BOw6rdIKJWf+S5qQ0GLOZuCK63qp0aFh5Q9BXPu6+CBG/ZFOoY54zluT8y?=
 =?us-ascii?Q?QKCmAjWOBuOckCgS/StdMN5byrDdmumvwTKbvIJKSe2Bh5Dje5J6szot75ZD?=
 =?us-ascii?Q?NHFlkZuzVghiyz8a15NW10VbVV0YeIUp3t73/llS1GCpWxvTLMuvZ7DqVH8w?=
 =?us-ascii?Q?N4wSwjuuDPU2+NWRcqMOdRxqJjZt0XNJgBcHWXk7kIi8VMMpfmp6FQcVTHBz?=
 =?us-ascii?Q?2t7AjLMGuhM9c+YYU1yLvKrNjmsb+OLFpe9mMuec6yR6xLDNxJaP59/AoJdy?=
 =?us-ascii?Q?7e7oMYRvUzCdTUveDs6kVrU5PnCa8s1JaQK2fCHrDbYjcgK3v1AWlZZrjDOj?=
 =?us-ascii?Q?xfCX0hIF79Mrnau3FoG8sK6f7o6z9LKL2Uz4+RNtKivlOe0zqIvvpqBwAU9N?=
 =?us-ascii?Q?n/UOxrWbDMkz0+oTp6fAAqjFvVPItG3UvdFYtudWUmFVivVegW/iD1zsqbYd?=
 =?us-ascii?Q?3ekJ/Z10rUtgfCgkNmJ/OUjMLhv6sTbs978xZVjUGrLTlY6KEpiHlJSzwfx3?=
 =?us-ascii?Q?tdbmIfKFAFZ9UvkZ9ZrOGkW79dGsyKivrWZsOLxfUbCLPo0AJJcG9LFRh5O7?=
 =?us-ascii?Q?S5FNdaemiVW2EC6cKtvOTmvWZCrQHb0matjO+Su2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ea99e1-0993-436b-cb35-08db55b9e4ea
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 03:01:50.2830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WQwXcLhVxrrhfKcgLPBkhwi+CtfrBc9swVN+kWHwBUS7woRxqrG7Ad7/wN16Dbd2+RJSn3dAL9N2XmSyB2xZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5812
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

On Tue, May 16, 2023 at 10:22:22AM +0800, Xiaoyao Li wrote:
>> > I think we need to fix this bug at first.
>> 
>> I have no idea how to fix the "bug" without intercepting the MSR. The
>> performance penalty makes me think intercepting the MSR is not a viable
>> solution.
>
>I thought correctness always takes higher priority over performance.

It is generally true. however, there are situations where we should make
trade-offs between correctness and other factors (like performance):

E.g., instructions without control bits, to be 100% compliant with CPU
spec, in theory, VMMs can trap/decode every instruction and inject #UD
if a guest tries to use some instructions it shouldn't.
