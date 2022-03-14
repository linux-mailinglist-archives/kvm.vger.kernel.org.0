Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF72D4D9025
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 00:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343612AbiCNXNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 19:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343594AbiCNXNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 19:13:41 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB5D3BFA1
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 16:12:31 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id v130so33881993ybe.13
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 16:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6jcGFDnk2ZGG1bJEADu4KX2ojHtFBsAIu/76P0Vp8qQ=;
        b=dEkCRsYp+MJ88Ryr09A72p/YdO6yGqO6HYOT4j+2PmSf1Fc1i9uuNZUJ+dRzhXIR6c
         hxl6+bTXY9g96VrCHB0rf9zglCVg57wIzPMGUcl5G2N5nJP47hZFJ5A4EU3etADVLZgi
         rCnORkYhOEfIzI1brWjsOm2WChZta6k5dxI7S2kWeXNu/p9wcGlH00DgLS5xj0VIdA9+
         kRr9gSd3K2K6tVeJ2E4Pc4R6dxc6xmvfG6BS2pPF+t9G64rYVLNSg+w8f8XYM9gZuG4M
         eD2+VeyTWRB3lxjb3FjgONy4cWYZK5gUSzWbV3xwfDDe8hn56mHOHgTPMbNq8JcjBCJS
         8t1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6jcGFDnk2ZGG1bJEADu4KX2ojHtFBsAIu/76P0Vp8qQ=;
        b=R3FrmyUahi+ihZDKkhwMmzgmnoODcp7fXfsA/TEFXg6TXmhniNdKfA+TUnclN8jDob
         lctV/d5Rng+uIj6zEI8VzW/+eywNlhI7lh53lSC/InNV3fmirvd87njJYYsoG2uZDb7U
         8/uczjhjOPYkc1fkpBpCTDz+u2hizrhqDgMhs1OPzF1kFjtc/QfCx6y3LNEIsD2Az3GW
         Czby/NIvmjoOydA8DRaIrGGyUB3d23kXVf3NS7H2eai1VJMBALC2Hz+kZzQfefmyrf1E
         XrVxkUgX0ogxQ2NtiSHs1/IzDp5qQq5tyTPZBb5KXkl3qpF9iLOnhLjHialAVVlrUHUt
         ndUQ==
X-Gm-Message-State: AOAM532hwM5p7mJkIIjyTums3FGGrs99OAh7XkNEY2Pxi/S+LzjY3vhs
        yQ+HphlMdS8zuv1YP/VTxrNizd4iK5sfn3UJH2YwpA==
X-Google-Smtp-Source: ABdhPJwOFHiGKaFjeiuAVqn0xvjObYV2J61nUJiTd5dhiZHHRCKHynlwkSXGaPtMkDjYwpTL95ZQnsnKJb988XLF1wk=
X-Received: by 2002:a25:d512:0:b0:61d:aded:1743 with SMTP id
 r18-20020a25d512000000b0061daded1743mr19108638ybe.526.1647299550552; Mon, 14
 Mar 2022 16:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com> <20220224172559.4170192-5-rananta@google.com>
 <Yi+DS/BUPMiB+B0a@google.com>
In-Reply-To: <Yi+DS/BUPMiB+B0a@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 14 Mar 2022 16:12:19 -0700
Message-ID: <CAJHc60zTDrwM_cEBKACQjqxceKbCV65mMM83xgPa0xvxMtZo=Q@mail.gmail.com>
Subject: Re: [PATCH v4 04/13] KVM: arm64: Capture VM's first run
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Mar 14, 2022 at 11:02 AM Oliver Upton <oupton@google.com> wrote:
Hi Oliver,
>
> Hi Raghavendra,
>
> On Thu, Feb 24, 2022 at 05:25:50PM +0000, Raghavendra Rao Ananta wrote:
> > Capture the first run of the KVM VM, which is basically the
> > first KVM_RUN issued for any vCPU. This state of the VM is
> > helpful in the upcoming patches to prevent user-space from
> > configuring certain VM features, such as the feature bitmap
> > exposed by the psuedo-firmware registers, after the VM has
> > started running.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>
> I believe this patch is superseded by commit:
>
>   5177fe91e4cf ("KVM: arm64: Do not change the PMU event filter after a VCPU has run")
>
> on kvmarm/next.
>
Perfect! Just what we needed. I'll drop this patch.

Regards,
Raghavendra
>
> --
> Thanks,
> Oliver
