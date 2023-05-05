Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2015C6F8799
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 19:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjEERbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 13:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjEERbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 13:31:18 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F46F1A1C3
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 10:31:17 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-51bb4164162so1433815a12.2
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 10:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683307876; x=1685899876;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qAOxuvlzoNXvPjKXSolx+GWj91lIdWlZPd2J+lepu+A=;
        b=YajfbfW6/wtHmrsLEvn1JkH+xI6N003d6IHsKYEdYKyQ4XBOf/ltXYAA8TT//7kx7h
         8wJuT8QRTxgAHxrmJYouhI/7YgQTZm4mO10KjPCgeJdJMeuE5+h/bLiahSr81Gm/ecKB
         zDx4TcPrzUJvkSrnc51y29YU+lehMTLTirJ8zF6Y7AvgQTUcfYtQ37OJnKLDHV7h0smL
         PJn351waqBTnvLrthFCgyYl4ojqlUIUMdMZ9mvD3/1gMVpPtasu86bb2kRnLpCKWJhO/
         k73RbTIykvnJHtRsAnnJa8Km60QZxDXHqCZ+6V04mHM7fIYa6vKKdRMKt3CdepgXl1bi
         CXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683307876; x=1685899876;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qAOxuvlzoNXvPjKXSolx+GWj91lIdWlZPd2J+lepu+A=;
        b=kyKk8ktrJ97ncd3TDlAInDpN4trG7viGJ1FwvWmUjtNa0MHXeCrcVm4D7clSX2De7k
         Mem+binpZcNSqIKSgqEOt2kVseNj/ewVwQbd3TBzOjG8dHVCFsBVDKgcYszvkjz/1cbN
         ekyKizvaGipIVI/eoOQDT3ZDu+WROQWOJ8uu4EwODCCryljKFWXUp577BX7PoAK56KKx
         kgS/qSOXwig+TBloiNol3c/P3lOJJmndlB50/VH6tOkMzcSHCvW3L0+RJEvC2r9Offax
         J8fW5M+2qhZ0+wF39C79HRuuS5VQWgcMuyXku134kq+yihYBNOL/S2ymh1tOjjvca3rU
         Ge9g==
X-Gm-Message-State: AC+VfDwg0oujvP9SXjdzOnoHxiAwNR0bUN2ESRVnmh9UrBIwPAmN8FZs
        1SaDvKLZHgaISr3kpLkBgGELoAKC0Vo=
X-Google-Smtp-Source: ACHHUZ5AKtrEhFxY1tyiq165vY9w3gn7Qqc7+wcBsvMx8OszEeBENNSnTQn/dNy8sL8BRZ1pG6YlJeRQjuk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:152:0:b0:52c:407a:2279 with SMTP id
 79-20020a630152000000b0052c407a2279mr529292pgb.0.1683307876644; Fri, 05 May
 2023 10:31:16 -0700 (PDT)
Date:   Fri, 5 May 2023 10:31:15 -0700
In-Reply-To: <6412bf27-4d05-eab8-3db1-d4efa44af3aa@digikod.net>
Mime-Version: 1.0
References: <20230505152046.6575-1-mic@digikod.net> <20230505152046.6575-3-mic@digikod.net>
 <ZFUumGdZDNs1tkQA@google.com> <6412bf27-4d05-eab8-3db1-d4efa44af3aa@digikod.net>
Message-ID: <ZFU9YzqG/T+Ty9gY@google.com>
Subject: Re: [PATCH v1 2/9] KVM: x86/mmu: Add support for prewrite page tracking
From:   Sean Christopherson <seanjc@google.com>
To:     "=?iso-8859-1?Q?Micka=EBl_Sala=FCn?=" <mic@digikod.net>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        "Mihai =?utf-8?B?RG9uyJt1?=" <mdontu@bitdefender.com>,
        "=?utf-8?B?TmljdciZb3IgQ8OuyJt1?=" <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        "=?utf-8?Q?=C8=98tefan_=C8=98icleru?=" <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023, Micka=EF=BF=BDl Sala=EF=BF=BDn wrote:
>=20
> On 05/05/2023 18:28, Sean Christopherson wrote:
> > I have no doubt that we'll need to solve performance and scaling issues=
 with the
> > memory attributes implementation, e.g. to utilize xarray multi-range su=
pport
> > instead of storing information on a per-4KiB-page basis, but AFAICT, th=
e core
> > idea is sound.  And a very big positive from a maintenance perspective =
is that
> > any optimizations, fixes, etc. for one use case (CoCo vs. hardening) sh=
ould also
> > benefit the other use case.
> >=20
> > [1] https://lore.kernel.org/all/20230311002258.852397-22-seanjc@google.=
com
> > [2] https://lore.kernel.org/all/Y2WB48kD0J4VGynX@google.com
> > [3] https://lore.kernel.org/all/Y1a1i9vbJ%2FpVmV9r@google.com
>=20
> I agree, I used this mechanism because it was easier at first to rely on =
a
> previous work, but while I was working on the MBEC support, I realized th=
at
> it's not the optimal way to do it.
>=20
> I was thinking about using a new special EPT bit similar to
> EPT_SPTE_HOST_WRITABLE, but it may not be portable though. What do you
> think?

On x86, SPTEs are even more ephemeral than memslots.  E.g. for historical r=
easons,
KVM zaps all SPTEs if _any_ memslot is deleted, which is problematic if the=
 guest
is moving around BARs, using option ROMs, etc.

ARM's pKVM tracks metadata in its stage-2 PTEs, i.e. doesn't need an xarray=
 to
otrack attributes, but that works only because pKVM is more privileged than=
 the
host kernel, and the shared vs. private memory attribute that pKVM cares ab=
out
is very, very restricted in how it can be used and changed.

I tried shoehorning private vs. shared metadata into x86's SPTEs in the pas=
t, and
it ended up being a constant battle with the kernel, e.g. page migration, a=
nd with
KVM itself, e.g. the above memslot mess.
