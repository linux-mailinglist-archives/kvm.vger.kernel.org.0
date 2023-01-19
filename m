Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358A46743DA
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjASVAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjASU6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:58:39 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2E29FDDD
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:57:13 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x12-20020a17090abc8c00b00229f8cb27a5so636073pjr.1
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bH13mQhRUU7b8EB6xov/auoX/BjFue416NjgtMgR1wo=;
        b=hHQRoWMQf7qVGttNm21+m0vpXxahusZ33qOJQf7eyh496BhiN00fNvXpdowqTe/Cjj
         i1mIKKjvIyKDyvKX3TWETFE6mMF4VeyNlUtIya8Rdvm1KQHlygU+wyJPQ1v5Px+BLptb
         hLIoq93ERlDdsShqm6Md2dOCsTWEEfUFcT0hGJW8u4a4igVo1rCuuMA5EUVsOeDsWEH6
         9kyVc1xUtwg8TPIT6ryJsHN3LOICneqAZ0Xr61sZZPM6I2PYYQprTtuSx2CMLVQJiCQc
         FO1CqXMhIxymQ34Mp5tKQ0aVYzCm4OL6OS0IanwOYctkE/jaKwmCekHR+5om1A9BZP8J
         q4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bH13mQhRUU7b8EB6xov/auoX/BjFue416NjgtMgR1wo=;
        b=WOMqWvtxhekroPYjQfDquVFKS+yAyk01Y56MiUGQmpK5+C81oCohzROXyhKhEzbhx2
         VPUDohHyEAkILifQ2YVyIs88h5Szws0/ShZmE5UjldaVorxOWiZ485klG4OzhmisYdzn
         gmtfjQzMqL/u+NpBWeHmgJ7OxSyflv0aZmINYhO7+RykIZ5IOY7iiuxfH3a4RW4y/mP/
         DisLMScdqiKAO6YXqodJh0GVkuk9r8b4HnmWKwrA3hfI/CpD39inzSO61qlxlTCQOJDU
         t43Qa+GVLzZPTsxmbGePGbDT4CLAiHCA0R/vAB7WSmJAtLVO0uQ4hM7cLXYqUjXw8zRZ
         etzA==
X-Gm-Message-State: AFqh2kpIHw8eloOpHIAWgIEYbH1FT6yPl5IbbFLFpTbGxzgltDkfjHuF
        LZkDoHztvz7GVGz2z10nZYEhurzq9Mk=
X-Google-Smtp-Source: AMrXdXsNcBRRH5SpMRRSQ+uzFtmcWKLZZTqJoUDlgp+y+n+qXW9t/DNW60KeRO1WV4TuJOym80ql7bdcJd0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:cc:b0:58d:bb5c:5050 with SMTP id
 e12-20020a056a0000cc00b0058dbb5c5050mr1157304pfj.44.1674161832598; Thu, 19
 Jan 2023 12:57:12 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:54:08 +0000
In-Reply-To: <20221128214709.224710-1-wei.liu@kernel.org>
Mime-Version: 1.0
References: <20221128214709.224710-1-wei.liu@kernel.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408866924.2366047.9012916781914614502.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: fix an incorrect comment in kvm_mmu_new_pgd()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Nov 2022 21:47:09 +0000, Wei Liu wrote:
> There is no function named kvm_mmu_ensure_valid_pgd().
> 
> Fix the comment and remove the pair of braces to conform to Linux kernel
> coding style.
> 
> 

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: fix an incorrect comment in kvm_mmu_new_pgd()
      https://github.com/kvm-x86/linux/commit/03e5fdfd708e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
