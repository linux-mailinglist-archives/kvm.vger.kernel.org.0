Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6595B4BC8BC
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 14:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242354AbiBSNtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 08:49:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbiBSNtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 08:49:00 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE4BBF7A
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 05:48:41 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id qe15so10917770pjb.3
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 05:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TMSny8Hb1/dj+Tg4cloLmwVkat85TCFFhtPIeBpg4qg=;
        b=pEI5DA4H3nyYsQetFyyEgRvzQXP2CNIZpTo6L2RWZLMnNP8t+aHpFkHJWJNtwFxzjP
         FyrzbI7oFcKD+/l3+xdincK/+TOEw4+5t0jw3AH1UPcDOWGyv8Z+jfrOlxnjoWoNj1Ya
         kDs3WMQGbqXBNnWmSH9cBZRzwGSGgGcwBRF4Ni7EWrNRZiuOyzeJVKyf3C04dPMtwYpO
         8zIxuhiv8PAgTlMme0SvpBkNt7hp+NCoKy6xdyxV0D3iHhmrI9oIc7J/jb0qTR4TKN7a
         rMZ+naEWS9O+3BU8EjLmoZjaGVpd1w9x66tQYwPRIOir2TsvweQ24kLoSJO4PxaeOkLI
         ZOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TMSny8Hb1/dj+Tg4cloLmwVkat85TCFFhtPIeBpg4qg=;
        b=ssZAQpqj1GZjnczD+DGjJojuwC6RIdacH9tLACkbwWnBFrJb9Rlp/AnFBQwUyAcJyX
         WHL++W0d3K/Va2MItLSBadPnv96CWv7tJMezostLH3xg3bDhclLJznChrocfmoQh5uxC
         Ld6XyPcd5aQg/otE/S7VlYln+QzQmIOFi7DiEp67ya5rJR3DlGEF+TuJQ3xOpcM8k+2H
         jMVWd+APPJTF1xtIRrueJiq1c4RURd/z+toNISWgr0+YgIOGjaYm0A8bTEGoWB7squ8y
         WNP2YRHNG21J1HcCx9zyyK1q9wXdXy/ZXQsEDNwukxV7g15Nk4KAckSxef3J+1Z2+/qJ
         Tacw==
X-Gm-Message-State: AOAM532S7pyb9heBgUm3QVlUq+O/Z7w6HtgmR8FztjogyVPNC0Jvzg5W
        HmUKyOw+W3oxjZxj42AwPKlQV6HMx8wADGiTLnUIMe92
X-Google-Smtp-Source: ABdhPJyE47hQVgA1q72jThE17dy2tEtzCHWvrzz2PSgzP3GXQcFrprR1DKCs5OoUeUiM+hddAnYZQy8ErlzDy/Qmh2g=
X-Received: by 2002:a17:90a:f318:b0:1bb:c168:90ec with SMTP id
 ca24-20020a17090af31800b001bbc16890ecmr11433360pjb.157.1645278520612; Sat, 19
 Feb 2022 05:48:40 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com> <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
In-Reply-To: <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Sat, 19 Feb 2022 13:48:29 +0000
Message-ID: <CAJSP0QU1LgqbKXePwojKKZsyKeyAR=reuMUt8ecBH8B6bhVV8Q@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Mark Kanda <mark.kanda@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Feb 2022 at 11:40, Michal Pr=C3=ADvozn=C3=ADk <mprivozn@redhat.c=
om> wrote:
>
> On 2/17/22 18:52, Paolo Bonzini wrote:
> > On 1/28/22 16:47, Stefan Hajnoczi wrote:
> >> Dear QEMU, KVM, and rust-vmm communities,
> >> QEMU will apply for Google Summer of Code 2022
> >> (https://summerofcode.withgoogle.com/) and has been accepted into
> >> Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> >> submit internship project ideas for QEMU, KVM, and rust-vmm!
> >>
> >> If you have experience contributing to QEMU, KVM, or rust-vmm you can
> >> be a mentor. It's a great way to give back and you get to work with
> >> people who are just starting out in open source.
> >>
> >> Please reply to this email by February 21st with your project ideas.
> >
> > I would like to co-mentor one or more projects about adding more
> > statistics to Mark Kanda's newly-born introspectable statistics
> > subsystem in QEMU
> > (https://patchew.org/QEMU/20220215150433.2310711-1-mark.kanda@oracle.co=
m/),
> > for example integrating "info blockstats"; and/or, to add matching
> > functionality to libvirt.
> >
> > However, I will only be available for co-mentoring unfortunately.
>
> I'm happy to offer my helping hand in this. I mean the libvirt part,
> since I am a libvirt developer.
>
> I believe this will be listed in QEMU's ideas list, right?

You're welcome to co-mentor the QEMU project indepently of a separate
libvirt project (if there is one). Your involvement would be great so
you can give input on what APIs libvirt wants.

Stefan
