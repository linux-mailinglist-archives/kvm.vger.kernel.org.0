Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A096FE33A
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 19:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbjEJR0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 13:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbjEJR0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 13:26:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F220213B
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 10:26:45 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50bc37e1525so14291321a12.1
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 10:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683739603; x=1686331603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HJL+JhQmxU9qA5lMrvGM05IUnqGL3GZgrHCNTgjj3t0=;
        b=v3awAP8GUD/ZDAJvrp2L+Znr7TDIkUCt5LWmzipwChCwH7m0oNy7iOV/XqpkYIvXC/
         BaMLy1q5d30O1WltT+xWOddJUdKCZ77bVEh+iIGcn7clk+Pr7J34ZR9C6HjlOh0M8PQN
         +KtV3eWjkMhmHGFj3VzXyHLN12k3kTd0Xp27WmEQMgAvOXZx8+M07tdd09LAcdq9S5gw
         Op6AeU8UYav4jAMxNbO8sejmCm826l+LN+yd8U18+i4+BXzX9kJ4pN6hmGxz+2JMRPVy
         lnOmcSZWW/LN0u/yOT1Hm6pCFNYc9LVNZeLjV+RSIjZHbsGsFCzBdebHdWJa6cCrS655
         E2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683739603; x=1686331603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HJL+JhQmxU9qA5lMrvGM05IUnqGL3GZgrHCNTgjj3t0=;
        b=fghgQlr5a1RK0PfmTA9xN0vNiO2rmVLRMkhQWkzpNWvz7cp3qrSLQWLkAuzZmAXAM2
         zDvmW1rh5omXDDbSmqhmM3uh+D9cDIlHuzIC8HYQXsRDBahsy3oRRplc3UZ7OP5LEgRk
         YKwfwF3rdAMqxgPXMCF1NgCqZqbTDr+ucM5b/OZSn4WN579U6HMNJDNbyLO6/zagNDNY
         66OkItpVbSVlZcj/SKGYE/plBzWbqmB75BndOwCypXXD1a5pSv54OtPVdB8Z2/zKI3lT
         5bmMB/h7JhDl21U4YfGDqGqW7F4c1R5LQD96PuVvimMaPWgkQHXwoU6O1H32aIPzwXj6
         ax7g==
X-Gm-Message-State: AC+VfDztEkDvaKREzNH6YDMz4OEVE/6251L7x75ZVcp/l62nIQOljMXu
        W1asRq5pI1axqWZ0FzZLc0e4kUceyNkkEGadA84nog==
X-Google-Smtp-Source: ACHHUZ64G94ODQQyPBdm7IGyu9kHzcE0JVQFyt0rwKkromaOxP7k8Aq6aDDkSvekpiO3NFhe4DF5fY89lBIyRxbDjfw=
X-Received: by 2002:aa7:cf95:0:b0:50b:c4f0:c200 with SMTP id
 z21-20020aa7cf95000000b0050bc4f0c200mr15479402edx.41.1683739603390; Wed, 10
 May 2023 10:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com>
In-Reply-To: <ZEM5Zq8oo+xnApW9@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Wed, 10 May 2023 10:26:32 -0700
Message-ID: <CAGtprH_+bF4VZg2ps6CM8vjJVvShsvSGAvaLfTedts4cKqhSUw@mail.gmail.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 6:33=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> ...
> cold.  I poked around a bit to see how we could avoid reinventing all of =
that
> infrastructure for fd-only memory, and the best idea I could come up with=
 is
> basically a rehash of Kirill's very original "KVM protected memory" RFC[3=
], i.e.
> allow "mapping" fd-only memory, but ensure that memory is never actually =
present
> from hardware's perspective.
>

I am most likely missing a lot of context here and possibly venturing
into an infeasible/already shot down direction here. But I would still
like to get this discussed here before we move on.

I am wondering if it would make sense to implement
restricted_mem/guest_mem file to expose both private and shared memory
regions, inline with Kirill's original proposal now that the file
implementation is controlled by KVM.

Thinking from userspace perspective:
1) Userspace creates guest mem files and is able to mmap them but all
accesses to these files result into faults as no memory is allowed to
be mapped into userspace VMM pagetables.
2) Userspace registers mmaped HVA ranges with KVM with additional
KVM_MEM_PRIVATE flag
3) Userspace converts memory attributes and this memory conversion
allows userspace to access shared ranges of the file because those are
allowed to be faulted in from guest_mem. Shared to private conversion
unmaps the file ranges from userspace VMM pagetables.
4) Granularity of userspace pagetable mappings for shared ranges will
have to be dictated by KVM guest_mem file implementation.

Caveat here is that once private pages are mapped into userspace view.

Benefits here:
1) Userspace view remains consistent while still being able to use HVA rang=
es
2) It would be possible to use HVA based APIs from userspace to do
things like binding.
3) Double allocation wouldn't be a concern since hva ranges and gpa
ranges possibly map to the same HPA ranges.

>
> Code is available here if folks want to take a look before any kind of fo=
rmal
> posting:
>
>         https://github.com/sean-jc/linux.git x86/kvm_gmem_solo
>
> [1] https://lore.kernel.org/all/ff5c5b97-acdf-9745-ebe5-c6609dd6322e@goog=
le.com
> [2] https://lore.kernel.org/all/20230418-anfallen-irdisch-6993a61be10b@br=
auner
> [3] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shutem=
ov@linux.intel.com
