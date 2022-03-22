Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26894E378B
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 04:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiCVDcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 23:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiCVDcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 23:32:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E1940CFC9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 20:30:55 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v4so14620940pjh.2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 20:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vHhSiR4NEl9sHSjdl1ma5WrsausBMeT/k+B8si8EB+I=;
        b=EirvhGafGNcJ8JIzxwmt3w8wqVW7VQQCgNGmwsfNJyM5G8N8vnyIINJrANxjcZX1HU
         sxkz4TwWf2aaOud7nv7hMfVWj5QsqOBD0/QKS7Bx01STIjEpTASjIULsGMs32X6JRTN6
         7ENoD/2JMxZgitgMpawhuyOFyPG9DaZ1bOgvIqHaM1XLABtR9hLHHw64+zNXKN+d9zot
         27BOebUK+Ur+fzD42eaKjvU3Qi3/lD0sC/N1rqpY6xkd+Ei2ogb+2byLVW1R+8ilbWnw
         FUSgmLzro3VwVdExVS5FEh6vtyB47vCSU0aeUAwnCW1D+QgZNkfr06jS5o2Nr6rZUZYB
         9X7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vHhSiR4NEl9sHSjdl1ma5WrsausBMeT/k+B8si8EB+I=;
        b=NeTXM6RbBkjf81U3PRs+nVJmsDh5Fgng2GLkjcyUdwoVphF80jxYrrs0yOLKHyzAZW
         vxDvUewQzB/1Wz49u67/f88rzsNdqhJDIYMOpPFG2iBFn0rlE7bc7tuYVBiDaCBTKnpk
         KdG+eEmJu1lR7hHdO+NfOHYixJPNLPw8AioAfwhG4S+SupsnZO0hbtTWZi7+H+tyk3q6
         2IoHUfWQoICZGYrivHIcNSZBnVANgHYSCaoYX8Us3crn8y86/zMrEi5LFIB9KtPngWEN
         V0MpGMgduT9dunkFfQYDSNZxYwwEgl3BS5/dxPS5+/Tba1YVwUjpOJKr8Cn32aPMico/
         JuxA==
X-Gm-Message-State: AOAM533umZhtSnYI6zFvbetX/Rllr76dWZz/jizQuM8GAwg3FxvZgrMM
        7sznvbLVPyaS5n0a3u6U4T7jTMfNAFF2jELulzU83w==
X-Google-Smtp-Source: ABdhPJy3GzdAtZ9zwFJ0Bdk3Wa4NlT1lmI0Dn1dcyAmuw0V4DSomEvnW7tgxmmsnbKkUftURU6j5v/g3XrKaVml9LfE=
X-Received: by 2002:a17:90b:1a8a:b0:1c5:f707:93a6 with SMTP id
 ng10-20020a17090b1a8a00b001c5f70793a6mr2565266pjb.110.1647919854371; Mon, 21
 Mar 2022 20:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220321050804.2701035-1-reijiw@google.com> <20220321050804.2701035-3-reijiw@google.com>
 <YjgYh89k8s+w34FQ@google.com>
In-Reply-To: <YjgYh89k8s+w34FQ@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 21 Mar 2022 20:30:38 -0700
Message-ID: <CAAeT=Fyju6Pi4XAxJnTJ20PPJj1wVF_fPLWMFvx5D0H7UovETg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
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

Hi Oliver,

On Sun, Mar 20, 2022 at 11:17 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Sun, Mar 20, 2022 at 10:08:04PM -0700, Reiji Watanabe wrote:
> > Introduce a test for aarch64 that ensures non-mixed-width vCPUs
> > (all 64bit vCPUs or all 32bit vcPUs) can be configured, and
> > mixed-width vCPUs cannot be configured.
> >
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
>
> Tiny nits, but looks fine to me. Only bother addressing if you do
> another spin, otherwise:
>
> Reviewed-by: Oliver Upton <oupton@google.com>

Thank you for the review!
Since I would like to fix one of your comments (the typo) at least,
I will respin the series (and will address all the comments).

Thanks,
Reiji
