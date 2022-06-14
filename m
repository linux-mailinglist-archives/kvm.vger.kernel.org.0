Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B3E54B260
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 15:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245604AbiFNNhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 09:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235958AbiFNNhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 09:37:00 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE021CB11;
        Tue, 14 Jun 2022 06:36:59 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id m20so17188395ejj.10;
        Tue, 14 Jun 2022 06:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TBZRXsIUgPrwK41uYl0qFR1bA9XKQJ6Wd9marZHiA5E=;
        b=By224uq/sOnAN+s/z0vVcdF/6dNVvBSlBCxxMi+6rjH2FYK0e6mYiUsjpegUOxN8jt
         q7Mps9QkZVv9hRt+INZjJnFH+MNWrT1ztkWnYYl+8NjxrhrXAOklb14sf1yLgSZbREc5
         cm/DwAA1mqb87u0tpnvtYB/WHO6xStksUnENFVBsEvBJQsvHXpvqZMWSGp/AVETVLWDe
         Y7WKbzYJcz8ZFFs5zQTanGkX3rXkrBCxGuDNKWYdFk5MMhrlp8PmYj2kuXMhw9IvOwF9
         CKanayB/4E+Htk9g8QfVIQ5wkbgwrNzF0zz0qjg4Qh4UWFt2Jp9qtOGSDj2of0hBbcnR
         O8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBZRXsIUgPrwK41uYl0qFR1bA9XKQJ6Wd9marZHiA5E=;
        b=Pl5vZsRgDtTslSSW2JBerDEmceUwhuL3nCEDfPdZFutLJAylrbASe57uFx2IuhaH/2
         jeoKHpboIi/UvLf1NDNIiNFlEZt77nLcdeMACcVHrLupaxCC8Wp7nTWI04zqSg/iUxSw
         EpSGuKBNotCVOuAuNlMD7eLICOfiV1JzUtJ7zklav7fzcYW/dOtKScvWYI6hTLrIXCjH
         O1a0bPdwuQkjwoW+dWmEJoIzRdmuCxXVCzAhJLK/TrShFT0aolHluLZAKoQLvc/LaZ9P
         Shv0xelw6Bsi9goAkqb/WvzeHzqSGgcHmNx7XP2coBaH8c8ANAxoxCWMfXpvhazx2q6j
         JrvQ==
X-Gm-Message-State: AOAM530JfaB3uVd8JZ07BMhwFs4Uhjltyh4vKOYjvnWUMbjjEft9XZCd
        GX8GGsT3UirVE4EdDO78edlD2iKrYQ17FcrBhKk=
X-Google-Smtp-Source: ABdhPJwwmaea2USqpctBchdlfpCRiDLTSWAqAR0YajpQBCirZQR5RNvshXX1pzGdbCJegLLC+R0wdjwBWQOnsl8VjTA=
X-Received: by 2002:a17:906:3c07:b0:718:e1a7:b834 with SMTP id
 h7-20020a1709063c0700b00718e1a7b834mr690062ejg.635.1655213817548; Tue, 14 Jun
 2022 06:36:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220614085035.122521-1-dzm91@hust.edu.cn> <87zgifihcd.fsf@redhat.com>
In-Reply-To: <87zgifihcd.fsf@redhat.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 14 Jun 2022 21:36:22 +0800
Message-ID: <CAD-N9QVS_9BjpocLuW9GRKhOo4inP8hqn1mB4h-1mW+J9-zeyA@mail.gmail.com>
Subject: Re: [PATCH] x86: kvm: remove NULL check before kfree
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
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

On Tue, Jun 14, 2022 at 8:01 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Dongliang Mu <dzm91@hust.edu.cn> writes:
>
> > From: mudongliang <mudongliangabcd@gmail.com>
> >
> > kfree can handle NULL pointer as its argument.
> > According to coccinelle isnullfree check, remove NULL check
> > before kfree operation.
> >
> > Signed-off-by: mudongliang <mudongliangabcd@gmail.com>
> > ---
> >  arch/x86/kernel/kvm.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 1a3658f7e6d9..d4e48b4a438b 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -236,8 +236,7 @@ void kvm_async_pf_task_wake(u32 token)
> >       raw_spin_unlock(&b->lock);
> >
> >       /* A dummy token might be allocated and ultimately not used.  */
> > -     if (dummy)
> > -             kfree(dummy);
> > +     kfree(dummy);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for your review. My signature seems with an incorrect format,
so I send a v2 patch.


>
> --
> Vitaly
>
