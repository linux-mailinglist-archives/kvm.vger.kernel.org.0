Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3004B64BE
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 08:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiBOHuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 02:50:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiBOHuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 02:50:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 177EC8A303
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 23:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644911394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=skGSLOtnoQCHfjZETdhbalWZTJmtFEGpyP+K1bHAZS8=;
        b=HKIvBE4OzPRJ5oPGwlyd1uZBwpjBqN+jqdWWW6uQOn7nUBtXqOBHaGPwhKORl95Fc7zFoP
        cBOKzID1lMQGmf9eYNz0uZV8FvjLgh2+UPvejJ7+a0Df1w5PkP7liK9tsyfa2kuUliJEgD
        Tqt/hnH4mQA/tbCO280RhMTca5d+OO8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-lq8vhpyvMJaqHgwcQ3empw-1; Tue, 15 Feb 2022 02:49:52 -0500
X-MC-Unique: lq8vhpyvMJaqHgwcQ3empw-1
Received: by mail-lf1-f72.google.com with SMTP id f37-20020a0565123b2500b004433d9bb4feso1458239lfv.22
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 23:49:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=skGSLOtnoQCHfjZETdhbalWZTJmtFEGpyP+K1bHAZS8=;
        b=dQmXpInz87toOOFgbj5NVDF+mYhny3wk4GCQo2SVvKtMpM4mGEk/XoXEShdDjYK90f
         FVOx72o3/NW3DbmcPfteI1JdCFjRzWZHPMcBOHx+6hvzkvFmjYzpwRD3jnp6E0uZlPZf
         Jpqvrc37sDFTesufDvRuHQOop2Win4Lttw0Hg5Mwxk5et1VYKZNBg6WGXnwVIRNB5hXf
         bSZ40UUh3lRUk5eesPuM5T9wJACBt9GlWgeEhlNfutFVJYRpX6YQxO0L9tVjt8KAyN72
         pkc5BL+INwO9lQNLFUFCSJfZZ6SZPCy89E1wazRzO+c81V/ECV5RDttDVzxxMFaJd1T6
         wJdA==
X-Gm-Message-State: AOAM533fZnJ48bFgRLGG6LpAx4sbf/TWSv7gcR2zb7ehJsCb5sh+7O5e
        DmjNsU0j297hI5OdjczSXn3LO/lTR1pfjh0sdXGaADvo5gvf2JzqBAvnKhcswWc3iVkjpdboaSO
        DOLot9LcJSBl25wyTM9M9UqMLBHEL
X-Received: by 2002:a05:6512:314d:: with SMTP id s13mr2280823lfi.84.1644911391111;
        Mon, 14 Feb 2022 23:49:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7jdBCFRGtOx3ChomoUjTqjBAlmnC0RLhXqNRSdsZZrU1QoF+2qS6ZJyNW8cOqfDRUBFdq9mmUwa0oMmRJaPM=
X-Received: by 2002:a05:6512:314d:: with SMTP id s13mr2280802lfi.84.1644911390882;
 Mon, 14 Feb 2022 23:49:50 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com> <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com>
In-Reply-To: <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 15 Feb 2022 15:49:39 +0800
Message-ID: <CACGkMEvt66SwZxWhZ72Bv_CL_tykwpL7njZwoddTdVQF7yDfqQ@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, mst <mst@redhat.com>
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

On Mon, Feb 14, 2022 at 10:02 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Mon, 14 Feb 2022 at 07:11, Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Fri, Jan 28, 2022 at 11:47 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> > >
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
> > Implementing the VIRTIO_F_IN_ORDER feature for both Qemu and kernel
> > (vhost/virtio drivers) would be an interesting idea.
> >
> > It satisfies all the points above since it's supported by virtio spec.
> >
> > (Unfortunately, I won't have time in the mentoring)
>
> Thanks for this idea. As a stretch goal we could add implementing the
> packed virtqueue layout in Linux vhost, QEMU's libvhost-user, and/or
> QEMU's virtio qtest code.

Yes, for vhost, last time I remember Michael may want to do that.

Adding Michael for more comments.

Thanks

>
> Stefano: Thank you for volunteering to mentor the project. Please
> write a project description (see template below) and I will add this
> idea:
>
> === TITLE ===
>
>  '''Summary:''' Short description of the project
>
>  Detailed description of the project.
>
>  '''Links:'''
>  * Wiki links to relevant material
>  * External links to mailing lists or web sites
>
>  '''Details:'''
>  * Skill level: beginner or intermediate or advanced
>  * Language: C
>  * Mentor: Email address and IRC nick
>  * Suggested by: Person who suggested the idea
>
> Stefan
>

