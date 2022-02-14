Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D854B5286
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354760AbiBNN7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:59:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354764AbiBNN7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:59:04 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDFA237F0
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:58:56 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id z17so10575610plb.9
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXs9XcapqbRrbbu3RpAFFzZbK/SBgndo4A8gy4sXDEk=;
        b=P2e3D/hOWT//3jYFtnJPPKCmJyGCeGMZ6ZWIshHRlJT2Efkef9rVHzR8ed5svR3m14
         u3LYGpsXDNDOF5jPfLRYSnyG618NGUfrdLS8juGGCc3Xu2lkMfkHOlmO9q86WEQ0Wqlv
         4ztlV/nJO3bvn0JFZHhsAtNvh/mzhIsgU6Au7CDpxwP4/cFYiR9QZNgInFLC56Pe5aPq
         bXu79qh+D2Bw7t+gQUXIUdXWN+Z6cAclY1/A39kNnyxdyRZYvLWukvqX9harwpHhjo9V
         KSjLbDejGsagFZX6LuNO1mouhMQgVaRKiSbxitMo7CX4GRH6J3BtNH1mzr/16tZyo9gv
         6JjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXs9XcapqbRrbbu3RpAFFzZbK/SBgndo4A8gy4sXDEk=;
        b=u6+emmsIORQwZfWoe/XDoatEe4/l4ZQXsh1xHOz86tnetb4rJv4yAhM1NUeJBywxKp
         ImYt0g/nMFD5BPh9T+Mo1awfkA2zAOpcOm60SvX2Tqb04XzTb512C3OsQyAR0dSqrOTB
         62kRgGqyQqL70bbnRRKXz2YJSHR7ls2BP45bkAuA1VrJNJvDC//Llk0gzlpF0/Q6KxmF
         +9xGVtl90TpvGQRv/VTfDalgYNwDJNigSnoL80Jtz/47DMqsaCV1eGfLy6vv1EJuqAYs
         2BWL4s5KN/Ma6OWrWcUMKNpNzTDF+7/ZRBuxVBynHItc2JjBqbE6wgOW42lJFABdR/St
         gYng==
X-Gm-Message-State: AOAM531TBykkzYG0DFzWHZVITbmbmjE0N5OMrqbH/tfcZtwWE1ih+OlK
        3pg1xn02JQItOF7J/YswxLO4/STi5BVpTqaCMTo=
X-Google-Smtp-Source: ABdhPJxRoKBRwU6H58UKPrfPWH/lWAnZqPcS8tFwF6Z5U1+98PD7kW2pwrS2qsNPTRhvwzE1XWcOQLk38V2Q4vOBv0o=
X-Received: by 2002:a17:902:b089:: with SMTP id p9mr14100225plr.93.1644847136084;
 Mon, 14 Feb 2022 05:58:56 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <244647ca-a247-cfc1-d0df-b8c74d434a77@amazon.com>
In-Reply-To: <244647ca-a247-cfc1-d0df-b8c74d434a77@amazon.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 14 Feb 2022 13:58:44 +0000
Message-ID: <CAJSP0QVqvvN=sbm=XMT8mxHQNcSfNfTrnWJXXf-QgXwxAfzdcA@mail.gmail.com>
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
        "Florescu, Andreea" <fandree@amazon.com>, hreitz@redhat.com,
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

On Wed, 9 Feb 2022 at 14:50, Alexander Graf <graf@amazon.com> wrote:
> On 28.01.22 16:47, Stefan Hajnoczi wrote:
> > Dear QEMU, KVM, and rust-vmm communities,
> > QEMU will apply for Google Summer of Code 2022
> > (https://summerofcode.withgoogle.com/) and has been accepted into
> > Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> > submit internship project ideas for QEMU, KVM, and rust-vmm!
> >
> > If you have experience contributing to QEMU, KVM, or rust-vmm you can
> > be a mentor. It's a great way to give back and you get to work with
> > people who are just starting out in open source.
> >
> > Please reply to this email by February 21st with your project ideas.
> >
> > Good project ideas are suitable for remote work by a competent
> > programmer who is not yet familiar with the codebase. In
> > addition, they are:
> > - Well-defined - the scope is clear
> > - Self-contained - there are few dependencies
> > - Uncontroversial - they are acceptable to the community
> > - Incremental - they produce deliverables along the way
> >
> > Feel free to post ideas even if you are unable to mentor the project.
> > It doesn't hurt to share the idea!
>
>
> I have one that I'd absolutely *love* to see but not gotten around
> implementing myself yet :)
>
>
> Summary:
>
> Implement -M nitro-enclave in QEMU
>
> Nitro Enclaves are the first widely adopted implementation of hypervisor
> assisted compute isolation. Similar to technologies like SGX, it allows
> to spawn a separate context that is inaccessible by the parent Operating
> System. This is implemented by "giving up" resources of the parent VM
> (CPU cores, memory) to the hypervisor which then spawns a second vmm to
> execute a completely separate virtual machine. That new VM only has a
> vsock communication channel to the parent and has a built-in lightweight
> TPM.
>
> One big challenge with Nitro Enclaves is that due to its roots in
> security, there are very few debugging / introspection capabilities.
> That makes OS bringup, debugging and bootstrapping very difficult.
> Having a local dev&test environment that looks like an Enclave, but is
> 100% controlled by the developer and introspectable would make life a
> lot easier for everyone working on them. It also may pave the way to see
> Nitro Enclaves adopted in VM environments outside of EC2.
>
> This project will consist of adding a new machine model to QEMU that
> mimics a Nitro Enclave environment, including the lightweight TPM, the
> vsock communication channel and building firmware which loads the
> special "EIF" file format which contains kernel, initramfs and metadata
> from a -kernel image.
>
> Links:
>
> https://aws.amazon.com/ec2/nitro/nitro-enclaves/
> https://lore.kernel.org/lkml/20200921121732.44291-10-andraprs@amazon.com/T/
>
> Details:
>
> Skill level: intermediate - advanced (some understanding of QEMU machine
> modeling would be good)
> Language: C
> Mentor: Maybe me (Alexander Graf), depends on timelines and holiday
> season. Let's find an intern first - I promise to find a mentor then :)
> Suggested by: Alexander Graf
>
>
> Note: I don't know enough about rust-vmm's debugging capabilities. If it
> has gdbstub and a local UART that's easily usable, the project might be
> perfectly viable under its umbrella as well - written in Rust then of
> course.

It would be great to have an open source Enclave environment for
development and testing in QEMU.

Could you add a little more detail about the tasks involved. Something
along the lines of:
- Implement a device model for the TPM device (link to spec or driver
code below)
- Implement vsock device (or is this virtio-mmio vsock?)
- Add a test for the TPM device
- Add an acceptance test that boots a minimal EIF payload

This will give candidates more keywords and links to research this project.

Thanks,
Stefan
