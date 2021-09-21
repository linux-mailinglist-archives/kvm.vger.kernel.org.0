Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AD2412DE7
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 06:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhIUEdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 00:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhIUEdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 00:33:21 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25357C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 21:31:53 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x27so76344647lfu.5
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 21:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8mDe5rbnLvO060XX9nGaWK4P5GkvGrT6mYXSVNAOw78=;
        b=nQIzrFfqYXnXnvGGHKK3AiocAQAr4s7hYZ2882e5Qcd8yf2Z52l7k12rBkJXS27y/S
         9KGegh6KIxMYhjlUbn+dPo6KC4LywdO4OLmTMgxedy/ZUwjx+go1ZZVekdZK71Z1m4fK
         2W0poCuEzaYOB064+Ka73sB/Bd7sURpzHf2VIFPLgA6AsyPJJVvMtjxbuckYvVUiCnWe
         kM5Aarpv/IZYS9gCv8Zp7sYQ5Qzv9F5Gtr2BA7mSVcwyzOkeHzXiup89yFpXxJ4lytf7
         uy8cLBHE/T0gbQtIoArl4aUwwr9TSh+s4au/R928uGpPfW79iOdPQv7Td0WJbbWyIZww
         dehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8mDe5rbnLvO060XX9nGaWK4P5GkvGrT6mYXSVNAOw78=;
        b=LtVPiVMcYdCjtWD+VEfK+k9VCaON6RwJRtj4EN2hgbSd5GbX5I31rnWYUx+G5DwQZ0
         0SaVUsjjakem/iJPWnwd9FhexfLzZffHefKEUI8yW0YVblMms8JXyysU5x9K2/C/cwZ7
         qbuYCHpVX3a02oiYhk+2JC5gSorpaWTmJyX+vjFg7pMg0kMb4s6Myc5ox8kUv5lCXT1m
         gGegnH7wQU0a7rWDkb+QaVOzhSEjk6QY+/pT/p4FSWb7khv79uqLuETBNJYJeOIBp3nv
         /4TrxJ8o5aKEiOgMfxMiNCYeykkoQFpE7y5HJ5JSS2oFq8Ad5EsqY1gzKH+H/tTmNJmh
         CJAA==
X-Gm-Message-State: AOAM5317lYJkHQ7lBhUW8VMR66rYUuSAwWsJpflDfOsNqJtIkHmwwZ4u
        IIqV49xm4gWoaKzIDe9k1myv9XaQ5eSuM+MV/No=
X-Google-Smtp-Source: ABdhPJxVk4CH30B8tsSGbMpThOQ3zumdhlIBuszW2M2MS14jOKX4WfsW8BU/9Mtnk4OEDqee/tKKn9zPibRXt/opl/Y=
X-Received: by 2002:ac2:446e:: with SMTP id y14mr5491856lfl.326.1632198711294;
 Mon, 20 Sep 2021 21:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-10-zixuanwang@google.com> <3fd467ae-63c9-adba-9d29-09b8a7beb92d@redhat.com>
In-Reply-To: <3fd467ae-63c9-adba-9d29-09b8a7beb92d@redhat.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 20 Sep 2021 21:31:15 -0700
Message-ID: <CAEDJ5ZQkKRGEmA+zEZySWkfWV8Yms8+rJGa9ZUJR7ykcexjfgQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 09/17] x86 UEFI: Set up page tables
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com, Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021 at 6:26 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/08/21 05:12, Zixuan Wang wrote:
> > +static void setup_page_table(void)
>
> It would also be nice if cstart64.S reused setup_page_table, but unlike
> GDT/IDT/TSS I guess it's not super-necessary.
>
> Paolo
>

I can update this in the next version. I can also move the page table
definitions to a C file, maybe lib/x86/desc.c or lib/x86/vm.c? I'm not
sure which file is better.

Best regards,
Zixuan
