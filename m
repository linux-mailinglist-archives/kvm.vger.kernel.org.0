Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58CC65F39B
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 19:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbjAESSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 13:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjAESSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 13:18:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E75A4FCCD;
        Thu,  5 Jan 2023 10:18:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQYoh3LeYO3eptDdQ9tdK+S+herCCWUZRNsYAzUTehvKEYXaIAdkaYEG7tuze3ff4PH6nZ04y4GJDsP/x/eNpb6UKHY9+8Kl1570WvCRn1ynBK6umbfTnSD0FsOrYo4lhbwAwLeR1hZDLY2ghjo0sRs+NvHd7rqizpuNGGvlRPUnDMAM7SwuKwq6HzVjpGjEhHTjYG1xI2MivAN1upcvxAKIKa3pPRCzP4KElovBO9aSlnEOxUb/EjKcZpnmuXuWu5CWGUMxOJVOW3/UYpgp7HUAGQRlUV99Pcvn+Me82oYEOE3TP8yxUAmxJJqY7NmOqKQFsQj0PPFYxHiGHYT/wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKqnDT1gHrMhoV5q6lrtBAHL38nro7QLWKMTdZ9hoYQ=;
 b=PXNmlp8Ww2YUQapwqqabWQ3IQu98OifosvTlI9dEf/tPEU+Y+X9QsVziHzTSymBUGPBpkLJMO4y9gTi5T6REGy8o3tn2WaJayXF6tA7amayerWeB98MUPyVLzV2wVxdh662BY55Um5Bh2xITQDgmM7S76vHdRGjPWhN7Blh8dhqhfjvbhA3/U2Ad5tdze72XWn9kChc2neM8/jIFmKVp3seI3OAUO8UZcdISNZbsONUeQBDOi0AYQi2r6CesPOlfvkCIASY/Ctpq2/K+pRB2wPUMzL8QxbgzrJxKmqiYHcnrQbOlL2nA3TDJrY39h6CRlhcbSq/YxXAL7zGe5SvYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKqnDT1gHrMhoV5q6lrtBAHL38nro7QLWKMTdZ9hoYQ=;
 b=DRDmo1+IpdwyE3KsU5dEZIbvvcrbWR/5HgsY02qodx8vYng6y/HlEXC+KnBeiVoYvlTTQzTUJHxPFlTHxvvDbfcq3GimV1Fu2mFyuUw/aXf4QPUvhT2AomSLRAp5R+r1mpE6G0UAaQ176lBi2tmN0vKqwkgxbM0IakLphvFaV7s=
