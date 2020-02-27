Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF141728C7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 20:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgB0TiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 14:38:19 -0500
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:23110
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727159AbgB0TiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 14:38:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W88gyFVdBtq5e4hCF2UleLhDYCShEEO7iH3OfGTcqPWHuBeAZX5u2H/F3Sw2Me7myuz8/tEF5lvhlj/EQnqnlHV8cgWWw8XE1nPuqQ0h0+LQXM6iR0NEdctlHlDRbjNBYNSal9ZSuNHlSp5GDIOg6Usb0i34OdgSQou8h9n2t33x19IfZSt2j7RSburRbWbivO19h690zCPXKurxwmOn/rHRyRCI/1h7Q0oJoBts3zinw+eQnprNJk2OQ2vdjbRaFy4en6nNFsPcKKLs2PJi+1yndtBIUyLcK/z7RYVlJa4jhsd+GPvlTv38s00NsFznc5Y4VihifWMZ+pW0fpdbFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oFG1WsyG0CJaLGKlhjfgyQUYMHRQg1ihWMrz2eIn8U=;
 b=jMv2hOvTNWlPvRIobvb2TyzeoxNLgsjoBo3V1sXMO/PbETPEMol9kBj44oDIXK/fVptaTex2U7pOQbOp08TKSAnazMDHJyJ/ezA4X8KSw5eiJsHI8jJOap+wO7t3AMV86YI0DZQ+5KkTZr7YGwuqpEB7aWZ8C5Szlqx000uZCtK7V6qZZa31ryIfdBoQVZv27l75ZuDEDV21ujkVcwlivhHgpYWWUfuwC4oaDK8JrhKJRo3ljH2ILWKJkAi7fJA0IlaU2qOmf/wOsw7LRieZbeGjx7aut+VT6qpNZuu4sSp8U3GVxkU6UPr0PtWC2S0ZML2vuxrTuILt5nEnda13Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oFG1WsyG0CJaLGKlhjfgyQUYMHRQg1ihWMrz2eIn8U=;
 b=n/hUk2vJrV+W4dj48+GFqKTwUapQkFlF/Z1nRILtrk0Dbm/1tHqKt8mGsG1BzOpYGzG6nrrrfSobIAKXZxdXE2EAAojgIUjQIyDBZ1k5UsfdaHjRic9ilmcY21GdzVek0f+DfmC4dh6f0d/e+ZPhjobDmnA0+9noE7K86CkKK2g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33)
 by SN1PR12MB2382.namprd12.prod.outlook.com (2603:10b6:802:2e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Thu, 27 Feb
 2020 19:38:15 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::7015:3d60:8f9b:5dad]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::7015:3d60:8f9b:5dad%6]) with mapi id 15.20.2772.012; Thu, 27 Feb 2020
 19:38:15 +0000
