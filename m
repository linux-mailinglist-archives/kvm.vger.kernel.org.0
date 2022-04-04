Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860784F0D78
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 03:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376884AbiDDBx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Apr 2022 21:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238610AbiDDBx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Apr 2022 21:53:27 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04CAAE48
        for <kvm@vger.kernel.org>; Sun,  3 Apr 2022 18:51:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c23so7008352plo.0
        for <kvm@vger.kernel.org>; Sun, 03 Apr 2022 18:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/HPdEv1u1dHBI9/8ZBUeRoQdCX9qorofNrQMRHwE/GM=;
        b=TH7dk7njieIgZMTiOMnEIMvq+kdoMWSqtMYSxG5nKkNG4lplBb6nOcZElTyYhgdDrp
         hR9rgg9oE2w1A7L4evuBKkZ258pqZoWl2wBuPX3QeTUN0fsmzRuh3Mi6Yxn1H37IQqg3
         X80ZJeF8GbE73f1zPSqOYhkLWEUPe0NE+5q76iLvJZ+4uFD40aOTQ8rkoBvoF0xBvVie
         CWx92BLBNo6CsWPLZOmC5jsJ/d8/XNmGI+oyuCS8ixp3agIFVepWHZjPhNcTQWmvgMX8
         GgSAV2Bj+pC7Xv0vAQQJIXIDDv67tLEX4dg644wEjpR/Eq+2cR+xwBxdTEZ3JJLdkvxM
         sqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/HPdEv1u1dHBI9/8ZBUeRoQdCX9qorofNrQMRHwE/GM=;
        b=M+fekxmwofkdIXNT5BWrmHT7agN+qX1fooWhTgAabiMLkp3GHxlEa0hjMQ9VYyd9fo
         kW6Xva/S5/9mjtRv5yIMhd0iKg89bw/BVmzCPSNuD67UrIxaYYKBSL3y/L5hpj3QKhFW
         vfmqD7vzp+HTYjVS4Is4JHf79j9BzFww1xp/lyt03qAc99s5+SzGojvIOCNCvseJNCUj
         IQRor9G7ig8URNKYif3fOhWFhsrkGoSFDAmOpl/X2aSxywQnPJETxzvIL+FFhpGE0vzs
         1ebczdY2VGI+c4t8k0sQ3arw7eXEUl2GcepimDuBe0QFySyEjIddu7Tv+22egRiDZvT5
         ESHQ==
X-Gm-Message-State: AOAM533g7ZMikIIdGEbDPvZkNwHEFAirlWOL+RGhl+qFNWlKyfniIxZg
        jYE7Ue4tfJMKGWVzDFpZ1+VtAYspXchmw3CQS/RVeA==
X-Google-Smtp-Source: ABdhPJxyxERsq7XOg9dz4MNtcUQNW88b6cSv75PSoe0iFwSBsyc+IpLz523KkiK7LrRy69grM1vP5GttYQgnmHlw9TY=
X-Received: by 2002:a17:902:c215:b0:153:8d90:a108 with SMTP id
 21-20020a170902c21500b001538d90a108mr21434704pll.172.1649037091972; Sun, 03
 Apr 2022 18:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com> <20220401010832.3425787-2-oupton@google.com>
In-Reply-To: <20220401010832.3425787-2-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 3 Apr 2022 18:51:16 -0700
Message-ID: <CAAeT=Fy=aUNHq7zWYxYOLWvR-nOZr5Gdvu1yNiOisgtJ3SF1pw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Wire up CP15 feature registers to
 their AArch64 equivalents
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
>
> KVM currently does not trap ID register accesses from an AArch32 EL1.
> This is painful for a couple of reasons. Certain unimplemented features
> are visible to AArch32 EL1, as we limit PMU to version 3 and the debug
> architecture to v8.0. Additionally, we attempt to paper over
> heterogeneous systems by using register values that are safe
> system-wide. All this hard work is completely sidestepped because KVM
> does not set TID3 for AArch32 guests.
>
> Fix up handling of CP15 feature registers by simply rerouting to their
> AArch64 aliases. Punt setting HCR_EL2.TID3 to a later change, as we need
> to fix up the oddball CP10 feature registers still.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
