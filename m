Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE25C11E5A4
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 15:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfLMOfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 09:35:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727619AbfLMOfU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 09:35:20 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDEXITA109229
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 09:35:18 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wusv116t4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 09:35:17 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 13 Dec 2019 14:35:16 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 13 Dec 2019 14:35:14 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBDEZDWL39059502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 14:35:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 178D6AE05A;
        Fri, 13 Dec 2019 14:35:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2206AE053;
        Fri, 13 Dec 2019 14:35:12 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.212])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Dec 2019 14:35:12 +0000 (GMT)
Subject: Re: [PATCH v5] kvm: Refactor handling of VM debugfs files
To:     Milan Pandurov <milanpa@amazon.de>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.de
References: <20191213130721.7942-1-milanpa@amazon.de>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 13 Dec 2019 15:35:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191213130721.7942-1-milanpa@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19121314-0028-0000-0000-000003C83535
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121314-0029-0000-0000-0000248B72D6
Message-Id: <ffd75066-c094-a15b-2c9b-84f17283124f@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_03:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0 phishscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.12.19 14:07, Milan Pandurov wrote:
> We can store reference to kvm_stats_debugfs_item instead of copying
> its values to kvm_stat_data.
> This allows us to remove duplicated code and usage of temporary
> kvm_stat_data inside vm_stat_get et al.
> 
> Signed-off-by: Milan Pandurov <milanpa@amazon.de>
> Reviewed-by: Alexander Graf <graf@anazon.com>
> 

I gave this a quick spin and it still seems to work.

