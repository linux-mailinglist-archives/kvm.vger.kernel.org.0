Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F14D2EF1B0
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 12:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbhAHLzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 06:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbhAHLzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 06:55:50 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DD8C0612F5
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 03:55:09 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b2so10951715edm.3
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 03:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TT5sj4iaJu43b/QUazBJnf2Em/sDqdQRPcN8vEMLGlQ=;
        b=rOMcP/FDfddJ59bQmtIUlvjeCooqpYpQiXi+F9rkYjJb0e3/5guxuBDdpS1aG3OS3f
         4rGQmIvAtvwTaVYaQ2AQm50pCldwNB3xUfHiemBZmgfl6rTxRWNWFxyfF6eeaiVrkuZI
         QHkMnKzc36bzydvsVoOun79GNo/EFyFNi+yqJpjAyYKXpvMUguJxDeDIZiHbgVzFc+gX
         JWtg5fM0lJo+q7PccuRnnjAyIWdj1D+kcfDDt6/LaZxDD6Nv8u7PfgMOwGex0DRJ3w3B
         mrjb6zm3VabCFhwTFqPF2s7ydaWR+IaXKvb8F4N8Rt/8JPsN001DCFBXS1wj6PMGe0DX
         l9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TT5sj4iaJu43b/QUazBJnf2Em/sDqdQRPcN8vEMLGlQ=;
        b=J9F96bzXX4cARUB5ldgZEowDYIFIlvqCatpiJ4dt/EkCUjxEB1S+myrZNwZR9RjDuw
         D+mku3dUm9b+lT2owf4rPyDJsTZYP9UnXPSJJS0TIlIasQfQWyLPA2uT5Dguc723Jcrh
         YsreBtR/fbmviq4yytubxGSnbR3GqsaG/ZJAKPi7ffixvMatYrNLsFEGvlMv5kq8gqYk
         Lvz5LQIZuXIyD8ViVK6O/zdP+Sn4LN7CaDCLDLil0dCZzEBKDf0P+xJO6f6yusjvKpLZ
         3h4oDtlNqrdXa9CYFdOrlAQx8bVQB/NkHgybnIx5zDslSUiXRSs1ZT07fRVWjQiiS9EA
         RBJQ==
X-Gm-Message-State: AOAM5330/dUkY7U78drTKyGexcJEhrAP+nri8s2x5z2UQgwBUJ0MlCTV
        WyXmNECU3ZsitqWFYk1PsJBdo2OaqypZZwG0jIGYOQ==
X-Google-Smtp-Source: ABdhPJyckDc+/6Etn43fiZ1uuKRn9BA9d8GkrLLZ6s1Q5Flec1t+BGz2awu6YoKhKr7qMj04u6ErSWGkmPsfbPWb7u0=
X-Received: by 2002:a50:fd18:: with SMTP id i24mr5140256eds.146.1610106908338;
 Fri, 08 Jan 2021 03:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20210107222253.20382-1-f4bug@amsat.org> <CAFEAcA-6SD7304G=tXUYWZMYekZ=+ZXaMc26faTNnHFxw9MWqg@mail.gmail.com>
 <CAAdtpL7CKT3gG8VCP4K1COjfqbG+pP_p_LG5Py8rmjUJH4foMg@mail.gmail.com>
In-Reply-To: <CAAdtpL7CKT3gG8VCP4K1COjfqbG+pP_p_LG5Py8rmjUJH4foMg@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 8 Jan 2021 11:54:57 +0000
Message-ID: <CAFEAcA_Sx3b3ppxUdnuUSkc-xJmGhp8WZ57jN6tDziwRNxQ-MQ@mail.gmail.com>
Subject: Re: [PULL 00/66] MIPS patches for 2021-01-07
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Libvirt <libvir-list@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Jan 2021 at 11:28, Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org> =
wrote:
> Le ven. 8 janv. 2021 11:35, Peter Maydell <peter.maydell@linaro.org> a =
=C3=A9crit :
>> Looks like decodetree fails to cope with non-ASCII characters in
>> its input file -- probably this depends on the host locale settings:
>> I think these hosts run in the 'C' locale.
>
>
> Can you provide more information on your host so we can cover it in Gitla=
b-CI?

It's just the windows crossbuilds on x86-64 Linux, and also the
aarch32-on-aarch64 chroot. I'm pretty sure that the only relevant
detail here is going to be the host LANG/etc environment variable
settings when 'make' is run, though.

thanks
-- PMM
