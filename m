Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034E073639F
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 08:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjFTGdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 02:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjFTGdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 02:33:12 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92E6E53;
        Mon, 19 Jun 2023 23:33:11 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-763a2e39b88so128291585a.1;
        Mon, 19 Jun 2023 23:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687242791; x=1689834791;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5+evG04UMHwwjirukN0kb+RSrnzU5xpsvDPn540ciQ=;
        b=RYErAH+mi2zc86r5KWWfsFA8LP9PiwTUwejliV9x5CX3ukRT4UyxAdu8oUINH7+o71
         BABXTb+Al0ui9J0tqzVpEDRuSZr7tolLidH0mp1NHU5h6r01OFWQA5apd8IF14gcAjCV
         ZRWOtKnC/zvWenVhjSYiKmkcKYt4CTOYw+0eRsHFKMmo9NQRqlAgaYQ2+wCBJ5fPad2y
         deRzUvOljVXlVzy6NidHkJvcZ2hSlA4NU0ZEdVHUogrHjN1a2N62u1KbIFT0+ns5rGr1
         FqDT8PFagV1HC5m3wV6nfyjNesWAJV5ePIm4nguSY52ho/FLBHehJd28qB1ZFHtWJmFE
         tW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687242791; x=1689834791;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W5+evG04UMHwwjirukN0kb+RSrnzU5xpsvDPn540ciQ=;
        b=IvazCjDnHFLalKeUak6p8Nvi3cIEUqHXmp7qTN8zDz+U4leCFJ3V0k9tNqRwoRI08S
         zL8QuGQvwg254/6bNwEgiA9WIeiEbQx/amyuQBPaq86mhJiMVnGfUx9HO68tM09aG8SI
         F5YT356SoinGopb2D9RsQZTrb9tjZBECXmvbB5+4eF58LvFXwPNI4B4lZjU7AkedZKNi
         aWE7TqCzcqFhLDIY+wYjjPmFzYzLDv60e7UC8fwVFIU++UEgC+bssNaIarPRXbunK4Xz
         N66J3WhUvjQsa1wYVqZK0O1wMO0XrW/OBzEzTL7XhNV+wnwWCNiUWNNymE4qH5td3k9h
         ACaQ==
X-Gm-Message-State: AC+VfDxdVn5pdoAIe+2R/OtgmGw3lPucAZIokcrgNPq3iCrB15VorDEE
        gFkC2TpHYQ3L43S1KhCUw2w0rTZvhg0=
X-Google-Smtp-Source: ACHHUZ5n5K5aPC9bYUBHTpIjgZaXZzWq6qemowxSHihC3bO7xjOaMj7H/aLUT30sH+RFyR4rpOLqsQ==
X-Received: by 2002:a05:620a:3c90:b0:763:a610:bb64 with SMTP id tp16-20020a05620a3c9000b00763a610bb64mr2766292qkn.25.1687242790830;
        Mon, 19 Jun 2023 23:33:10 -0700 (PDT)
Received: from localhost (193-116-195-252.tpgi.com.au. [193.116.195.252])
        by smtp.gmail.com with ESMTPSA id i14-20020aa78d8e000000b0064f708ca12asm622133pfr.70.2023.06.19.23.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 23:33:10 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 20 Jun 2023 16:32:47 +1000
Message-Id: <CTH9N6UYDUM2.1974CRL32YFQC@wheely>
Cc:     "Alistair Popple" <apopple@nvidia.com>,
        "Anup Patel" <anup@brainfault.org>,
        "Ben Gardon" <bgardon@google.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Chao Peng" <chao.p.peng@linux.intel.com>,
        "Christophe Leroy" <christophe.leroy@csgroup.eu>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Fabiano Rosas" <farosas@linux.ibm.com>,
        "Gaosheng Cui" <cuigaosheng1@huawei.com>,
        "Gavin Shan" <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Marc Zyngier" <maz@kernel.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Michael Larabel" <michael@michaellarabel.com>,
        "Mike Rapoport" <rppt@kernel.org>,
        "Oliver Upton" <oliver.upton@linux.dev>,
        "Paul Mackerras" <paulus@ozlabs.org>,
        "Peter Xu" <peterx@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Thomas Huth" <thuth@redhat.com>, "Will Deacon" <will@kernel.org>,
        "Zenghui Yu" <yuzenghui@huawei.com>, <kvmarm@lists.linux.dev>,
        <kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-trace-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-mm@google.com>
Subject: Re: [PATCH mm-unstable v2 06/10] kvm/powerpc: make radix page
 tables RCU safe
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Yu Zhao" <yuzhao@google.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>
X-Mailer: aerc 0.14.0
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-7-yuzhao@google.com>
In-Reply-To: <20230526234435.662652-7-yuzhao@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat May 27, 2023 at 9:44 AM AEST, Yu Zhao wrote:
> KVM page tables are currently not RCU safe against remapping, i.e.,
> kvmppc_unmap_free_pmd_entry_table() et al. The previous

Minor nit but the "page table" is not RCU-safe against something. It
is RCU-freed, and therefore some algorithm that accesses it can have
the existence guarantee provided by RCU (usually there still needs
to be more to it).

> mmu_notifier_ops members rely on kvm->mmu_lock to synchronize with
> that operation.
>
> However, the new mmu_notifier_ops member test_clear_young() provides
> a fast path that does not take kvm->mmu_lock. To implement
> kvm_arch_test_clear_young() for that path, orphan page tables need to
> be freed by RCU.

Short version: clear the referenced bit using RCU instead of MMU lock
to protect against page table freeing, and there is no problem with
clearing the bit in a table that has been freed.

Seems reasonable.

>
> Unmapping, specifically kvm_unmap_radix(), does not free page tables,
> hence not a concern.

Not sure if you really need to make the distinction about why the page
table is freed, we might free them via unmapping. The point is just
anything that frees them while there can be concurrent access, right?

>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/bo=
ok3s_64_mmu_radix.c
> index 461307b89c3a..3b65b3b11041 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -1469,13 +1469,15 @@ int kvmppc_radix_init(void)
>  {
>  	unsigned long size =3D sizeof(void *) << RADIX_PTE_INDEX_SIZE;
> =20
> -	kvm_pte_cache =3D kmem_cache_create("kvm-pte", size, size, 0, pte_ctor)=
;
> +	kvm_pte_cache =3D kmem_cache_create("kvm-pte", size, size,
> +					  SLAB_TYPESAFE_BY_RCU, pte_ctor);
>  	if (!kvm_pte_cache)
>  		return -ENOMEM;
> =20
>  	size =3D sizeof(void *) << RADIX_PMD_INDEX_SIZE;
> =20
> -	kvm_pmd_cache =3D kmem_cache_create("kvm-pmd", size, size, 0, pmd_ctor)=
;
> +	kvm_pmd_cache =3D kmem_cache_create("kvm-pmd", size, size,
> +					  SLAB_TYPESAFE_BY_RCU, pmd_ctor);
>  	if (!kvm_pmd_cache) {
>  		kmem_cache_destroy(kvm_pte_cache);
>  		return -ENOMEM;

KVM PPC HV radix PUD level page tables use the arch/powerpc allocators
(for some reason), which are not RCU freed. I think you need them too?
I wouldn't mind if the kvm pud table slab was moved in here instead of
shared.

Thanks,
Nick
