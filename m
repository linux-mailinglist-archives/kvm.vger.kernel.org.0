Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D1935D441
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344225AbhDMAFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243321AbhDMAE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:04:59 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0A6C06175F
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:04:40 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id 6so12606691ilt.9
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+OQdtZxsQyvO3nm0SGxHYUM1RYw+EQP6aqSBPHNZGl0=;
        b=eDaQLfyq81OEGi82RdxLfq8BWq/m46x7z/phYKQJzVD8aAEsOqYW9b/chAWdXaNqVy
         q60N8L2763d3RuzIMnSdERgep7oJPuUofXlCUiEZwzrl7eCL2yJPZmfB+qxPUuscisA9
         6N5zXajDte3yIgV6Udih6TaKkDwjjGMBrPvSH6OZTK/LeGdVKsgco2uzdlUTzhTZkBRi
         KDBCYUD2GMdfQk3IOwlLn37keA7LmBuyta+jDgbHNSdI/h0QDRGU5Pj+Z2OCZM+IatKP
         OmR0wbUXdy+QGC3SlA55AZAKiTj/uLNdQt5uKfKMJLHNOJxlqHSkKkNEOpmFg13WXh0a
         +BDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+OQdtZxsQyvO3nm0SGxHYUM1RYw+EQP6aqSBPHNZGl0=;
        b=d6WY73z1xngPG1JI3NS393imLyayDZR4gSDmW92DfjVyhYcQBqzmsCGT6mFB5rJNtK
         ITK+R+RavQPn8LZj0X3AcVhRCcpBhCXGp4U8XVWuHmNJZ5S/N5hOzSXKUdQNkIleZj7t
         Dt4OS+RsdJsQpEgE6Ngpwd4W1+x9wOhcbX5V/juvLSi28q0XVTN57u+sOdW0aOTI1+4J
         ppcr46dVQIYHbom2cvedTrk0NMgMQOjJoye2YU0ChRFde7GOM0/bLmEGtvr4kKLzoR6u
         438r9J+VDfJE42752kKpjyF0Vq9AXeBQBZmH1HK/ZGqXc5Z+PkCxAAIJQl92il0s1eZm
         7r9A==
X-Gm-Message-State: AOAM53112eeUe4TmJ/+fhMjAAg69KLQ5JI+w7YtTXI50FqcQAJjKjxDU
        DCTkSi3Bbc86UFSyKGCFGwhaFyNHH9TaCcrlQESGyA==
X-Google-Smtp-Source: ABdhPJxuABDyeM+gQOGSyy0PjjB/7iX/1lLquOIYANJLTcbwVTrfZAKTeKerZMsxQQI5jUjC5HMmVWfsO1mp5FYtkG0=
X-Received: by 2002:a05:6e02:1c07:: with SMTP id l7mr18267543ilh.110.1618272279969;
 Mon, 12 Apr 2021 17:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <c5d0e3e719db7bb37ea85d79ed4db52e9da06257.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <c5d0e3e719db7bb37ea85d79ed4db52e9da06257.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:04:03 -0700
Message-ID: <CABayD+dvmnZeE4FgKqYhCwc-eo0XgzyeaKwmGiB=XMUOO5VZDQ@mail.gmail.com>
Subject: Re: [PATCH v12 05/13] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:44 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The command is used for copying the incoming buffer into the
> SEV guest memory space.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        | 24 ++++++
>  arch/x86/kvm/svm/sev.c                        | 79 +++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  9 +++
>  3 files changed, 112 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index c86c1ded8dd8..c6ed5b26d841 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -372,6 +372,30 @@ On success, the 'handle' field contains a new handle and on error, a negative va
>
>  For more details, see SEV spec Section 6.12.
>
> +14. KVM_SEV_RECEIVE_UPDATE_DATA
> +----------------------------
> +
> +The KVM_SEV_RECEIVE_UPDATE_DATA command can be used by the hypervisor to copy
> +the incoming buffers into the guest memory region with encryption context
> +created during the KVM_SEV_RECEIVE_START.
> +
> +Parameters (in): struct kvm_sev_receive_update_data
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_launch_receive_update_data {
> +                __u64 hdr_uaddr;        /* userspace address containing the packet header */
> +                __u32 hdr_len;
> +
> +                __u64 guest_uaddr;      /* the destination guest memory region */
> +                __u32 guest_len;
> +
> +                __u64 trans_uaddr;      /* the incoming buffer memory region  */
> +                __u32 trans_len;
> +        };
> +
>  References
>  ==========
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e530c2b34b5e..2c95657cc9bf 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1448,6 +1448,82 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct kvm_sev_receive_update_data params;
> +       struct sev_data_receive_update_data *data;
> +       void *hdr = NULL, *trans = NULL;
> +       struct page **guest_page;
> +       unsigned long n;
> +       int ret, offset;
> +
> +       if (!sev_guest(kvm))
> +               return -EINVAL;
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +                       sizeof(struct kvm_sev_receive_update_data)))
> +               return -EFAULT;
> +
> +       if (!params.hdr_uaddr || !params.hdr_len ||
> +           !params.guest_uaddr || !params.guest_len ||
> +           !params.trans_uaddr || !params.trans_len)
> +               return -EINVAL;
> +
> +       /* Check if we are crossing the page boundary */
> +       offset = params.guest_uaddr & (PAGE_SIZE - 1);
> +       if ((params.guest_len + offset > PAGE_SIZE))
> +               return -EINVAL;
> +
> +       hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
> +       if (IS_ERR(hdr))
> +               return PTR_ERR(hdr);
> +
> +       trans = psp_copy_user_blob(params.trans_uaddr, params.trans_len);
> +       if (IS_ERR(trans)) {
> +               ret = PTR_ERR(trans);
> +               goto e_free_hdr;
> +       }
> +
> +       ret = -ENOMEM;
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               goto e_free_trans;
> +
> +       data->hdr_address = __psp_pa(hdr);
> +       data->hdr_len = params.hdr_len;
> +       data->trans_address = __psp_pa(trans);
> +       data->trans_len = params.trans_len;
> +
> +       /* Pin guest memory */
> +       ret = -EFAULT;
> +       guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
> +                                   PAGE_SIZE, &n, 0);
> +       if (!guest_page)
> +               goto e_free;
> +
> +       /* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
> +       data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
> +                               offset;
> +       data->guest_address |= sev_me_mask;
> +       data->guest_len = params.guest_len;
> +       data->handle = sev->handle;
> +
> +       ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, data,
> +                               &argp->error);
> +
> +       sev_unpin_memory(kvm, guest_page, n);
> +
> +e_free:
> +       kfree(data);
> +e_free_trans:
> +       kfree(trans);
> +e_free_hdr:
> +       kfree(hdr);
> +
> +       return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -1513,6 +1589,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_RECEIVE_START:
>                 r = sev_receive_start(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_RECEIVE_UPDATE_DATA:
> +               r = sev_receive_update_data(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 29c25e641a0c..3a656d43fc6c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1759,6 +1759,15 @@ struct kvm_sev_receive_start {
>         __u32 session_len;
>  };
>
> +struct kvm_sev_receive_update_data {
> +       __u64 hdr_uaddr;
> +       __u32 hdr_len;
> +       __u64 guest_uaddr;
> +       __u32 guest_len;
> +       __u64 trans_uaddr;
> +       __u32 trans_len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.17.1
>
Reviewed-by: Steve Rutherford <srutherford@google.com>
