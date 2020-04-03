Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D6019CE71
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 03:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390315AbgDCB6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 21:58:03 -0400
Received: from mail-eopbgr700070.outbound.protection.outlook.com ([40.107.70.70]:64033
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388709AbgDCB6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 21:58:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=it21CaiJ0t8HWOjk38gcWuZP477wdRRATZSnCCNnkEJGjQO+MulfXLJH11/V+QctGKb7kZCLaBomCYSxs0NKWPwiOuHxF8Ic0AQQ8+/XVMKgfQ2T/ws3weOsvblmsNK1EQEwxIDViIvg53Ny2Bpg5GQaM+gTsBURuLIe4UCt1VTDvMLBJqJMZVYsmF4mYoHwbybKKSEDtmeOLoXCh/kFQ2+4tPXFoHt3RsuBKFEM45ayqrSBvlAhVMFZ/N7TLE5+nV4x9NFEC6ZAdJX9zPn6ZufrkuDsbT/bGnVf3ajUDQ5pby1HDAAaZVnKZMnHUFWkLw7IZsn6cXdG6Z0B9QWOjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIxz9uVDihdZb/s/5lJbB1qjPyC7XmvigE7jVUOMpvQ=;
 b=G2m85XtotfLAs4OYjaw5983Byls5ilp1evBgCshBdElqCUsrHWUb5025B3Fr1cIdayIJzBoFMy6JljfBTTV8o/WihDabgFVOUQuFIGHc7wixwGVL80iS8PjT9R8DQy6+tUDR4QD1vb/azr289Q7+5Jpw/Y3r2qSDxk2FmdmPQ9nHsxZFsL9mvm2ZSYznCZ+VPY7cOvKlhWp+KAOWrCcM7ChuW3gYxoblv0WA7t/Y1FimlRBpSBx+8EKzSNXc3PJd2GAvtrIIZ/ftwUxlq2jQJGg5MbVq3nBWbEiUU7QQ6X6EOWJxQ3VuCnNhwrNRrGqIRXhi9FEKzXhL+IDTcFXuHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIxz9uVDihdZb/s/5lJbB1qjPyC7XmvigE7jVUOMpvQ=;
 b=nrbVUs8J0DymDUnVI1EDdocmpk9fe3C7bQD0rWuQoHfTI549uVzKltYRtrCNaE7oTJKWoc57vZLCxHicOJDoiyI1k7LXVB57/gKayYsegAlO+ra6TflCfvD4WkWA7Faqq+UZVA9CTPm0FS6j2X3RhY2VuMVf5fHtGPhc9lFK7oQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1226.namprd12.prod.outlook.com (2603:10b6:3:75::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Fri, 3 Apr 2020 01:57:54 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.017; Fri, 3 Apr 2020
 01:57:54 +0000
Date:   Fri, 3 Apr 2020 01:57:48 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 08/14] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20200403015748.GA26677@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
 <8d1baef8-c5ea-e8ac-0a9c-097aa20ea7aa@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d1baef8-c5ea-e8ac-0a9c-097aa20ea7aa@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN4PR0501CA0006.namprd05.prod.outlook.com
 (2603:10b6:803:40::19) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0006.namprd05.prod.outlook.com (2603:10b6:803:40::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.6 via Frontend Transport; Fri, 3 Apr 2020 01:57:53 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6b4addc-9d5c-4bf0-9d65-08d7d7726c41
X-MS-TrafficTypeDiagnostic: DM5PR12MB1226:|DM5PR12MB1226:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1226ECF15608646EEDD1A8248EC70@DM5PR12MB1226.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(53546011)(66946007)(5660300002)(66556008)(16526019)(6496006)(8676002)(86362001)(4326008)(33656002)(66476007)(186003)(6666004)(26005)(2906002)(6916009)(9686003)(1076003)(52116002)(316002)(44832011)(81156014)(956004)(66574012)(8936002)(33716001)(55016002)(7416002)(478600001)(81166006);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jCXV3C+c5F2hnB7ycL/QO3Hchi+dwX5beAibZrs9oc/0y9jiFT0fR6QZqJ+C4FLcLtfcH3hbpv/GyUs6krL0cRahEuXG8KnN/LMLullVLQ/aRs7PM2yWEE1BZ+384HVhpxFsC1SnGVIiSmwH5rafCT2giKzc/cnziwAJdn9XuK/ZQfdO+5E0B5G88j3nWvmdczyGudeJIfYhbB3aShc01fUt+IkcyrjOxlJiJKPC+U+elbjZzD8+mCSdb09hj8hXV3iFyPnm8QTCs5PB9UcXo4DpFC5bJiESQ9UFWTCWZCcDe4lIos+SLs7fIn6WJnM/JHdgpEcgVuOi2wjvikXWx5XFHEQ25VZQg9TXGT3HACLO26w6/lk1lb2yEnJL9t5NDInf3ekhdbe9P0RFvtb/vzOcix1fpRFPboHiq92SMHpBaSQPbko6w+/jJ1cKT0v
X-MS-Exchange-AntiSpam-MessageData: XuWBiP6LRHTIW4NcPeDd9lBn6vH+bue/zEEsgZVfGOsmatJDHgSaE/ovSCDlgAt39QJUK/QY6YDSOXfbndnFC7JGOFWe32obZrcHqRmCN2R0qZ9sN6HEjIW48HccT+iDgZG7HzHQpBa22arAWRl+Lg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b4addc-9d5c-4bf0-9d65-08d7d7726c41
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 01:57:54.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ceab1sUknoJ10o7vnmXVTCzcjb6mAXU2YCxmkVWL4FRw9hunqFSSSBZY6/ArYbPAZOyior1yCGJLZNqnhnmTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1226
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 06:31:54PM -0700, Krish Sadhukhan wrote:
> 
> On 3/29/20 11:22 PM, Ashish Kalra wrote:
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > 
> > This hypercall is used by the SEV guest to notify a change in the page
> > encryption status to the hypervisor. The hypercall should be invoked
> > only when the encryption attribute is changed from encrypted -> decrypted
> > and vice versa. By default all guest pages are considered encrypted.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >   Documentation/virt/kvm/hypercalls.rst | 15 +++++
> >   arch/x86/include/asm/kvm_host.h       |  2 +
> >   arch/x86/kvm/svm.c                    | 95 +++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/vmx.c                |  1 +
> >   arch/x86/kvm/x86.c                    |  6 ++
> >   include/uapi/linux/kvm_para.h         |  1 +
> >   6 files changed, 120 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> > index dbaf207e560d..ff5287e68e81 100644
> > --- a/Documentation/virt/kvm/hypercalls.rst
> > +++ b/Documentation/virt/kvm/hypercalls.rst
> > @@ -169,3 +169,18 @@ a0: destination APIC ID
> >   :Usage example: When sending a call-function IPI-many to vCPUs, yield if
> >   	        any of the IPI target vCPUs was preempted.
> > +
> > +
> > +8. KVM_HC_PAGE_ENC_STATUS
> > +-------------------------
> > +:Architecture: x86
> > +:Status: active
> > +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> > +
> > +a0: the guest physical address of the start page
> > +a1: the number of pages
> > +a2: encryption attribute
> > +
> > +   Where:
> > +	* 1: Encryption attribute is set
> > +	* 0: Encryption attribute is cleared
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 98959e8cd448..90718fa3db47 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
> >   	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> >   	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> > +	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > +				  unsigned long sz, unsigned long mode);
> >   };
> >   struct kvm_arch_async_pf {
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 7c2721e18b06..1d8beaf1bceb 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -136,6 +136,8 @@ struct kvm_sev_info {
> >   	int fd;			/* SEV device fd */
> >   	unsigned long pages_locked; /* Number of pages locked */
> >   	struct list_head regions_list;  /* List of registered regions */
> > +	unsigned long *page_enc_bmap;
> > +	unsigned long page_enc_bmap_size;
> >   };
> >   struct kvm_svm {
> > @@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm *kvm)
> >   	sev_unbind_asid(kvm, sev->handle);
> >   	sev_asid_free(sev->asid);
> > +
> > +	kvfree(sev->page_enc_bmap);
> > +	sev->page_enc_bmap = NULL;
> >   }
> >   static void avic_vm_destroy(struct kvm *kvm)
> > @@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >   	return ret;
> >   }
> > +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	unsigned long *map;
> > +	unsigned long sz;
> > +
> > +	if (sev->page_enc_bmap_size >= new_size)
> > +		return 0;
> > +
> > +	sz = ALIGN(new_size, BITS_PER_LONG) / 8;
> > +
> > +	map = vmalloc(sz);
> 
> 
> Just wondering why we can't directly modify sev->page_enc_bmap.
> 

