Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B016743B7
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjASUwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjASUvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:51:15 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8472E5B8C
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:51:14 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id j1-20020aa78001000000b0057d28e11cb6so1419937pfi.11
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I2tCCje/5pOyO5VnTjmGeAPKEpXwqTjK1CxJlREHoLc=;
        b=ZUxDCKMVQjNq0Ad3LmKcfXxLYPQlie6QymBRU9CgWvPnQmU9YNW3vRcaYzXlDf5zGK
         iBkYKQDM6BTanCHAesuDCeGhnFpa2ZowBqPYTml16CUd2+O15v5wsT6cveJwoqmF8CW8
         h0HfBZNFXtMwqWwyYMJSUdqn1BfLD8pZSZTcHMI8By/yzItKQB6xJrffJGRrtRZ4+L9v
         ZT05TsuLk0jaJP1yfvVCxxIz35gDfSZzhEDPnlsLTg5plULU5US3BsDMYdswsCXEJ6GO
         XvaQhJWSwaX4TsjwRTdHjGGn8lP3+TNR5q/VjVjJm5S8Wh806CvafZKa6FDaBcZEFwpp
         Encg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2tCCje/5pOyO5VnTjmGeAPKEpXwqTjK1CxJlREHoLc=;
        b=3Ib6eXAHcphU57JkVcBGqXvjrQV3xMmWHE5db2gAPjyZwgawJSw4X3h3tnoxx0MasP
         gb1tJxqmFcdLUSbXS6jH5W8Gc0de30SlLiaA9M6rRCHaA7r/oyP8croQu/rB++HBNK0L
         YUQ0pyYqqhGRO56I1uvYeLqN0uBdR26NwGXcFSV221uy/1dYEfSp01dea7lc3UJYhNeX
         ExSFCs9ykdIZiDZxw0LBSdfgucXvxHKPlpvTMs9EEYC2s9D1jrDyRqpXEzQ5jQLaO4h1
         ma/vo3gjEi3qy7ZbwE34cFb+SMnGx5N31vF6++PBc//abCPmJpHtgiTkYmWsARtJEWDX
         FiQw==
X-Gm-Message-State: AFqh2kpjoBHre+8QHMGNQZSjKONqUGhN2vJyS81PlchA254azhyH3NRG
        Ds3ctNHMnFl6htQRBKNTbDvRcn+hliI=
X-Google-Smtp-Source: AMrXdXuMJ72KATZjKKGdUxfwU1BnmbdJhYoDO22X+Eb8X1jmyzmFoSUv42Aa7I3d+0m8g/hjK7t9hHqafUo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:12cf:b0:194:b631:69ac with SMTP id
 io15-20020a17090312cf00b00194b63169acmr838250plb.39.1674161473999; Thu, 19
 Jan 2023 12:51:13 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:48:54 +0000
In-Reply-To: <20230106103600.528-1-pdurrant@amazon.com>
Mime-Version: 1.0
References: <20230106103600.528-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167409095498.2375862.15711695818147385057.b4-ty@google.com>
Subject: Re: [PATCH v7 0/2] KVM: x86/xen: update Xen CPUID Leaf 4
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Paul Durrant <pdurrant@amazon.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 06 Jan 2023 10:35:58 +0000, Paul Durrant wrote:
> Patch #2 was the original patch. It has been expended to a series in v6.
> 
> Paul Durrant (2):
>   KVM: x86/cpuid: generalize kvm_update_kvm_cpuid_base() and also
>     capture limit
>   KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if
>     present
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/2] KVM: x86/cpuid: generalize kvm_update_kvm_cpuid_base() and also capture limit
      https://github.com/kvm-x86/linux/commit/e3ac476711ca
[2/2] KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present
      https://github.com/kvm-x86/linux/commit/509d19565173

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
