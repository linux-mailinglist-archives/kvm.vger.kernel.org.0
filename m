Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264AF174FBE
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 21:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCAU6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 15:58:15 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35135 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgCAU6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 15:58:14 -0500
Received: by mail-lj1-f194.google.com with SMTP id a12so8420660ljj.2
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2020 12:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R5IUY0GQxU/XfvpiXOgjTBtgaur6VEt5HW3USwfNMAU=;
        b=gRXxBUXhAXbHB1YnqsV82IHy14iGoFPbb3OclzTGCh53eeuiDUhTTU4vVpld85gGcH
         T/S+oMx1eZx+2VzqeK3LI1x28u2assIN1gOFEcaEiRGmvxHpTTuEl2y6lcdtvJeN0Uiz
         MVd4sxce0NkInQR0aop/Y27TgdTkBkX7y1I9yu8NTSCz6eKuqxWBWD+z7ecwFDbQ1/mV
         St/u6jA1eVczOiWDuUg/QDhsS9gMKFyIWyu4Nj2k7HD47dtSirOuBUPGFodgEUxFyt7Z
         6mQ7so0ZC4mih5i6/aUmILMK5CxHYB/9m80x59MsJN7qnT3CiXL/N2IU8ozXx3aVpbkD
         Tcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R5IUY0GQxU/XfvpiXOgjTBtgaur6VEt5HW3USwfNMAU=;
        b=FwiKGH4/VBMvDPoa+K3f3cxPV8p+YINh/SVs+6YaNpYfvyqlgyH21OnmFUooNi7eYA
         d1qNgEanL/qUWGOdVf9Cv2Ngs2sTorBu8u68BSaE2AzhFVQCxXQvDRi4cxl1VTPSVNxv
         om7SPOCVSpqWWffBHX/EwJrJ12gQL7ql/pYWFu2KXFUdMIFp52wiUAXl7zO0wkF9Dahs
         5odhvu/d2aHQGWhUXWl/psil50CpyoSmk3GAOEhNyBTpgvvMj/paCcZpRBYiBSikp/J4
         81oNrYPEheTQWPClxrHHaeKkqDqNhIBJSB0HnmTpPlToxaMaDdj6CFcj/TkDG/yZqcMf
         BrbQ==
X-Gm-Message-State: ANhLgQ0V4wl5BZ07jc0Y6gq49SVMgGTiF1D2XSv5KPslWCWj5PlDXtHw
        OJptgRArbb/P0987ZYCYYaK+tfm1U2Tkvf+HLJO5ug==
X-Google-Smtp-Source: ADFU+vs7XeKpPBaWsx2h6L02XWqIwO8rLpyNbPx9NIiWyRyIgfbJBMjylD2oOSiA2c5PG5jVQ8tDhtVRhbW2Tg1v6Zk=
X-Received: by 2002:a2e:a17c:: with SMTP id u28mr203412ljl.69.1583096292391;
 Sun, 01 Mar 2020 12:58:12 -0800 (PST)
MIME-Version: 1.0
References: <1582888591-51441-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1582888591-51441-1-git-send-email-pbonzini@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Sun, 1 Mar 2020 12:58:01 -0800
Message-ID: <CAOQ_Qsjzo8_yYJ6OP_Y9b-zA8DwhFfCcy2nYQJhx5dGJ2KjXtQ@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] x86: VMX: the "noclone" attribute is not needed
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 3:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Don't use the "noclone" attribute as it's not needed.
> Also, clang does not support it.
>
> Reported-by: Bill Wendling <morbo@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/vmx_tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index a7abd63..e2fa034 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4974,7 +4974,7 @@ extern unsigned char test_mtf1;
>  extern unsigned char test_mtf2;
>  extern unsigned char test_mtf3;
>
> -__attribute__((noclone)) static void test_mtf_guest(void)
> +static void test_mtf_guest(void)
>  {
>         asm ("vmcall;\n\t"
>              "out %al, $0x80;\n\t"
> --
> 1.8.3.1
>
Reviewed-by: Oliver Upton <oupton@google.com>