> ---
> v1 -> v2:
>  - fix compile issues
>  - add reference to kvm_stats_debugfs_item in kvm_stat_data
>  - return -EINVAL when writing !0
>  - use explicit switch case instead of ops indirection
>  - fix checkpatch warning: Change S_IWUGO to 0222
> 
> v2 -> v3:
>  - remove unused kvm_stat_ops
>  - fix style issues
> 
> v3 -> v4:
>  - revert: Change S_IWUGO to 0222
> 
> v4 -> v5:
>  - fix checkpatch warning: Change S_IWUGO to 0222
> ---
>  include/linux/kvm_host.h |   7 +-
>  virt/kvm/kvm_main.c      | 142 +++++++++++++++++++--------------------
>  2 files changed, 76 insertions(+), 73 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7ed1e2f8641e..d3f2c0eae857 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1109,9 +1109,8 @@ enum kvm_stat_kind {
>  };
>  
>  struct kvm_stat_data {
> -	int offset;
> -	int mode;
>  	struct kvm *kvm;
> +	struct kvm_stats_debugfs_item *dbgfs_item;
>  };
>  
>  struct kvm_stats_debugfs_item {
> @@ -1120,6 +1119,10 @@ struct kvm_stats_debugfs_item {
>  	enum kvm_stat_kind kind;
>  	int mode;
>  };
> +
> +#define KVM_DBGFS_GET_MODE(dbgfs_item)                                         \
> +	((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
> +
>  extern struct kvm_stats_debugfs_item debugfs_entries[];
>  extern struct dentry *kvm_debugfs_dir;
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 00268290dcbd..0ebd6aa95671 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -113,7 +113,7 @@ struct dentry *kvm_debugfs_dir;
>  EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
>  
>  static int kvm_debugfs_num_entries;
> -static const struct file_operations *stat_fops_per_vm[];
> +static const struct file_operations stat_fops_per_vm;
>  
>  static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
>  			   unsigned long arg);
> @@ -650,11 +650,11 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  			return -ENOMEM;
>  
>  		stat_data->kvm = kvm;
> -		stat_data->offset = p->offset;
> -		stat_data->mode = p->mode ? p->mode : 0644;
> +		stat_data->dbgfs_item = p;
>  		kvm->debugfs_stat_data[p - debugfs_entries] = stat_data;
> -		debugfs_create_file(p->name, stat_data->mode, kvm->debugfs_dentry,
> -				    stat_data, stat_fops_per_vm[p->kind]);
> +		debugfs_create_file(p->name, KVM_DBGFS_GET_MODE(p),
> +				    kvm->debugfs_dentry, stat_data,
> +				    &stat_fops_per_vm);
>  	}
>  	return 0;
>  }
> @@ -4013,8 +4013,9 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
>  		return -ENOENT;
>  
>  	if (simple_attr_open(inode, file, get,
> -			     stat_data->mode & S_IWUGO ? set : NULL,
> -			     fmt)) {
> +		    KVM_DBGFS_GET_MODE(stat_data->dbgfs_item) & 0222
> +		    ? set : NULL,
> +		    fmt)) {
>  		kvm_put_kvm(stat_data->kvm);
>  		return -ENOMEM;
>  	}
> @@ -4033,105 +4034,111 @@ static int kvm_debugfs_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -static int vm_stat_get_per_vm(void *data, u64 *val)
> +static int kvm_get_stat_per_vm(struct kvm *kvm, size_t offset, u64 *val)
>  {
> -	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
> +	*val = *(ulong *)((void *)kvm + offset);
>  
> -	*val = *(ulong *)((void *)stat_data->kvm + stat_data->offset);
> +	return 0;
> +}
> +
> +static int kvm_clear_stat_per_vm(struct kvm *kvm, size_t offset)
> +{
> +	*(ulong *)((void *)kvm + offset) = 0;
>  
>  	return 0;
>  }
>  
> -static int vm_stat_clear_per_vm(void *data, u64 val)
> +static int kvm_get_stat_per_vcpu(struct kvm *kvm, size_t offset, u64 *val)
>  {
> -	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
> +	int i;
> +	struct kvm_vcpu *vcpu;
>  
> -	if (val)
> -		return -EINVAL;
> +	*val = 0;
>  
> -	*(ulong *)((void *)stat_data->kvm + stat_data->offset) = 0;
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		*val += *(u64 *)((void *)vcpu + offset);
>  
>  	return 0;
>  }
>  
> -static int vm_stat_get_per_vm_open(struct inode *inode, struct file *file)
> +static int kvm_clear_stat_per_vcpu(struct kvm *kvm, size_t offset)
>  {
> -	__simple_attr_check_format("%llu\n", 0ull);
> -	return kvm_debugfs_open(inode, file, vm_stat_get_per_vm,
> -				vm_stat_clear_per_vm, "%llu\n");
> -}
> +	int i;
> +	struct kvm_vcpu *vcpu;
>  
> -static const struct file_operations vm_stat_get_per_vm_fops = {
> -	.owner   = THIS_MODULE,
> -	.open    = vm_stat_get_per_vm_open,
> -	.release = kvm_debugfs_release,
> -	.read    = simple_attr_read,
> -	.write   = simple_attr_write,
> -	.llseek  = no_llseek,
> -};
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		*(u64 *)((void *)vcpu + offset) = 0;
> +
> +	return 0;
> +}
>  
> -static int vcpu_stat_get_per_vm(void *data, u64 *val)
> +static int kvm_stat_data_get(void *data, u64 *val)
>  {
> -	int i;
> +	int r = -EFAULT;
>  	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
> -	struct kvm_vcpu *vcpu;
> -
> -	*val = 0;
>  
> -	kvm_for_each_vcpu(i, vcpu, stat_data->kvm)
> -		*val += *(u64 *)((void *)vcpu + stat_data->offset);
> +	switch (stat_data->dbgfs_item->kind) {
> +	case KVM_STAT_VM:
> +		r = kvm_get_stat_per_vm(stat_data->kvm,
> +					stat_data->dbgfs_item->offset, val);
> +		break;
> +	case KVM_STAT_VCPU:
> +		r = kvm_get_stat_per_vcpu(stat_data->kvm,
> +					  stat_data->dbgfs_item->offset, val);
> +		break;
> +	}
>  
> -	return 0;
> +	return r;
>  }
>  
> -static int vcpu_stat_clear_per_vm(void *data, u64 val)
> +static int kvm_stat_data_clear(void *data, u64 val)
>  {
> -	int i;
> +	int r = -EFAULT;
>  	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
> -	struct kvm_vcpu *vcpu;
>  
>  	if (val)
>  		return -EINVAL;
>  
> -	kvm_for_each_vcpu(i, vcpu, stat_data->kvm)
> -		*(u64 *)((void *)vcpu + stat_data->offset) = 0;
> +	switch (stat_data->dbgfs_item->kind) {
> +	case KVM_STAT_VM:
> +		r = kvm_clear_stat_per_vm(stat_data->kvm,
> +					  stat_data->dbgfs_item->offset);
> +		break;
> +	case KVM_STAT_VCPU:
> +		r = kvm_clear_stat_per_vcpu(stat_data->kvm,
> +					    stat_data->dbgfs_item->offset);
> +		break;
> +	}
>  
> -	return 0;
> +	return r;
>  }
>  
> -static int vcpu_stat_get_per_vm_open(struct inode *inode, struct file *file)
> +static int kvm_stat_data_open(struct inode *inode, struct file *file)
>  {
>  	__simple_attr_check_format("%llu\n", 0ull);
> -	return kvm_debugfs_open(inode, file, vcpu_stat_get_per_vm,
> -				 vcpu_stat_clear_per_vm, "%llu\n");
> +	return kvm_debugfs_open(inode, file, kvm_stat_data_get,
> +				kvm_stat_data_clear, "%llu\n");
>  }
>  
> -static const struct file_operations vcpu_stat_get_per_vm_fops = {
> -	.owner   = THIS_MODULE,
> -	.open    = vcpu_stat_get_per_vm_open,
> +static const struct file_operations stat_fops_per_vm = {
> +	.owner = THIS_MODULE,
> +	.open = kvm_stat_data_open,
>  	.release = kvm_debugfs_release,
> -	.read    = simple_attr_read,
> -	.write   = simple_attr_write,
> -	.llseek  = no_llseek,
> -};
> -
> -static const struct file_operations *stat_fops_per_vm[] = {
> -	[KVM_STAT_VCPU] = &vcpu_stat_get_per_vm_fops,
> -	[KVM_STAT_VM]   = &vm_stat_get_per_vm_fops,
> +	.read = simple_attr_read,
> +	.write = simple_attr_write,
> +	.llseek = no_llseek,
>  };
>  
>  static int vm_stat_get(void *_offset, u64 *val)
>  {
>  	unsigned offset = (long)_offset;
>  	struct kvm *kvm;
> -	struct kvm_stat_data stat_tmp = {.offset = offset};
>  	u64 tmp_val;
>  
>  	*val = 0;
>  	mutex_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> -		stat_tmp.kvm = kvm;
> -		vm_stat_get_per_vm((void *)&stat_tmp, &tmp_val);
> +		kvm_get_stat_per_vm(kvm, offset, &tmp_val);
>  		*val += tmp_val;
>  	}
>  	mutex_unlock(&kvm_lock);
> @@ -4142,15 +4149,13 @@ static int vm_stat_clear(void *_offset, u64 val)
>  {
>  	unsigned offset = (long)_offset;
>  	struct kvm *kvm;
> -	struct kvm_stat_data stat_tmp = {.offset = offset};
>  
>  	if (val)
>  		return -EINVAL;
>  
>  	mutex_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> -		stat_tmp.kvm = kvm;
> -		vm_stat_clear_per_vm((void *)&stat_tmp, 0);
> +		kvm_clear_stat_per_vm(kvm, offset);
>  	}
>  	mutex_unlock(&kvm_lock);
>  
> @@ -4163,14 +4168,12 @@ static int vcpu_stat_get(void *_offset, u64 *val)
>  {
>  	unsigned offset = (long)_offset;
>  	struct kvm *kvm;
> -	struct kvm_stat_data stat_tmp = {.offset = offset};
>  	u64 tmp_val;
>  
>  	*val = 0;
>  	mutex_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> -		stat_tmp.kvm = kvm;
> -		vcpu_stat_get_per_vm((void *)&stat_tmp, &tmp_val);
> +		kvm_get_stat_per_vcpu(kvm, offset, &tmp_val);
>  		*val += tmp_val;
>  	}
>  	mutex_unlock(&kvm_lock);
> @@ -4181,15 +4184,13 @@ static int vcpu_stat_clear(void *_offset, u64 val)
>  {
>  	unsigned offset = (long)_offset;
>  	struct kvm *kvm;
> -	struct kvm_stat_data stat_tmp = {.offset = offset};
>  
>  	if (val)
>  		return -EINVAL;
>  
>  	mutex_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> -		stat_tmp.kvm = kvm;
> -		vcpu_stat_clear_per_vm((void *)&stat_tmp, 0);
> +		kvm_clear_stat_per_vcpu(kvm, offset);
>  	}
>  	mutex_unlock(&kvm_lock);
>  
> @@ -4262,9 +4263,8 @@ static void kvm_init_debug(void)
>  
>  	kvm_debugfs_num_entries = 0;
>  	for (p = debugfs_entries; p->name; ++p, kvm_debugfs_num_entries++) {
> -		int mode = p->mode ? p->mode : 0644;
> -		debugfs_create_file(p->name, mode, kvm_debugfs_dir,
> -				    (void *)(long)p->offset,
> +		debugfs_create_file(p->name, KVM_DBGFS_GET_MODE(p),
> +				    kvm_debugfs_dir, (void *)(long)p->offset,
>  				    stat_fops[p->kind]);
>  	}
>  }
> 

