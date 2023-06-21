Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6177738EE5
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 20:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjFUSeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 14:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjFUSeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 14:34:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139EC1995
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 11:34:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-988689a5f44so490574666b.1
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 11:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687372441; x=1689964441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MkTkg0yk5G+m/3RuQi582p9no07noJpOVWR1uVt2QJ8=;
        b=jhU2qXV7zgZAHlPuzJt9roWj9xYxOAu1wdHns/nRruICat6vZgD6g7WT66fmeD7eJC
         SYrdE5LfxQViiL6lSz4LSuSIoJr9/06WPjE8nkVTCvYQbI7uT6RcV3QmKgya8iN2QkVD
         ddp8ZNe0TBekwvv68uje4kaxI8i10czLrcDvDhsRwfiKW950/CS5k07O93fwZNlyieBo
         L4DAIRaspsoyTxggLGA5y651H1fMcenqDEg44Ab00oou5Iy3ni91xvXPrZiGTaVBfrad
         B/bhazmIbrfha7bOoi56i8PYPVUf2uMiHfQ17gYuCwaWR3Y1C64AIx92fJ6PXll7A4Ym
         gTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687372441; x=1689964441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MkTkg0yk5G+m/3RuQi582p9no07noJpOVWR1uVt2QJ8=;
        b=W9XR8SGxDaXXteA/+Eyu/1jAGSPj3omEjwfgWpwSLrchddS6T+imEkFT5CgcGRm6Yu
         MVhNA4ugXLXYwhzKoV+af+eDdANn+iFYQchxM2mR0Lvu0nSRwDPsktYISE8/ohNDujkf
         /k0oQNOTGrAiujmL5Ryy6I6Nv/RItMV2cuCgx0706EcsmZ6XQ8XS5VbHh8d3zPOsAk1J
         EHNrTVHgS3+G09bLpfRJ+Wfbpt2XnkU0yjirb+xeN2WMlWvKHXO8C4Tp4j/OTOLLOpPC
         +WoAg9z0dwlPbSrytgcApV9vP2BrwwzSTYEDvP0oLQ3Utx1Jy/tRjVLUZruDkNFjTeWS
         +TUg==
X-Gm-Message-State: AC+VfDwhDFECSmXiNVikcMLYJjZkVy0gMfOfd6N94eRCFmhFRAwuTCs/
        ym5PGjWtUOSuXJXhjdPdNHlokdKB2bZgKQzYsto+OQ==
X-Google-Smtp-Source: ACHHUZ56mWPIZN9zRu60o7GkY+dtcQe/JAx8qk37vaGZg5yLb4G/foH80j+heYxIq88Od3vZR0/ZK5nlyTE1OnKvpwg=
X-Received: by 2002:a17:907:3e92:b0:988:7cdb:943a with SMTP id
 hs18-20020a1709073e9200b009887cdb943amr11674209ejc.30.1687372441404; Wed, 21
 Jun 2023 11:34:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230618000856.1714902-1-mizhang@google.com> <20230619120051.00001f0f.zhi.wang.linux@gmail.com>
In-Reply-To: <20230619120051.00001f0f.zhi.wang.linux@gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Wed, 21 Jun 2023 11:33:25 -0700
Message-ID: <CAL715WKF8Ws1E0UNvRNQ7ZqisrFD6srC3o24g8FU=f=f0YwUKw@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: Documentation: Update document description for
 kvm_mmu_page and kvm_mmu_page_role
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 19, 2023 at 2:00=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.com>=
 wrote:
>
> On Sun, 18 Jun 2023 00:08:50 +0000
> Mingwei Zhang <mizhang@google.com> wrote:
>
> > When reading the KVM MMU documentation for nested virtualization, I fee=
l
> > that the description of kvm_mmu_page (and kvm_mmu_page_role) has been
> > lagging for around 1-2 years. The descriptions for several fields in st=
ruct
> > kvm_mmu_page and struct kvm_mmu_page_role are missing. So I think it mi=
ght
> > be good to add them to make it consistent with the current code.
> >
>
> This is so nice. A trivial comment, maybe refining the tittle of PATCH 1-=
6 a
> bit: "Add the missing comment of xxxx into xxxx". It is a little bit conf=
using
> by just looking at the titles at the first glance, more like some members=
 are
> missing, not the comments. :)
>

Sure. Yeah, the shortlog looks slightly confusing as if I am changing
the actual data structures. I will update those in the next version.
Thanks for your comments.

-Mingwei
