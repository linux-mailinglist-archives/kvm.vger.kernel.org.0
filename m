Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9512B1150E2
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 14:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfLFNQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 08:16:19 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41547 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726246AbfLFNQT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 08:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575638178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CrW7Lex1+OzXVywDt0TiG68VMfO0sASp7+r8tV0WwQk=;
        b=WskA9CcDe4Hppv5mx6/C/9oChIdcUPjRd7sLJ/4wGdUWSYAGJZXHVT2P2OKnxTagF9uoNl
        6pINNrefl3vtLU+Z8hYGBpYg5HJSGpKKvl1hmqlxzO+Dcr8oCVQPJccexNgLX5LYHyA5ja
        bh5hYULJe3LfXb9FZBP5nWJqOxM00+o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-KqvuDOmVPbKyO-tDA8GWhA-1; Fri, 06 Dec 2019 08:16:15 -0500
Received: by mail-wr1-f69.google.com with SMTP id w6so3107938wrm.16
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 05:16:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CrW7Lex1+OzXVywDt0TiG68VMfO0sASp7+r8tV0WwQk=;
        b=PPcUTnjlmgg9pPTFOsf0PWpU+peRsGit/q6e+A+AHOvadadMv3YFAoFWZlWVE8mkgx
         MyRGrNDfiJyf3D9nmwJHLvqqJ91GbrNkoXrP5i7Jv61XBzlMgwjbdKX+GLAmcY32YKS8
         EreAf2NNHKxehprn3/KMnzKTp2kjaNpm4mMuuUGsU/3WpNgq/zApOXnCZpTdT+T38pbe
         3Kpa+FFiDOioWijiS6EjZi03eNBM+YOpH5JZyvAFDHugNGDqrTFtNkcDnJNaSTKGJ4ds
         DFZ79KeyeBD4JNRAiTcSQMMJ1g//Fvl6K+hmRgk4/82Ijua2uT5qqHh199uRZHcGwXT+
         gHCA==
X-Gm-Message-State: APjAAAWEMitMrGLBHWGw/9iSgkMp0u8MWRd9eV4HIfURZi3hi9n9m004
        n47SrSt6Np9bdjWvJAM1Yz8PGcbkDlVN+ruoBi9PJK3bf38HnZ2PRzOpZ0Qsbn7wFVKfrTmukDu
        P9eGEg0VNQMRl
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr15518633wrs.369.1575638174200;
        Fri, 06 Dec 2019 05:16:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDOEUrb5KBysWvt//z0FRCXLobOdgtlpqpA0NdWRlxMIF36aZHlcCNqK5tRuS4PopZ92+E1Q==
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr15518609wrs.369.1575638173950;
        Fri, 06 Dec 2019 05:16:13 -0800 (PST)
Received: from [10.201.49.168] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id u69sm3591583wmu.39.2019.12.06.05.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 05:16:13 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Fix some comment typos
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1575620418-19011-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6d9e3468-aa27-95d9-5d01-660298a6e9ac@redhat.com>
Date:   Fri, 6 Dec 2019 14:16:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1575620418-19011-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: KqvuDOmVPbKyO-tDA8GWhA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/19 09:20, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Fix some typos in comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  arch/x86/kvm/x86.c     | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a81c605abbba..0684b90070de 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1525,7 +1525,7 @@ struct rmap_iterator {
>  /*
>   * Iteration must be started by this function.  This should also be used after
>   * removing/dropping sptes from the rmap link because in such cases the
> - * information in the itererator may not be valid.
> + * information in the iterator may not be valid.
>   *
>   * Returns sptep if found, NULL otherwise.
>   */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e58a0daf0f86..e82772d9ab48 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1371,7 +1371,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
>  		/*
>  		 * VM exits change the host TR limit to 0x67 after a VM
>  		 * exit.  This is okay, since 0x67 covers everything except
> -		 * the IO bitmap and have have code to handle the IO bitmap
> +		 * the IO bitmap and we have code to handle the IO bitmap
>  		 * being lost after a VM exit.
>  		 */
>  		BUILD_BUG_ON(IO_BITMAP_OFFSET - 1 != 0x67);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3ed167e039e5..392d473252f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9790,7 +9790,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  	 *
>  	 * The reason is, in case of PML, we need to set D-bit for any slots
>  	 * with dirty logging disabled in order to eliminate unnecessary GPA
> -	 * logging in PML buffer (and potential PML buffer full VMEXT). This
> +	 * logging in PML buffer (and potential PML buffer full VMEXIT). This
>  	 * guarantees leaving PML enabled during guest's lifetime won't have
>  	 * any additional overhead from PML when guest is running with dirty
>  	 * logging disabled for memory slots.
> 

Queued, thanks.

Paolo

