Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C6C6AE6DA
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 17:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCGQjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 11:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCGQjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 11:39:14 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25E996093
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:36:33 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e194so12020532ybf.1
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 08:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678206992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTtKRWqbwOakiT5wLHajjWYxdhCo3hERieQBolp5/vE=;
        b=MThh9HgYlIX8P2Ynk7YnPovsvHl3/TLIntSap+A/VK4IFabVSlozALZJ2RqMTE6iaV
         nhqHu2LdfyL0829yoT4Crlf7cW/LE8rWj2nZlrMsW7hnCMYoyRKXRhq2RobHYw9q+Okd
         v0oeDA3zOHO21JCKaT1eLf4n1p4sVvecVW/ASmyT9a5kMdEdpWLI8EPHWST9Rz1MaAG6
         Yv8IY7tBjtT+prvGUW1vnT3WeloOX+tJqhJQMWhJvUTjzTnfX8Yyzp0qe9ULEVV//QXG
         sY+4gTcm2n/PxUwIVsFfNsZlVV/AM3IxfJGozTHq4vIJKJUyaC3KkT1exdVrkBcgBID8
         S7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678206992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YTtKRWqbwOakiT5wLHajjWYxdhCo3hERieQBolp5/vE=;
        b=jX4hZK+sbs/A+zGmGG4Nl1UHj9f7YzLVNMs/flEI4JfJUbeIw4lwAXp6uGyn/dmG+x
         T/Bqm/+M5D8Yoh8qz/Dy//pjZwRlneDajNao9BqF6KMNm74CmwJ9UDpA4pMu9yzw/LDA
         OPWTxxbyOnpnYQBK1a1wZWS/5lSsLmYt5fz24UZhHx7RyUvIoHnUCQu1CEhrxOFS8Fnh
         0/4V4lxD1ZU5j1WDYub04SHUjAky83D1HdDpqY8Mjlz2hvPpCBb9zh59bPcu1aWod3ZF
         r+xHOm7LUa48J1h77NEhxFQrApLmuoovD+C2QSJaS8NT4+vbK0uaMxa3lTC3Ke4mZXCE
         KuJw==
X-Gm-Message-State: AO0yUKXbggpcsTM922DS6XjhjsZE6V9oebsaNRWyOfy0LDAYb09kW6KU
        ogcKMtpi84DGB4fcIQfd/LB3r9izxRqwQeyGyA2eug==
X-Google-Smtp-Source: AK7set81IXSQxjNIrrYjq/+5nyfj1iJjvfOipuQXOoy7NftexY39u1ZAHsJIFfWDQqX7BXeNfInnwGMxbDJjzYirTX0=
X-Received: by 2002:a25:9702:0:b0:a36:3875:56be with SMTP id
 d2-20020a259702000000b00a36387556bemr9048746ybo.10.1678206992335; Tue, 07 Mar
 2023 08:36:32 -0800 (PST)
MIME-Version: 1.0
References: <20230307135233.54684-1-wei.w.wang@intel.com>
In-Reply-To: <20230307135233.54684-1-wei.w.wang@intel.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 7 Mar 2023 08:35:56 -0800
Message-ID: <CAL715WJFJLtVy_pooEVzsteEq35Wqa9LDFc_gfRjMEm0McfB-w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     seanjc@google.com, dmatlack@google.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 7, 2023 at 5:52=E2=80=AFAM Wei Wang <wei.w.wang@intel.com> wrot=
e:
>
> Current KVM_BUG and KVM_BUG_ON assume that 'cond' passed from callers is
> 32-bit as it casts 'cond' to the type of int. This will be wrong if 'cond=
'
> provided by a caller is 64-bit, e.g. an error code of 0xc0000d0300000000
> will be converted to 0, which is not expected.
>
> Improves the implementation by using bool in KVM_BUG and KVM_BUG_ON.
> 'bool' is preferred to 'int' as __ret is essentially used as a boolean
> and coding-stytle.rst documents that use of bool is encouraged to improve
> readability and is often a better option than 'int' for storing boolean
> values.
>
> Fixes: 0b8f11737cff ("KVM: Add infrastructure and macro to mark VM as bug=
ged")
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
Reviewed-by: Mingwei Zhang <mizhang@google.com>
