Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6771219DFC4
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 22:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgDCUru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 16:47:50 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:52416
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbgDCUru (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 16:47:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1miY3ezRgtb2GBBHi8+AJ49wxrsxRKveltPmFSgJs9SI5IbECU2x0wA2U14Uklsudv+dpqKurp17XrUrATduFqVfUQlp7+viRoGciYZDRapkmKYclJqdm1sjEUtDuHwHWegQVkOaI/vQFc8ig9eZjs/puvk3kacXWQCaekk7VeyQftKKOTvGluEpSpsgB9d9MqJh9IIjzu7Q5WaOLjMIjES7iA+UN4Ww+wgyNHie2Et0PpcDbWrlbmB0cQcrOun9SBUZ/kKZZ7mt/7Cz8fRu3M4ALjZoFdfc53/LAMCw4JHW2dqXhkN6eAzDD6GRw17N0Y/cpDA2NqN0BcGMKFAXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0yShZZqS3ig+9P83cMBawyVNi4rJKSPYw7X8mQyzFQ=;
 b=fbFrlCPJkI5T8zkQEhHzWCOyw+bXWalaihEMf0zcwlZRSuikuqfJMXojkTETIauY+DnObAj1gh8BAEyoZPrsH5cgg635EdLXY7UbC6aUZY/UKYVzE6OoibCz2JqVhgVNEZ2A29g3gyQsvNPH/2pMybYePRZ4XGWl7zcLPbLp1tNqdadywgL5Onwjj7MPxP3dOvgS9fDcRHJir2LLpKIgobK9V9A3K6ruEa2cnSXo/zMYpK4KNCSg14P7JLSr2rT04v8Paj+bgNi92BDe0p9sYKoY8u0EzZgJGtZX+bHpZRa9VyI5RmDMdBkKK8aNaKXyS5KZ3EV4o5gICibyqqqXuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0yShZZqS3ig+9P83cMBawyVNi4rJKSPYw7X8mQyzFQ=;
 b=3m4yPP/T8mXraoazfGk/AWgLJ6jzvzNIrtGAyX1PDnm+C1PJVjS5/T/av9oUPGj+nPZR3eHMLD3ThERBQ41aCSf8dR3q2BFkoKf7QjAcWz9lVToZsSH05amv3GfmmmypEF3as8ZzVL4oKTkaYKq+/rfPmXpZqTMpMo5iZIokZnc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1898.namprd12.prod.outlook.com (2603:10b6:3:10d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.16; Fri, 3 Apr 2020 20:47:41 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.017; Fri, 3 Apr 2020
 20:47:40 +0000
Date:   Fri, 3 Apr 2020 20:47:34 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 09/14] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Message-ID: <20200403204734.GA28542@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <388afbf3af3a10cc3101008bc9381491cc7aab2f.1585548051.git.ashish.kalra@amd.com>
 <88185cd3-a9f4-68a8-9c34-2e72deaf3d8d@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88185cd3-a9f4-68a8-9c34-2e72deaf3d8d@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN4PR0201CA0034.namprd02.prod.outlook.com
 (2603:10b6:803:2e::20) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0201CA0034.namprd02.prod.outlook.com (2603:10b6:803:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Fri, 3 Apr 2020 20:47:39 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 66e189d3-d36b-4ab9-f640-08d7d810402a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1898:|DM5PR12MB1898:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18989F7714E20968CCB8B9FF8EC70@DM5PR12MB1898.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(8676002)(33716001)(186003)(44832011)(53546011)(6916009)(6496006)(52116002)(33656002)(956004)(478600001)(6666004)(66556008)(66946007)(66476007)(7416002)(5660300002)(16526019)(316002)(1076003)(81156014)(4326008)(9686003)(86362001)(55016002)(26005)(2906002)(66574012)(8936002)(81166006);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hV4mKea96MliomVdi44AX8tvuxLeCrsDdyImWUiaWuHtx2KRR4k8g0OkGQW7arpXzye4E8tPonNO5qVfahggbBk0hHNP8/MESoXD7o5jZ2QvESquShNIHbpvnpvWlfbqWJHZbZFXJ8EzwJozafMhvoh7iyRJ5TvGh0gBp7aqStSzqjJn1P46W0NcJsqkr7fUJT87nOJxFKSJH9D9XB5k4De130mVdqwcFfKGWKEgiYgrC2H06+xXT+nfK3EXS+61yZFRKXttEOSVwNC3KTSlna4uru+017evQDean1jQO9PsX0RsSDuySVr23kCERCDkd/gF1JIt7I2o61KoIiG5d+19N8Y2B8K6ZT9JzU0I2zOQ798/ocFoAKrXdxMLMJ383fef0LQpOInFGQhoCrLNbJFphjx80AKkrBqgSCLD/vuYV2KXvMqWLzAC2QXAg6cZ
X-MS-Exchange-AntiSpam-MessageData: 9LSCM7HGd+ZF5xGykhCB2vnnLkmSjba2+9Pk2xnUEQT2OsIbLFKQU/ZacJelmD6n68ijp1KeD+wjAcnUoK24Rwy1XnWsgDmu4roFLcAyKfD4NsMi8JvFBO5C4MXnHOXAJ33nKZz0UYcmgFjr+evG/g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e189d3-d36b-4ab9-f640-08d7d810402a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 20:47:40.7426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 41m3m83SPv3D487lmQnnXPDZes84+1u0PCDphT1pbUSTzhA0O5koAJPJ1nkes9NVH8/cg3BL3ts3FH75cbdy4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1898
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 03, 2020 at 01:18:52PM -0700, Krish Sadhukhan wrote:
> 
> On 3/29/20 11:22 PM, Ashish Kalra wrote:
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > 
> > The ioctl can be used to retrieve page encryption bitmap for a given
> > gfn range.
> > 
> > Return the correct bitmap as per the number of pages being requested
> > by the user. Ensure that we only copy bmap->num_pages bytes in the
> > userspace buffer, if bmap->num_pages is not byte aligned we read
> > the trailing bits from the userspace and copy those bits as is.
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
> >   Documentation/virt/kvm/api.rst  | 27 +++++++++++++
> >   arch/x86/include/asm/kvm_host.h |  2 +
> >   arch/x86/kvm/svm.c              | 71 +++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/x86.c              | 12 ++++++
> >   include/uapi/linux/kvm.h        | 12 ++++++
> >   5 files changed, 124 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index ebd383fba939..8ad800ebb54f 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -4648,6 +4648,33 @@ This ioctl resets VCPU registers and control structures according to
> >   the clear cpu reset definition in the POP. However, the cpu is not put
> >   into ESA mode. This reset is a superset of the initial reset.
> > +4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
> > +---------------------------------------
> > +
> > +:Capability: basic
> > +:Architectures: x86
> > +:Type: vm ioctl
> > +:Parameters: struct kvm_page_enc_bitmap (in/out)
> > +:Returns: 0 on success, -1 on error
> > +
> > +/* for KVM_GET_PAGE_ENC_BITMAP */
> > +struct kvm_page_enc_bitmap {
> > +	__u64 start_gfn;
> > +	__u64 num_pages;
> > +	union {
> > +		void __user *enc_bitmap; /* one bit per page */
> > +		__u64 padding2;
> > +	};
> > +};
> > +
> > +The encrypted VMs have concept of private and shared pages. The private
> > +page is encrypted with the guest-specific key, while shared page may
> > +be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
> > +be used to get the bitmap indicating whether the guest page is private
> > +or shared. The bitmap can be used during the guest migration, if the page
> > +is private then userspace need to use SEV migration commands to transmit
> > +the page.
> > +
> >   5. The kvm_run structure
> >   ========================
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 90718fa3db47..27e43e3ec9d8 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1269,6 +1269,8 @@ struct kvm_x86_ops {
> >   	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> >   	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> >   				  unsigned long sz, unsigned long mode);
> > +	int (*get_page_enc_bitmap)(struct kvm *kvm,
> > +				struct kvm_page_enc_bitmap *bmap);
> 
> 
> Looking back at the previous patch, it seems that these two are basically
> the setter/getter action for page encryption, though one is implemented as a
> hypercall while the other as an ioctl. If we consider the setter/getter
> aspect, isn't it better to have some sort of symmetry in the naming of the
> ops ? For example,
> 
>         set_page_enc_hc
> 
>         get_page_enc_ioctl
> 
> >   };

These are named as per their usage. While the page_enc_status_hc is a
hypercall used by a guest to mark the page encryption bitmap, the other
ones are ioctl interfaces used by Qemu (or Qemu alternative) to get/set
the page encryption bitmaps, so these are named accordingly.

> >   struct kvm_arch_async_pf {
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 1d8beaf1bceb..bae783cd396a 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -7686,6 +7686,76 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >   	return ret;
> >   }
> > +static int svm_get_page_enc_bitmap(struct kvm *kvm,
> > +				   struct kvm_page_enc_bitmap *bmap)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	unsigned long gfn_start, gfn_end;
> > +	unsigned long sz, i, sz_bytes;
> > +	unsigned long *bitmap;
> > +	int ret, n;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -ENOTTY;
> > +
> > +	gfn_start = bmap->start_gfn;
> 
> 
> What if bmap->start_gfn is junk ?
> 
> > +	gfn_end = gfn_start + bmap->num_pages;
> > +
> > +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
> > +	bitmap = kmalloc(sz, GFP_KERNEL);
> > +	if (!bitmap)
> > +		return -ENOMEM;
> > +
> > +	/* by default all pages are marked encrypted */
> > +	memset(bitmap, 0xff, sz);
> > +
> > +	mutex_lock(&kvm->lock);
> > +	if (sev->page_enc_bmap) {
> > +		i = gfn_start;
> > +		for_each_clear_bit_from(i, sev->page_enc_bmap,
> > +				      min(sev->page_enc_bmap_size, gfn_end))
> > +			clear_bit(i - gfn_start, bitmap);
> > +	}
> > +	mutex_unlock(&kvm->lock);
> > +
> > +	ret = -EFAULT;
> > +
> > +	n = bmap->num_pages % BITS_PER_BYTE;
> > +	sz_bytes = ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYTE;
> > +
> > +	/*
> > +	 * Return the correct bitmap as per the number of pages being
> > +	 * requested by the user. Ensure that we only copy bmap->num_pages
> > +	 * bytes in the userspace buffer, if bmap->num_pages is not byte
> > +	 * aligned we read the trailing bits from the userspace and copy
> > +	 * those bits as is.
> > +	 */
> > +
> > +	if (n) {
> 
> 
> Is it better to check for 'num_pages' at the beginning of the function
> rather than coming this far if bmap->num_pages is zero ?
> 

This is not checking for "num_pages", this is basically checking if
bmap->num_pages is not byte aligned.

> > +		unsigned char *bitmap_kernel = (unsigned char *)bitmap;
> 
> 
> Just trying to understand why you need this extra variable instead of using
> 'bitmap' directly.
> 

Makes the code much more readable/understandable.

> > +		unsigned char bitmap_user;
> > +		unsigned long offset, mask;
> > +
> > +		offset = bmap->num_pages / BITS_PER_BYTE;
> > +		if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offset,
> > +				sizeof(unsigned char)))
> > +			goto out;
> > +
> > +		mask = GENMASK(n - 1, 0);
> > +		bitmap_user &= ~mask;
> > +		bitmap_kernel[offset] &= mask;
> > +		bitmap_kernel[offset] |= bitmap_user;
> > +	}
> > +
> > +	if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
> 
> 
> If 'n' is zero, we are still copying stuff back to the user. Is that what is
> expected from userland ?
> 
> Another point. Since copy_from_user() was done in the caller, isn't it
> better to move this to the caller to keep a symmetry ?
>

