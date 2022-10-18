Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308306030D1
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJRQdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 12:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJRQdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 12:33:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577031C126
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:33:50 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id 13so33572896ejn.3
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DqDgXXUBKgC05Hv+WG8VLItfXbNXEiS/cMK9T9OzjCs=;
        b=EDVjXNcJBQF3sMy6ywtF+Bbf8LfvpG0Ow0j3NoGv4ZwLzhdNxu0siesmOopfPJNYTi
         Q1TdZV8pOeLQwNRQUl8icKzCsINTo7YVaQnsLEzpwW8cdn8ebQR//CSFnD4fhBQ+Tf1H
         /5cpfU1ilnYG9XecfXoOJT9Rdo/rmcCp+qX1kbiKCAbi4wDgGVgRoX+O+I1b1K+oeyU0
         FGP7wcsVZ+QliZq3POvA6X6UXGMpec7yW+Xf2UG/ZkTUuKhrv53jnj8m6ErVy1fXxDmB
         +Mjl+g8duDlR4HZp7BiVUn1XwXG1kE9jTpWZ5+cx62qyRBaXSt7m1TfF3lm6XM9BoS5M
         1JiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqDgXXUBKgC05Hv+WG8VLItfXbNXEiS/cMK9T9OzjCs=;
        b=qkFSaHidJP9yFpbe74q37Wt0CDO2Juw+S1pIHdNQZ08aqE8RoztQ1IBtQMGxJV5hVk
         JtNbxQTsWavx/4ogIvw5z2RfyvXv928hnRrRJGfvlItMnt1BG7Aeu99lSiHbIyAE5C7s
         R5dqN/r6eKerWbWJOhN5w1L74S5515S9Pjt64+dxliHsZIwB2HcZIJhV61kWVJCQg7i/
         TA5AJTKQxY3M2K1pPufExid7WNQzV6bj75NYlZ4NHO0CWQ92zJ293m638F1Jx26q9seM
         cO/Pzm1yqO8opvinImTBB5MFxAUdHr9wNUxq+7Gf136GTA//9TV711XZZDNIymAfGe1N
         tizA==
X-Gm-Message-State: ACrzQf3e9YTNKIStv1YsFiXibmSOaK3XaBZ5UDHOv80dGbnDMuzD2lOF
        0U/ml2C8ommxheCOgACqXnX2iQ==
X-Google-Smtp-Source: AMsMyM75nkHFBrc8vAbS6QOzzLFaHYxFqm8Mdjtq2X4oVdP8KRhyics/XG4ZyYsOZYHfc53Cnkg3pA==
X-Received: by 2002:a17:906:5dac:b0:791:93de:c61d with SMTP id n12-20020a1709065dac00b0079193dec61dmr3059147ejv.751.1666110828800;
        Tue, 18 Oct 2022 09:33:48 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l6-20020a1709062a8600b0073d796a1043sm7687814eje.123.2022.10.18.09.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:33:48 -0700 (PDT)
Date:   Tue, 18 Oct 2022 16:33:45 +0000
From:   Quentin Perret <qperret@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y07VaRwVf3McX27a@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-13-will@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> +void pkvm_hyp_vm_table_init(void *tbl)
> +{
> +	WARN_ON(vm_table);
> +	vm_table = tbl;
> +}

Uh, why does this one need to be exposed outside pkvm.c ?
