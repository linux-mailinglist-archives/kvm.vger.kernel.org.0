Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332D969206E
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjBJOEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjBJOEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:04:45 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE9F656AE
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676037884; x=1707573884;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=f260QEA+Pp1M6w5JxKu2pwMh96UkewKszKWJ7CGtM1I=;
  b=naDYGraiyLKr2GFkJ5mnWoc1eJf5c6MV0G6A2nIVOjGZaxJupOYcEv/8
   aFqMy+dfaJxQoMWsVtFrK8bciapAlxUnPw5rKezOvrSi8Xfq2poZWKNDl
   UkPJhOSFvPgevU8gOvaoeeFqsP3tvQWOgWwvwZpONX4854eJeh+8jJC8t
   Ul5pmkf02vpNFCNdna45b9FqQFt6B4sjrfQNJfZQPNGBP4cYJ39zKFD5S
   Dj7bYmIec8k3xQVOz8zcO+86nHsrDU8bCpA3Qm1vQxCscUs7YutV53X2a
   TkZDTiUY8Sqey8IQl9cB/mD3DGhZn9o5NLenWtM2FAWXLiFhklpja+Xo7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395031494"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395031494"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 06:04:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="810825350"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="810825350"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 10 Feb 2023 06:04:43 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 06:04:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 06:04:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 06:04:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxSBUXLlpiJcmI8ovg4wHWN3j4SJOTV5tyuWqZyryt16KzUNN2u7rhYxxW3ePV+zHjq5yZQ0ieLz0wahiIYjDmp9MY+mMsEBVzLpBd+5wLQcJfAxfxunABBJGVaTgkssjaF8+Vo2NivjoQMNVGrpZfY8+nREu863LrnRE5OUvM77FC8REK5x/IXC5gdllG7vy+N6w/+VmXcyyY37387OqBeqebHUdacflT+cocsS2OllMvIrBvr9BRdBS/HYoZymVHYPLFIHMPZDKAJTW3rF0w+4tK4aoHfqLHdD9/CCrVcJLtA6pvw9EsaN86vX8y7qUuNmLs2m23hnix0FuOhMIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGV57rRKatqFjNh7kQOhx1nngzEM4/6MNoWug+IulpQ=;
 b=D4JY2HmOF3sDpHJfsTy2fBA9XDaTlkYgmXfSsoq7kbPSrL4BPyLIa1Hmr3TLVHbYsQ/4Z9c3pv+H6xbGMxrkeXGgKUYO07jEKv4xBu4nuFDWNica8i/uIPx/IFQORU8V+jGW+aFwwOvKOH/zJnPLzQQLqt0uxNBNJTPB8txd7nisdoEd3B8OdotlcLUZ6agVr9+ejC9nO+APIN8U7Cw+Jn/pYZaKHDZ5U5vCEK3w6F64HTx1lFuQVzP/GuDMWkJ2/SKW/oi9TUbnjO5RhUVWnCWJzroc0op8wrqY+cDLSYMVGKX9M9nJY8I3VwsrOEXn9nOvV/1jqMZf8fVzKQn2EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB8185.namprd11.prod.outlook.com (2603:10b6:610:159::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 14:04:39 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 14:04:39 +0000
Date:   Fri, 10 Feb 2023 22:04:55 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 4/9] KVM: x86: MMU: Integrate LAM bits when build
 guest CR3
Message-ID: <Y+ZPBxFBJTsItzeE@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-5-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-5-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR03CA0130.apcprd03.prod.outlook.com
 (2603:1096:4:91::34) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB8185:EE_
