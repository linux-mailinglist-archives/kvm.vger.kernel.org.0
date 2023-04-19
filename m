Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563406E7FCA
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 18:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjDSQk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 12:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjDSQk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 12:40:57 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C391759DF
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 09:40:56 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id eo4-20020a05600c82c400b003f05a99a841so1751366wmb.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 09:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681922455; x=1684514455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7ulxf76hUCZ0akg3GoWfjVZJU9xZOvLTfQ8cLCLnXs=;
        b=lLpEcte1WFIPxs1iYDAcqsvSne5uaJCO31xK1HIHPaNFz96e11Lq9WgLL3os9eTgzE
         GI+2Dz4szYFXhOWkojooOqXvu/8eGchwq1Gr4VUN7wC6AnGt2sMD0NbUCpMPz8vOymqX
         bX4zUie+ggg6sMHO3VCb1tZMZV6Hv66E7rYh2CIsAiIIxu32uBbLkH/ZZAABdQokaxbX
         zzSDAWAYMi3002Ua2FIkWE8zoY7c58nXtCDNW+UhDZM50J8av4F2swhStMjr44K0Ewdu
         6xSfKSBLzBow3J7OWjoEDPLhz/cmBPOnh9qGf5lBktHyhCxnRadV634p6FS/QfFDumH5
         0qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681922455; x=1684514455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x7ulxf76hUCZ0akg3GoWfjVZJU9xZOvLTfQ8cLCLnXs=;
        b=Y+pwqCrpHRSNZSTYuWYX3YsOY4iXO+b/tMvsIxiuysokXZ5ggwvFopmAmFRgQ18pBe
         wO2i0uN33mD0o5rthNw5XzJ0p8G1fwKr61EGLYcSteK1r11qfMvt246OhDBPefusGOHm
         wn8wkcmSNvJ7wX1UIZ0fnUqxrHaKv7FBTuIEYbYySP8v9dMXlYmcTC4AvI7RNh/LaC0L
         NWaKwwnsCTJSxfKZpqONHQQ8iz24jJeIFYLzwmPt8L8d7h94tvavqrt/f9mZevwYo3Yc
         XdKlL/GyRX5rIKlCqaHOjSbqcm80r4Hf0FtlZV+Em6u/7N0RPVwzQjV8BG9huoDxPkQY
         MC1Q==
X-Gm-Message-State: AAQBX9dEBw7AvLPcMAk7MS5lcWtHumKxd76KvfVVZRS2XIfGXUnIUCsi
        9EFx4O7sv/wVWhzvJ2wxL3WOEapf0LLdEyvkZyF32A==
X-Google-Smtp-Source: AKy350Y36y/mjjnrbKOpnXE3uN4J7+Aex1emSDVNVOsx9QcPt8EaxobZWA9Pka67YsWN6T+kDsEPZwmOOkXh2+I1FBg=
X-Received: by 2002:a7b:cbd3:0:b0:3f0:9a3f:c8b6 with SMTP id
 n19-20020a7bcbd3000000b003f09a3fc8b6mr17580825wmi.2.1681922455207; Wed, 19
 Apr 2023 09:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-23-amoorthy@google.com>
 <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
In-Reply-To: <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 19 Apr 2023 09:40:18 -0700
Message-ID: <CAF7b7mpmodkW=vmsNxGRy_bdwFSqMPfnEnG-iKdF4VyawMCNpw@mail.gmail.com>
Subject: Re: [PATCH v3 22/22] KVM: selftests: Handle memory fault exits in demand_paging_test
To:     Hoo Robert <robert.hoo.linux@gmail.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

On Wed, Apr 19, 2023 at 7:10=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> There are quite a few strange line breaks/indentations across this
> patch set, editor's issue?:-)

A combination of editor issues and inconsistency on my part I think,
that's been a bit of a theme :/ Thanks for pointing out so many
places, I'll figure out what's going wrong (and also look at your
non-style related feedback as well :)
