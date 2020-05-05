Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8011C5B0E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 17:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgEEP05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 11:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729250AbgEEP04 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 11:26:56 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F3EC061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 08:26:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so3264143wrx.4
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 08:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zXzR1aUk2ZPbhK+lz+Dt3JwzZZ+Iz4WfBlkdVh6bKZ4=;
        b=D5EdbvAamPv1DrL3nw+DFrCk7yJ0oA0Pk0KLYgu30csT1pr6SXwD2SFPhq9b16Ree2
         ++nyPqcQTRhY6O4Ye2ZkZKT+PA8UYEWVNv+b5qGz096S1/6vAu7jppfCqUeBXoXr8RWO
         7tT1K1i1KFaSNwEvHVV4zEVWWxTxTC6RU4M0UrpLdzS9mv1Ck3AD1JaFPaB6R96xWoUo
         7vbzFotV8dB2owsQUB3g107Y3UnKh3b+dNwJi2k5zB7wZ4dZtkbsPmJXAjeEXX3qKG7C
         qMjHiL1zRDXFin/CH1nE4zNhx93UIfsgjKsB3VPBYiSt0+6KZCaoets0e7sCsJDWqVcP
         LYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zXzR1aUk2ZPbhK+lz+Dt3JwzZZ+Iz4WfBlkdVh6bKZ4=;
        b=oVWQCM1pzr2dhb9pTCIPFk9TvRKuEX81KhmlQwlCRoOq6sc0gEUkSvYbtqC5B7EBVU
         /0x2xJkjnTHKqKVd0Ag92RD+CELXPuw5u+fA/nqXnnHp/fVv68te1eGb2iN2gBtl5JrC
         OGgqvrgldFmQRbA+cFLh4fFfIVqEjqYr8m9GXKEpRNST2htcDPwVBcr61vYU777GHiIe
         hQ/E0XURdCuqxXLTqg1PRNXOFQzXXIrHml14GmR+yNMFgb1m+q7VJ4zpUao6CQIKEhfw
         Ze3PE8xcaMo6aC3uXEa3RArYk8jn16pUl5VpK0mNgnQfTPw8YI81qZPZMxJdZ+MD2Ja8
         HIHw==
X-Gm-Message-State: AGi0PuZtlJKYEy7xHVkOb37IDze8X6VmdwXsH+a7psaohCTLongcurjR
        VzLkjTdl/8SYk0OaqkvjQhqQykcS6DezYA==
X-Google-Smtp-Source: APiQypI8heCYBzq/jyvWYkJRjjg6bf3eXOCslINaHp7aVsym9o41pg4+cPoZ+kh2dtXuR1lVzqzCkg==
X-Received: by 2002:a5d:51c9:: with SMTP id n9mr4216171wrv.84.1588692414526;
        Tue, 05 May 2020 08:26:54 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id a13sm3733889wrv.67.2020.05.05.08.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 08:26:53 -0700 (PDT)
Date:   Tue, 5 May 2020 16:26:48 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
Message-ID: <20200505152648.GA237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-4-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having a go at reviewing. Might turn out to be more useful as a learning
exercise for me rather than useful feedback but we've got to start
somewhere..

> -struct kvm_arch {
> +struct kvm_s2_mmu {
>  	struct kvm_vmid vmid;
>  
> -	/* stage2 entry level table */
> -	pgd_t *pgd;
> -	phys_addr_t pgd_phys;
> -
> -	/* VTCR_EL2 value for this VM */
> -	u64    vtcr;
> +	/*
> +	 * stage2 entry level table
> +	 *
> +	 * Two kvm_s2_mmu structures in the same VM can point to the same pgd
> +	 * here.  This happens when running a non-VHE guest hypervisor which
> +	 * uses the canonical stage 2 page table for both vEL2 and for vEL1/0
> +	 * with vHCR_EL2.VM == 0.
> +	 */
> +	pgd_t		*pgd;
> +	phys_addr_t	pgd_phys;
>  
>  	/* The last vcpu id that ran on each physical CPU */
>  	int __percpu *last_vcpu_ran;
>  
> +	struct kvm *kvm;
> +};
> +
> +struct kvm_arch {
> +	struct kvm_s2_mmu mmu;
> +
> +	/* VTCR_EL2 value for this VM */
> +	u64    vtcr;

VTCR seems quite strongly tied to the MMU config. Is it not controlled
independently for the nested MMUs and so remains in this struct?

> -static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
> +static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr, pmd_t *pmd)

How strictly is the long line style rule enforced? checkpatch has 16
such warnings on this patch.

> -static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
> +static void stage2_dissolve_pud(struct kvm_s2_mmu *mmu, phys_addr_t addr, pud_t *pudp)
>  {
> +	struct kvm *kvm __maybe_unused = mmu->kvm;
> +
>  	if (!stage2_pud_huge(kvm, *pudp))
>  		return;

There're a couple places with `__maybe_unused` on variables that are
then used soon after. Can they be dropped in these cases so as not to
hide legitimate warning?
