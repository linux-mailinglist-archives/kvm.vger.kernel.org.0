Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B954B5298
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354825AbiBNOCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:02:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245298AbiBNOCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:02:13 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83809D
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 06:02:04 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c4so8034668pfl.7
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 06:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2xzHEJ4t1jVAMUwW/BHxKnQJ/o9l34zpVpVLqeAfwL4=;
        b=X9mazUBFcIGPS9C2DXn76IpKO4Q7VChw/khLO4V0bpooV1NTqqdD/8yxMjnWaJbA55
         DDhgriINmV/GnIegmbQK4+IHhU0BSkSNewCiI+EqHRlG4C5aY3wFcwXkvL4qZJwKTpmI
         AZ9ZdJU94k/qg/lGrTh8OD4Td78t0R7ysEQafMrKGvyeAMOJxcZKTaZrii7rzOwPkfY8
         f8ER9+WhczYIJzIkLDpHl84PRoVLc/JXeMbuIpIpBG3Gytlc5AdlxU8quPyKG24y+3g+
         tpWzsdNkv3O2E45KfjtfSRBnvrmx981PQXzz5KRegWaWTuKEbwl0oBaicQtoWLLz+LA0
         dMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2xzHEJ4t1jVAMUwW/BHxKnQJ/o9l34zpVpVLqeAfwL4=;
        b=3DkQQnPfZKoBTsQhb5Pm2vqD8VgkMn6+H0wlO7L2mkygpPY5JTqY/ho41x2CUvf5/Q
         nE59T9u3vRjqDkZD1iwXwwu8usZDk6NDVRVPM5VXjwdzYNmte81bCNFHfUXgnXnt8VhP
         7alinz7QgHunOkjrpwJd5+fUiQJoOZLeR6oDynUQjQFq5n+DyQTycE2zjp88IJJTkfUu
         VoQBjhZOqWADvOsYt08td883xdY8zotTmIIRUMI0Yzlw3TV/GQ0c1HhO82HnoatQuIrm
         go+V5R96NmfSbBBVqUJa13Btfe2qj2blvv+2Y4lJOzSy0KGpTT0RQNiAeNnKcJoQrf94
         UJJg==
X-Gm-Message-State: AOAM531oYF2E5xAWD73HLJNFXnisM2vxZF/CcDNthldCYtt3ZAo5CRQV
        tEQxKGwYfnXB7j9qvaHAi6Tp4tsCuVPGJCkz3dg=
X-Google-Smtp-Source: ABdhPJw9F+NSOYskhPxSW7TGCcK6ZoAr0uHG5Irjp6NTYDuNbJYgzsRxlDVVmJkEFtX5K3JMKVSiFl142ftptwNb04E=
X-Received: by 2002:a05:6a00:16d3:: with SMTP id l19mr14341573pfc.7.1644847324177;
 Mon, 14 Feb 2022 06:02:04 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
In-Reply-To: <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 14 Feb 2022 14:01:52 +0000
Message-ID: <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Jason Wang <jasowang@redhat.com>
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
        Hanna Reitz <hreitz@redhat.com>
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

On Mon, 14 Feb 2022 at 07:11, Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, Jan 28, 2022 at 11:47 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >
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
> Implementing the VIRTIO_F_IN_ORDER feature for both Qemu and kernel
> (vhost/virtio drivers) would be an interesting idea.
>
> It satisfies all the points above since it's supported by virtio spec.
>
> (Unfortunately, I won't have time in the mentoring)

Thanks for this idea. As a stretch goal we could add implementing the
packed virtqueue layout in Linux vhost, QEMU's libvhost-user, and/or
QEMU's virtio qtest code.

Stefano: Thank you for volunteering to mentor the project. Please
write a project description (see template below) and I will add this
idea:

=== TITLE ===

 '''Summary:''' Short description of the project

 Detailed description of the project.

 '''Links:'''
 * Wiki links to relevant material
 * External links to mailing lists or web sites

 '''Details:'''
 * Skill level: beginner or intermediate or advanced
 * Language: C
 * Mentor: Email address and IRC nick
 * Suggested by: Person who suggested the idea

Stefan
