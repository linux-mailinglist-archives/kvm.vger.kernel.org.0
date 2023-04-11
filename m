Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4CA6DE536
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 22:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDKUCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 16:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDKUCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 16:02:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4041E4228
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 13:01:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id nh20-20020a17090b365400b0024496d637e1so14498357pjb.5
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681243319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZJZV+00U1PjCKp/KXUNYCO8B2rEbR+LZ2jAdA9mfb4=;
        b=yZ5ZU+U8vx1wvIaqCj8jLt0S3tSKHmP/ShywKOL6jLWJveEWYUCJ3tr8nD95vhYI+x
         QtgEYoA+oXsrvghkf+EJ7EM0yWZvAYtIYXFb0cuBUF5ZhPT+22PBIJTIo/8bdGXPz7TK
         Gl0/M2xMXPbDOjr0CCuQM5AzlyZv6WIxkOIkY1dZNrbQQ30XlesGsnnu9ziclW8mq8K0
         VFziObrwle8/3ZaWiaKGPnlDlFDycDVOXDVG3XLXcXrzhXlLHwVXy9rXMm394usi+vsx
         Di3yAprbFumRoUZVjfKDg0JqPe+wYyJKPrpmZKA3P0oRX70XVIC2wpgpchFldRr5dsdj
         qjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681243319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QZJZV+00U1PjCKp/KXUNYCO8B2rEbR+LZ2jAdA9mfb4=;
        b=p5eMyJfA68eZ6G0LXxMKN9TKG8zOVn8InGfNACD6BQ+IFKWJ1u7oS4RFdUlOPDemaP
         BNJyNxE+kUV5YCtz87xq5RA9hyUhpE4fL4NLvpGDPqI4pwvS/6IIOnqoyYmFsVmH6mUo
         WfVeF/kcfojyUfDyHxPAn++/AV24q5EUYTNydVPsLTiqzT0uc+NOgpmzG+PSVUKHEut3
         BmSkAKFHcr/B4Z0bRIe9mMNxa2cGQeBz5AJz6sPMVGA6RKlfs7PP/aNYJyE//9J0ytT4
         sJgXfTfrjVeDhf5zK3LARLcQjQc/3nSwfeFgS8ZdWJanFO+QrcNi5FUSBR3mRhS5/fDD
         U6UQ==
X-Gm-Message-State: AAQBX9dTah32INyrwhu1EQrjuZRcz+6rzkLufjF442KWMCVclgkjjHBO
        P2MpW0ADi8Cuye/I/VUQpMWUQYkmAXjy1Iidnoos/UVyujzRiBTJvLs=
X-Google-Smtp-Source: AKy350ZB8w/35+QJm1URvnj4NpxgWc5vArTpHhKIzSDpVvNrL4hP5ylw9/fOi2FaaC7LyWMpaxzjApY4fio29V5hgKc=
X-Received: by 2002:a17:902:f301:b0:1a6:6a6b:5191 with SMTP id
 c1-20020a170902f30100b001a66a6b5191mr184197ple.11.1681243318533; Tue, 11 Apr
 2023 13:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <ZBl4592947wC7WKI@suse.de> <bf7f82ab-3cd3-a5f6-74ec-270d3ca6c766@amd.com>
In-Reply-To: <bf7f82ab-3cd3-a5f6-74ec-270d3ca6c766@amd.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Tue, 11 Apr 2023 13:01:46 -0700
Message-ID: <CAAH4kHb9VPF8RvLAyrK6JHNPT4RBp12tPDUTL2v6XrfQqc61jw@mail.gmail.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 12:57=E2=80=AFPM Tom Lendacky <thomas.lendacky@amd.=
com> wrote:
>
> On 3/21/23 04:29, J=C3=B6rg R=C3=B6del wrote:
> > Hi,
> >
> > We are happy to announce that last week our secure VM service module
> > (SVSM) went public on GitHub for everyone to try it out and participate
> > in its further development. It is dual-licensed under the MIT and
> > APACHE-2.0 licenses.
> >
> > The project is written in Rust and can be cloned from:
> >
> >       https://github.com/coconut-svsm/svsm
> >
> > There are also repositories in the github project with the Linux host a=
nd
> > guest, EDK2 and QEMU changes needed to run the SVSM and boot up a full
> > Linux guest.
> >
> > The SVSM repository contains an installation guide in the INSTALL.md
> > file and contributor hints in CONTRIBUTING.md.
> >
> > A blog entry with more details is here:
> >
> >       https://www.suse.com/c/suse-open-sources-secure-vm-service-module=
-for-confidential-computing/
> >
> > We also thank AMD for implementing and providing the necessary changes
> > to Linux and EDK2 to make an SVSM possible.
>
> Just wanted to let everyone know that I'm looking into what we can do to
> move towards a single SVSM project so that resources aren't split between
> the two.
>
> I was hoping to have a comparison, questions and observations between the
> two available by now, however, I'm behind on that... but, I am working on=
 it.
>

This is a happy development. Glad to hear it and thanks for your work,
Tom, J=C3=B6rg, and all collaborators.

> Thanks,
> Tom
>
> >
> > Have a lot of fun!
> >



--=20
-Dionna Glaze, PhD (she/her)
