Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B29E3DDC5C
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 17:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhHBPZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 11:25:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234754AbhHBPZ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 11:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627917917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xftexRmGJH8/1M/pkzb30LS03dbVSEsqIX9DeZUf7y0=;
        b=BaMUHdL5E7bCeWbd0tmr+3SqJE9z1MC7765xgLdDTbfsQ9pqipeqOXK7MovbEFZFhpA0Ke
        W5A8dtmErwvUPEy+SrGjBPEAsghrIz8fnii194GCXEWi28/U0ojdklAMu+wNWms3nzvkS1
        xlKRGxbiV/jllNWgbgt18VUrRePlciY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-_66L0CsvOsa4U0IOwVG1Bg-1; Mon, 02 Aug 2021 11:25:16 -0400
X-MC-Unique: _66L0CsvOsa4U0IOwVG1Bg-1
Received: by mail-wm1-f69.google.com with SMTP id e21-20020a05600c4b95b029025b007a168dso906224wmp.4
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 08:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xftexRmGJH8/1M/pkzb30LS03dbVSEsqIX9DeZUf7y0=;
        b=sYVTmINHsLO/9Gw2sD5Idaoo0Mk/i9rRI7goybIRpTfKQIAEhhMkWCXZMgMhdwyT/s
         K8BybHvPVWBbHqop43UOcirwDto+OykSM0nX3o39Eqs+Ss69Y2vWjeiYtxZpeO9Yf8Ew
         Y1C4Ml0JhbAMxd4czDN5M+JMkLWNyE4DsgA9qYpacOIElRqhvlO1tLJulYqgcQO+tVRW
         xNRA9vvgDtn//1xPz+L0EvLmW5kK/Sz/uqtbQaDuzOTO7o3EBwE9Xa/BL0j5lvjZBu3s
         zUwzGTTiXiEUveVnjJdaJyt/E1WI0HsLK1eyhpTg/MbXlCiVDq3G76shfhEEXWRH/bV/
         6hwQ==
X-Gm-Message-State: AOAM531KHh2/E8RNr+mPvAXTktPYUNSt1zxF1kpDo4uWSdknETavaKOv
        fuchc66rlW8kGAPR+U/CqUocH6ehxS1LLEFnAOfK8EqVR3OLjqu30eF6TcRqcte2YqwZmBnjBsK
        lvvrW+MmPysR2
X-Received: by 2002:adf:f550:: with SMTP id j16mr17963068wrp.91.1627917914731;
        Mon, 02 Aug 2021 08:25:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9Fi4IxIqrXQ8Q59sUryuPklM/kVQ/ol76fUwEbKaqHpLrnllMncmn29lBNyvRUD+Yy3rDYw==
X-Received: by 2002:adf:f550:: with SMTP id j16mr17963049wrp.91.1627917914542;
        Mon, 02 Aug 2021 08:25:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 19sm4293972wmj.48.2021.08.02.08.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 08:25:13 -0700 (PDT)
Subject: Re: [PATCH v3 4/7] KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs
 file
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210730220455.26054-1-peterx@redhat.com>
 <20210730220455.26054-5-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8964c91d-761f-8fd4-e8c6-f85d6e318a45@redhat.com>
Date:   Mon, 2 Aug 2021 17:25:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730220455.26054-5-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/21 00:04, Peter Xu wrote:
> Use this file to dump rmap statistic information.  The statistic is done by
> calculating the rmap count and the result is log-2-based.
> 
> An example output of this looks like (idle 6GB guest, right after boot linux):
> 
> Rmap_Count:     0       1       2-3     4-7     8-15    16-31   32-63   64-127  128-255 256-511 512-1023
> Level=4K:       3086676 53045   12330   1272    502     121     76      2       0       0       0
> Level=2M:       5947    231     0       0       0       0       0       0       0       0       0
> Level=1G:       32      0       0       0       0       0       0       0       0       0       0
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   arch/x86/kvm/x86.c | 113 +++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 113 insertions(+)

This should be in debugfs.c, meaning that the kvm_mmu_slot_lpages() must 
be in a header.  I think mmu.h should do, let me take a look and I can 
post myself a v4 of these debugfs parts.

