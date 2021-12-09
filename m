Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C818246F33A
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243398AbhLISic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243276AbhLISi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:38:26 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84955C061746;
        Thu,  9 Dec 2021 10:34:52 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y12so21874796eda.12;
        Thu, 09 Dec 2021 10:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+zI/uY0HbhRQxbU0uDHdKiysuc/BimXIFXVd1mgbhUs=;
        b=c3ECy+yxCV+HPacayaTpJOgHPIHwef7ZJNvYQDpgYKf18CpWjfUTkVnWfQqn++/o10
         Fp3Xr36EmfHMBSPk84IPd5g4Yhe/gP5KzzIrO4F3p/AkP2/qm7MeQNy8eyZNAuLL5h/P
         fJOWgXvFlGIzamG9sRPW0HwPhw7FfV4qYg/m4VTx5oE8rSaKk16KDX0fWUkgcqKre3A2
         MmQshaP3JXfmbO4cXh5eNC1IEkpEJlGUeBn7FF9dRJKU/FVOwnzUIlt1sUli0icW5LsR
         3Vbgd+KFeP+zI91Omkntwb3DYSkKK7IBWJYW2omwyqo0LZhG74wb+VUPnNC36+FfsfG0
         tS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+zI/uY0HbhRQxbU0uDHdKiysuc/BimXIFXVd1mgbhUs=;
        b=dqshoGPvh6DGZMNCbSGMMegQ5KjjOBc6KmsskYT3rCy1C0Lkzxyv649v26F0Oem/HO
         z4WkrrMC2FF+8gb+xz4U3/4n3RGvElsfqDPEwvTELBoawE34qybLImtT7ngk9OcJ4IjF
         GQgliXpquW7/AuRQEelckdq+vV7WP04wR/E+xS3RN1IQSrI52rMYqCawBibmU7VbSOG7
         nZ5JwObbVlC2khDZofip060GVh8yIfSteT1Gutd7mDavM9KttexkTfizGoU4+BpQ6Zj3
         7+0Ail3DJVZhsPB/IvGs23v0zrv++Xixmnq7OPQp61YV8vIySvaZfGJmkV0C6b/cDzwJ
         W98Q==
X-Gm-Message-State: AOAM533fz8NBLjdikEN/p2N9cNMsbXHhSFCDFO13UIHn1C3IlbQth/PJ
        2MjRp1pRhbISQcDRRinXNV4=
X-Google-Smtp-Source: ABdhPJyzZnV4yIOIpx1yw9gOS9Nnuyioy0GPnW+twuf6B+q2BDrnhU8giByTdwbtnr3yemfopJ87vw==
X-Received: by 2002:a17:906:938f:: with SMTP id l15mr17905624ejx.302.1639074889734;
        Thu, 09 Dec 2021 10:34:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k16sm260233edq.77.2021.12.09.10.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 10:34:49 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <2617aea0-af09-5c0d-1fd7-65e2a814b516@redhat.com>
Date:   Thu, 9 Dec 2021 19:34:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 00/12] KVM: x86/xen: Add in-kernel Xen event channel
 delivery
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211121125451.9489-1-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211121125451.9489-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/21 13:54, David Woodhouse wrote:
> Introduce the basic concept of 2 level event channels for kernel delivery,
> which is just a simple matter of a few test_and_set_bit calls on a mapped
> shared info page.
> 
> This can be used for routing MSI of passthrough devices to PIRQ event
> channels in a Xen guest, and we can build on it for delivering IPIs and
> timers directly from the kernel too.
> 
> v1: Use kvm_map_gfn() although I didn't quite see how it works.
> 
> v2: Avoid kvm_map_gfn() and implement a safe mapping with invalidation
>      support for myself.
> 
> v3: Reinvent gfn_to_pfn_cache with sane invalidation semantics, for my
>      use case as well as nesting.
> 
> v4: Rework dirty handling, as it became apparently that we need an active
>      vCPU context to mark pages dirty so it can't be done from the MMU
>      notifier duing the invalidation; it has to happen on unmap.
> 
> v5: Fix sparse warnings reported by kernel test robot<lkp@intel.com>.
> 
>      Fix revalidation when memslots change but the resulting HVA stays
>      the same. We can use the same kernel mapping in that case, if the
>      HVA → PFN translation was valid before. So that probably means we
>      shouldn't unmap the "old_hva". Augment the test case to exercise
>      that one too.
> 
>      Include the fix for the dirty ring vs. Xen shinfo oops reported
>      by butt3rflyh4ck<butterflyhuangxx@gmail.com>.
> 
> 
> As in the previous two rounds, the last patch (this time patch 12) is
> included as illustration of how we*might*  use this for fixing the UAF
> bugs in nesting, but isn't intended to be applied as-is. Patches 1-11 are.

Queued 1-7, will be on kvm/next tomorrow though.

Paolo
