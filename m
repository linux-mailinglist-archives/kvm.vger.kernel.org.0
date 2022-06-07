Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CCA5400BB
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 16:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244098AbiFGOIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 10:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239509AbiFGOI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 10:08:29 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2AEB19
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 07:08:28 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-fe023ab520so66316fac.10
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 07:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=moaYlNQasBh1GKoo2CWbjTbE/4FE4XKn+rUyoVcj728=;
        b=X/KPnKQJaNBmmk4NB+zRl/elG70ffbZEUBBkRfkqFPNDiIUulVhu3z8E6s/SgawEqr
         9jU4An5o1zknYVZ0bdZqRKCdC7M+7PchBxMKesJ45IzJBhJKhBNgwh1NahYbkzfcsmdx
         K5OpLdkN67SkyJxk3dCnEzzM+b4Kb/tFCPEWQS4J7Rop2m/shBN38ohZ5zwFnmHD21Ad
         JKNM0PKRcVwj95c0cwkXRtD8LvKRXkc3p6VKAomnK4gK+XnhUkqR4cB5c6DzlJC9AwXc
         2n7jfNs+FsF4+gi4Uq4Lmo9wJ9QPXP5Kp0SfgJSry956Ea2SYjHl6EZBM4oXv1zfRgDz
         n8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=moaYlNQasBh1GKoo2CWbjTbE/4FE4XKn+rUyoVcj728=;
        b=ggDMKQ5LzmO9c16DdDgbw2UHcsvEwtlFncsIrmqCFMUcL7IuBGwYf+qbYkCjzLnrZO
         P0dhVeOskw7o06Sf5ccqBovpxwvgiN2Ic+mev1m7j8JFzgftHqxF3E+CFgod5pPbG6uN
         wHGETVSC0hwx3MLnzOZj1SF2P3W0aAxL/LgeWKNcGtsTDHW9e73DksCxwoH0tBtSYjrA
         NWAmeoq9Qrz3ew9Bg3BGewYImf9cDfY6ymbevfju0xT+1X2yvXURkZ9ZGhThVVMqfdmV
         X32QbZqUO2k1Twj0X4Ole9L1puXlTYVSQkOyAOUeARU1X+dVejquwdoeYBDUN76WdEVr
         l8zQ==
X-Gm-Message-State: AOAM531ss3kSyWUdM5SodprUsRjsAVnCPraooe2QHh870hQEhC6i28pC
        zXWDw4WU8bPrccMwxAv1+gLM2ez+dxD2kIdNebDj2SoL
X-Google-Smtp-Source: ABdhPJxZabN7AQlVFnyaPhTkuofk5LL56OfplxYUR4YEmaUsk4u2/0bgD7xTIBE4AjmV/IS3KQehRShqjpb1XiNiVgc=
X-Received: by 2002:a05:6870:a792:b0:f3:1eca:5ba6 with SMTP id
 x18-20020a056870a79200b000f31eca5ba6mr15652140oao.212.1654610907520; Tue, 07
 Jun 2022 07:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <Yp4V61lfTTN3QsT4@stefanha-x1.localdomain> <20220607132625.GA181696@heatpiped>
In-Reply-To: <20220607132625.GA181696@heatpiped>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 7 Jun 2022 15:08:15 +0100
Message-ID: <CAJSP0QWeiudRsLNDsTX3z6Mvua_kEov2sfTfDUvhauknZCvL_w@mail.gmail.com>
Subject: Re: ioregionfd with io_uring IORING_OP_URING_CMD
To:     Elena <elena.ufimtseva@oracle.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Jag Raman <jag.raman@oracle.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        john.levon@nutanix.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
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

On Tue, 7 Jun 2022 at 14:32, Elena <elena.ufimtseva@oracle.com> wrote:
> On Mon, Jun 06, 2022 at 03:57:47PM +0100, Stefan Hajnoczi wrote:
> > The downside is it requires more code than general purpose I/O. In
> > addition to ->uring_cmd(), it's also worth implementing struct
> > file_operations read/write/poll so traditional file I/O syscalls work
> > for simple applications that don't want to use io_uring.
> >
> > It's possible to add ->uring_cmd() later but as a userspace developer I
> > would prefer the ->uring_cmd() approach, so I'm not sure it's worth
> > committing to the existing userspace-provided file approach?
>
> Makes total sense. I am going to start working on this and will
> come back with more questions.

Good to hear!

Userspace needs a way to create these fds. I think a new
ioctl(KVM_CREATE_IOREGIONFD) is needed. Then the fd can be passed back
to KVM_SET_IOREGION.

Stefan
