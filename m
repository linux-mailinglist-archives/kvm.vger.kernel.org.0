Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2439F5EDBB8
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 13:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiI1L00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 07:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiI1L0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 07:26:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77E766A54;
        Wed, 28 Sep 2022 04:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664364383; x=1695900383;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jXOcSfbkkq/dN2hr26OmGvTlHtaObsDAxTDCr6KWbK8=;
  b=lnsCZMNbbvxTkb7YLriWVD3f7hCn/6KAMZjjKIbMzjwWWqj/pesM16UL
   DcsydCh91S70tHob+u1NlackRdyFUCmJvyJ51Ue42h280D/EOhNKw5YbM
   yi+NTvsfgwKXSSMUGmV+odih5DN3/9F3d/RAq64sbOqeuMbSMXBDIxy4G
   G5qyVJA8nHaJoJ3TNOI5hj1Ye4bvO2OKE4e5Mwe2coN+V7xZjscme+EXT
   iZdCNfW+pss6H95vqoA8lHAyhrNqhbWwafdyiXaQHPXyHNlrWBDzwix5j
   NrL1JEXA+yrg5iL1JVXaxaY/ZnKFQ8a2fAVeIk4k922ySRxHQ+/g94d4M
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="303059379"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="303059379"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 04:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="573002611"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="573002611"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 28 Sep 2022 04:26:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 04:26:22 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 04:26:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 04:26:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 04:26:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRGm0DZ/O/ehaaiPody+O2gPeNcdNyNNx3kGA0O1IWSdhLLB5bOUvoz67krGZFW+p716/Alcnw4lhqTScpNnvZ1Hm5wtyBNV5MuDYDEeLXGlLZJRNLQxaIsw7FH2QWU1r1fu987PrNwei6nhU5DwUp5YZzUuKidfDGIx9SrDH0YagrCDD6nJaZSvcNmX32Mxhu4LFmQSetMcOSwIVKG88bEbckpiAmKeQR+P/bA4UWIV/d60gmcdVG3VtL+FvubuY0S6PvPB/Cnw4vpgP6JgBfh78p3ax7oUPi2CoaWY7iUro5bSWUNZ5WYvNloKP6Jw5MITI5wiqxa4MYnkYryVjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfvZwd26c64kUjRkZH6k9XQWYe7D8zeSPHJkeyIEQS4=;
 b=mowfKQ3/WzAckdmGp++Z+i2UDj67tu33c7bkk00xsRvSw3SrNSyi4aUilGpRAWE9hakmj5KWEWL0N7cljO5+XGjW54Umk9MKiuTCffworqfigXiyLP1c7+HGWYsRZYy1k5yglWWlBryFwOHal1lfgoRzZab0UrFu14rgojUzxMIlB11v4/z9kNq2wVoGr44BzZwxr8OLbMDLMZRs5WbMFvvJDaQ5JpXpiFpxZGvFVn0EBV1Enjfx9NPlRE1Swp/9JYLiaXcFmvpC2UdACtMr6ee23SQcoTxbe4dr/88n5XixhCiJEGci/LEm1jULejtntL6JEhUKMg6x2yb3qxY4gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by SA1PR11MB5828.namprd11.prod.outlook.com
 (2603:10b6:806:237::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 11:26:18 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::a071:6245:5340:793b]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::a071:6245:5340:793b%6]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 11:26:18 +0000
Date:   Wed, 28 Sep 2022 19:26:18 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jon@nutanix.com>, <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v2] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Message-ID: <YzQvWhr9nAeesRKy@gao-cwp>
References: <20220923085806.384344-1-chao.gao@intel.com>
 <YzHRKO1v5N/BIQl6@google.com>
 <YzKZExaU2k7qfcS9@gao-cwp>
 <YzNubGQf0yvODjZC@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YzNubGQf0yvODjZC@google.com>
