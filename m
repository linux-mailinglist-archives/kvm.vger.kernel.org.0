Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758153D0AC9
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 10:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbhGUHx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 03:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237116AbhGUHuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 03:50:24 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B333C0613DC
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 01:30:20 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k4so1216142wrc.8
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 01:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=yUJHVWQTlhcEWMO4DydR2xNVcklNcrzSF7aJbrXgfvg=;
        b=GwdmBlYvKMUbfBL/G94R3vphXcZlpRXLWB5bF6QGSKL6pV85wsV22JWa094sGOGZ7g
         P7qZ2LHJQBo4PwG/TNgCHOaSgH2i2SjcyzRNDuX20bIJxYhvzaR4zaGWcHvYfz7FosQ1
         +yN7E9DcdXpiJYZyNTefp+5fVA6/p0Iih4ldiljoRyOGgUM/UJfxsJv02X3wzob4Rndq
         IFXhZkCFEChrGwQ0t0RNvLKWhe0VX5MuIqQGR6jl1KGLr0E0wvw3SXlB/oyfvLUR0i77
         BLKvwGfPp8i9fxGt49K+cQN7ANcz5BjuZM8eJYMmSGGv2iBwzBMt/VngBYxrBWcVPqtB
         SFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yUJHVWQTlhcEWMO4DydR2xNVcklNcrzSF7aJbrXgfvg=;
        b=SVH1xMK12U2D1BI3jLdOCRwXmc74HwV+0QWwjui4Oi5lhX7TsYBxX7XfnzawjaESIS
         mfmWgZpkvdiacZJ1KT750JT/pk3QwTS9ZlxGzJWjBA46dkeY96wiHncGEamafDunVXVk
         cxjByBduuwTOztqwIgJI1vQBZ62TjgurnJtq8P6rvfq3PdYHiCTszeOAZAWEWfU317Y9
         qxGJ9w4O4l8YAnxJM1XzCWtCNS8c5mtXIq0+jzQYbm/syW6YI683vG2sHwsejJD34epd
         Co+EWjBA1nZRNSoG+GsIjTSthSd4ExMOPuUt1kHp95hcDgOQhsdcQpuKVwc3Xa2gsh5j
         xHzw==
X-Gm-Message-State: AOAM532DWReadq85+/TY5WorOQy1oZe2ZzQv2wPTZxMIkQ3WRlyn2zlD
        /6LPGetAs13qeBrffvXyd5k=
X-Google-Smtp-Source: ABdhPJw/bXojKZq/3rBVxc6LypfZ1k0EVFJuDmJugmtJ7S6ZqIPs+VTOFVKLsKXR1S8VTaSs6Vqj4A==
X-Received: by 2002:adf:b605:: with SMTP id f5mr41299570wre.419.1626856219104;
        Wed, 21 Jul 2021 01:30:19 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:9bcf:837a:d18c:dc66? ([2a02:908:1252:fb60:9bcf:837a:d18c:dc66])
        by smtp.gmail.com with ESMTPSA id w3sm26068057wrt.55.2021.07.21.01.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 01:30:18 -0700 (PDT)
Subject: Re: [PATCH 1/7] vgaarb: remove VGA_DEFAULT_DEVICE
To:     Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>, kvm@vger.kernel.org,
        David Airlie <airlied@linux.ie>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Christoph Hellwig <hch@lst.de>, Ben Skeggs <bskeggs@redhat.com>
References: <20210716061634.2446357-1-hch@lst.de>
 <20210716061634.2446357-2-hch@lst.de>
 <f171831b-3281-5a5a-04d3-2d69cb77f1a2@amd.com>
 <YPbUvIYmu3WfyM2C@phenom.ffwll.local>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <81094b7d-1846-9d43-dc58-44ff9bd60995@gmail.com>
Date:   Wed, 21 Jul 2021 10:30:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPbUvIYmu3WfyM2C@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20.07.21 um 15:50 schrieb Daniel Vetter:
> On Fri, Jul 16, 2021 at 09:14:02AM +0200, Christian König wrote:
>> Am 16.07.21 um 08:16 schrieb Christoph Hellwig:
>>> The define is entirely unused.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> I'm not an expert for this particular code, but at least of hand everything
>> you do here makes totally sense.
>>
>> Whole series is Acked-by: Christian König <christian.koenig@amd.com>
> Care to also push this into drm-misc-next since you looked already?

Done.

Christian.

> -Daniel
>
>> Regards,
>> Christian.
>>
>>> ---
>>>    include/linux/vgaarb.h | 6 ------
>>>    1 file changed, 6 deletions(-)
>>>
>>> diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
>>> index dc6ddce92066..26ec8a057d2a 100644
>>> --- a/include/linux/vgaarb.h
>>> +++ b/include/linux/vgaarb.h
>>> @@ -42,12 +42,6 @@
>>>    #define VGA_RSRC_NORMAL_IO     0x04
>>>    #define VGA_RSRC_NORMAL_MEM    0x08
>>> -/* Passing that instead of a pci_dev to use the system "default"
>>> - * device, that is the one used by vgacon. Archs will probably
>>> - * have to provide their own vga_default_device();
>>> - */
>>> -#define VGA_DEFAULT_DEVICE     (NULL)
>>> -
>>>    struct pci_dev;
>>>    /* For use by clients */

