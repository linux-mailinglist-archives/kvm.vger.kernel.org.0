Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A1B7B999F
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbjJEBbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244482AbjJEBbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:31:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C775FF2
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:31:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8943298013so612107276.2
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696469496; x=1697074296; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xda1ecjjiZbKdQWHkJnno+SGBsr2H774i+dBsqhxAuM=;
        b=09BG38DVeLWEjNHuaZ+fb4rLdAQgUd+QVXF0SILiXaHAIQuiTqRb7C6dXbNpFkrUvv
         E+2mZAdf70uH2F+4CCOhRWHzp0E6MLp6J3aqDYnSgrEO1T7q05Fib33ejRv9kXoceOb9
         UanpQDi2mRWiBadvuHFHZCr9X80i3r2XEzwbRY26HJmU3B/CDWwAg6gaW8VyGQDSIpaP
         os9enJmVwTnlOARbP/PjHxBSgkAuuQuJNgwRvfGwY0goCRMZscp8ZLQTxWRY/Wh6KAU4
         QabK73HaGz66jVLxKAdGV3TnESAIgSQ4X1tD18cwHt0yB2umSZBXuqGuQFbUa3GNlp+p
         1ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696469496; x=1697074296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xda1ecjjiZbKdQWHkJnno+SGBsr2H774i+dBsqhxAuM=;
        b=akw1ghWxj0CKY9HsRB/GP8Hx/HzoSGv7GyaOCiT4oGN6zYR8ml6snBa7jgfY0ciWc2
         +4wNJlYwqr9YfWgnrGBbvMOZhK9tx8BYrhQ0YBsL2tsrvFs5+DTh8nJ8EYq24IwhP+y2
         kfzszycx6k6m3Sr7RDNolnzeCEK5HI0l8NbbbsJRvIKFCYnr8RSPv1sDnoQhfSktgsQm
         jdztHW+YtypaHPpcANVRPdlbdnhwh9ukM4tyt9xoHr/BO3ncL5ZP7JCv4jw/SJHp3JNT
         Y3NYSW+e1rWim1ZGbRIUXMcI6MAp30BDnE8JwWPLJeq+YjbQ7dRRuPbGBmeDc7fo8ULm
         xq2g==
X-Gm-Message-State: AOJu0Ywccl+PpmusbonZX+MjTAxNkv2GetHnH6jKASg2825ZLt+UHqll
        owxK6uvyShBWsj+axuFi+wnQ6haZksI=
X-Google-Smtp-Source: AGHT+IG2aHVyPg3d16ztOsdHyjEi6jHqc3esaJjLX34jL1vQcS5VxBAA/jrDErtGK3O7Nln4DyQKobwzaB8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9a04:0:b0:d74:93a1:70a2 with SMTP id
 x4-20020a259a04000000b00d7493a170a2mr62326ybn.5.1696469495720; Wed, 04 Oct
 2023 18:31:35 -0700 (PDT)
Date:   Wed,  4 Oct 2023 18:29:37 -0700
In-Reply-To: <20231004174628.2073263-1-paul@xen.org>
Mime-Version: 1.0
References: <20231004174628.2073263-1-paul@xen.org>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169645826229.2822648.14767470474793635064.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Durrant <paul@xen.org>
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 04 Oct 2023 17:46:28 +0000, Paul Durrant wrote:
> Upstream Xen now ignores this flag [1], since the only guest kernel ever to
> use it was buggy. By ignoring the flag the guest will always get a callback
> if it sets a negative timeout which upstream Xen has determined not to
> cause problems for any guest setting the flag.
> 
> [1] https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=19c6cbd909
> 
> [...]

Applied to kvm-x86 xen, thanks!

[1/1] KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag
      https://github.com/kvm-x86/linux/commit/409f2e92a27a

--
https://github.com/kvm-x86/linux/tree/next
