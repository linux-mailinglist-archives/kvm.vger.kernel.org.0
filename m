Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A399414AE5
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhIVNnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232050AbhIVNnE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 09:43:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632318093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AoRgYfPGAxyUTr8iwhyKmCXSgOV4FJeNaVwSJn1d/sE=;
        b=hldCE99Z4ZXodVSv9VKx3FHlsKUKOl/UdvUYXNHltOb1y/llb1a6mgDTetHXSLlLVBk4wH
        2g+7p+nCcsDN1otr9nEpwUte10/yMXlQEtx6zcEe89QuWEiUc9HPDchcIfCqPLYdXAnwvq
        SK0RuQNzkmu5UtzwsRzioWz1N/+2ql8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-lBpg6f5zNpacSEo7i36RkA-1; Wed, 22 Sep 2021 09:41:32 -0400
X-MC-Unique: lBpg6f5zNpacSEo7i36RkA-1
Received: by mail-wr1-f72.google.com with SMTP id m1-20020a056000180100b0015e1ec30ac3so2204431wrh.8
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 06:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AoRgYfPGAxyUTr8iwhyKmCXSgOV4FJeNaVwSJn1d/sE=;
        b=3ODDgHtLr4yw4qiuuA6uyA1sa294tzNoG4CEyDWwHtsb/t1SNlDqBy3/ROZeOy0SYm
         6r94nzmHWnXEHeJAvhQgd/CebxH9uHG6LdddfJc9cEjwgsFeIP3FXCgwVeXFednb3h3j
         E2eV3G2cjJuXLROlIWP6qG/D3CpDD06vxZytozqS2OD88hAishmQhn0bLDTrphceIm+v
         r2GcPbdhpgQKDCGmxr8P1Ma2tbOC0EaFTv4zaTRwM0jEwRKdsMsBxEAB11AkCGQ2cUr3
         GB/gzj/tf8MTvzKoPObEWSDhIZVy1FWe7bmoGmS8vZWZt89ylvdk2VWX+Rf5yDy/1RVN
         Z3WA==
X-Gm-Message-State: AOAM533Voc/z0kXdNy0VJmm+FnvilYfyTaJ8mLqa6LvVEFiePvzLCfy/
        TgS6GyL2h62RtzwQNMrM4SqbgPtxpbqltC1eXFmTPbbDzo2UUOeBsS6iv+zBsi3SL5g8QUZbYAu
        Md3zGMRqmK3Q83TRFurkpPr+fzBujPlUP2Lu2iKlp0SP8jQRwkhSm+SsjqKxXZxwA
X-Received: by 2002:a5d:4d92:: with SMTP id b18mr42150219wru.245.1632318091490;
        Wed, 22 Sep 2021 06:41:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGINcO8L+ILk9ixvKyeWuwFNJJKeXsFBDooHDZPIjHohljjSyfzqZc0ncw2UvbycKaVfyPeA==
X-Received: by 2002:a5d:4d92:: with SMTP id b18mr42150199wru.245.1632318091300;
        Wed, 22 Sep 2021 06:41:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o1sm2248164wru.91.2021.09.22.06.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 06:41:30 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     mattias <mjonsson1986@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: vhd file with windows
In-Reply-To: <4f679440-113d-60be-4c84-e5cfaffab4ca@gmail.com>
References: <4f679440-113d-60be-4c84-e5cfaffab4ca@gmail.com>
Date:   Wed, 22 Sep 2021 15:41:29 +0200
Message-ID: <87zgs47mnq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mattias <mjonsson1986@gmail.com> writes:

> if i have a vhd image created by e.g virtualbox
>
> can i boot it with kvm?

With QEMU/KVM, yes, you can use something like (old but still supported
syntax):

$ qemu-system-x86_64 -name guest=win10 -machine q35,accel=kvm -cpu ... -m ... -drive file=/var/lib/libvirt/images/ws2019_gen1.vhdx,format=vhdx,if=none,id=drive-ide0-0-0
-device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1 -vnc :1

alternatively, you can convert the image to QCOW2:

$ qemu-img convert  -O qcow2 /var/lib/libvirt/images/ws2019_gen1.vhdx /var/lib/libvirt/images/ws2019_gen1.qcow2

-- 
Vitaly

