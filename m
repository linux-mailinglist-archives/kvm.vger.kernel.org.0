Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BACE675EAD
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 21:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjATUKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 15:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjATUKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 15:10:30 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFB1AA7F6;
        Fri, 20 Jan 2023 12:10:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObYA5zjvcCMt97aZk4BqKKuhWyeE80a0Bo+GD84muAqP6GHB93YNPp5uxJc/dnLvfJJWz8V91KuHORSia98ffEZwPfQQdPIlu2aQQS2U42qkEKXH5sPIFZTRo5aJHO6MC3ahVpEpZoi3r/Z+uEZ41bE+27yrlYj2Gc4RO6NEvhHKVtUfEFDnouGKxbafV+fGZii8lWTNjm+R9F8hlfWYoZUjCOs+HGTtTvJfVQEgopyy/Uul7OXitlQS1lQ8jBEip5+x+x8VwGqLWlYYXM4TxG5qej3a2m2Mgr4+vo77n8WxiBvhqTZwa1S/fxEMXc9W4OsoGK25e05S0C/F5XIcpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdIThfOt+359IWoZYZxagRuePUVr9tk6mUaHYHh0azY=;
 b=k/DcPxyQK9L/vohpqvubkU9Dn9w42M8Y4weSbqFxrfv7JQFo/um5GljahA2qkWwDQF37638xvoix2v7VtCCKnlEbXvLljOPKyZhJ4TKU2w9cMpiL7kliWiG+hytcsQmTuph7nK6iSbwkDGBBlYJc0byGgETaY6B6XI7cCd2ow49lL19I14uCWigzQWZfj6SYsnArV80zw6lHZTJCGPFcMQS1tYd7Ic5IpfZy+YJEofYXpd0lG08fqMq1y8+IWxC9gXqmACZFzW77OlNaZt593bc3YOdmO1n8AWjfaSFe9Gy9VWlG+zVF/kVIf1kRNSw1ChRXzlGUfemsVRgRCrePWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdIThfOt+359IWoZYZxagRuePUVr9tk6mUaHYHh0azY=;
 b=CpBggc542RzhL0yGv2I329mYla1eSQDjs1AJHy0fLzPxekqx5I2VesqIpXlj+gstaZ5zLAxYdTccte/6KiNQ+ztJurYpIsDMd6W2PS3a2chQ4u21m8dc9Q1iybU73YGWJD9Hy6+66RfUv1t6Q8sCTXU1dgPHMIVRH9VCv8hQ94Y=
Received: from DM6PR07CA0083.namprd07.prod.outlook.com (2603:10b6:5:337::16)
 by SJ0PR12MB6712.namprd12.prod.outlook.com (2603:10b6:a03:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 20:10:26 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::84) by DM6PR07CA0083.outlook.office365.com
 (2603:10b6:5:337::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Fri, 20 Jan 2023 20:10:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Fri, 20 Jan 2023 20:10:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 20 Jan
 2023 14:10:24 -0600
Date:   Fri, 20 Jan 2023 14:10:08 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Alper Gun <alpergun@google.com>
CC:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
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
        <dgilbert@redhat.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <harald@profian.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v7 44/64] KVM: SVM: Remove the long-lived GHCB host
 map
