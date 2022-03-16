Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41424DA881
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 03:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353063AbiCPCj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 22:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiCPCj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 22:39:57 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E8A20F48;
        Tue, 15 Mar 2022 19:38:44 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o5so2069281ybe.2;
        Tue, 15 Mar 2022 19:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=beHpj5JAWlaoc++bFsSH0fXaGFVr/upMyISOw0UCyLE=;
        b=j28XZqTaTBbGV5ZoEnmcxjfICuXvlgvy9t0Z9p3cZrd35JfDonkD/L4ovmaILPRC/E
         xy3uZhyj/Ptyq3/H90dFCkIL48qcft9F2tHiKi9G7MgoMbRbMI9WNjtgt21GejkTaXNq
         wq2zwyDhSkhD/n9aDKICgBGOzI8Xq/U5NNDbicPw4HQAaMvli/tHT+DQzJYI1aXtOWQo
         c7n/EnXMc37SpnhIO3nK1nTMlF0o0Oq+W0qAd6VgdzcjsmREBhjldsVaAm9m+VH+OnVU
         QBhdvQ4ZWrZSaVdgkVm6CramkaIn+BBiS3t5KCeHNaHz8axUdD/P+B4+4jXBPPQErUgr
         +C1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=beHpj5JAWlaoc++bFsSH0fXaGFVr/upMyISOw0UCyLE=;
        b=BXjvJnkmZ5KO1Ws+v0leChEK+U5fU9ldms5iRTVBw2VSvUXcKgeQGRzYzotS4EqxnD
         QK61H9U+hjM/uHVu4slKDjYU9wP5UtVkSi90VMCmQ1wXJqLbLDd9fbLO3h82ihEfrU7m
         Xdj6hDL8Q6fmkvojEQYh5nnrPzvYej7tdArsxV8HEuMlEseL9aRfS5gOLYsIVebRerYj
         3DLQ2gs5JIA3Qk+STfHKjeSBYDXK6TbnzSIgcYgqq78ws6s+U/VwCfKaqfYrLnN5O4Nb
         l/HtXigt7Sps+bgYqJE6CDGijcrhOS6wp+GgrSCSHaELZXC3gwYit8uU4nKYqKTEh/KS
         F1/A==
X-Gm-Message-State: AOAM533bfmzqH/GPIKomUFEAnAIdcH6fGfQgiX40a97df5zU4OPmS3Hc
        RHwK5LnBwYu9qEsHeoizIWqxdgJvGikpQTC8n1kkdm+XozldSTpk
X-Google-Smtp-Source: ABdhPJy+2XkqzeK5gibMOPsaLhpDuQdWag/l1vmj1R15mdj+QM//7ImHAJJUiSmtqZX9c654QPlfCDWFXw8EvDA2g1A=
X-Received: by 2002:a25:8f8b:0:b0:629:33e8:9c6a with SMTP id
 u11-20020a258f8b000000b0062933e89c6amr26432029ybl.552.1647398323590; Tue, 15
 Mar 2022 19:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220311070346.45023-1-jiangshanlai@gmail.com> <5cc80cc7-8088-3bb7-4bbe-40c527465658@redhat.com>
In-Reply-To: <5cc80cc7-8088-3bb7-4bbe-40c527465658@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Wed, 16 Mar 2022 10:38:32 +0800
Message-ID: <CAJhGHyD9Vvjj6ZpnBgRsuon+Ts2Qbn20oo-+Xi2_9cWF4QdGvg@mail.gmail.com>
Subject: Re: [PATCH V2 0/5] KVM: X86: permission_fault() for SMAP
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 5:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/11/22 08:03, Lai Jiangshan wrote:
> > From: Lai Jiangshan<jiangshan.ljs@antgroup.com>
> >
> > Some change in permission_fault() for SMAP.  It also reduces
> > calls two callbacks to get CPL and RFLAGS in come cases, but it
> > has not any measurable performance change in tests (kernel build
> > in guest).
>
> I am going to queue patches 1-4.  The last one shouldn't really have any
> performance impact with static calls.
>

It is not about performance, it is about "less surprise".

The patchset was made due to it surprised me that "what the hell
is it when L0 is using L2's rflags when building shadow EPT/NPT for L1".

After some investigation, I knew the L2's rflags is "ignored" in a very
hidden and complicated way which relies on code in several other places.

I think some additional comment is necessary if that patch is not applied.
