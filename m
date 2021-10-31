Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6411344110E
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 22:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhJaVjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 17:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhJaVjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 17:39:21 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318C2C061714
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 14:36:49 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id u5so26338661ljo.8
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 14:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RH047mBRPA+53TMlNcP8FjKAFIuJlSdRZt0OVWAL79g=;
        b=kdi0y25PRIL4zy+u9wDEJa3fLHYhwNp22TNcHWAh0tIxPjfmJE5/Ont2PV4KNyWjkg
         gQmqZ3lvtbNRqfRkOwg9Uq5a5PycYM5sQiHAQyp3QSOvJXX3aNpTAuudpKWl/eaJkTjn
         ls1vGqvzc7Xd0WSJJb9pryNO7/JrdmD1PjCt8Yzv5Pkpbbfh+GxqVSnN+JxCY65Yzmmc
         JTsyjJzICM/Xzc18BmKbAfwFP4/r/MHIHLWtUeaTiU1opYV4suyS7RHprPt4upHyM/9B
         s0ROs/i9cKOeITDqIc3H1KzDAquM3ZwTPpUmnUXfoH5QBm+iMfSwCFE5RZ3PkSPpiPd3
         2zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RH047mBRPA+53TMlNcP8FjKAFIuJlSdRZt0OVWAL79g=;
        b=PCRHTmPSYGLDa1wzN4rU5S0TLz5gHhHnkjEGsE0EYnQqf+TDctjmlPBk5MA6bhu/sr
         hK8sJr/Jj2ALfPlGwdbBzm3xKrsAQv92B+6WvPDGU5gofotR6dv9AkAlJVWZ8X5+2Cyy
         5lzB+SjPRz9mFbCYASjbLX7LUL7mSr2c2FlcmYSJ9z4IcGRvQpQkuWjCz/E4qpwSm6mm
         BghoW418Du4mcxgNANGmvExuHiXAKdiCBoA0xvtQZ07SYIEhi3bR6pQuyCa0f+vnEKTD
         GgFn4cj/Le1ej7k9BhySPAj89y1MjqWxJIL8Mu6ZT/8Ou6xDJG9qA2B9bCuqT6nwtf2k
         qgjw==
X-Gm-Message-State: AOAM5304eBxATVcvBBNLJ1CeOfl1Xd8sWcZ+IEieo92Vrn75Ld/ewZ0L
        azMqu8OrBW/mrgaKMReyF+h+NW7Go0dn1sV5obtVMBg62sU=
X-Google-Smtp-Source: ABdhPJzMc6xlu1P5wmnJrIoMdBxqpeQ+s/uCCNm4bhYq0z/elFQZ5dW++v//TiQIQP6Z+Cnv3KUkN+CqlWfUe1sO7Pc=
X-Received: by 2002:a2e:969a:: with SMTP id q26mr26105399lji.44.1635716207631;
 Sun, 31 Oct 2021 14:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211031055634.894263-1-zxwang42@gmail.com> <20211031055634.894263-6-zxwang42@gmail.com>
 <5460ca03-4547-b538-e187-6eb8e9ce8641@redhat.com>
In-Reply-To: <5460ca03-4547-b538-e187-6eb8e9ce8641@redhat.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Sun, 31 Oct 2021 14:36:00 -0700
Message-ID: <CAEDJ5ZQVX6c_FQ_=b4thNXo76cN2_a4cu+-4PZERdLovmjKmvg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 5/7] x86 UEFI: Exit QEMU with return code
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 31, 2021 at 3:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/10/21 06:56, Zixuan Wang wrote:
> > From: Zixuan Wang <zxwang42@gmail.com>
> >   efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> >   {
> > -     int ret;
> > +     unsigned long ret;
>
> Why this change?

Didn't notice this, it should be int, thanks for pointing it out!

> >       efi_status_t status;
> >       efi_bootinfo_t efi_bootinfo;
> >
> > @@ -134,14 +134,14 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> >       ret = main(__argc, __argv, __environ);
> >
> >       /* Shutdown the guest VM */
> > -     efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, ret, 0, NULL);
> > +     exit(ret);
> >
> >       /* Unreachable */
> >       return EFI_UNSUPPORTED;
> >
> >   efi_main_error:
> >       /* Shutdown the guest with error EFI status */
> > -     efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, status, 0, NULL);
> > +     exit(status);
> >
> >       /* Unreachable */
> >       return EFI_UNSUPPORTED;
>
> It's better to keep the exit() *and* the efi_rs_call(), I think, in case
> the testdev is missing and therefore the exit() does not work.
>
> Paolo
>

I agree, I think there are three possible solutions:

1. keep both exit() and efi_rs_call() here, or
2. define a new function efi_exit() that calls both exit() and efi_rs_call(), or
3. add efi_rs_call() to the end of exit() function (defined in
lib/x86/io.c), so many other calls to exit() can utilize EFI exit as a
backup

Best regards,
Zixuan
