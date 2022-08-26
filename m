Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE935A1DD5
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 02:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiHZAxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 20:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiHZAxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 20:53:36 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4893C8884
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:53:35 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id k10so296585vsr.4
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Fhu/EVEBLSu/3KSf5ItZEuzOt/5JilGlFLRwNgSUIxY=;
        b=c76630Lu8LzWdOPChT9C2E5frjk/NZyKMsyV5oYEe6DyQfF0dLBayYZoxmxhWX1o/p
         1JobhHmvWBCPWxC1xdMXfHW3l3dS8eqQeRoNr+n8Hr6Gg9sTDBETjySGa0m5aE5knoTv
         Y2wvV12VngbxEHC4JDXqrs0TRMwckEFpuj9MtioXPWtgxLE/X7NAkI/uqLnr9jfAR9yS
         BS5ipIkcCMf0N4QjPabJMlDvRSxkzdbU0YpEO3LKWB02KaBpvKKkousZ4XvQFDWegoGE
         KVe4Sb01aZTpJoO+Iy8m5/xBroaJFZkbBQQfWizG+tZ76SaPkoxBmtCSJlaZrX1ury9t
         Zlag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Fhu/EVEBLSu/3KSf5ItZEuzOt/5JilGlFLRwNgSUIxY=;
        b=l7d9bGCGGg+lQFKxZJH9hbfdB3WG5aTz8idxaslCNLSLlkH2WoOvjZm9a2QQGjmxsw
         VsIgi5DCTg+Bg4atcPzM03YTdlsRrLItGX6LDVC6rLHKr6nqFEvVMhRhcNibOb2dscqF
         J6ZfwzpwghGqlGDwxKjkbQVBGfk+1OkIakX+ZLG8GgX8s8fsC9+mQo6IgkDo60sm1RDd
         ql4IQAMbC4T4KR686wbSf7dMy791d9I16Upbp/8JibaFkrTzYxmw5GOnusOMRaat2vFl
         GMlhHFgOzUtGWP+C1t9Yy3VwLotFDGvH3+pMAvDtLKdhGkndvnQ7hHqWiEhY6/ZDjZX0
         26IQ==
X-Gm-Message-State: ACgBeo0ZP/80vfq/9tNzmLr+Z7kpx2wpHzFQlizLV/7PgdGXw+1/ulwr
        /dKRe8wZ6LYcf9e9otWVt+uMQeaRiac7hx0bn8n/GQ==
X-Google-Smtp-Source: AA6agR5dA3FEzav0fnfqK8HpXi7Nmc3Rw5gadbvBD/pSPCDDrQA3YlufC6mUMuZkEvdFfwE59ZqW1e/QZg0k48DNEFU=
X-Received: by 2002:a67:ea58:0:b0:38f:d89a:e4b3 with SMTP id
 r24-20020a67ea58000000b0038fd89ae4b3mr2426094vso.51.1661475214815; Thu, 25
 Aug 2022 17:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com> <20220825050846.3418868-4-reijiw@google.com>
 <Ywepg6c4FT7DvJ83@google.com>
In-Reply-To: <Ywepg6c4FT7DvJ83@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 25 Aug 2022 17:53:19 -0700
Message-ID: <CAAeT=Fw_c52n8aAUHQLDmhL8sB3iZPwS59ji4wxBKFeLSRwtaw@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Aug 25, 2022 at 9:55 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:40PM -0700, Reiji Watanabe wrote:
> > Remove the hard-coded {break,watch}point #0 from the guest_code()
> > in debug-exceptions to allow {break,watch}point number to be
> > specified.  Subsequent patches will add test cases for non-zero
> > {break,watch}points.
>
> Also worth mentioning that you're opportunistically zeroing the debug
> registers as their values are UNKNOWN out of reset.

Yes, I will add that description in v2.

Thank you,
Reiji
