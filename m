Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163823F8D56
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 19:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbhHZRwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 13:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24948 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243206AbhHZRws (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 13:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630000321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X7Lj9awqBBycYuhLJvwNIbEVGKw0TxUXZDLG3ZZOlE4=;
        b=bszAguc+j/eiOkg2rGRe3uB7/Pvz6yf9Ljxry9r+s0ncumQT153rV0gCT6CaWl1BFkgvUP
        +rOdoIvWDF9wsLAh7i9aUa+KGkv/Ze56bwlYkY172MrLu6EPBYFMwOPSSWJ/5v8XWrPVQv
        /9empju/Wau5O8VlP40RSwTgf6046HE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-MTb05pSsOVKFoc6qlN7J9A-1; Thu, 26 Aug 2021 13:51:59 -0400
X-MC-Unique: MTb05pSsOVKFoc6qlN7J9A-1
Received: by mail-wm1-f70.google.com with SMTP id r4-20020a1c4404000000b002e728beb9fbso4631233wma.9
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 10:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=X7Lj9awqBBycYuhLJvwNIbEVGKw0TxUXZDLG3ZZOlE4=;
        b=RKP9ejytpYO7W3F1ed9rmsvNeH6ZtKjiKIGswc7VULfoUxjPRiAr+YlAQsxjo2LCLl
         UTpWagr5gHAAXpyNjK12uTLjBi4ZNmBrxp/Zcw9hHxRV8/6xQ0H6p2FCuaJ4Wz8LR9KN
         vxdEFJrYwZY6d50f17c3an6WtV0VwMNxamTXyfDHbGv2uNKjWx7E7jogRvT/IEuvm+wf
         GJs5lxNELaHyh5g903SZge26RasCzuqVMrJ0PST6x7iV9OzVSmuDBwIQBUmiAfop1ce4
         OcO0KkLDExOpg0NjRHuTxa91YravekLnxgy2nq2/GlEB5Zv/am5xt4MdM5ShZGqTzxNL
         hl3w==
X-Gm-Message-State: AOAM533C6GufTE5wZYvHf2R2zkBDWztkXyjmxTNadKJfOHV0RI+KB3CM
        WZjgNFYVetQ/TN/0e1VPpQl8Q4xz0loVhMdWerNDAdII47dIJhGrGeOY9nTZSU+ilXNUi5XCZJR
        sdAdcqanN/gAS
X-Received: by 2002:adf:f08b:: with SMTP id n11mr5390007wro.176.1630000318183;
        Thu, 26 Aug 2021 10:51:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwD7w2aRqyemEnLCT6kDSf0JIriZ5aIvnRuoJzrU7tc/SP4mXvdW79F9rET9Lw32yvuidTxQ==
X-Received: by 2002:adf:f08b:: with SMTP id n11mr5389983wro.176.1630000317941;
        Thu, 26 Aug 2021 10:51:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b4sm3746452wrp.33.2021.08.26.10.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 10:51:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: Re: [PATCH v1 3/3] nitro_enclaves: Add fixes for checkpatch and
 docs reports
In-Reply-To: <20210826173451.93165-4-andraprs@amazon.com>
References: <20210826173451.93165-1-andraprs@amazon.com>
 <20210826173451.93165-4-andraprs@amazon.com>
Date:   Thu, 26 Aug 2021 19:51:56 +0200
Message-ID: <87czq0hz5v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andra Paraschiv <andraprs@amazon.com> writes:

> Fix the reported issues from checkpatch and kernel-doc scripts.
>
> Update the copyright statements to include 2021, where changes have been
> made over this year.
>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>  drivers/virt/nitro_enclaves/ne_misc_dev.c | 17 +++++++++--------
>  drivers/virt/nitro_enclaves/ne_pci_dev.c  |  2 +-
>  drivers/virt/nitro_enclaves/ne_pci_dev.h  |  8 ++++++--
>  include/uapi/linux/nitro_enclaves.h       | 10 +++++-----
>  samples/nitro_enclaves/ne_ioctl_sample.c  |  7 +++----
>  5 files changed, 24 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> index e21e1e86ad15f..8939612ee0e08 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  /**
> @@ -284,8 +284,8 @@ static int ne_setup_cpu_pool(const char *ne_cpu_list)
>  	ne_cpu_pool.nr_parent_vm_cores = nr_cpu_ids / ne_cpu_pool.nr_threads_per_core;
>  
>  	ne_cpu_pool.avail_threads_per_core = kcalloc(ne_cpu_pool.nr_parent_vm_cores,
> -					     sizeof(*ne_cpu_pool.avail_threads_per_core),
> -					     GFP_KERNEL);
> +						     sizeof(*ne_cpu_pool.avail_threads_per_core),
> +						     GFP_KERNEL);
>  	if (!ne_cpu_pool.avail_threads_per_core) {
>  		rc = -ENOMEM;
>  
> @@ -735,7 +735,7 @@ static int ne_add_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
>   * * Negative return value on failure.
>   */
>  static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
> -	struct ne_user_memory_region mem_region)
> +					   struct ne_user_memory_region mem_region)
>  {
>  	struct ne_mem_region *ne_mem_region = NULL;
>  
> @@ -771,7 +771,7 @@ static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
>  		u64 userspace_addr = ne_mem_region->userspace_addr;
>  
>  		if ((userspace_addr <= mem_region.userspace_addr &&
> -		    mem_region.userspace_addr < (userspace_addr + memory_size)) ||
> +		     mem_region.userspace_addr < (userspace_addr + memory_size)) ||
>  		    (mem_region.userspace_addr <= userspace_addr &&
>  		    (mem_region.userspace_addr + mem_region.memory_size) > userspace_addr)) {
>  			dev_err_ratelimited(ne_misc_dev.this_device,
> @@ -836,7 +836,7 @@ static int ne_sanity_check_user_mem_region_page(struct ne_enclave *ne_enclave,
>   * * Negative return value on failure.
>   */
>  static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
> -	struct ne_user_memory_region mem_region)
> +					   struct ne_user_memory_region mem_region)
>  {
>  	long gup_rc = 0;
>  	unsigned long i = 0;
> @@ -1014,7 +1014,7 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
>   * * Negative return value on failure.
>   */
>  static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
> -	struct ne_enclave_start_info *enclave_start_info)
> +				  struct ne_enclave_start_info *enclave_start_info)
>  {
>  	struct ne_pci_dev_cmd_reply cmd_reply = {};
>  	unsigned int cpu = 0;
> @@ -1574,7 +1574,8 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
>  	mutex_unlock(&ne_cpu_pool.mutex);
>  
>  	ne_enclave->threads_per_core = kcalloc(ne_enclave->nr_parent_vm_cores,
> -		sizeof(*ne_enclave->threads_per_core), GFP_KERNEL);
> +					       sizeof(*ne_enclave->threads_per_core),
> +					       GFP_KERNEL);
>  	if (!ne_enclave->threads_per_core) {
>  		rc = -ENOMEM;
>  
> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> index 143207e9b9698..40b49ec8e30b1 100644
> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  /**
> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
> index 8bfbc66078185..7bbfd39280fec 100644
> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  #ifndef _NE_PCI_DEV_H_
> @@ -84,9 +84,13 @@
>   */
>  
>  /**
> - * NE_SEND_DATA_SIZE / NE_RECV_DATA_SIZE - 240 bytes for send / recv buffer.
> + * NE_SEND_DATA_SIZE - 240 bytes for send buffer.
>   */
>  #define NE_SEND_DATA_SIZE	(240)

Nitpicking: "240 bytes for send buffer" comment looks a bit weird, it
would probably be better to just state what 'NE_SEND_DATA_SIZE' defines:

/*
 * NE_SEND_DATA_SIZE - size of the send buffer, in bytes
 */

> +
> +/**
> + * NE_RECV_DATA_SIZE - 240 bytes for recv buffer.
> + */
>  #define NE_RECV_DATA_SIZE	(240)

Ditto.

>  
>  /**
> diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
> index b945073fe544d..e808f5ba124d4 100644
> --- a/include/uapi/linux/nitro_enclaves.h
> +++ b/include/uapi/linux/nitro_enclaves.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  #ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
> @@ -60,7 +60,7 @@
>   *
>   * Context: Process context.
>   * Return:
> - * * 0					- Logic succesfully completed.
> + * * 0					- Logic successfully completed.
>   * *  -1				- There was a failure in the ioctl logic.
>   * On failure, errno is set to:
>   * * EFAULT				- copy_from_user() / copy_to_user() failure.
> @@ -95,7 +95,7 @@
>   *
>   * Context: Process context.
>   * Return:
> - * * 0				- Logic succesfully completed.
> + * * 0				- Logic successfully completed.
>   * *  -1			- There was a failure in the ioctl logic.
>   * On failure, errno is set to:
>   * * EFAULT			- copy_from_user() / copy_to_user() failure.
> @@ -118,7 +118,7 @@
>   *
>   * Context: Process context.
>   * Return:
> - * * 0					- Logic succesfully completed.
> + * * 0					- Logic successfully completed.
>   * *  -1				- There was a failure in the ioctl logic.
>   * On failure, errno is set to:
>   * * EFAULT				- copy_from_user() failure.
> @@ -161,7 +161,7 @@
>   *
>   * Context: Process context.
>   * Return:
> - * * 0					- Logic succesfully completed.
> + * * 0					- Logic successfully completed.
>   * *  -1				- There was a failure in the ioctl logic.
>   * On failure, errno is set to:
>   * * EFAULT				- copy_from_user() / copy_to_user() failure.
> diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enclaves/ne_ioctl_sample.c
> index 480b763142b34..765b131c73190 100644
> --- a/samples/nitro_enclaves/ne_ioctl_sample.c
> +++ b/samples/nitro_enclaves/ne_ioctl_sample.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  /**
> @@ -185,7 +185,6 @@ static int ne_create_vm(int ne_dev_fd, unsigned long *slot_uid, int *enclave_fd)
>  	return 0;
>  }
>  
> -
>  /**
>   * ne_poll_enclave_fd() - Thread function for polling the enclave fd.
>   * @data:	Argument provided for the polling function.
> @@ -560,8 +559,8 @@ static int ne_add_vcpu(int enclave_fd, unsigned int *vcpu_id)
>  
>  		default:
>  			printf("Error in add vcpu [%m]\n");
> -
>  		}
> +
>  		return rc;
>  	}
>  
> @@ -638,7 +637,7 @@ static int ne_start_enclave(int enclave_fd,  struct ne_enclave_start_info *encla
>  }
>  
>  /**
> - * ne_start_enclave_check_booted() - Start the enclave and wait for a hearbeat
> + * ne_start_enclave_check_booted() - Start the enclave and wait for a heartbeat
>   *				     from it, on a newly created vsock channel,
>   *				     to check it has booted.
>   * @enclave_fd :	The file descriptor associated with the enclave.

-- 
Vitaly

