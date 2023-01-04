Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6C465E31F
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 03:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjAEC6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 21:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAEC6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 21:58:30 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394029FFF;
        Wed,  4 Jan 2023 18:58:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nduR79k77Wpos/VAAYHoAvJ/+qLSQTuyGYledcPxkH2QyKTmkgQZVoALnh8O0BlG5+xTrKBQkWuJ25CIP0VPsxsRtnyqjKB/6y7xRTlpwvj9EZfiQnET9wTudrIIDCl3C8pv/P6kIkRZnJ+wdna6+sw2OH7dvhtS0GnOs3egTZcdbIo3hUu0aVHqSrHuen5byJpaHYb/7f7ygNbGkeOk6WoQ64lH9+cTsHrP2QfgH358uL6BqgYMvBGKSKwXZyZZtIIkOLs+M0mrP82alVfylwumMetF7EwOvYQ+LjD+RwTTN+sH7ghE4PiiIGrawoovNrgV/PXyOVJr04COzxG7eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugtSNyt+nUXlVfWzk5XZaVZAFZPpNa20m9RhqH2gMgE=;
 b=KVHpWV5jCb+NAWb/b723PycERWMb7PWYSkGOI1WCu9cuFVLsIQWgqmhIAXBK5RwoKiKlrORpFMBkjIkOG262eXFmXD+l5W1t4v07V/8okQ+Dx5xblCq10gZKvAY2EsS0n0KE/b9MC4z7ZqJcuBmL/ILm/9BtW+MrD2s/VRxM4TgKxj44tkgdGW8YkgUfSk7qUjEkLSrSKKvnB178mNi27l77llASP1yd/nkqmRImAfJmHS7Ak5cvqOD2onsCIpRKrKntsEnjZOamwN+pJ2NdatP4JEffjNIJSVOAquL8kdbzhmwYUFzlikt6ipIG8UM8O8XPTSPRRoexS+EGcuahOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugtSNyt+nUXlVfWzk5XZaVZAFZPpNa20m9RhqH2gMgE=;
 b=lhD6g99oAuFo2hrNsUo4rB6taBUD6LgFEfH+tmWxbAaksdBy5YkwCiR/m8BP9lHIlpTgN+WBwHCFCruMscuJV1QnVTCOA4J32R+XHaLNFZQH0ZQsPT5NHQWLSrZ93U/BhpnNEHAXBdyH8EVCrxQl2YqASxRDVn03RbkdfjBDUHU=
Received: from DM6PR21CA0008.namprd21.prod.outlook.com (2603:10b6:5:174::18)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 02:58:27 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::4a) by DM6PR21CA0008.outlook.office365.com
 (2603:10b6:5:174::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.6 via Frontend
 Transport; Thu, 5 Jan 2023 02:58:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.17 via Frontend Transport; Thu, 5 Jan 2023 02:58:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 20:58:26 -0600
Date:   Wed, 4 Jan 2023 11:56:32 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH RFC v7 02/64] KVM: x86: Add
 KVM_CAP_UNMAPPED_PRIVATE_MEMORY
