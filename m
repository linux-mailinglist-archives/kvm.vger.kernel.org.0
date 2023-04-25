Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D416EDA9F
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 05:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjDYD0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 23:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjDYD0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 23:26:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1668D46B3;
        Mon, 24 Apr 2023 20:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682393192; x=1713929192;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kmyv6mnMFA1oodryoD44HAgc5H6vugMC8D1yautbhLE=;
  b=Yb0Wm2Gs2+F76fOuPfMKsi3+D+Daf2VxQCnmxhekwadDLNMpcOzta6QH
   auvefNs+vksdsxxikspZ+FPjBTklX3afTrk+S3ky1hloZPdiGWI56D5Ye
   jvOmnMvf/rPOSkFsBkRs80PuIqyXUvsbNBiGooRs621QfUx5WC5hsf/qj
   uFsNKkUbxFBE0Z9VZyKSKEnqBwcNX5mSvBFJuJ7iyU+hziPlJ8lDr+zX3
   X4UgiHLllW33xh1C5xoM4vRgNISaClvzi96S6fZexWW+R8+zsHD2r9l6E
   fSZ0mQWqqcf3sI6ZQl6mc8vXd97Bf9bBXggBh0oPATYk4B374XhpL7+ri
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="346656759"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="346656759"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 20:26:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="1022968181"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="1022968181"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2023 20:26:27 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 20:26:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 20:26:26 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 20:26:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaekoLiBRIsTq4OLMfpFV3S4AuEAas14Lf6LqNby3den7Axp1TkNzj1nD9JFWdQRhJkxB9DjG6s3p1VvMfO6p4lJriSguYMrT8xqDx790pti2mgPVYas5UxLA8DyOk8s5E3XMDVhYkf54Ct0otpUU7gaPj8jc+9SyMK0wI8SEOiTXcBJU9kflppfarfRnxDkCN8nT/nUWxdduV7B+iakQbNdOm8FeMTrtnsHfhTkk8vX2qkU24XE/CfNHQAtq5eHDVI/BYQvyxc/873fGyoT8hbBtUmkmdIQDFrxZx39HTu/6uObV+7V7VduWAjQ2nePBd9I7KotBL4sak+SJNi6Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vhCz5fT3tRBOk4fxAuvoUx5nl0BlK0rvvuoQ4DgJJ6E=;
 b=RmAyhBKDvmKEWr5qfykedUZUJv4P84JAI8bGeMxnZH7yUASPSMqUY5ExnlMJjYb1EhmcJSfwQ8bj/aZErQezmZxsV2pFVL4DjIRBLCxLUIHPKMB2va3WMRPTZ5U1HXEHvW3Jj3vcuztimBknEm4CqAfVvwXvUcgJzOuiSVuX3gE9GN9BrYPyIXOuYMzRAiF7X1ZTX0Txt++tfXeREyUh3v1DG/IlDSp4wIC2YV6A32Hdjt6l1oRf9/zDbHilN5w9ZPo4UOYlJQ50qVG/tO45f99XSTM58AQliDJ0DU3QUzdTVYQD4q/MMLm0CqD7YHUigNLH/kjnXBMPJnebi0Reyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH7PR11MB6978.namprd11.prod.outlook.com (2603:10b6:510:206::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 03:26:19 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 03:26:19 +0000
Date:   Tue, 25 Apr 2023 11:26:07 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] KVM: x86: Virtualize CR4.LASS
Message-ID: <ZEdIT3xySArgKO3R@chao-email>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-2-guang.zeng@intel.com>
 <ZEYwlMmzYnJjNNHq@chao-email>
 <848cb820-e634-4608-5d09-a9bd9ee6de18@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <848cb820-e634-4608-5d09-a9bd9ee6de18@intel.com>
X-ClientProxiedBy: SG2PR02CA0089.apcprd02.prod.outlook.com
 (2603:1096:4:90::29) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH7PR11MB6978:EE_