Message-ID: <20230120201008.v5kxftwqoddlslfe@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-45-michael.roth@amd.com>
 <20230118152721.GA24742@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CABpDEunq_GwJZWw9LNEHB=67w7PHut=UfCr_0bmTHe6Ymng9vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABpDEunq_GwJZWw9LNEHB=67w7PHut=UfCr_0bmTHe6Ymng9vQ@mail.gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT056:EE_|SJ0PR12MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d66ff1-9e9a-4c72-a38c-08dafb225e1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SZXGCnMjT1dnD9UFPWwFZCiIlXCbmxGJtq0Na8QetK27/B+MPcaLHv1YrFGP/Ftk6asezaaAV9sMCBiLBCREpmSdQ8StVIp9Khex2409+1RBcnE63fN+TgyWlqembeIilnny/D1EtrYOSfka5q/RuwnXUCXoEXtkYoLZRyXKiysxOnRHO4KsoL0WOC4vWkJrbAU3yyNawUEMKu78GFbXXJZi7M12rIDBd2+EXxBhvgjYIx3b6XJ0NM6SZ3Cc9zK7MgMo+bPlKHIr3qxB735Di3ypbLuuvTuIa4vHTcVR9mBVzYaxvbvrj3aTgvkOOOXfo9yKYgzrF9tel2YAzEM9Y3NYGIimP8HDU/rekaF3IbhkjWMm9aCBxpSjXihMCorzo2uJeGQiNR8XZ+x13rQtENUa/CpaAgVdSPifD7Hml1TyayMSiSgRpSlmC321Ulsxdy1HHapxkOORpmaX7AJ8MdXavK9yofMIY5Hr495x6FRajVNnHhe2EjCg9WiMjLfxhJb0FQHtl7RUo2AFbgXkH2TnM92mIfK4k6s81aO3DiAAqzdqC4SuKBqH+4Gl/EeJ+0yWbRc0A8q3pvuVrvBDYH0H6nv/w2//5vPzxdnTQ/cqVnURm9e0JBWmYSwl1ji1RjbakZAtwkrGdMhcudVHA16QApNE8S8HWJazHQ7GPTAGflwhNdKT28OSG5i8g5fXKaGtvLnjKmwFPZzn5+KdRLtWvX5fmd+w/Xa00qs8LwPRWjrn1Gj2Xd6TElpjULqVr+xevoD0qEh6h7IJpDOeqg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199015)(36840700001)(40470700004)(46966006)(81166007)(7416002)(26005)(5660300002)(44832011)(356005)(7406005)(41300700001)(8936002)(40460700003)(82740400003)(36860700001)(36756003)(54906003)(6666004)(53546011)(186003)(83380400001)(86362001)(16526019)(478600001)(316002)(8676002)(70206006)(2906002)(4326008)(82310400005)(70586007)(2616005)(426003)(40480700001)(336012)(1076003)(6916009)(47076005)(21314003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 20:10:25.1869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d66ff1-9e9a-4c72-a38c-08dafb225e1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6712
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 10:15:38AM -0800, Alper Gun wrote:
> On Wed, Jan 18, 2023 at 7:27 AM Jeremi Piotrowski
> <jpiotrowski@linux.microsoft.com> wrote:
> >
> > On Wed, Dec 14, 2022 at 01:40:36PM -0600, Michael Roth wrote:
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > >
> > > On VMGEXIT, sev_handle_vmgexit() creates a host mapping for the GHCB GPA,
> > > and unmaps it just before VM-entry. This long-lived GHCB map is used by
> > > the VMGEXIT handler through accessors such as ghcb_{set_get}_xxx().
> > >
> > > A long-lived GHCB map can cause issue when SEV-SNP is enabled. When
> > > SEV-SNP is enabled the mapped GPA needs to be protected against a page
> > > state change.
> > >
> > > To eliminate the long-lived GHCB mapping, update the GHCB sync operations
> > > to explicitly map the GHCB before access and unmap it after access is
> > > complete. This requires that the setting of the GHCBs sw_exit_info_{1,2}
> > > fields be done during sev_es_sync_to_ghcb(), so create two new fields in
> > > the vcpu_svm struct to hold these values when required to be set outside
> > > of the GHCB mapping.
> > >
> > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > [mdr: defer per_cpu() assignment and order it with barrier() to fix case
> > >       where kvm_vcpu_map() causes reschedule on different CPU]
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >  arch/x86/kvm/svm/sev.c | 131 ++++++++++++++++++++++++++---------------
> > >  arch/x86/kvm/svm/svm.c |  18 +++---
> > >  arch/x86/kvm/svm/svm.h |  24 +++++++-
> > >  3 files changed, 116 insertions(+), 57 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index d5c6e48055fb..6ac0cb6e3484 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -2921,15 +2921,40 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
> > >       kvfree(svm->sev_es.ghcb_sa);
> > >  }
> > >
> > > +static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
> > > +{
> > > +     struct vmcb_control_area *control = &svm->vmcb->control;
> > > +     u64 gfn = gpa_to_gfn(control->ghcb_gpa);
> > > +
> > > +     if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
> > > +             /* Unable to map GHCB from guest */
> > > +             pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
> > > +             return -EFAULT;
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
> > > +{
> > > +     kvm_vcpu_unmap(&svm->vcpu, map, true);
> > > +}
> > > +
> > >  static void dump_ghcb(struct vcpu_svm *svm)
> > >  {
> > > -     struct ghcb *ghcb = svm->sev_es.ghcb;
> > > +     struct kvm_host_map map;
> > >       unsigned int nbits;
> > > +     struct ghcb *ghcb;
> > > +
> > > +     if (svm_map_ghcb(svm, &map))
> > > +             return;
> > > +
> > > +     ghcb = map.hva;
> >
> > dump_ghcb() is called from sev_es_validate_vmgexit() with the ghcb already
> > mapped. How about passing 'struct kvm_host_map *' (or struct ghcb *) as a
> > param to avoid double mapping?
> 
> This also causes a soft lockup, PSC spin lock is already acquired in
> sev_es_validate_vmgexit. dump_ghcb will try to acquire the same lock
> again. So a guest can send an invalid ghcb page  and cause a host soft
> lockup.

We did notice that issue with v6, and had a fix similar to what Jeremi
suggested, but in this patchset the psc_lock spinlock has been replaced
in favor of taking a read_lock() on kvm->mmu_lock.

The logic there is that userspace drives the page state changes via
kvm_vm_ioctl_set_mem_attributes() now, and it does so while holding a
write_lock() on kvm->mmu_lock, so if we want to guard the GHCB page from
page state changes while the kernel is accessing it, it makes sense to
use the same lock rather than relying on some separate SNP-specific lock.

And because it's now a read_lock(), I don't think the deadlock issue is
present anymore in v7, but it probably does still make sense to avoid the
double-mapping as Jeremi suggested, so we'll plan to make that change for
v8.

Thanks,

Mike
