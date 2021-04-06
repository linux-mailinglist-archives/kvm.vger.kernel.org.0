Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF613558D5
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346230AbhDFQIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 12:08:15 -0400
Received: from mail-eopbgr680071.outbound.protection.outlook.com ([40.107.68.71]:49817
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244082AbhDFQIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 12:08:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWn+OsMm+njal6Z9JbCKuLJlzrszPbS11HByXCjzbgXya4NqaFtrLDcDH8BpqflBTS8D1KyffX4C04wCLCY9UvwuwPietG1gu4GFCxtPzN7U99R76oAy5WCEgIkEc2vQcvqTxNHlXXcI34bKd7oWOQz4bpFG073p5z9z+QHyh/zwDkLEGvxcCcfYHazgzFsOj4jRMvL+6RTyNiHd4Qib1XeB8yLu6nqAUWNbYIRi5C6Ev3RXvhlz7j8qwWNyu3Ozh8HdYtOSIHRV0aTMaGBGu4tVC9YRgKGjHVr6iX49fVscV9eRdiER51Vv+12HguazkU0N8EfiRCjClBeTSPCN9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFJgsfg2aUPQIHnIGU61YSHJT65rWb5jT0aSR6qbqJo=;
 b=hZEDDHW9ZQQ4JgL5kXkIziLRSFjKyzIZcRnynVT9nkV/QuQ4FAHvie08UVUIyHTlyGRLKln4iYRQam1iSWK8hrbkAcRDju3W0ROhx8Ervnwu93qFtvvWTyihcyVQbyu6BxSbOrHfmhB5+2LPEftrP6B65E88kgg0+Yr69rVYOtFfPpYVptobMb7q/wCnLLMAoDhLRhh7pQ/HJN8+014lUOqEZwpvpcAh3TlUKs0wnw7WH9yVY/LpV4DfMJO77xcpZjMCK5emG2p12ly6w8bL4lrxmrPHW8bIBOJ+uol8d+ybdi705f+SOfKZwf9Ap+Jd8CMOLhMpYwmsPO+ByE95aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFJgsfg2aUPQIHnIGU61YSHJT65rWb5jT0aSR6qbqJo=;
 b=IIiLdZ1/fVjy1ThkBPvLWr2JZBNQOUkOW1WMT9ag9QWXqNrHkQp8oDJHEdhaueSxnWlOV4VhURnmsPi4MQZfB+t44fitDVWW+dLpl3xX7qLx5HRBzXOhynnb1ymQWUVAY6a6j4wCE24fVeEnNweXDvofVOgcqs8kZMxY9DfS9WE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 16:08:04 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 16:08:04 +0000
Date:   Tue, 6 Apr 2021 16:07:58 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com, will@kernel.org,
        maz@kernel.org, qperret@google.com
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20210406160758.GA24313@ashkalra_ubuntu_server>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
 <YGyCxGsC2+GAtJxy@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGyCxGsC2+GAtJxy@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0220.namprd04.prod.outlook.com
 (2603:10b6:806:127::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN7PR04CA0220.namprd04.prod.outlook.com (2603:10b6:806:127::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29 via Frontend Transport; Tue, 6 Apr 2021 16:08:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eabe76e7-ee02-4d98-7eaf-08d8f916289c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB441516E2675B05ACBEA33AEF8E769@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3Iu/yK1pPFIUq9tFXd4xrprHQICg21WvytdqJHaQLnphTlAoGbTv4HspQWfzmrlUw+P2WQpgrNeOyKLf/E377koM52B0PbfXPbrKVsR32X0MxHUR4HsnPDoE3v6QcHUHwG6B9ty6U1lY3PT6lsKrax9DX+NdVtPVrMQ4yY9b4ASf+jNOeitrUuouEBBj9jgFoaOhbgtz+0zgJMGxlMygW/I14bcn91ob6Am5Yc4VHtNcl9f2MZaPNVHV38pX0iB9V7gW6R6nGHUjucQeaqbuuVCH47X3hRxwoeMYeN4nQKi/1x8c++6I5EWk3kpk2e/Zjg3eFVgLCR9Q4VPQ2HDpSjnvwFqJzZjES9eKFR7K5WGrIq/0tM0YfyNdwxtd763xR0UwOrNrePaEoaxxGSwEXR3Bi8YqPKqsOggVQzD+2rqE1WVmfiXxPGjcCPKGFkVnMRYolyT6FjogWYa0EcR950/wnAnDyrAGa7uxUApaF7SnCs62zq2jTLaJyU2PcJf/4O20iHdglaI+ccWOsHKcrxkEhlfdGolgv+Z4RSqteVbCEdvzYGgK+/+wzcUXhGvYUXe0k4QvJTkRqB3j1qYramPnR9tdz0Im/d1/zEI1VMdaiJ0xBX7WNVoeM1dwlPXAY34RjmACgVHzIYym8Q7W03FiDy756bmdGSJElH8SsM2xvTFj3pM/MEq0UT00iC/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39840400004)(376002)(366004)(136003)(396003)(6666004)(316002)(956004)(52116002)(44832011)(86362001)(83380400001)(38100700001)(7416002)(55016002)(16526019)(33716001)(33656002)(26005)(186003)(8936002)(478600001)(4326008)(6916009)(66476007)(9686003)(66556008)(5660300002)(66946007)(6496006)(8676002)(2906002)(1076003)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MpumYa5LAmDoirjP73KodhWePW5WjEuiHVmYHam8CYtCjJIrml66FOQqU4kL?=
 =?us-ascii?Q?JoONR71WM7d0BLfSQBUCDwvuu/MI6pJ0IxQRn2OXRIBd+aqRcbURTicWFNPk?=
 =?us-ascii?Q?Z45qXejVs8G2sVc4GTRfc+aRX25rATdMOhryf0hxUSWlbzWqSSgVMcGmwGHY?=
 =?us-ascii?Q?sNwf/WSAeS454oIvRkIKtR8KDjDPY84FwNSy2fiU8iANp+AXmXUGjSRqVjzT?=
 =?us-ascii?Q?i//zUqgI96ZqorDQgcOwlFGhmIJtcAaI88cnaicvvcd3DZp2tmBNBhq8xv26?=
 =?us-ascii?Q?ZELdC2msqO35XODQCGM5ZlS3gwZ+qzU3/q39VcwT8buMxdH1YihL1RAZLGab?=
 =?us-ascii?Q?Z6Z6qdVq/FLtQc0Qo8cgPiKnktejIRALsKF8WjXKdQLfGKVQDgR/Mb3Q9/qu?=
 =?us-ascii?Q?cFPgZKUqWrqWndG5elNwynS8F200merUIchBybqBRuUurRtDx3cR8Vwr56eL?=
 =?us-ascii?Q?MCw0m01N3+xDAm1Z5Jfn/p3flNsgs3etoeVCwiq9ekdoJdcEcPsoqHsSmRdE?=
 =?us-ascii?Q?uf1BYA5arSddw6V+i50SPd0EpI7seM2l18+KU0yD1/hCl6/P6/s0LzehzW9S?=
 =?us-ascii?Q?9gBhNhsa+VKnvoL4Q0IX/2/EquMxFbDTj2ig2+hCvWEPC11hbOT9VRlqy3Qd?=
 =?us-ascii?Q?+2xAXBSpn5D1aL0KEo1mNwUdo+IanMeiRC8zIqaOk74axKwGKWC567dn4uRT?=
 =?us-ascii?Q?VflFxGyS2BzkYAjRlVrPP/yh6G1x+jSaCjXu0hhiYpHoJMCqYGIYtLU4Nprv?=
 =?us-ascii?Q?3QfFSoCalBf68Lu5RGj9QTzBMtOSLULcuvR9W3jywvjsapqa5UscBGZfXvDf?=
 =?us-ascii?Q?ZwA48jaAle8r0NQuHdgwv8eBxOK98pyk/XJ50ow3d4nQB1Rca11Ia16C81Wp?=
 =?us-ascii?Q?LTx10ekBOIiEH/6Y+Dg1UIuabL3favV7CCN3CnIrcTx0F8Ehb804YOFxJ1AP?=
 =?us-ascii?Q?vTQ/Q5q78CE8OCVzUMVKv2abB08OUqgSfDDqUXmfiyCoGKDawQmIFXQK3dA2?=
 =?us-ascii?Q?pX6yeompVnrvCXMO1/exK9HyMnAs9PuU77ZzjJ7w+1RJl4O0Wt9LxIOK8Y9I?=
 =?us-ascii?Q?bAXEDEi0GdttEqi0h7zQkplEHJ4hV+7qFN0nG2nfCXpcah79S1R/HZZb1i6q?=
 =?us-ascii?Q?K0jzq8zeShJMJ8lnod27sOXNGHxR9Ss31IkqzZ3/IfweTgh69XGOa7vVrCte?=
 =?us-ascii?Q?YHhCwV4pi+iQXlTI39YKwoNIv4trrK0J5uiTHEig/0PjGh0zHxkYekD231aJ?=
 =?us-ascii?Q?NVaVSOMp5Z78aG32+VvuDkKGOYRJ0nApIERFYTcJnomb5bIOL6eYbzB2RbVj?=
 =?us-ascii?Q?WjD1wSHS5gdgstcAgwsTqM1w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eabe76e7-ee02-4d98-7eaf-08d8f916289c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 16:08:04.2204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40yVGtZtW0q2x8PYQbDriutRS1aNviPk9JqN/oE/xyG+w2Y40krRdvq8E4nGSGzdkzR4f8QT0CRe1wf2FD7bTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 03:48:20PM +0000, Sean Christopherson wrote:
> On Mon, Apr 05, 2021, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> 
> ...
> 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3768819693e5..78284ebbbee7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1352,6 +1352,8 @@ struct kvm_x86_ops {
> >  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> >  
> >  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> > +	int (*page_enc_status_hc)(struct kvm_vcpu *vcpu, unsigned long gpa,
> > +				  unsigned long sz, unsigned long mode);
> >  };
> >  
> >  struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index c9795a22e502..fb3a315e5827 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1544,6 +1544,67 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  	return ret;
> >  }
> >  
> > +static int sev_complete_userspace_page_enc_status_hc(struct kvm_vcpu *vcpu)
> > +{
> > +	vcpu->run->exit_reason = 0;
> > +	kvm_rax_write(vcpu, vcpu->run->dma_sharing.ret);
> > +	++vcpu->stat.hypercalls;
> > +	return kvm_skip_emulated_instruction(vcpu);
> > +}
> > +
> > +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> > +			   unsigned long npages, unsigned long enc)
> > +{
> > +	kvm_pfn_t pfn_start, pfn_end;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	gfn_t gfn_start, gfn_end;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -EINVAL;
> > +
> > +	if (!npages)
> > +		return 0;
> 
> Parth of me thinks passing a zero size should be an error not a nop.  Either way
> works, just feels a bit weird to allow this to be a nop.
> 
> > +
> > +	gfn_start = gpa_to_gfn(gpa);
> 
> This should check that @gpa is aligned.
> 
> > +	gfn_end = gfn_start + npages;
> > +
> > +	/* out of bound access error check */
> > +	if (gfn_end <= gfn_start)
> > +		return -EINVAL;
> > +
> > +	/* lets make sure that gpa exist in our memslot */
> > +	pfn_start = gfn_to_pfn(kvm, gfn_start);
> > +	pfn_end = gfn_to_pfn(kvm, gfn_end);
> > +
> > +	if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> > +		/*
> > +		 * Allow guest MMIO range(s) to be added
> > +		 * to the shared pages list.
> > +		 */
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > +		/*
> > +		 * Allow guest MMIO range(s) to be added
> > +		 * to the shared pages list.
> > +		 */
> > +		return -EINVAL;
> > +	}
> 
> I don't think KVM should do any checks beyond gfn_end <= gfn_start.  Just punt
> to userspace and give userspace full say over what is/isn't legal.
> 
> > +
> > +	if (enc)
> > +		vcpu->run->exit_reason = KVM_EXIT_DMA_UNSHARE;
> > +	else
> > +		vcpu->run->exit_reason = KVM_EXIT_DMA_SHARE;
> 
> Use a single exit and pass "enc" via kvm_run.  I also strongly dislike "DMA",
> there's no guarantee the guest is sharing memory for DMA.
> 
> I think we can usurp KVM_EXIT_HYPERCALL for this?  E.g.
> 

