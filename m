Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DEC69B16A
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjBQQxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjBQQxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:53:17 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2156B38E8D
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:53:16 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-53657970423so17784877b3.3
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z/hRZYR3fVpHyYpO+oH5zoICQrmOs+J1H6tsMPelw4A=;
        b=lhjA8MbStWGfo26CglkUGgucX3s1xSLnittXgq74TCMNsEAUEHoGmHDakQZiT+Zeb+
         cxYZX4Z4DSyC8QxG2FKstkLr6zxMTgZE2qCx+hKnPu93Mdrk9QVrPAlIUMaGmjsOobPT
         xeMQlcciVkT8v7vNAomlNUQ9xwNWZoz+3q0cljl0yrMWslvurXST8P03gZD/9cs5tn3/
         W//CMRqz136aMbLKctrEdYn0YH7FnC5Aa/BS9NEWvlxqDBx5y5PuHQ/M0MCMpXWkR94Q
         ndELdimx/4EW/dmspjd2rXUu/8J3O9Bm3uwQHCEGBB6JuIzFb2cTkIDI2vgl1xY6sZCm
         8JKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z/hRZYR3fVpHyYpO+oH5zoICQrmOs+J1H6tsMPelw4A=;
        b=Ydokgc/Q7OfqqWMutLevxe6qc6cG+29ZNnaaacW4SObNs+7uuIslRILA66x6/cGkFQ
         HEDPh3FVJusCDZWZQAnF6U9WsUQXpWJO95yiuStFEd603808ByQJSpktAPgvxQ+igu+N
         1nRm2F4C8JJmclKTyDBKPrprgeZtZnrGOY0L409SdslCjUoCB6RvCkAjrATalsNQWvna
         q9Kp13Ys95bA0pyYaXdv7NrDPa9DOnWwwD8Mt5DGnJ5BMntsHddo6hWy4aHkWmV/HPv/
         f8iqf2f7G6/RfES2v+HrhaDvmT3Uml15v3cJm06vdAVx1JVXfYHq3TkVi5/Q2OFMOobn
         vZxg==
X-Gm-Message-State: AO0yUKU1Bm4tuBYCuJEMutGr1+JlFV2L9rtfHDPwyjhxFQjGuefDAsue
        S/dUXHUSnKhgvQ7KQ3YUmTq+1NLdyTHV6HXo75Y=
X-Google-Smtp-Source: AK7set8nB6PKjkOu4hIviFl1ja2lfs+XKEzHTQQnjzxsICmvHJvlSkKhj56yCtciQKCE6lBz5tmGVYmYAJqIxlwq1d4=
X-Received: by 2002:a81:fd12:0:b0:4f0:64a3:725a with SMTP id
 g18-20020a81fd12000000b004f064a3725amr1275366ywn.229.1676652795340; Fri, 17
 Feb 2023 08:53:15 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
 <20230217162334.b33myqqfzz33634b@sgarzare-redhat>
In-Reply-To: <20230217162334.b33myqqfzz33634b@sgarzare-redhat>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 17 Feb 2023 11:53:03 -0500
Message-ID: <CAJSP0QXDD5uyY5Neccf4WmGyuXwHuefwbToBdZDwegV2XHMnHA@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2023
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
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

On Fri, 17 Feb 2023 at 11:23, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> Hi Stefan,
>
> On Fri, Jan 27, 2023 at 10:17:40AM -0500, Stefan Hajnoczi wrote:
> >Dear QEMU, KVM, and rust-vmm communities,
> >QEMU will apply for Google Summer of Code 2023
> >(https://summerofcode.withgoogle.com/) and has been accepted into
> >Outreachy May 2023 (https://www.outreachy.org/). You can now
> >submit internship project ideas for QEMU, KVM, and rust-vmm!
> >
> >Please reply to this email by February 6th with your project ideas.
>
> sorry for being late, if there is still time I would like to propose the
> following project.
>
> Please, let me know if I should add it to the wiki page.

Hi Stefano,
I have added it to the wiki page:
https://wiki.qemu.org/Internships/ProjectIdeas/VsockSiblingCommunication

I noticed that the project idea describes in words but never gives
concrete details about what sibling VM communication is and how it
should work. For someone who has never heard of AF_VSOCK or know how
addressing works, I think it would help to have more detail: does the
vhost-user-vsock program need new command-line arguments that define
sibling VMs, does a { .svm_cid = 2, .svm_port = 1234 } address usually
talk to a guest but the TO_HOST flag changes the meaning and you wish
to exploit that, etc? I'm not suggesting making the description much
longer, but instead tweaking it with more concrete details/keywords so
someone can research the idea and understand what the tasks will be.

Stefan
