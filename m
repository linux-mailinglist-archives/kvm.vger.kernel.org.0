Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F215724BBB
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 20:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239086AbjFFStB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 14:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239130AbjFFSsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 14:48:50 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B42B173B
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 11:48:48 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2553b096ddfso4479667a91.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 11:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686077328; x=1688669328;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fN0Fls1U74QCQM1Xm6ZYG4bCrufqtPp5nAnLDL+EUzE=;
        b=FwQXYRBxBJBGXt1Lq7luAzvVT4DDyzoXVPP8VB7AHg2yHiHbpo6AmHR3BLCubiDzY1
         m+7p40bUs9ndbSQxs9i2hNhFTSYzhA2Ad8c0Zb4QgBSYdfSAds/+4xzyCHpWUZHJ9yvu
         AZGILlP244CpP86XBey+8iLx7C9zzx2103w5IXOwtM1ug40RI1AQBVJNdMqBFD+St9TV
         rZ8GLA4QlMpSRV9ZdSNJVU0neFkTc8ykG6gmIMuXawiD9vkTU7PR1C/uDnt26o8Q6xsB
         bu6f4yXDFNB/9Hzumk2tEshQ/7DFLH6p6bA6h+ZOB7v1xyuVN3UP3W7410NqcfGLrNF1
         Ou0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686077328; x=1688669328;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fN0Fls1U74QCQM1Xm6ZYG4bCrufqtPp5nAnLDL+EUzE=;
        b=L/VY4YIsn4PtG4VKTFQ/UVjr73In1//vUjA5rmrIK6+EDtY+ER5gZHt35TZUJDIQtX
         zKCC9iqznGGLkSFfO7acgOWWqG3vMBWjZ9i5WXBOtjMp4+bbWjIewG7BO3CmoDPcNumx
         Zw7zG024297FzbeuIDruCFozofphM0/1dUG/luu7AE/STzFkEMmkKYNVGnCh7Hq4+Pdc
         /TxsMbrldEcDeWdzy9RvrvbAxaSqHTB4KsHW40K+t6VZhh8Jaqyr0gA5YOSz8EC0vPAu
         9vTdgh7yDmxo0bVh2W+s+GKt8CrXQYriH+dtgBlB9NVVN3vRW7eD17pNo0ivA6zO58mI
         Fh7A==
X-Gm-Message-State: AC+VfDz0OnEFopSkC21aUUf5gWmI4ut11RtXyEZC+Yvdp7EZG/uEF3uA
        xlEvp/Zcw4e3bgwsKVI+Y7nHqFp6Pv0=
X-Google-Smtp-Source: ACHHUZ4cZk+uYmAHt8bLFAANuelXzq0fKbAwTD4UgjWe2H34B4Bp0ysoDuMLU8JEKzLDj67jxa/gQ8Vy5NA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cb97:b0:259:ae68:858d with SMTP id
 a23-20020a17090acb9700b00259ae68858dmr388903pju.1.1686077327954; Tue, 06 Jun
 2023 11:48:47 -0700 (PDT)
Date:   Tue,  6 Jun 2023 11:48:40 -0700
In-Reply-To: <20230522161249.800829-1-aleksandr.mikhalitsyn@canonical.com>
Mime-Version: 1.0
References: <20230522161249.800829-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168607721796.1301198.548168594619269524.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: SVM: small tweaks for sev_hardware_setup
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc:     "=?UTF-8?q?St=C3=A9phane=20Graber?=" <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 May 2023 18:12:46 +0200, Alexander Mikhalitsyn wrote:
> KVM: SVM: enhance info printk's in SEV init
> 
> Let's print available ASID ranges for SEV/SEV-ES guests.
> This information can be useful for system administrator
> to debug if SEV/SEV-ES fails to enable.
> 
> There are a few reasons.
> SEV:
> - NPT is disabled (module parameter)
> - CPU lacks some features (sev, decodeassists)
> - Maximum SEV ASID is 0
> 
> [...]

Applied [2/2] to kvm-x86 svm, with the minor fixup.  I'll post a formal patch
for the alternative approach to "fixing" the leak, I can always circle back to
this series if this approach is preferred.

Thanks!

[2/2] KVM: SVM: enhance info printk's in SEV init
      https://github.com/kvm-x86/linux/commit/6d1bc9754b04

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