Message-ID: <20230104175632.mqmg4xybbe7vzies@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-3-michael.roth@amd.com>
 <Y7VrIDfNmhG+BVQ9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7VrIDfNmhG+BVQ9@kernel.org>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT054:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 34744ed2-4ee2-42f1-fdbc-08daeec8b7d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uP94FJYLNcJRqz5NBffyRbBr9rBJ8sP1dEd4YohRg2C6ZG4h+PitSkFgpA4BvkIc2W9E1KK+qwuvcRNfZ7P5zi4hnwT5Acw8Sw3cYKsL5cGzNwDMBUS60z6OEZmUB3dmcgXtdUCQ7kg3wZrtRqjiszD3JyQC9fRoS/rGZH+J/iWoQp0JwV8acMmMYjpj6SvaUQNErr6/kItjyurXYzt1GmCFrw3jWqU7Gk5470AQTJ/Q8mOC7rz1S/o2jTeS7JztPFQ4KfO5U63JLyBLyszhK7EB2+q02AOVr2tq1mNbK8cqDeuZfpZ1ezbCph8wH30gw+Ylg8GCzUzEyFugvD4glZEafPWJ7N1IHWXzjzBLLqRRA8pG8RoJEdJYi5vijLOh17aeWcmtwnORDWpq2EadtvN8/M/rB9ZCHL+G0xW8Mo5dM9jEh+jNbRMFsc9vLFU8GDgPIavUYg2Vz0yOyIWZYIHCK6/RJR7AzeMpGBUPfgLEBxk9n+harhn29i4tLQpkrwSX1MbGOJFEMlVp0NxjLz3Y65eYXhaySwJtW5QTZcu7v5Obj+MH8rDioJUuQOp/1gLgbqSZAZyV8g/EO71Wc8yEdlZ/bUhdWZkeIX3nCoaNozcfBs3ZObX93fisrA+zE1VUlKHcGUtMQi6EQOzol8lKSvE7h+tdSWja0bFKJh3KuCJXbCfRPy5RVSqNpDHFogDJOfAO2m+BRw9aD5gjgUQMvqm1ftXCO4++NDTm6Q8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(46966006)(36840700001)(40470700004)(426003)(47076005)(16526019)(26005)(82310400005)(1076003)(2616005)(83380400001)(336012)(186003)(6666004)(40480700001)(40460700003)(36860700001)(86362001)(36756003)(356005)(82740400003)(81166007)(4326008)(8676002)(8936002)(41300700001)(66899015)(2906002)(5660300002)(7406005)(7416002)(44832011)(478600001)(70586007)(316002)(70206006)(6916009)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:58:27.0755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34744ed2-4ee2-42f1-fdbc-08daeec8b7d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 12:03:44PM +0000, Jarkko Sakkinen wrote:
> On Wed, Dec 14, 2022 at 01:39:54PM -0600, Michael Roth wrote:
> > This mainly indicates to KVM that it should expect all private guest
> > memory to be backed by private memslots. Ideally this would work
> > similarly for others archs, give or take a few additional flags, but
> > for now it's a simple boolean indicator for x86.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  3 +++
> >  arch/x86/kvm/x86.c              | 10 ++++++++++
> >  include/uapi/linux/kvm.h        |  1 +
> >  3 files changed, 14 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 27ef31133352..2b6244525107 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1438,6 +1438,9 @@ struct kvm_arch {
> >  	 */
> >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> >  	struct kvm_mmu_memory_cache split_desc_cache;
> > +
> > +	/* Use/enforce unmapped private memory. */
> > +	bool upm_mode;
> >  };
> >  
> >  struct kvm_vm_stat {
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c67e22f3e2ee..99ecf99bc4d2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4421,6 +4421,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_EXIT_HYPERCALL:
> >  		r = KVM_EXIT_HYPERCALL_VALID_MASK;
> >  		break;
> > +#ifdef CONFIG_HAVE_KVM_MEMORY_ATTRIBUTES
> > +	case KVM_CAP_UNMAPPED_PRIVATE_MEM:
> > +		r = 1;
> > +		break;
> > +#endif
> >  	case KVM_CAP_SET_GUEST_DEBUG2:
> >  		return KVM_GUESTDBG_VALID_MASK;
> >  #ifdef CONFIG_KVM_XEN
> > @@ -6382,6 +6387,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >  		}
> >  		mutex_unlock(&kvm->lock);
> >  		break;
> > +	case KVM_CAP_UNMAPPED_PRIVATE_MEM:
> > +		kvm->arch.upm_mode = true;
> > +		r = 0;
> > +		break;
> >  	default:
> >  		r = -EINVAL;
> >  		break;
> > @@ -12128,6 +12137,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >  	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
> >  	kvm->arch.guest_can_read_msr_platform_info = true;
> >  	kvm->arch.enable_pmu = enable_pmu;
> > +	kvm->arch.upm_mode = false;
> >  
> >  #if IS_ENABLED(CONFIG_HYPERV)
> >  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index c7e9d375a902..cc9424ccf9b2 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1219,6 +1219,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
> >  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
> >  #define KVM_CAP_MEMORY_ATTRIBUTES 225
> > +#define KVM_CAP_UNMAPPED_PRIVATE_MEM 240
> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >  
> > -- 
> > 2.25.1
> > 
> 
> Why we want to carry non-UPM support still?

For SNP, non-UPM support is no longer included in this patchset.

However, this patchset also adds support for UPM-based SEV (for lazy-pinning
support). So we still need a way to let userspace switch between those 2
modes.

-Mike

> 
> BR, Jarkko
> 
