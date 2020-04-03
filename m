Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8452619E00D
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 23:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgDCVGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 17:06:16 -0400
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:48193
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727842AbgDCVGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 17:06:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXF5rReiLZvnfuFEOtgpNBKMqM7zv3l3agj1NcLrwrKuyyM32p4goG+500WqkJsdrBtIPcRH8kj1cWeoq9pTiUxfbyjvCj9oYhN1tGDu4vADUJAQNGZejwOPP/T5R7AbGonohOYdJrdxN7AuW/goay1KkRR8b22VCskacyslxENsCK0zas1gvKR5Xyxf4A+Pbsgc3/eteYnT8x6bdWoXVPog1EGD28F3UXgvks/kqwcUgs1fkRkU+xTqvhtmSJaTfB4Qb8VUydZcXj7YK3EfAH1NijVv7giR0OInmRhMSrSCLiAGnXRT2tBtTuiPnMFE6S5MAIceL+7SEIgLrGsYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vgwUmd8Hjvr+8OgZvTiAU02A0N5VMMrtOxnlTaXPb8=;
 b=V4rPbIr7Gdr444TY6I1Qw8BlSfpj4Q/nMw+oZXzfmR3xf5dKmiq7vFxwBgkTKtPfTUSJ+GlQ4WmeyW5BqmEE9EYJV1H9yz/UIPeFAKYothqYorNj2Ms/5rA6mIXPDoNn128eSmOYpYXHoaLeHb0bW7YIdiY12H/8hDnVrUw8yneD7bVwJuguRASGYJv+6VDOMzA3n0HTM/EJjeK/NEfZmELQRl2X89u5fAdd/sUzEtiU9LEFMNq61teWwodLoU519qTpDSr3HpRUbPzXIr8vaGhgmjyGxxMu5RtlJmVo7Px3lzzHFbrz7+tRTiEjLoLYLDyrRAuMz344mE96K21ByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vgwUmd8Hjvr+8OgZvTiAU02A0N5VMMrtOxnlTaXPb8=;
 b=vyTylJeZPJRRKAXfP4sSZGGVNL1p+0Fi5iy3+EGy2cp4XqmdUAL+BbHBadJkBA2C1KpPFb9O/V09WjzmAwMlmbI2IDcT9865lS7VoMq0jtGB/4V1MZK+eT01XHaESmITmd6PToopDXQHJ0YA9x0iptGf6Qns7hm7EYArthAPAnY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1179.namprd12.prod.outlook.com (2603:10b6:3:6f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Fri, 3 Apr 2020 21:01:37 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.017; Fri, 3 Apr 2020
 21:01:37 +0000
Date:   Fri, 3 Apr 2020 21:01:31 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: Re: [PATCH v6 09/14] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Message-ID: <20200403210131.GA28660@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <388afbf3af3a10cc3101008bc9381491cc7aab2f.1585548051.git.ashish.kalra@amd.com>
 <88185cd3-a9f4-68a8-9c34-2e72deaf3d8d@oracle.com>
 <20200403205507.GA729294@vbusired-dt>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200403205507.GA729294@vbusired-dt>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR16CA0026.namprd16.prod.outlook.com
 (2603:10b6:4:15::12) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR16CA0026.namprd16.prod.outlook.com (2603:10b6:4:15::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Fri, 3 Apr 2020 21:01:35 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5dd70198-5264-4479-fa57-08d7d81232ac
X-MS-TrafficTypeDiagnostic: DM5PR12MB1179:|DM5PR12MB1179:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11795AAE7602A572EC44717E8EC70@DM5PR12MB1179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(4326008)(7416002)(1076003)(66946007)(66556008)(66476007)(316002)(66574012)(478600001)(2906002)(33716001)(33656002)(8936002)(52116002)(6496006)(8676002)(86362001)(956004)(9686003)(81166006)(81156014)(53546011)(5660300002)(55016002)(6666004)(16526019)(26005)(6916009)(186003)(44832011);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wxha+nwfqsyyN5AunhYkz2EgfPu3dRKG5cDMNWRYrdhdp0c1FBgN7fT8pY4X2s7eeCicPkbh6vdvRUupoTYzA8hI9IKbwcl9o+V0KL/2A5ha7Re422hQF07JnmPzLgE4SiKIlqfREoQMNrPzatSS5WfgatNsNPTIKXWszGTlKqApxBlro2KZKG7XLxhn4zUkJa+pvxsXOaVHRwNe/zBymvKDzPcGV1sHHcp10AR4O/lmLUZo1BgEtU2b28H723BBrX1Cm7d0YNBUqboU/roS0CNsM8dAbC/sOD4+1XVAbwuzo74AQtLozGbV5rtMiFyUmUWx9+ozbG1jLqrY+pHIv7PPJGVkSvOfjzhMbsga+ligfFGIONMqaEKQW3KMSOGW9mgBF2u/DzfQwmxNQsCllsmfv/GuWlhN0kwwavdlItj9sQhliv5P7XoQcLkaLvL/
X-MS-Exchange-AntiSpam-MessageData: bZivTYAdT1SQLCCI+Zj1rpZrHeRPh/IUN6ZIbd5BxR37mGuuUhnP15b41jf63hGvwtngZZLviyoHXnvrKuwyOLTjk4I792vP4kBFX4FruwxL9rSbOfR1C4HPf9AHnOUcncO/skIW44eArtBDMZz/9g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd70198-5264-4479-fa57-08d7d81232ac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 21:01:36.9931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2k2C6tDr58mBjW6SP+vD5JM5QlaZIY/W8SnUW+TxwWiQrRa0Df056AoCfUjye4RZw58SR7+kcagRl4M9ZOzN8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 03, 2020 at 03:55:07PM -0500, Venu Busireddy wrote:
> On 2020-04-03 13:18:52 -0700, Krish Sadhukhan wrote:
> > 
> > On 3/29/20 11:22 PM, Ashish Kalra wrote:
> > > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > > 
> > > The ioctl can be used to retrieve page encryption bitmap for a given
> > > gfn range.
> > > 
> > > Return the correct bitmap as per the number of pages being requested
> > > by the user. Ensure that we only copy bmap->num_pages bytes in the
> > > userspace buffer, if bmap->num_pages is not byte aligned we read
> > > the trailing bits from the userspace and copy those bits as is.
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
> > > ---
> > >   Documentation/virt/kvm/api.rst  | 27 +++++++++++++
> > >   arch/x86/include/asm/kvm_host.h |  2 +
> > >   arch/x86/kvm/svm.c              | 71 +++++++++++++++++++++++++++++++++
> > >   arch/x86/kvm/x86.c              | 12 ++++++
> > >   include/uapi/linux/kvm.h        | 12 ++++++
> > >   5 files changed, 124 insertions(+)
> > > 
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index ebd383fba939..8ad800ebb54f 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -4648,6 +4648,33 @@ This ioctl resets VCPU registers and control structures according to
> > >   the clear cpu reset definition in the POP. However, the cpu is not put
> > >   into ESA mode. This reset is a superset of the initial reset.
> > > +4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
> > > +---------------------------------------
> > > +
> > > +:Capability: basic
> > > +:Architectures: x86
> > > +:Type: vm ioctl
> > > +:Parameters: struct kvm_page_enc_bitmap (in/out)
> > > +:Returns: 0 on success, -1 on error
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
> > >   5. The kvm_run structure
> > >   ========================
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 90718fa3db47..27e43e3ec9d8 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1269,6 +1269,8 @@ struct kvm_x86_ops {
> > >   	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> > >   	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > >   				  unsigned long sz, unsigned long mode);
> > > +	int (*get_page_enc_bitmap)(struct kvm *kvm,
> > > +				struct kvm_page_enc_bitmap *bmap);
> > 
> > 
> > Looking back at the previous patch, it seems that these two are basically
> > the setter/getter action for page encryption, though one is implemented as a
> > hypercall while the other as an ioctl. If we consider the setter/getter
> > aspect, isn't it better to have some sort of symmetry in the naming of the
> > ops ? For example,
> > 
> >         set_page_enc_hc
> > 
> >         get_page_enc_ioctl
> > 
> > >   };
> > >   struct kvm_arch_async_pf {
> > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > index 1d8beaf1bceb..bae783cd396a 100644
> > > --- a/arch/x86/kvm/svm.c
> > > +++ b/arch/x86/kvm/svm.c
> > > @@ -7686,6 +7686,76 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > >   	return ret;
> > >   }
> > > +static int svm_get_page_enc_bitmap(struct kvm *kvm,
> > > +				   struct kvm_page_enc_bitmap *bmap)
> > > +{
> > > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > +	unsigned long gfn_start, gfn_end;
> > > +	unsigned long sz, i, sz_bytes;
> > > +	unsigned long *bitmap;
> > > +	int ret, n;
> > > +
> > > +	if (!sev_guest(kvm))
> > > +		return -ENOTTY;
> > > +
> > > +	gfn_start = bmap->start_gfn;
> > 
> > 
> > What if bmap->start_gfn is junk ?
> > 
> > > +	gfn_end = gfn_start + bmap->num_pages;
> > > +
> > > +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
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
> > > +
> > > +	n = bmap->num_pages % BITS_PER_BYTE;
> > > +	sz_bytes = ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYTE;
> > > +
> > > +	/*
> > > +	 * Return the correct bitmap as per the number of pages being
> > > +	 * requested by the user. Ensure that we only copy bmap->num_pages
> > > +	 * bytes in the userspace buffer, if bmap->num_pages is not byte
> > > +	 * aligned we read the trailing bits from the userspace and copy
> > > +	 * those bits as is.
> > > +	 */
> > > +
> > > +	if (n) {
> > 
> > 
> > Is it better to check for 'num_pages' at the beginning of the function
> > rather than coming this far if bmap->num_pages is zero ?
> > 
> > > +		unsigned char *bitmap_kernel = (unsigned char *)bitmap;
> > 
> > 
> > Just trying to understand why you need this extra variable instead of using
> > 'bitmap' directly.
> > 
> > > +		unsigned char bitmap_user;
> > > +		unsigned long offset, mask;
> > > +
> > > +		offset = bmap->num_pages / BITS_PER_BYTE;
> > > +		if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offset,
> > > +				sizeof(unsigned char)))
> > > +			goto out;
> > > +
> > > +		mask = GENMASK(n - 1, 0);
> > > +		bitmap_user &= ~mask;
> > > +		bitmap_kernel[offset] &= mask;
> > > +		bitmap_kernel[offset] |= bitmap_user;
> > > +	}
> > > +
> > > +	if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
> > 
> > 
> > If 'n' is zero, we are still copying stuff back to the user. Is that what is
> > expected from userland ?
> > 
> > Another point. Since copy_from_user() was done in the caller, isn't it
> > better to move this to the caller to keep a symmetry ?
> 
> That would need the interface of .get_page_enc_bitmap to change, to pass
> back the local bitmap to the caller for use in copy_to_user() and then
> free it up. I think it is better to call copy_to_user() here and free
> the bitmap before returning.
> 

