Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F3642B0DB
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 02:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhJMALA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 20:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbhJMAK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 20:10:59 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252A5C061570
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 17:08:57 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id u5-20020a4ab5c5000000b002b6a2a05065so275845ooo.0
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 17:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1wf1Q0TmXCdzHDtOeU4GKQoLNPN392+7vMasONuwGT0=;
        b=cEDWyZChSrL2mgFPe/kyle8Ost5j6rOkSsaSYAaArHUrhSxWP/2ylCdW8nlLH1rsYf
         nxCmVTOs3k6ZLuxNLeRvdREb/BFp/dpj45lXImILcYb7o1sfTQFKHWGFBYgjVXXBB8qd
         fcEkdtwDYrC63pYOhBrYEs90yqmfgCXS2iF4pP/mSuKe8YUi4Io138hMCGUbPnVw4Cu3
         EwBhdhy0Di8by0/pkMcuz0bnGpuiKBQZQC5gRmJ6dEGq2K99jMi1/UU0q2qJDbP1YboU
         B5geR22+JBuRrgV04ZYIqAduKHnOWt9xlmHGeVwj+WL7q6wvfcPR2So3vOZT7afyMfrr
         QD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1wf1Q0TmXCdzHDtOeU4GKQoLNPN392+7vMasONuwGT0=;
        b=CrSMPm8MhEPQUMUjvdYzxxvZ2MwO11vM46OBkds4MngzdZa0+G9hur9cHgArw+4wRB
         t7QJ2UzFX1vgkUA5CcTSGFt1allkcAwUTxB+Lq73tmZDCCpjvQliiyIxyEuBs8Ie99Xg
         YnWfb+sd2Hpo9KJJcSiQV9uQ8pARdvkLprJOhx4DrhmY3bAzNIu1SE/lMfIF3T4DJ/ev
         9bUKP7bOZQwh4P/ThZq7bhsG6uhCEdnvKpClj+fgzHH+ZmMeY8Emrox/qVm2d8Bvq9LN
         0ZUoWMLALn4964hiHYTpSJsScyBakERZRb/3qFclKwcZkxB09mgTSVaG6rCGfpe9JuSx
         fNaw==
X-Gm-Message-State: AOAM532aKiOYqVOFbsCcvNMNnEQfamB8jZgxhzr1kavqz7qvDQVHwPUV
        f1eZWn2D422dbKCgOxeLYCM3IKIHoiY5RC70FUjaCPuUsgw=
X-Google-Smtp-Source: ABdhPJwO6iezf2PeaBla0vqTRGeeZoOZcOXOSXVXKD8rfmjlkJjv1FXGnqeZ55FGQUHiKY4925LPbb9Or0QLeTfiZjc=
X-Received: by 2002:a4a:c993:: with SMTP id u19mr7932771ooq.31.1634083736242;
 Tue, 12 Oct 2021 17:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211012174026.147040-1-krish.sadhukhan@oracle.com>
 <CALMp9eTaGfDyHn2i=fT51_GtmLmF6cXa6h1Wb_s-f=8Me1wFtA@mail.gmail.com> <b0ee2adc-a15b-dd12-d297-b9754fd3628a@oracle.com>
In-Reply-To: <b0ee2adc-a15b-dd12-d297-b9754fd3628a@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 12 Oct 2021 17:08:45 -0700
Message-ID: <CALMp9eQR0hDG8thu=wRCo8FBRFH9vvd6sYbhR8+xtckhrYeCbA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_open() to __vm_create()
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 4:17 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 10/12/21 2:14 PM, Jim Mattson wrote:
> > On Tue, Oct 12, 2021 at 1:43 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> vm_open() actually creates the VM by opening the KVM device and calling
> >> KVM_CREATE_VM ioctl, so it is semantically more correct to call it
> >> __vm_create().
> > I see no problem with the current semantics, since the KVM_CREATE_VM
> > ioctl *opens* a new VM file descriptor.
>
> Agreed. But the KVM device is also opened for many purposes. For
> example, in kvm_get_supported_cpuid() it is opened for getting CPUID
> stuff.  The purpose of opening the KVM device in this context is to
> create a VM and hence I thought it would be semantically correct to
> rename the function.

You are misinterpreting my response. I said nothing about the  KVM device.

The KVM_CREATE_VM ioctl *opens* a brand-new VM file descriptor. In that sense,
vm_open makes perfect sense.
