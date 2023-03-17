Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784996BF6A2
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 00:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCQXt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 19:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCQXt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 19:49:28 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA665C172
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 16:49:26 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j7so7414691ybg.4
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 16:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679096966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5fL6F3mPwoA7sLSKblKlhrnG1SyfjvzqQaa+DnqN6I=;
        b=jlzykgWGzVdf2uGbPxbEO5u0/e5FGFX0CaSijaUHBEXqOPlr2pWjeVpYiXVWeUOZUN
         Mfh68xsB9pk3pn3fhvIMjWCkK98hgS7t+3sIQx3KGJi5+cXX6sQNaL3qF3jcQJoNrfVd
         rxSxrh6md6PlO4IWVaJCx/xis1AnGGO5vNs2VG4O2vcbMGFniWU0SFYq7PM9ZOODaOI+
         fDZXXvav8cKIvKofGAzB1N45w4h0Upa4LAjJfmvG5OzWfNdEu17JA4SALVfN7oSZ/FsS
         AbEkFxFGCaQQudJdTdNZtxs4GLBJjZ4N6VYeX/dUj01vvqHinvmz8avGz6mk+k42JTpJ
         qtrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679096966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5fL6F3mPwoA7sLSKblKlhrnG1SyfjvzqQaa+DnqN6I=;
        b=qZ27nrKiJGwRm2P7Gxy9L94fwUonxMkOa+K5yYNdt49hHJJR+v0wW0I8byYJJ+QInv
         +WdxeEpHllcznZv+PffQxkWCZZAoMLpoS6cQDGzaLrxW7eOwThE4nxGl09tNpRNP/WiY
         5COaUclantB4BXQnO+AzoEI8quWOcZNW7L3Kt91faz6m7TY0UtCoS2UfERhyBQOu4Xz3
         49k3E2o5zXlmWFl7UqXTOSDFQ2I0jE1btaIFNYGe+j40QoI1dnVN5XA3aFDXLcEN98B8
         gnOUYcwgkusqbrE/n6D5ZCeaGW2+UlypJ4bH4yNriQ+UmmA08tFn+FLhv0ngoSVQ0wpd
         HfBg==
X-Gm-Message-State: AO0yUKV1YN5u8BQCoQB1O3Uj5qicdq5JEK6k85nl5F3V50/bIpx1aL0/
        EBl5GUrt6AqMg1Dc/5hb/xBm3EmcGCBPaRVpvzYbXQ==
X-Google-Smtp-Source: AK7set8Pz4tY+CCiW+ssZqKDXY9nva643d3YexIUkH3Vjz9KgB+OIFgOVsqyUGKWq2Caa6x2e+Rlfn6/Q1xCm7RzeUw=
X-Received: by 2002:a5b:70c:0:b0:b3f:f831:bfdd with SMTP id
 g12-20020a5b070c000000b00b3ff831bfddmr184229ybq.13.1679096965695; Fri, 17 Mar
 2023 16:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com> <20230211014626.3659152-8-vipinsh@google.com>
 <ZBTu40/IYurmQi5N@google.com>
In-Reply-To: <ZBTu40/IYurmQi5N@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 17 Mar 2023 16:48:49 -0700
Message-ID: <CAHVum0fM3CLda98e-nBP6yPBLkRvBhUq=iZqZGCC_6jT08SM0Q@mail.gmail.com>
Subject: Re: [Patch v3 7/7] KVM: x86/mmu: Merge all handle_changed_pte* functions.
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 3:51=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 10, 2023, Vipin Sharma wrote:
> > @@ -1301,7 +1283,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, st=
ruct kvm_gfn_range *range)
> >       /*
> >        * No need to handle the remote TLB flush under RCU protection, t=
he
> >        * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freei=
ng a
> > -      * shadow page.  See the WARN on pfn_changed in __handle_changed_=
spte().
> > +      * shadow page. See the WARN on pfn_changed in handle_changed_spt=
e().
>
> I was just starting to think you're an ok person, and then I find out you=
're a
> heretic that only puts a single space after periods.  ;-)

I know, I know, I can't help it. I just love the way single space
looks after periods.
