Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0D53CF76F
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhGTJ2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 05:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbhGTJ2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 05:28:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B58C061574
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 03:09:27 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id f17so25379056wrt.6
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 03:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0j3bPtwVUVm/jZDBUJXolF4U+AmslpUbr8sCL6VPfoA=;
        b=HAyimdTxgae0VX9e5mbMhkKbnj16MrHWbI0i37pITjBmQQJ4VRXmvUpgvzO9ymMIKg
         mjrgM+dSiSax+84SIS0Okxr3ALUy2Ehb+jDqtr2dpRRcd9ugaeJaePM84jSgNnWfo7b6
         owAA6Yabf9pZ2CECadWlx2Vf/UcEBe3Ru/Hg8eXnI3Od9skjqLcVzLQYwMKdHLP1FjTf
         UXYVjUdCfgJtyqHqmkXXSPNvKzWc7/4OhrDx4gVDizRY6QqTXT5ADTSEwm8EW6X4NsiK
         KfeXgor2I58mOMbFMQYxJ6eRaDl5r+ueK7+ScH5nlJkkcOYGasQrSdjuHKcsvRFOpkbH
         csUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0j3bPtwVUVm/jZDBUJXolF4U+AmslpUbr8sCL6VPfoA=;
        b=IJNpsqt3zk5KaPbxIFLFQ+jhjvr05yRBLqGv2rQ9ocJiMBXxwbaLHmZhRlCDsNIchA
         JcfEQ1iCN+3sbjQI7Uvo7zOMmPEN8n6TpTyYTYGr3NNePgJUKZDZzeHzT9RiCdp+h09y
         Pw36lzkJhH3oiFnjN9BnSaJxPGUQ9vNtWrdk9GExsUsuAXYVE/19MAsEkUitPqtgtd6H
         Z+/8nMO0LOi75icOiMcZzc4k+h9vYA8+JOBXkWMjP0biyZsBLmNn5KygDbIxVVIyomyB
         Zab3hvOqPuyR7Qu0C3pC/svT3Ugx4ozWqahHIrWX4gqZByrNyafRZpG+1JH+fKCzTB3m
         5XBg==
X-Gm-Message-State: AOAM531dWdSsOypVmB2TvNueA8d45hOLyzY8uHsSP6IsYEbXXGQqIZqb
        2BMfZ7RNiEaWhy/AlV456oQjvQ==
X-Google-Smtp-Source: ABdhPJw9FCFTdkiAN4LxfJoUs++5xlLWx8lVhaIJEWeX7hAEofC+sahFp6Ki2Mrs5oqdp3xuqh93zw==
X-Received: by 2002:adf:a2c3:: with SMTP id t3mr33970462wra.223.1626775765602;
        Tue, 20 Jul 2021 03:09:25 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
        by smtp.gmail.com with ESMTPSA id m15sm19470088wmc.20.2021.07.20.03.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 03:09:25 -0700 (PDT)
Date:   Tue, 20 Jul 2021 11:09:21 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        dbrazdil@google.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner into
 kvm_pgtable_stage2_annotate
Message-ID: <YPag0YQHB0nph5ji@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday 15 Jul 2021 at 17:31:46 (+0100), Marc Zyngier wrote:
> @@ -815,7 +807,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.arg		= &map_data,
>  	};
>  
> -	if (owner_id > KVM_MAX_OWNER_ID)
> +	if (!annotation || (annotation & PTE_VALID))
>  		return -EINVAL;

Why do you consider annotation==0 invalid? The assumption so far has
been that the owner_id for the host is 0, so annotating a range with 0s
should be a valid operation -- this will be required when e.g.
transferring ownership of a page back to the host.

>  
>  	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> -- 
> 2.30.2
> 
