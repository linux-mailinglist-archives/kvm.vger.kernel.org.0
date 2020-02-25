Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9076716EB1A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 17:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgBYQQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 11:16:57 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33905 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 11:16:56 -0500
Received: by mail-ot1-f68.google.com with SMTP id j16so67558otl.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 08:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hlv8glY/nETgRGQM3JrX7U+aqQLACOo8EtOJKWLyg2o=;
        b=pvmjF/YK/Llxj+KwQTKvFsDg33CBSxEkGh+RZmGNIHEKerUVTdAvcuUFYvXqpYL9+r
         lTArS0BYMJ/EA5azo0fl3vcMyZcK+zSUb7g+j1ySKdseWpQlcvmWlz8CF3iueT4dgByv
         807h3wLRfTDkU81vYKTM06rHLWXODWUPSfjOUmFuhu541V6ArRppRXhXBOXfUrvUCnPq
         Mpt8rUP4A3TJnwG7gAqUvU7ctZexojhvKWMY66MgVU0qMeIYIlKxrC9qeaj3b0aAbwEv
         f+Zj+t0k03vMYQz8Gr8tuY3cXljzjhe1UqtEO6T74nigH8FDdpJT7UfibHPu/3YIEfcX
         gQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hlv8glY/nETgRGQM3JrX7U+aqQLACOo8EtOJKWLyg2o=;
        b=k48HnsZ5itNyqEBA07YJvNRXCVk8piAuws/uOclp2KJ7SqTFykOBo+tm3Ng1iIKE8x
         yX0Z/qOcrDB0YdnUN/0tWPoQFwM0+Zo2UVGJFNRFiRmFU2VXTLff66OOFwm5pKC6iUP7
         XikiglQyh9uluRRkFpS7smmY05Euylj+rC+D6LKjs9fGeQmmYGqlNEskBy+QABw+1c15
         ML92FQ9Eh2IGmLsKKXxyUkxUbJKSQ3OekBxw8ZDdHWRb9lGLIiuyfWwwetS2OlN5goOz
         tuEUMRjRGfAGQ+r3A9S3Qig0Tyx02kJqFxEj68umUKbVtSGRPlYZgZEwfKqTTivTkpzz
         IE7w==
X-Gm-Message-State: APjAAAW/jZSr3x+9cJNCQvNVfRpt5NTA56Tpcf8tnnSlB81XcbE2hCHf
        mR6wPNZbAuEdlHCaBMnx6J7ZeAuq4bjrzCf+n/hVdQ==
X-Google-Smtp-Source: APXvYqwrQZAseC96mjkcu4WFviym/5+i8KWdLsn7ZJyRU6pF2+Hzhyqk2VMhlES5mY819yutsnfzMFQTlFmo0u79KhE=
X-Received: by 2002:a05:6830:13da:: with SMTP id e26mr42364907otq.97.1582647415115;
 Tue, 25 Feb 2020 08:16:55 -0800 (PST)
MIME-Version: 1.0
References: <CAM2K0nreUP-zW2pJaH7tWSHHQn7WWeUDoeH_HM99wysgOHANXw@mail.gmail.com>
In-Reply-To: <CAM2K0nreUP-zW2pJaH7tWSHHQn7WWeUDoeH_HM99wysgOHANXw@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 25 Feb 2020 16:16:43 +0000
Message-ID: <CAFEAcA84xCMzUNfYNBNR8ShA58aor_rbYTq7jnmsLQqhvbOH8w@mail.gmail.com>
Subject: Re: Problem with virtual to physical memory translation when KVM is enabled.
To:     Wayne Li <waynli329@gmail.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, kvm-ppc <kvm-ppc@vger.kernel.org>,
        qemu-ppc <qemu-ppc@nongnu.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        David Gibson <david@gibson.dropbear.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 at 16:10, Wayne Li <waynli329@gmail.com> wrote:
> So what could be causing this problem?  I=E2=80=99m guessing it has somet=
hing
> to do with the translation lookaside buffers (TLBs)?  But the
> translation between virtual and physical memory clearly works when KVM
> isn=E2=80=99t enabled.  So what could cause this to stop working when KVM=
 is
> enabled?

When you're not using KVM, virtual-to-physical lookups are
done using QEMU's emulation code that emulates the MMU.
When you are using KVM, virtual-to-physical lookups
are done entirely using the host CPU (except for corner
cases like when we come out of the kernel and the user
does things with the gdb debug stub). So all the page
tables and other guest setup of the MMU had better match
what the host CPU expects. (I don't know how big the
differences between e5500 and e6500 MMU are or whether
the PPC architecture/KVM supports emulating the one on
the other: some PPC expert will probably be able to tell you.)

thanks
-- PMM
