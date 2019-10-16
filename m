Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BACAD98C4
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 19:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389308AbfJPR4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 13:56:09 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:43012 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388804AbfJPR4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 13:56:09 -0400
Received: by mail-il1-f194.google.com with SMTP id t5so3537142ilh.10
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 10:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ehRRCFef7SbxvSvaubzQTNJ3wrCGvh7drnATTKOs8ME=;
        b=BEw/h73DCHahkI5YCnaAWabSBuq2bgR6Q04P8/f7FX3soJYbVto41L9T1ZWfGlUGjb
         cMvc41JtXS8cxQb3VhKEuEKtk9sn7igUgM259vdH3zN6WlwlMM8r3788RRXRL+IpWvFk
         9TJXXY9nFvHSFZnQk4rcoJZVE0yKmSx+rgKAGqe8D5YX8uupfbmufXR5TS4255PTv5KK
         1miX+fBUdWoaU1E75h5P+QgJ2LI2a+D0K5uO906Ixsy+rtjL7n6Ix+c8ri4Gr5ghRfJQ
         p91jDIp+HCLQvukhTqUF+eO/ntG6CQ/UdoKrgWTU+ljFNzjKyxDcceCLCynN1QHN7Qdu
         Uykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ehRRCFef7SbxvSvaubzQTNJ3wrCGvh7drnATTKOs8ME=;
        b=qTnvtmf7NouYAyojvxmCh/shGGm7m1XImSbToFYNmb5LSj45wVi13+bbYTq0wEzpiz
         i9modEXhH8zZ0Qimzls5e3fYclc37rTHb35g4ny9Qn0uvPGgyXIkEDQa0Y4YDokHVHKh
         xcYnODagfa88Qh7zRcqLkgggpZlaCZsIu0fQC8RL4sRX6gHX2hM7Zi/kzzTQmWuSuO+k
         5LQlYD63FgOcPDmMVg6IJCuiBy2aZo/86L22Cdyk/tdJ6qUkqqcWryrKyAFi1tl+YAbX
         46RAQF3e/1BXx57VmoJtPDY+hCBrcrAE+W46GNDPLIzGFIuXpJZGyg0igAUyjTZLWAPe
         INwQ==
X-Gm-Message-State: APjAAAVJmYv0NVGzxth2sjsSq3Z262oFw81Apj4YHcvAPjbKEH+DjYGu
        xrLfGxB00EfxuRr3QcxkU1y2JIb0Mo016cPV8+7+f8qROaM=
X-Google-Smtp-Source: APXvYqzlA39F7QAPFTptp4LtLzuHbATpKJhReUJiO6s4fXLprOjwV66bhxNERidUVNIeIrkf4OKrNfTSoX03cW846dM=
X-Received: by 2002:a92:c142:: with SMTP id b2mr13518079ilh.118.1571248566454;
 Wed, 16 Oct 2019 10:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191015001633.8603-1-krish.sadhukhan@oracle.com> <20191015001633.8603-3-krish.sadhukhan@oracle.com>
In-Reply-To: <20191015001633.8603-3-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Oct 2019 10:55:55 -0700
Message-ID: <CALMp9eSg-cY0ZDauS11HitF13b7G_=urszQ6d7m+kAm-4htArg@mail.gmail.com>
Subject: Re: [PATCH 2/4] kvm-unit-test: nVMX: __enter_guest() needs to also
 check for VMX_FAIL_STATE
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 5:52 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>   ..as both VMX_ENTRY_FAILURE and VMX_FAIL_STATE together comprise the
>     exit eeason when VM-entry fails due invalid guest state.

Nit: s/reason/reason/

> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  x86/vmx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 647ab49..4ce0fb5 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1848,7 +1848,8 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
>         vmx_enter_guest(failure);
>         if ((abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL && failure->early) ||
>             (abort_flag & ABORT_ON_INVALID_GUEST_STATE &&
> -           vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
> +           (vmcs_read(EXI_REASON) & (VMX_ENTRY_FAILURE | VMX_FAIL_STATE))
> +           == (VMX_ENTRY_FAILURE | VMX_FAIL_STATE))) {
This shouldn't be a bitwise comparison. It should just be a value comparison:

vmcs_read(EXI_REASON) == VMX_ENTRY_FAILURE | VMX_FAIL_STATE

>
>                 print_vmentry_failure_info(failure);
>                 abort();
> --
> 2.20.1
>
