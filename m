Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4D131EE5C
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhBRSdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbhBRRor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 12:44:47 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79CCC06178A
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:44:04 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 75so1564454pgf.13
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Xh74tiaKTLgu6iSFVSNwadSz4xskX8HanaA+nosu/A=;
        b=Td2Sr5J5o1Z/PzUcOrqIT/3IQ5NAKiexgxuyzDqdkNFIq3Oj8rrsB0WZyBm0sQMtZR
         tDEPOX4FlzHlTtrL1rqjxy00CXfxMHkGfbbC15K08umBkjmE5wfO5YTnpsNbtRdr31Vs
         b+WM8Db/UjWIhmjUktMlqBxp3haVlX++KnVgO0hMVAxVziQmujxpHhO9jyt12s//ZIDj
         UoEF6029XTwA3sg/FKspQCDPrIvf5sxI0jUuAwmlv5EVcyPCa/WJzmlTIiQpDsCT9Ypv
         o4uR7JfN7/QgabeLyAWfHQ9sdudBKRsSt+CKi9yz3w1oDB63k+xo7DPRjuQcPqj9JIBM
         bVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Xh74tiaKTLgu6iSFVSNwadSz4xskX8HanaA+nosu/A=;
        b=h0hJH0o+WWfQxKbVpHGG0bbSF+lJZuIGPInt3zUAqDGJ72VtD3UkeXDXCiCGnAABMl
         iWzWCQYOQZKvg/P+/sEm8mC7uQIeayZ9g5sMUaQA9Czm/8szuL/iaJxsJEh7b6za8NDo
         NPOzXh694/jEIkQvz/gvqBSeejUASTD9oaVw+IszohgwKS+YdsS8CJoREJQuh0E+Hqhd
         2lx9bO0o3tG5WfeSmoA+4nWXd+hvch+jOks7uPFLgNxND60Zlipti3MqianenDHk0igW
         WP4pbe1gsWsoeQjYXOqkGvnQSE65KdxrJ2V0IreYZGR+lJzA2rB0rZG82bkoxQU2LS9J
         VvCA==
X-Gm-Message-State: AOAM530NC26IcvmXef9IocE0ueixni+jlX1gWERJ3wL7NCcoxa7xzIvG
        pn8fNrX5m7Tkpua4jOIe5Rw3bBXqZtUdaYsMuT0=
X-Google-Smtp-Source: ABdhPJwZfCFi1qt998/YfwPE+9jq7ogTdqh51FACnJE3iBBuQd3kdVn3+n+GgdDB010i9pbbTnd1vf9xL/WMlchW95E=
X-Received: by 2002:a63:1723:: with SMTP id x35mr4987883pgl.393.1613670244019;
 Thu, 18 Feb 2021 09:44:04 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QWWg__21otbMXAXWGD1FaHYLzZP7axZ47Unq6jtMvdfsA@mail.gmail.com>
 <1613136163375.99584@amazon.com> <CAJSP0QXEvw6o7XFk9FXudr9PmorFHiOuNRg16DjJhBgj_qC-FQ@mail.gmail.com>
 <f0493c86-e92b-8bb6-a4a9-33646bf05fab@amazon.com>
In-Reply-To: <f0493c86-e92b-8bb6-a4a9-33646bf05fab@amazon.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Thu, 18 Feb 2021 17:43:52 +0000
Message-ID: <CAJSP0QUH5Ewa=xC5wUfPTbseg=5GCAzXtNYK8c40HKikRWkxSA@mail.gmail.com>
Subject: Re: [Rust-VMM] Call for Google Summer of Code 2021 project ideas
To:     Andreea Florescu <fandree@amazon.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "rust-vmm@lists.opendev.org" <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        Alberto Garcia <berto@igalia.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Aleksandar Markovic <Aleksandar.Markovic@rt-rk.com>,
        Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021 at 11:50 AM Andreea Florescu <fandree@amazon.com> wrote:
> On 2/17/21 1:20 PM, Stefan Hajnoczi wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >
> >
> >
> > Thanks, I have published the rust-vmm project ideas on the wiki:
> > https://wiki.qemu.org/Google_Summer_of_Code_2021
> Thanks, Stefan!
> >
> > Please see Sergio's reply about virtio-consoile is libkrun. Maybe it
> > affects the project idea?
> I synced offline with Sergio. It seems I've misread his comment.
> The code is already available in libkrun, and to port it to rust-vmm
> will likely take just a couple of days. We explored the option of also
> requesting to implement VIRTIO_CONSOLE_F_MULTIPORT to make it an
> appropriate GSoC project, but we decided this is not a good idea since
> it doesn't look like that feature is useful for the projects consuming
> rust-vmm. It also adds complexity, and we would need to maintain that as
> well.
>
> Since it would still be nice to have virtio-console in rust-vmm, I'll
> just open an issue in vm-virtio and label it with "help wanted" so
> people can pick it up.
> Can we remove the virtio-console project from the list of GSoC ideas?

Done.

> Also, iul@amazon.com will like to help with mentoring the GSoC projects.
> Can he be added as a co-mentor of: "Mocking framework for Virtio Queues"?

Done.

Thanks for getting the rust-vmm mentors together! I'm looking forward
to more Rust virtualization projects :).

Stefan
