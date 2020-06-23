Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0F4205ADC
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 20:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbgFWSd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 14:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732549AbgFWSd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 14:33:27 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDD0C061573
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 11:33:27 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id o5so24875339iow.8
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 11:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UtyB56A4GlL/xfW5TfbaXtMpiTxF/0AhjDFpSBvRZMI=;
        b=BAJ7kFUpMH5dEDlDy4+yUBFYL5XLpvs6GP07Et4UBbYb/femCcnoQ9nXhZqjrVf/5s
         UW3PiTpqSpmRMqXRw/JT+KlH3E43a1EGVezid7813IrzKQMynfY4CZ4B71dMY20QJ6JS
         QLonOjX8A9qcIIHt3kklF7zaR3/kuTfbB2zh5J35bmf3HSLsnnnBIkE3huroNstJawZ7
         HIcpaTcIjphoudc16KBqe4bFWZkJurZyp4wJy6uL/Zara0yzmJGLc8vczIn74rKbOf4W
         BWpr649mXLkuvqhC52OWOrz8EdXqSYkM3snVoNva/j0h+JBw3nXyUP4QEiARC9SWVsXZ
         X5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UtyB56A4GlL/xfW5TfbaXtMpiTxF/0AhjDFpSBvRZMI=;
        b=E+ivgMPuioSvIWTYI0AG0It4I2hlOvpPOgeoAz6BP5t+WMRtzP8BCI455fs686ZkUd
         3otUAlCmZVv+7pRJ+GLjsXGU8S57H4KJ0aNk9pfsV862F+9fzvdZBGqnd9vecv8Tdo4j
         ZjliHf8yiFDhg0OJgfnNNqlUHlQIgKIFFziXuj4/9+rd0z40pRAqDWkALOv3t4L8aUPP
         h1wJ7Y8vTl91iyaZZEHfAOu5ZKYKNdQEHor9MKrqS6xwmlerCux4oTVNddhippLJteA2
         quqOYKhL3QUXAz69gPsqqBkFoMF+VDQfIawYUefMJEXCKuC8sSvo2GD/w+bITPuOdKFq
         cwvA==
X-Gm-Message-State: AOAM530tla24yQ8nHdE47wE56efIaIoyYP/N6n/dl7+PSLNwcP3tPJhM
        OMwltPyNEEIJf4UqEswBoOs57MVcWd7geGYFL1H/2g==
X-Google-Smtp-Source: ABdhPJykBp8X5Z4CqMdsE2ghkfEut2I5tFhhTXReKfA9l0ob8aNZctjmaaBZSTbQ5YjGsfDrHee/1PdgQ0Dg+Paxxlo=
X-Received: by 2002:a05:6638:236:: with SMTP id f22mr10168797jaq.18.1592937206714;
 Tue, 23 Jun 2020 11:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200623072851.30972-1-pbonzini@redhat.com>
In-Reply-To: <20200623072851.30972-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 23 Jun 2020 11:33:15 -0700
Message-ID: <CALMp9eTSrGwqNSXuVNi+Rku0bix800Gva1zkv8VGjCR8acH6iQ@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] lib/alloc.c: fix missing include
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 12:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Include bitops.h to get BITS_PER_LONG and avoid errors such as
>
> lib/alloc.c: In function mult_overflow:
> lib/alloc.c:24:9: error: right shift count >= width of type
> [-Werror=shift-count-overflow]
>    24 |  if ((a >> 32) && (b >> 32))
>       |         ^~
>
> Fixes: cde8415e1 ("lib/alloc.c: add overflow check for calloc")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
