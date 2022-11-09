Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727E0622343
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 05:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiKIE4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 23:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKIE4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 23:56:23 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB6A13E91
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 20:56:22 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id r18so15220923pgr.12
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 20:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzUeY1NlxFoV85zKdxUEiopAncPI0prGSQvQzA7f6E4=;
        b=bXkUG4RyEIkvleCDlvx3Rac8B5yi5/hq766O41A+882GVFz4JwHSgTT/wQzcDxDdvv
         65G34zPEgRyTOA1NaYtOVVedTCUBzxWOpTd5nhQHDphZn/M6CmHj8h+y7OpJh7ZmAoOl
         ugclCF6lv2MvP3bvuLkNEh024Hbho48BHLghUQdNSHt2sHgrpqTR2eZbACEZ2SyflWBo
         UURweBa4Sms/GL+6rE1RpimM6fehRWd+p1AkFKyj0TGdOlG3C0Dm1DT9fvRVOKvHG8zd
         CKG5rbKB06BSaZwnPVkLMN9P5WfcHTw2Gy5WQoNDT57x+o2L315bhivzi1Q+zeNTbEDo
         7wlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzUeY1NlxFoV85zKdxUEiopAncPI0prGSQvQzA7f6E4=;
        b=nbdQ/4qTlJhZI3TUvh/Ht+4wOGp1Xlk7mdNlw37saNGM7jn8eXaGsd+9ESBNL6ODGr
         IhvkdNdvn0vr/qWQpqXvYyBOn0xhX39s062/BfF8wO7BGLx10RbhJT572vOGuX2077Xj
         8vGhdfoamIqsdz8ffkft2A8o9VQpnztqSYfH2rYuTxRDFftEbovNL63vNfrRWujIAYQ0
         +cONC+5Xg5Hdv+xSxB3gk9Gf8rLVqpysGB+Zhi6Y7qpF/Rvnr5JDEd6RQbFoO9U/IHqE
         3lvf09ZQ2uwnZtDtlAFa3FwBQCCjwgrEjUjEp3uqyJMCEj31fu6NrYyZREzuF6Ih3gvd
         3xhg==
X-Gm-Message-State: ACrzQf0lPH4cdAxP9icYzspqzitpAnUGBW8PJT+2Z0JT38Jtm3YKwTQW
        ToRg8PaUn/F/Vf8725zvNeU=
X-Google-Smtp-Source: AMsMyM6cQL3VyAw2OgSsaPvMvLCDu45UVMNhgkILcoRIP9d61m9aaXcLGO0900Qwm/Z38wpB2KAUCw==
X-Received: by 2002:a63:82c7:0:b0:470:22e0:7031 with SMTP id w190-20020a6382c7000000b0047022e07031mr25783366pgd.63.1667969782019;
        Tue, 08 Nov 2022 20:56:22 -0800 (PST)
Received: from localhost ([39.156.73.13])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902710300b0017534ffd491sm7932308pll.163.2022.11.08.20.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 20:56:21 -0800 (PST)
Date:   Wed, 9 Nov 2022 12:56:16 +0800
From:   hbuxiaofei <hbuxiaofei@gmail.com>
To:     andre.przywara@arm.com
Cc:     will@kernel.org, kvm@vger.kernel.org, Alexandru.Elisei@arm.com
Subject: Re: [PATCH kvmtool] hw/i8042: Fix value uninitialized in kbd_io()
Message-ID: <20221109125616.000072b4@gmail.com>
In-Reply-To: <CAFVig-zYrUDg_xNUpfiCmxxq5-PeZeXSbuBi3y640YYDLA5WoA@mail.gmail.com>
References: <20221102080501.69274-1-hbuxiaofei@gmail.com>
        <20221104152709.10235b86@donnerap.cambridge.arm.com>
        <CAFVig-zYrUDg_xNUpfiCmxxq5-PeZeXSbuBi3y640YYDLA5WoA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=GB18030
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Nov 2022 10:52:53 +0800
Xiaofei <hbuxiaofei@gmail.com> wrote:

> On Wed,  2 Nov 2022 16:05:01 +0800
> hbuxiaofei <hbuxiaofei@gmail.com> wrote:
> 
> Hi,
> 
> >   GCC Version:
> >     gcc (GCC) 8.4.1 20200928 (Red Hat 8.4.1-1)
> >
> >   hw/i8042.c: In function ¡®kbd_io¡¯:
> >   hw/i8042.c:153:19: error: ¡®value¡¯ may be used uninitialized in
> > this  
> function [-Werror=maybe-uninitialized]
> >      state.write_cmd = val;
> >      ~~~~~~~~~~~~~~~~^~~~~
> >   hw/i8042.c:298:5: note: ¡®value¡¯ was declared here
> >     u8 value;
> >        ^~~~~
> >   cc1: all warnings being treated as errors
> >   make: *** [Makefile:508: hw/i8042.o] Error 1  
> 
> Yeah, I have seen this with the Ubuntu 18.04 GCC as well (Ubuntu
> 7.5.0-3ubuntu1-18.04), when compiling for x86. It's pretty clearly a
> compiler bug (or rather inability to see through all the branches),
> but as the code currently stands, value will always be initialised.
> So while it's easy to brush this off as "go and fix your compiler",
> for users of Ubuntu 18.04 and RedHat 8 that's probably not an easy
> thing to do. So since we force breakage on people by using Werror,
> I'd support the idea of taking this patch, potentially with a
> comment, to make people's life easier.
> 
> Cheers,
> Andre
> 
> > Signed-off-by: hbuxiaofei <hbuxiaofei@gmail.com>
> > ---
> >  hw/i8042.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/hw/i8042.c b/hw/i8042.c
> > index 20be36c..6e4b559 100644
> > --- a/hw/i8042.c
> > +++ b/hw/i8042.c
> > @@ -295,7 +295,7 @@ static void kbd_reset(void)
> >  static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32
> > len, u8 is_write, void *ptr)
> >  {
> > -     u8 value;
> > +     u8 value = 0;
> >
> >       if (is_write)
> >               value = ioport__read8(data);  

Thanks for your advice, it is indeed a compiler bug. Let me add some
comments.

Best regards
Xiaofei
