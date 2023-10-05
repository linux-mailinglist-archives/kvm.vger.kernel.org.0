Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83667BAEA0
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 00:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjJEWH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 18:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjJEWH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 18:07:58 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0578A95
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 15:07:57 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-57b5f0d658dso844755eaf.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 15:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696543676; x=1697148476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVEDH7DIG0wbfSQq3l//NlGrUn25Tt5fS9CoqUlLrR0=;
        b=dX5L6pPBp1HQzqDZfR+NFyZRAi89ORDqfdZ4I+0Xr4obaWr6STir7HyDyxBu0G/wv4
         3vIFNmphOlQcRcrR17OudbWHm05ITkW0S5sTVKi+m2H1qrpeZjxPgwiWLNhcMqHcv9EQ
         6qO6rxPAdRLqvLUCe0i3uPeSxz11mvsU95pJeV5w1FEHheN6lg4TmUqGUSjcWcJSb0mB
         +5xpSzZ7wJPNCzQiz8ADUibZudDOTZzDN1w2RQoXKR7wfjBKeUrTab4MwD0PmHQS2Sys
         rKIkP5mBbQNc5WsusDNl4IJyW+x6EOR2VUpCzBBQmxBP983LQECNk/lipjlefx9b5d06
         IMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696543676; x=1697148476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVEDH7DIG0wbfSQq3l//NlGrUn25Tt5fS9CoqUlLrR0=;
        b=Ly1ZUYhDOrCEMAjMrQMxNaMmjSba8tiCJKh9d1W4/YLDNfXEqn5aDYV1qlsquzQitW
         5No6Ui/hifl40JZQRxBLiswwIfsyx+U1O9M8KdQnkZbeZGvOROxAIRsck2Gy4yAEf5WF
         sp2SONPtu66KKa/ZHmYbQ0fIzaAP7axl7g/E3rPxpOeyQpVq67+HrKA3EdYldw6n6yjW
         xzQCR3EAYafwtZ9q8C4B9/hI460ySA8B/1d46AyO7UfkKX47rOHlZ5TPP+YgS5O2fVpe
         DCG5N7lJ4BZYgfHrX3zp+ptxWQVqX+biL3AJmKKBa4tWEYHD2tX/+iYrV6iTXuaypyT6
         r3nA==
X-Gm-Message-State: AOJu0YwQMh9POrQmjn6UpWxZ5i4FnPGSjQqHs4/W0Onvhb3FLm8lt34/
        lFJZfHyt3exm+Xk7rM76oP68wz+1VDPufqHm/xrEUA==
X-Google-Smtp-Source: AGHT+IEZBLWG7MHKbRYLlAd2jmfuZ64eocXXaB5o38fDnCbh9AkI5WYrmKeXE/dRrdn/9j/liwFQcw/a3M1v6AdfJBQ=
X-Received: by 2002:a4a:270d:0:b0:57b:4f1e:96e4 with SMTP id
 l13-20020a4a270d000000b0057b4f1e96e4mr6802480oof.1.1696543676303; Thu, 05 Oct
 2023 15:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
 <ZRyn0nPQpbVpz8ah@google.com>
In-Reply-To: <ZRyn0nPQpbVpz8ah@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 5 Oct 2023 15:07:19 -0700
Message-ID: <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 3, 2023 at 4:46=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspace coul=
d be
> "unreliable" is if something other than a memory_fault exit clobbered the=
 union,
> but didn't signal its KVM_EXIT_* reason.  And that would be an egregious =
bug that
> isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruption woul=
d affect
> each and every other KVM_EXIT_* reason.

Keep in mind the case where an "unreliable" annotation sets up a
KVM_EXIT_MEMORY_FAULT, KVM_RUN ends up continuing, then something
unrelated comes up and causes KVM_RUN to EFAULT. Although this at
least is a case of "outdated" information rather than blatant
corruption.

IIRC the last time this came up we said that there's minimal harm in
userspace acting on the outdated info, but it seems like another good
argument for just restricting the annotations to paths we know are
reliable. What if the second EFAULT above is fatal (as I understand
all are today) and sets up subsequent KVM_RUNs to crash and burn
somehow? Seems like that'd be a safety issue.