X-MS-Office365-Filtering-Correlation-Id: 9434e684-f9c8-4c77-ab4d-08db453cd566
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XFVVkM5XN4KAUF8EpN8DE4F0OfAV9xRKadaAV0vsQeDMTLdW8oFB19ueFscuO1SZtgCF+VdqoVImmccUvTJJJNy2leECRDXapl7TLlJWo9l/3jshoJSLVMApytxYbta55xQLrzzLYryTnYcin0Op4naFbmIs9mfgjtOjMtS5w3W2MaxRuiBXfiGV4N/de7Pdx+XWBIvyPwm+nDgFdsD1GRNyHoDYTPC/xa9MnA8S5N27JPWXzZU2UMkYTzlTgf7z1vCHxYSxnZzUfeZuH/cG3FBrJkCkWPSFpQlyzEgw33IBpbiUPq8XpXK2SScSSi2Hkvjf/BZUM7Q8nh5Psu2kh9iR17Xhr3czSBDj+cpKxZmM/BtKcz72lXrSD7RQljG6iUfnyf1RDBKnmqQ9xSGbfPvgdwQGeE2iOKVnGvUexwQIAsumdnaBHsdzwfKh2VPa9ewuFraQ9AHsHAlmpr69sVuT7atSmrLkHdqQn/o7Qhwd64hsWbpl7YibOD/PQC9tyVtnUUUf9WKz6skspHgsKa/GzUkYdQW/FnymPGSW3s2WjIXr/05hsaj49gkde1Bm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199021)(2906002)(6486002)(6512007)(6506007)(6666004)(9686003)(186003)(66556008)(66476007)(66946007)(8676002)(8936002)(6862004)(41300700001)(4326008)(316002)(26005)(478600001)(44832011)(7416002)(6636002)(5660300002)(54906003)(82960400001)(38100700002)(33716001)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WEoEmIbIa15OeT1tAVqOvMtM/u9qHUIn9wqNS1NZElE3tnO4ij0CmakCkdh0?=
 =?us-ascii?Q?wa3h3r1/8fWv+1tdBRMh7yguIufo/2mtQjYMaKYumZfzNI4hblNw4B/BpPM7?=
 =?us-ascii?Q?5UAtja9NV97a/mHpKagDYnysp++JJscW2/MsRO7lkt+7NHI2B/dxuJHRtAg8?=
 =?us-ascii?Q?ezS7dZdw0NVMiqaJqNTsLf92KWRDkQb++qwK+v3WkmINcTiOsuqQ1bG35FJu?=
 =?us-ascii?Q?BHJ50xOInQLA7rAEz4xjtvBwoxsxJcHvVvlwbemNzDJyDuLyaRgIHSbpNMnz?=
 =?us-ascii?Q?HVOETU2nMs1Vl5O2h4hVwUrLxpiaQSpdSpJnOua0pBrUgRmcqHDcpSvPlB5L?=
 =?us-ascii?Q?NN99f/LYlDUoLhuyK21i0Zz4RfQUYGWzxINn7UsMCU627b8MABuPVPqgsn8Y?=
 =?us-ascii?Q?XtuThSD5s4YyZFGxrEM1+EzSzNZSn1JajQtEoa7EEBhRT/oUu5VXBa5k+SQp?=
 =?us-ascii?Q?770/m837vPDN6yEToQaFLs8TpxOxNidV3xtYaNJY9pelco1V7gF9wrawzn4u?=
 =?us-ascii?Q?DxIKw9epJgS3j7ewNru1kcGwNYS39gjXpBRqp2hBVOGXPANrkLlCUiWzlETm?=
 =?us-ascii?Q?q2O5cxZJQ5NMFmIX+ArP4QhlXQHLiE+Z3GY1JE3OOaYhgeM372ioDUWio97F?=
 =?us-ascii?Q?V90dErZJycmvrRPEAEmB+1olWHYIuT1dcl6Nb5XZVG+n8TkAT1tZEj8yHv3W?=
 =?us-ascii?Q?SvKmkYny57PCnv8ZQbocb3lTIT5f7R2IudIboKcFz18RtsQZEho59mveT36G?=
 =?us-ascii?Q?8Ti0lpO9smRaux/brn3y/V1At4ISQuw+fLB7+PB9GW0i0EhctfaZ6qzdKT3H?=
 =?us-ascii?Q?xubAloF+G/qKetbz+nE7IGFxkZRBpieUJgUOdDcE3GBCJ/fzoZKehWCxCQVH?=
 =?us-ascii?Q?sPfFvxcyzBMWToKShF0u4ZepxNXaMDqx6Wym/UnA3E48ygg2ma4NhF2U5Dc3?=
 =?us-ascii?Q?G5mUCsmF0x58/i40hPOtEJ09u1umYsK+OaTs8VTBdukUGipUzzcQX2DkKImi?=
 =?us-ascii?Q?G7KRBUSTPacLuhqkfWtT5BgL5r8K9uHBw9YnW47Z3vFm6pMQuSrhuYBrYC+V?=
 =?us-ascii?Q?Gm/dKsip0PHrJGx9woRWD7ApozEA6Cli+WW8oSgpnvn0byaS0be/vRg7TtZ8?=
 =?us-ascii?Q?EJTiOjaokYWmFQpLqH0+iskkfFdTCaQ+1UFyTQHCyd5W/gXq5gQAjYHTQttj?=
 =?us-ascii?Q?a0biNMlkrkQFG7nrnVFBj1YHP4no7A8FSzplOxnO0qdhaJQnNVu2yZhtUYsa?=
 =?us-ascii?Q?d7f02EbMGze37M0MYMCQ+XeDUzfT7tJdMaMS8i5ZA1FiVEWAgcnvB1r28xDH?=
 =?us-ascii?Q?E9BnUXBU03AhzV8U2ooc1KUMk7/bD6cv18FAFJvnfdpnUBrQxsTVdwfshajp?=
 =?us-ascii?Q?lce0Ri/jUNoqQoNuOng8VyIc0hkr7H8CatpEwlU3CUQXYMG/bisbRzRCECM2?=
 =?us-ascii?Q?hc7kwkMizc6hK8wEPmgAIyWQjFGnJ8ehTALjCdi9ZMw3kHJe1YeuaYDqBsIK?=
 =?us-ascii?Q?8BnCWvDK9xESKZd+zDaukF8jAXE3Vt4JW0okSxZMt6iHs+nSn+TQKPjwl5C/?=
 =?us-ascii?Q?YP3er8b66WUjILojjgCy0jKMyianP4zsHtAalAh0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9434e684-f9c8-4c77-ab4d-08db453cd566
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 03:26:18.6161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JmRO2uoCYZNk9+6TGPpcwhrZzCukzroLBWKDu5QfhInR/Uf3lm694kD6E8rYa/0CwKjv7e+tlsWOjJr+hx6OLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6978
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 25, 2023 at 10:35:25AM +0800, Zeng Guang wrote:
>
>On 4/24/2023 3:32 PM, Gao, Chao wrote:
>> On Thu, Apr 20, 2023 at 09:37:19PM +0800, Zeng Guang wrote:
>> > Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
>> > as CR4.LASS generally set once for each vCPU at boot time and won't be
>> > toggled at runtime. Besides, only if VM has LASS capability enumerated with
>> > CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
>> > to set CR4.LASS.
>> > By design CR4.LASS can be manipulated by nested guest as
>> > well.
>> This is inaccurate. The change in nested_vmx_cr_fixed1_bits_update() is
>> to allow L1 guests to set CR4.LASS in VMX operation.
>
>Essentially it allows nested guest to set CR4.LASS. L1 guest uses cr4_fixed1
>to check
>cr4 value requested to set by nested guest valid or not. Nested guest will
>get #GP
>fault if it's not allowed.

The change to CR4_FIXED1 has more impacts. Without CR4_FIXED1 change,
guest shouldn't enable LASS in VMX operation; it means:

1. before VMXON, LASS should be disabled
2. in VMX operation, LASS cannot be enabled

What you said (i.e., L1 guest allows L2 to enable LASS) belongs in #2.
But #1 isn't covered. That's why I said "inaccurate".

>
>> I would say:
>> 
>> Set the CR4.LASS bit in the emulated IA32_VMX_CR4_FIXED1 MSR for guests
>> to allow guests to enable LASS in nested VMX operation.
>
