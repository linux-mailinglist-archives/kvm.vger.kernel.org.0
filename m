Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C840B640BCE
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbiLBRJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiLBRJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:09:17 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A850E0769
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:09:13 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 62so4848885pgb.13
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JbEpNpUzseZTQupf42Rj1IKHfu3QLHpqGxrYsl/wNeI=;
        b=mI5cA7a7Sg4TXS0Q5VfJBHIQvZ1ELh7hKpc8t0/8ipN5qOI6hp/FHLxfcP/hVRDl7P
         uQyB/HYT89CTdt+HkzoUetTK9gKWusrqfNO79ltDCsyA23omDi8YKC3AmYlXhZlQxuAu
         /fEsFl8gLO0PEgvinbnVwi8rBO9Ba+PbMnoy/k8tK2glpCxr5G6SvJ4hJpMuWvPZpVH5
         E3VosW0P14YRG2cOzOzTYkSP/FAXH8pgRonht5k8KDdk6x7ljewzNaK9uMvCc2qXdgH4
         zFi3S0RkARbtcDqxxZLnk46HSHdSS8V7JBcWI+/tQFwsfSW1THHtNRdqNchAAYIFnQ7v
         IP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JbEpNpUzseZTQupf42Rj1IKHfu3QLHpqGxrYsl/wNeI=;
        b=NlHQcmPGqrtVAfzGAf7UZNIORGcYMw7TCv02cHFnVVAGls71eVNu3s5iElZ4XP4MMw
         dp+AbrTiJkGQ2BO5blaIQDvgE2wlCd9SN79ZvFdjDa2nBigj1g5iKP8fjrI3cQhEBId1
         rS5XUoqmZb7js+uyrwzfppwhqoJSZgXfC17w3tyreVFkkKwc8jFr6B9OxwpV/087eaqu
         yY4Qzm11wjwyeS0tzCnptlHTwPvzcJyxvW5RPEDCXRaJI2ATt05Vai+hBXNHuPF0cOoa
         wxo8L15c670+a/UMqwvnAf082b+jr/hEQ7Fq0oYA/BZVzyLAArwAqIEYMOnvDnOMb77I
         cMFg==
X-Gm-Message-State: ANoB5pn5R3k50uTiclPtILG30zrG7H5K0aO4Y2yOWUBDfurI/MoRjNPx
        bNOBUSLEn1twxVDm+SAW8L21Fw==
X-Google-Smtp-Source: AA0mqf4kl0zvfaDO4FTtGaa5lHreKmD7cstYdlvhz+MAO6zO8v0H85mFV60iIiabONC9Ox4WnKDcAA==
X-Received: by 2002:a63:ed0b:0:b0:477:9319:eb4f with SMTP id d11-20020a63ed0b000000b004779319eb4fmr47408147pgi.257.1670000953165;
        Fri, 02 Dec 2022 09:09:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b0018853416bbcsm5879737plg.7.2022.12.02.09.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 09:09:12 -0800 (PST)
Date:   Fri, 2 Dec 2022 17:09:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC  8/9] RISC-V: KVM: Implement perf support
Message-ID: <Y4oxNbQwOldICdnw@google.com>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-9-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718170205.2972215-9-atishp@rivosinc.com>
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

On Mon, Jul 18, 2022, Atish Patra wrote:
> RISC-V SBI PMU & Sscofpmf ISA extension allows supporting perf in
> the virtualization enviornment as well. KVM implementation
> relies on SBI PMU extension for most of the part while traps
> & emulates the CSRs read for counter access.

For the benefit of non-RISCV people, the changelog (and documentation?) should
explain why RISC-V doesn't need to tap into kvm_register_perf_callbacks().
Presumably there's something in the "RISC-V SBI PMU & Sscofpmf ISA extension" spec
that allows hardware to differentiate between events that are for guest vs. host?
