Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC48E3E0ADC
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 01:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhHDXcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 19:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhHDXcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 19:32:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B3BC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 16:32:39 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso2142023pjb.5
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 16:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GEY4fD5yTtVusES2V+7/qwef8O+lrHGgZiJ82DRI4is=;
        b=pENPHCeWlybJ/Gyfy/Z7Xbe3eT93GtA9t2uWVRxUNQxn4KGEzyD9YcUuCzJfPS0jrA
         mio41gsj9MCTJyqcXM9t/n8Qvg069nCIgSpdwikHsXK1AcWu7Eh6HHRtoOkdhnn28tQd
         mixHw9vUuoAkxuJ7W7WBt1/liaSBrn5c4t/V0HBTKQ3LMkelmNo/OzU704pxAgSvW8pd
         RvJLTxeS75u+bfoIhE3hTAySJ2QAQVfH0eACY3CG5MHW8hvJWEl1zZ56BTjU5SjLSCrm
         aOWIgorySwKKk2lKMTC98BolnOuy8pIvQy9f5xgWtOgndrmIC4UUfLBhx0dHRq0JYIJ4
         OcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GEY4fD5yTtVusES2V+7/qwef8O+lrHGgZiJ82DRI4is=;
        b=ACUFixtjleVl9LRnbA8wO+6tqBr4C7JPgthQL1uLvNHQLD6ruhEwBdTVwHpABGNuQK
         ngXXs+U9p2f9jYFiQ5B5sbKvuaZy986XvkFe2UWYAF/R4751Y1G+suAU9LR/CXpmmEz2
         DBJqEJ17iCG01MCndvRia9guLgZQ2tKvAyNWYyBIx928g5eZTT8gD1vDwaE60CQedWqc
         46zA+U1mOUSpgLB8RxPV0hir3Q41OxTkrVsWTbGjtfN5xJfMU/8swk1AbC6MYW3tOuSU
         0HbnMkEXQB9qRi0iieWj4boQIW7Bt6o9HnlYqsSP14LzcnZ7l7im4fqDcPga3pVkc/Kj
         6+9g==
X-Gm-Message-State: AOAM532Rbn1/0X/yKglftUzQ+k3opFRw6WsYpZCDdSFAtro6A5DWVaRJ
        u2+1EsDBD5LpCrZd05XiUu18ZQ==
X-Google-Smtp-Source: ABdhPJwnbTS+0bG3I6EnW4W3vEGyG2Q4iA2qU4Eg1E7Yz9wu7YS2PtXANua1GayLt/mJbDKRrO3poQ==
X-Received: by 2002:a17:902:f704:b029:11a:cdee:490 with SMTP id h4-20020a170902f704b029011acdee0490mr1360703plo.37.1628119959237;
        Wed, 04 Aug 2021 16:32:39 -0700 (PDT)
Received: from [192.168.10.153] (219-90-184-65.ip.adam.com.au. [219.90.184.65])
        by smtp.gmail.com with UTF8SMTPSA id m16sm7400791pjz.30.2021.08.04.16.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 16:32:38 -0700 (PDT)
Message-ID: <05ade6a2-2eb4-89c2-7c6e-651c8c53c6f6@ozlabs.ru>
Date:   Thu, 5 Aug 2021 09:32:33 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:90.0) Gecko/20100101
 Thunderbird/90.0
Subject: Re: [PATCH] KVM: Do not leak memory for duplicate debugfs directories
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210804093737.2536206-1-pbonzini@redhat.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210804093737.2536206-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04/08/2021 19:37, Paolo Bonzini wrote:
> KVM creates a debugfs directory for each VM in order to store statistics
> about the virtual machine.  The directory name is built from the process
> pid and a VM fd.  While generally unique, it is possible to keep a
> file descriptor alive in a way that causes duplicate directories, which
> manifests as these messages:
> 
>    [  471.846235] debugfs: Directory '20245-4' with parent 'kvm' already present!
> 
> Even though this should not happen in practice, it is more or less
> expected in the case of KVM for testcases that call KVM_CREATE_VM and
> close the resulting file descriptor repeatedly and in parallel.
> 
> When this happens, debugfs_create_dir() returns an error but
> kvm_create_vm_debugfs() goes on to allocate stat data structs which are
> later leaked. 

Rather the already allocated srructs leak, no?

> The slow memory leak was spotted by syzkaller, where it
> caused OOM reports.

I gave it a try and almost replied with "tested-by" but after running it 
over night I got 1 of these with followed OOM:

[ 1104.951394][  T544] debugfs: Directory '544-4' with parent 'kvm' 
already present!
[ 1104.951600][  T544] Failed to create 544-4

This is definitely an improvement as this used to happen a few times 
every hour but still puzzling :-/

> 
> Since the issue only affects debugfs, do a lookup before calling
> debugfs_create_dir, so that the message is downgraded and rate-limited.
> While at it, ensure kvm->debugfs_dentry is NULL rather than an error
> if it is not created.  This fixes kvm_destroy_vm_debugfs, which was not
> checking IS_ERR_OR_NULL correctly.
> 
> Cc: stable@vger.kernel.org
> Fixes: 536a6f88c49d ("KVM: Create debugfs dir and stat files for each VM")
> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   virt/kvm/kvm_main.c | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d20fba0fc290..b50dbe269f4b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -892,6 +892,8 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
>   
>   static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>   {
> +	static DEFINE_MUTEX(kvm_debugfs_lock);
> +	struct dentry *dent;
>   	char dir_name[ITOA_MAX_LEN * 2];
>   	struct kvm_stat_data *stat_data;
>   	const struct _kvm_stats_desc *pdesc;
> @@ -903,8 +905,20 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>   		return 0;
>   
>   	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
> -	kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
> +	mutex_lock(&kvm_debugfs_lock);
> +	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
> +	if (dent) {
> +		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
> +		dput(dent);
> +		mutex_unlock(&kvm_debugfs_lock);
> +		return 0;
> +	}
> +	dent = debugfs_create_dir(dir_name, kvm_debugfs_dir);
> +	mutex_unlock(&kvm_debugfs_lock);
> +	if (IS_ERR(dent))
> +		return 0;
>   
> +	kvm->debugfs_dentry = dent;
>   	kvm->debugfs_stat_data = kcalloc(kvm_debugfs_num_entries,
>   					 sizeof(*kvm->debugfs_stat_data),
>   					 GFP_KERNEL_ACCOUNT);
> @@ -5201,7 +5215,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
>   	}
>   	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
>   
> -	if (!IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
> +	if (kvm->debugfs_dentry) {
>   		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
>   
>   		if (p) {
> 

-- 
Alexey
