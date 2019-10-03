Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9661ACAE1C
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 20:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388902AbfJCSXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 14:23:34 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36830 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732868AbfJCSXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 14:23:34 -0400
Received: by mail-io1-f67.google.com with SMTP id b136so7838967iof.3
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 11:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=275AfUnj6aHBgYIbA3ON9mS0LQosy+5qsD0pGkCb32s=;
        b=c1OGLMY44+4ckwsAl/G+KpSfgRdufeD7+g8abBklf/iVHaeStNDSGUTsrYn7KivMXy
         gd7lalJgK9VamFzr9yNcORUcBx5LO1pQ2sKh6g5SI6nEq/O5eeoVknEsekuOaFOVig0P
         zYYjsvfJfiVajqgUraogcoDmK5vSur/OJYeUyg678zQ8L9Ldoj0d7EV7q0dV+FC5SQgL
         v7fWJu2DAffTqUxpZTW21k6xCZus+kt1iDjg4sFWAViYV57/B0bGZCATnzZyABpuHWln
         h1mch2xYQlBObkXEVqmbDW9F1eJ7AryfZvM1PEe18JDRWm5Xki/wDJ5ZhgQKCOf6Cvfk
         HexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=275AfUnj6aHBgYIbA3ON9mS0LQosy+5qsD0pGkCb32s=;
        b=YdFmKVuW9KUdRGy910BGC1nRgWeQppBiYJei3FnuQ7L7uFaCSg9GhZ9EPXMpFBw712
         myBbgT7Whlfsa1SrBj8LvbPSw9b+mldUYLWL5RJlTm40wlPb+I6lHZ576bXV6JLJYVDp
         p8dzKz6MC8teNCmUS80Ic3gD54NRH3hNFZw/hWQHBUGyt4ZnK72lOig/iBY2JIAmJVpc
         LhwKqzTskWARfB/YEEcJdKZ0TwrGqUgeKb7WGsDIFmnWPv59PpTsrj+T/MLCqzrCeHeY
         4ITKQi81ivY6ColZGQDdeOyTqb/Mkm3tl81lbEvXbCnuQa166Q/HVL+VIphQA0jX2x21
         +8Ag==
X-Gm-Message-State: APjAAAV+pf9jgBLlYMrSrQ342qBcEfDJR89RzwhtTWu630oAtsfrLwxr
        /TOU2mOm8ddXnPnn1mbZGXEK00JK9EyCR2mDbE/WYw==
X-Google-Smtp-Source: APXvYqz+qHo6hpknvwi0t3HRw6jBKEJsjcAIwLnUH/pYAlcuWzLA/cEliwwkK5mVPejYp8PluQHLQUxCAf9UTnBfCOA=
X-Received: by 2002:a92:5a10:: with SMTP id o16mr11756152ilb.296.1570127012953;
 Thu, 03 Oct 2019 11:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <1570097418-42233-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eRFUeSB035VEC61CzAg6PY=aApjyiQoSnRydH788COL4w@mail.gmail.com> <f8e169a5-4cf6-8df7-86bb-f70a480c33ad@redhat.com>
In-Reply-To: <f8e169a5-4cf6-8df7-86bb-f70a480c33ad@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Oct 2019 11:23:21 -0700
Message-ID: <CALMp9eSCB-wyLm-QYS-7gTcSeuWWCvgYL3iDEP0y6BM4cWMFag@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: omit absent pmu MSRs from MSR list
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 3, 2019 at 10:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/10/19 19:20, Jim Mattson wrote:
> > You've truncated the list I originally provided, so I think this need
> > only go to MSR_ARCH_PERFMON_PERFCTR0 + 17. Otherwise, we could lose
> > some valuable MSRs.
>
> This is v2, so it was meant to replace the patch that truncates the
> list.  But I can include the other one too, perhaps even ask the x86
> maintainers about decreasing INTEL_PMC_MAX_GENERIC to 18.

The list should definitely be truncated, since
MSR_ARCH_PERFMON_EVENTSEL0 + 18 is IA32_PERF_STATUS.
