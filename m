Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852AA484FC4
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 10:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiAEJHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 04:07:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238744AbiAEJHU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 04:07:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641373639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zLHo5gatlAz4K5AXtvrHLogJItKyAj7DCmCIcRo2WqU=;
        b=GEy8phPLgGQf9Y4ACk3dB4KYdNwWxo4AolROSFGFPBB90h1+bnoGxxSEHv7NHm8Lpksfqb
        DLeOuOxT2K8ov7NBgBstVT/t69IFArRFAS5jYJR/8pdpF2ZF3tWGQsshE3Xf75yXImU7xF
        NLlkWQ87SkWeVs4f+FQuiYRvDUnd1tk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-e6VWKPqxMRC-pYukfZT2Zg-1; Wed, 05 Jan 2022 04:07:18 -0500
X-MC-Unique: e6VWKPqxMRC-pYukfZT2Zg-1
Received: by mail-pj1-f71.google.com with SMTP id f11-20020a17090a664b00b001b0fbffc9d6so25882449pjm.1
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 01:07:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zLHo5gatlAz4K5AXtvrHLogJItKyAj7DCmCIcRo2WqU=;
        b=ioydxatSlZ0gqPEmbb05It3CKIBbQ/SoqAiqzSscGgTdLKSM3fOPF6VGJMiDinzKmQ
         HUx9Qmil0JojBG67UFrz+G0tL6enJSPhZdyTL6dmVBOFaPb1gr4odH/NgF3TTsRRaxEG
         wwz0uCvUK3377miumzlyndQ8quUFco9hQpobyCrIWAwKyWECcU7k47KKjsAe6U4ep927
         LwuVuOe1Qu/5ojzFXBcWem/mwzOUVap98ZDPFtoBpISMZCMV8f4KpNejIUdkCH6mVw1S
         QHn6Y6XoXlUrrlMj9sMTgUWm1hqAsmUyub23bMDaD1Eg931dzl57ZzVMjwEw1owkuqJH
         WRzg==
X-Gm-Message-State: AOAM531lkupMWkilYINRtUty/1UZ+nfUU+DOT4M1GYSIFuvxTSv3PCzb
        IvkMd8El/GYXD4LL/4So/uECSExCs3pUQu/Ag1QWpJOqS6oi5TZjtAp3w4CM+D+XHH9WEaK7S/1
        Kp1O06Nyfp9QR
X-Received: by 2002:a17:90a:ff17:: with SMTP id ce23mr2935543pjb.164.1641373636638;
        Wed, 05 Jan 2022 01:07:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygM2moouakshCbTCfB6/j7aKotwHT4x7eDd+T3cw/smwNCpvmGYdchc35/8RBcj8F/v0HOrQ==
X-Received: by 2002:a17:90a:ff17:: with SMTP id ce23mr2935527pjb.164.1641373636403;
        Wed, 05 Jan 2022 01:07:16 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id g5sm47343621pfj.143.2022.01.05.01.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 01:07:15 -0800 (PST)
Date:   Wed, 5 Jan 2022 17:07:10 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vasant.hegde@amd.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2] KVM: x86: Check for rmaps allocation
Message-ID: <YdVfvp2Pw6JUR61K@xz-m1.local>
References: <20220105040337.4234-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220105040337.4234-1-nikunj@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 09:33:37AM +0530, Nikunj A Dadhania wrote:
> With TDP MMU being the default now, access to mmu_rmaps_stat debugfs
> file causes following oops:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 7 PID: 3185 Comm: cat Not tainted 5.16.0-rc4+ #204
> RIP: 0010:pte_list_count+0x6/0x40
>  Call Trace:
>   <TASK>
>   ? kvm_mmu_rmaps_stat_show+0x15e/0x320
>   seq_read_iter+0x126/0x4b0
>   ? aa_file_perm+0x124/0x490
>   seq_read+0xf5/0x140
>   full_proxy_read+0x5c/0x80
>   vfs_read+0x9f/0x1a0
>   ksys_read+0x67/0xe0
>   __x64_sys_read+0x19/0x20
>   do_syscall_64+0x3b/0xc0
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>  RIP: 0033:0x7fca6fc13912
> 
> Return early when rmaps are not present.
> 
> Reported-by: Vasant Hegde <vasant.hegde@amd.com>
> Tested-by: Vasant Hegde <vasant.hegde@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
> 
> v1: https://lore.kernel.org/kvm/20220104092814.11553-1-nikunj@amd.com/T/#u
> 
> Check the rmaps inside kvm_mmu_rmaps_stat_show() as the rmaps can be
> allocated dynamically (Peter Xu)
> 
>  arch/x86/kvm/debugfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index 543a8c04025c..9240b3b7f8dd 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -95,6 +95,9 @@ static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
>  	unsigned int *log[KVM_NR_PAGE_SIZES], *cur;
>  	int i, j, k, l, ret;
>  
> +	if (!kvm_memslots_have_rmaps(kvm))
> +		return 0;
> +
>  	ret = -ENOMEM;
>  	memset(log, 0, sizeof(log));
>  	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
> -- 
> 2.32.0
> 

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

