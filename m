Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255D05BD3E9
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 19:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiISRhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 13:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiISRgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 13:36:52 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201BD42ACA
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 10:36:51 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id c9so43495770ybf.5
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ck4BMj+vvY5OflnBnyLJgGwLlOkDf6AU0R4r0DkS+6o=;
        b=DKB1zIcH2hIzAYwBRLGwDBO2MCcYOnB5iwOfRnqA+MJiHe9U+kryhBSwEIYWGekY2G
         q9yxcfBMbCV5Nvjqs20gZTfifCzhCIHiF+DVxtHEb79hJIKQ+zcs2g0dbfqJv6oiBt7W
         6nAlO6FwMpG7hQmQehWaMoMkYp3POvRxRUZxIu4R++sHwM0cuaRrvQeVanJsu5KR0Lxf
         poYgqqL/LSBU6hFp5EaNtSYUuHWxZ+KnB+ILpG6kq5Mg43kV+J8M4OG9FLiOZe3wJYpN
         fPVK1JI3d5Ew7aO0uAAhPMpZFJUieWeEjud5W/Zl3RuDvuy/BFhuLJo3Pao2FffTVD/R
         wfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ck4BMj+vvY5OflnBnyLJgGwLlOkDf6AU0R4r0DkS+6o=;
        b=mXXT3tuMa/0vTGIrt+QWVTTUuDPeDphcO7ehw4PfDOM4UBEGZ3+Y/k8RzztKJ0R9wc
         OYdwR8MaZXc1OW/z8J13F72ya9y4LV2gXX1pmY7NAdJgqnZiCrT6egHttmKlsgmAxLVf
         lA0WKJuhrgdfFTxWMOWk/ZObJzBPBNcrWXbNHcNKHC/SEYiqA87e0Pb65KCBNX9h2yYN
         Jvm9DHYc3WZMBIWswjslb1gXhyzQdLXWSm1pfek4NS6/CkBmgQa5AYdDjPwc2k5VM9LL
         Zt/d1Soxxmyv79FAcYfpxxCgtAn3TD6NWYFDG3rZ8eckNTSDUa6LNZdD1/pXFZzmlYlC
         /V4Q==
X-Gm-Message-State: ACrzQf3R7B128Glo9aY6OYxLe2cntaJdrVtxSQpSNlb/AO2TmLhr8J4l
        SGBfklAj+qgT4KuTdpPaEHB47pHLtMC3Thpk6E0=
X-Google-Smtp-Source: AMsMyM4U201McPLAj52F9LhXfPz6GsbWtNm90YXWHpOJlUWV9MA4lX+lGM2V11A0F2sHSbzR2fGPGEZc6cNZMSelXkw=
X-Received: by 2002:a25:e0cd:0:b0:6a8:cd39:694a with SMTP id
 x196-20020a25e0cd000000b006a8cd39694amr15871176ybg.207.1663609010289; Mon, 19
 Sep 2022 10:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAJSP0QUn5wianZaCu8Ka=eu2uuwtwTnTLD-P9pkb+PxFd=1Mzg@mail.gmail.com>
In-Reply-To: <CAJSP0QUn5wianZaCu8Ka=eu2uuwtwTnTLD-P9pkb+PxFd=1Mzg@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 19 Sep 2022 13:36:38 -0400
Message-ID: <CAJSP0QWbN8Ee49HTYfc4sbgHJpB0bNTyCyRAZT2GgQYXBeG7YQ@mail.gmail.com>
Subject: Re: Call for Outreachy Dec-Mar internship project ideas
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Warner Losh <imp@bsdimp.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Frank Chang <frank.chang@sifive.com>,
        Matheus Ferst <matheus.ferst@eldorado.org.br>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Sept 2022 at 12:41, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> The Outreachy open source internship program
> (https://www.outreachy.org/) is running again from December-March. If
> you have a project idea you'd like to mentor and are a regular
> contributor to QEMU or KVM, please reply to this email by September
> 22nd.

Reminder: there are only a few days left for proposing Outreachy
Dec-Mar project ideas.

Stefan