Date:   Thu, 27 Feb 2020 19:38:09 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Message-ID: <20200227193808.GA19871@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <efe6a4d829af0b2ed9fe1b58fd2dfb343f5b8de0.1581555616.git.ashish.kalra@amd.com>
 <20200227175748.GA268253@vbusired-dt>
 <20200227181858.GA268538@vbusired-dt>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200227181858.GA268538@vbusired-dt>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR12CA0060.namprd12.prod.outlook.com
 (2603:10b6:3:103::22) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR12CA0060.namprd12.prod.outlook.com (2603:10b6:3:103::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Thu, 27 Feb 2020 19:38:13 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 65071a87-4cf1-454e-6075-08d7bbbc9661
X-MS-TrafficTypeDiagnostic: SN1PR12MB2382:|SN1PR12MB2382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23828626E9B742BF0EA6EC278EEB0@SN1PR12MB2382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 03264AEA72
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(366004)(376002)(346002)(199004)(189003)(33716001)(55016002)(86362001)(2906002)(6916009)(956004)(6496006)(44832011)(33656002)(66946007)(9686003)(66556008)(66476007)(81156014)(81166006)(1076003)(8676002)(7416002)(66574012)(186003)(4326008)(26005)(52116002)(6666004)(316002)(53546011)(5660300002)(478600001)(16526019)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2382;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KtPNa+pEj+jmmZK59/BSosp8yAzkRGWM/cMAG0PHxKvtvlTRv7hwMEBa1MdMl/8pWwXvyJBnX0XJajYbN6d0JUPCnYo+3JtfiCE46FuDUaZm1Q7ctAjTNjrKEewQVYyo1wZKGDVlGDGUhWGSMhQdoKDqECTbwTtnC86VPpvbj84U1mnMpnD+mrRvsAlXYDcnFsv/HsiH27+MvoNI0mGkbS11EnGLAivp0bFVWggMJDgYPz4a73B+XeCIvhua2Jf589p4fd8iN9ybbUVsox7Q8iSYTG9M2/kltzTq0/r0I7FuC3HwSMh7bz7IC2rmHYrMNNy5h/fBpOYJuzcNo/qhrGn5tGgfb2r22ZNzyLcS2MxWbON3n8TgtZ0mEWeNgPxBPVRFGz8SH6YO0g9wXZAWpJ7a9Xyrteqq2fdt8ZLc9KfnkluXt5+I0KkjxlkAV8Iy
X-MS-Exchange-AntiSpam-MessageData: toz4wzwjWtw8u87sK4MU7/ECJQvG5aWU8GkCDDnBFKZEvNuJOOe+/2jPYBh5Q/LdGxbdmA9YJL4KPUZiCO80EyRXSGeLc6kjeyLqLfWFPlzgJn/IvAWtu/UeLR/LQz/rMEXI3CWEPOnqgKexDq+G8A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65071a87-4cf1-454e-6075-08d7bbbc9661
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2020 19:38:15.0322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JcmO26zzQGlQKQuJ2EKoPZAqxrjSaAVSjrqOiGMGW4uxOs5DyLTEhBRGD/ZKVx3O+wegI2ipNEEg6jVc/Ex1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2382
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The patch series should apply to tag v5.6-rc1.

I will be posting the v5 of this patchset next week, which should
apply on top of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git.

Thanks,
Ashish

On Thu, Feb 27, 2020 at 12:18:58PM -0600, Venu Busireddy wrote:
> On 2020-02-27 11:57:50 -0600, Venu Busireddy wrote:
> > On 2020-02-13 01:17:45 +0000, Ashish Kalra wrote:
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > 
> > > The ioctl can be used to retrieve page encryption bitmap for a given
> > > gfn range.
> > > 
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > > Cc: Joerg Roedel <joro@8bytes.org>
> > > Cc: Borislav Petkov <bp@suse.de>
> > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: x86@kernel.org
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > This patch does not apply to upstream Linux version 5.5.6.
> > 
> >   <snip>
> >   Applying: KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
> >   error: patch failed: Documentation/virt/kvm/api.txt:4213
> >   error: Documentation/virt/kvm/api.txt: patch does not apply
> >   error: patch failed: include/uapi/linux/kvm.h:1478
> >   error: include/uapi/linux/kvm.h: patch does not apply
> >   Patch failed at 0009 KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
> >   <snip>
> > 
> > Which kernel version does this patch series apply to, cleanly?
> 
> Tried git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git.
> With that, patch 08/12 fails with the top of that tree, as well as
> tag v5.6-rc3.
> 
> > Thanks,
> > 
> > Venu
> > 
> > > ---
> > >  Documentation/virt/kvm/api.txt  | 27 +++++++++++++++++++++
> > >  arch/x86/include/asm/kvm_host.h |  2 ++
> > >  arch/x86/kvm/svm.c              | 43 +++++++++++++++++++++++++++++++++
> > >  arch/x86/kvm/x86.c              | 12 +++++++++
> > >  include/uapi/linux/kvm.h        | 12 +++++++++
> > >  5 files changed, 96 insertions(+)
> > > 
> > > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > > index c6e1ce5d40de..053aecfabe74 100644
> > > --- a/Documentation/virt/kvm/api.txt
> > > +++ b/Documentation/virt/kvm/api.txt
> > > @@ -4213,6 +4213,33 @@ the clear cpu reset definition in the POP. However, the cpu is not put
> > >  into ESA mode. This reset is a superset of the initial reset.
> > >  
> > >  
> > > +4.120 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
> > > +
> > > +Capability: basic
> > > +Architectures: x86
> > > +Type: vm ioctl
> > > +Parameters: struct kvm_page_enc_bitmap (in/out)
> > > +Returns: 0 on success, -1 on error
> > > +
> > > +/* for KVM_GET_PAGE_ENC_BITMAP */
> > > +struct kvm_page_enc_bitmap {
> > > +	__u64 start_gfn;
> > > +	__u64 num_pages;
> > > +	union {
> > > +		void __user *enc_bitmap; /* one bit per page */
> > > +		__u64 padding2;
> > > +	};
> > > +};
> > > +
> > > +The encrypted VMs have concept of private and shared pages. The private
> > > +page is encrypted with the guest-specific key, while shared page may
> > > +be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
> > > +be used to get the bitmap indicating whether the guest page is private
> > > +or shared. The bitmap can be used during the guest migration, if the page
> > > +is private then userspace need to use SEV migration commands to transmit
> > > +the page.
> > > +
> > > +
> > >  5. The kvm_run structure
> > >  ------------------------
> > >  
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 4ae7293033b2..a6882c5214b4 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1258,6 +1258,8 @@ struct kvm_x86_ops {
> > >  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> > >  	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > >  				  unsigned long sz, unsigned long mode);
> > > +	int (*get_page_enc_bitmap)(struct kvm *kvm,
> > > +				struct kvm_page_enc_bitmap *bmap);
> > >  };
> > >  
> > >  struct kvm_arch_async_pf {
> > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > index f09791109075..f1c8806a97c6 100644
> > > --- a/arch/x86/kvm/svm.c
> > > +++ b/arch/x86/kvm/svm.c
> > > @@ -7673,6 +7673,48 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > >  	return ret;
> > >  }
> > >  
> > > +static int svm_get_page_enc_bitmap(struct kvm *kvm,
> > > +				   struct kvm_page_enc_bitmap *bmap)
> > > +{
> > > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > +	unsigned long gfn_start, gfn_end;
> > > +	unsigned long *bitmap;
> > > +	unsigned long sz, i;
> > > +	int ret;
> > > +
> > > +	if (!sev_guest(kvm))
> > > +		return -ENOTTY;
> > > +
> > > +	gfn_start = bmap->start_gfn;
> > > +	gfn_end = gfn_start + bmap->num_pages;
> > > +
> > > +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
> > > +	bitmap = kmalloc(sz, GFP_KERNEL);
> > > +	if (!bitmap)
> > > +		return -ENOMEM;
> > > +
> > > +	/* by default all pages are marked encrypted */
> > > +	memset(bitmap, 0xff, sz);
> > > +
> > > +	mutex_lock(&kvm->lock);
> > > +	if (sev->page_enc_bmap) {
> > > +		i = gfn_start;
> > > +		for_each_clear_bit_from(i, sev->page_enc_bmap,
> > > +				      min(sev->page_enc_bmap_size, gfn_end))
> > > +			clear_bit(i - gfn_start, bitmap);
> > > +	}
> > > +	mutex_unlock(&kvm->lock);
> > > +
> > > +	ret = -EFAULT;
> > > +	if (copy_to_user(bmap->enc_bitmap, bitmap, sz))
> > > +		goto out;
> > > +
> > > +	ret = 0;
> > > +out:
> > > +	kfree(bitmap);
> > > +	return ret;
> > > +}
> > > +
> > >  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > >  {
> > >  	struct kvm_sev_cmd sev_cmd;
> > > @@ -8066,6 +8108,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> > >  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> > >  
> > >  	.page_enc_status_hc = svm_page_enc_status_hc,
> > > +	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
> > >  };
> > >  
> > >  static int __init svm_init(void)
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 298627fa3d39..e955f886ee17 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -5213,6 +5213,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
> > >  	case KVM_SET_PMU_EVENT_FILTER:
> > >  		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
> > >  		break;
> > > +	case KVM_GET_PAGE_ENC_BITMAP: {
> > > +		struct kvm_page_enc_bitmap bitmap;
> > > +
> > > +		r = -EFAULT;
> > > +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> > > +			goto out;
> > > +
> > > +		r = -ENOTTY;
> > > +		if (kvm_x86_ops->get_page_enc_bitmap)
> > > +			r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
> > > +		break;
> > > +	}
> > >  	default:
> > >  		r = -ENOTTY;
> > >  	}
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index 4e80c57a3182..9377b26c5f4e 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -500,6 +500,16 @@ struct kvm_dirty_log {
> > >  	};
> > >  };
> > >  
> > > +/* for KVM_GET_PAGE_ENC_BITMAP */
> > > +struct kvm_page_enc_bitmap {
> > > +	__u64 start_gfn;
> > > +	__u64 num_pages;
> > > +	union {
> > > +		void __user *enc_bitmap; /* one bit per page */
> > > +		__u64 padding2;
> > > +	};
> > > +};
> > > +
> > >  /* for KVM_CLEAR_DIRTY_LOG */
> > >  struct kvm_clear_dirty_log {
> > >  	__u32 slot;
> > > @@ -1478,6 +1488,8 @@ struct kvm_enc_region {
> > >  #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
> > >  #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
> > >  
> > > +#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc2, struct kvm_page_enc_bitmap)
> > > +
> > >  /* Secure Encrypted Virtualization command */
> > >  enum sev_cmd_id {
> > >  	/* Guest initialization commands */
> > > -- 
> > > 2.17.1
> > > 
