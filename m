Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1A76D67CE
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbjDDPqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbjDDPqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:46:42 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99722EC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:46:41 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t10so132287001edd.12
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 08:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680623200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXW7PcHR8jY5rjao2CXqqhAggW80wQf9CATLv2awgpo=;
        b=V5dNrM8dHK3wPLgQ/hko/4XDDZxu6Rmght8bAA/yfiA1aCFjPFZdg4FnIZcejQ5Wvh
         QIfeXkqr0p09Mj1i60uOuMHGPRjzkMiLajoS/956pSJcRN8kHXW3vscrhk6e67sWkTZX
         SXY+WM88N3laXzuyso4ZPwOFuUVrs9PFtKE0/NLbSDdM6P8fLskq43jb9pIZUGaLHFlt
         muu1VhoRZ7myTAEI+tbMMBBtIGj4QxsLoiR6h1h05VhzRdAMbOV1eWYbqpMTdEgQz8WK
         MbZl37LH8w1dfidTYfeXbEQcdT8Ros+pZM+YSBbUaGiVZHHixmRjZYZ8nV9wZh2FmDG+
         Onbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680623200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HXW7PcHR8jY5rjao2CXqqhAggW80wQf9CATLv2awgpo=;
        b=Wr5ZDkJA2lO8c0LfU3wpwyUNvFtLmNl7QSgA2x3E2QGlTeRyH07lUV7dKo3O/Mo1Du
         DLrgAj1JHgKnZMphIG05mj5tf1DkiXkxD4XcuuPOdpvZSS0F0+9xVqDI9ZHRx/oSw9R0
         S2ttA2mEMgY3oqH8fxR+/YTtZ+QD6ydbG/+UFsxPehXtvXqHcGzVBdDMPzHnS6VlQEc7
         8kLG/7ML5o9W+kUX4CrVeomua+cvsKieOAw2Yne0UfavyaUHJrnV2bFlKC+72e6ONPAp
         kIezYp8C5varF/cntByx+qf12OauKPH7SYHoTGP1m7UQyBJyYu9T4/jnbydJ9DBjedyl
         p01w==
X-Gm-Message-State: AAQBX9doa1eNk/3ON7ltgC0MTNgpo3W0M93taW9MbMXMTWwRk2nc8Yff
        f2IJkCiAn4ujRS+AVFj9zf7FnlUW1oJT+xqJDBTfJE43uSc4jlpLK8s=
X-Google-Smtp-Source: AKy350bgFXwfBN/tb0T+h0XQFwa57ZRcGIFEiJh0i4TiJV2bhRqO8lgSh4ru8ADFtK2rF+lmArBusdGs/lP8H7aIZbE=
X-Received: by 2002:a50:a6d1:0:b0:4fb:4a9f:eb95 with SMTP id
 f17-20020a50a6d1000000b004fb4a9feb95mr1724260edc.2.1680623199972; Tue, 04 Apr
 2023 08:46:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230327144553.4315-1-faithilikerun@gmail.com>
 <20230329005755-mutt-send-email-mst@kernel.org> <CAJSP0QW1FFYYMbwSdG94SvotMe_ER_4Dxe5e+2FAcQMWaJ3ucA@mail.gmail.com>
In-Reply-To: <CAJSP0QW1FFYYMbwSdG94SvotMe_ER_4Dxe5e+2FAcQMWaJ3ucA@mail.gmail.com>
From:   Sam Li <faithilikerun@gmail.com>
Date:   Tue, 4 Apr 2023 23:46:13 +0800
Message-ID: <CAAAx-8J72fiVpOqeK71t8uNiyJLR2DowzGouk_H3oFRF_czc+w@mail.gmail.com>
Subject: Re: [PATCH v9 0/5] Add zoned storage emulation to virtio-blk driver
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        hare@suse.de, Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stefan Hajnoczi <stefanha@gmail.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=883=E6=
=97=A5=E5=91=A8=E4=B8=80 20:18=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, 29 Mar 2023 at 01:01, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Mar 27, 2023 at 10:45:48PM +0800, Sam Li wrote:
> >
> > virtio bits look ok.
> >
> > Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > merge through block layer tree I'm guessing?
>
> Sounds good. Thank you!

Hi Stefan,

I've sent the v8 zone append write to the list where I move the wps
field to BlockDriverState. It will make a small change the emulation
code, which is in hw/block/virtio-blk.c of [2/5] virtio-blk: add zoned
storage emulation for zoned devices:
- if (BDRV_ZT_IS_CONV(bs->bl.wps->wp[index])) {
+ if (BDRV_ZT_IS_CONV(bs->wps->wp[index])) {

Please let me know if you prefer a new version or not.

Thanks,
Sam