Because the page_enc_bitmap needs to be re-sized here, it needs to be
expanded here. 

> > +	if (!map) {
> > +		pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
> > +				sz);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* mark the page encrypted (by default) */
> > +	memset(map, 0xff, sz);
> > +
> > +	bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
> > +	kvfree(sev->page_enc_bmap);
> > +
> > +	sev->page_enc_bmap = map;
> > +	sev->page_enc_bmap_size = new_size;
> > +
> > +	return 0;
> > +}
> > +
> > +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > +				  unsigned long npages, unsigned long enc)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	kvm_pfn_t pfn_start, pfn_end;
> > +	gfn_t gfn_start, gfn_end;
> > +	int ret;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -EINVAL;
> > +
> > +	if (!npages)
> > +		return 0;
> > +
> > +	gfn_start = gpa_to_gfn(gpa);
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
> > +		 * to the page encryption bitmap.
> > +		 */
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > +		/*
> > +		 * Allow guest MMIO range(s) to be added
> > +		 * to the page encryption bitmap.
> > +		 */
> > +		return -EINVAL;
> > +	}
> 
> 
> It seems is_error_noslot_pfn() covers both cases - i) gfn slot is absent,
> ii) failure to translate to pfn. So do we still need is_noslot_pfn() ?
>

We do need to check for !is_noslot_pfn(..) additionally as the MMIO ranges will not
be having a slot allocated.

