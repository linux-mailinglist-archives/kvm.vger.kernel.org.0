Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4818D1C93B8
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 17:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgEGPIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 11:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726074AbgEGPIw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 11:08:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73A2C05BD43
        for <kvm@vger.kernel.org>; Thu,  7 May 2020 08:08:51 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so6855680wrt.1
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 08:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TQa81UcYxl76b0HSzt9euhUmUepcpv3Z6r/LM6Ln5KE=;
        b=QLPKtMifAlPpfvwJKFqGd26kBFWPILMeiCXFGFuEBE548R8w7lgb/0jsPh1bu3DHka
         breNdX586T44AB8m87A/JFIhSjk18lq8Ve/dJA8HOPPUdvxMajShm3p9OrMioRH7BjNk
         OtO/C7ZoIrq3QXqeHbPkDtJj/UCSnMPHzfmtbcFPKku/qJ3SLGEvDZfQNIGTDQOHihp2
         RZUnfXmJAg5LekkpLJLHtjTC60tVDp/QS+HCO4fpBcJAltENqV7gK5zsOYx3ba2n1ytG
         Gid9G0dnaQqFzt1Mv4dH7ozS4PPRWrE3NnI+YiPyf0hsTtLfCKlYI43SN/29CxJTkK6U
         Irsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TQa81UcYxl76b0HSzt9euhUmUepcpv3Z6r/LM6Ln5KE=;
        b=EWYY4hiI9NIfu7sSjrPpvkrVE4Nvi0PUNQfiySohX2nfsaYGyGnbTPRWLeDaQQHu0i
         E4JU6TsMK2BcsYHLVk01c5t22zvn12WlCqIUHEMi0N1TRsngP1l2G/YZH6jC14046s0u
         A+9snzgSIIN9sNQzWSv0eE5IOztGDTtd72TtljnqaeB5czzYkffzKumyhPkjciFiN6pE
         z1MXft/pNe5OgB4vJuXVYqQFqn7xq64O2egnK0cKCOYx4eD4ewBjVa1f259UaeA4G9ds
         Ph0Yo1jVkJg66Qgdqnt1erhvSAZzp4qhMsUn1wRwi9415szrerdrLmouHr3J9qw+3HTV
         J+Lg==
X-Gm-Message-State: AGi0PuakOliQsxuavhMiyzCR+mvCiXFaCOZdsF0aCWdsR7xq2uBckBx1
        MhNp9Tm9iXDUa7b5g2aDewU3fQ==
X-Google-Smtp-Source: APiQypIHxYj17NVfmcnSuGrpk40/cA1y0gsCzWWQg9AehmmC7nw/0HsXW/bsHDdO/dPr7ICzSJ0SUQ==
X-Received: by 2002:a5d:5445:: with SMTP id w5mr15635148wrv.422.1588864130021;
        Thu, 07 May 2020 08:08:50 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id u2sm10491869wrd.40.2020.05.07.08.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 08:08:49 -0700 (PDT)
Date:   Thu, 7 May 2020 16:08:43 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 07/26] KVM: arm64: Add a level hint to
 __kvm_tlb_flush_vmid_ipa
Message-ID: <20200507150843.GG237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-8-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
> +void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
> +					 phys_addr_t ipa, int level)

The level feels like a good opportunity for an enum to add some
documentation from the type.

>  static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
>  {
> -	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
> +	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa, 0);

With the constants from the next patch brought forward, the magic 0 can
be given a name, although it's very temporary so..

Otherwise, looks good.
