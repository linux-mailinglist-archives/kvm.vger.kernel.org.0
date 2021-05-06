Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B591375602
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhEFO6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:58:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234965AbhEFO6n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 10:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620313065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lyIxY1ohvh2Vr+4gsSzPvJplNzaIO6PYXkp2+1UYBHg=;
        b=VhqJ2zFbs5CgUKiNV88l0SvVgmMMTGSOWqlqcPU72412334puBXRsLmDHA25IeGNN0DkxP
        W3BY2wlc6/fn/EBGYWZNc0pGATibAT2N5qUkwasHPExVOD1LVha/gv+zXae3oKdu7XOcKC
        3aGAkk0Dk0osx+UVbGdODcp1A/UKA/A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-5DmMihG8PuyqtVV2oUhunw-1; Thu, 06 May 2021 10:57:41 -0400
X-MC-Unique: 5DmMihG8PuyqtVV2oUhunw-1
Received: by mail-wr1-f71.google.com with SMTP id q18-20020adfc5120000b029010c2bdd72adso2303555wrf.16
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 07:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lyIxY1ohvh2Vr+4gsSzPvJplNzaIO6PYXkp2+1UYBHg=;
        b=kjipDiywIjiR03MCmTYMU27sxGOQn3gfX51TCsa3mX7hx1fYGFjhC5ciStblz4zKZM
         MsAxIlmS7Rs1cnAYJmX5aYdVjgFTtiKfJWb20ZeHmp3HaBi0L5+ijdi3PvrKib5nKG/p
         QHjhGH9D0u8WAat1rOe5qNWzDGIkEYigWUeMcBw2rRE3swfywqzXDZt9/yiBci94kfgu
         D3mD1UmXKMWoc1M2/6rWffRj+y0AWAFRDtpwD1qaflfn8KkSHRLp1mY/CjIfTFq3ZXw4
         NvEBtdYxLx+xAUWgYNxj0UAXda+4iOitDeNlENxhy1Wo3W6A2CvQ7Z4TEsteBbrE0GJz
         rF1g==
X-Gm-Message-State: AOAM533ckPbJqgEAP+lWdamMsk0+od77NoaDEYlZjtzxQNz5/nttMqHn
        qUCdw4SCXJUEH/ClQJ5F8vJvPk0iFctnPgnGz2OUMaaQtw+uTWjXjVTSHxPcZnq7z1VUr1U2NKl
        eaDBtxGupVDII
X-Received: by 2002:a1c:1dd5:: with SMTP id d204mr4430929wmd.21.1620313060101;
        Thu, 06 May 2021 07:57:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwungeHCyrKF1CRqOuFagaX0vPn3NhcHfo6YfU7kbw68ds20olEQalC73cXhHw28cCXTSCXQ==
X-Received: by 2002:a1c:1dd5:: with SMTP id d204mr4430899wmd.21.1620313059832;
        Thu, 06 May 2021 07:57:39 -0700 (PDT)
