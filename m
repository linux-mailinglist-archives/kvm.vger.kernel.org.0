Return-Path: <kvm+bounces-69861-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aCeOMqe7gGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69861-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 15:58:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 30802CDBFA
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 15:58:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D2344301E97A
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 14:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC86374182;
	Mon,  2 Feb 2026 14:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FrrF7XRp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E9C36A01C
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770044135; cv=pass; b=es6LxqJz17BuFE1KvDBJvRWvIuU6CcAmdPbTZvT0+pYx/QgrWrtXb+TEr4HPrfq+b7joAzzGK5BJSwAjclXS1S3DMdsOqq2UUuvBy0zWX6xHuU9FFMhWexhH/aMWW7GS2wBCYBtcvvZtwEEi22W/rG0rHwIJ6pf/EnaecjzbzPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770044135; c=relaxed/simple;
	bh=L+Drc4zZELrb56o4CSDEnC33mSxORpzl59/bTQk9IrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nMJ6qYYBgmfCnkc/19OLlN4yqhftsmmGlvDydYMBsZan2p1VYw8pTupGDLL2nxTmp7w3qKKhwFgd7rAfI8X+oIqk86buILt48ITXEaSGCS81cfTQuArb7wDdQ4QQhOLstOWe4/fXWeakAJjf6vAscgo/R4kFRga67FmqAe0fRBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FrrF7XRp; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5014b5d8551so851281cf.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 06:55:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770044132; cv=none;
        d=google.com; s=arc-20240605;
        b=CKIpMj1bjpSG566G7xJXAP7qU+bmedD9lWmPHTAGa4sa2/yZIdnlF6e0Lrs9TXH4s0
         S3myswMOIdrGRC3WB/ZPcXIdiT/WvrMGpo7Fze9rMidr80XmBpjT/CIEu+98fs/k2+1U
         S+lDt5JrAyZb3Wzm12OKy56U8FaH0MTf6g0bjWonXU0wUEnpVZ/8tlokeg6e3SYLclcB
         KKTnBTuG+PauFo1dK+bGGVFhTk/Pk4vHlxARl+5+pWOzDKBXTM+BRkOXPMRnZJZ/Tt5K
         NCLU26gN4jVjmuSRxwKFwr+CI6AstkNvwxiOZuQSNAU/DHpUyPSKc8HW+PMdLpS5E4fb
         YmeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=p2kyDBMjKUAvLcpywCWxpjEa8MLWup/GMgXHmqrdgQw=;
        fh=KGcuNjxddnD9qzE0YmsXmHeGNVjSiCRPT/2xorpl08g=;
        b=KFxzdE/6YXIz2gfqOl9XO7stzxyVLPsrMQDjdI3iWrEuK0zGxDk6TpzQy514BzeKYq
         85CE2C9ngvDBMLoZC9r7Gn/HTFFLlYcKoiuULCIf1txPREEy94oXDg9VMCgAUmzRN94l
         ELzQ/WOgjdXCXIAgX0SCoYxOXzZJqZ8zdvzrve2zyvE0gxrfTbE0gSfR/Nf7WIdbzg5k
         jvmV3V/lBwlgtz9rUWvsibHCwa1tu4LFoZTBfxYvmuRjbdGcB729SA5k2KH4pHeIdQSi
         JbRnyEdnhxbNjK48kaWDoah42HWLtx0HJnrNFCBNUGkC4gSli+gqH8X4C0BTtSFys/+1
         97Ww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770044132; x=1770648932; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p2kyDBMjKUAvLcpywCWxpjEa8MLWup/GMgXHmqrdgQw=;
        b=FrrF7XRpvLYqNuVZHFE9zlAdd0LRNRsZbvTtE78yHUR8ZhgLhqcBN3VBB4fz50QZzk
         JTwENtyZQOJ9PRHbJCEljysYN/1sWfibxDO5I8k6vB9Sv+wAUpcrPtI1hgxUOsOGsI1X
         BVZ1fRTdDFJaCAh9HCOVj12IDNkxZkYRUGtotoGZrfFWn8wGSbQ8LBrt3EPxb1EXLV6K
         /e0QoXCCPVAiBYRsIrCCJ8UKkSdsONHeGP8A665eUa2nNaCAY/6C3pE3HMAfayuCp9Gy
         aJ16mxSANaKJvYUWOiueMQ1V1DD9l/50mZTGmMk7Skpq3qCP9s0ORr22UWwi1fio5hAB
         BBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770044132; x=1770648932;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2kyDBMjKUAvLcpywCWxpjEa8MLWup/GMgXHmqrdgQw=;
        b=ooQNyNWl2nmahvvTJE1otuh+fE4ObgQP2Rr8F+D0bud1NU5U9i1OTsLlGPLvx2asOy
         bYEqlaTeJy67HJKDx3V1c4j/lOGxqI2XnJqNXmPODDkHN5Mf4tzz2PFYml9r0+6IeY62
         6qnim9f8lRF3xwcEa0P9CL0wctwB2cET0iHWqT07X+uktlzmY6ptkXHLijUP4X9E86l3
         rwcVWv/X+zA4tu12A3iLVGJNf4DYkoYD6iL9rONG5zhApBT+VQZqDBpJpaHWBZzn2DWu
         2b0lfNJGfja9kDPv6D87zwi5lHK+CupnhRW+xyBgD5uXSqHdxuGxUYfXEcqwIrT9iJC3
         o7lw==
