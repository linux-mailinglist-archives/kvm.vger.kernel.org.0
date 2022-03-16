Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208304DB0D5
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 14:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344313AbiCPNRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 09:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbiCPNRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 09:17:37 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D37E403FE
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 06:16:23 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id t2so3869217pfj.10
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 06:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5QoOLQCH6W8SvrDhidEQQuX3kQLXun4tVXl3MOAktVk=;
        b=Lo1tUTRDYSi1EqEAhNSTV2FAJcCJVYEUHZoyumTe4Fg3zuVUyuqvgfW43DZiMdG+fW
         gTZsP3hkjaGwUxrtOj4G3LQnnr6I2B9axcFIxk3vQEFlew8fOSbN3cLfGsJfDo1LaydP
         I3Q60uEnNRpii6LRgAPX82XTKkHYlMPOKyEyAb9R2DH1NYFyqKH0+FrjPJK60vouxrcI
         Su3OqIhTY0qyQrEnYUug5wDTY/Zd3zyJtiiwbeJuMksEuXhq7h9w/Ks3nRrkiYMq+Z/V
         ZzJvUjwevVd14JoYl1br8WwjFVRAX7vsGnBu0iJrb7+0eML2IC+J+H7Si5DyKB1qxAar
         /pcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5QoOLQCH6W8SvrDhidEQQuX3kQLXun4tVXl3MOAktVk=;
        b=K/53ERQs9gIoOCgKYIOl6CMJz+SZ97BSzt4PZt2nTw004whlMx9KfxOS5YSvloVsnT
         iyuJvexzmsTg7NGQpmU8GRjmJF+WcsP6S2of2dF8+W1elgzP9kEPpoTH09RrR2jkmTxY
         oF4d1ZkOSxpuUALlWYWpCX4elTZ4Fp5U3W4FaB709jA3SlalyJK8yd53u4XEx5CwNCu9
         bdCUAtf4MFWw4S+zj1x0zCn51iVXRtu192ZGijNF+/Y3yZ/ExnInygSfCAwmbMVk3gPT
         hJ7TWdCi+gx+RDJU7u9ihIe/Dtq4J3FZs5hBWtPnGMGOemEVxfVx8jH9MZLsiH9CFMak
         gWQA==
X-Gm-Message-State: AOAM533IfvjTHE+AJHVizbZpTwaUzH8HDcrDrHr0Va62fAdgXvDawDiY
        yB/+g68nHhP8kEm3d3X/qK2Li32EwzL3Ghxo/S8=
X-Google-Smtp-Source: ABdhPJz6RtgOgg34TPHvPiT760rW1IhoxqnqCvtmFtoRZq64b6vT+XXUT1I9k7F4voJyKuDm+lCrzA2BuIfd3I8Qn8I=
X-Received: by 2002:a05:6a00:16c7:b0:4f7:e497:69c7 with SMTP id
 l7-20020a056a0016c700b004f7e49769c7mr12732196pfc.7.1647436582554; Wed, 16 Mar
 2022 06:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <244647ca-a247-cfc1-d0df-b8c74d434a77@amazon.com> <CAJSP0QVqvvN=sbm=XMT8mxHQNcSfNfTrnWJXXf-QgXwxAfzdcA@mail.gmail.com>
In-Reply-To: <CAJSP0QVqvvN=sbm=XMT8mxHQNcSfNfTrnWJXXf-QgXwxAfzdcA@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Wed, 16 Mar 2022 13:16:11 +0000
Message-ID: <CAJSP0QUZS=vcruOixYwsC_Nwy2mvgeemuJimSqv98KsKr4BdSQ@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Alexander Graf <graf@amazon.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, ohering@suse.de,
        "Eftime, Petre" <epetre@amazon.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Feb 2022 at 13:58, Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Wed, 9 Feb 2022 at 14:50, Alexander Graf <graf@amazon.com> wrote:
> > On 28.01.22 16:47, Stefan Hajnoczi wrote:
> > > Dear QEMU, KVM, and rust-vmm communities,
> > > QEMU will apply for Google Summer of Code 2022
> > > (https://summerofcode.withgoogle.com/) and has been accepted into
> > > Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> > > submit internship project ideas for QEMU, KVM, and rust-vmm!
> > >
> > > If you have experience contributing to QEMU, KVM, or rust-vmm you can
> > > be a mentor. It's a great way to give back and you get to work with
> > > people who are just starting out in open source.
> > >
> > > Please reply to this email by February 21st with your project ideas.
> > >
> > > Good project ideas are suitable for remote work by a competent
> > > programmer who is not yet familiar with the codebase. In
> > > addition, they are:
> > > - Well-defined - the scope is clear
> > > - Self-contained - there are few dependencies
> > > - Uncontroversial - they are acceptable to the community
> > > - Incremental - they produce deliverables along the way
> > >
> > > Feel free to post ideas even if you are unable to mentor the project.
> > > It doesn't hurt to share the idea!
> >
> >
> > I have one that I'd absolutely *love* to see but not gotten around
> > implementing myself yet :)
> >
> >
> > Summary:
> >
> > Implement -M nitro-enclave in QEMU
> >
> > Nitro Enclaves are the first widely adopted implementation of hypervisor
> > assisted compute isolation. Similar to technologies like SGX, it allows
> > to spawn a separate context that is inaccessible by the parent Operating
> > System. This is implemented by "giving up" resources of the parent VM
> > (CPU cores, memory) to the hypervisor which then spawns a second vmm to
> > execute a completely separate virtual machine. That new VM only has a
> > vsock communication channel to the parent and has a built-in lightweight
> > TPM.
> >
> > One big challenge with Nitro Enclaves is that due to its roots in
> > security, there are very few debugging / introspection capabilities.
> > That makes OS bringup, debugging and bootstrapping very difficult.
> > Having a local dev&test environment that looks like an Enclave, but is
> > 100% controlled by the developer and introspectable would make life a
> > lot easier for everyone working on them. It also may pave the way to see
> > Nitro Enclaves adopted in VM environments outside of EC2.
> >
> > This project will consist of adding a new machine model to QEMU that
> > mimics a Nitro Enclave environment, including the lightweight TPM, the
> > vsock communication channel and building firmware which loads the
> > special "EIF" file format which contains kernel, initramfs and metadata
> > from a -kernel image.
> >
> > Links:
> >
> > https://aws.amazon.com/ec2/nitro/nitro-enclaves/
> > https://lore.kernel.org/lkml/20200921121732.44291-10-andraprs@amazon.com/T/
> >
> > Details:
> >
> > Skill level: intermediate - advanced (some understanding of QEMU machine
> > modeling would be good)
> > Language: C
> > Mentor: Maybe me (Alexander Graf), depends on timelines and holiday
> > season. Let's find an intern first - I promise to find a mentor then :)
> > Suggested by: Alexander Graf
> >
> >
> > Note: I don't know enough about rust-vmm's debugging capabilities. If it
> > has gdbstub and a local UART that's easily usable, the project might be
> > perfectly viable under its umbrella as well - written in Rust then of
> > course.
>
> It would be great to have an open source Enclave environment for
> development and testing in QEMU.
>
> Could you add a little more detail about the tasks involved. Something
> along the lines of:
> - Implement a device model for the TPM device (link to spec or driver
> code below)
> - Implement vsock device (or is this virtio-mmio vsock?)
> - Add a test for the TPM device
> - Add an acceptance test that boots a minimal EIF payload
>
> This will give candidates more keywords and links to research this project.

Hi Alex,
Would you like me to add this project idea to the list? Please see
what I wrote above about adding details about the tasks involved.

Thanks,
Stefan