I see the following in Documentation/virt/kvm/api.rst :
..
..
/* KVM_EXIT_HYPERCALL */
                struct {
                        __u64 nr;
                        __u64 args[6];
                        __u64 ret;
                        __u32 longmode;
                        __u32 pad;
                } hypercall;

Unused.  This was once used for 'hypercall to userspace'.  To implement
such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).

This mentions this exitcode to be unused and implementing this
functionality using KVM_EXIT_IO for x86?

Thanks,
Ashish

> 	vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> 	vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
> 	vcpu->run->hypercall.args[0]  = gfn_start << PAGE_SHIFT;
> 	vcpu->run->hypercall.args[1]  = npages * PAGE_SIZE;
> 	vcpu->run->hypercall.args[2]  = enc;
> 	vcpu->run->hypercall.longmode = is_64_bit_mode(vcpu);
> 
> > +
> > +	vcpu->run->dma_sharing.addr = gfn_start;
> 
> Addresses and pfns are not the same thing.  If you're passing the size in bytes,
> then it's probably best to pass the gpa, not the gfn.  Same for the params from
> the guest, they should be in the same "domain".
> 
> > +	vcpu->run->dma_sharing.len = npages * PAGE_SIZE;
> > +	vcpu->arch.complete_userspace_io =
> > +		sev_complete_userspace_page_enc_status_hc;
> 
> I vote to drop the "userspace" part, it's already quite verbose.
> 
> 	vcpu->arch.complete_userspace_io = sev_complete_page_enc_status_hc;
> 
> > +
> > +	return 0;
> > +}
> > +
> 
> ..
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f7d12fca397b..ef5c77d59651 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  		kvm_sched_yield(vcpu->kvm, a0);
> >  		ret = 0;
> >  		break;
> > +	case KVM_HC_PAGE_ENC_STATUS: {
> > +		int r;
> > +
> > +		ret = -KVM_ENOSYS;
> > +		if (kvm_x86_ops.page_enc_status_hc) {
> > +			r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
> 
> Use static_call().
> 
> > +			if (r >= 0)
> > +				return r;
> > +			ret = r;
> > +		}
> 
> Hmm, an alternative to adding a kvm_x86_ops hook would be to tag the VM as
> supporting/allowing the hypercall.  That would clean up this code, ensure VMX
> and SVM don't end up creating a different userspace ABI, and make it easier to
> reuse the hypercall in the future (I'm still hopeful :-) ).  E.g.
> 
> 	case KVM_HC_PAGE_ENC_STATUS: {
> 		u64 gpa = a0, nr_bytes = a1;
> 
> 		if (!vcpu->kvm->arch.page_enc_hc_enable)
> 			break;
> 
> 		if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(nr_bytes) ||
> 		    !nr_bytes || gpa + nr_bytes <= gpa)) {
> 			ret = -EINVAL;
> 			break;
> 		}
> 
> 	        vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL; 
>         	vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS; 
> 	        vcpu->run->hypercall.args[0]  = gpa;
>         	vcpu->run->hypercall.args[1]  = nr_bytes;
> 	        vcpu->run->hypercall.args[2]  = enc;                                    
>         	vcpu->run->hypercall.longmode = op_64_bit;
> 		vcpu->arch.complete_userspace_io = complete_page_enc_hc;
> 		return 0;
> 	}
> 
> 
> > +		break;
> > +	}
> >  	default:
> >  		ret = -KVM_ENOSYS;
> >  		break;
