Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA96A7BCB
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 08:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCBHYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 02:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjCBHX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 02:23:59 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA615163
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 23:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677741833; x=1709277833;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=unk9SmqfsaIkXYphx7oIvpb5axX8j4HN1bOmalDbBzc=;
  b=Rp+gr2+dBi1vwD9lDmTOSPDYuQUwRz0pfT0+PSVbRrrMBsDG1rGJrgsG
   4vE0Nc0bCv49qpS/VxFTo9FXdjEygW+g2fSqmBsA9XEoaF0JEKaSyCEUY
   snq3ZA06EAFdQq8UXqOKLND1KcH+7Nyh793I5TyvmEWpeuL8PptMHAWQ5
   7DBX6YEpTq3JpkmKh+cRYk/V+gF55YnISYGpYYlfqMl0ikuc4cNABctc5
   csnhVoHkPMkmOl0DZ1swyhWm09yQD9i7eYKddmkUFyK+IVZEKylGwELHC
   m5DqsTRYbsSbnAUkN33GY5Ld70Fn+MsqKpDASGxnAZLTj7CtZqEmaYFLC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="322916786"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="322916786"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 23:23:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="738954363"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="738954363"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 01 Mar 2023 23:23:48 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 23:23:48 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 23:23:48 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 23:23:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIiSVimIFFRmuiuWlLkRA/VkdLhJ/Pa6dS+iJ+mvCqzbnMjzbIBm0PMPG2TdNp6H1Dp4WxD3Vz16rrLrKm879nuNg0o8Qb98BG0E1mV1fqI6t/0aCDzR2/mgQL4BVt3nh0BVDWrAw+TQTOdLzMbF26e/iKcffudAE0DWzBYUVeDuxYiISFJT9CA8us29dej7Ok5EN4UfoQAKQuLhRYsSlsWDvVzMGwFRIDbDpuTmObDM/uioEFIWMllUeSn3ZarEJHiS+sqqLyRPLP1iwrNxzva3/XXhQq4ADoMQwvboaoxM7ZokNHEykEIzTHTXHW1QDyIspRH5v3OTRvRbF+C8LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVci9SCMr/imaBwyJVNHK8+daSiG/eiB1T5gyNkZhTw=;
 b=HKRntQCP4G9GN+coggLDSNn5NrgwZLxLgmAF6IixvB0fTtDcGgiy8/cXu2G1Xf9HCv1Cy7rPQ+lqKRcDx75gmSW0XZqNmnR5u624PrGtViz8qzjIkrFXvgTu+D4sFaWAMaLSkZi8XO4I4l6XG+GNLkBkTQooQl+gGj3b3julqhXQlIoQznnoIEwcwQktXY7/Z0E77SZiCjPzDYcw6DqqrF4k6z09lFcgL0cQSzAkJXaw5LyJQOJ8SlNldxBbOy7vinCcIQpgdEg8jBS2bFKP/TROAr82Vy5/AGzTrfzD1ZijhEAPYev1NyQv37LCynh+hn25Hz7tu3ZBNCPPX0FpOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH0PR11MB5689.namprd11.prod.outlook.com (2603:10b6:610:ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 07:23:42 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6134.028; Thu, 2 Mar 2023
 07:23:42 +0000
Date:   Thu, 2 Mar 2023 15:24:04 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 2/5] [Trivial]KVM: x86: Explicitly cast ulong to bool
 in kvm_set_cr3()
