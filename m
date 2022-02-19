Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B057D4BC728
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 10:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241851AbiBSJh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 04:37:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241841AbiBSJh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 04:37:26 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0E054692
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 01:37:07 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v4so10616557pjh.2
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 01:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqehRaZ/IySJbkttcqrJhGWD2un0MeCB0ZrslGhubuQ=;
        b=dGWNHqNAFDDFezo64afskyOkql/znAdfpXmfZZeMpPtNk3TBw0zL3mwzL9KDxBSUHS
         VjxCsGPAplh4HapwGsajIs0LsjEhUvUvGL1YSDMqNopfvTIklH0WLv1DhXYPeQ9gwMF1
         I3d0mLBlZzHc75pt3sb+aL/PpSnZsgbrk9VccmICCIkCTm3qclkc25dC8usSYVooLDFb
         2HCCRyOjCf0pZXo0UBxTlRJ5GSFmqSVpxw1qekMonL+0qYdsTyCMwR3B5jerYkAy8Mps
         PndVXESYDRNNa37RFTz7ORp/84j7Y0RI/UDe8MGgPArxxEhG3aFR5Qn4n+8420HgK0yw
         wb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqehRaZ/IySJbkttcqrJhGWD2un0MeCB0ZrslGhubuQ=;
        b=LDvsoxsikDalMPzmqxu8dFxeR3WgyQ4sFyWBzpE1H46w3Ba5fk/nAUk3S2FJejvvsA
         aKegGRZ+HBmNkdTaA02uGsJsCZvolVC4BLCL2jTJQ+oGCunvrnYkttAdHPhGFoAeZkug
         hvYPhg/VAj8u0y1tiqromtTeZXTJZCcCGYHXjTh6iuRBoHudcJ7rulbSQu5p72ox3/8/
         uODE5ouH2baw3QJ8kt5Cq1h/Re9xVeHXWPx8aQYF2syQBuwbkYT4onSNU/Y8TSgxQOUT
         pwvZrHlUYFzVujrZFleiJkpHTeVKwKfnkpfgwZakKOePTwDfC6mDfgAo23ykyT3egndz
         AOVw==
X-Gm-Message-State: AOAM531Q/laf6hRbAiBQs+YC0Tm3cKAt6cxQ+45buBQ8pI+J1xvJwH1l
        erRwcv1kbwoIxLJiXeEuz/lJf9y3kz15M1e2cRs=
X-Google-Smtp-Source: ABdhPJxY8hPZtV8KkysLrfS5pwQ/SUbtTJicDRvtyWp546oHsqt+zbkkwhqPdvFSb7XfPzwq+r2RXuC9wNpBOt73Mms=
X-Received: by 2002:a17:902:e8c2:b0:14d:bc86:be4d with SMTP id
 v2-20020a170902e8c200b0014dbc86be4dmr11093133plg.106.1645263426545; Sat, 19
 Feb 2022 01:37:06 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
 <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com> <70c04ba7-d617-580d-deaa-97018192e8a6@redhat.com>
In-Reply-To: <70c04ba7-d617-580d-deaa-97018192e8a6@redhat.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Sat, 19 Feb 2022 09:36:55 +0000
Message-ID: <CAJSP0QXUiNLQmTap1EgX-fxc5N1OqpN=PY=6x9JdCGxMaMHk7Q@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>, kvm <kvm@vger.kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        John Snow <jsnow@redhat.com>, Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Stefano Garzarella <sgarzare@redhat.com>
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

On Thu, 17 Feb 2022 at 17:49, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 2/14/22 15:01, Stefan Hajnoczi wrote:
> > Thanks for this idea. As a stretch goal we could add implementing the
> > packed virtqueue layout in Linux vhost, QEMU's libvhost-user, and/or
> > QEMU's virtio qtest code.
>
> Why not have a separate project for packed virtqueue layout?

Sure, but we need mentors and they overlap with the VIRTIO_F_IN_ORDER
project. Does anyone want to mentor a packed virtqueue layout project?

Stefan