Received: from [192.168.1.19] (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id e10sm4858890wrw.20.2021.05.06.07.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 07:57:39 -0700 (PDT)
Subject: Re: [PATCH v2 4/9] bsd-user/syscall: Replace alloca() by g_new()
To:     Warner Losh <imp@bsdimp.com>,
        Peter Maydell <peter.maydell@linaro.org>
Cc:     kvm-devel <kvm@vger.kernel.org>, Kyle Evans <kevans@freebsd.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, qemu-ppc <qemu-ppc@nongnu.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
 <20210506133758.1749233-5-philmd@redhat.com>
 <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
 <CAFEAcA9VL_h8DdVwWWmOxs=mNWj-DEHQu-U4L6vb_H4cGMZpPA@mail.gmail.com>
 <CANCZdfpXjDECHmZq55zP43g32OVhnfjf9W+ERtPMFeDs2MmvXQ@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <994028a8-8d62-0355-0343-f721d6f256f6@redhat.com>
Date:   Thu, 6 May 2021 16:57:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANCZdfpXjDECHmZq55zP43g32OVhnfjf9W+ERtPMFeDs2MmvXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/21 4:48 PM, Warner Losh wrote:
> 
> 
> On Thu, May 6, 2021 at 8:21 AM Peter Maydell <peter.maydell@linaro.org
> <mailto:peter.maydell@linaro.org>> wrote:
> 
>     On Thu, 6 May 2021 at 15:17, Warner Losh <imp@bsdimp.com
>     <mailto:imp@bsdimp.com>> wrote:
>     >
>     >
>     >
>     > On Thu, May 6, 2021, 7:38 AM Philippe Mathieu-Daudé
>     <philmd@redhat.com <mailto:philmd@redhat.com>> wrote:
>     >>
>     >> The ALLOCA(3) man-page mentions its "use is discouraged".
>     >>
>     >> Replace it by a g_new() call.
>     >>
>     >> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com
>     <mailto:philmd@redhat.com>>
>     >> ---
>     >>  bsd-user/syscall.c | 3 +--
>     >>  1 file changed, 1 insertion(+), 2 deletions(-)
>     >>
>     >> diff --git a/bsd-user/syscall.c b/bsd-user/syscall.c
>     >> index 4abff796c76..dbee0385ceb 100644
>     >> --- a/bsd-user/syscall.c
>     >> +++ b/bsd-user/syscall.c
>     >> @@ -355,9 +355,8 @@ abi_long do_freebsd_syscall(void *cpu_env,
>     int num, abi_long arg1,
>     >>      case TARGET_FREEBSD_NR_writev:
>     >>          {
>     >>              int count = arg3;
>     >> -            struct iovec *vec;
>     >> +            g_autofree struct iovec *vec = g_new(struct iovec,
>     count);
>     >
>     >
>     > Where is this freed?
> 
>     g_autofree, so it gets freed when it goes out of scope.
>     https://developer.gnome.org/glib/stable/glib-Miscellaneous-Macros.html#g-autofree
>     <https://developer.gnome.org/glib/stable/glib-Miscellaneous-Macros.html#g-autofree>
> 
> 
> Ah. I'd missed that feature and annotation...  Too many years seeing
> patches like
> this in other projects where a feature like this wasn't there to save
> the day...
> 
> This means you can ignore my other message as equally misinformed.

This also shows my commit description is poor.

>     > Also, alloca just moves a stack pointer, where malloc has complex
>     interactions. Are you sure that's a safe change here?
> 
>     alloca()ing something with size determined by the guest is
>     definitely not safe :-) malloc as part of "handle this syscall"
>     is pretty common, at least in linux-user.
> 
> 
> Well, since this is userland emulation, the normal process boundaries
> will fix that. allocating from
> the heap is little different..., so while unsafe, it's the domain of
> $SOMEONE_ELSE to enforce
> the safety. linux-user has many similar usages for both malloc and
> alloca, and it's ok for the
> same reason.
> 
> Doing a quick grep on my blitz[*] branch in the bsd-user fork shows that
> alloca is used almost
> exclusively there. There's 24 calls to alloca in the bsd-user code.
> There's almost no malloc
> calls (7) in that at all outside the image loader: all but one of them
> are confined to sysctl
> emulation with the last one used to keep track of thread state in new
> threads...
> linux-user has a similar profile (20 alloca's and 14 mallocs outside the
> loader),
> but with more mallocs in other paths than just sysctl (which isn't present).
> 
> I had no plans on migrating to anything else...

I considered excluding user emulation (both Linux/BSD) by enabling
CFLAGS=-Walloca for everything except user-mode, but Meson doesn't
support adding flags to a specific source set:
https://github.com/mesonbuild/meson/issues/1367#issuecomment-277929767

  Q: Is it possible to add a flag to a specific file? I have some
     generated code that's freaking the compiler out and I don't
     feel like mucking with the generator.

  A: We don't support per-file compiler flags by design. It interacts
     very poorly with other parts, especially precompiled headers.
     The real solution is to fix the generator to not produce garbage.
     Obviously this is often not possible so the solution to that is,
     as mentioned above, build a static library with the specific
     compiler args. This has the added benefit that it makes this
     workaround explicit and visible rather than hiding things in
     random locations.

Then Paolo suggested to convert all alloca() calls instead.

Regards,

Phil.

