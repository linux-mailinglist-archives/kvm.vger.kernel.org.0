Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A805348A36E
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 00:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345636AbiAJXKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 18:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242456AbiAJXKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 18:10:19 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19576C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:10:19 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id u8so19937701iol.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i56dmiKFJTz7J+/29IVu7tJ1DviTvoTcjNMgMReords=;
        b=NISRuqHiFv5JvcDKDmKF2qp7N46SKxQSlEzzm7du49yfGeG7oR+jS3JZo3KVecwaNd
         +Ese/IqFOmACd4oIGTV5C0UtauHkpjzz4RtzXAQ3/1sAfZZtyQyjRZKv/jnolSjdO/Tu
         b4DFChNxUt9GS4sZI1oFm+8v/bf0QPHYTjdGt0NWkpP0L/zz75dTL+eM/JDGZqdBltST
         ktjTGb5o0xKaMT/uOx0bkwXzJvHCvcCg2QvbSRkxBT/3uATJ2f4dFxIk0x1GWEBKyeSM
         hoGvQVL9ZHFn2l+/RWoydIxVogRgyK82xFoskil3ksISXzQCQualWXMLePKucAFyVKci
         /S9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i56dmiKFJTz7J+/29IVu7tJ1DviTvoTcjNMgMReords=;
        b=g6RsK70LxyiwyhkM3cST1FSN7stclwWpQByeAjRCq2wZ3NYrFetn+DfoevEY+rngBN
         mFJF1Vh114ooDR4T2XeglYlsPAh6JaTVh81RVz0LkMChfF1aucJybyO4pxFXZdLw8GHu
         /BGLQVbLU4H6AJ91McbNOKbwlJF4w6WXzky6ebiOCNYqlpGBWZw94UtMFr/ZcmFk2Jmh
         DmomOPcAsPDDfLooLBEqdEOLeT6WMBWoSRbKAFe81y/j6pPIsTvZmcVDfkkkTJ9mekYg
         LkwcFg459Fl2wjVoqsWf58OoNO2GF6dgwKKTmnvNj5AUBA1GI88nynNLvkD4jGRQMCR2
         uDjQ==
X-Gm-Message-State: AOAM533fCjgeGH6o5MgFo7acUIH14GqGn1SPNRf7grza6RSZq6iu3Akx
        15bMGCvrkeBzacznNQwhBx8BF36hRfHEfoR3CwA=
X-Google-Smtp-Source: ABdhPJwHQXu+ExB9DkfL21+E0aF1Eeg/9j8DWaYEDlnnIJKMSrfVOWFNGIJHNe3qZCFl/uFnjXBf4rw0fnIAd3GNZkk=
X-Received: by 2002:a02:6954:: with SMTP id e81mr93782jac.63.1641856218466;
 Mon, 10 Jan 2022 15:10:18 -0800 (PST)
MIME-Version: 1.0
References: <20220110013831.1594-1-jiangyifei@huawei.com> <20220110013831.1594-3-jiangyifei@huawei.com>
In-Reply-To: <20220110013831.1594-3-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 11 Jan 2022 09:09:52 +1000
Message-ID: <CAKmqyKOOD-iRxX8aj7V2Vtfmi6=i9jCDT=0qgUvxX1j1DOOHXg@mail.gmail.com>
Subject: Re: [PATCH v4 02/12] target/riscv: Add target/riscv/kvm.c to place
 the public kvm interface
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>,
        Anup Patel <anup.patel@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 11:48 AM Yifei Jiang via <qemu-devel@nongnu.org> wrote:
>
> Add target/riscv/kvm.c to place kvm_arch_* function needed by
> kvm/kvm-all.c. Meanwhile, add kvm support in meson.build file.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>
> ---
>  meson.build              |   2 +
>  target/riscv/kvm.c       | 133 +++++++++++++++++++++++++++++++++++++++
>  target/riscv/meson.build |   1 +
>  3 files changed, 136 insertions(+)
>  create mode 100644 target/riscv/kvm.c
>
> diff --git a/meson.build b/meson.build
> index 53065e96ec..7eaec31a3a 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -90,6 +90,8 @@ elif cpu in ['ppc', 'ppc64']
>    kvm_targets = ['ppc-softmmu', 'ppc64-softmmu']
>  elif cpu in ['mips', 'mips64']
>    kvm_targets = ['mips-softmmu', 'mipsel-softmmu', 'mips64-softmmu', 'mips64el-softmmu']
> +elif cpu in ['riscv']
> +  kvm_targets = ['riscv32-softmmu', 'riscv64-softmmu']
>  else
>    kvm_targets = []
>  endif

Can you add this as a separate commit at the end of the series?

That way we have implemented KVM support before we enable it for users.

Alistair
