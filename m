Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B5159A8AC
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 00:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbiHSWfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 18:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242363AbiHSWfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 18:35:37 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C611D109583
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 15:35:35 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m3so2179308lfg.10
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 15:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=evm3p80JS4RFtejj7lVlvHfBUpyOJbSSQegi5i+9Wzk=;
        b=EiU+YkOaG3KPMnxSH1ZllhyaUuXl/fYjdo8aBvcCfYA8mB3X1aIbhhJ44G+YW3h4rL
         2X9x86WDT0FFwj4v0c3cpD0NoAPGcdTXyLLVpHyGYaijyQGdheScak35Lm6CUEAQ0S3/
         lCf0ROezwbNibi4mOOS2zSNyyOIrk7iVuBkDh02MnfJ/xZ+PZ0Wp+sLVlS76sS7soGyL
         AdlCdlfmj4/7A5yZ4ICCkqoqaQ2AUpH33Za6x51O7cnb4rzeQbQE09kjopAOJnNL3Ct5
         v7WOIXT4VA3gDLtnoNb/YEADTbA4I2SqB1j9NzmH2ktZ3SDfpqNz35m0row0DSD2SXTc
         Y35A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=evm3p80JS4RFtejj7lVlvHfBUpyOJbSSQegi5i+9Wzk=;
        b=oPoi/iCKNaeUtLmvgbrRlRJfLm/8Vmo9c/GDI3GisY4YixqtZpz4sPmAaWcpMn6iP0
         /JijOcR1vXNVJQSDLtn1lkF0I6VzhuSmPuxipgiYVmm77QJgAJJG53nszOVMTiOYviZ0
         IQMtjXk6mEot/vznqYqIMr2xg5Y7EbMII0yhb5KnrKOvCc4hb6GznTT798WUVJcosrzO
         Qp3ub44kBJmdlG/jNfT+RDeS+HndYzcKSD3hxTVDyX4XDKj2sTteY+IMch7BquXxq0GL
         r5SVe7U1kNPCdidnfeGBtyzED7eP9odq0l1KRTcIofIvtNBaqcMJoIVBI0NyFBhJ0Dqv
         AVWw==
X-Gm-Message-State: ACgBeo3RUwfKHrUL4ztZ6lzXICCweY65LQfXGhKxD0UUn4uXVv3iQsJv
        lKOT709pYSG/zkkM1S4hVvPsJ1QU8Rw/NSxQOKmk4w==
X-Google-Smtp-Source: AA6agR5fgDQUO2gZF9+mEm6EDADZqLBkEYrhCiiVJ7qTnt1tCOvWsOKfI4qpEsHdS4v6j5rkeE8Zz2lsT1xsMlcSng8=
X-Received: by 2002:a05:6512:3ba8:b0:48a:f8e2:8ee8 with SMTP id
 g40-20020a0565123ba800b0048af8e28ee8mr2873212lfv.104.1660948533871; Fri, 19
 Aug 2022 15:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220819210737.763135-1-vipinsh@google.com> <YwAC1f5wTYpTdeh+@google.com>
 <CAHVum0ecr7S9QS4+3kS3Yd-eQJ5ZY_GicQWurVFnAif6oOYhOg@mail.gmail.com> <YwAP2dM/9vfjlAMb@google.com>
In-Reply-To: <YwAP2dM/9vfjlAMb@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 19 Aug 2022 15:35:07 -0700
Message-ID: <CALzav=fHWjAXthLUHJf2LdKCx1i4UO1u7iK0C6gw=y4sRw37-Q@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: selftests: Run dirty_log_perf_test on specific cpus
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Fri, Aug 19, 2022 at 3:34 PM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Aug 19, 2022 at 03:20:06PM -0700, Vipin Sharma wrote:
> >
> > This will assume all tests have the same pinning requirement and
> > format. What if some tests have more than one worker threads after the
> > vcpus?
>
> Even if a test has other worker threads, this proposal would still be
> logically consistent. The flag is defined to only control the vCPU
> threads and the main threads.

s/main threads/main thread/
