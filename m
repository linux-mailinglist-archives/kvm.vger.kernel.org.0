Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A128C19FD9A
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 20:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgDFSx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 14:53:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgDFSx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 14:53:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Ii0RB008154;
        Mon, 6 Apr 2020 18:53:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3TUYNHdBY6ulFkaBClhwUTL4XGUagsttRHZeXbyiUmI=;
 b=rB7t20WmZrzmLA/R/SAJHtFFn/0geSDJ2gWl5t2iZB9xXLzrlpiKFJuKaEGQBvW3vmJu
 iI2b6pMdA818DasqT9XqOmyBLop7rjVUhS/g1tHDOldvoDdUM3nDH3KnxDzJxS+G/cc3
 Vye/Wp/GfZ6W3K9mkAgo42GwhBnniV5LxbR+aAwwgCdfGJ1/gthakSjlVOPQjnBf3mAu
 8TYHcx4MKy2cCOATfLLOS6kgla+Dcx5LRxShgT+MRXOO/XIhttvV0bVUcRqogblw3JXW
 X8EhzUNzjqRmT2WbmDcty7TzPOPxg8Ti4UA4M5qKV6sqWElDr7rBcdqIlTYE64UPeAOl 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 306hnr0r1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:53:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IhEsd116843;
        Mon, 6 Apr 2020 18:53:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3073qdt8sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:53:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036Ir1gv003045;
        Mon, 6 Apr 2020 18:53:01 GMT
Received: from localhost.localdomain (/10.159.148.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 11:53:01 -0700
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
 <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com>
 <20200403214559.GB28747@ashkalra_ubuntu_server>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com>
Date:   Mon, 6 Apr 2020 11:52:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200403214559.GB28747@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/3/20 2:45 PM, Ashish Kalra wrote:
> On Fri, Apr 03, 2020 at 02:14:23PM -0700, Krish Sadhukhan wrote:
>> On 3/29/20 11:23 PM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> This ioctl can be used by the application to reset the page
>>> encryption bitmap managed by the KVM driver. A typical usage
>>> for this ioctl is on VM reboot, on reboot, we must reinitialize
>>> the bitmap.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>    Documentation/virt/kvm/api.rst  | 13 +++++++++++++
>>>    arch/x86/include/asm/kvm_host.h |  1 +
>>>    arch/x86/kvm/svm.c              | 16 ++++++++++++++++
>>>    arch/x86/kvm/x86.c              |  6 ++++++
>>>    include/uapi/linux/kvm.h        |  1 +
>>>    5 files changed, 37 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index 4d1004a154f6..a11326ccc51d 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
>>>    bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
>>>    bitmap for an incoming guest.
>>> +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
>>> +-----------------------------------------
>>> +
>>> +:Capability: basic
>>> +:Architectures: x86
>>> +:Type: vm ioctl
>>> +:Parameters: none
>>> +:Returns: 0 on success, -1 on error
>>> +
>>> +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
>>> +bitmap during guest reboot and this is only done on the guest's boot vCPU.
>>> +
>>> +
>>>    5. The kvm_run structure
>>>    ========================
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index d30f770aaaea..a96ef6338cd2 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
>>>    				struct kvm_page_enc_bitmap *bmap);
>>>    	int (*set_page_enc_bitmap)(struct kvm *kvm,
>>>    				struct kvm_page_enc_bitmap *bmap);
>>> +	int (*reset_page_enc_bitmap)(struct kvm *kvm);
>>>    };
>>>    struct kvm_arch_async_pf {
>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>> index 313343a43045..c99b0207a443 100644
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
>>>    	return ret;
>>>    }
>>> +static int svm_reset_page_enc_bitmap(struct kvm *kvm)
>>> +{
>>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> +
>>> +	if (!sev_guest(kvm))
>>> +		return -ENOTTY;
>>> +
>>> +	mutex_lock(&kvm->lock);
>>> +	/* by default all pages should be marked encrypted */
>>> +	if (sev->page_enc_bmap_size)
>>> +		bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
>>> +	mutex_unlock(&kvm->lock);
>>> +	return 0;
>>> +}
>>> +
>>>    static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>    {
>>>    	struct kvm_sev_cmd sev_cmd;
>>> @@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>>>    	.page_enc_status_hc = svm_page_enc_status_hc,
>>>    	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
>>>    	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
>>> +	.reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
>>
>> We don't need to initialize the intel ops to NULL ? It's not initialized in
>> the previous patch either.
>>
>>>    };
> This struct is declared as "static storage", so won't the non-initialized
> members be 0 ?


Correct. Although, I see that 'nested_enable_evmcs' is explicitly 
initialized. We should maintain the convention, perhaps.

>
>>>    static int __init svm_init(void)
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 05e953b2ec61..2127ed937f53 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>>    			r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
>>>    		break;
>>>    	}
>>> +	case KVM_PAGE_ENC_BITMAP_RESET: {
>>> +		r = -ENOTTY;
>>> +		if (kvm_x86_ops->reset_page_enc_bitmap)
>>> +			r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
>>> +		break;
>>> +	}
>>>    	default:
>>>    		r = -ENOTTY;
>>>    	}
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index b4b01d47e568..0884a581fc37 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
>>>    #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
>>>    #define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
>>> +#define KVM_PAGE_ENC_BITMAP_RESET	_IO(KVMIO, 0xc7)
>>>    /* Secure Encrypted Virtualization command */
>>>    enum sev_cmd_id {
>> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
