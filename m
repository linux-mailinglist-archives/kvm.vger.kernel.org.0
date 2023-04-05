Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37196D7200
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 03:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbjDEBd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 21:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbjDEBd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 21:33:27 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5266530F3;
        Tue,  4 Apr 2023 18:33:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKUKurGwsnc9EdRfrnx0PUMFPwpFc+VxWwMHaN39OUv4sAd6mQNExFe6soh1PLx7oUD9hAqGtQx0aRr63DM4PMvLmotItrry/NajZlxVS4UV8Jp0a+A45yPVdzYWCl9EHicKERI9Fo6cP1PPVFnz07kga0szC/AueX4OOsIapfAC9jz/U6Vd8C21ckk4mX5qZKn9qtWZIDrKLFyjxoRBdrTc4r9Rlyf0B5Ajk+R2wXIttasaDQ9q+kKRqiQKI8q+Us3Ud6xP3BpXPE0oCn7r6WldIKmwT5p8zqexqtGkepzILw+EZGObt0K2jgN8n6kP6HsudWr4e1sFZXJCNBZK2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2H9+8hYvz53XDMhvxtOtnt2jCjSv8kYLRy2LNL4joDk=;
 b=Ti00+s9yD6/jvZKR1Tv44T3xm9Dm3n82TLOVLFKdcKlaPjUaLlxY6cZIV3tKu9vatZ1XaPWxB/1t9T2CFJO+5l51qGaD5xECRgInaYYADLegG885tH1W+t8KT6v45rX0l1UMohud3nUl/VNK+VbJcZMdgSQFdIj1y/ao2RFEZw7X1NUujpDre0v2/g/BusqyryIUFScrdYCSRgU0HYr490ypyrKIVaHl/iJcMLxvx320kUakJ2w04HQArIl2ErlB4HErUCcm16vDu8EUXPhU/0cb+pgGWWkvTgQ+DP4Lc9aG7NPwoxDjHQ4SdyV/SgqZc7pWjxVSbU6ep3C04RqE+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=amazon.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2H9+8hYvz53XDMhvxtOtnt2jCjSv8kYLRy2LNL4joDk=;
 b=wsduntgmVey6MQOPX6KV4aAsUwADnRPyLmVQD7YAQsjO3QjI3aafvLwskGO5P39IrPCF5K5xdtGIn5fF2MPUWdQiSkpsQjmpHDHTk7JwPdzxgZBobAXkO4zkfW92gAAM7rCtQEmg3aamBR2DK2AAh91AgzhN3veHz0ZYt4nkyRw=
Received: from DS7PR03CA0114.namprd03.prod.outlook.com (2603:10b6:5:3b7::29)
 by DS0PR12MB7746.namprd12.prod.outlook.com (2603:10b6:8:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 01:33:08 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::14) by DS7PR03CA0114.outlook.office365.com
 (2603:10b6:5:3b7::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Wed, 5 Apr 2023 01:33:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.14 via Frontend Transport; Wed, 5 Apr 2023 01:33:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 4 Apr
 2023 20:33:07 -0500
Date:   Tue, 4 Apr 2023 19:54:39 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Alexander Graf <graf@amazon.com>
CC:     Zhi Wang <zhi.wang.linux@gmail.com>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 47/56] KVM: SVM: Support SEV-SNP AP Creation NAE
 event
