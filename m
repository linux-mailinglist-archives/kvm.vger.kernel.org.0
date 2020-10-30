Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C73B29FF7D
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 09:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgJ3IP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 04:15:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59957 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgJ3IP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 04:15:57 -0400
Received: from mail-lf1-f72.google.com ([209.85.167.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kYPZi-0003k4-W8
        for kvm@vger.kernel.org; Fri, 30 Oct 2020 08:15:55 +0000
Received: by mail-lf1-f72.google.com with SMTP id q24so929530lfc.9
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 01:15:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tvQ3YbXwFexR15wThxHj76pajtIT9wY97QdIqvDJoGQ=;
        b=cQ01JVoKNPGwxfXDSlnSI3vVW2vI5Z8ZEkmh7YcgPIrLLdKXzf9yXwbykGubapoAil
         y8LckpkSDMx7Ff/2UjxVKPWtjXQ2BfaMp4ASYg7ZNVSiudhDcAo0WWlFXd4uYQJoYAfm
         oYhCJgt1KWf7bp1QGva6SEYm8JkMZa9l7+bPjxQPOCbO7VBsshYuGuykfFYrv2wvgNxY
         vmltv2cNfs2wnazZ6nnPvRc+V6DjdAVxPQuemtSF52HzHUJpWy5rskP5290CpJuwi4Uk
         neC9npHW4dALi6+Cin4UJzn+UI+VDWKZ3b9lDFlpdl7JsiYDhYa1mcPUMyGJB0SC7SQs
         iCJw==
X-Gm-Message-State: AOAM530txCkq/uTyM0Fp3ogQHcKp+7Eak1J7miRzRYLhUjeLy2a0AneS
        0TmXk77fbZMEqswRdL1nPUOpAkD6VNRWABW1nzSpwLiTIgAWjrZhYO0cZn5LxNvft3l4qTfG9lQ
        47Mo5l89fr7bnlSvMw7z8wgdSeACYBnAISi59z4sNKpO6
X-Received: by 2002:a2e:8616:: with SMTP id a22mr490242lji.132.1604045754341;
        Fri, 30 Oct 2020 01:15:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybpqsGUOhXyED6dBQawuoLuhwIT7cXXYPo+J+XYgduqOr9Ht2+Tzvk754G0iaZLCXn0npp2beZVK+VSvvCuYQ=
X-Received: by 2002:a2e:8616:: with SMTP id a22mr490228lji.132.1604045754093;
 Fri, 30 Oct 2020 01:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201013091237.67132-1-po-hsu.lin@canonical.com> <87d01j5vk7.fsf@vitty.brq.redhat.com>
In-Reply-To: <87d01j5vk7.fsf@vitty.brq.redhat.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Fri, 30 Oct 2020 16:15:43 +0800
Message-ID: <CAMy_GT8+Cr5WEw6oSKiJR9Odw1a+fuekS5dcmeA6T8U4EnDpSw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 15, 2020 at 11:59 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Po-Hsu Lin <po-hsu.lin@canonical.com> writes:
>
> > We found that on Azure cloud hyperv instance Standard_D48_v3, it will
> > take about 45 seconds to run this apic test.
> >
> > It takes even longer (about 150 seconds) to run inside a KVM instance
> > VM.Standard2.1 on Oracle cloud.
> >
> > Bump the timeout threshold to give it a chance to finish.
> >
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> > ---
> >  x86/unittests.cfg | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 872d679..c72a659 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -41,7 +41,7 @@ file = apic.flat
> >  smp = 2
> >  extra_params = -cpu qemu64,+x2apic,+tsc-deadline
> >  arch = x86_64
> > -timeout = 30
> > +timeout = 240
> >
> >  [ioapic]
> >  file = ioapic.flat
>
> AFAIR the default timeout for tests where timeout it not set explicitly
> is 90s so don't you need to also modify it for other tests like
> 'apic-split', 'ioapic', 'ioapic-split', ... ?
>
Hello,
interesting thing is that this apic test is the only one that will timeout.
For Azure cloud hyperv instance Standard_D48_v3 (kernel 5.4 on Bionic):
apic-split - 31.892s
ioapic - 1.187s
ioapic-split - 1.212s
vmx_apic_passthrough_thread - 2.099s
vmx_apic_passthrough_tpr_threshold_test - Failed (KVM: entry failed,
hardware error 0x0)

So I think bumping the timeout just for this test should be enough.
Thanks

> I was thinking about introducing a 'timeout multiplier' or something to
> run_tests.sh for running in slow (read: nested) environments, doing that
> would allow us to keep reasonably small timeouts by default. This is
> somewhat important as tests tend to hang and waiting for 4 minutes every
> time is not great.
>
> --
> Vitaly
>