As per the comments above, please note if n is not zero that means 
bmap->num_pages is not byte aligned so we read the trailing bits
from the userspace and copy those bits as is. If n is zero, then
bmap->num_pages is correctly aligned and we copy all the bytes back.

Thanks,
Ashish

> > +		goto out;
> > +
> > +	ret = 0;
> > +out:
> > +	kfree(bitmap);
> > +	return ret;
> > +}
> > +
> >   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >   {
> >   	struct kvm_sev_cmd sev_cmd;
> > @@ -8090,6 +8160,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >   	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> >   	.page_enc_status_hc = svm_page_enc_status_hc,
> > +	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
> >   };
> >   static int __init svm_init(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 68428eef2dde..3c3fea4e20b5 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5226,6 +5226,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >   	case KVM_SET_PMU_EVENT_FILTER:
> >   		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
> >   		break;
> > +	case KVM_GET_PAGE_ENC_BITMAP: {
> > +		struct kvm_page_enc_bitmap bitmap;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> > +			goto out;
> > +
> > +		r = -ENOTTY;
> > +		if (kvm_x86_ops->get_page_enc_bitmap)
> > +			r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
> > +		break;
> > +	}
> >   	default:
> >   		r = -ENOTTY;
> >   	}
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 4e80c57a3182..db1ebf85e177 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -500,6 +500,16 @@ struct kvm_dirty_log {
> >   	};
> >   };
> > +/* for KVM_GET_PAGE_ENC_BITMAP */
> > +struct kvm_page_enc_bitmap {
> > +	__u64 start_gfn;
> > +	__u64 num_pages;
> > +	union {
> > +		void __user *enc_bitmap; /* one bit per page */
> > +		__u64 padding2;
> > +	};
> > +};
> > +
> >   /* for KVM_CLEAR_DIRTY_LOG */
> >   struct kvm_clear_dirty_log {
> >   	__u32 slot;
> > @@ -1478,6 +1488,8 @@ struct kvm_enc_region {
> >   #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
> >   #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
> > +#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> > +
> >   /* Secure Encrypted Virtualization command */
> >   enum sev_cmd_id {
> >   	/* Guest initialization commands */
