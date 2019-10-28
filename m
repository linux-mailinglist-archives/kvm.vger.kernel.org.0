Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D889DE74CB
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 16:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390679AbfJ1PQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 11:16:58 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36864 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731176AbfJ1PQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 11:16:58 -0400
Received: by mail-ot1-f65.google.com with SMTP id 53so6935178otv.4
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 08:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b3W8+Qp16hmsb7/JhtK8PXuOeb3m3ErHdyA5OPSEtIk=;
        b=uAibY66Cn5eqjLRfWcMvqp6bm84T/njNNWYsekP/MKFcRDuKTn6JlJTDmvhB+ZuMVC
         JqY1mF24mP+Q01BlOdZpS47rfjlTzUC54gSN589nwK50xAPrMwmbVnFVa5GbudhTXsO8
         3Jjq72jE17k85mdGDAVVued3ug04Jg8/PwdJOsw8e7RcgD5BmZQjh5uDcOrr4qKXoDSI
         I2HivvV1/6Kl26NEnNvzsASBXDkN+tqOMtYG2Moeg+VFEaJOiB1YAZR/jRA4s4CG6dVO
         df7akOVvV5rMiJzF0FHqEtzyf3kyutnWGOg3GFzLLN/8dCgxz6RBJTOvBKNNgO3YI+e7
         tAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b3W8+Qp16hmsb7/JhtK8PXuOeb3m3ErHdyA5OPSEtIk=;
        b=g+R28lloc9LWa7DOXedeq3dOFIlkNhWkd9kC5N8AG2Sc5D6HNewu9RsKyNlHy9DWRG
         gFOODNlENaW7Ais0HKWAra9RLO7tq2LZ8h0wgoSxw1IObSCW+pMy7Ellb3aD0zGhasBC
         4Fa9fOzsDJeu7v5M0FO3ijeuFb/PMRyNfoTT0iVKg/4NTLqxD0SCAeZ9fRj2BgTmxys0
         bFeR80qdpaLUORy510mNyt1qTKtXPcncrduGQcVdPmOED4YocprmpcspuXRFNdR3EjkS
         NvMXjNhg+2c3a4h53t2+fFK1BCff2wWciYreIaR9XGLE8Xr1hR3KlS5tAVXch/QcfwSL
         dzwg==
X-Gm-Message-State: APjAAAUNlGhQWLLF6QaPNhEEXyflg8Dop8ksJYSHvYf6qz9Ye9k9URNq
        Pl0FE8GLneK+MTeTUCKCXcm4ZmYaFQz4LpOkIyTnFQ==
X-Google-Smtp-Source: APXvYqwqqKJhg7rD9h45FcQj/MOCW1kI8o9v8PwLEaiJloqU8FA8MBujZefHAT4c+ZPqFdOMOqMj8n8/SIENvz5VnJ0=
X-Received: by 2002:a9d:7385:: with SMTP id j5mr4039306otk.135.1572275817240;
 Mon, 28 Oct 2019 08:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <20191026032447.20088-1-zhengxiang9@huawei.com>
 <20191027061450-mutt-send-email-mst@kernel.org> <6c44268a-2676-3fa1-226d-29877b21dbea@huawei.com>
 <20191028042645-mutt-send-email-mst@kernel.org> <1edda59a-8b3d-1eec-659a-05356d55ed22@huawei.com>
 <20191028104834-mutt-send-email-mst@kernel.org> <a16f00df-98cd-3469-1c64-d9d7a6ccaccf@huawei.com>
In-Reply-To: <a16f00df-98cd-3469-1c64-d9d7a6ccaccf@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 28 Oct 2019 15:16:56 +0000
Message-ID: <CAFEAcA9fTOoOpeHfnhgy1p-tXk3b8p-e8T02jWkhhBmjv3OnDA@mail.gmail.com>
Subject: Re: [PATCH v20 0/5] Add ARMv8 RAS virtualization support in QEMU
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, wanghaibin.wang@huawei.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Linuxarm <linuxarm@huawei.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Xiang Zheng <zhengxiang9@huawei.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        James Morse <james.morse@arm.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "xuwei (O)" <xuwei5@huawei.com>, Laszlo Ersek <lersek@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Oct 2019 at 15:11, gengdongjiu <gengdongjiu@huawei.com> wrote:
>
> On 2019/10/28 22:56, Michael S. Tsirkin wrote:
> > On Mon, Oct 28, 2019 at 09:50:21PM +0800, gengdongjiu wrote:
> >> Hi Michael,
> >>
> >> On 2019/10/28 16:28, Michael S. Tsirkin wrote:
> >>>>> gets some testing.  I'll leave this decision to the ARM maintainer.  For
> >>>>> ACPI parts:
> >>>>>
> >>>>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> >>>> Got it, Thanks for the Reviewed-by from Michael.
> >>>>
> >>>> Hi Michael,
> >>>>   According to discussion with QEMU community, I finished and developed the whole ARM RAS virtualization solution, and introduce the ARM APEI table in the first time.
> >>>> For the newly created files, which are mainly about ARM APEI/GHES part,I would like to maintain them. If you agree it, whether I can add new maintainers[1]? thanks a lot.
> >>>>
> >>>>
> >>>> [1]:
> >>>> +ARM APEI Subsystem
> >>>> +M: Dongjiu Geng <gengdongjiu@huawei.com>
> >>>> +M: Xiang zheng <zhengxiang9@huawei.com>
> >>>> +L: qemu-arm@nongnu.org
> >>>> +S: Maintained
> >>>> +F: hw/acpi/acpi_ghes.c
> >>>>
> >>> I think for now you want to be a designated reviewer.  So I'd use an R:
> >>> tag.
> >>
> >>  Thanks for the reply.
> >>  I want to be a maintainer for my newly created files, so whether I can use M: tag. I would like to contribute some time to maintain that, thanks a lot.
> >
> > This will fundamentally be up to Peter.
>
> Thanks.
>
> Hi Peter,
>     what do you think about it?

I suggest you just use R: for the moment. The code will all end up going
through my tree or perhaps Michael's anyway, so it doesn't make much
practical difference.

thanks
-- PMM
