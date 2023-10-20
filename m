Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB78B7D1969
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjJTW6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjJTW6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:58:04 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53F9D76
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:58:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-27cf48e7d37so1214698a91.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697842682; x=1698447482; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3YJUbXLc41eB4MhMk4dwKPTxYx78Ax4qZ5YkFcbOnrU=;
        b=g52c0ASOETzdo/gVmHylVla5THW3yVGVj08JVffS735RQPUzH0/F2tbA1xZ+MWz+YS
         QCXTvJT/ylvBacMZUATKxaI7EAkn5zglv0t82S0oKDvCIsUjY6LTlyrXcqVJY2Pp638H
         3MhbBWzbXO2RcImP75cK0yOnSfYFsvFMxHqWGSyyu3Zn33qAOhF9R6TG6zbQ9e/uC8O+
         cK35FJl+AmCFkZatdzqM67tcChmr1Rwrp4g5GcvmKg7Ny/bMfj3CdPrcDYnEsy4WuiYf
         cbF55Up3i4jQnSmYF0mY72Z7ZXZ4dnvw9v083Z/GZ2zqCrPYYcusxhLByEVe9EIsZbl2
         Y48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697842682; x=1698447482;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3YJUbXLc41eB4MhMk4dwKPTxYx78Ax4qZ5YkFcbOnrU=;
        b=FI7FCth2LBTG7abgRUlQ5F3RNplisE1OzsrQ/mAsCvcOB3pZdhUoduSYoynwxwj/Yc
         u1h0A8s9DiKoWslhVb1DgsUgFBe6ub9V/R7gOprL+BqHDPt3N/yd47jXXYhtoSWXDdtp
         9v+Vx5hru7T6dE643Tp3VKfNQRhSCmj7ArH3DAosnRcgNiRexXXqBKAOFDtLfcF8zJGf
         S3bA48zTYbzoUVB/kxgwrzDe5NnLoQ5wk2EPHHMoIZi7t4ecWR/KJ3g4OemiZmEfY/Mb
         B+JOreTnwzxRMBkOjw+6ZIzSAUz7pxpuTDkUSr2cvyE7ZyylT6qKfUEBHCVsRha/27z9
         USng==
X-Gm-Message-State: AOJu0YxXAujOpcPvPQEwc/dW6hPPHJZBBemyz2+7N6Ouz0R5rtUjKBOQ
        UYRR5WE8VziykM0XnUmumDEH8VcS48s=
X-Google-Smtp-Source: AGHT+IGfYZWevFY4LmuyPUFyRmMlkbI4CYl3i++HdLF4sX1XJI0e/0I3e9txRYNsBFnmgQ94Pj9gzteLP7Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3788:b0:27d:3b44:86fc with SMTP id
 mz8-20020a17090b378800b0027d3b4486fcmr74085pjb.7.1697842681955; Fri, 20 Oct
 2023 15:58:01 -0700 (PDT)
Date:   Fri, 20 Oct 2023 15:56:25 -0700
In-Reply-To: <1ce85d9c7c9e9632393816cf19c902e0a3f411f1.1697731406.git.maciej.szmigiero@oracle.com>
Mime-Version: 1.0
References: <1ce85d9c7c9e9632393816cf19c902e0a3f411f1.1697731406.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169773243871.2018423.1481448432661434673.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Ignore MSR_AMD64_TW_CFG access
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Oct 2023 18:06:57 +0200, Maciej S. Szmigiero wrote:
> Hyper-V enabled Windows Server 2022 KVM VM cannot be started on Zen1 Ryzen
> since it crashes at boot with SYSTEM_THREAD_EXCEPTION_NOT_HANDLED +
> STATUS_PRIVILEGED_INSTRUCTION (in other words, because of an unexpected #GP
> in the guest kernel).
> 
> This is because Windows tries to set bit 8 in MSR_AMD64_TW_CFG and can't
> handle receiving a #GP when doing so.
> 
> [...]

Applied to kvm-x86 misc, thanks!  I added a paragraph at the end of the
changelog to capture the gist of the discussion on why we agreed that having
KVM eat MSR accesses is the least awful option.  I also tagged this for stable.

Paolo, holler if you want to grab this for v6.6 and I'll drop my copy.

[1/1] KVM: x86: Ignore MSR_AMD64_TW_CFG access
      https://github.com/kvm-x86/linux/commit/2770d4722036

--
https://github.com/kvm-x86/linux/tree/next
