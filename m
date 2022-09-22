Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E715E6C03
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiIVTuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiIVTuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:50:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB6F7CAB3
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663876202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZXRmhPwX9gChpCINfr2PtClLxFqm5t+8Ejuiulypl8=;
        b=anA8vZL0jnjrZHLV644UCkoD2ua0b+0+kNsn1KwE+ijeqI7703+h41Ui2LJVPlKmP+M9GB
        ogsah850A1cqdhW5akq82EMb9hQvKBM0RhezNW3a4esALeBBlLwVAYx8yDpOeTy95oE+PI
        qrwWyg3GxCYqzw/XFMJ6pc5zixf6JXk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-JFFnRSPfMP2DKm7e0MCZ_g-1; Thu, 22 Sep 2022 15:49:58 -0400
X-MC-Unique: JFFnRSPfMP2DKm7e0MCZ_g-1
Received: by mail-qv1-f71.google.com with SMTP id f10-20020ad443ea000000b004aca9fabe98so7096487qvu.18
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:49:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7ZXRmhPwX9gChpCINfr2PtClLxFqm5t+8Ejuiulypl8=;
        b=0La/jaCIttkSwepb2CsR6CF/v7R7RHnU9PLymwL9BPXdf+Wfgv0svZw9L24+Q9SMEG
         RVHGHsWMDqenpzg5ZjKXJfzR55j0gkulxSOzLRS0czIPehL3CzRo6hSr7QgUTC8LzMNy
         C/z48FVeQBoIma4d5TEoegWDTCNju1HYfKSPPLoda9nqoudC2lECZJ4U5nqg/AmZK/b9
         19d0RQf5goWb73IHprmEuxtL29Oi1MJ+CjSOB04GIAxM5qxtqNT/pP6Bk7KTZb9iXOvx
         Vbax95qdlrwEMzzfMF9Q3CNCmuXtdN+z/Mf5okF534GSEJEbppyquI9stXmITBy3cdas
         dsTA==
X-Gm-Message-State: ACrzQf0CDkG3kU3ewUHfS3D1TDj0gxyg/s6/XoLErY21F2Zch8M4bquF
        cFgMnJe5NBH8ltORUWsiDrfg1wvNCVgEiMH1r0EVtI27HhUyK0bk8KZtEmxEHTeuuPmKOQVIPMM
        pOTnE7xliVoIxNxr557/iekZA5+zk
X-Received: by 2002:a37:503:0:b0:6ce:8a8e:7625 with SMTP id 3-20020a370503000000b006ce8a8e7625mr3444850qkf.288.1663876198192;
        Thu, 22 Sep 2022 12:49:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6d65F7z9P/VgdBAGCLBW1PBf+X0H6uAmc4XjUsUvh1VO6n1cVpAlv7NIWL0eCtsPfiPMdwdIImX+4sAHU+gYQ=
X-Received: by 2002:a37:503:0:b0:6ce:8a8e:7625 with SMTP id
 3-20020a370503000000b006ce8a8e7625mr3444843qkf.288.1663876197974; Thu, 22 Sep
 2022 12:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220922101454.1069462-1-kraxel@redhat.com> <YyxF2TNwnXaefT6u@redhat.com>
 <20220922122058.vesh352623uaon6e@sirius.home.kraxel.org> <CABgObfavcPLUbMzaLQS2Rj2=r5eAhuBuKdiHQ4wJGfgPm_=XsQ@mail.gmail.com>
 <20220922141633.t2dk2jviw2f3i26x@sirius.home.kraxel.org> <CALMp9eSEDEit0PEAt_qUwGhBRBPZNsyjasiuJhcrFKT9Zm4K=A@mail.gmail.com>
In-Reply-To: <CALMp9eSEDEit0PEAt_qUwGhBRBPZNsyjasiuJhcrFKT9Zm4K=A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 22 Sep 2022 21:49:46 +0200
Message-ID: <CABgObfZApegzv_4AxMRf0p0LvGWoqnBL289vBXL3g-F-tpL8SA@mail.gmail.com>
Subject: Re: [PATCH v4] x86: add etc/phys-bits fw_cfg file
To:     Jim Mattson <jmattson@google.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-devel@nongnu.org, Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 7:13 PM Jim Mattson <jmattson@google.com> wrote:
> > Treating 40 as invalid and continue to use the current conservative
> > heuristic, otherwise treat phys-bits as valid might work.  Obvious
> > corner case is that it'll not catch broken manual configurations
> > (host-phys-bits=off,phys-bits=<larger-than-host>), only the broken
> > default.  Not sure how much of a problem that is in practice, maybe
> > it isn't.
> >
> > I think I still prefer to explicitly communicate a reliable phys-bits
> > value to the guest somehow.
>
> On x86 hardware, KVM is incapable of emulating a guest physical width
> that differs from the host physical width. There isn't support in the
> hardware for it.

Indeed, everything else is a userspace bug. Especially since here
we're talking of host_maxphyaddr < guest_maxphyaddr, which is
completely impossible.

Paolo

