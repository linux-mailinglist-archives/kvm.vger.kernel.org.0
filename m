Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32992103648
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 10:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfKTJAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 04:00:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38384 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbfKTJAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 04:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574240414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=df2jZGkaKYIX8XGP45379iKP8na141nKrPLZMKk0bUg=;
        b=H1Xjbr1+ST8mqdPBZ7xS0FuuCn5JHZSQ2FuYgEJnRqNHdR6ppijrRG8jdRsHKGOzwS49el
        TsJZDzYde6dupkbLSuoFQJnC/V0uhWuMY0DJ8FXF3o3pAcsAUMDjFx5XW7pXV/gUJqOIxh
        MP2OaPwp3bupCfUbUxtwelZyz3jiL0c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-5Er1Jh6hOT-6OxZfAMPo_A-1; Wed, 20 Nov 2019 04:00:13 -0500
Received: by mail-wr1-f69.google.com with SMTP id w9so20831310wrn.9
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 01:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z+y/mrfI8ftCAoV6iK00SrByVRSNZiEo0o81DOjJrmQ=;
        b=nnXW8/eYWTqgXveBFMXet78nZrRBtVXGcTG3pyzvSAd72JSAaOg3X8zluhDPxVO1LJ
         4Xc76FTGW0RHdRZhUa0k/4RN4DlSfp1s7zcNwieapDGhVSYq064BW80mtiaI0i2DjwcW
         u4X9UsSYfDF/MW7Ba+2I6kaosy3FZSsJk1X9PZ48Yz1YESp38adZKqkHFFcVE0w+ApFD
         dexQx8osTz84MMsKrtDPth9YKX2wE6rCVMblWfUlU6pmWSPWlseZtV0bbmQcd8Qe0QQT
         4jIwffxWoIi67HgMJjJudDY9vD+k3KLw2bW88frJYRCWTWcQzOLaluh0NOI30RQLcVPb
         4E3Q==
X-Gm-Message-State: APjAAAWHW8u6EqcJg2Nw3yvK4RrQ+cd9Dne0vyD/SAkI2hfJdESOI3UA
        uGzBzAw11G4wuKlDEeRbhmfAg9a9vHEPf0exl/J7Kfz/6I82+0AQPT8LnRj1eeKQXnUqK3hgpfY
        LKIdtWMHChF9o
X-Received: by 2002:a5d:640b:: with SMTP id z11mr1744249wru.195.1574240412214;
        Wed, 20 Nov 2019 01:00:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqzH0Kdjailo9KhJjoLt6nJgWn1k9d4qaEv02JFRBV4exDlOdZ6AoQZwxtxq6bSHolNraKXzJA==
X-Received: by 2002:a5d:640b:: with SMTP id z11mr1744217wru.195.1574240411959;
        Wed, 20 Nov 2019 01:00:11 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id m16sm5646172wml.47.2019.11.20.01.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 01:00:11 -0800 (PST)
Date:   Wed, 20 Nov 2019 10:00:08 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        decui@microsoft.com, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jhansen@vmware.com
Subject: Re: [PATCH net-next 4/6] vsock: add vsock_loopback transport
Message-ID: <20191120090008.qlfc3lnzwl6yudsf@steredhat>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-5-sgarzare@redhat.com>
 <20191119.171501.666690660172999834.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20191119.171501.666690660172999834.davem@davemloft.net>
X-MC-Unique: 5Er1Jh6hOT-6OxZfAMPo_A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 19, 2019 at 05:15:01PM -0800, David Miller wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Tue, 19 Nov 2019 12:01:19 +0100
>=20
> > +static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
> > +{
> > +=09struct vsock_loopback *vsock;
> > +=09struct virtio_vsock_pkt *pkt, *n;
> > +=09int ret;
> > +=09LIST_HEAD(freeme);
>=20
> Reverse christmas tree ordering of local variables here please.
>=20

Sure, I'll fix in the v2.

Thanks,
Stefano