Paolo

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e44d8f7781b6..0877340dc6ff 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -30,6 +30,7 @@
>   #include "hyperv.h"
>   #include "lapic.h"
>   #include "xen.h"
> +#include "mmu/mmu_internal.h"
>   
>   #include <linux/clocksource.h>
>   #include <linux/interrupt.h>
> @@ -59,6 +60,7 @@
>   #include <linux/mem_encrypt.h>
>   #include <linux/entry-kvm.h>
>   #include <linux/suspend.h>
> +#include <linux/debugfs.h>
>   
>   #include <trace/events/kvm.h>
>   
> @@ -11193,6 +11195,117 @@ int kvm_arch_post_init_vm(struct kvm *kvm)
>   	return kvm_mmu_post_init_vm(kvm);
>   }
>   
> +/*
> + * This covers statistics <1024 (11=log(1024)+1), which should be enough to
> + * cover RMAP_RECYCLE_THRESHOLD.
> + */
> +#define  RMAP_LOG_SIZE  11
> +
> +static const char *kvm_lpage_str[KVM_NR_PAGE_SIZES] = { "4K", "2M", "1G" };
> +
> +static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
> +{
> +	struct kvm_rmap_head *rmap;
> +	struct kvm *kvm = m->private;
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	unsigned int lpage_size, index;
> +	/* Still small enough to be on the stack */
> +	unsigned int *log[KVM_NR_PAGE_SIZES], *cur;
> +	int i, j, k, l, ret;
> +
> +	memset(log, 0, sizeof(log));
> +
> +	ret = -ENOMEM;
> +	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
> +		log[i] = kzalloc(RMAP_LOG_SIZE * sizeof(unsigned int), GFP_KERNEL);
> +		if (!log[i])
> +			goto out;
> +	}
> +
> +	mutex_lock(&kvm->slots_lock);
> +	write_lock(&kvm->mmu_lock);
> +
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		slots = __kvm_memslots(kvm, i);
> +		for (j = 0; j < slots->used_slots; j++) {
> +			slot = &slots->memslots[j];
> +			for (k = 0; k < KVM_NR_PAGE_SIZES; k++) {
> +				rmap = slot->arch.rmap[k];
> +				lpage_size = kvm_mmu_slot_lpages(slot, k + 1);
> +				cur = log[k];
> +				for (l = 0; l < lpage_size; l++) {
> +					index = ffs(pte_list_count(&rmap[l]));
> +					if (WARN_ON_ONCE(index >= RMAP_LOG_SIZE))
> +						index = RMAP_LOG_SIZE - 1;
> +					cur[index]++;
> +				}
> +			}
> +		}
> +	}
> +
> +	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	/* index=0 counts no rmap; index=1 counts 1 rmap */
> +	seq_printf(m, "Rmap_Count:\t0\t1\t");
> +	for (i = 2; i < RMAP_LOG_SIZE; i++) {
> +		j = 1 << (i - 1);
> +		k = (1 << i) - 1;
> +		seq_printf(m, "%d-%d\t", j, k);
> +	}
> +	seq_printf(m, "\n");
> +
> +	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
> +		seq_printf(m, "Level=%s:\t", kvm_lpage_str[i]);
> +		cur = log[i];
> +		for (j = 0; j < RMAP_LOG_SIZE; j++)
> +			seq_printf(m, "%d\t", cur[j]);
> +		seq_printf(m, "\n");
> +	}
> +
> +	ret = 0;
> +out:
> +	for (i = 0; i < KVM_NR_PAGE_SIZES; i++)
> +		if (log[i])
> +			kfree(log[i]);
> +
> +	return ret;
> +}
> +
> +static int kvm_mmu_rmaps_stat_open(struct inode *inode, struct file *file)
> +{
> +	struct kvm *kvm = inode->i_private;
> +
> +	if (!kvm_get_kvm_safe(kvm))
> +		return -ENOENT;
> +
> +	return single_open(file, kvm_mmu_rmaps_stat_show, kvm);
> +}
> +
> +static int kvm_mmu_rmaps_stat_release(struct inode *inode, struct file *file)
> +{
> +	struct kvm *kvm = inode->i_private;
> +
> +	kvm_put_kvm(kvm);
> +
> +	return single_release(inode, file);
> +}
> +
> +static const struct file_operations mmu_rmaps_stat_fops = {
> +	.open		= kvm_mmu_rmaps_stat_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= kvm_mmu_rmaps_stat_release,
> +};
> +
> +int kvm_arch_create_vm_debugfs(struct kvm *kvm)
> +{
> +	debugfs_create_file("mmu_rmaps_stat", 0644, kvm->debugfs_dentry, kvm,
> +			    &mmu_rmaps_stat_fops);
> +	return 0;
> +}
> +
>   static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
>   {
>   	vcpu_load(vcpu);
> 