As i replied in my earlier response to this patch, please note that
as per comments above, here we are checking if bmap->num_pages is not byte
aligned and if not then we read the trailing bits from the userspace and copy
those bits as is.

Thanks,
Ashish

> > 
> > > +		goto out;
> > > +
> > > +	ret = 0;
> > > +out:
> > > +	kfree(bitmap);
> > > +	return ret;
> > > +}
> > > +
> > >   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > >   {
> > >   	struct kvm_sev_cmd sev_cmd;
> > > @@ -8090,6 +8160,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> > >   	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> > >   	.page_enc_status_hc = svm_page_enc_status_hc,
> > > +	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
> > >   };
> > >   static int __init svm_init(void)
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 68428eef2dde..3c3fea4e20b5 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -5226,6 +5226,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
> > >   	case KVM_SET_PMU_EVENT_FILTER:
> > >   		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
> > >   		break;
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
> > >   	default:
> > >   		r = -ENOTTY;
> > >   	}
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index 4e80c57a3182..db1ebf85e177 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -500,6 +500,16 @@ struct kvm_dirty_log {
> > >   	};
> > >   };
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
> > >   /* for KVM_CLEAR_DIRTY_LOG */
> > >   struct kvm_clear_dirty_log {
> > >   	__u32 slot;
> > > @@ -1478,6 +1488,8 @@ struct kvm_enc_region {
> > >   #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
> > >   #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
> > > +#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> > > +
> > >   /* Secure Encrypted Virtualization command */
> > >   enum sev_cmd_id {
> > >   	/* Guest initialization commands */
