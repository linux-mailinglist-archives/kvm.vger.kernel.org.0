Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E08C365F0A
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhDTSME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:12:04 -0400
Received: from mail-bn8nam12on2080.outbound.protection.outlook.com ([40.107.237.80]:49792
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232913AbhDTSMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 14:12:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ7w36WtljEm1LGljOsEJvVsoYNwq06tM/6gyrH5zDl9gI+U+lkxTSNUwSHRWbEQ+sYWlDlnHZnu5ctyhGbavTaxOVQvwpYRm1nSiaVAqDf6uEeP33ow3OCeVuYvQuvrtxmTlwiqTX1aN1t1Wa3WZPHjc0zGwus43RIvvpDzC9BFBNfaWqbzZju0/MJhsKRRjvg3Cixeb8WrIaZsp8WsS8RZ2YaVZKHBxi22barkyTGX4e/UgnLHRqO0U40Q/n2AnP7u5Ds/E/pf408uOfCFydgzXP8VrPDZlIP2P22HYVQckLMQnZHSn2JkSqmEtx9UHEJwGlDONtu62BRYphHZWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyXZwXhrw5jGRXT24CXdCCyGaNt9J2zlN3u0cXxGNMA=;
 b=TSCK0Ha8AHgVkdHpJbfhPGqu/FjSnAWpFpTw88TlIATiTsPemDfZsaoIq3uUcBVsdUrWcZ6iiodUHZBpc2ZbFaXluuYI56lf0Jz9KRkmlMTINJn/50DArXnp9RSIhgZvWCPkUqB/z33kXL5fm7aRR2VMHoDjDNLXSBmzQn1RBmTXCOuf3JO+OVNamG1G/5HkxbTkVWFGJGa6mZdW2BtlbpxpxRiQaanLdxG7WwhdGgayUVHrnQrGM9AcPUTPfOQ+NMzVqOSI5nhfJQDIBfBBzqD+Gej40myW5laZiUHjZqazE3Hw7mD64YY+W2sbh0rdFB+0+31VxyCPPnHQYaJHbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyXZwXhrw5jGRXT24CXdCCyGaNt9J2zlN3u0cXxGNMA=;
 b=3l80IoyTOtt50mPVsb0DX3raP8fc32+R2izfiiyXRalAzAroDd+HDDD00tr+i0vQoSWKCMISon0L/4ScRfgsUe/riKdQ/R0PRfGDzFST3XfFvu0uLlzdF6eMBHHRqTeU865voYyRVvCwaL6CwtLUaZFqJ0gFlb2EUs3HWVCdSmk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 18:11:29 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 18:11:29 +0000
Date:   Tue, 20 Apr 2021 18:11:24 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, srutherford@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        venu.busireddy@oracle.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
Message-ID: <20210420181124.GA12798@ashkalra_ubuntu_server>
References: <20210420112006.741541-1-pbonzini@redhat.com>
 <YH8P26OibEfxvJAu@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH8P26OibEfxvJAu@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:806:130::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR13CA0017.namprd13.prod.outlook.com (2603:10b6:806:130::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Tue, 20 Apr 2021 18:11:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75459c31-66da-4710-0c30-08d90427b882
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2511509D26A1DB8DF20F140E8E489@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qYoZYUgIA4PTJr/Q52mPAySH58669QQutIjMmFtseH4pPO7rWX8l+DF0eON4r+t1Sz54G3dpSXNoWJmSF8IXDTdp3SoirZ3smWtvZIUhf1e6lAB7/nyD/gLeyWlwMBokq9BpT15/j8ltgX89MqUMxMof6ZBPPinUaq3oY08JZKCx7+gW1ZjqRwmxSkHgIaGUXDjdRyYWz0kSr3JcPFWmdFLSZtAeM8Q067ficvEbwMA4TSNk1KBsNBS+BpNKkCcvwCTi3D70ZTyAmN1xJl8ePey3NN4PqX+KwUE9A9hSBr2qCKxQ3khqIfDBgcJlRjbhyrkoEBF5EJsLxex5qruB6QtDe/kN2GUNEj18Ma2ZkWwMQmtDf3htzW0Sr8Jt94KI7UjNvtUEK6P/wOUfV+ldgaHH2A97uMD2MrvtfeTsIgy9lOfiO/JrXe/Uy6a2mBfhDxag751Vj1PjXHw1CB6HLcYmooj7xnS2YhIZDSTn6rfkM/gHn7jcGBcU/5w+N6plEtg4HS6Tftxafs35A88cJ1J7sw8J8sQAeCCUnPiP8m9UiRel48QlqJwlP46Npi6A/yeTkK8yRh9jTdq/3wmkcn+5e9jIFuac4baIwD1P3YDRsL1EBSuO+pb2WLPl6zeMSFZkzvn2AvB4bdZuSva9zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(5660300002)(956004)(66556008)(2906002)(8936002)(55016002)(66476007)(66946007)(6496006)(6916009)(8676002)(9686003)(26005)(54906003)(52116002)(16526019)(316002)(33716001)(7416002)(83380400001)(186003)(478600001)(86362001)(6666004)(38100700002)(38350700002)(33656002)(1076003)(4326008)(53546011)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QyncB0TA8U3sicnUeget0FDL4IY5YZg6AY8OWTN1lWenCYiOiEjRnF0yvOBX?=
 =?us-ascii?Q?MtOPqpFLrKpTvJAqR8AUH8tDGSEDhZOfTwxou1gVZABfHN4fNqhXU0Rhxwvj?=
 =?us-ascii?Q?Rcr5U19QdhKXOYft+tLBiPKMkV/kde1Y8ckkh4WAOnp6an7tLnx38yTSY+qh?=
 =?us-ascii?Q?ZthmuZHV6t2LIyHPO+SWRrfLksiQEPrxEyQJQfNOmLeTJXjvVhVFMx/7HLZs?=
 =?us-ascii?Q?401/auCNvq3ubPuyZZ4MiOTTrgFVEL0GnKGltx61XT6mQKvgN3ocNmXzGSFM?=
 =?us-ascii?Q?qKKqzyyyocsdKDxIDnpdBconu74E3EZaZdvnzzCVMxKXmMGLjb1K0JRYSVPv?=
 =?us-ascii?Q?C0v+Pjkwlz8ZJ4WoePp5txcNj/Jt0pkgL5tkOs1k0RBPZ8MCH4n1YqNOnNn8?=
 =?us-ascii?Q?BrBY4tYwF/zFPAvbkmTBue7arL4W+zi3cANADdxfm/rtctdgUWV32rFmn5YG?=
 =?us-ascii?Q?IYCPVMjGhObjBz/HbzPYNox+1Gol/3coNG5wtCGxhEBuFcUmDnMM0XfDm7VJ?=
 =?us-ascii?Q?dhQPbzloKjEvT7dv2cY1IWeOCpPjpaudG6G1TcSTTnfyDqyRDibupBYtM0Wb?=
 =?us-ascii?Q?GW9hWbKdCAqgbg+PYj+0zpR0WjUVQ1LUSBnelzRHFcPEmaT1IerjpRH0QzlA?=
 =?us-ascii?Q?artC9nKOv2gHRo0T059ZLUYGYF619/4ZB1z1stN183X7hemtlbevpTeDVt8u?=
 =?us-ascii?Q?wiMxgy8UO0SaRPQnfTQ2/hM9biiisazt5KKWriUArQjIh1c9xjmu+JRrWejq?=
 =?us-ascii?Q?Itoqx6ZzhygAlSKkfUTz39e/DlA+RqloVP+k04Fx+6w7puTVNMZZWTUngFRJ?=
 =?us-ascii?Q?yfHW0wID0XwcOxkF1tX9DyOxZy7S7IavOhRBQj/yO/wICvEutNZGdvaAkdds?=
 =?us-ascii?Q?HUGEfwzgNBxNoFxyvtgnDKcFNcyZpTbLlFf3Oe3KBTq7leOI6cpHKlhPV2zq?=
 =?us-ascii?Q?6jYaOhfiP7NsRdn9DiMBd1JTd2AtL0ey2DWX+gwUA/asTr+t5qgkOI+3w6vU?=
 =?us-ascii?Q?Xi897X8LdZafQfrCZcjZ1QoNbOJAffUuD/6DW7KWG8jfPr0wDq5xj8pLDMrY?=
 =?us-ascii?Q?+JS893uhFMjwLij7/Vh2OmAoArRbJUgTi3QDbUK/31BYmQzJaIN8cSOshu1d?=
 =?us-ascii?Q?qKKe0+kmoTzYlFk5LLC/umgW0Su03+UxVqToDABbXMohcgXsgYL0KzVkx3Tq?=
 =?us-ascii?Q?fVkRR3TTCOfjGu4ge/kmJFw//x/DWXvO8YSgaKD5bf6JBEZ0VuGZA1YT34XO?=
 =?us-ascii?Q?EDJIzztlPx1GjTE8eyHTd606RUekJ8ux3UfEYfOF/BUr9/II/IQEAuNT89re?=
 =?us-ascii?Q?3imgicjADnFoEuz+SGOZ7nat?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75459c31-66da-4710-0c30-08d90427b882
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 18:11:29.7001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySVBj8FmdacXfTuZBCPp6vGz3a3lcfJmpq74HOpv2XImNYbfOqsv5se48jxmVswRrqGPZyllRA2kyCQslkDscg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 05:31:07PM +0000, Sean Christopherson wrote:
> On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> > From ef78673f78e3f2eedc498c1fbf9271146caa83cb Mon Sep 17 00:00:00 2001
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > Date: Thu, 15 Apr 2021 15:57:02 +0000
> > Subject: [PATCH 2/3] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
> > 
> > This hypercall is used by the SEV guest to notify a change in the page
> > encryption status to the hypervisor. The hypercall should be invoked
> > only when the encryption attribute is changed from encrypted -> decrypted
> > and vice versa. By default all guest pages are considered encrypted.
> > 
> > The hypercall exits to userspace to manage the guest shared regions and
> > integrate with the userspace VMM's migration code.
> 
> ...
> 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index fd4a84911355..2bc353d1f356 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6766,3 +6766,14 @@ they will get passed on to user space. So user space still has to have
> >  an implementation for these despite the in kernel acceleration.
> >  
> >  This capability is always enabled.
> > +
> > +8.32 KVM_CAP_EXIT_HYPERCALL
> > +---------------------------
> > +
> > +:Capability: KVM_CAP_EXIT_HYPERCALL
> > +:Architectures: x86
> > +:Type: vm
> > +
> > +This capability, if enabled, will cause KVM to exit to userspace
> > +with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
> > +Right now, the only such hypercall is KVM_HC_PAGE_ENC_STATUS.
> > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > index cf62162d4be2..c9378d163b5a 100644
> > --- a/Documentation/virt/kvm/cpuid.rst
> > +++ b/Documentation/virt/kvm/cpuid.rst
> > @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
> >                                                 before using extended destination
> >                                                 ID bits in MSI address bits 11-5.
> >  
> > +KVM_FEATURE_HC_PAGE_ENC_STATUS     16          guest checks this feature bit before
> > +                                               using the page encryption state
> > +                                               hypercall to notify the page state
> > +                                               change
> 
> ...
> 
> >  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned long nr, a0, a1, a2, a3, ret;
> > @@ -8334,6 +8346,28 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  		kvm_sched_yield(vcpu, a0);
> >  		ret = 0;
> >  		break;
> > +	case KVM_HC_PAGE_ENC_STATUS: {
> > +		u64 gpa = a0, npages = a1, enc = a2;
> > +
> > +		ret = -KVM_ENOSYS;
> > +		if (!vcpu->kvm->arch.hypercall_exit_enabled)
> 
> I don't follow, why does the hypercall need to be gated by a capability?  What
> would break if this were changed to?
> 
> 		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
> 

But, the above indicates host support for page_enc_status_hc, so we want
to ensure that host supports and has enabled support for the hypercall
exit, i.e., hypercall has been enabled.

Thanks,
Ashish

> > +			break;
> > +
> > +		if (!PAGE_ALIGNED(gpa) || !npages ||
> > +		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa)) {
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> > +		vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
> > +		vcpu->run->hypercall.args[0]  = gpa;
> > +		vcpu->run->hypercall.args[1]  = npages;
> > +		vcpu->run->hypercall.args[2]  = enc;
> > +		vcpu->run->hypercall.longmode = op_64_bit;
> > +		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> > +		return 0;
> > +	}
> >  	default:
> >  		ret = -KVM_ENOSYS;
> >  		break;
> 
> ...
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 590cc811c99a..d696a9f13e33 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3258,6 +3258,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		vcpu->arch.msr_kvm_poll_control = data;
> >  		break;
> >  
> > +	case MSR_KVM_MIGRATION_CONTROL:
> > +		if (data & ~KVM_PAGE_ENC_STATUS_UPTODATE)
> > +			return 1;
> > +
> > +		if (data && !guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
> 
> Why let the guest write '0'?  Letting the guest do WRMSR but not RDMSR is
> bizarre.
> 
> > +			return 1;
> > +		break;
> > +
> >  	case MSR_IA32_MCG_CTL:
> >  	case MSR_IA32_MCG_STATUS:
> >  	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> > @@ -3549,6 +3557,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
> >  			return 1;
> >  
> > +		msr_info->data = 0;
> > +		break;
> > +	case MSR_KVM_MIGRATION_CONTROL:
> > +		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
> > +			return 1;
> > +
> >  		msr_info->data = 0;
> >  		break;
> >  	case MSR_KVM_STEAL_TIME:
> > -- 
> > 2.26.2
> > 
