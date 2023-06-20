Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D25736487
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 09:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjFTHaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 03:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjFTHa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 03:30:29 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A72188;
        Tue, 20 Jun 2023 00:30:28 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b549e81cecso9727835ad.0;
        Tue, 20 Jun 2023 00:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687246228; x=1689838228;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pYV4rW6gKPpoa3eFGZn6o9TgBp896EY80rdpl9Nfr2s=;
        b=kQcnC5U4PfyLQDSNkgJ+ZABIfGbRvyggeR2C8Y/N456McznJImrS63FChLkZaxR5tR
         Yq9f7Fxc2W99C/vYKA7o90DjifVQOxR0zUmPd2QEoj+ZsFWgSwqMn23Ryj/MQnhi07XE
         +FR5gSzkjkQbqq3p+O+0CpJeIdKu999apYycR+66zy89IamAqsRPerriuP6fbapd6VKd
         9HKmNtYaXYD5JqcEUNTemZQjEs9szfcsmT7wGpnlhLG3lNn6gmpsq11BV3U2q6pLf8KZ
         hLgEt3KZCnMPg6XY/thkZMJk7T5TBObUL6+V3k5F2FiirDyfxWxH5sIOasXCkEmGX1a3
         i+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687246228; x=1689838228;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pYV4rW6gKPpoa3eFGZn6o9TgBp896EY80rdpl9Nfr2s=;
        b=ByETK8lE7Qk2bsk/erpA5ck5/wZ6CwaL7bqmfjP8n1YYijC2E60RTpftUzouNxrwSL
         uFvW3ZqqvHFTVhXW6GxMnaThn2rxT9kv1WnGPMhubNS4TEUmsCNttcUY1sB6eswn7uj5
         XZFoRZOptvsibHNwNE27yfa6FqKivKLygLULbDSLS3YUzhNzDmrHa4dLG0cmA6Jek5C8
         HZW2NNM7tVha5MvvggNJ8j9gH4pUWYXuClid3SdQGuU0CeglAjTp9y53gLuWltTkXr6W
         176duYvjgQj3uVAi7PBemV0bWmU9J9MHN3oFt8rjOFMPk2vF4fiUE7WvU/3irabrnBnL
         3Eyw==
X-Gm-Message-State: AC+VfDwQcz0koxC08umXYfZ7dQQibzvekaG3tpYVF/1Cu7WLsGX/vPDP
        jx2CmoLdeAFxlzT1jnNv/ks=
X-Google-Smtp-Source: ACHHUZ43eep1AAmMl46MrK15oMgQPLrGXyP67yrmCY8AmGwY+QIfVnfreQMQhLQu3G2HRVKs6stwBg==
X-Received: by 2002:a17:902:c14a:b0:1b2:404c:7d46 with SMTP id 10-20020a170902c14a00b001b2404c7d46mr6394563plj.54.1687246227734;
        Tue, 20 Jun 2023 00:30:27 -0700 (PDT)
Received: from localhost ([124.170.190.103])
        by smtp.gmail.com with ESMTPSA id iy22-20020a170903131600b001b04b1fae4dsm958860plb.35.2023.06.20.00.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 00:30:27 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 20 Jun 2023 17:30:09 +1000
Message-Id: <CTHAV43JUAN4.I7HNUHO778BB@wheely>
To:     "Yu Zhao" <yuzhao@google.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>
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
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add
 mmu_notifier_ops->test_clear_young()
From:   "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.14.0
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-2-yuzhao@google.com>
In-Reply-To: <20230526234435.662652-2-yuzhao@google.com>
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
> Add mmu_notifier_ops->test_clear_young() to supersede test_young()
> and clear_young().
>
> test_clear_young() has a fast path, which if supported, allows its
> callers to safely clear the accessed bit without taking
> kvm->mmu_lock.
>
> The fast path requires arch-specific code that generally relies on
> RCU and CAS: the former protects KVM page tables from being freed
> while the latter clears the accessed bit atomically against both the
> hardware and other software page table walkers. If the fast path is
> unsupported, test_clear_young() falls back to the existing slow path
> where kvm->mmu_lock is then taken.
>
> test_clear_young() can also operate on a range of KVM PTEs
> individually according to a bitmap, if the caller provides it.

It would be better if you could do patch 1 that only touches the
mmu_notifier code and implements mmu_notifier_test_clear_young() in
terms of existing callbacks, and next patch swaps KVM to new callbacks
and remove the old ones.

> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 64a3e051c3c4..dfdbb370682d 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -60,6 +60,8 @@ enum mmu_notifier_event {
>  };
> =20
>  #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
> +#define MMU_NOTIFIER_RANGE_LOCKLESS	(1 << 1)
> +#define MMU_NOTIFIER_RANGE_YOUNG	(1 << 2)
> =20
>  struct mmu_notifier_ops {
>  	/*
> @@ -122,6 +124,10 @@ struct mmu_notifier_ops {
>  			  struct mm_struct *mm,
>  			  unsigned long address);
> =20
> +	int (*test_clear_young)(struct mmu_notifier *mn, struct mm_struct *mm,
> +				unsigned long start, unsigned long end,
> +				bool clear, unsigned long *bitmap);

This should have a comment like the others. Callback wants to know how
to implement it.

Could add a _range on it as well while you're here, to correct that
inconsistency.

> +
>  	/*
>  	 * change_pte is called in cases that pte mapping to page is changed:
>  	 * for example, when ksm remaps pte to point to a new shared page.
> @@ -392,6 +398,9 @@ extern int __mmu_notifier_clear_young(struct mm_struc=
t *mm,
>  				      unsigned long end);
>  extern int __mmu_notifier_test_young(struct mm_struct *mm,
>  				     unsigned long address);
> +extern int __mmu_notifier_test_clear_young(struct mm_struct *mm,
> +					   unsigned long start, unsigned long end,
> +					   bool clear, unsigned long *bitmap);
>  extern void __mmu_notifier_change_pte(struct mm_struct *mm,
>  				      unsigned long address, pte_t pte);
>  extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_ran=
ge *r);
> @@ -440,6 +449,35 @@ static inline int mmu_notifier_test_young(struct mm_=
struct *mm,
>  	return 0;
>  }
> =20
> +/*
> + * mmu_notifier_test_clear_young() returns nonzero if any of the KVM PTE=
s within
> + * a given range was young. Specifically, it returns MMU_NOTIFIER_RANGE_=
LOCKLESS
> + * if the fast path was successful, MMU_NOTIFIER_RANGE_YOUNG otherwise.
> + *
> + * The last parameter to the function is a bitmap and only the fast path
> + * supports it: if it is NULL, the function falls back to the slow path =
if the
> + * fast path was unsuccessful; otherwise, the function bails out.

Then if it was NULL, you would just not populate it. Minmize differences
and cases for the caller/implementations.

> + *
> + * The bitmap has the following specifications:
> + * 1. The number of bits should be at least (end-start)/PAGE_SIZE.
> + * 2. The offset of each bit should be relative to the end, i.e., the of=
fset
> + *    corresponding to addr should be (end-addr)/PAGE_SIZE-1. This is co=
nvenient
> + *    for batching while forward looping.
> + *
> + * When testing, this function sets the corresponding bit in the bitmap =
for each
> + * young KVM PTE. When clearing, this function clears the accessed bit f=
or each
> + * young KVM PTE whose corresponding bit in the bitmap is set.

I think this is over-designed as a first pass. The secondary MMU should
just implement the call always. If it can't do it locklessly, then just
do individual lookups. If the benefit is in the batching as you say then
the locked version will get similar benefit. Possibly more because locks
like some amount of batching when contended.

I think that would reduce some concerns about cases of secondary MMUs
that do not not support the lockless version yet, and avoid
proliferation of code paths by platform.

_If_ that was insufficient then I would like to see numbers and profiles
and incremental patch to expose more complexity like this.

Also mmu notifier code should say nothing about KVM PTEs or use kvm
names in any code or comments either. "if the page was accessed via the
secondary MMU" or similar is mutually understandable to KVM and mm
developers.

> @@ -880,6 +887,72 @@ static int kvm_mmu_notifier_test_young(struct mmu_no=
tifier *mn,
>  					     kvm_test_age_gfn);
>  }
> =20
> +struct test_clear_young_args {
> +	unsigned long *bitmap;
> +	unsigned long end;
> +	bool clear;
> +	bool young;
> +};
> +
> +bool kvm_should_clear_young(struct kvm_gfn_range *range, gfn_t gfn)
> +{
> +	struct test_clear_young_args *args =3D range->args;
> +
> +	VM_WARN_ON_ONCE(gfn < range->start || gfn >=3D range->end);
> +
> +	args->young =3D true;
> +
> +	if (args->bitmap) {
> +		int offset =3D hva_to_gfn_memslot(args->end - 1, range->slot) - gfn;
> +
> +		if (args->clear)
> +			return test_bit(offset, args->bitmap);
> +
> +		__set_bit(offset, args->bitmap);
> +	}
> +
> +	return args->clear;
> +}

I don't quite understnd what's going on here. This is actually the
function that notes the young pte, despite its name suggesting it is
only a query.

Shouldn't it set the bitmap bit even in the clear case? And why is it
testing at all? Oh, it seems to be some strange mix of test *or* clear
young. With the bitmap being a predicate in some cases for the clear
case.

This is a fairly confusing multi-modal API then. I think it should
take 2 bitmaps, one is the young bitmap and the other is the predicate
bitmap, and either/or can be NULL.

Also this kvm_should_clear_young helper is clunky and misnamed. If you
just provided an inline helper to get test_clear_young bitmap offset
from gfn, then set/clear bit in the caller is quite trivial.

> +
> +static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, st=
ruct mm_struct *mm,
> +					     unsigned long start, unsigned long end,
> +					     bool clear, unsigned long *bitmap)
> +{
> +	struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> +	struct kvm_hva_range range =3D {
> +		.start		=3D start,
> +		.end		=3D end,
> +		.on_lock	=3D (void *)kvm_null_fn,
> +		.on_unlock	=3D (void *)kvm_null_fn,
> +	};
> +
> +	trace_kvm_age_hva(start, end);
> +
> +	if (kvm_arch_has_test_clear_young()) {
> +		struct test_clear_young_args args =3D {
> +			.bitmap	=3D bitmap,
> +			.end	=3D end,
> +			.clear	=3D clear,
> +		};
> +
> +		range.args =3D &args;
> +		range.lockless =3D true;
> +		range.handler =3D kvm_arch_test_clear_young;
> +
> +		if (!__kvm_handle_hva_range(kvm, &range))
> +			return args.young ? MMU_NOTIFIER_RANGE_LOCKLESS : 0;
> +	}
> +
> +	if (bitmap)
> +		return 0;
> +
> +	range.args =3D NULL;
> +	range.lockless =3D false;
> +	range.handler =3D clear ? kvm_age_gfn : kvm_test_age_gfn;

Minor thing, but KVM's "young" handling has been called "age" until now.
Any reason not to stick with that theme?

Thanks,
Nick
