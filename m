Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550141A009C
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 00:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgDFWIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 18:08:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFWIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 18:08:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M7lsl142030;
        Mon, 6 Apr 2020 22:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=I8jEMbf54vHiQS8CSQonjTAgKNgkfUVAkXZQU5T5740=;
 b=uG9vh7st1X1NAR52U0X0kc6vo16WlBCQ6mQTfd/1V1QcTibQd2PYJjuF+QiYDmwaxKmr
 icAKgXI5TcPVMN73Ahrr+UGy/sZ3T6KMUCDssDzn+7TInGOefXwqk6JMvoKRcFSD5mKc
 nyKG6NoP7LQItWDjNlnga0SqSc+L6BpkjFrFO/A54BYETD628Xp2eIj+cnjBVpZHuiG4
 XHbvOIPscPHaphT154WI9Br/L14LoW+1594MOgX0cDzaFV9jJ9MUV6TjP4CqYTcSneyt
 oXYEawPJS5h7ZqGDgWtm/r7PmE88o/COh1Ljl4qf0heJc5KrUDq+86+8Mhim5A/9k4TT YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 306hnr1jsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:07:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M7VAo112958;
        Mon, 6 Apr 2020 22:07:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30741bvubs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:07:57 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036M7rtB024961;
        Mon, 6 Apr 2020 22:07:53 GMT
Received: from localhost.localdomain (/10.159.148.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 15:07:53 -0700
Subject: Re: [PATCH v6 09/14] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <388afbf3af3a10cc3101008bc9381491cc7aab2f.1585548051.git.ashish.kalra@amd.com>
 <88185cd3-a9f4-68a8-9c34-2e72deaf3d8d@oracle.com>
 <20200403204734.GA28542@ashkalra_ubuntu_server>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <82adee80-5322-5992-0efa-94c5ce16a9af@oracle.com>
Date:   Mon, 6 Apr 2020 15:07:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200403204734.GA28542@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060167
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/3/20 1:47 PM, Ashish Kalra wrote:
> On Fri, Apr 03, 2020 at 01:18:52PM -0700, Krish Sadhukhan wrote:
>> On 3/29/20 11:22 PM, Ashish Kalra wrote:
>>> From: Brijesh Singh <Brijesh.Singh@amd.com>
>>>
>>> The ioctl can be used to retrieve page encryption bitmap for a given
>>> gfn range.
>>>
>>> Return the correct bitmap as per the number of pages being requested
>>> by the user. Ensure that we only copy bmap->num_pages bytes in the
>>> userspace buffer, if bmap->num_pages is not byte aligned we read
>>> the trailing bits from the userspace and copy those bits as is.
>>>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
>>> Cc: Joerg Roedel <joro@8bytes.org>
>>> Cc: Borislav Petkov <bp@suse.de>
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: x86@kernel.org
>>> Cc: kvm@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>    Documentation/virt/kvm/api.rst  | 27 +++++++++++++
>>>    arch/x86/include/asm/kvm_host.h |  2 +
>>>    arch/x86/kvm/svm.c              | 71 +++++++++++++++++++++++++++++++++
>>>    arch/x86/kvm/x86.c              | 12 ++++++
>>>    include/uapi/linux/kvm.h        | 12 ++++++
>>>    5 files changed, 124 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index ebd383fba939..8ad800ebb54f 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -4648,6 +4648,33 @@ This ioctl resets VCPU registers and control structures according to
>>>    the clear cpu reset definition in the POP. However, the cpu is not put
>>>    into ESA mode. This reset is a superset of the initial reset.
>>> +4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
>>> +---------------------------------------
>>> +
>>> +:Capability: basic
>>> +:Architectures: x86
>>> +:Type: vm ioctl
>>> +:Parameters: struct kvm_page_enc_bitmap (in/out)
>>> +:Returns: 0 on success, -1 on error
>>> +
>>> +/* for KVM_GET_PAGE_ENC_BITMAP */
>>> +struct kvm_page_enc_bitmap {
>>> +	__u64 start_gfn;
>>> +	__u64 num_pages;
>>> +	union {
>>> +		void __user *enc_bitmap; /* one bit per page */
>>> +		__u64 padding2;
>>> +	};
>>> +};
>>> +
>>> +The encrypted VMs have concept of private and shared pages. The private
>>> +page is encrypted with the guest-specific key, while shared page may
>>> +be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
>>> +be used to get the bitmap indicating whether the guest page is private
>>> +or shared. The bitmap can be used during the guest migration, if the page
>>> +is private then userspace need to use SEV migration commands to transmit
>>> +the page.
>>> +
>>>    5. The kvm_run structure
>>>    ========================
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 90718fa3db47..27e43e3ec9d8 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1269,6 +1269,8 @@ struct kvm_x86_ops {
>>>    	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>>>    	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
>>>    				  unsigned long sz, unsigned long mode);
>>> +	int (*get_page_enc_bitmap)(struct kvm *kvm,
>>> +				struct kvm_page_enc_bitmap *bmap);
>>
>> Looking back at the previous patch, it seems that these two are basically
>> the setter/getter action for page encryption, though one is implemented as a
>> hypercall while the other as an ioctl. If we consider the setter/getter
>> aspect, isn't it better to have some sort of symmetry in the naming of the
>> ops ? For example,
>>
>>          set_page_enc_hc
>>
>>          get_page_enc_ioctl
>>
>>>    };
> These are named as per their usage. While the page_enc_status_hc is a
> hypercall used by a guest to mark the page encryption bitmap, the other
> ones are ioctl interfaces used by Qemu (or Qemu alternative) to get/set
> the page encryption bitmaps, so these are named accordingly.


