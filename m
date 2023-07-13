Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B9C752CB4
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 00:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjGMWD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 18:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjGMWD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 18:03:58 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02B126B7
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 15:03:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8af49a5d2so8715105ad.2
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 15:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689285836; x=1691877836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZzFbjTUKfvtg9IK6V6Q6qdE4DKqEmkmxRE0+kAvIJJc=;
        b=ooPU8phvp1E+dELkGdoFhSzDtDE8YZ55ffTywH58Vi8FSZxwM4RT2FbNyoO1BRxaio
         lX8CW3VYAi2vduxGvn7dWcmO+UOuXBnFIpNy17+gypv+Pr7ApdmPhrngOgtwI4RmzkSd
         iwZ5zXmDS2+JAeCeCl2H92KB87W4rsHRHHYJZE3kH6hgM+9qXF7V9ommIt54PIGeV3Em
         YdhEeLe/NPY0wZ6m/LAKLQDA5G6Ub8XVrRxf4TChH3WRdiU5B3E97JcTOhGahE1KcbGb
         rk5UW+6Y2PopGpUVvZZyg5Ta2V2NP8dycatOplwk+Y2O5wWZaMJ3ngX+sjjcj2RQqCjS
         Ot4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689285836; x=1691877836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZzFbjTUKfvtg9IK6V6Q6qdE4DKqEmkmxRE0+kAvIJJc=;
        b=hqXJ3KxV18jeGJokxQ2t8QgUool+2mF1Ao+g7ICQZiVPQ0YFFox9rhfR8EihqXHUpQ
         r8i2FZhu80Hz2Zdq9IPCoVDC7qjfKBDR9u1Oa96NcQkjqYPzXLRGic+UCfAEyOMwS9Qb
         FeLxxBSgk3MnYncycDV/2zJnz9S1k8v9/SjybdBpIEs02QauWm89ZqfM6YEVzn9iNxp1
         qCbR+x++vPx6GnjRJxcjGNfyDfbecYwBUl3P1Wq3FAu28WMtqiF1TMKCtKjQn5Gq54Gh
         qmAjCUBJxL9g/TPQDKTKeSwIOBTfLGTd0lSN4dfK0LWH76xd8FN/NI856+qRj4baBj1J
         BPuw==
X-Gm-Message-State: ABy/qLbBzrF+lBg0OS1uJlK12p1DYovAkqVRvFJaifkgN3H+253H/JVn
        KxU2uEbSyGE5jABmxkA4rlWCN+9YpoQ=
X-Google-Smtp-Source: APBJJlHsGVlZCRJkBgCAhvsTKbRLQYCXoORPGHs0vaqb/OclkGLJ58hCGkydkfW0vvf9K7hic6wlAzTb28U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:70c9:b0:1b8:b7fc:9aa1 with SMTP id
 l9-20020a17090270c900b001b8b7fc9aa1mr8957plt.1.1689285836408; Thu, 13 Jul
 2023 15:03:56 -0700 (PDT)
Date:   Thu, 13 Jul 2023 15:03:54 -0700
In-Reply-To: <358fb191b3690a5cbc2c985d3ffc67224df11cf3.1687991811.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1687991811.git.isaku.yamahata@intel.com> <358fb191b3690a5cbc2c985d3ffc67224df11cf3.1687991811.git.isaku.yamahata@intel.com>
Message-ID: <ZLB0ytO7y4NOLWpL@google.com>
Subject: Re: [RFC PATCH v3 08/11] KVM: Fix set_mem_attr ioctl when error case
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> kvm_vm_ioctl_set_mem_attributes() discarded an error code of xa_err()
> unconditionally.  If an error occurred at the beginning, return error.
> 
> Fixes: 3779c214835b ("KVM: Introduce per-page memory attributes")
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> Changes v2 -> v3:
> - Newly added
> ---
>  virt/kvm/kvm_main.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 422d49634c56..fdef56f85174 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2423,6 +2423,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  	gfn_t start, end;
>  	unsigned long i;
>  	void *entry;
> +	int err = 0;
>  
>  	/* flags is currently not used. */
>  	if (attrs->flags)
> @@ -2447,14 +2448,17 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  	KVM_MMU_UNLOCK(kvm);
>  
>  	for (i = start; i < end; i++) {
> -		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> -				    GFP_KERNEL_ACCOUNT)))
> +		err = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> +				      GFP_KERNEL_ACCOUNT));
> +		if (err)
>  			break;
>  	}
>  
>  	KVM_MMU_LOCK(kvm);
> -	if (i > start)
> +	if (i > start) {
> +		err = 0;
>  		kvm_mem_attrs_changed(kvm, attrs->attributes, start, i);
> +	}
>  	kvm_mmu_invalidate_end(kvm);
>  	KVM_MMU_UNLOCK(kvm);
>  
> @@ -2463,7 +2467,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  	attrs->address = i << PAGE_SHIFT;
>  	attrs->size = (end - i) << PAGE_SHIFT;
>  
> -	return 0;
> +	return err;

