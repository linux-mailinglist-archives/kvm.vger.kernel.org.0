Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8259421997
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhJDWLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhJDWLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 18:11:49 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA79C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 15:09:59 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u18so77882294lfd.12
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 15:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZRrLv0zfQRc+NK7rUcQuissZHmzLFsLZ2Bhqy84Xra8=;
        b=OLRJ/xi4gETwd0nkaMwDKrQY1iwu7PxgYfaSS7ID2z1zWsV57sAS6bUKAaz0dWmW31
         1CcvaQmwCOMLFS7CvJ8m0CZ6hF+SfIjpY6n1ex0vcQ7iysbWnh9El6PfNxTQ4tf5Gs4D
         BX2nzk6GjSJOW4UP0HByJCldDk8lefdktcYoxkztcxj3OGho2sce0XidL9T4ionb9U5n
         FHOA2Mihv39ahY9V1M7riIAV9stuTk1ocuHbBZRU9raPcv14XQz7dO8orFwQQWNsLKk4
         VfWLv3K3gHWJL/jJANlM6egxHfdcLB/prQf0bTd9iWVxUJ27QOOM2lF3MxRI8gebAH14
         hwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZRrLv0zfQRc+NK7rUcQuissZHmzLFsLZ2Bhqy84Xra8=;
        b=XWlZk9qM6MRcs35N/t3wfXbRW72OrqABUmB88lpbiW0b45KDBzmHzPq4Z0fBLMMQ9W
         S82sbeayAZThHW3issa2zKCmoXnMGANSyMGe+DAi13/saoEAJJIQVuzT8SBew9JxQhD4
         AgQyvGojfvaIUUJ2YDXCQ+SSthFdrOXhrI0ELi4cbjCmQfzdvxTaNvrXxZkD3giXi52m
         MAqoOgBMXPt3xtqaRjjC7GV4QKkjxgNpVJb27VQbclFEDx0+m9+sQNIZZbIVieOZhh0E
         hS3fzfrrg3P8tL23/OO2lNTdkINoGnpO5amQd5IiVx1Vr9P9Cuua9qcjS7ERUex6ETtg
         OYJQ==
X-Gm-Message-State: AOAM531yxWRYcsr5uGPXttsXSAbfGgpn4WouGXQIY6ck5Qv6nz1vp/zE
        hKpITLiep7JjGIbbW407Fj8uDftMi4a+L7oPwIw=
X-Google-Smtp-Source: ABdhPJxi4vsp064LHjm/4m75N3TO3Gs4qwaLj2H8ymaefmikvuZJFdAZCdCpxM7NM1hiInL30kiUvSmkKk9hLSCKLro=
X-Received: by 2002:a2e:a48d:: with SMTP id h13mr18865004lji.36.1633385397745;
 Mon, 04 Oct 2021 15:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-4-zixuanwang@google.com> <20211004124411.nqikc4wyvpal73sh@gator>
In-Reply-To: <20211004124411.nqikc4wyvpal73sh@gator>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 4 Oct 2021 15:09:23 -0700
Message-ID: <CAEDJ5ZR63OzHG+_Yz5vNxSUYUwUAqsMgfz9TJnUnENiVTZa01Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 03/17] x86 UEFI: Copy code from GNU-EFI
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 5:46 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 03:12:08AM +0000, Zixuan Wang wrote:
> > +More details can be found in `GNU-EFI/README.gnuefi`, section "Building
> > +Relocatable Binaries".
> > +
> > +KVM-Unit-Tests follows a similar build process, but does not link with GNU-EFI
> > +library.
>
> So, for AArch64, I also want to drop the gnu-efi dependency of my original
> PoC. My second PoC, which I haven't finished, took things a bit further
> than this does, though. I was integrating a PE/COFF header and linker
> script changes directly into the kvm-unit-tests code rather than copying
> these files over.
>
> Thanks,
> drew
>

This approach sounds really interesting. Is there a public repo for
this new PoC?

I think the self-relocation code is the most important one in this
patch. If we can avoid or rewrite the self-relocation process, then we
can pretty much avoid copying GNU-EFI files.

Best regards,
Zixuan
