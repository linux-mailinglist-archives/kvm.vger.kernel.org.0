Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8730A59A646
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 21:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351423AbiHST2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 15:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351349AbiHST17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 15:27:59 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7061B82F9A
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 12:27:56 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 24so4419727pgr.7
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 12:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=OdVRHW5dgn9+ZFv7Dx3d9MQVdeaggjviefmhBuLYccY=;
        b=KLiHLmUnTwUW4nPAcccokb8rqDM7RaZKR3tAhfpWrqa4fyUZ11fQGnRCahlJbMSNkc
         K7onznVTAcTPdJ5ctU5qfok0xiXA4RUZWWeXukjQhEL0KrbtzmRpe90Uuw2GudQ6cB3z
         wqidMjhzn3TYXU35oygksNUgU3fknacc64G2XK3+HLTw5IWBs6csGTW6/65ggSWB/q94
         VV1NbgwFLjrAIvYqiN/GSEoDRheHm2Jcs0J12eYCvBM3w1EYrjOcPA4TzdFyaz7+hBZg
         W08yNzJhuyiH6ybAoXgAL2/XGKRMYk/cdwhxrx/frztCzW3qlKJK1yFKPYJyVcVN9uzT
         Z1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=OdVRHW5dgn9+ZFv7Dx3d9MQVdeaggjviefmhBuLYccY=;
        b=Z2rBzBi3qJvRCR+CJmVD5Ti0/9p2dTJwa++yCPm6LJ3NzgASfwnD0njIQbBRV1+HMU
         iAez7pQNUKDNBn3b079XvkzH3ApHG9fcy74EgsSSrxrqwZunKs67qrpt7ob/UC+Bw3s+
         BmpAUoACH+AkSnh1TslKTfjpT5HBN2leEv9wqTgqyMxPtGcTDKjiMnLwV2RmzEjGR1eh
         1d+mJPZ9VcOlJ0fLJCrf12Um807x8Tq8Fz0MiVShT98sPxYi4IHLBTCXV8tPO57+v0v/
         RKJc2mi6JR3I6X33pybSjmz7iPvKa0Brxsm3wkbV0jz4hm33XbM5Rnj/LUWIYkYySmqE
         hbdg==
X-Gm-Message-State: ACgBeo354w4KmJ26n3LyUOVo+nQgnvoIC6qb0wLr4XfWRhqqmhE0KT8y
        d6luyJ2ImuT2OB2Maqcww0pNz/CmRBww5M9Us7tKWA==
X-Google-Smtp-Source: AA6agR6GwGgHvB/kIWBltf1ldR8xs3lS7wiIsIOwazSdhvuDPMSNX6TOwG4x6BLYFJ/S/btctxhQLjTtMJ9Rygnp60E=
X-Received: by 2002:a65:5941:0:b0:41d:a203:c043 with SMTP id
 g1-20020a655941000000b0041da203c043mr7317812pgu.483.1660937275721; Fri, 19
 Aug 2022 12:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com> <20220810152033.946942-11-pgonda@google.com>
In-Reply-To: <20220810152033.946942-11-pgonda@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Fri, 19 Aug 2022 12:27:44 -0700
Message-ID: <CAGtprH-emXA_5dwwdb4noOC-cuy3BTGT8UbKRkPD8j2gjBSu+Q@mail.gmail.com>
Subject: Re: [V3 10/11] KVM: selftests: Add ucall pool based implementation
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, andrew.jones@linux.dev
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

On Wed, Aug 10, 2022 at 8:20 AM Peter Gonda <pgonda@google.com> wrote:
> ...
> +
> +static struct ucall *ucall_alloc(void)
> +{
> +       struct ucall *uc = NULL;
> +       int i;
> +
> +       if (!use_ucall_pool)
> +               goto out;
> +
> +       for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +               if (!atomic_test_and_set_bit(i, ucall_pool->in_use)) {
> +                       uc = &ucall_pool->ucalls[i];
> +                       memset(uc->args, 0, sizeof(uc->args));
> +                       break;
> +               }
> +       }
> +out:
> +       return uc;
> +}
> +
> +static inline size_t uc_pool_idx(struct ucall *uc)
> +{
> +       return uc->hva - ucall_pool->ucalls;
> +}
> +
> +static void ucall_free(struct ucall *uc)
> +{
> +       if (!use_ucall_pool)
> +               return;
> +
> +       clear_bit(uc_pool_idx(uc), ucall_pool->in_use);
> +}
>
>  void ucall(uint64_t cmd, int nargs, ...)
>  {
> -       struct ucall uc = {};
> +       struct ucall *uc;
> +       struct ucall tmp = {};

This steps seems to result in generating instructions that need SSE
support on x86:
struct ucall tmp = {};
   movaps %xmm0,0x20(%rsp)
   movaps %xmm0,0x30(%rsp)
   movaps %xmm0,0x40(%rsp)
   movaps %xmm0,0x50(%rsp)

This initialization will need proper compilation flags to generate
instructions according to VM configuration.

>         va_list va;
>         int i;
>
> -       WRITE_ONCE(uc.cmd, cmd);
> +       uc = ucall_alloc();
> +       if (!uc)
> +               uc = &tmp;
> +
> +       WRITE_ONCE(uc->cmd, cmd);
>
>         nargs = min(nargs, UCALL_MAX_ARGS);
>
>         va_start(va, nargs);
>         for (i = 0; i < nargs; ++i)
> -               WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
> +               WRITE_ONCE(uc->args[i], va_arg(va, uint64_t));
>         va_end(va);
>
> -       ucall_arch_do_ucall((vm_vaddr_t)&uc);
> ...
