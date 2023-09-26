Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDD87AE2BD
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 02:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjIZADo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 20:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjIZADm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 20:03:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C1DFC
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 17:03:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81503de9c9so11815638276.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 17:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695686614; x=1696291414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5YTmwARNMOrdL0eY6PvUVfzk6lroU7KMzCpG5updMAI=;
        b=AQQRUSkViezKihFy3fWNfoGQEEUOwvy9p7Mk/oZoT8f2N7jqkml9velSThK2chQJo7
         l1v4oG6Ek0TSXECzmfook1Q/pIGKsoSOsccrVsT2tMVj7NTYvrkRr/nqHShW7z7Mihr4
         loluEL+QO6hhHVBbHjQYGSClbQ2lKnDt4A4Kc9BW9QgnXfKo4SBi/tDmQnPeIVM9/4gd
         cHP3rUboBkvs3bZOHZ97dWja5UXkPWmw/buorojUBBCbEHvTYAt95YpEsIfkdJcWkWSF
         VzKSLtVp23Fuu5D4MBid8Zf5jWGVK61sxjhKxzzs/e09i4PNpbUruLPw5Xnrvj7RvsCQ
         7wVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695686614; x=1696291414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YTmwARNMOrdL0eY6PvUVfzk6lroU7KMzCpG5updMAI=;
        b=Sm/HDpRpCTVkCjY531wReU8HDD+2ZJNkDzYdAKZdbuNz52IyVOuZqOpkQHwOWPhsgg
         Ql2G3YdU8tDVtlyhpcg7TNQfl1BW0fVwPCSOk4HrNWG42vG5HitAgO7VSNMjgb0jKAss
         V94Z1itILF5GM0But44JzHUCRaf0ucTePrTV0v9n5ao+OIZAoklHD2SPK0Yr42TVwxyN
         pdMenoj2k2m5rBTX8sFBvb1d1icKBTSY1hWrQCUMX5MEz8PJr7WPgdbzAaZbOvnJDzdF
         17NNOG/kOWArDLmZUAl2hObAJBm9/4R9RgnFvk8PR39YvyBLWtlYGsFMujdpld6VZOVQ
         hmFQ==
X-Gm-Message-State: AOJu0YziVjWZdPZBTGQqvt1wog01ycRLgRjtOwbxwN1f5bNv2nmI+vZb
        JF5h2s0vY2W9tf9gGvaZ7818UxHxFFI=
X-Google-Smtp-Source: AGHT+IFjtBd5I0scOusAJ1S2VeqlSo5J7SdEiPZyy00x6t7yvgHWHk1UFsAAVu290oHDscIwGC6Us6oDYvo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:161c:b0:d0e:e780:81b3 with SMTP id
 bw28-20020a056902161c00b00d0ee78081b3mr82351ybb.2.1695686614668; Mon, 25 Sep
 2023 17:03:34 -0700 (PDT)
Date:   Mon, 25 Sep 2023 17:03:32 -0700
In-Reply-To: <20230924124410.897646-1-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230924124410.897646-1-mlevitsk@redhat.com>
Message-ID: <ZRIf1OPjKV66Y17/@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: tracepoint updates
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 24, 2023, Maxim Levitsky wrote:
> This patch series is intended to add some selected information
> to the kvm tracepoints to make it easier to gather insights about
> running nested guests.
> 
> This patch series was developed together with a new x86 performance analysis tool
> that I developed recently (https://gitlab.com/maximlevitsky/kvmon)
> which aims to be a better kvm_stat, and allows you at glance
> to see what is happening in a VM, including nesting.

Rather than add more and more tracepoints, I think we should be more thoughtful
about (a) where we place KVM's tracepoints and (b) giving userspace the necessary
hooks to write BPF programs to extract whatever data is needed at any give time.

There's simply no way we can iterate fast enough in KVM tracepoints to adapt to
userspace's debug/monitoring needs.  E.g. if it turns out someone wants detailed
info on hypercalls that use memory or registers beyond ABCD, the new tracepoints
won't help them.

If all KVM tracepoints grab "struct kvm_vcpu" and force VMCS "registers" to be
cached (or decached depending on one's viewpoint), then I think that'll serve 99%
of usecases.  E.g. the vCPU gives a BPF program kvm_vcpu, vcpu_{vmx,svm}, kvm, etc.

trace_kvm_exit is good example, where despite all of the information that is captured
by KVM, it's borderline worthless for CPUID and MSR exits because their interesting
information is held in registers and not captured in the VMCS or VMCB.

There are some on BTF type info issues that I've encountered, but I suspect that's
as much a PEBKAC problem as anything.
