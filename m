Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980187059B1
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjEPVkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 17:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjEPVkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 17:40:21 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1177170D
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 14:40:20 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-3f51ea3a062so37991cf.1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 14:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684273220; x=1686865220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBWzZ1fuaiKLG9VaE48oXuTKbbOfGWu4xTiiYU69WFY=;
        b=1xMVpM85sRCMWv3cTm4heqjZ9rr0DqyJoh+rxCj0a7TlY2mtxgJYe/FSxsohDxb37h
         pmIsq22W70owvlM2QYab1s8vfLfVelLr+db27v/N0wrIqrkH+Asn8CMSQJJHBY1bY3Hn
         6ZwY9AGOPd3PNJJ75Onxhj3/e/dLOTAVNpLsHbJCd5Cucp/OzpIEJCaChsgq8pfHDA5H
         qvkZTbgm6LNs7Zvz+nM+7AEw/8eRNaDXjAt+o1nDbs7J4Rlw1Ny5szh3g51seW+Lk4Nz
         3M9SUlMVxPWZs7hKUWHmLXQQXWjaU1ibLufGcSWd3gz3OH8YcBegOo2IhqnCWR5akJDk
         qTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684273220; x=1686865220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WBWzZ1fuaiKLG9VaE48oXuTKbbOfGWu4xTiiYU69WFY=;
        b=ZKqagUeDObZrUohn8jCxirOTCvNIfKmopE6bnr59Q6lU/u0CQ+XNND9kdiP9uHHGmP
         D0ak9FPXW/VstyeA5vbJK6y00ASfhfEMCw1USG0/tn07OjNEzsc/XsCHOb08XmsNvqLU
         AwTKkXWdx6SQAvFWeOYSyW5qU05qeLxhGEpTtYzA86tuoiYFKqYYa1THSN6Vi5XPhSc8
         cGzmmiEYtwwIlwM43SeOFI5gjSIlurmAuEOUYcri4Vx27Vm4uWjv7SCfUYhOlI9PcZqV
         MeKsmLynRxjiXdpfRFIKIdhDotybQcCBJXnzmRuQN6OR0gSIlxvkQJiMvmsSV15MqTEz
         3OHw==
X-Gm-Message-State: AC+VfDws4YtzcgHsKft9I2JMPCcLR3jlkdGiDvPXtmCWZ6DdIUQGVtno
        z+T7pAi1p6xCoZ7+C3V7m32d+WWPFOohiYBRbCm7vg==
X-Google-Smtp-Source: ACHHUZ5O3TpDez4/ceufx3QgUALhmlmkLhLDu3sqaex5zVfs/B6kjqQuC4aT78OURRr+hmHCmhDxLIOPAEqG10WYI/M=
X-Received: by 2002:a05:622a:34a:b0:3f3:75c2:7466 with SMTP id
 r10-20020a05622a034a00b003f375c27466mr128665qtw.8.1684273219625; Tue, 16 May
 2023 14:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220225012959.1554168-1-jmattson@google.com> <YhgxvA4KBEZc/4VG@google.com>
In-Reply-To: <YhgxvA4KBEZc/4VG@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 16 May 2023 14:40:08 -0700
Message-ID: <CALMp9eRQC-U4f9imkwsMM1=ewtJFuUORjseFPNskib4t-AL6-w@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Fix header file dependency of asm/vmx.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
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

On Thu, Feb 24, 2022 at 5:32=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Feb 24, 2022, Jim Mattson wrote:
> > From: Jacob Xu <jacobhxu@google.com>
> >
> > Include a definition of WARN_ON_ONCE() before using it.
> >
> > Fixes: bb1fcc70d98f ("KVM: nVMX: Allow L1 to use 5-level page walks for=
 nested EPT")
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Jacob Xu <jacobhxu@google.com>
> > [reworded commit message; changed <asm/bug.h> to <linux/bug.h>]
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/include/asm/vmx.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > index 0ffaa3156a4e..447b97296400 100644
> > --- a/arch/x86/include/asm/vmx.h
> > +++ b/arch/x86/include/asm/vmx.h
> > @@ -14,6 +14,7 @@
> >
> >  #include <linux/bitops.h>
> >  #include <linux/types.h>
> > +#include <linux/bug.h>
>
> Paolo, any chance you want to put these in alphabetical order when applyi=
ng? :-)
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> >  #include <uapi/asm/vmx.h>
> >  #include <asm/vmxfeatures.h>
> >

Ping.
