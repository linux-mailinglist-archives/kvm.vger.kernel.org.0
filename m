Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B277A210F
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbjIOOcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 10:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbjIOOcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 10:32:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B66E7E
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 07:32:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5924b2aac52so29180917b3.2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 07:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694788369; x=1695393169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EgH0+vdWhBKkmAM68hgMPvRed2JPtKLNHbHYRKgOnaE=;
        b=nvG530dICqf28YeKAeGxKwv1ltN9QWRsvVqHfVeux/kZjFi/i7Dh6xPr1OFEOSG5Xa
         3JoC+o3GB3In0lZcNxbo17KtK6lcKpzZV5zYTHpI01QYMT2/BJJ2mOfsRn5LFjatkfow
         2zBhZh+A3410kgLflKUx3BrTFz5xUZ7ei/h2lcLSj1HpaStfFTLy2by1LGkdnlrAwqqI
         qSJLJfzg0kApN0rMl+x9dQFQii7EmHnMSS5RCVBYZOtEUCwTK5LagmvbPuaNQNUEh4nn
         ZLHxJD9MmPueDkY/iWZwH6wt7xtZ2fbRxaxhVwGkRwmw8cF/pG5xEEPU+Jrnru7x3l5q
         4LmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694788369; x=1695393169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgH0+vdWhBKkmAM68hgMPvRed2JPtKLNHbHYRKgOnaE=;
        b=W4UDlQyjQu7pQc5GqH1S7CaOOeZuEUbRoSbz73ajkWHmbnjtq8J2/5Ymde1RdEZlyL
         7jjwT9cxj3Psj/1hOAIMdssMmjL3HTGtHjU1o3DmmAWjdOnrB7SM9KrwoVxNYK3ZJ6ok
         SnEFA0tbVQdSApgkhfytUI9Uq1nDc/eg9oWT018XDlvxMFWNYhd1tQurao8fUht+hKV4
         /AvYUgquTSbioOiQqZj19ywZdnfVth7JgWo+Q7EdtbdCL4EDDNqAGCgLlYK1ZThnQ6/U
         oy+Gc+zIPlNBeuMv4VrmWUarAgjAboglbcVhA2/FBS4wMQ15JUwzrwoyywR5tag58Ucv
         2CRA==
X-Gm-Message-State: AOJu0YzqYQjnHqDTs2Yq5s36S8+fz7RO8zPrH2TZ44XOXL4F7kPW0z6n
        iGA49G61hmxEgUlt2PS4Spkj3JbIrcM=
X-Google-Smtp-Source: AGHT+IFJi8kNSVSo9fd0TqO3GO+k0o1Ge0vt5R58ABURLt5K8Li6/umehmpTNkdVGZUfa88+bEL7sv90bS4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac55:0:b0:59b:ee27:bbe9 with SMTP id
 z21-20020a81ac55000000b0059bee27bbe9mr47809ywj.9.1694788368840; Fri, 15 Sep
 2023 07:32:48 -0700 (PDT)
Date:   Fri, 15 Sep 2023 07:32:47 -0700
In-Reply-To: <1e155a46-78f3-51f4-40a0-a94386e8f627@amd.com>
Mime-Version: 1.0
References: <cover.1694721045.git.thomas.lendacky@amd.com> <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
 <ZQNs7uo8F62XQawJ@google.com> <f2c0907c-9e30-e01b-7d65-a20e6be4bf49@amd.com>
 <ZQN3Xbi5bEqlSkY3@google.com> <1e155a46-78f3-51f4-40a0-a94386e8f627@amd.com>
Message-ID: <ZQRrD/CY/pXNlQRX@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix TSC_AUX virtualization setup
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023, Tom Lendacky wrote:
> On 9/14/23 16:13, Sean Christopherson wrote:
> This toggling possibility raises a question related to the second patch in
> this series that eliminates the use of the user return MSR for TSC_AUX.
> Depending on when the interfaces are called (set CPUID, host-initiated WRMSR
> of TSC_AUX, set CPUID again), I think we could end up in a state where the
> host TSC_AUX may not get restored properly, not 100% sure at the moment,
> though.

Give me a few minutes to respond to patch 2, I think it can be much simpler, more
performant, and avoid any races.

> Let me drop that patch from the series for now and just send the fix(es).
> I'll work through the other scenarios and code paths and send the user
> return MSR optimization as a separate series later.
