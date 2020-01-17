Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87821414D6
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 00:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgAQX2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 18:28:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730135AbgAQX2v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jan 2020 18:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579303729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MjyPfkzU3dn7QHHrQzzYmC6ifUdo417MoZY6rQGGZI8=;
        b=NCWMJxmTotfft2uczm6lFvXssK1pt4v2hyF9zAnD3ma1j6fHwKYEgQNTrKpGlAlKE4WDBY
        m3JVKbcEYHHLs6UcLF/dbFY/zw/2sBJkGo0Mez18Umr1kuwQszSKLcNebj730qjk+FXwaB
        LcKzggeTPsT/i1xmJk1oRuJQoTN3NI4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-7MFSskqUO06KCn8XjKvYHQ-1; Fri, 17 Jan 2020 18:28:48 -0500
X-MC-Unique: 7MFSskqUO06KCn8XjKvYHQ-1
Received: by mail-wr1-f69.google.com with SMTP id r2so11105114wrp.7
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 15:28:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MjyPfkzU3dn7QHHrQzzYmC6ifUdo417MoZY6rQGGZI8=;
        b=Hc36EGbVLKBsp+vJT7I4V/iEa+ulz3pFLUZr8wdzOjcXM7syjvClGgdOdXYm+brr4q
         0DHpTPCUjZVK5/DIzZFRr4p6FY9buveomv1TqIAp57Fand+fWABhd5CCVDmRSFMZ4IN0
         BO9PnheC7YgwKjqY758uF4KwqRJyUte77kHSlO5KWg7uAbm/0LRvv9UEg0+7B9Ptu8Az
         a9PC8hT1bE/8h3uVQ0H0xI7fxFq2xoVqd+S7JvEdoaKDEHRuGZd+aTgmKgEFQ2ghbZNZ
         CNLOQdH0xKsnB0yJe+nxvhnwCib9MEgUZBJLrh7lgkXhu1CJd5CVCyY6/SpQEF+o/nav
         R6NA==
X-Gm-Message-State: APjAAAWaWhYdhu/18UeB52KruYU62GuyJbx6dpfUk5pOLGIHq4JvDP3J
        GPFoAigxNq+XY8qYGx0Mk3+2qSkJOQGqTyd9aErtQxGQ/YvXPLuGyKKSSIscEXMDcHcdFNBnQMg
        EbKuQ19xgGphO
X-Received: by 2002:adf:eb46:: with SMTP id u6mr5558628wrn.239.1579303726614;
        Fri, 17 Jan 2020 15:28:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqxnHd6bm22G1DDBmeRyT5u1n8tqKZHE3aTfRx9ji/6MdFU2l1gv+9DZE3MnBkovjWjFRoeRLQ==
X-Received: by 2002:adf:eb46:: with SMTP id u6mr5558599wrn.239.1579303726233;
        Fri, 17 Jan 2020 15:28:46 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u14sm35448021wrm.51.2020.01.17.15.28.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 15:28:45 -0800 (PST)
Subject: Re: [PATCH v5] kvm: Refactor handling of VM debugfs files
To:     Milan Pandurov <milanpa@amazon.de>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, graf@amazon.de, borntraeger@de.ibm.com
References: <20191213130721.7942-1-milanpa@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f592043-ff05-445c-2755-0aa648e35add@redhat.com>
Date:   Sat, 18 Jan 2020 00:28:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213130721.7942-1-milanpa@amazon.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 14:07, Milan Pandurov wrote:
> We can store reference to kvm_stats_debugfs_item instead of copying
> its values to kvm_stat_data.
> This allows us to remove duplicated code and usage of temporary
> kvm_stat_data inside vm_stat_get et al.
> 
> Signed-off-by: Milan Pandurov <milanpa@amazon.de>
> Reviewed-by: Alexander Graf <graf@anazon.com>
> 
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

Queued, thnaks.  Sorry for the delay.

Paolo

