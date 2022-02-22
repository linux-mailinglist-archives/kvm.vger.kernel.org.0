Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EE54BFBDD
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiBVPER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiBVPEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:04:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D198910EC64
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:03:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E9D6152E
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 15:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE1CC340E8;
        Tue, 22 Feb 2022 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645542218;
        bh=sF29agGyHsX8Udu48FPCpvs/QyXfpzPgjgx5kraSddQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f3dsrr0hoHdYTBf6UbJFOKQ+S+xQzLXMxVRXUzG1yPzzaz8CIqigtGy7weXYheNW+
         ha4/yrxPLMPW5w0NsBZ66wlB5D9/zq7n+hKDbBmT+HudU2/6lxUryeSUbFuB9p4T8D
         3euJoh+8xmA7a102HjWhUks7/FPGlzMArzkyTIPJFd5e4ha05TcBRKOSHje+57a1Be
         aaGXMV5b9+UcoVPx5Xq+3tySqxTuEofCjivfWck2TwmmjtLF/ltpRH8EqmI9cKCbpu
         y9RGo2LpA6XLf3XyhEkS3VK3fjDIh07KqFwThMwLoWoIcnziACpri9Ar450kvLj5Lv
         hqJtwdE2TGvZQ==
Date:   Tue, 22 Feb 2022 07:03:35 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Klaus Jensen <its@irrelevant.dk>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Message-ID: <20220222150335.GA1497257@dhcp-10-100-145-180.wdc.com>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <YhMtxWcFMjdQTioe@apples>
 <CAJSP0QVNRYTOGDsjCJJLOT=7yo1EB6D9LBwgQ4-CE539HdgHNQ@mail.gmail.com>
 <YhN+5wz3MXVm3vXU@apples>
 <CAJSP0QXz6kuwx6mycYz_xzxiVjdVR_AqHnpygwV4Ht-7B9pYmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QXz6kuwx6mycYz_xzxiVjdVR_AqHnpygwV4Ht-7B9pYmw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 09:48:06AM +0000, Stefan Hajnoczi wrote:
> On Mon, 21 Feb 2022 at 12:00, Klaus Jensen <its@irrelevant.dk> wrote:
> >
> > Yes, I'll go ahead as mentor for this.
> >
> > @Keith, if you want to join in, let us know :)

Thank you for setting this up, I would be happy assist with the cause!

> > Suggested updated summary:
> >
> > QEMU's NVMe emulation uses the traditional trap-and-emulation method to
> > emulate I/Os, thus the performance suffers due to frequent VM-exits.
> > Version 1.3 of the NVMe specification defines a new feature to update
> > doorbell registers using a Shadow Doorbell Buffer. This can be utilized
> > to enhance performance of emulated controllers by reducing the number of
> > Submission Queue Tail Doorbell writes.
> >
> > Further more, it is possible to run emulation in a dedicated thread
> > called an IOThread. Emulating NVMe in a separate thread allows the vcpu
> > thread to continue execution and results in better performance.
> >
> > Finally, it is possible for the emulation code to watch for changes to
> > the queue memory instead of waiting for doorbell writes. This technique
> > is called polling and reduces notification latency at the expense of an
> > another thread consuming CPU to detect queue activity.
> >
> > The goal of this project is to add implement these optimizations so
> > QEMU's NVMe emulation performance becomes comparable to virtio-blk
> > performance.
> >
> > Tasks include:
> >
> >     Add Shadow Doorbell Buffer support to reduce doorbell writes
> >     Add Submission Queue polling
> >     Add IOThread support so emulation can run in a dedicated thread
> >
> > Maybe add a link to this previous discussion as well:
> >
> > https://lore.kernel.org/qemu-devel/1447825624-17011-1-git-send-email-mlin@kernel.org/T/#u
> 
> Great, I have added the project idea. I left in the sq doorbell
> ioeventfd task but moved it after the Shadow Doorbell Buffer support
> task and made it clear that the ioeventfd can only be used when the
> Shadow Doorbell Buffer is enabled:
> https://wiki.qemu.org/Google_Summer_of_Code_2022#NVMe_Emulation_Performance_Optimization

Looks great, this seems like a very useful addition to have. I like that
the feature can be broken down into two parts. Hopefully that makes it
more approachable.
