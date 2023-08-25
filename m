Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7810788F15
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 21:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjHYTDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 15:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjHYTC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 15:02:59 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3592E2690
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:02:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-594e5e2e608so1996787b3.2
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692990166; x=1693594966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lkF8HC++Qf7cGjgxZMsjOTZMESDaoCpW5C43MWMv8aM=;
        b=LXNX5TA8aHnFLADA7zjZOU3xdGUcDEqnmFhm/ONADp0hqgd4llq9OS6VyO/VRtR8or
         LhIqzc7eA8V4jQn5Z9PVgQLha9+qkruVN4IAEpFPFn6SjRC2TvA6Zke2lcW0jqGScvcH
         0bhY2rlGQINC5qFWDGT0hJ9dE9RQ7fG8lr/ejLh+OblV3TpdlzHYvvAp3Ghm10kncRfd
         7fSWvxgsQaTF7jkNCRPE9h0rJNXZuoPKVnw2uXMZvmGA4RVHUGRHgwb0uB8hVgJTznZV
         KiZ75GotczosQLt+ty5serzwwItp9xxdlKCSiXb1zI+kAWhtijtdbZmeMQwJtOZelp54
         2ntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692990166; x=1693594966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkF8HC++Qf7cGjgxZMsjOTZMESDaoCpW5C43MWMv8aM=;
        b=kQwACoJfM6mM3/g0yYT+IQy96NsC7tSMU9FwWBSmz3LFEub8b8kr6uYWJk4IZy9Ugo
         RHfp+295U7fwSfPslsUd0gjhxUuFgAx2yXxmRnPLcyDgygZH5oun/d9ezIVx4xE3ZTbR
         AZ3Db0QEC2Y/Z/nf/cm2CDZongANiWtTfWtRHiU4PhDHuZEVYtjjbEjblJiZgnaCq7tH
         ZJfGdf2Xc2NApwuGoDAs4n2PNgiMaMFiAkfMx4EMFuNTPu/E1t5Ai9whYYQdGq2YieYy
         SlTd3XNc41VcZM/ZHTcc2ReQuOLRvSthpTHtrn9Y0/k+7V5uxXaW+RUk5/pqDbu93TZk
         CeQQ==
X-Gm-Message-State: AOJu0YyMk95DVUGX68yn9X5NSwujfPQHyQQ1EblDITyEbe7n2oIf75NZ
        Xkkn5U/b3S36K1S54J2rRbZHOC2ONAQ=
X-Google-Smtp-Source: AGHT+IGjyRCLQFc9+X3WZ1j6KjcKHNfotrK+SO1usxAAAAeEtt4NbM3dx4n+qBep7RoJ7YlWU/BYmqD0hxg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b660:0:b0:573:5797:4b9e with SMTP id
 h32-20020a81b660000000b0057357974b9emr527684ywk.1.1692990166490; Fri, 25 Aug
 2023 12:02:46 -0700 (PDT)
Date:   Fri, 25 Aug 2023 12:02:42 -0700
In-Reply-To: <20230815174215.433222-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815174215.433222-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <169297955779.2871906.7970773718400668561.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Delete ancient pr_warn() about KVM_SET_TSS_ADDR
 not being set
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thorsten Glaser <t.glaser@tarent.de>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Aug 2023 10:42:15 -0700, Sean Christopherson wrote:
> Delete KVM's printk about KVM_SET_TSS_ADDR not being called.  When the
> printk was added by commit 776e58ea3d37 ("KVM: unbreak userspace that does
> not sets tss address"), KVM also stuffed a "hopefully safe" value, i.e.
> the message wasn't purely informational.  For reasons unknown, ostensibly
> to try and help people running outdated qemu-kvm versions, the message got
> left behind when KVM's stuffing was removed by commit 4918c6ca6838
> ("KVM: VMX: Require KVM_SET_TSS_ADDR being called prior to running a VCPU").
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Delete ancient pr_warn() about KVM_SET_TSS_ADDR not being set
      https://github.com/kvm-x86/linux/commit/9ca0c1a1265c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
