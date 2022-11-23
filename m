Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5C9636192
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 15:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbiKWOX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 09:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiKWOXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 09:23:03 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC2193C9
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 06:22:57 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a11-20020a05600c2d4b00b003cf6f5fd9f1so1401789wmg.2
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 06:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O7q+XYng1M6vgFUaz+j49ftUqX+WR8ClrflugSdb5kc=;
        b=edHq3RVn9DSBBq7CRndmDwodvYiy6GSiaortnHNkU6FOZWSCBhRhKpcbD62GCAhPw9
         /QiFv4N/dcL4PCAc8CwIoWgti2RFrN1ptwSQL0NtPHwcbKbUqlyO+hcPAUD4iuJfgM/u
         Ttyxu3uU1BcjwRrqjOsT6g0JZlFH2GQPo0wptSB28ssX8nhyIWd/fZm21ZOVgb/f8jG7
         dEj7s9ihNu16XHgRAoWDEMiIvuX851EkdduRncHXNnUCDGiUhbd1n868j6a1dG2ms/Lv
         Q63rnrk4Y5W3PM18eUUFU39GgY5FBU5TQAbbSFMAytnz4X22ZENR6rkQvHNZxYHni10e
         K2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7q+XYng1M6vgFUaz+j49ftUqX+WR8ClrflugSdb5kc=;
        b=KCTev03N3wwv6DSbsWhBqyfoQBel4FFIata7IP+NwV09WjseAUDRT9H20eW+1OXhs5
         j+4n5e8anDOGzlkevCpGmqfcWkOVv7IU0YBqcQnIohiwbGF/eaZwBNXfsVLSkKGYuGbE
         tniXpXVqcIaaM191r8twUTlsUt+C/hJ1S89hfKlvVuMbbsElrQIjkrvzK0uNvmH/3q9S
         jmHz56s1ScsdSg8PwL2fIinV2g54GdeUDJuYGrwFAtohNipTJzOF+xNswImhKXFQXZgP
         15saWiVk0oTJ+LxAwGDaepcLK0xzG0qI9UL9o///rf+PmOVNZZ8AZOuPOMLSNPafdn+O
         heCQ==
X-Gm-Message-State: ANoB5pkI18IBo/QM/NJPha01y94rzbgucI/QphJ2EC7T4vs/kR09BFix
        rZCj0UJcfk95xzVywR3azCxnbg==
X-Google-Smtp-Source: AA0mqf5VfnqzmwMYBXMzkrpmg1rUoPfdo56SRwF7T9gCWmDowQUGoSpPvQQYpQ0z+4JO0FX8oiJQfw==
X-Received: by 2002:a05:600c:a51:b0:3cf:8df5:68dc with SMTP id c17-20020a05600c0a5100b003cf8df568dcmr19412226wmq.15.1669213376042;
        Wed, 23 Nov 2022 06:22:56 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-748-2a9a-a2a6-1362.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:748:2a9a:a2a6:1362])
        by smtp.gmail.com with ESMTPSA id q11-20020a05600c46cb00b003c6f1732f65sm2730643wmo.38.2022.11.23.06.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:22:55 -0800 (PST)
Date:   Wed, 23 Nov 2022 15:22:54 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC 8/9] RISC-V: KVM: Implement perf support
Message-ID: <20221123142254.2mc3j27kgw37jblv@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-9-atishp@rivosinc.com>
 <20221101153112.hpst2bohsdvqours@kamzik>
 <CAOnJCU++M5jd6toy1J8T+FPGJWSUaw8s9X7sxZY25naPoZeJJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCU++M5jd6toy1J8T+FPGJWSUaw8s9X7sxZY25naPoZeJJw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 04:45:16PM -0800, Atish Patra wrote:
...
> This brings up another generic error returning problem in KVM SBI
> land. Usually, SBI error code numbers do not
> align with Linux error codes to accommodate other operating systems.
> However, most of the SBI error codes
> have 1-1 relationship with the Linux error code.
> Thus, kvm internal code returns a Linux specific error code and
> vcpu_sbi will map those to SBI error code using
> kvm_linux_err_map_sbi.
> 
> However, this will not work for SBI_ERR_ALREADY_STARTED/STOPPED as
> there are no corresponding
> Linux specific error codes. We can directly return the SBI error codes
> from vcpu_pmu.c and modify the
> kvm_linux_err_map_sbi to pass through those. In that case, we can't
> map any linux error code that
> collides with SBI error code. Any other ideas to handle this case ?
>

It seems like we should drop kvm_linux_err_map_sbi() and add another
parameter to kvm_vcpu_sbi_extension.handler for the SBI error. Another
option is to continue mapping SBI errors to Linux errors, e.g.
SBI_ERR_ALREADY_STARTED == EBUSY, but that may not be too easy in
all cases and the errors become ambiguous, as we can't tell if the
Linux implementation generated the error or if the SBI call did.

Thanks,
drew
