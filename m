Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5BD1AFDE2
	for <lists+kvm@lfdr.de>; Sun, 19 Apr 2020 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDST6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Apr 2020 15:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgDST6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Apr 2020 15:58:20 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DF4C061A0C
        for <kvm@vger.kernel.org>; Sun, 19 Apr 2020 12:58:19 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id i27so6217778ota.7
        for <kvm@vger.kernel.org>; Sun, 19 Apr 2020 12:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8sgZNtHLVvuYw+5lDrqsN+Jm8FYYVijiJfjS9qHlDxA=;
        b=tcHo/oAdo+AaUr/nRWts65oNLNMeGWd5AIknQ0t3HEnEAdV4yG35Kk8yjSb3asyjWa
         iagFJhcl1bkDtx2phWa4bucjGe/x7IzojSIOvM8jTLUqVwfUMlExGIBFEXmlHGsx5Sdc
         CO+HdMvFiAxM+HfKBqJRXPupugrFmD8mF1GUWOmjS3x5pjlO0nrcT9m+kuxBgKZwxu7X
         pF4voaq7tIFkH+fvgSWGfwtka3hrMn/JXpnO+mXL+Heas4AHAfvarYypkXGnYplSyB7B
         zBpagAXgaVlLFQJ/KEQ38PyTCxL7tZBIdN1+sj+9XuQ5h1duPcpAy/N07H5U1wKe1S2b
         s9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8sgZNtHLVvuYw+5lDrqsN+Jm8FYYVijiJfjS9qHlDxA=;
        b=fNEFSiiaRxJyBKHzLvH5SddITjcroTruGHbZcXstSKX819RbcUHZ5NasxlXOs4wCIc
         LCpjDY/B72PsVU4zciLfDF95kurNNyag8cprRHMptMdGlc9BPuBrhu30RZFsNI+2R/Td
         PszEiKKzN8z5tOxvOnXEB22HPnWT7n6wgZsK66EVIim9uZQnnERZGcD8SbN6qWtwwHqq
         UKjdxvZY3jQnUBDFGWZr5W3NpO8wCl6dIgSVoCl6UWMZTARV7K+6QHFA7HzIebz/XFXo
         DgzwKrdWod2pKBTWAbY2aFTZhHfJu1w+uwJZtdlunoCtHVby7FyOB8yE34w/qK1/hD5C
         fCyA==
X-Gm-Message-State: AGi0PuZurJdrZi548688echqslMHyvdB4TUbFUYqPitGHo40Pndl1j2A
        3TWfTbGFAY3+B1NjKSgOk3bsRoQBt1FuWzZkISGI7g==
X-Google-Smtp-Source: APiQypI8UIJka580eXEMW8htEkYmryhOVDrQrkv7Gcep4mnLZqyA9aHRQgiiEQiubaTRr7VBz+Gkb5XrWvUDV5JbomI=
X-Received: by 2002:a05:6830:1e4e:: with SMTP id e14mr6978758otj.91.1587326298321;
 Sun, 19 Apr 2020 12:58:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200316160634.3386-1-philmd@redhat.com> <20200316160634.3386-2-philmd@redhat.com>
 <cb3178f1-5a0c-b11c-a012-c41beeb66cd2@linaro.org> <3dc0e645-05a5-938c-4277-38014e4a68a3@redhat.com>
 <f4ee109e-b6fc-8e1b-7110-41e045e58c30@redhat.com>
In-Reply-To: <f4ee109e-b6fc-8e1b-7110-41e045e58c30@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Sun, 19 Apr 2020 20:58:07 +0100
Message-ID: <CAFEAcA8z5t__ZQQSqx88nMcC26SHowa3AjtDaQQFaPn-p-FYYQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/19] target/arm: Rename KVM set_feature() as kvm_set_feature()
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 19 Apr 2020 at 17:31, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> On 3/17/20 10:09 AM, Philippe Mathieu-Daud=C3=A9 wrote:
> > On 3/16/20 9:16 PM, Richard Henderson wrote:
> >> On 3/16/20 9:06 AM, Philippe Mathieu-Daud=C3=A9 wrote:
> >>> +++ b/target/arm/kvm32.c
> >>> @@ -22,7 +22,7 @@
> >>>   #include "internals.h"
> >>>   #include "qemu/log.h"
> >>> -static inline void set_feature(uint64_t *features, int feature)
> >>> +static inline void kvm_set_feature(uint64_t *features, int feature)
> >>
> >> Why, what's wrong with the existing name?
>
> Peter suggested the rename here:
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg641931.html

In that message I suggest that if you move the set_feature()
function to cpu.h (which is included in lots of places) then
that is too generic a name to use for it. The function of
the same name here in kvm32.c is fine, because it's
'static inline' and only visible in this file, so the bar
for naming is lower. (In fact, it's a demonstration of why
you don't want a generic name like 'set_feature' in a widely
included header file.)

thanks
-- PMM
