Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A884B999D
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 08:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbiBQHIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 02:08:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiBQHIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 02:08:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8931F298AEC
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 23:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645081702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PJwlrEigBYAbeDng+pA4J2ghsfpfNYKjHDIfIXfAcCk=;
        b=TNxh8zeQiFWBYDNt/UJ95htogmLprY7+ywAvBWBbN4ZBxeYH47e1BCgjPr3qVxJmcpglh0
        0xKi/bLOQ4sWhRi2/jhGOFze6JYbCr2PkHiULYGCkdDuzOcaCNUTv092oEWJSoZyqV70hx
        C6WWtWYW7HogOq6bO8v/22lU2uB5Upo=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-bgf_OdrBNvmOiY7aXPhsag-1; Thu, 17 Feb 2022 02:08:18 -0500
X-MC-Unique: bgf_OdrBNvmOiY7aXPhsag-1
Received: by mail-lj1-f199.google.com with SMTP id i8-20020a2ea228000000b002449296c787so1866334ljm.18
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 23:08:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PJwlrEigBYAbeDng+pA4J2ghsfpfNYKjHDIfIXfAcCk=;
        b=639OvDTIawheKL5YRls+q25VtlHSZzM0wqvWgaUxwhtIotOFmXEMvwoCbYjqK/372W
         jpq+neRtafGnewht4AwuFbZ9HvqEqSx5qHdZcuCQJWvu7tdrmyauzf6pB12Y08nJDBM2
         6cdJtHVSP8NMm+FIb+sV0UIdY3rj56Gh0VhfFIhCKkKgYx7c1RTyNc7CIR/pcfyMUTBf
         1x/B6se3rrY0e+3kXgA3CmKDQABF+psdBQsV7uVRr7id5jzwWUxbDsuiKqpZojSko/t/
         h+X4yEpHIcm0AKfXf1+ojLDqXAnD1WNleDKDMp3KxXI1fK9+/vTROEA6J8QzCAHOKGZ2
         cyVg==
X-Gm-Message-State: AOAM5309kRbJIT3EOXbHYEp0e7DaE9eXHj3gZHIWpSW6f6TROCtl0dES
        9BVRfv1SgxYZZA/UH4c7Y5GzTopGToY/YkrMAHiJ29V+EKwj/2QApeHCXKjDR5yZIuJ2WYt/MgO
        SF/D+RBYBqyF/BqzE4S1Nmo7ke4Zo
X-Received: by 2002:a05:6512:1581:b0:443:96c9:d1a0 with SMTP id bp1-20020a056512158100b0044396c9d1a0mr1165187lfb.501.1645081697258;
        Wed, 16 Feb 2022 23:08:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9ZAveF3ctcDThUhmShOSbalf72WBbK0f6Bxv13o5sV4xVgG8OW3g25T+vumGT/qKP9gOoHKx2rUn5apiTujI=
X-Received: by 2002:a05:6512:1581:b0:443:96c9:d1a0 with SMTP id
 bp1-20020a056512158100b0044396c9d1a0mr1165171lfb.501.1645081697029; Wed, 16
 Feb 2022 23:08:17 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
In-Reply-To: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
From:   Alice Frosi <afrosi@redhat.com>
Date:   Thu, 17 Feb 2022 08:08:06 +0100
Message-ID: <CABBoX7PcqRFHDm0LCwWOwmYmOwH2x70pM-3OyxfDXD1sE_fHrw@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>, hreitz@redhat.com,
        Alex Agache <aagch@amazon.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sergio Lopez Pascual <slp@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022 at 6:04 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> Dear QEMU, KVM, and rust-vmm communities,
> QEMU will apply for Google Summer of Code 2022
> (https://summerofcode.withgoogle.com/) and has been accepted into
> Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> submit internship project ideas for QEMU, KVM, and rust-vmm!
>
> If you have experience contributing to QEMU, KVM, or rust-vmm you can
> be a mentor. It's a great way to give back and you get to work with
> people who are just starting out in open source.
>
> Please reply to this email by February 21st with your project ideas.
>
> Good project ideas are suitable for remote work by a competent
> programmer who is not yet familiar with the codebase. In
> addition, they are:
> - Well-defined - the scope is clear
> - Self-contained - there are few dependencies
> - Uncontroversial - they are acceptable to the community
> - Incremental - they produce deliverables along the way
>
> Feel free to post ideas even if you are unable to mentor the project.
> It doesn't hurt to share the idea!
>

I'd like to propose this idea:

Title: Create encrypted storage using VM-based container runtimes

Cryptsetup requires root privileges in order to be able to encrypt
storage with luks. However, privileged containers are generally
discouraged for security reasons. A possible solution to avoid extra
privileges is using VM-based container runtimes (e.g crun with libkrun
or kata-containers) and running inside the Virtual Machine the tools
for the storage encryption.

This internship focus on a PoC for integrating and extending crun with
libkrun in order to be able to create encrypted storage. The initial
step will focus on creating encrypted images to demonstrate the
feasibility and the necessary changes in the stack. If the timeframe
allows it, an interesting follow-up of the first step is the
encryption of persistent storage using block-based PVCs.

Language: C, rust, golang
Skills: containers and virtualization would be a big plus
I won't put a level but the intern needs to be willing to dig into
different source codes like crun (written in C), libkrun (written in
Rust) and possibly podman or other kubernetes/containers projects
(written in go)
Mentor: Alice Frosi, Co-mentor: Sergio Lopez Pascual

Let me know if the idea sounds feasible to you!

Many thanks,

Alice

