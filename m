Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1391A3F37D6
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 02:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbhHUAtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 20:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhHUAtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 20:49:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1499EC061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:48:27 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id n12so16391585edx.8
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jKvFK3ZttTtS1RC7m96P6R+9n7wr5sGga2H63cHhoI4=;
        b=ScM1wlquP52p4C6Re/rkgbfGv3Jxfo/qS5/3NUv9EiDFEYRzoYm/SBOFFN23M6xPiE
         NFxNBye36eh7Vqip3BgytJmPo4HIsgcntzIlmcVHDTMTxGPsD4VCOiELEMyzYF6z604R
         gBupBz+J2aflQbETMtE+BgCc+cImqwsupfRaO65HG95ieHs8tyeTuOErJlp+GtO6B/Id
         3LHaOO6Y9V1Xpw39mowi32K6jqtIqG2hGAiwOVsvb2XlKNp5O/JOkfAsBP9OVdL6wilf
         Xn96b18i3hgxoVEoFMBIlx2ypHZY1sLDGQ1Kg8BqH6Ol8HnylRF4SKyl0zkVGLvjP4Y8
         UWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jKvFK3ZttTtS1RC7m96P6R+9n7wr5sGga2H63cHhoI4=;
        b=HI+q8etINwQDGoEj8Iukks38zZIHKD1KrX1VOkCnG/Npgip9WhtUWm0xMZ0CuPoI52
         NvCKz+dvC1heHCXmt6HTUQrGwvmnbGVeOr28CFCROGzMc48/t2c9P4EzgWbOrp71Ht4m
         5w1zc0Jt8r68W8vLdqAgNrjGsar6hBlTUkNZ7gk63kfk7wEQVkKj259zG+lqpCvN1vjH
         NlK0tgLBi5mrDli77kQlW2dTk1XWKBz0WgeMt5+kEm2ZH7QJTAgtTDdpDOG3BIXPhNX+
         i4ZWZXdhAh2fhLeerqUFAh15nwNUKHgaves6ZMs6Pp6sepblW9pSrBUBypgI9PkhK5x5
         9IYg==
X-Gm-Message-State: AOAM532zHT6ze1/mfZbysQ929DP021Lrv1/OG43eGXjGisPwStreG1iw
        m/+6+OdkdU5Crbe3VwEFXTNogF/9gHRyoF6AMi752A==
X-Google-Smtp-Source: ABdhPJzSDSu+IJe0CWe5H+zMpYM8uy/2uT8qY2aeIBgQALywqd5X6l/Zkk9lmNb3sxxTmT4YiD925ztie9ShG2vZF94=
X-Received: by 2002:a05:6402:1014:: with SMTP id c20mr22960177edu.71.1629506905443;
 Fri, 20 Aug 2021 17:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
 <20210818000905.1111226-15-zixuanwang@google.com> <YSA/sYhGgMU72tn+@google.com>
In-Reply-To: <YSA/sYhGgMU72tn+@google.com>
From:   Zixuan Wang <zixuanwang@google.com>
Date:   Fri, 20 Aug 2021 17:47:48 -0700
Message-ID: <CAFVYft0XjHOX1yMh_B1DuC5MHUp0UmLHYoZue8qzmvaFrF6AzA@mail.gmail.com>
Subject: Re: [kvm-unit-tests RFC 14/16] x86 AMD SEV-ES: Copy UEFI #VC IDT entry
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Fri, Aug 20, 2021 at 4:50 PM Sean Christopherson <seanjc@google.com> wrote:
> > Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> > ---
> >  lib/x86/amd_sev.c | 10 ++++++++++
> >  lib/x86/amd_sev.h |  5 +++++
> >  2 files changed, 15 insertions(+)
> >
> > diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> > index c2aebdf..04b6912 100644
> > --- a/lib/x86/amd_sev.c
> > +++ b/lib/x86/amd_sev.c
> > @@ -46,11 +46,21 @@ EFI_STATUS setup_amd_sev(void)
> >
> >  #ifdef CONFIG_AMD_SEV_ES
> >  EFI_STATUS setup_amd_sev_es(void){
> > +     struct descriptor_table_ptr idtr;
> > +     idt_entry_t *idt;
> > +
> >       /* Test if SEV-ES is enabled */
> >       if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
> >               return EFI_UNSUPPORTED;
> >       }
> >
> > +     /* Copy UEFI's #VC IDT entry, so KVM-Unit-Tests can reuse it and does
>
> Nit, multiline comments should have a leading bare /*, i.e.
>
>         /*
>          * Copy ....
>          * not have to ...

Thanks for pointing this out, I will fix this issue in the next version.
