Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076F769B17A
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjBQQ4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjBQQ4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:56:51 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08463A868
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:56:46 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 63so1327734ybq.6
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J4RHINuYWc62wuiZUYoVA1vr2xMboB0oFkSwWLbZ724=;
        b=RilVJ/HKpoW7n5UWDOfmrCHM8smsB9ocQ/p3kdiPDCSdDzuOlCJEft4fkow+1dxspC
         GC8C4lRh3cOpNfXNe6d4qZZp98hQu6zKVw3dmJp4Xx6Oc7yZJk+tJpIREqR6DX5P8AZV
         YFpHe/T1skf1BjQ0qqt6rq3LcasxdRFSrcW98DOzWrr81YY80DpinOc4vjfb5LmHjF6h
         uXsCTd3/tK9RtuGq35Z0leESq2HGjaeosMdNT8xA3RsTGFDOB4LWBhp1LeylZDK+bBus
         OFQQJptLk7+igo7m3ejC12+xx66bsaz0a5wCgpuZa1i5gHIPenso0tLc+viophHTM4rZ
         Qb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4RHINuYWc62wuiZUYoVA1vr2xMboB0oFkSwWLbZ724=;
        b=pyhTpMKmmRBUtuoh/f3ZBopRrLCESyn5Cz26vIYIyUSVC1252zfNHnNJHuKWbzTgTU
         IhQ38PY56yCEyymlwl9cLDFN78ADUGMihvFSosthbUhQ/WChfiab5w1M+sSY0MPfUBDw
         PyVqmV8Lhs9o7yjkHbGgxJd9omLGRGhd36yjhg47ypMpFjiKrYsHXQWNJ2sQQPYsA1TG
         e0cYRKsumti9/2bZ/tDnMkoBMIj4IWATSjmpRuA5uH2nPFSzX1makGhJ3KcjGLfRpc+u
         tXSw3fm/Kdi+EQ9cjDgsvPgCJsn3FHcf4X5s5igUlzMjjuUqvNckrZSHQTM+tYZ0EOaU
         CpmA==
X-Gm-Message-State: AO0yUKWfy3sWhFfLrKTJWmnhuB6Nj9OWWJmKctBAGry+gVVMgsMxyOZG
        hfzkwYlV8qXIURVXNr0LdaMzrHvDO1Ht0WJpKBk=
X-Google-Smtp-Source: AK7set9I98nAtJXAqf2cGgeSocah47oxAOCKp17Pa8rpZh8CKcwj6w7QL2PwPvnpDaxatA7kg/Dbt82bbdNpUSZSncI=
X-Received: by 2002:a5b:1c1:0:b0:95d:85ed:4594 with SMTP id
 f1-20020a5b01c1000000b0095d85ed4594mr704527ybp.513.1676653005832; Fri, 17 Feb
 2023 08:56:45 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
 <CAJh=p+4_XkR-MN4ByiOHmu_8-RSMDS69zKd_AXYX-47Kzp7Ciw@mail.gmail.com>
In-Reply-To: <CAJh=p+4_XkR-MN4ByiOHmu_8-RSMDS69zKd_AXYX-47Kzp7Ciw@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 17 Feb 2023 11:56:34 -0500
Message-ID: <CAJSP0QUrXeySuD4xi-sbuAeniuKJQLHfg9+Xu-Xpn=-SZdKsxQ@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2023
To:     German Maglione <gmaglione@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Damien <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alberto Faria <afaria@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Bernhard Beschow <shentey@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Feb 2023 at 11:43, German Maglione <gmaglione@redhat.com> wrote:
>
> Hi Stefan,
>
> Sorry for being so late, if it is still possible I would like to propose the
> following project:

Added, thanks!
https://wiki.qemu.org/Internships/ProjectIdeas/VirtiofsdSandboxingTool

Stefan

>
> === A sandboxing tool for virtiofsd ===
>
> ''Summary:''' Create a tool that runs virtiofsd in a sandboxed environment
>
> Virtiofs is a shared file system that lets virtual machines access a directory
> tree on the host. Unlike existing approaches, it is designed to
> offer local file system semantics and performance.
>
> Currently, virtiofsd integrates the sandboxing code and the server code in a
> single binary. The goal is to extract that code and create an external tool that
> creates a sandbox environment and runs virtiofsd in it. In addition, that tool
> should be extended to be able to run virtiofsd in a restricted environment with
> Landlock.
>
> This will allow greater flexibility when integrating virtiofsd into a VMM or
> running it inside a container.
>
> Goals:
> * Understand how to setup a restricted environment using chroot, namespaces, and
>   Landlock
> * Refactor virtiofsd to extract the sandbox code to its own crate
> * Create an external sandboxing tool for virtiofsd
>
> '''Links:'''
> * https://virtio-fs.gitlab.io/
> * https://gitlab.com/virtio-fs/virtiofsd
> * https://landlock.io/
>
> '''Details:'''
> * Project size: 175 hours
> * Skill level: intermediate (knowledge of Rust and C)
> * Language: Rust
> * Mentor: German Maglione <gmaglione@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>
> * Suggested by: German Maglione <gmaglione@redhat.com>
>
>
> On Fri, Jan 27, 2023 at 4:18 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>>
>> Dear QEMU, KVM, and rust-vmm communities,
>> QEMU will apply for Google Summer of Code 2023
>> (https://summerofcode.withgoogle.com/) and has been accepted into
>> Outreachy May 2023 (https://www.outreachy.org/). You can now
>> submit internship project ideas for QEMU, KVM, and rust-vmm!
>>
>> Please reply to this email by February 6th with your project ideas.
>>
>> If you have experience contributing to QEMU, KVM, or rust-vmm you can
>> be a mentor. Mentors support interns as they work on their project. It's a
>> great way to give back and you get to work with people who are just
>> starting out in open source.
>>
>> Good project ideas are suitable for remote work by a competent
>> programmer who is not yet familiar with the codebase. In
>> addition, they are:
>> - Well-defined - the scope is clear
>> - Self-contained - there are few dependencies
>> - Uncontroversial - they are acceptable to the community
>> - Incremental - they produce deliverables along the way
>>
>> Feel free to post ideas even if you are unable to mentor the project.
>> It doesn't hurt to share the idea!
>>
>> I will review project ideas and keep you up-to-date on QEMU's
>> acceptance into GSoC.
>>
>> Internship program details:
>> - Paid, remote work open source internships
>> - GSoC projects are 175 or 350 hours, Outreachy projects are 30
>> hrs/week for 12 weeks
>> - Mentored by volunteers from QEMU, KVM, and rust-vmm
>> - Mentors typically spend at least 5 hours per week during the coding period
>>
>> For more background on QEMU internships, check out this video:
>> https://www.youtube.com/watch?v=xNVCX7YMUL8
>>
>> Please let me know if you have any questions!
>>
>> Stefan
>>
>
>
> --
> German