Aha!  Idea (stolen from commit afb2acb2e3a3 ("KVM: Fix vcpu_array[0] races")).
Rather than deal with a potential error partway through the updates, reserve all
xarray entries head of time.  That way the ioctl() is all-or-nothing, e.g. KVM
doesn't need to update the address+size to capture progress, and userspace doesn't
have to retry (which is probably pointless anyways since failure to allocate an
xarray entry likely means the system/cgroup is under intense memory pressure).

Assuming it works (compile tested only), I'll squash this:

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 46fbb4e019a6..8cb972038dab 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2278,7 +2278,7 @@ struct kvm_s390_zpci_op {
 
 /* Available with KVM_CAP_MEMORY_ATTRIBUTES */
 #define KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES    _IOR(KVMIO,  0xd2, __u64)
-#define KVM_SET_MEMORY_ATTRIBUTES              _IOWR(KVMIO,  0xd3, struct kvm_memory_attributes)
+#define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd3, struct kvm_memory_attributes)
 
 struct kvm_memory_attributes {
        __u64 address;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9584491c0cd3..93e82e3f1e1f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2425,6 +2425,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
        gfn_t start, end;
        unsigned long i;
        void *entry;
+       int r;
 
        /* flags is currently not used. */
        if (attrs->flags)
@@ -2439,18 +2440,32 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
        start = attrs->address >> PAGE_SHIFT;
        end = (attrs->address + attrs->size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
 
+       if (WARN_ON_ONCE(start == end))
+               return -EINVAL;
+
        entry = attrs->attributes ? xa_mk_value(attrs->attributes) : NULL;
 
        mutex_lock(&kvm->slots_lock);
 
+       /*
+        * Reserve memory ahead of time to avoid having to deal with failures
+        * partway through setting the new attributes.
+        */
+       for (i = start; i < end; i++) {
+               r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
+               if (r)
+                       goto out_unlock;
+       }
+
        KVM_MMU_LOCK(kvm);
        kvm_mmu_invalidate_begin(kvm);
        kvm_mmu_invalidate_range_add(kvm, start, end);
        KVM_MMU_UNLOCK(kvm);
 
        for (i = start; i < end; i++) {
-               if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
-                                   GFP_KERNEL_ACCOUNT)))
+               r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
+                                   GFP_KERNEL_ACCOUNT));
+               if (KVM_BUG_ON(r, kvm))
                        break;
        }
 
@@ -2460,12 +2475,10 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
        kvm_mmu_invalidate_end(kvm);
        KVM_MMU_UNLOCK(kvm);
 
+out_unlock:
        mutex_unlock(&kvm->slots_lock);
 
-       attrs->address = i << PAGE_SHIFT;
-       attrs->size = (end - i) << PAGE_SHIFT;
-
-       return 0;
+       return r;
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
@@ -5078,9 +5091,6 @@ static long kvm_vm_ioctl(struct file *filp,
                        goto out;
 
                r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
-
-               if (!r && copy_to_user(argp, &attrs, sizeof(attrs)))
-                       r = -EFAULT;
                break;
        }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */

