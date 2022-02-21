Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3276A4BE92C
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353059AbiBUKOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 05:14:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353171AbiBUKOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 05:14:12 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DEC2A26F
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 01:34:29 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t4-20020a17090a3b4400b001bc40b548f9so1816892pjf.0
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 01:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+z38o2AuyC9uCa7uvA5CctNElBqiXVLTZOkjYvSbv/I=;
        b=Bn0csyyCp38/o3NTZBO1aDJKbbl+x1rIO08ZpKDEuO2Pt/MVc/DVtm4TSwtGEJe52L
         hy6rtuQaqte/m91K3UNT6B/jjq3h+mxKUCo5V7jpDpYxAnOi7TnXtWPgTUAAOC8dO9JX
         mhPmXLb5GYouHfAMffSido1cJuq9csxZ2qBmTgF5GmJ9ONJJX+cKiAjLw9NdAeSPRjpn
         +Rkcf/SbktkbKx2XtYLbm7gFP3F7OlFCfQIyaljx70HGdGPutBp3qxzCPSGsskls0ES5
         x1uAWDu02ol4Pc2u/FiWTLOkJ5t/PJHcm/Pf8d28OVVyvTa75iB3VCQZll9xr6VVd0Wp
         If+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+z38o2AuyC9uCa7uvA5CctNElBqiXVLTZOkjYvSbv/I=;
        b=Fo6APVOAJZntzLQo8uXC7yu34STG8tGSlKd76BS7+PaA/2MQmph/AiNIDwb58n5XaX
         nRdEoxNJK7ymsZEbHpHamGB/Yf5RdHqI6zHW7vHPLYo61gCPRyIKpLRY3yEG5X9Mg4bc
         rxcN0HFWfpwBStZBUghc+sRMtlHHixtKF59l/nwIDwK6mFKLOGmwleTxIAYpWHaHv5j2
         WUrDXzg3l+DEtuMpGhJ5iibSpTiw3JBIsD5E6T7r6nvwjm72duiXQzDYbimP5PWzeS/I
         If4MirlXuLEXN+JONf/CH3POvkt4+S86ayueaDEz7Qsa+8vfisHbPKJgXbCn4GaZYdl5
         MAvg==
X-Gm-Message-State: AOAM5314DnV5fhxrzm4xYVjiXA0HYYeoJQPONfM8v9Rh6uB133jn+By9
        pRn4la8RcFPAl0uTUbZprtrtdwMeCUZEqOerirc=
X-Google-Smtp-Source: ABdhPJw9Suoh59SvPz8JFSzK3/5kKtIrydHWVvABx9Rho58UFlL0RMn13nid4jNojkMDuUP4w5wHPJ2DhvxUVUp5Kxk=
X-Received: by 2002:a17:902:bc82:b0:14f:2b9c:4aa with SMTP id
 bb2-20020a170902bc8200b0014f2b9c04aamr17880462plb.145.1645436068677; Mon, 21
 Feb 2022 01:34:28 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <20220218210323.hw2kkid25l7jczjo@mozz.bu.edu>
In-Reply-To: <20220218210323.hw2kkid25l7jczjo@mozz.bu.edu>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 21 Feb 2022 09:34:17 +0000
Message-ID: <CAJSP0QXxJhxc6gr=DnPGomL+z+fcTfpUcGSDRzXt9ivP86qU+g@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Alexander Bulekov <alxndr@bu.edu>
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
        Stefano Garzarella <sgarzare@redhat.com>, bdas@redhat.com,
        Darren Kenny <darren.kenny@oracle.com>
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

On Fri, 18 Feb 2022 at 21:05, Alexander Bulekov <alxndr@bu.edu> wrote:
>
> On 220128 1547, Stefan Hajnoczi wrote:
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
> Here are two fuzzing-related ideas:

Hi Alex,
I have added both ideas to the wiki. I tried to edit them, including
adding specific goals for the intern to complete during the summer.
Please take a look at then and feel free to edit!

> Summary: Implement rapid guest-initiated snapshot/restore functionality (for
> Fuzzing).

https://wiki.qemu.org/Google_Summer_of_Code_2022#Implement_a_snapshot_fuzzing_device

> Summary: Implement a coverage-guided fuzzer for QEMU images

https://wiki.qemu.org/Google_Summer_of_Code_2022#Coverage-guided_disk_image_fuzzing

Stefan
