Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E31652F00
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 10:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiLUJze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 04:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbiLUJzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 04:55:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05C622B20
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 01:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671616208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nTgcQrziW5VujETu8NLZFtI7hg34vFn/f7FoknZcMU4=;
        b=hVCm66i1Ymqkh9+YjjJtnaIsbiJjUblOhuOYS+vJwyR1fm+ZScsx5Q3OnjCF6oRcBsf4yt
        BRR+Is1F3gX/0JqWxKH/mYi5d+xmKr9LrsTCFOma8KG9KWMgIBHjP4TEXCuBVRk4xmctwo
        lop6Br7yjljehwfeZv/TKTVohTFS3Ko=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-kXzvWSgbO3aHPrrOxZlILg-1; Wed, 21 Dec 2022 04:50:07 -0500
X-MC-Unique: kXzvWSgbO3aHPrrOxZlILg-1
Received: by mail-qt1-f200.google.com with SMTP id d12-20020ac851cc000000b003a8118f79daso6721729qtn.19
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 01:50:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTgcQrziW5VujETu8NLZFtI7hg34vFn/f7FoknZcMU4=;
        b=tgFs4ekyJ33Y5BmEfagmeOZYBXVRbZuJ/dtLeMoc1RB+kIGqCax1SOkD3oIVzg41NO
         YLRtz0eSW5ZdJzItZ8qWv7yt/XeJzdD1gbFcmF5uHDT2bFuxZyUzdmX7fmOZOPkZIt/d
         /534W2+NolraQZ/ayufMvjZZGJ0rxF5bz/mOTbq5smpR2jBRyACwtn/KE/iASeW4B5+D
         JG63ltUw+jFiRkmrUQDLYyf8WQ4nSURCmsW1mPnoektH4ePtRgSq0VQhQlWbu1Z4G4w6
         zQMB2hGOD8xAB22w9UqBB9LAJvutPGOm1VE77KDOfIXR8Oi6OSZJ131fBfUbatW92w6O
         SjUA==
X-Gm-Message-State: AFqh2krE4/Aaus5r+zKJ2VjigfdJhNLQoloo6AAkxZc8FuxyBavkNJme
        IhTP67mCxqZQDZUI16SnVktmcMUlggDJ09g4g+Z/LpDIGDTw+fjcZTOrAI39C1GwRsJJh3Wm+nX
        y2PhBDjETiscI
X-Received: by 2002:a05:6214:2d10:b0:513:520c:9180 with SMTP id mz16-20020a0562142d1000b00513520c9180mr1493841qvb.38.1671616206932;
        Wed, 21 Dec 2022 01:50:06 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsqOkaJ1D2A6Dv07PmI1nhJvRa8UOdEQEYu1jCnu3iSlOtZ1p/WiOSE2yBkC7QN8kWGuOBveg==
X-Received: by 2002:a05:6214:2d10:b0:513:520c:9180 with SMTP id mz16-20020a0562142d1000b00513520c9180mr1493823qvb.38.1671616206640;
        Wed, 21 Dec 2022 01:50:06 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id br12-20020a05620a460c00b006faf76e7c9asm10558965qkb.115.2022.12.21.01.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 01:50:06 -0800 (PST)
Date:   Wed, 21 Dec 2022 10:50:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, stefanha@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] vdpa_sim: add support for user VA
Message-ID: <20221221095000.m7bx26dohemrjql2@sgarzare-redhat>
References: <20221214163025.103075-1-sgarzare@redhat.com>
 <20221214163025.103075-7-sgarzare@redhat.com>
 <CAJaqyWdwa5P6hXJ5Ovup+Uz3293Asr10CLvi4JVQZqDL-M1p1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJaqyWdwa5P6hXJ5Ovup+Uz3293Asr10CLvi4JVQZqDL-M1p1A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 08:17:41AM +0100, Eugenio Perez Martin wrote:
>On Wed, Dec 14, 2022 at 5:31 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> The new "use_va" module parameter (default: false) is used in
>
>Why not true by default? I'd say it makes more sense for the simulator
>to use va mode and only use pa for testing it.

Yep, you are right. I'll change it in the version.
I initially left it at false because we usually use the simulator to 
test the paths that would be used for the real hardware.

Thanks,
Stefano

