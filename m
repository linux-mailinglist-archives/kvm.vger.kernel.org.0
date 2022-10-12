Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6866D5FCEAA
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 00:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJLW7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 18:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiJLW62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 18:58:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A53120BEB;
        Wed, 12 Oct 2022 15:58:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Io3q2jwQ8MO1+xn0BTi59o3v08G1MnkTrQBrYGqO4g+X2fDSwsG1vMCbw0dmecl7FWYu2OvcHW6KlMvbwMZdmvkQfIY7AQw/mNVhaYh1gsvVsuI0hbVigG5XBpsUMlT6E4f27ZuncKl6hlCCcWT/VU9ej/+GWP9xiSNGDBJ8eYJ7CP0DQJcMTR7RD1avBns6lGo/TPCthKUT9xVmJ5maA618FyrK9cYM8oRvYo0UQK9p11k0sZZ0YIYPDLEAHagwfoWTvcW84qhK2M0WdIZnKT0xjRERSdjrMYdQiU7sipxoBdQCi2vYcKiqr5/zMU+cDDS5zLDSVbGObMWzfDX49A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoiPAXbycVc2JvqIJ0QHKmjoUU6vT0Oot4s+R0A+FYU=;
 b=npM2+yk9IULo0GTsjVpI4yOd19mZmyL2+skSiDKeCeYIXkeny4CWMQcdOXgsUnog4NhRLUdx+nGoEqOb+4GalCYRe8l9eEwkMExFnwqpfAanQEGJVsv/iU97WmagEUksm0RcShUhJq+6OaC27uLK9gqBO3tmzKEFe5Sb2+TW4aPV0Ts4y1hxhMo0X4wkcyhkdlJYSgkhAyWPRr4FjJgqJkvyxkSKPFRS+1SyJD/cf5xPA7jaUQxVvbQzNvaZOtfMwZktFrrNYQiIMlrIDzwt9TeQxkWUb4z/O3Wx2JaxvDiMhG9xpwArKGfRITlRtSXzD0F8vRiKJ2RXxt+/JD3+WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoiPAXbycVc2JvqIJ0QHKmjoUU6vT0Oot4s+R0A+FYU=;
 b=kayLj/AJX/j8TInYGZJu58CtT9M6S05aRso8vQUOUU4Hfk5xMYBxP4yimKHpgpEQHgnd7iO8BVRyo7UDWNQBpdqcKs+H6zkqs2SCJGHWoG4YUSc9JCrKIlSwJ7h7wLzZkEgtbfH3ByeOJ5r+MnjDnDzHT0XJ9jvJ4sGaXKP5uIU=
