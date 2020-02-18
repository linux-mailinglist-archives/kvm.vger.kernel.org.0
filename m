Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4451162D27
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBRRjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:39:15 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:44458 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgBRRjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 12:39:15 -0500
Received: by mail-vs1-f67.google.com with SMTP id p6so13235269vsj.11
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 09:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gjAA4dsULwXSrvS5rYCjWJ21iiVnnwDL3fZ8ISlNg/8=;
        b=KwW8UbbM3IM8Zx7Obd2JJJNDUwaredz96gj1ApMuey1vHZx+z3u7gXCrem0xaJiJPW
         ViyHFJqd/ax1rhRVbLMay+QcR4AL4OznI3MgZYBPKHdyEYHB32HxCeh6NjUx4LOVbG1+
         GwRQj08xxEKuWpKEB1rnoAGra+V1qjs50fuxwLNXyoCXpPjEVO8wnd7aoiGQz7KLzOTn
         RmnBw5gC/DKnWTra9p0XJvJjx8YZWByd4zxEwDAmyTSq9aeU0LzObn+Fc5eLbcotToEb
         uoB1zNVVk3oqMyn0wfjdMaj2j36xIy+CCb49d3+9M381/jV2XvMPgcVWBSf4+JW+xzU7
         PQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gjAA4dsULwXSrvS5rYCjWJ21iiVnnwDL3fZ8ISlNg/8=;
        b=n2bjv8RC8DE/Iei8cDC3XfY7Z18UIdZ0aCS5Iogzx4j3DzN/c8SG5W5j1nCGzkRHwh
         xsmdn29jWU3NumLpJDl5hjozGzUpgLTnGL4eJni7it4ftpBIq8g0ja2lEhi0cxCt0TFg
         CjeWcZpUH+LvAxSumVJgw9IM15ksQdy5ZeIs/KJY4pCXrGq5NO5TFliizZBWeshKFf+s
         hN8oX5DxWtlyGo7QIOS8HbsM5VTjDh3t0kCp3ADHSGepsGYDN+N1W4I65C8zFBLSEW+R
         ZWNWGpoUML0r7btlp9RjUK4NaHEL3k6Ix2NRr4/Ywgj/9EoHCBP3rgSkL9ssOKOnQAma
         yc/g==
X-Gm-Message-State: APjAAAXhi1atTQARXPRo6IVigjxUBgS3ks6+Ktg3d4G/uImzMsEc8xKG
        VLO1O/80gt7OWdDlxXOvGUsSOq8y4bkWkKrpHQ3WVeoz5q+s6w==
X-Google-Smtp-Source: APXvYqy+IjGE2dbt3aFf7tmpPGrUzzkA83GertH5YnwfwDLPPsKJKYQN7bnDKg8tAyRNDgajHHbLZzytN2UMVpklQNU=
X-Received: by 2002:a05:6102:2f4:: with SMTP id j20mr12174456vsj.17.1582047553847;
 Tue, 18 Feb 2020 09:39:13 -0800 (PST)
MIME-Version: 1.0
References: <20200214145920.30792-1-drjones@redhat.com> <20200214145920.30792-4-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-4-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 18 Feb 2020 09:39:02 -0800
Message-ID: <CANgfPd884HrKF+0R-SymmZrg6VbOXsRyvKxUzUiMbMB4Fq3Giw@mail.gmail.com>
Subject: Re: [PATCH 03/13] fixup! KVM: selftests: Support multiple vCPUs in
 demand paging test
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 6:59 AM Andrew Jones <drjones@redhat.com> wrote:
>
> [guest_code() can't return, use GUEST_ASSERT(). Ensure the number
>  of guests pages is compatible with the host.]
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index ec8860b70129..2e6e3db8418a 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -115,9 +115,8 @@ static void guest_code(uint32_t vcpu_id)
>         uint64_t pages;
>         int i;
>
> -       /* Return to signal error if vCPU args data structure is courrupt. */
> -       if (vcpu_args[vcpu_id].vcpu_id != vcpu_id)
> -               return;
> +       /* Make sure vCPU args data structure is not corrupt. */
> +       GUEST_ASSERT(vcpu_args[vcpu_id].vcpu_id == vcpu_id);
>
>         gva = vcpu_args[vcpu_id].gva;
>         pages = vcpu_args[vcpu_id].pages;
> @@ -186,6 +185,12 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
>         pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
>                  PTES_PER_4K_PT;
>
> +       /*
> +        * If the host is uing 64K pages, then we need the number of 4K
s/uing/using

> +        * guest pages to be a multiple of 16.
> +        */
> +       pages += 16 - pages % 16;
> +
Could we use some derivative of getpagesize() here instead?
e.g.
ASSERT(getpagesize() >= (1 << PAGE_SHIFT_4K));
ASSERT(!(getpagesize() % (1 << PAGE_SHIFT_4K)));
pages_4k_per_host_page = getpagesize() / (1 << PAGE_SHIFT_4K);
pages += pages_4k_per_host_page - pages % pages_4k_per_host_page;

>         vm = _vm_create(mode, pages, O_RDWR);
>         kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
>  #ifdef __x86_64__
> --
> 2.21.1
>
