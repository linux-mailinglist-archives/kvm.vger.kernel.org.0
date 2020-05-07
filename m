Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EF41C948A
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 17:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgEGPN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 11:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgEGPN2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 11:13:28 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80219C05BD43
        for <kvm@vger.kernel.org>; Thu,  7 May 2020 08:13:28 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so6840231wrt.5
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 08:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S2uo98FwAjVg5CWP5Av+uIlNFRj0bTJ/Soj3by7c/U4=;
        b=KTP/UuKnmFq2SPCo2FGyvoGogXVtgtFTX5B4pJ8o/uSdf2i17qIMcFtyhsPPurcepl
         TbE5Rgj3LKq1EPMC9Co4rtvTM66GKJ56TWPuka3aSQqzUCOVcYjbiDExz6JDELbOQDAG
         wSB2FwSYtEWaFVYj6juw+K/c+6PgofSbKHcoRnalTJBpuFTSlfwRcSjqHzZbRpKqboFw
         tMOt470dTW4GQir+16tCiljhjjBZt3GqcbkmGJGPM2qE2G50yC2baZINqrYNUQCpWGYq
         CLuFbuEi3wSxnL0lNFoOAgCyVRtv1Fr1W/+sFw0ohgtjSiGprk1+wysg1+kwJ37SpF32
         Ocaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S2uo98FwAjVg5CWP5Av+uIlNFRj0bTJ/Soj3by7c/U4=;
        b=n9/gOS21Kx4PmSfmNb3slgRinmlpBCZDIbGMFqp1msLwIG47sMQNqcJNFgAQ5+Q4uN
         b0/gu/KA0v3z+SbhTxwp74/bydJwCS1/wezni/3KVZjkhQWZQ2nvwROMHpjSiMpYf1VB
         +dI59gsD+r16R3jHtLxoXxrTPRwmCIuickBYa2N1jhJEFXJstEoocQlekEUJVDUnP7bi
         PmEhhio6e4pcF4eLlVXfTvfDiQp9T2b61Ak69QG09rOo7PooyOax5BjCubCA9pTxllSY
         +9HnQlMesfnSjjn2LtWw6gzLbf9FaSTA+kwRrnpUhAhvDv7dOvSnmM1HjJexZm1WgLRP
         eHQg==
X-Gm-Message-State: AGi0PuaLWPDVsw7W978B7zywas5w0Kt8OuaFbrMB5iyLKXhfaJfIXC4h
        FiFUBucNuyuv26EYYg4kg01yQ/BGNKs=
X-Google-Smtp-Source: APiQypLNfmFFEmEkdVcn8CcdE0QmpbeyzViDZ82NLnSF0CRXgetg8FYsnaOyp6ozrpX3U1nd3rIVtg==
X-Received: by 2002:a5d:6705:: with SMTP id o5mr9808907wru.426.1588864406980;
        Thu, 07 May 2020 08:13:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id t16sm8235479wmi.27.2020.05.07.08.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 08:13:26 -0700 (PDT)
Date:   Thu, 7 May 2020 16:13:21 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
Message-ID: <20200507151321.GH237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-9-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -176,7 +177,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
>  	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
>  	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
>  	stage2_pud_clear(kvm, pud);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>  	stage2_pmd_free(kvm, pmd_table);
>  	put_page(virt_to_page(pud));
>  }
> @@ -186,7 +187,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
>  	pte_t *pte_table = pte_offset_kernel(pmd, 0);
>  	VM_BUG_ON(pmd_thp_or_huge(*pmd));
>  	pmd_clear(pmd);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>  	free_page((unsigned long)pte_table);
>  	put_page(virt_to_page(pmd));
>  }

Going by the names, is it possible to give a better level hint for these
cases?
