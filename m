Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D15D6EA5F7
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDUIhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDUIhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:37:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBA25B8F
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 01:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682066220; x=1713602220;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dKSKSczw6QH3tiOodnxSIZ8Zo45F8R7nCoMgwDHCzP4=;
  b=Z/bWqDUG0ALaO/ihDk2mv7Du1xY2aCKRfh6wxmPh5XagOTjHIkJ6ILaD
   jSl1cbLCW4CEo9Rgrz8Z7HqqWLi+9o7bAXs0T85i5Wa6DOsw2GYfE1siv
   v3vvsN22dtOzsDWZ9AaNlwrCN2px0/74QfgtJ39TxobEdfyTGLUlRFxwz
   wPffB7ft3MY6Wp7zlUVJQziPNGqpn7nlWVC58KUlAh6TqgDdyPj+349uB
   ovEoGlLnTbDAZ348X2I5AQ6iYwMzl6kMC3gZsRxTHMi5GmoDpYaOW+64w
   dHe0oT9WqGzy4dPcYTB6cDt6J90T68hKRqgtMmyAH43rGouE2dtN2Bkp2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="373869739"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="373869739"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 01:37:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="669650475"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="669650475"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2023 01:37:00 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 01:37:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 01:36:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 01:36:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 01:36:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aljrO8xPBMkyKacukBYuzLft3hjcbdJi+0LEmKYwfxoPvsn/jKcGaJB08p5eSZuAZqf2yufSCYNIE09sQ4payjIgslRvjCtwS4ut5jM6AaSNPl3t2EDCh5OzNCdrmgVHhR6j1zFv44RquD4MqsRs2Dx0CcUb9trM65jPNBoQjWj2AvKoNagH34m5k5EhfhR9fNtczCmkWNzDNtY+q/BThBbMGv7VH5XbtSp36VeRjBojnFdiqHLEMbuMf75WAoqAGL4sJ0Vjbc5m+p3i1Uf3947lX6UPId6iSADFTY12w2Tt9fe68CWK1St+cVw4Wl4+B+g0Wfjn23DhKUEusos7+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcEcp8OMSz7cRpYvixDpT63YIqBLo6Vk5yoVt/Ab/Rw=;
 b=IGM5Il6vuoV4op3rftsZd39t+icQRpy/cdJqy7xPr7Bfiiy3Fpnxjf90mzssLKraZ6qZLzjw7Ffr7LHZHeJP2Ky5Jrhf9bFZ45XFpknHYR3BzGZD1QPuwsp1YwLFjDRoz1D7P5DNCPJwxCHjCDPBcAvX345FmLU2+BfXQOt2zRWmUbAHu3okizTf/H2akA5FxJYPZyW1J9x3lfuBuzSAoEiqKoLzkAiDZW3xlakxhzFh5jfcxiHr7uV2H9Qx2mgOvTWNUSPXexUfznuXItaaI4ylgCe+JZQ1pF7is9TB7apiKPU3gRHeO+7YGY2Mo7ce7frYeddwl2fM6VmEUfD24Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM4PR11MB6264.namprd11.prod.outlook.com (2603:10b6:8:a5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Fri, 21 Apr 2023 08:36:49 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 08:36:49 +0000
Date:   Fri, 21 Apr 2023 16:36:40 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <kai.huang@intel.com>, <xuelian.guo@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
Message-ID: <ZEJLGGUPD5PFJ0at@chao-email>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-5-binbin.wu@linux.intel.com>
 <ZD+NiODiAiIY55Fx@chao-env>
 <f1d564d1-572e-75fc-aa68-05b52abc2914@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1d564d1-572e-75fc-aa68-05b52abc2914@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0066.apcprd02.prod.outlook.com
 (2603:1096:4:54::30) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM4PR11MB6264:EE_
X-MS-Office365-Filtering-Correlation-Id: 206abf0f-5054-434b-4a55-08db42438ca7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8HkFpxyjUBSp1gMxydbDyrmGucq79xW/z5c5xuvBbQYxGcmOQ7xet2dt9QIEHHNpvEjI2AuxgyR/k9EjNzR6iDOyL+o+dKa8tjzTUlKT8SJmwzMnwCOdqEpK0FtLPLgMyshnLlqU7z6o5fTmq8iVZKMXvLnngmA1ShpQlyTCoBWGeplODPfyV1RaxVtj51j6tOf+VJoR2t2hLRK1rP2RSuqEoyzCQKauJuw1ubBBahAAugmhRIWWYqRMUFAgTyGaw2eNt5c6sgrcpWMk1iuleWf5cfsjV7rBP/XEmsF1qAh0vAfxPQdlhkOcv9bPEHcqfO52WIq/Pb40GmxiJ3t2Fo7gg5urkPxO6IDF7WFbP5piU1/b0AC4uhvnIliunDRRguHUi7pc5ZPIFapPTjZRep8hatL9P/FJjazzVIuXidIT9BQ+SAg9wdKGvFOcCEEcLPJ/OZwkRn5mI8XdefqzJJLSm3GDLJEpVkKsScCBANd8/SHPmgEtplXO+yiuzsU1UqOKBhIuK7EijDxBmIRo0xZaw18YyX2+pJy5nUIRskel3UT5onm4ZB3/kwUqhY9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(396003)(39860400002)(346002)(366004)(451199021)(6486002)(6666004)(26005)(478600001)(33716001)(186003)(6506007)(9686003)(6512007)(2906002)(44832011)(5660300002)(66946007)(8936002)(41300700001)(66556008)(6916009)(66476007)(8676002)(4326008)(316002)(86362001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?jXwv1VOamycgH7OVv0FXHmWbHWeDazCJzJkjrBUuzD1yB5JHbXBQ/jxYX7?=
 =?iso-8859-1?Q?OAK5M91J+r34nUnzoSDU3aN2vMN92dAIz3yQRpxna+FVhyMZMi6X0qzE7W?=
 =?iso-8859-1?Q?ld+K4lDXWFhntE2OridKqOA0XZDT590qiQ/BVvylJ2HcoGcYvRlkmxFBlm?=
 =?iso-8859-1?Q?/jDKf+KDSdzL0zQFvRifQ2jLiUU//0WGRMHaA1IvcIHb8bZE6g/67vyEvo?=
 =?iso-8859-1?Q?0xryacynAuKoulhlPN3jP9QD4XwAZXuML/1O/hcshZWGhUKCLK7wLGJN3U?=
 =?iso-8859-1?Q?hfvvb2ZcktzAel7zV7PyVExCqJD8KZFHYN/vdKGAPhS7qEibED4J5T+yQD?=
 =?iso-8859-1?Q?un0SqsKFTOh1yZO5Ilw/khttIdNCkKiZQFSiwNf6PDf1Ex9ynIM274B3Sv?=
 =?iso-8859-1?Q?b6Yz/P1fu9c9UeUSxDSAHnvkB56mClYeTYDTwAwHoMcEGHxI+5r6h3SqAu?=
 =?iso-8859-1?Q?yY+gmBCIw09E+IxB2ggakKY2fd4GLs2dUmmsIM0NgeTrLHbTKebotcB3rt?=
 =?iso-8859-1?Q?aQdF66K610ie9ccz1waYbgLDewPJ006jcMM6AG89KuXMbjx9btdfbnOIsL?=
 =?iso-8859-1?Q?HYAppbpEL66gd/Nx0tpAU7LImKWQAk8t0v8mxXXn3K179azWw6LWVBORUc?=
 =?iso-8859-1?Q?eyGfdj7ptCKU4LuM5QzFUINsQFiZ1zyZNRO1lHubQh4LKakOvH6QWf2DZW?=
 =?iso-8859-1?Q?VuWzwjnMX6p1atl2wdMbYhPGLQJ0XhECyxO25ckox8lfyfgZ9dPhqqEnl6?=
 =?iso-8859-1?Q?xfrNp1q5YtpKJzoK+z0AHiNuAvY0cMgJyXUGSe2EZjZKTyOaL3hImSUrOp?=
 =?iso-8859-1?Q?JJHitSdh3UvOGGOmvg0G2uwwvHrdvX0y89iJMrPDIW2OETb8bm5mgoqe0Y?=
 =?iso-8859-1?Q?eyO6jVFUhv6YdF2b4sy0E3Fc2PBrKpVJyRg9y8mWiPHAE9/7GBWT9V67mI?=
 =?iso-8859-1?Q?E5spfL6Vqz8EGL6N0ZN0tQ2pi4+ExYoa2UKrNoJStkTLYM9mimCh0SWhZI?=
 =?iso-8859-1?Q?RfVL8u6y+DFygjiT1eHMNmrdHZWkQQhhwLfl4IJVJz1aY4poiGpMTbDXh+?=
 =?iso-8859-1?Q?YuhVFeMFdDTeWwKptdY5+UHqa9Obo68kufKCOqEqGrFvr83X0YxoubhzFc?=
 =?iso-8859-1?Q?Ilgp3zzQRv47sVJDNi2wr9RijjxgtYFQE2jsAbbcxEwVzRTorzvO/ZJM1f?=
 =?iso-8859-1?Q?qVmB3kJ9NW/UbbUvA4mPtvvYX4apSiRm8xUqvXuvW/uob7MHVyXlUXN0oy?=
 =?iso-8859-1?Q?F8a3wvkuaFUCMA7MhRv+ytuGr5Kx0BLfy+5oz3LGlz8Q7maOTvQ6nQ1oXV?=
 =?iso-8859-1?Q?hwcwYLM7ViYtkWJeAJf3mre9/GBFstvF4967XwYOYCQcbIW1I7/Bh+IUmn?=
 =?iso-8859-1?Q?6Sm7DHUidF2Quub5NCctHRkw+cjvW/4/sH1CclGfnjnO3fXbXqlfjViI37?=
 =?iso-8859-1?Q?geEsTIs+aRg6IFdTuLPyOAu/ANH49+IXwHOrskF4ROP1tis/eluigD9oE+?=
 =?iso-8859-1?Q?YJovqWadt3QD/pCxaWbDvqddIEcwzMVHIwpx+VcGKxNajbO25o1VjPRM9F?=
 =?iso-8859-1?Q?Sl1TNIQrkwcHMvrIdCXZuWIabnKE42M0g29dP/lCrqA2z21SeOVk/9CG1N?=
 =?iso-8859-1?Q?trj4cfd3YbzoK/Z6hzRu1si+N1v1FhFjBg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 206abf0f-5054-434b-4a55-08db42438ca7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 08:36:49.4629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j1oT98ire8nEtz3ActWj/48E3oJIPmFpBLhgIabPsY79IOPI6Dp/IwkFMXHVdr4aS2G7rJxy+z5wLUYA0/BxdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6264
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

On Fri, Apr 21, 2023 at 03:57:15PM +0800, Binbin Wu wrote:
>
>> > --- a/arch/x86/kvm/emulate.c
>> > +++ b/arch/x86/kvm/emulate.c
>> > @@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>> > 				       struct segmented_address addr,
>> > 				       unsigned *max_size, unsigned size,
>> > 				       bool write, bool fetch,
>> > -				       enum x86emul_mode mode, ulong *linear)
>> > +				       enum x86emul_mode mode, ulong *linear,
>> > +				       u64 untag_flags)
>> @write and @fetch are like flags. I think we can consolidate them into
>> the @flags first as a cleanup patch and then add a flag for LAM.
>
>OK. Here is the proposed cleanup patch:

looks good to me

>
>
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -48,6 +48,15 @@ void kvm_spurious_fault(void);
> #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX USHRT_MAX
> #define KVM_SVM_DEFAULT_PLE_WINDOW     3000
>
>+/* x86-specific emulation flags */
>+#define KVM_X86_EMULFLAG_FETCH                 _BITULL(0)
>+#define KVM_X86_EMULFLAG_WRITE                 _BITULL(1)

Can we move the definitions to arch/x86/kvm/kvm_emulate.h?

>
>
>And the following two will be defined for untag:
>
>#define KVM_X86_EMULFLAG_SKIP_UNTAG_VMX     _BITULL(2)
>#define KVM_X86_EMULFLAG_SKIP_UNTAG_SVM     _BITULL(3) /* reserved for SVM */
>
>
