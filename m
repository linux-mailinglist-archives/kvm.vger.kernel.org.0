Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0766BDFBE
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 04:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCQDpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 23:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjCQDpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 23:45:10 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D04166C1
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 20:45:03 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so15491086ede.8
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 20:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679024702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=42zKkr+jA/SYJcRCtFD2SMkXv6iiKp0lbJVL6b4yzcE=;
        b=myFwG+EPkwUaupESYhHdlLobJ9eBp8lkEQLGWPUnCayOFy3xbG9IMPRtXmlF2qlZeK
         ecaq5CU4Za7tEfMknKixHAbvPBnHuQgRJCYmWwl59r5WurE6rQwzEUHVUKmdLIBs4GGu
         nOoHvidGAdpH3+6EZdvuC1Yx6Tagr6w0CuGFM7lIVFvUq7So3xwwKkAP8ggCCidjJRg4
         J3iru6KOVSm0q3tLw8gPTNUdA7NSv27zPG6/Y/7ge5u2R/S2aZ6MotLK6e3DHFvm4skd
         vRcvIG290T1xjZsgYvAk+TjAvSDpnxNgDFhKLN98YHx3E2cIv1+AD8LZkiXPzQJzObuF
         6RpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679024702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=42zKkr+jA/SYJcRCtFD2SMkXv6iiKp0lbJVL6b4yzcE=;
        b=2I//+sgxKnLZCn6k91T4p53KyBN4BogBaWuyk9RupGc92yocN5Utb96tHJQfkY1aRi
         O5Vw4pgqyh4/fdrqI7BkZVgiJSE4swWGCq1J4wI7FZPZKB+253E+G8zVMcF+oSKSXN02
         4eovEQJUMPXFQtGK4vpA0PGaPatFw/Ica3hZCfOlZjXNBX4e3Dd4gDjgrsgsRvCz6hyr
         Co+BTnCiqwkR1F50FfP1uRAJX7YZd0AoXKTLI9XOirrTlM/PF1dhEycLPMnpVe9tq+x2
         4whq2f6ixJH7bPkqTRq5JX+AudtRWTkaKe1fgkRnGkHacjwY5APqLJfP37Vp3a4CEzPO
         MI/w==
X-Gm-Message-State: AO0yUKVRwuusAIeVtGgnZEQQS3ZasdhXDbkFqKLtpuBIjc6aSWPaOXy6
        SgKXaFosLLbB0oYovjCtDqnLs8KWEQbIVgM2Ycs=
X-Google-Smtp-Source: AK7set8FrwCReQDzvIYMK9q/ud8T/7M7QBhDfAfK4PGkQ6mlVXikgE6AhYGJNnPgPuOm1pjyMBuyumXv19+kfwJAqSI=
X-Received: by 2002:a17:906:1f53:b0:879:5db8:8bb2 with SMTP id
 d19-20020a1709061f5300b008795db88bb2mr5789351ejk.7.1679024701684; Thu, 16 Mar
 2023 20:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230310105431.64271-1-faithilikerun@gmail.com> <20230316192423.GG63600@fedora>
In-Reply-To: <20230316192423.GG63600@fedora>
From:   Sam Li <faithilikerun@gmail.com>
Date:   Fri, 17 Mar 2023 11:44:35 +0800
Message-ID: <CAAAx-8JXJSdBYawBw+rXsrZxmBZHc0giaU3JSyNuafn+OToUDw@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] Add zoned storage emulation to virtio-blk driver
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     qemu-devel@nongnu.org, damien.lemoal@opensource.wdc.com,
        Hanna Reitz <hreitz@redhat.com>, hare@suse.de,
        qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dmitry.fomichev@wdc.com,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stefan Hajnoczi <stefanha@redhat.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8817=E6=
=97=A5=E5=91=A8=E4=BA=94 03:46=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Mar 10, 2023 at 06:54:27PM +0800, Sam Li wrote:
> > This patch adds zoned storage emulation to the virtio-blk driver.
> >
> > The patch implements the virtio-blk ZBD support standardization that is
> > recently accepted by virtio-spec. The link to related commit is at
> >
> > https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090=
ad15db65af8d7d981
> >
> > The Linux zoned device code that implemented by Dmitry Fomichev has bee=
n
> > released at the latest Linux version v6.3-rc1.
> >
> > Aside: adding zoned=3Don alike options to virtio-blk device will be
> > considered as following-ups in future.
> >
> > v6:
> > - update headers to v6.3-rc1
>
> Hi Sam,
> I had some minor comments but overall this looks good. Looking forward
> to merging it soon!

That's great to hear. I'll address them in the next revision. Please
let me know if any further issues arise.

Thanks,
Sam