Received: from DM6PR07CA0068.namprd07.prod.outlook.com (2603:10b6:5:74::45) by
 CY5PR12MB6549.namprd12.prod.outlook.com (2603:10b6:930:43::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.15; Wed, 12 Oct 2022 22:58:02 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::25) by DM6PR07CA0068.outlook.office365.com
 (2603:10b6:5:74::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21 via Frontend
 Transport; Wed, 12 Oct 2022 22:58:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 22:58:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 17:58:01 -0500
Date:   Wed, 12 Oct 2022 17:57:42 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
CC:     Peter Gonda <pgonda@google.com>, Ashish Kalra <ashkalra@amd.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Alper Gun <alpergun@google.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        "Linux Memory Management List" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Tobin Feldman-Fitzthum" <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Andi Kleen" <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Message-ID: <20221012225742.hirj4kfovrs4cumq@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rrGJ5DYTAJKFUTagN9i_opS8u5HPw5c_8NoyEjK7rYzA@mail.gmail.com>
 <CABpDEum157s5+yQvikjwQRaOcxau27NkMzX9eCs9=HFOW5FYnA@mail.gmail.com>
 <0716365f-3572-638b-e841-fcce7d30571a@amd.com>
 <CABpDEu=quPsv6cXfbvpsGS2N+5Pcw7inCfmv=sx3-VaK0UE76g@mail.gmail.com>
 <8113b5d4-31c6-012c-fc0c-78a9bdbb1e69@amd.com>
 <31c1b2bb-b43a-709a-2b7e-0e945b9e8bb7@amd.com>
 <CAMkAt6o=G7W3pRgVYiBKK5RjQskMfzL_9me2Hcr7_e9rTHuStw@mail.gmail.com>
 <53010b89-ae47-0065-9238-0ab065b70a44@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53010b89-ae47-0065-9238-0ab065b70a44@amd.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|CY5PR12MB6549:EE_
X-MS-Office365-Filtering-Correlation-Id: 38aa3887-8453-4066-c677-08daaca5377f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 16Wzrbt8r0rJkOZeuL/0kd7H+1AaqkrWQ0OP6/aYa126+DMqSmsVrWcJXVQWIylF5grww8MVD/p3Fg5hglwKt9QvFM2g9Q/cAA+DR5zVywjBKnm7350bJn6q2hY6M0t4qJDVT7MbrNeV0e/uLMZtep8+MfYK7juqqp1uK2Ccc+COQC7/9p5nGQBbDz4mTq4pLSpZIwZrpWjPfWUq8e2F2NADQw+G3R5rDZKcSSFIUwLK5HmbNDwxosrgxKRopGrA008VXfwC3kJy2WydckHNXfnm/4QOdjnVge1BusDQLowZx52QL6POOBQEvh2Sk5K4tFUt4YWBXYoY2Y/JgHh4B/uGRKV+x+RWIBbKA2uI10GIiO0Joe+Ox+6NKeG+oJrShZN4GVS9j7hKhoAbl3F7AP++x+xLTykFggVxhVb4bmLZSIHWUbgYrcweNRKdYA2uzspAJMs2hV9k0C1s3Ek+LYWi8A884zMPzRzrTQ5Z7pHf8e3hhHh8QIg1q6v35Bf5P0UXvttYmmnkzS41t8ejJ3u3Gg+keaDO66XO1brN4zRLqHzNlry5BvDMjckGyuUgKdCvqNQB736gvFcaxba5MaOpuMR87FpNlcD3h2gMgQ3FdBMB71p5zCqFQfDO2gYWj4b79SXuEhiOhw/65uFE1p41AyclDBMSLPpN8YyKqCZXIhXSEjuvHuKXjdHJ0Qv2b9txZ8gM+WbyGurLYRKzgAlRbaHCt7L5r+3WevvYQEtWT/3EcsEkPvxdc7uuYBn+VdyjddgdBBJe7GC+TpuonjR3cpFy504fD7iVxggey49b/VAFm9Fe1YWrGyB2HQUQ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(66899015)(26005)(36860700001)(37006003)(54906003)(8676002)(6636002)(316002)(36756003)(82740400003)(356005)(40480700001)(40460700003)(86362001)(478600001)(2616005)(6666004)(336012)(83380400001)(5660300002)(426003)(1076003)(7406005)(7416002)(53546011)(47076005)(16526019)(4326008)(8936002)(6862004)(2906002)(81166007)(186003)(41300700001)(44832011)(70586007)(70206006)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 22:58:02.5642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38aa3887-8453-4066-c677-08daaca5377f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6549
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 03:15:15PM -0500, Kalra, Ashish wrote:
> On 9/26/2022 10:19 AM, Peter Gonda wrote:
> > On Mon, Sep 19, 2022 at 5:47 PM Ashish Kalra <ashkalra@amd.com> wrote:
> > > 
> > > 
> > > On 9/19/22 22:18, Tom Lendacky wrote:
> > > > On 9/19/22 17:02, Alper Gun wrote:
> > > > > On Mon, Sep 19, 2022 at 2:38 PM Tom Lendacky
> > > > > <thomas.lendacky@amd.com> wrote:
> > > > > > 
> > > > > > On 9/19/22 12:53, Alper Gun wrote:
> > > > > > > On Fri, Aug 19, 2022 at 9:54 AM Peter Gonda <pgonda@google.com> wrote:
> > > > > > > > 
> > > > > > > > > +
> > > > > > > > > +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu,
> > > > > > > > > enum psc_op op, gpa_t gpa,
> > > > > > > > > +                                         int level)
> > > > > > > > > +{
> > > > > > > > > +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> > > > > > > > > +       struct kvm *kvm = vcpu->kvm;
> > > > > > > > > +       int rc, npt_level;
> > > > > > > > > +       kvm_pfn_t pfn;
> > > > > > > > > +       gpa_t gpa_end;
> > > > > > > > > +
> > > > > > > > > +       gpa_end = gpa + page_level_size(level);
> > > > > > > > > +
> > > > > > > > > +       while (gpa < gpa_end) {
> > > > > > > > > +               /*
> > > > > > > > > +                * If the gpa is not present in the NPT then
> > > > > > > > > build the NPT.
> > > > > > > > > +                */
> > > > > > > > > +               rc = snp_check_and_build_npt(vcpu, gpa, level);
> > > > > > > > > +               if (rc)
> > > > > > > > > +                       return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +               if (op == SNP_PAGE_STATE_PRIVATE) {
> > > > > > > > > +                       hva_t hva;
> > > > > > > > > +
> > > > > > > > > +                       if (snp_gpa_to_hva(kvm, gpa, &hva))
> > > > > > > > > +                               return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +                       /*
> > > > > > > > > +                        * Verify that the hva range is
> > > > > > > > > registered. This enforcement is
> > > > > > > > > +                        * required to avoid the cases where a
> > > > > > > > > page is marked private
> > > > > > > > > +                        * in the RMP table but never gets
> > > > > > > > > cleanup during the VM
> > > > > > > > > +                        * termination path.
> > > > > > > > > +                        */
> > > > > > > > > +                       mutex_lock(&kvm->lock);
> > > > > > > > > +                       rc = is_hva_registered(kvm, hva,
> > > > > > > > > page_level_size(level));
> > > > > > > > > +                       mutex_unlock(&kvm->lock);
> > > > > > > > > +                       if (!rc)
> > > > > > > > > +                               return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +                       /*
> > > > > > > > > +                        * Mark the userspace range unmerable
> > > > > > > > > before adding the pages
> > > > > > > > > +                        * in the RMP table.
> > > > > > > > > +                        */
> > > > > > > > > +                       mmap_write_lock(kvm->mm);
> > > > > > > > > +                       rc = snp_mark_unmergable(kvm, hva,
> > > > > > > > > page_level_size(level));
> > > > > > > > > +                       mmap_write_unlock(kvm->mm);
> > > > > > > > > +                       if (rc)
> > > > > > > > > +                               return -EINVAL;
> > > > > > > > > +               }
> > > > > > > > > +
> > > > > > > > > +               write_lock(&kvm->mmu_lock);
> > > > > > > > > +
> > > > > > > > > +               rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn,
> > > > > > > > > &npt_level);
> > > > > > > > > +               if (!rc) {
> > > > > > > > > +                       /*
> > > > > > > > > +                        * This may happen if another vCPU
> > > > > > > > > unmapped the page
> > > > > > > > > +                        * before we acquire the lock. Retry the
> > > > > > > > > PSC.
> > > > > > > > > +                        */
> > > > > > > > > + write_unlock(&kvm->mmu_lock);
> > > > > > > > > +                       return 0;
> > > > > > > > > +               }
> > > > > > > > 
> > > > > > > > I think we want to return -EAGAIN or similar if we want the caller to
> > > > > > > > retry, right? I think returning 0 here hides the error.
> > > > > > > > 
> > > > > > > 
> > > > > > > The problem here is that the caller(linux guest kernel) doesn't retry
> > > > > > > if PSC fails. The current implementation in the guest kernel is that
> > > > > > > if a page state change request fails, it terminates the VM with
> > > > > > > GHCB_TERM_PSC reason.
> > > > > > > Returning 0 here is not a good option because it will fail the PSC
> > > > > > > silently and will probably cause a nested RMP fault later. Returning
> > > > > > 
> > > > > > Returning 0 here is ok because the PSC current index into the PSC
> > > > > > structure will not be updated and the guest will then retry (see the
> > > > > > loop
> > > > > > in vmgexit_psc() in arch/x86/kernel/sev.c).
> > > > > > 
> > > > > > Thanks,
> > > > > > Tom
> > > > > 
> > > > > But the host code updates the index. It doesn't leave the loop because
> > > > > rc is 0. The guest will think that it is successful.
> > > > > rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
> > > > > if (rc)
> > > > > goto out;
> > > > > 
> > > > > Also the page state change request with MSR is not retried. It
> > > > > terminates the VM if the MSR request fails.
> > > > 
> > > > Ah, right. I see what you mean. It should probably return a -EAGAIN
> > > > instead of 0 and then the if (rc) check should be modified to
> > > > specifically look for -EAGAIN and goto out after setting rc to 0.
> > > > 
> > > > But that does leave the MSR protocol open to the problem that you
> > > > mention, so, yes, retry logic in snp_handle_page_state_change() for a
> > > > -EAGAIN seems reasonable.
> > > > 
> > > > Thanks,
> > > > Tom
> > > 
> > > I believe it makes more sense to add the retry logic within
> > > __snp_handle_page_state_change() itself, as that will make it work for
> > > both the GHCB MSR protocol and the GHCB VMGEXIT requests.
> > 
> > You are suggesting we just retry 'kvm_mmu_get_tdp_walk' inside of
> > __snp_handle_page_state_change()? That should work but how many times
> > do we retry? If we return EAGAIN or error we can leave it up to the
> > caller
> > 
> 
> Ok, we return -EAGAIN here and then let the caller in
> snp_handle_page_state_change() or sev_handle_vmgexit_msr_protocol()
> (in case of GHCB MSR protocol) do the retries.
> 
> But, the question still remains, how may retry attempts should the caller
> attempt ?

With UPM I don't think we need to deal with this particular case, since we
don't need to walk the NPT to determine the PFN. The PSC will simply get
forward to userspace, and userspace will (generally):

 for shared->private:
   - deallocate page in shared pool
   - allocate page in private pool
   - issue KVM_MEM_ENCRYPT_REG_REGION on the GFN to switch it to private
     in the KVM xarray and RMP table (and zap current NPT mapping)
   - resume guest
   - guest faults on GFN and KVM MMU sees that it is private and maps the GFN
     to the corresponding PFN in the private pool, which should be reliably
     obtainable since it is pinned

 for private->shared:
   - deallocate page in private pool (which will switch it to shared in
     RMP table so it can be safely released back to host)
   - allocate page in shared pool
   - issue KVM_MEM_ENCRYPT_UNREG_REGION on the GFN to switch it to
     shared in the KVM xarray (and zap current NPT mapping)
   - resume guest
   - guest faults on GFN and KVM MMU sees that it is shared and handles it
     just like it would a normal non-SEV guest, so we don't ever need to
     acquire the specific PFN backing the HVA since they are implicitly
     shared, so no need anymore for kvm_mmu_get_tdp_walk() helper

     (also no need for pre-mapping into TDP via kvm_mmu_map_tdp_page() in
     this case, but not sure that was needed even without UPM, seems more like
     an optimization to avoid a 2nd #NPF. I guess we still have the option with
     UPM though if it seems justified, but it would likely happen in
     {REG,UNREG}_REGION in that case rather than SNP-specific hooks)

There may be some other edge cases to consider, but I'm not aware of any
sequences that aren't clearly misbehavior on the part of userspace/guest,
in which case terminating at the host/guest level seems reasonable.

-Mike

> 
> Thanks,
> Ashish
> 
> > > > 
> > > > > 
> > > > > > 
> > > > > > > an error also terminates the guest immediately with current guest
> > > > > > > implementation. I think the best approach here is adding a retry logic
> > > > > > > to this function. Retrying without returning an error should help it
> > > > > > > work because snp_check_and_build_npt will be called again and in the
> > > > > > > second attempt this should work.
> > > > > > > 
> > > > > > > > > +
> > > > > > > > > +               /*
> > > > > > > > > +                * Adjust the level so that we don't go higher
> > > > > > > > > than the backing
> > > > > > > > > +                * page level.
> > > > > > > > > +                */
> > > > > > > > > +               level = min_t(size_t, level, npt_level);
> > > > > > > > > +
> > > > > > > > > +               trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op,
> > > > > > > > > level);
> > > > > > > > > +
> > > > > > > > > +               switch (op) {
> > > > > > > > > +               case SNP_PAGE_STATE_SHARED:
> > > > > > > > > +                       rc = snp_make_page_shared(kvm, gpa, pfn,
> > > > > > > > > level);
> > > > > > > > > +                       break;
> > > > > > > > > +               case SNP_PAGE_STATE_PRIVATE:
> > > > > > > > > +                       rc = rmp_make_private(pfn, gpa, level,
> > > > > > > > > sev->asid, false);
> > > > > > > > > +                       break;
> > > > > > > > > +               default:
> > > > > > > > > +                       rc = -EINVAL;
> > > > > > > > > +                       break;
> > > > > > > > > +               }
> > > > > > > > > +
> > > > > > > > > +               write_unlock(&kvm->mmu_lock);
> > > > > > > > > +
> > > > > > > > > +               if (rc) {
> > > > > > > > > +                       pr_err_ratelimited("Error op %d gpa %llx
> > > > > > > > > pfn %llx level %d rc %d\n",
> > > > > > > > > +                                          op, gpa, pfn, level, rc);
> > > > > > > > > +                       return rc;
> > > > > > > > > +               }
> > > > > > > > > +
> > > > > > > > > +               gpa = gpa + page_level_size(level);
> > > > > > > > > +       }
> > > > > > > > > +
> > > > > > > > > +       return 0;
> > > > > > > > > +}
> > > > > > > > > +