Message-ID: <20230405005439.x636mzqfurwmlsa6@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-48-michael.roth@amd.com>
 <09696af0-b72d-29e7-862b-22ae4a630299@amazon.com>
 <20230228224730.00007d21@intel.com>
 <7eed5a32-6e68-6690-ac45-cec0868b8f5d@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7eed5a32-6e68-6690-ac45-cec0868b8f5d@amazon.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|DS0PR12MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c8b5ab9-9621-44ff-a003-08db3575b60f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RtiyZ6LaZoENkg76z14/Cy9aHrDknMTz08lHpImm+8SG0am8Bq9n1cfHmPRQ4eQT+eqrdl2poiVvuQliyLxcrtuPm41AzOGh6JTvXToa59uM2xvWicD9MjiHJjAd2+CmgJolpQ0kOlwgGaENlQ8izkMxaDu9KUaaIaZy55G6FgmzH/tCEOMRsyGCWX8L/Qx8g6wFByjOILMuwfKtrrbZxNVyuUjtFKirMKhFUgKVrlTTPireU7rPA80PplFfmVYpbYhD7DJTl9LROqAFtsHYlFgSzAxiJ8MKBc6BrEsNvBkPfyehMsPPtbaxBWzySrag6OUHWJ86Wfie47lBl1CuMqcc/AgDJJUDlmySiaxOiPQdEAEWKWWTzoN47CcF1KMcFBizUk1jhEZiuJppufIUlPqlQVzjmyRd5RcRjGIht1dQcPel8MePF4ymVQ/PdUdaXr9tKk5a4wSzxMhx+hmUd7rvYThX8s42vifAAqEZhzArCIrGgQarKZOtblEys2Sah8ql53b5QcEf+6RpyTR6rb4gN3umckbW/83CtfqMKL+DrpY242M0GS0ONnDfEfmRqab30QMFdlTn58qJtTfzbhxQFDLTvvNFmUuadvMDz1mtB1HWQOtLhxRcMsSeuynvnSfrY4AQtyBxHBQHp+W0Bvsw5F0MyxR+wVmLZzlyqj8an9njXqrp6umGzCgRXnorAVAABTwGbmaKzhShV8cxpV0eTNQAILh+PTVrFfUPVAg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199021)(36840700001)(46966006)(40470700004)(2906002)(40480700001)(8936002)(82740400003)(356005)(81166007)(36860700001)(7416002)(7406005)(5660300002)(41300700001)(82310400005)(44832011)(8676002)(6916009)(70206006)(70586007)(4326008)(478600001)(47076005)(40460700003)(316002)(83380400001)(53546011)(1076003)(54906003)(336012)(426003)(26005)(16526019)(6666004)(36756003)(186003)(86362001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 01:33:08.4042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8b5ab9-9621-44ff-a003-08db3575b60f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7746
X-Spam-Status: No, score=1.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 10:14:19PM +0100, Alexander Graf wrote:
> 
> On 28.02.23 21:47, Zhi Wang wrote:
> > On Fri, 24 Feb 2023 13:37:48 +0100
> > Alexander Graf <graf@amazon.com> wrote:
> > 
> > > On 20.02.23 19:38, Michael Roth wrote:
> > > > From: Tom Lendacky <thomas.lendacky@amd.com>
> > > > 
> > > > Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
> > > > guests to alter the register state of the APs on their own. This allows
> > > > the guest a way of simulating INIT-SIPI.

<snip>

> > > > +                */
> > > > +               if (IS_ALIGNED(svm->vmcb->control.exit_info_2, PMD_SIZE)) {
> > > > +                       vcpu_unimpl(vcpu,
> > > > +                                   "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M aligned\n",
> > > > +                                   svm->vmcb->control.exit_info_2);
> > > > +                       ret = -EINVAL;
> > > > +                       goto out;
> > > > +               }
> > > > +
> > > > +               target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
> > > > +               break;
> > > > +       case SVM_VMGEXIT_AP_DESTROY:
> > > 
> > > I don't understand the destroy path. Why does this case destroy anything?
> > > 
> > > 
> > > > +               break;
> > > > +       default:
> > > > +               vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
> > > > +                           request);
> > > > +               ret = -EINVAL;
> > > > +               break;
> > > > +       }
> > > > +
> > > > +out:
> > > > +       if (kick) {
> > > > +               if (target_vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)
> > > > +                       target_vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > > 
> > > What if the guest AP goes through a create -> destroy -> create cycle?
> > > Will it stay runnable while destroyed?
> > The code is not very straightforward.
> > 
> > 1) target_svm->sev_es.snp_vmsa_gpa is set as INVALID_PAGE in the beginning of this function.
> > 
> > 2) If a DESTROY is hit in this function, target_svm->sev_es.snp_vmsa_gpa will be
> > left as INVALID_PAGE.
> > 
> > 3) At the end of this function, it calls kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE).
> > 
> > 4) In the vcpu_enter_guest(), the kvm_vcpu_reset()->sev_snp_init_protected_guest_state()
> > ->__sev_snp_init_protected_guest_state() is called.
> > 
> > 5) The mp_state is set to KVM_MP_STATE_STOPPED by default and the runtime VMSA is
> > cleared. Then the it will be initialized according to the guest's
> > configuration.
> > 
> > 6) As the snp_vmsa_gpa is set as INVALID_PAGE in 1, the mp_state will be left as
> > KVM_MP_STATE_STOPPED.
> > 
> > 7) With this code piece:
> > 
> > +                       kvm_vcpu_reset(vcpu, true);
> > +                       if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
> > +                               goto out;
> > 
> > vcpu_enter_guest() bails out.
> 
> 
> Thanks a lot Zhi for the detailed explanation! I think this code flow wants
> to become slightly more obvious. For example, if we just said
> 
>   case SVM_VMGEXIT_AP_DESTROY:
>     /* This will tell __sev_snp_update_protected_guest_state to unmap the
> VMSA */
>     target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
>     break;
> 
> We'd get a big win in readability with little effort. It makes it
> immediately obvious where to look for the destroy operation.

The target->snp_vmsa_gpa value mainly serves to cache the GPA of the new
VMSA up until the point where KVM points the target vCPU's VMCB over to
using it as part of sev_snp_init_protected_guest_state(). We want to
make sure it is either INVALID_PAGE, or whatever GPA the guest want us
to set it to.

Once sev_snp_init_protected_guest_state() processes the update, it will
set it back to INVALID_PAGE. So if we initialized it once during VM
creation it wouldn't be necessary to keep setting it to INVALID_PAGE at
all, except for one case ...

There is a window where the guest could do an AP_CREATE with new GPA,
followed immediately by AP_DESTROY. If that AP_DESTROY got processed
before the vCPU re-enters the guest, it might instead restart the vCPU
(due to taking VALID_PAGE(snp_vmsa_gpa) branch in
__sev_snp_update_protected_guest_state()). So for that reason it makes
sense to always initialize it to INVALID_PAGE when an AP_CREATION
request comes in, to essentially clear any pending updates from a
previous pending AP_CREATION for the same vCPU. If we move it to the
AP_DESTROY case, but hit a failure elsewhere in sev_snp_ap_creation(),
then the calling vCPU will get a #GP, but the target vCPU might get
set up with the VMSA for the previous pending request. That might be
appropriate though, just because calling vCPU hosed itself doesn't mean
a previous valid AP_CREATION request shouldn't go through for target.
Hmm...

And having said all that... yes, I guess that basically boils down to
INVALID_PAGE being used as an indicator of whether or not to unmap
VMSA. I'll try to come up with some wording to better convey all this
a bit more clearly.

Thanks,

-Mike

> 
> 
> Alex
> 
> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