Received: from BN9PR03CA0982.namprd03.prod.outlook.com (2603:10b6:408:109::27)
 by CH3PR12MB8257.namprd12.prod.outlook.com (2603:10b6:610:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 18:17:59 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::95) by BN9PR03CA0982.outlook.office365.com
 (2603:10b6:408:109::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 18:17:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5944.17 via Frontend Transport; Thu, 5 Jan 2023 18:17:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 5 Jan
 2023 12:17:57 -0600
Date:   Thu, 5 Jan 2023 12:17:41 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
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
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Message-ID: <20230105181741.q6mq37gvcjk5nbjg@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-4-michael.roth@amd.com>
 <Y6Xd0ruz3kMij/5F@zn.tnic>
 <20230105021419.rs23nfq44rv64tsd@amd.com>
 <Y7bnE5bTUb6fQiX/@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7bnE5bTUb6fQiX/@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|CH3PR12MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a002a37-0734-4c71-d285-08daef492c8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9u2wmFlKKTJqDESjpZgeUQTS4lgiHAz6sA5e+Fr8kyy3kCfOYp1tlpqmkJgkLhfUlLsF7AUPobb5zG7aRiYEYXDlcFSSczEFVd3rZqv4/WPj3TSBsMJNDFh+dNQ8M7ID42e7SPswZu/OxvRreEbvmPps/jXkc40vjADWlIoY0C0KGKEA06sCbf1nw0Kh+t23oU6XpzPzwSSCUaWpEC/f9ADk/VVxlUajoHehDUH/2Wu7pwXGuV++Em8pNWog0if+yWK/YC7tlKYjhYipH6NWjd/O66FP3vMRVKLIMjQw+3yaq/bv3tZfWABl/PINfK4X5gjQxAJeLvwYbdWMOc/iBlDIQusIa4ggJL3UYW9DDAaH+0CXAL+Mv6TYgw8xOtOEHOlKQlbYyrNAemoQgKUtvBgdFhHUOFEpG/TJPsXXjvYNJZT7AkMxR/WF7BagsPwdMhDMROs9UxffWJbINeYXr+czaMkkFKAe9Lib/wY8GXtEqkm2A8wkGjHvYr6b3JkzvWKNbE86yy/fNtMVU4afqvuYJbrTAbHXU0N+vK7qy2mabkVClveYzPwy1wBTqHkklb+VeK16OOAXKkg9RIbx561nMmKTP1J/WbulI9OCsb8w50WQK2TjK8qgigkha0cV4yepq9x4zOH2GZSd3O5t0h6xdyCVKD/ehcu4wsbynocQAGkG4/yHjvCWlsG8NzFO+BXQQQerAYAiK+jaA10zZSyKliSmp1vA7gvMTSS2q6jAqfQXdsmwn+jhvBBX8ZJLm0KXt0JCmWgWcVuxZKifw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(7416002)(7406005)(41300700001)(5660300002)(70586007)(8676002)(70206006)(44832011)(2906002)(54906003)(6916009)(4326008)(8936002)(45080400002)(186003)(16526019)(478600001)(966005)(6666004)(26005)(426003)(40480700001)(336012)(47076005)(86362001)(36860700001)(2616005)(82740400003)(81166007)(36756003)(356005)(1076003)(316002)(82310400005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 18:17:58.4995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a002a37-0734-4c71-d285-08daef492c8f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8257
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 04:04:51PM +0100, Borislav Petkov wrote:
> On Wed, Jan 04, 2023 at 08:14:19PM -0600, Michael Roth wrote:
> > Maybe that's not actually enforced, by it seems awkward to try to use a
> > bool return instead. At least for KVM_X86_OP_OPTIONAL_RET0().
> 
> I don't see there being a problem/restriction for bool functions, see
> 
> 5be2226f417d ("KVM: x86: allow defining return-0 static calls")
> 
> and __static_call_return0() returns a long which, if you wanna interpret as
> bool, works too as "false".
> 
> I still need to disassemble and single-step through a static_call to see what
> all that magic does in detail, to be sure.

Hmm, yah, looking at that patch it seems pretty clear (at least at the
time) that bool returns are expected to work fine and there are still
existing cases that do things that way.

> 
> > However, we could just use KVM_X86_OP() to declare it so we can cleanly
> > use a function that returns bool, and then we just need to do:
> > 
> >   bool kvm_arch_has_private_mem(struct kvm *kvm)
> >   {
> >           if (kvm_x86_ops.private_mem_enabled)
> >                   return static_call(kvm_x86_private_mem_enabled)(kvm);
> 
> That would be defeating the whole purpose of static calls, AFAICT, as you're
> testing the pointer. Might as well leave it be a normal function pointer then.

That's true, we should just use the function pointer for those cases.
But given the above maybe KVM_X86_OP_OPTIONAL_RET0() is fine after all
so we can continue using static_call().

> 
> > On a separate topic though, at a high level, this hook is basically a way
> > for platform-specific code to tell generic KVM code that private memslots
> > are supported by overriding the kvm_arch_has_private_mem() weak
> > reference. In this case the AMD platform is using using kvm->arch.upm_mode
> > flag to convey that, which is in turn set by the
> > KVM_CAP_UNMAPPED_PRIVATE_MEMORY introduced in this series.
> > 
> > But if, as I suggested in response to your PATCH 2 comments, we drop
> > KVM_CAP_UNAMMPED_PRIVATE_MEMORY in favor of
> > KVM_SET_SUPPORTED_MEMORY_ATTRIBUTES ioctl to enable "UPM mode" in SEV/SNP
> > code, then we need to rethink things a bit, since KVM_SET_MEMORY_ATTRIBUTES
> > in-part relies on kvm_arch_has_private_mem() to determine what flags are
> > supported, whereas SEV/SNP code would be using what was set by
> > KVM_SET_MEMORY_ATTRIBUTES to determine the return value in
> > kvm_arch_has_private_mem().
> > 
> > So, for AMD, the return value of kvm_arch_has_private_mem() needs to rely
> > on something else. Maybe the logic can just be:
> > 
> >   bool svm_private_mem_enabled(struct kvm *kvm)
> >   {
> >     return sev_enabled(kvm) || sev_snp_enabled(kvm)
> 
> I haven't followed the whole discussion in detail but this means that SEV/SNP
> *means* UPM. I.e., no SEV/SNP without UPM, correct? I guess that's the final
> thing you guys decided to do ...

It's more about reporting whether UPM is *possible*. In the case of
this patchset there is support for using UPM in conjunction with SEV
or SEV-SNP, and that's all the above check is conveying. This is
basically what KVM_SET_SUPPORTED_MEMORY_ATTRIBUTES ioctl will rely on to
determine what attributes it reports to the guest as being supported,
which is basically what tells userspace whether or not it can make use
of UPM features.

In the case of SEV, it would still be up to userspace whether or not it
actually wants to make use of UPM functionality like KVM_SET_MEMORY_ATTRIBUTES
and private memslots. Otherwise, to maintain backward-compatibility, 
userspace can do things as it has always done and continue running SEV without
relying on private memslots/KVM_SET_MEMORY_ATTRIBUTES or any of the new ioctls.

For SNP however it is required that userspace uses/implements UPM
functionality.

-Mike

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&data=05%7C01%7Cmichael.roth%40amd.com%7C4bfcf0c3d1e54046703008daef2e35d4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638085279100077750%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=oCjQx7LV1paTYdMA4JpFjIexf5UkiZEf2pYOWTvpkZ0%3D&reserved=0
