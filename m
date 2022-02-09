Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B422A4AE8DC
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 06:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiBIFHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 00:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377685AbiBIEcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 23:32:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B60B9C0612B8
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 20:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644380509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3BqN70XFYwy8dmYrTT0pR/AuWTTmgK4Xwa4KvhO/0ZM=;
        b=YynKFFEB2xzTlhHznKtqX8b7+Cx6IyHjQBx19mIhOJcn0evzQUdRth1CbkNZQoisssoOCT
        guRED/q7y+ziZP0JqHiqsf8NQI4EGMSa5xKUVHazkxCkmzj+pxrgUqYr/GEm1ts+mGK6xR
        BZ8PT1FRoCbdbvSsq/yU2j/avL012r0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-m2gbHGmcP5WRFLbx9VfShw-1; Tue, 08 Feb 2022 23:21:48 -0500
X-MC-Unique: m2gbHGmcP5WRFLbx9VfShw-1
Received: by mail-lj1-f200.google.com with SMTP id n9-20020a2e82c9000000b002435af2e8b9so524327ljh.20
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 20:21:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3BqN70XFYwy8dmYrTT0pR/AuWTTmgK4Xwa4KvhO/0ZM=;
        b=3q3vo4M78vj8NMVYJ2AeAXBhSrJaa08SFoMMh9WLV/3z9Ojh3TqXiySeuNpfM3ludr
         Q+jSveCLZiOn0Qej7PnIml4IQ61eNaSH8IKv1ezFslwVmWOqCak1j6qR0psLVdaGU5X6
         CHKzIyiYayUQtszAXG/Oigv9T7Lr4LtTnTsMnsIf4ie4ql0kLboZ5As+zCRs3F+BcEkn
         +/0XKUycnUykPMFyE2y8gHnm3ReJJMZitXZFGMZpsAYJWzhPWDbmuoRCoc1jPP0ymvE6
         9AdM81195hKYgIL4+vmI5SO4u3tDGHTa2ca4k4ivw3G9Cr0aa76/pbXywd3fzdX36ej8
         065g==
X-Gm-Message-State: AOAM533jJbhNAhDhlJ4IIjwqUpu+r/WSQ8Q2RTxalRIsbW6ntBmdxGcT
        q2MpdA7RRhXsTP1CCBb7qlZyVklL1SRpcsGIYubvo5ZFqaWChPr6WT5EIKSSO0hFvNr4HKtFCxf
        2D8JwQV6D/v60xhQfVfH1RGdQjsJO
X-Received: by 2002:a05:6512:39c6:: with SMTP id k6mr310150lfu.199.1644380506944;
        Tue, 08 Feb 2022 20:21:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVYYypj/6GW5UHMyOBXeJC+jbnVDlGLvx86+l1eiL77ZqPBfak0Yk8KnpKpOLeHjk1QP8JpKC1731kUazhSlU=
X-Received: by 2002:a05:6512:39c6:: with SMTP id k6mr310142lfu.199.1644380506777;
 Tue, 08 Feb 2022 20:21:46 -0800 (PST)
MIME-Version: 1.0
References: <CALAgD-5+Ryzmj4iziL4J0yb7ehXZS8geqaj3ZfH462rgCRdxqA@mail.gmail.com>
 <20220208155726-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220208155726-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Feb 2022 12:21:35 +0800
Message-ID: <CACGkMEt6fU0s9wspqChJYiE-HPxXEbzsdKdksL8f0X8NNO-=LQ@mail.gmail.com>
Subject: Re: one question about your patch "vhost: log dirty page correctly"
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xingyu Li <xli399@ucr.edu>, netdev <netdev@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding lists.

On Wed, Feb 9, 2022 at 4:58 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Feb 08, 2022 at 11:37:00AM -0800, Xingyu Li wrote:
> > Hi Jason,
> >
> > Sorry to disturb you. I have a question about your Linux kernel
> > patch-- 1981e4c9a97("vhost: log dirty page correctly"). I noted that the commit
> > message says that the fix tag of this patch is 6b1e6cc7855b ("vhost: new device
> > IOTLB API"). It also says that the bug occured when try to log GIOVA.However,
> > when I look at the the commit diff of the 6b1e6cc7855b, I do not find the
> > related contents to modify the vhost_log_write() or some log-related functions.
> > Can you give me some guidance on this?

So the logic is: 6b1e6cc7855b doesn't touch vhost_log_write() so the
log is wrong since vhost_log_write() is based on GPA. That's why I
wrote 1981e4c9a97 where I translated GIOVA to GPA before doing the
log.

> >
> > --
> > Yours sincerely,
> > Xingyu
>
> Pls CC mailing list on questions. I have a policy against replying
> off list.

Right.

Thanks

>
> Thanks!
>
> --
> MST
>

