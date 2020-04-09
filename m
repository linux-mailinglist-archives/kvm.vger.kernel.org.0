Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2BD01A3323
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 13:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgDILYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 07:24:50 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45858 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDILYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 07:24:50 -0400
Received: by mail-io1-f68.google.com with SMTP id i19so3416718ioh.12
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 04:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RRjJJW6qKikQw1uT9zffeLo51gT+qFo1k0SsUp6S/3Q=;
        b=m7gAuMsTZVgpMlIZ3AGfBPT6Vs8UwSiV/949AmtSbdbmOqslX7QYtKtXSdcfUVe+in
         QaZg/gi1eBGViFzb60n27umu1J/5l0SPYBQbPvrUOyPQYDd0IEw+9S7/+oN/j2YARK64
         ///WmhB5t7+L2qVYIwfNcqLXBdKDFxmsHZmK9dZJJqwdDz4FJptpogx24wP+Ae4/uNqL
         wGUISG7Vhl4jRO+2YPyAXSV+OGfGFOgM2UVmIV7pnBPahLPsMvpv/iqbFXpiQ3zbB7NY
         uCEpsJxlcvSgDgsGFshijXZVyHgmqL73CW3NaNy1ensxcg6TYdLWsSzuM+ALs9g3DE5Q
         ArpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RRjJJW6qKikQw1uT9zffeLo51gT+qFo1k0SsUp6S/3Q=;
        b=QNv+ReiDw4H/ODzet/W+ORvhxFaR+59gK4A5Vcbtxj4FIbltSvSk0NXscuYz3SXQNA
         fee4S1CsBWTwEmVIn2tPQZvGCdiNTgFTUKxshzgBZNtnAPwdHsStxMz/X0/W4IQmeWFZ
         vytJhecfuFftxZ49en8lFr7VWl/lFJHCh5B0u292EBnKMC4M+4tu44AoFHP4RV2ENAcR
         uQLBawgn0aWwydIEZom4GmbduzfUxMWgYOc+FOOxz2gAAVq6mJT8OO6dCuKv2Gk0IgTG
         HzdZ7M2yw+VHXFv4I78mTVdfaagDCpo3yXeUGt80/+YKPaCM0GxAdzHBQi4cbApcAFdR
         4oCg==
X-Gm-Message-State: AGi0Pubklhbc4KH47ibEDpceaS9k4ZkETRe/UEsqc4ntRTMfmQpJHDXp
        65hHqWLf9VRR3vxdQI1b21BCCgQA6cR9//T+79G/zJo6
X-Google-Smtp-Source: APiQypK+sXsuX5veA6Ber9LepWF/pkBeRcRoXBIy/QdXMwqErFI7rNCzKGk9AG3/VIPmzXGHn4H3yNvC8cQ4R9o7wxU=
X-Received: by 2002:a5d:891a:: with SMTP id b26mr11625899ion.194.1586431488940;
 Thu, 09 Apr 2020 04:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
 <8079b118-1ff4-74a8-7010-0601d211a221@intel.com>
In-Reply-To: <8079b118-1ff4-74a8-7010-0601d211a221@intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 9 Apr 2020 13:24:37 +0200
Message-ID: <CAFULd4b7-sqSHWzanQYrOoCYd7xZ+Qn0-ZHctPtvvo5TbZVOMw@mail.gmail.com>
Subject: Re: Current mainline kernel FTBFS in KVM SEV
To:     like.xu@intel.com
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 9, 2020 at 10:31 AM Xu, Like <like.xu@intel.com> wrote:
>
> Hi Bizjak,
>
> would you mind telling us the top commit ID in your kernel tree ?
> Or you may try the queue branch of
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git
> and check if this "undefined reference" issue gets fixed.

Unfortunately no, the build breaks in the same way.

Uros.

> Thanks,
> Like Xu
>
> On 2020/4/9 16:20, Uros Bizjak wrote:
> > Current mainline kernel fails to build (on Fedora 31) with:
> >
> >    GEN     .version
> >    CHK     include/generated/compile.h
> >    LD      vmlinux.o
> >    MODPOST vmlinux.o
> >    MODINFO modules.builtin.modinfo
> >    GEN     modules.builtin
> >    LD      .tmp_vmlinux.btf
> > ld: arch/x86/kvm/svm/sev.o: in function `sev_flush_asids':
> > /hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:48: undefined reference to
> > `sev_guest_df_flush'
> > ld: arch/x86/kvm/svm/sev.o: in function `sev_hardware_setup':
> > /hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:1146: undefined reference
> > to `sev_platform_status'
> >    BTF     .btf.vmlinux.bin.o
> >
> > .config is attached.
> >
> > Uros.
>
