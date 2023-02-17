Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8079E69B182
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBQQ74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjBQQ7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:59:52 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF5865342
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:59:51 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id h3so1688894ybi.5
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0Opl1wLztqrW5e2VMQoGp+l57IB6F32QmC5KGlWJjQA=;
        b=Id5TXF7Qtt8bc1Lb00xdUVojNssGC9SXkFbo24OTB9y5/roTZuiB1D0Cx7pIMR8Mgn
         Vcpn6Du15hz11q56tE3me6wLthpwXteyRPdytBYE9cqbGHP6B8bALoqo1cMImdCQy862
         F3OLQJnQscDmQT8csL5R6Xue+dNID/dK7IeOL+WtZnLw7CDN8BIwDZqRKkUUnX81i13x
         slx5XYi6Gg0j/jOpF2aiKL8dblTys1LIynf2tNfKwg6jeaqQRDUs71EZmwplOCaQnGuJ
         PrV6VMOQjNjbfbllCX+rdOlRtB9QtetC51Rw6AvPHKxhg3XSL/7RC2mDxqKYgLdC79uu
         imtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Opl1wLztqrW5e2VMQoGp+l57IB6F32QmC5KGlWJjQA=;
        b=g78SIWQV352MCULorRl48bnKE3rkxP/RuCA8Kg6Apdr0CZLU1Wsn/Wfg5LwO5vkaye
         3lL/lu/4HuYJcplcrSqf0B7Fg0JZa6u9cXbZaECZwazS706BV/uvAU8ByPjx8Ugkk/th
         xu17z8JtQ7GpK2pba7S/HNG8GatBWvEhWbHJfKQVW0GiebFi1mmF6jzE0YfB6Df02GxE
         yFCwqJNM+p4kd+d/Bga44KVRiwrzDhJ2AMX+I3tbmjjlte65OvCuPsa4uiwwHWc/vXPy
         5G4kdPJtCi81iimNPiT/hxDEwMzwgoWPMnWqiPR8UVuu83B3Dhm0eag3H8/EL8EU9DNa
         GL+A==
X-Gm-Message-State: AO0yUKWwcQEBfzOFmhS/kPWg3B09fjGvOYCVcGnV6aA14qwbU+o4f68j
        4+ifjIARk/CQcXLDI5cqSWCjC70cEPEaNJ0nOKg=
X-Google-Smtp-Source: AK7set+AUuH84xAU8cUaJzSvpTuZ34zUhuUa7UWUc2P+BXQaNQjz3KL+NK4VXkHwFRgMCV4F3PPT+3plQXzlwZL23jw=
X-Received: by 2002:a5b:1c1:0:b0:95d:85ed:4594 with SMTP id
 f1-20020a5b01c1000000b0095d85ed4594mr705137ybp.513.1676653190596; Fri, 17 Feb
 2023 08:59:50 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
In-Reply-To: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 17 Feb 2023 11:59:38 -0500
Message-ID: <CAJSP0QWv6mBjW8g0Cqp5VP7tGvqQUTYiSPhtRFHyn239JHDLbA@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2023
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>
Cc:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
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
        Vitaly Kuznetsov <vkuznets@redhat.com>, gmaglione@redhat.com
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

On Fri, 27 Jan 2023 at 10:17, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> Please reply to this email by February 6th with your project ideas.

The call for project ideas is now closed. We have enough project ideas
for this internship cycle and I wouldn't want people to spend time on
additional ideas that we're unlikely to have funding for. Thank you
everyone who submitted ideas!

Stefan
