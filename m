Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4187C516
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 16:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbfGaOjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 10:39:04 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42579 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfGaOjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 10:39:04 -0400
Received: by mail-lf1-f67.google.com with SMTP id s19so47627800lfb.9
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 07:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ctmBDHo9TX2dbSp2AaSHsPzQrsJdvD0Z0tQiKSJILjI=;
        b=vOqnA7p5rkZBV1OzvJdBY8iKuYdA1b4/1o8F1w0IN2uTr1QTWzn7WwJ2JFJulsfP9n
         w7SXEHZMs3OROdBscJxfm3yqK9ykTM2PKIM1oR1tL2f1241B9xYMdSVWTnrMHbmOd9VA
         mAPZDUO9HHBe830SnSJXzdgMSSIEPBHBeQe84S0kLGX8L+iv7XtRoPM2CXTUOuZ6dEH7
         B6aO1hPD3ht6n0bJLtnoxUg9cuq5DY7bj7JYiayjoj4jbBFKArFvRvlrFY6jxT+osgBK
         CDJg8qjTb01Y8yRl6THr9PaB5tdxxrnbZ70xpFwfysyJN6KNOtOOA/6JqLIDDSPmGMp5
         fVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ctmBDHo9TX2dbSp2AaSHsPzQrsJdvD0Z0tQiKSJILjI=;
        b=BIwnz20oe/PVeAXAUHOPTJ2TP9Y9aMVoS6fW6YRaHrkw0iIDB69NAJ9vZGDxhzsqet
         013BK1xHUA4rVw959CdA39xN+BZhosa4ENGvEK2UXK1qOYhlzjSmUUJUMCQzrtqR86zw
         KNZ7sAjvx/umRIOX5yH+Y7g0irQQMHTDo1JdjRzSgzChQ/4lgGdtG5iTpGjurq0P39By
         YbAQnVx0dzioV9SbYG5e0vlJRyFxW/YswWHILmqyO3kx+KIdkoPQq5j8NyLPRQ5MOU05
         emCqxkIB0lOhyWfkE8QrkmlisRjwwYyRKLxwZApXXG1HpXWba7BU0lOnh8KUX/NIaz9G
         BiPQ==
X-Gm-Message-State: APjAAAXeeWPJCqC88WDHf7xKwBgSX7eeWwAytL9SCUbUiObs21HooFTC
        aadhsRoyHJwA/z3crt0ZNPWekY/Fr+vwRWpzUbVPrA==
X-Google-Smtp-Source: APXvYqzUvYIZI+JTlouZm26wyL/S+M0wK6ZP0t5id5XDl31AGiIZPngdjFnaNrgG32VgIjVn4hRZhKk2bdPsATnEjw8=
X-Received: by 2002:ac2:482d:: with SMTP id 13mr46123622lft.132.1564583942340;
 Wed, 31 Jul 2019 07:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190731105540.28962-1-naresh.kamboju@linaro.org> <43fd5a9b-7ecd-3fff-2381-1dfce7b8618a@redhat.com>
In-Reply-To: <43fd5a9b-7ecd-3fff-2381-1dfce7b8618a@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 31 Jul 2019 20:08:51 +0530
Message-ID: <CA+G9fYvf_3JZFauHUzqjgdg9kir4i__oSsboiOGzBBS63zg7+g@mail.gmail.com>
Subject: Re: [PATCH] selftests: kvm: Adding config fragments
To:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        sean.j.christopherson@intel.com, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Jul 2019 at 18:32, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/07/19 12:55, Naresh Kamboju wrote:
> > selftests kvm test cases need pre-required kernel configs for the test
> > to get pass.
> >
> > Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> Most of these are selected by other items.  CONFIG_KVM should be enough
> on ARM and s390 but MIPS, x86 and PPC may also need to select the
> specific "flavors" (for example Intel/AMD for x86).

If the below listed configs are not harmful i would like to keep all listed
configs. Because we (Linaro 's test farm) building kernels with maximum
available kernel fragments for a given test case to get better coverage.

>
> How are these used?  Are they used to build a kernel, or to check that
> an existing kernel supports virtualization?

"make kselftest-merge"
will get configs from tools/testing/selftests/*/config
and enables configs fragments and we build kernel for running
kvm-unit-tests, kselftests, LTP, libhugetlbfs, ssuite, perf and
v4l2-compliance.

- Naresh
