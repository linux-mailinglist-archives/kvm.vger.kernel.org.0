Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BE31A3100
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 10:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDIIej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 04:34:39 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41987 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgDIIei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 04:34:38 -0400
Received: by mail-io1-f67.google.com with SMTP id y17so2997017iow.9
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 01:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K1E0J5vxo102jBUCjnqCrXjn1UT0fbZexcGRihASQcs=;
        b=tlnmgIw9Z+kX338M03W1kAb/YjGv17SuGIxWUlBTxzb2FGoapCLrrsynRlX5++4GyS
         9ZzqtHQcgOyzkYp2e6miemwuP4EDrzle8RUBFHPRsC+hKy6Z7CMwj6PAhrtCD0fpNI9l
         jC9Lv+tfJ1knnPFHkn2+6eEHDMcWIdT2zF/cN58S1TSvexy2Z5/oaBrt3UJ7Kn5e1oro
         QeO24AlZNOrwbuDcPG9uBWSRVPpZLbL5Do0xrtSMTakJZCtmm1k0qi+2myyLEWj5fmo7
         cy7LLxZxbbGRMIWuZj13wX7pjiPBlks7dnNk6iuMfiBva7O31O3UT0FQyC1RT4UsWfWr
         +LYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K1E0J5vxo102jBUCjnqCrXjn1UT0fbZexcGRihASQcs=;
        b=a/Bbus06Y9yLs1IOUqBXD5286Q1EXP8oMDk+xUHIdlAgSsPcfUP8aiTz5B1OdPS79P
         LBZVsN5dZeGn1oeZ1jjrPjnrA4polnnWT4vOBKKw8Wyz0KiqKSERBl1JeDXEA8Bf8MEG
         tYalvM5DxRq9J1G0RXsH+5Pu6LevHOwoBSd971uh4l1ADFyMg/3t5NSnld98TFZkaIyG
         Vl0T9mJP4TDYtJd/4Q1wN1rMSWyu8TryQRsqgs3TprlZB8iU9ULngLMGZ8Ul+579riQA
         SElqEV7N5091CPl8YCAgnNWQ3UjT4cIRfEylGtzUHbcgkNkvOO//mzjcvAvNz/QKobSs
         ucmg==
X-Gm-Message-State: AGi0PubX1pMp5lslcu/JofkwjgAWR4qawMqtCdh3GPB7dWne/HDBEDMR
        vJYGPfzLx/M6pm6cB5npDdFRsUruhFZRDhGMPbQ=
X-Google-Smtp-Source: APiQypKcSxiOpPv9M0K/92K1Fmght2SYfnVHk9qZpjo8VsclOTgZQAYBWZP/PpPLtrGD/1yTLC+w2whia1CFclZEzCI=
X-Received: by 2002:a02:1482:: with SMTP id 124mr1602518jag.4.1586421278070;
 Thu, 09 Apr 2020 01:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
 <8079b118-1ff4-74a8-7010-0601d211a221@intel.com>
In-Reply-To: <8079b118-1ff4-74a8-7010-0601d211a221@intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 9 Apr 2020 10:34:26 +0200
Message-ID: <CAFULd4a5QJUSg8RDZjsiZc85SQ5MywQ5j5_SP2NEmyCKRFdWxA@mail.gmail.com>
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

Top of tree is at:

commit 5d30bcacd91af6874481129797af364a53cd9b46 (HEAD -> master,
origin/master, origin/HEAD)
Merge: fcc95f06403c c6f141412d24
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Apr 8 21:51:14 2020 -0700

    Merge tag '9p-for-5.7-2' of git://github.com/martinetd/linux

    Pull 9p documentation update from Dominique Martinet:
     "Document the new O_NONBLOCK short read behavior"

    * tag '9p-for-5.7-2' of git://github.com/martinetd/linux:
      9p: document short read behaviour with O_NONBLOCK

BR,
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