OK.

Please rename 'set_page_enc_hc' to 'set_page_enc_hypercall' to match 
'patch_hypercall'.


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

>
>>>    struct kvm_arch_async_pf {
>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>> index 1d8beaf1bceb..bae783cd396a 100644
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -7686,6 +7686,76 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>>>    	return ret;
>>>    }
>>> +static int svm_get_page_enc_bitmap(struct kvm *kvm,
>>> +				   struct kvm_page_enc_bitmap *bmap)
>>> +{
>>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> +	unsigned long gfn_start, gfn_end;
>>> +	unsigned long sz, i, sz_bytes;
>>> +	unsigned long *bitmap;
>>> +	int ret, n;
>>> +
>>> +	if (!sev_guest(kvm))
>>> +		return -ENOTTY;
>>> +
>>> +	gfn_start = bmap->start_gfn;
>>
>> What if bmap->start_gfn is junk ?
>>
>>> +	gfn_end = gfn_start + bmap->num_pages;
>>> +
>>> +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
>>> +	bitmap = kmalloc(sz, GFP_KERNEL);
>>> +	if (!bitmap)
>>> +		return -ENOMEM;
>>> +
>>> +	/* by default all pages are marked encrypted */
>>> +	memset(bitmap, 0xff, sz);
>>> +
>>> +	mutex_lock(&kvm->lock);
>>> +	if (sev->page_enc_bmap) {
>>> +		i = gfn_start;
>>> +		for_each_clear_bit_from(i, sev->page_enc_bmap,
>>> +				      min(sev->page_enc_bmap_size, gfn_end))
>>> +			clear_bit(i - gfn_start, bitmap);
>>> +	}
>>> +	mutex_unlock(&kvm->lock);
>>> +
>>> +	ret = -EFAULT;
>>> +
>>> +	n = bmap->num_pages % BITS_PER_BYTE;
>>> +	sz_bytes = ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYTE;
>>> +
>>> +	/*
>>> +	 * Return the correct bitmap as per the number of pages being
>>> +	 * requested by the user. Ensure that we only copy bmap->num_pages
>>> +	 * bytes in the userspace buffer, if bmap->num_pages is not byte
>>> +	 * aligned we read the trailing bits from the userspace and copy
>>> +	 * those bits as is.
>>> +	 */
>>> +
>>> +	if (n) {
>>
>> Is it better to check for 'num_pages' at the beginning of the function
>> rather than coming this far if bmap->num_pages is zero ?
>>
> This is not checking for "num_pages", this is basically checking if
> bmap->num_pages is not byte aligned.
>
>>> +		unsigned char *bitmap_kernel = (unsigned char *)bitmap;
>>
>> Just trying to understand why you need this extra variable instead of using
>> 'bitmap' directly.
>>
> Makes the code much more readable/understandable.
>
>>> +		unsigned char bitmap_user;
>>> +		unsigned long offset, mask;
>>> +
>>> +		offset = bmap->num_pages / BITS_PER_BYTE;
>>> +		if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offset,
>>> +				sizeof(unsigned char)))
>>> +			goto out;
>>> +
>>> +		mask = GENMASK(n - 1, 0);
>>> +		bitmap_user &= ~mask;
>>> +		bitmap_kernel[offset] &= mask;
>>> +		bitmap_kernel[offset] |= bitmap_user;
>>> +	}
>>> +
>>> +	if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
>>
>> If 'n' is zero, we are still copying stuff back to the user. Is that what is
>> expected from userland ?
>>
>> Another point. Since copy_from_user() was done in the caller, isn't it
>> better to move this to the caller to keep a symmetry ?
>>
> As per the comments above, please note if n is not zero that means
> bmap->num_pages is not byte aligned so we read the trailing bits
> from the userspace and copy those bits as is. If n is zero, then
> bmap->num_pages is correctly aligned and we copy all the bytes back.
>
> Thanks,
> Ashish
>
>>> +		goto out;
>>> +
>>> +	ret = 0;
>>> +out:
>>> +	kfree(bitmap);
>>> +	return ret;
>>> +}
>>> +
>>>    static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>    {
>>>    	struct kvm_sev_cmd sev_cmd;
>>> @@ -8090,6 +8160,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>>>    	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
>>>    	.page_enc_status_hc = svm_page_enc_status_hc,
>>> +	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
>>>    };
>>>    static int __init svm_init(void)
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 68428eef2dde..3c3fea4e20b5 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -5226,6 +5226,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>>    	case KVM_SET_PMU_EVENT_FILTER:
>>>    		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
>>>    		break;
>>> +	case KVM_GET_PAGE_ENC_BITMAP: {
>>> +		struct kvm_page_enc_bitmap bitmap;
>>> +
>>> +		r = -EFAULT;
>>> +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
>>> +			goto out;
>>> +
>>> +		r = -ENOTTY;
>>> +		if (kvm_x86_ops->get_page_enc_bitmap)
>>> +			r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
>>> +		break;
>>> +	}
>>>    	default:
>>>    		r = -ENOTTY;
>>>    	}
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 4e80c57a3182..db1ebf85e177 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -500,6 +500,16 @@ struct kvm_dirty_log {
>>>    	};
>>>    };
>>> +/* for KVM_GET_PAGE_ENC_BITMAP */
>>> +struct kvm_page_enc_bitmap {
>>> +	__u64 start_gfn;
>>> +	__u64 num_pages;
>>> +	union {
>>> +		void __user *enc_bitmap; /* one bit per page */
>>> +		__u64 padding2;
>>> +	};
>>> +};
>>> +
>>>    /* for KVM_CLEAR_DIRTY_LOG */
>>>    struct kvm_clear_dirty_log {
>>>    	__u32 slot;
>>> @@ -1478,6 +1488,8 @@ struct kvm_enc_region {
>>>    #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
>>>    #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
>>> +#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
>>> +
>>>    /* Secure Encrypted Virtualization command */
>>>    enum sev_cmd_id {
>>>    	/* Guest initialization commands */
