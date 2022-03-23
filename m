Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A194E5701
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbiCWRBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiCWRBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:01:38 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE71375E5B
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 10:00:07 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-dda559a410so2309166fac.3
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 10:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TV0oSDRHiJymPDNvAXTxfZzTo2VZe2I/axS41WuuY70=;
        b=my1cWR6Rh+0RcmMEq5FG5TrEo8BEnU6rdhNBXANAIK6yfOazwVLY6RVDsfMz/jEDR7
         dTE8pfntIyxgjNmfEyNQsw+BYPWGgvVSycJALr7Wn7ANAefOYSOEXK/Te+RfwLCRJSZY
         WQWNODMAPr2VcdpOsW6IlRLG3BNf2oCb1XvUbj2J0HelpY1uA0IaXigrVjBraUtzGm7s
         8TCb8JfCyChDlrCRsL+pAjfGYzCHZ8rHBrTIuaQ3h2holgRggK5dJeSQ8KQni9PZ6WAh
         hLMmL6ZNDVor0PzvNLvBtFeUXpCaB7UnN9TI+SkpvnYz2uJ8v5ciGRxdCvTdQYyGkQ/1
         5org==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TV0oSDRHiJymPDNvAXTxfZzTo2VZe2I/axS41WuuY70=;
        b=WcdgQvP7jlOiDm64gQzHrtqzepogWFGwqQaIREwgGvbzeA2Clka7D/th3pNLzJQA7H
         yYjGvnQg1rx2jWe57wQySjVOTL7+wr3UP3IoD4pFrC/+aY+pA4DjDI92j4Hv1R7XZwM4
         ICRNB0zjZldsTuaaBVu6fyleIK7nVPImMiKlMMRUk0HuED+Z5yhdTUwgWTq/ShUdqDH3
         gPqRfIpBUT1vjK9Xl7f+2S4p4+l/jCEiBy8G0KY6n36P1/0bXn5qvSdJnBb4JL0BFtKE
         FZU0wPB92G+qqs/ERXmADM1lQ0w1GFrcc35hZSNcmc2eF5+Zbk94dAwP690ZosEQ/dbZ
         +s0g==
X-Gm-Message-State: AOAM5335OKgjCivx270TFq5Pi/8CYI/72IRyDKSk0IgthMmcfQdzGYZL
        o22arXd/p7aBSVU8Qn0e2g0GMFXhmQM5t96pC8VzT2yph74=
X-Google-Smtp-Source: ABdhPJx6iz/VgCAnesCKx9zB4V3pMwqq+DIGns58a7UjyjhWqSQ+fo15VfZN9YVoFiwEcDe9r+ZQpZ3NO5bQ3inmHiA=
X-Received: by 2002:a05:6870:15c9:b0:dd:e6db:cfce with SMTP id
 k9-20020a05687015c900b000dde6dbcfcemr3824760oad.269.1648054806252; Wed, 23
 Mar 2022 10:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220322110712.222449-1-pbonzini@redhat.com> <20220322110712.222449-3-pbonzini@redhat.com>
In-Reply-To: <20220322110712.222449-3-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Mar 2022 09:59:55 -0700
Message-ID: <CALMp9eS0_BXC2J26umCOqQS6mbZn-QKQqYzFcON5rrEBbebbvw@mail.gmail.com>
Subject: Re: [PATCH 2/3] Documentation: KVM: add virtual CPU errata documentation
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 4:07 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Add a file to document all the different ways in which the virtual CPU
> emulation is imperfect.  Include an example to show how to document
> such errata.
This is fantastic. Thank you. Along these lines, I wonder if we should
come up with a mechanism a la IA32_ARCH_CAPABILITIES (or AMD's OSVW
MSRs) for declaring fixed errata.

For example, today, KVM ignores the guest-only and host-only bits in
PerfEvtSel MSRs, but I can't imagine we're going to do that forever.

Reviewed-by: Jim Mattson <jmattson@google.com>