Message-ID: <ZABPFII40v1nQ2EV@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-3-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230227084547.404871-3-robert.hu@linux.intel.com>
X-ClientProxiedBy: SGBP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::13)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH0PR11MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: e6e0e1e7-72a1-4174-e297-08db1aef0ce2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FqSoHnCMJJFnJBIScUPEYpcGpz/eohtJ4DIaRgNmv4f2j90jmMWi/mR7/0TD3RFlg3PVPO94XX9rdcAN8wV4/6oi7MFgIxEivZ+PJ/btNCq/vBGbwC61nlAC0alc/xCtg4A4DmwAWGFwqgNBLntxYm6P1Z9Dp88zrnrouVY8eVMkekhCymcYUFqphh45Gh9bGYIl0ulOTZOT+hyxQrbTBAR1jRdt87WUhiN8zs9TGvJ/kUwbB1PQheuPC/FAyuscd+GOk+3M/iO1cIimUOkja6qj2tTbZc4WD+zMk67euQ77HAvpEmoXGJ8j+M91vgciW2mI4F7pJmHEGRFyYc5veBYAN7QMIAwgHYEJvcI1LdV063e6NiA3X1cd9XICGMGyPPvcVx8eT3y+hXdJLLDL+648vTYpi7JMv72ueQLiuJMuylVRNwZohK9/VOAe0OFMqA0Kohuz8FgsFQ7JKa0LHBhOYoQSU3BmnE9pQjZHDQAlVHeESOzllG3Y2p4WsXzmMjJRxPviRJ5ljb0XjtLdCM11G99Ra4CcM5jnIdTRTThm+OLUYnpHoZCNRTKSTuq9YuP0khuepv+bUoyK+SxMLevwsm1EjsTArYSxoU+JsYsQql3H+YFYHRLKVQcNAICpLq+jFnYHq1q0kK34gz15N66WCKaLqFPVzIILsYM0TF9TYbVs/0VdDgbtPGeXzmHkeGTu4B/l1/IM8wvosOQV1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(83380400001)(6666004)(38100700002)(33716001)(8936002)(5660300002)(82960400001)(478600001)(86362001)(66946007)(9686003)(186003)(26005)(6512007)(6486002)(6506007)(66476007)(4744005)(66556008)(2906002)(8676002)(44832011)(6916009)(316002)(4326008)(41300700001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p2u2jEmJoSYPmPfo6zLMpdXyw4Mb+HwKmfzNhlxe6+JqxCAb60AF/QVM6Qyg?=
 =?us-ascii?Q?6JaIrx+V1vdv9CTCGCWyxfDrK9KKkGYSSqiBHWpQ5U0Y/H2FgF2SMc++kDvh?=
 =?us-ascii?Q?IJNwWPOCCJD4+koGRmqSEKXEnBF8mAkPbZx5CLAxnNvW7/JnmaPPPDu/HntM?=
 =?us-ascii?Q?H5EEwS5+hFMJUgshHp0k9+5icl7JLsMyOKlJQXt+MXmj7XzGYYj32qDOZm3c?=
 =?us-ascii?Q?D0gk53zjjjmnDYgAqTpwLXE3xDpGTaVKN+21vN2uiPm8n0IMSmjOPxS9PuEQ?=
 =?us-ascii?Q?QNU52JeXd9qNQAfPrvIQCY5T7M/dXkmfeTu19BGXrqCwFW4jzOaAUhAPP8k1?=
 =?us-ascii?Q?5MpOUu/vX4V6gdJzTyJyWwEwgR98Fph59xKohOjqpAqGJhsmdyOgimiAWP32?=
 =?us-ascii?Q?ttV4ZY0nEn/nWRg3ThowBss9sOcd+i3p2cIYGfhlG3t6wPAaf5dmiWp1ECbT?=
 =?us-ascii?Q?NVm2dmNC1VPu6Cr/w89QehqpOGTAYFUwBRCxUU3K+site2ED7rPnVgHxr06O?=
 =?us-ascii?Q?fb7jzI5u8su1aWJQzomNNWqDSa7bjSdZQicmLSELWILylP+RUWiJKuqM0Ruq?=
 =?us-ascii?Q?TwWUZXFoOVwBrHi5HuencaMFBBnGQ96NzTbzXNuIhYkarSTbQ8xHebfllipL?=
 =?us-ascii?Q?8NcnPJVtVdMfWlX2vobyG1/jCqeitWJthGOG6Wzl68IJBOZ9cGCVdoeYiXqZ?=
 =?us-ascii?Q?vdGF3AsZvHEFFi/6PQ2oXa+CKdf3Wn4FGeK0wz817B+JLitPXlLI5qnT1S30?=
 =?us-ascii?Q?9XjWdEHUZzPFJLuG5bT7OBjck7cZjKCjQnPpzggIXaPRzVWYTi8IG1zFYdad?=
 =?us-ascii?Q?yL6tA72Hw9kXLpt8isxb9rMem5jAeiX5qJPOPhimAkn3N+hU5hfKSryqeXOH?=
 =?us-ascii?Q?t2TCeOhdUhkM9DdKn2y+xjIikL/7j2nARIts1GXhW2FhHwJ5NspiEIawFyHJ?=
 =?us-ascii?Q?JIexo/4dLid5cPlU5G8WbkLatFfNdCQXE6EXLiieBftgJo0sO9RnD0u1U+XT?=
 =?us-ascii?Q?KaydA7G6CGnrm3uovXB6Rsd2D4Tm3m19n07w4Y08CtlaP3b7ocqQqHjMdIav?=
 =?us-ascii?Q?uk9auYah7XnVpg8Uk3WIgDl0hC7r2SbKDzrRZTmPyY/6r9SHW0JAgOBfE4a/?=
 =?us-ascii?Q?VHZon7PArzb5sNyxuJt6hQhh/edME58/LHWCl5Wen437xARPRRSlLl5NKEXd?=
 =?us-ascii?Q?QxB2NHHpCrP3wDPhKpDFLdcZYns5458QVip9DZHYptgG/bq8f+q/TsvxPIEx?=
 =?us-ascii?Q?QD2jTCMWn/1+Dp1k2oii+S4LFm1EMKf3vG4Eq9PjCf+no1i4ziehc+5CZW2I?=
 =?us-ascii?Q?j6Rf2RayoRQJ9RLEEiXBA4SzBn16nHvxmzHmKdCnvi9ffpP+z4eS41QF3Rih?=
 =?us-ascii?Q?a5SR1i9xySGmubKbTrZ+Xqlv6PiwneHdAxfC6MLeqkk6nBJcaK77itSTLGPp?=
 =?us-ascii?Q?DYiL9gaayHm6MbnM+BW2YBYNj6XGptlpWdtgmGopQcOGbSSCoAozcNH+Mh0k?=
 =?us-ascii?Q?AL8mwAvwU6el2KXgUcDqXlDe9VGeAlv/KirfwQ/WKliTiEEKrYxJyuM7ZU7H?=
 =?us-ascii?Q?CYZlKQXlpgbwnzWjHd8tP7LuVlyBQGyEcp1s5oVV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e0e1e7-72a1-4174-e297-08db1aef0ce2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 07:23:42.0321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tstFUvP0EPUTvVY7AXkp67tjE4sK0shtIcuD2YFV52kn63fxN+zmzNBXqCxd/3kqoHv2oIM8vCxomrzQNakxQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5689
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 04:45:44PM +0800, Robert Hoo wrote:
>kvm_read_cr4_bits() returns ulong, explicitly cast it bool when assign to a
>bool variable.
>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>---
> arch/x86/kvm/x86.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 312aea1854ae..b9611690561d 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1236,7 +1236,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> 	bool skip_tlb_flush = false;
> 	unsigned long pcid = 0;
> #ifdef CONFIG_X86_64
>-	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>+	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> 
> 	if (pcid_enabled) {
> 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;

pcid_enabled is used only once. You can drop it, i.e.,

	if (kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)) {

>-- 
>2.31.1
>