X-Gm-Message-State: AOJu0YyV1m1OUwreQfZjF+HOC2llf04riS0V67N6vqeHshf9IocpnvGl
	fr92P8NYvdggi2pyZWTL1KLCmWVmQfNv12cUm6HzfUQCQ0KAzEUllLVYd/pVaTkRLKrP1CZkEKC
	q6g/YIFQjsTmLUqGHxrirNKynbZ2s4JFaGoRGNJR7YUi4wmea/5dnfe0n
X-Gm-Gg: AZuq6aLRw8VPcoe8bS0GqvGXlI44lqZXZAleADsqg0n3aphizMfBoz5uz2qFNmuEPHs
	/cXgTsa4ftsTUnU+8W/xJFELLfVM9v3McVOSk1U3HqDrYrlzLLwJAnMJcDhOhLIFpNilwOjUNJ/
	4xVKd9J+McyiKLZZ6kJzBf0IkXkHEoUXSnjQb2gh54OyzysaCVQdlgl4KYPoTqv7p7cDGcs0vWM
	kUeaORnqzekfn6AUwmwYMMs+Mp+EREGfs3fT+/LsjPnOBsIqPQiJdv1f5KITxRC233H9oGN
X-Received: by 2002:ac8:5d45:0:b0:4ff:bffa:d9e4 with SMTP id
 d75a77b69052e-505dfb55052mr19488481cf.13.1770044132084; Mon, 02 Feb 2026
 06:55:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202130513.49436-1-tabba@google.com> <86tsvz9pbg.wl-maz@kernel.org>
In-Reply-To: <86tsvz9pbg.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Feb 2026 14:54:55 +0000
X-Gm-Features: AZwV_Qj88kuF0nlt2JcSTWbHw1T0UvegRJGqt9wyIYg1kj2dP_rnWko34sG6YH8
Message-ID: <CA+EHjTxC3SXJSHkChVfzLs7C5M4iD59VhKYiHf99MjxuNSPZaA@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: nv: Use kvm_phys_size() for VNCR
 invalidation range
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69861-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 30802CDBFA
X-Rspamd-Action: no action

Hi Marc,

On Mon, 2 Feb 2026 at 14:45, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 02 Feb 2026 13:04:24 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > KVM: arm64: nv: Use kvm_phys_size() for VNCR invalidation range
> >
> > Protected mode uses `pkvm_mappings` of the union inside `struct kvm_pgtable`.
> > This aliases `ia_bits`, which is used in non-protected mode.
> >
> > Attempting to use `pgt->ia_bits` in kvm_nested_s2_unmap() and
> > kvm_nested_s2_wp() results in reading mapping pointers or state as a
> > shift amount. This triggers a UBSAN shift-out-of-bounds error:
> >
> >     UBSAN: shift-out-of-bounds in arch/arm64/kvm/nested.c:1127:34
> >     shift exponent 174565952 is too large for 64-bit type 'unsigned long'
> >     Call trace:
> >      __ubsan_handle_shift_out_of_bounds+0x28c/0x2c0
> >      kvm_nested_s2_unmap+0x228/0x248
> >      kvm_arch_flush_shadow_memslot+0x98/0xc0
> >      kvm_set_memslot+0x248/0xce0
> >
> > Fix this by using kvm_phys_size() to determine the IPA size. This helper
> > is independent of the software page table representation and works
> > correctly for both protected and non-protected modes, as it derives the
> > size directly from VTCR_EL2.
>
> I'm a bit confused by the explanation. We have plenty of code that
> uses pgt->ia_bits outside of the NV code. And yet that code is not
> affected by this?
>
> I'm asking because NV is clearly a case where the pkvm_mappings
> aliasing is unambiguously *not* happening.
>
> Isn't the real issue that we are entering the NV handling code for any
> S2 manipulation irrespective of NV support? Would something like below
> help instead?

That would definitely work (just tested it). I just assumed that the
code is there in case in the future we want to support nv + pkvm....
Although, I chuckled a bit as I was writing those words :)

I was going to ask if you'd like me to respin, but this is a
completely different patch. Would you like me to write it up and send
it (my contribution would be the commit msg)?

Cheers,
/fuad


> Thanks,
>
>         M.
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index cdeeb8f09e722..d03e9b71bf6cd 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1101,6 +1101,9 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
> +       if (!kvm->arch.nested_mmus_size)
> +               return;
> +
>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>
> @@ -1117,6 +1120,9 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
> +       if (!kvm->arch.nested_mmus_size)
> +               return;
> +
>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>
> @@ -1133,6 +1139,9 @@ void kvm_nested_s2_flush(struct kvm *kvm)
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
> +       if (!kvm->arch.nested_mmus_size)
> +               return;
> +
>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>
> @@ -1145,6 +1154,9 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
>         int i;
>
> +       if (!kvm->arch.nested_mmus_size)
> +               return;
> +
>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>
>
> --
> Without deviation from the norm, progress is not possible.