X-ClientProxiedBy: SGAP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::20)
 To MWHPR1101MB2221.namprd11.prod.outlook.com (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|SA1PR11MB5828:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ca3753-6742-4176-32c1-08daa14442dc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Kgx4njOzmiEbSmMsqu3etBdQsG50u6C7xt68YdePeLWIm64MIA2uud3xzuNg/BZEJmmVomkhrijk6xxy8NnCSYQt7UBlonFLZGc+RExg1hyWtLzn5En678KV1x/sJuBVOdOd/TXgn7oMbthRMc96C4WsFa9Er3Bcp13C6PQ9sjO6/vb8o+i6ytU8wuxNmj36ckAwY6027/sJnDovFKz7+6xI8RAFX4oSqJKt5LdsHrfnUZsNNhGclVetr84QSQVH48sBeXhaeTodc9aVn95PXp18QCLT1GmB8p5ryd/FoCVKtuZwQPCKJrJYzshG/+9uWR0O4EhTCetDKflNHV7pJQHltYWDNwkpn7/oE4tOVTl9Wo/jp7dhJEHW1NUOL1IHmbEdcA+0wLUhYuaDmzFChV6xpfMkigUkUKWMTXglEO9vKaslzOJVYEUIBG4YB1PBsoBqtDjUZOXT+lyeq4X+qmQCYc/PA1kWR2cDv7nqaM3R2L8zxMwMHt/jhJXUP3CZxX/dAoS7dtERrB2ftF056ywZ0U7WDytenAq0TxLU+IbuFh4w58nhjT/GF/5yBEp4z4zSLwLnPiLFAZJKbODUQt+L5DgVprhCApe6LyX47CqXlunOddpG1IjUW6OHeCmcg+GElp31rMZo+hvYWNkaSue8bsDciyJcwrx6oDRimn249EceHdzeu2RW6Z0V2rG/NpFCYCORFfFBZ02rMgpFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199015)(66476007)(26005)(9686003)(6512007)(186003)(478600001)(6506007)(38100700002)(82960400001)(316002)(2906002)(83380400001)(6486002)(54906003)(6916009)(7416002)(8936002)(5660300002)(41300700001)(33716001)(66946007)(4326008)(8676002)(66556008)(44832011)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MTyUFtPkQ3VLzpD8bGpnP/dKm+ECp0dTfDsZml1DaTxeVBsLpsn/j5fsYQaL?=
 =?us-ascii?Q?/cDE/oXe0pHJnaNPcBb6m6LtkHhYbI/VoVe8u/ihXDq5J0elKxJetNhekj3o?=
 =?us-ascii?Q?IC3eozWD9KFhsp/yxzLnjcIn9HKvkv/0EoFLZShHH69CqZbGYc/rFVIGFwhH?=
 =?us-ascii?Q?LobnNaf6U2zouaKZ2aNeEZCFqLI18aOGzUwgeWo847NqO24I839ZQoTRUByr?=
 =?us-ascii?Q?SY/r0VxN5kgGQZ9Wf4LFxQVkAKZGaAX3S99Tq8CBS3h/9AiIlVCli9/BdduT?=
 =?us-ascii?Q?0pGbVaaf0WaaUgloN8+jYoxNJoxZJcmSAFEKL51xQ6XVKBtyF+L2gcctZRsV?=
 =?us-ascii?Q?R427z7JH+vKwRpGfk/A6poLgfOlv6vM9mAp07GQf5ONSOf4xWt6UEMJuGVbV?=
 =?us-ascii?Q?90cVKfb8TdENqgwRQiiSUjOf0NlZnbd1iQPgvOccWxfYpRWdUJGFZGuG0hoH?=
 =?us-ascii?Q?lqmjNUfelDqXqyibccC4H7AwIw0uQLG7X1lgElYGVPD5yC6l+aNHu6Ap01TP?=
 =?us-ascii?Q?L/66k9Jv4UlLpwLwbH2SFAvdAPsuC7HTFvt8srMZwchIkuGn9K4fdox25H16?=
 =?us-ascii?Q?raHgANXXiUlsSBilBWw5DfkJMCnepdjZqOpMB/+m5VMwOsX3QpwUvNOapRCC?=
 =?us-ascii?Q?yqF+FYnoCzOrhZltSNXOLqQ7mETBgHmhN8jgQjDf+znW/lk/Z3g13seroW1W?=
 =?us-ascii?Q?nXEQ/eVEb6aD5GhgmUewhv2WitfFRplvvYplsI1BtUqgLR93dwVZ+470udD6?=
 =?us-ascii?Q?KZ7W6KoUMHKdHPmJnew+qgr2Eavso3ld6WG0wGSRs52WcPU1mlJvxV0JEZi3?=
 =?us-ascii?Q?HDQcdtBxrXrgllaGHCLcglb5EaoRMNwOwJPtRoah5xflMK+zSf8eqNskxvmE?=
 =?us-ascii?Q?L/rlULM8CyAitKbB1PWv8Zd57z2N8RsZuowodcK9V054mMxcNSzfHz+EThxF?=
 =?us-ascii?Q?SvfTAL8jNyiO4kjEMi0MqCNlRlF1OGIdxjxKBG+PZiMsv/3kqnbObOzEZa1Z?=
 =?us-ascii?Q?noYNBv9Rtk2VwkEuGnwt3xaYYzHbvMZPyeDqpX5y/QPakvH2AWXQ+gMm8oiD?=
 =?us-ascii?Q?yd1NYfptWvVUHSYXC9lsYVe0WeCV/lXIneh6Z2J/DZchsPro2QJO3Clef9xr?=
 =?us-ascii?Q?p8BQCDG1VpnY4CKBzQ+7LCPp/5P3prjBCCVhMX7rptDP0gECCsN8Pif0229c?=
 =?us-ascii?Q?1r7AYWs/JmqyWNfRL/sZEUtBPFUasNAJ8wlXf+Gv8sdksCa5o6jbjRRQzfOx?=
 =?us-ascii?Q?46JtiGSTxBbe9/ZEIX9Gd8Bc81o0gBdZ9a2bRLCGKjjKmTTdrxbR8EfRp0CV?=
 =?us-ascii?Q?nfaL1F7I0I1UGPLlZMhbm+/QOzTwIgZ6F76pb4myGZPb+iI7bGHwUjodR/he?=
 =?us-ascii?Q?W4NhZDjvSnpq9ZtyCObkVfWg5PbcAZkGts4wtURq2avniHITVlOLc9sEEP8I?=
 =?us-ascii?Q?e6odEApmzSc0qKCUFxIcHls/ryVY0dC9/N3WE7tsx+Ccx9D60FdUl7iNI277?=
 =?us-ascii?Q?56Mn8LbWORdTXBrNz03becQjQ4SeEEt/c1C6DP024QqpnBZneYQHyleodJtM?=
 =?us-ascii?Q?T8BATn8vYvzgpJp5O48kj8CKHHbZSri3wfjHFXtQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ca3753-6742-4176-32c1-08daa14442dc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 11:26:17.9327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhGj8ETUR1OwhZdo5bFMnO/yEjoZEboHL87JuJsqU38emjufC4aK8l0/V+Y9cWDLLiZKSW6Lsq19mSN28T57Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5828
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 09:43:08PM +0000, Sean Christopherson wrote:
>The benefits I see are:
>
>  1. The code is very explicit.  When clearing SN, check PIR and set ON=1 to
>     ensure IRQs aren't ignored.
>
>  2. pi_enable_wakeup_handler() is only responsible for changing the vector,
>     i.e. there's no clearing of SN "hidden" in the CMPXCHG loop.
>
>  3. Same for vmx_vcpu_pi_load(), it's only responsible for updating the pCPU
>     and the vector, it doesn't touch SN.
>
>  4. The logic is common to all paths that clear SN, i.e. the same helper can
>     be used for both VM-Enter and vCPU blocking.
>
>E.g. the VMX hook for both VM-Enter and vCPU blocking could be:
>
>  static void vmx_no_idea_what_to_call_this(struct kvm_vcpu *vcpu)
>  {
>	pi_clear_sn(&vmx->pi_desc);
>
>	/*
>	 * Clear SN before reading the bitmap.  The VT-d firmware writes the
>	 * bitmap and reads SN atomically (5.2.3 in the spec), so it doesn't
>	 * really have a memory barrier that pairs with this, but we cannot do
>	 * that and we need one.
>	 */
>	smp_mb__after_atomic();
>
>	/* blah blah blah */
>	if (!pi_test_on(&vmx->pi_desc) && !pi_is_pir_empty(&vmx->pi_desc))
>		pi_set_on(&vmx->pi_desc);
>  }
>
>One related thought thing I want to capture:
>
>The proposed approach is having vmx_sync_pir_to_irr() check PIR if ON=1 || SN=1
>is effectively _required_ to avoid breaking halt-polling.  I was thinking we could
>keep that path optimized to check only ON=1, but with that approach, KVM won't detect
>the pending IRQ until it actually starts to block the vCPU, i.e. until it clears SN
>and manually checks the PIR.  Clearing SN in kvm_arch_vcpu_pending() would be better
>than waiting until the vCPU is "put", but even that is too late from a halt-polling
>perspective.
>
>A comment in vmx_sync_pir_to_irr() is likely needed to capture that.

All your comments make sense to me. I just posted v3 with all issues of v2
addressed.
