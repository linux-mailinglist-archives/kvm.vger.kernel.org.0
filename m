Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4EB2C445
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 12:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfE1Kcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 06:32:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53156 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbfE1Kcj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 May 2019 06:32:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SAWNAQ041724
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 06:32:38 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ss21938uq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 06:32:37 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 28 May 2019 11:32:36 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 28 May 2019 11:32:33 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4SAWWRD49873028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 10:32:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1383742045;
        Tue, 28 May 2019 10:32:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2FC94203F;
        Tue, 28 May 2019 10:32:31 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.177])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 May 2019 10:32:31 +0000 (GMT)
Subject: Re: [PATCH] kvm: add kvm cap values to debugfs
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org,
        dja@axtens.net
References: <20190528083535.27643-1-sjitindarsingh@gmail.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Tue, 28 May 2019 12:32:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528083535.27643-1-sjitindarsingh@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19052810-0020-0000-0000-00000341312F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052810-0021-0000-0000-000021942C45
Message-Id: <7622b8ab-c2a4-8920-afe3-d2a9089cbd10@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280070
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.05.19 10:35, Suraj Jitindar Singh wrote:
> KVM capabilities are used to communicate the availability of certain
> capabilities to userspace.
> 
> It might be nice to know these values without having to add debug
> printing to the userspace tool consuming this data.
> 
> Thus add a file in the kvm per vm debugfs file named "caps" which
> contains a file for each capability number which when read returns what
> would be returned when querying that capability.
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> 
> ---
> 
> I'm not sure if it'd be better to keep a per arch list of the revelevant
> capabilities to avoid adding an entry for irrelevant ones. Comments?
> ---
>  include/linux/kvm_host.h |  1 +
>  include/uapi/linux/kvm.h |  1 +
>  virt/kvm/kvm_main.c      | 31 +++++++++++++++++++++++++++++++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 79fa4426509c..6cb45a8de818 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -500,6 +500,7 @@ struct kvm {
>  	bool manual_dirty_log_protect;
>  	struct dentry *debugfs_dentry;
>  	struct kvm_stat_data **debugfs_stat_data;
> +	int debugfs_cap_data[KVM_CAP_MAX + 1];
>  	struct srcu_struct srcu;
>  	struct srcu_struct irq_srcu;
>  	pid_t userspace_pid;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2fe12b40d503..7b5042ec5902 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_SVE 170
>  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
> +#define KVM_CAP_MAX	KVM_CAP_ARM_PTRAUTH_GENERIC
> 
>  #ifdef KVM_CAP_IRQ_ROUTING
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 134ec0283a8a..b85a43263fb7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -117,6 +117,7 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
>  static int kvm_debugfs_num_entries;
>  static const struct file_operations *stat_fops_per_vm[];
> 
> +static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg);
>  static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
>  			   unsigned long arg);
>  #ifdef CONFIG_KVM_COMPAT
> @@ -594,6 +595,33 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
>  	}
>  }
> 
> +static int vm_cap_get(void *data, u64 *val)
> +{
> +	*val = *((int *) data);
> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(cap_fops, vm_cap_get, NULL, "%llu\n");
> +
> +static void kvm_create_vm_cap_debugfs(struct kvm *kvm)
> +{
> +	char *dir_name = "caps";
> +	struct dentry *dentry_p;
> +	int i;
> +
> +	dentry_p = debugfs_create_dir(dir_name, kvm->debugfs_dentry);
> +
> +	for (i = 0; i <= KVM_CAP_MAX; i++) {
> +		int *cap = &kvm->debugfs_cap_data[i];
> +		char file_name[ITOA_MAX_LEN];
> +
> +		*cap = kvm_vm_ioctl_check_extension_generic(kvm, i);
> +		snprintf(file_name, sizeof(file_name), "%d", i);
> +		debugfs_create_file(file_name, 0444, dentry_p, cap, &cap_fops);
> +	}

So you get the information of the capabilities during creation of the VM.
Are there any capabilities that might change over time? I do not know right
now, but wouldnt it be better to actually call kvm_vm_ioctl_check_extension_generic
in the fops callback?

> +}
> +
>  static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  {
>  	char dir_name[ITOA_MAX_LEN * 2];
> @@ -623,6 +651,9 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  		debugfs_create_file(p->name, 0644, kvm->debugfs_dentry,
>  				    stat_data, stat_fops_per_vm[p->kind]);
>  	}
> +
> +	kvm_create_vm_cap_debugfs(kvm);
> +
>  	return 0;
>  }
> 

