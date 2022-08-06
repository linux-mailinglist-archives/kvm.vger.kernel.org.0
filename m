Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC15658B517
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 12:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiHFKwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 06:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHFKwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 06:52:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0C23102E
        for <kvm@vger.kernel.org>; Sat,  6 Aug 2022 03:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659783149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FVB8GBi8CPuWQGQ31lEj4KvoXOjnJ6pObTR9a5Q9woI=;
        b=FKrJPpsT/US8AN8a9tHwvlMfUblbOfyZe74e0m/qxiqaNUleo4LqUuPEPw9AzZ2Ex9iBT/
        GLGqtWE0c347qza0HDzxX9xO8vWvwIN9tiIds9+CefnpLV4AQUL9BhpSiadj2jqN3HluII
        Cb+w6Ey9zPIJKLUW3MGwMKQ+bCznZgo=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-qPBpslR_PwCzS2mBJfF-cg-1; Sat, 06 Aug 2022 06:52:28 -0400
X-MC-Unique: qPBpslR_PwCzS2mBJfF-cg-1
Received: by mail-lj1-f197.google.com with SMTP id z7-20020a2ebe07000000b0025e5c7d6a2eso1454244ljq.20
        for <kvm@vger.kernel.org>; Sat, 06 Aug 2022 03:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=FVB8GBi8CPuWQGQ31lEj4KvoXOjnJ6pObTR9a5Q9woI=;
        b=YvMhxEztLCJAKSeEX6vraZpJWrxmrnWse7EK092VRy5Mb6cyB/p5IGiQMoNoo6HHwu
         yko3rGY4X0IZuPrBlXYARZYYDQ0o8iiZWKAHp2eFeGw2OEEUB9ekY4ngkMHke2vEcBBi
         5YJIWiDF3UspJ0OF3EO1byEwOu7qRLHyT++L9yMk3K424/OSsYAA0mHZAOYOQtatxx3v
         P/cEC6BqusoRvcNAPc36/fBJbEfznqkzLpEU1PPXbXLS2SMNG5l1s8dYWVkXGaNJQNwK
         JAtWoCMk7zNJ4TX2d9ANuugRva3L4+YpYBC/5qU+NSJJFcdmQifHwFi+56m6WXe3Mm0w
         qQQQ==
X-Gm-Message-State: ACgBeo1I/W3oWApNMDDCdF4cmjY8NYxwFY+S9+9HGvlddlta6ZSDAxCl
        Jg1Ghi6hn+HKHM1ckM/7XTisfmRuu3Zw/bDDrwB9yW+GarqC3fY2xohokR6vMZX21hyU7NLFMDq
        0ZZud3dT8QkdrUtuFzpY2GoCaXWHm
X-Received: by 2002:a2e:9d59:0:b0:25e:1eda:86f6 with SMTP id y25-20020a2e9d59000000b0025e1eda86f6mr3321010ljj.315.1659783146755;
        Sat, 06 Aug 2022 03:52:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4NuPHgYr/hElf345kksAZ+8ayrELU22TdJcimjfjHpgr+lvqhmRxM5dU49D249wYp3EZOGQgnnZs59WG6aaG0=
X-Received: by 2002:a2e:9d59:0:b0:25e:1eda:86f6 with SMTP id
 y25-20020a2e9d59000000b0025e1eda86f6mr3321001ljj.315.1659783146571; Sat, 06
 Aug 2022 03:52:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220805181105.GA29848@willie-the-truck> <20220806074828.zwzgn5gj47gjx5og@sgarzare-redhat>
 <20220806094239.GA30268@willie-the-truck>
In-Reply-To: <20220806094239.GA30268@willie-the-truck>
From:   Stefan Hajnoczi <shajnocz@redhat.com>
Date:   Sat, 6 Aug 2022 06:52:15 -0400
Message-ID: <CAD60JZMbbkwFHqCm_iCrOrKgRLBUMkDQfuJ=Q1T-sZt59eTBrw@mail.gmail.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
To:     Will Deacon <will@kernel.org>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, mst@redhat.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        torvalds@linux-foundation.org, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 6, 2022 at 5:50 AM Will Deacon <will@kernel.org> wrote:
> On Sat, Aug 06, 2022 at 09:48:28AM +0200, Stefano Garzarella wrote:
> > On Fri, Aug 05, 2022 at 07:11:06PM +0100, Will Deacon wrote:
> > If the VMM implements the translation feature, it is right in my opinion
> > that it does not enable the feature for the vhost device. Otherwise, if it
> > wants the vhost device to do the translation, enable the feature and send
> > the IOTLB messages to set the translation.
> >
> > QEMU for example masks features when not required or supported.
> > crosvm should negotiate only the features it supports.
> >
> > @Michael and @Jason can correct me, but if a vhost device negotiates
> > VIRTIO_F_ACCESS_PLATFORM, then it expects the VMM to send IOTLB messages to
> > set the translation.
>
> As above, the issue is that vhost now unconditionally advertises this in
> VHOST_GET_FEATURES and so a VMM with no knowledge of IOTLB can end up
> enabling it by accident.

Unconditionally exposing all vhost feature bits to the guest is
incorrect. The emulator must filter out only the feature bits that it
supports.

For example, see QEMU's vhost-net device's vhost feature bit allowlist:
https://gitlab.com/qemu-project/qemu/-/blob/master/hw/net/vhost_net.c#L40

The reason why the emulator (crosvm/QEMU/etc) must filter out feature
bits is that vhost devices are full VIRTIO devices. They are a subset
of a VIRTIO device and the emulator is responsible for the rest of the
device. Some features will require both vhost and emulator support.
Therefore it is incorrect to expect the device to work correctly if
the vhost feature bits are passed through to the guest.

Stefan