X-MS-Office365-Filtering-Correlation-Id: b9d21aa9-f9d6-4d63-be5d-08db0b6fbf9e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1BLJ0WwKrLqf9x1YhOE37/YQWoOogEc+tk0o1ktRINwbS453SQHCkKN6BokpKfqzagDW7lU6QJyMfaUUhfmbjie4VDSzP9q7MqpGMouxlBPl3Fekv+Gn6wE1YTMUehK4ZPAfjlq532kIobihBT07SVWJ5m8iCBh6xu7VeRSJ1yVnv8y3SEIO7lezcXpRhT65MwfXtnYQ+hvAhsSLP+sGn4DKq3rzHHSzJf7iEriqecVlUhVKQ8GyJq3tp9oPCe/RI8CKVc28JQUPsVcsRqgIeIICcimfaqRIFBK8eugMJVrGyiV4tdzJKy551B4px+cbA50qpbPeCt+GSAndDNcYgFSJpanGjLQ2uG5VU33Gwectk/ZLhk1KGIYHpp1Aiiei6+bJ9dpQHNFmVM7n5kKBRcFx1h1KJmfAcTKo57ESK4tPn1l/rRQUBrMqDb84MG3EnZKXE0FQdY6fNEj4QY/B8PNNlh7N52GZ7INXEuBGGzzIjUUOShfKdggI0UI4KsxHMo/qE/js01gPgi6otayoHSwrm4WVuJ0wuUkBg/4TbI+1jxpggcnvQeUoCBXQeLpR3fosOFB6AJFpnVyufMQ/ne+50GCopWgeFPUfj6CHgFxwZoGb2LqzDSqE9MjeeVuP5fvA+013QKfIgz1dW7JDNcrtpXIt+ZSDv6VRbNLsZUUj3hg8xQqzE0QbYKSf1GRN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199018)(33716001)(83380400001)(186003)(38100700002)(82960400001)(6512007)(26005)(9686003)(2906002)(6666004)(478600001)(316002)(6486002)(6506007)(41300700001)(8936002)(5660300002)(86362001)(44832011)(66556008)(66476007)(4326008)(66946007)(6916009)(8676002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H0bmSOJ+hI1BWS89gwwbK0iNsqe2UHUwHZotKXHUUDs+p7YkVe9dHZwAzDj3?=
 =?us-ascii?Q?OleRNv0wuMFR2841ycy3ta0Wwb90iimA1eHNEPS0kCCWooB8P6Bal9MZX8jT?=
 =?us-ascii?Q?ooFycqa8nPlWv3abCwJUTm4eC86cXswfzMMNsjgMHfNQt85p4LxmOetexctB?=
 =?us-ascii?Q?7wsXKeJL19O5dttVo2a3MNbQUmFCdPyobH8bA53TKejy6r0YtFzHTehJhHCU?=
 =?us-ascii?Q?Sv4uyu1K2DdcmCYtdHtkBUzl85MO90XeSq5U52/Sq2O0V/j57DIJUKgh82MF?=
 =?us-ascii?Q?Tql+bXWDn8sP63GfT2XluKVe97kYL6AKfDfyFF5zVIiq81VYez5W8KZH/IX/?=
 =?us-ascii?Q?IGiALDiiU7T+R54TXejVdM41G840/vk5rouWWJnnTt82ZK0nBl6VzsP8qZJx?=
 =?us-ascii?Q?kwqfB0QocW8IPVj0zrEnUfddJCFCcxbN6GzIhsvx/NFtFm7HVzRAY8stL/Yz?=
 =?us-ascii?Q?tkPnSDGtSnk6Lk+Dq2I8/NGNM3aH3qnQg3SuDzmTjKgAzJNANNbvKkk+5RzK?=
 =?us-ascii?Q?ixIypgdmYomM+D7XAXXXvEyAc3thsX7F0TGXjuCyhDDT8bh22TsooOLzEi8s?=
 =?us-ascii?Q?+2TU6G2GNkxZktdgCNT5FuL/QQHhjiXWpBrDzOLE/fBq7EJqR180l/SzOY/n?=
 =?us-ascii?Q?DlzddhVdC8UUcbrxDKE+Ashg/1be67kX9zEGd++xpM7jm3aed7ZxXMLHDppc?=
 =?us-ascii?Q?I16348xxhKevU4oGMZBneRu1JZPCN1qlOV5uhy1cb3LMU5kREQqW5MKl7Qu9?=
 =?us-ascii?Q?gEdNqkR3Az98p/DpGu6UneTOrWlg436Z/NE1lEDu/y+jO82YXvblZKgbj2Hp?=
 =?us-ascii?Q?20qwUBY5Kgi/gSj3WaI0dyZYClcF865jOqgzuqkpdE77h000ZKlOE41dpRgd?=
 =?us-ascii?Q?bg30tGDqOEjlZhrWraz5LgWvIRVj919L0G2SXJ1JM7ErRuy4ktG6lNZPNaXl?=
 =?us-ascii?Q?ePVc912v1bw6uttZZH9mUc6touATo5Bm8NZiWWIFNQyUoG8Z0tNxya2BncaW?=
 =?us-ascii?Q?XCqrF2PZeIkphN5CA8SJA1J8lW2BgVUNYDmSoCrJuoH3mB11qNHSyzUoxYmY?=
 =?us-ascii?Q?FXRg3QAIg9xA6KPXFobBMD2TueFAX+7Yl2+juoIBngmofNAMzvZgIRnj8BJt?=
 =?us-ascii?Q?T+XzU/bV9b4b/VxSCUUP4lH3cmiqven/SRlRGuzLf6tQzJZy6hAMj0imu7iC?=
 =?us-ascii?Q?DKoAEY6KJudIsQCNbsKWIUeEltA6nmGbLeMDm+RFW5hxFererSPYpPCyxHhd?=
 =?us-ascii?Q?GILYZSTC1q2Jb2BCvqm18qgjx9iqZrUoNerawMpgjlUbFlz+ef+rq0hF/O7L?=
 =?us-ascii?Q?fc8iSoqsd2mC+xIaPBq+aUkqMaveCiFxpBg7pMh3APHuRvzTLaFs9fSNkP9b?=
 =?us-ascii?Q?qbimg2bHInPIj0XgyG+9X5nCqhSiE4ov14wagpeJThhqpOgEyKOCpU3CymlA?=
 =?us-ascii?Q?bNvCMaZvyQPGRc4hh6Vw78mIn78+fXN/VrDIcZJDhSug9P5aAx9gxYf7lbfr?=
 =?us-ascii?Q?0Eyj6wQDFPxdEFex1cPm1h1Dqkv++KJhIF5NnVm4iQTqweOAYfTDucGjUN8R?=
 =?us-ascii?Q?ZBuGLkYloTI/UHHRjRv5ekh5+3HON2cpS2vOV8Vj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d21aa9-f9d6-4d63-be5d-08db0b6fbf9e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 14:04:38.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcB1IYeCdlwvXp50iYmCh15zcCV7gxjBGJNNektRNTDa84SNYX+L4jHUVx0pcRm+iQCnpOdnPj9uUNL0BGj8nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8185
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 10:40:17AM +0800, Robert Hoo wrote:
>When calc the new CR3 value, take LAM bits in.

I prefer to merge this one into patch 2 because both are related to
CR3_LAM_U48/U57 handling. Merging them can give us the whole picture of
how the new LAM bits are handled:
* strip them from CR3 when allocating/finding a shadow root
* stitch them with other fields to form a shadow CR3

I have a couple questions:
1. in kvm_set_cr3(), 

        /* PDPTRs are always reloaded for PAE paging. */
        if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
                goto handle_tlb_flush;

Shouldn't we strip off CR3_LAM_U48/U57 and do the comparison?
It depends on whether toggling CR3_LAM_U48/U57 causes a TLB flush.

2. also in kvm_set_cr3(),

        if (cr3 != kvm_read_cr3(vcpu))
                kvm_mmu_new_pgd(vcpu, cr3);

is it necessary to use a new pgd if only CR3_LAM_U48/U57 were changed?

>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
>---
> arch/x86/kvm/mmu.h     | 5 +++++
> arch/x86/kvm/vmx/vmx.c | 3 ++-
> 2 files changed, 7 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>index 6bdaacb6faa0..866f2b7cb509 100644
>--- a/arch/x86/kvm/mmu.h
>+++ b/arch/x86/kvm/mmu.h
>@@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
> 	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
> }
> 
>+static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
>+{
>+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
>+}
>+
> static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
> {
> 	u64 root_hpa = vcpu->arch.mmu->root.hpa;
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index fe5615fd8295..66edd091f145 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -3289,7 +3289,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> 			update_guest_cr3 = false;
> 		vmx_ept_load_pdptrs(vcpu);
> 	} else {
>-		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
>+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
>+			    kvm_get_active_lam(vcpu);
> 	}
> 
> 	if (update_guest_cr3)
>-- 
>2.31.1
>