Thanks,
Ashish

> > +
> > +	mutex_lock(&kvm->lock);
> > +	ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	if (enc)
> > +		__bitmap_set(sev->page_enc_bmap, gfn_start,
> > +				gfn_end - gfn_start);
> > +	else
> > +		__bitmap_clear(sev->page_enc_bmap, gfn_start,
> > +				gfn_end - gfn_start);
> > +
> > +unlock:
> > +	mutex_unlock(&kvm->lock);
> > +	return ret;
> > +}
> > +
> >   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >   {
> >   	struct kvm_sev_cmd sev_cmd;
> > @@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >   	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> >   	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> > +
> > +	.page_enc_status_hc = svm_page_enc_status_hc,
> 
> 
> Why not place it where other encryption ops are located ?
> 
>         ...
> 
>         .mem_enc_unreg_region
> 
> +      .page_enc_status_hc = svm_page_enc_status_hc
> 
> >   };
> >   static int __init svm_init(void)
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 079d9fbf278e..f68e76ee7f9c 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >   	.nested_get_evmcs_version = NULL,
> >   	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> >   	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> > +	.page_enc_status_hc = NULL,
> >   };
> >   static void vmx_cleanup_l1d_flush(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index cf95c36cb4f4..68428eef2dde 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >   		kvm_sched_yield(vcpu->kvm, a0);
> >   		ret = 0;
> >   		break;
> > +	case KVM_HC_PAGE_ENC_STATUS:
> > +		ret = -KVM_ENOSYS;
> > +		if (kvm_x86_ops->page_enc_status_hc)
> > +			ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
> > +					a0, a1, a2);
> > +		break;
> >   	default:
> >   		ret = -KVM_ENOSYS;
> >   		break;
> > diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> > index 8b86609849b9..847b83b75dc8 100644
> > --- a/include/uapi/linux/kvm_para.h
> > +++ b/include/uapi/linux/kvm_para.h
> > @@ -29,6 +29,7 @@
> >   #define KVM_HC_CLOCK_PAIRING		9
> >   #define KVM_HC_SEND_IPI		10
> >   #define KVM_HC_SCHED_YIELD		11
> > +#define KVM_HC_PAGE_ENC_STATUS		12
> >   /*
> >    * hypercalls use architecture specific
