Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD5C7D500C
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbjJXMmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbjJXMmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:42:23 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6FBDD
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:42:21 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2c50305c5c4so67277131fa.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698151339; x=1698756139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nleuh30f60jeiNJDPgerM6LHIyJSmfHjZNXbgUudLV0=;
        b=OGwU1lM8okJua+aqlm3LQPvESbaXq/TBXqKSOjiQj1lN6eGqEp1WY7NR6OikiDzDSx
         /JjpmPk4X6EGmogks/nIHr9nymM6GMt27SAtqY9qF5ZRMd20rVXmMYHO3aiNqvHWuD/R
         O/0wOadfeAVIN/fiDmIL/AozsT5y31EDxi9I+VEBlXozfSh7evdk6U4yFCjukeVzJL56
         idWr7VHSqaJg/a4FkhOa0dUd0gOcpjP7HF2RM30L8T+P89LBHOVh1U3f77MIkqVO9REc
         +646qnschQpsHrUTRj50o+WvS7UMC84kXYheu58wh6wlWe6aEJF5GI7Dx54RjHaZ//cd
         rjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698151339; x=1698756139;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nleuh30f60jeiNJDPgerM6LHIyJSmfHjZNXbgUudLV0=;
        b=r74koAxBXELfXhkrkUaRv4h2ess6q0AviaReIq4jtedF3sw/dU2isnsgb5MmX74Iic
         qDGmscO/ifc4cBW3RHZGd6WFzaMss8sZxPisTeeBBqEFLXJ7puV+fI/XSKphKVTfz544
         TPykzLxpK8l8q6UEtVGJRzCVpcP9pEOJwR7bO8qIMtsOcv6swTjQ2DrTfkaARJ0EfSIs
         71yvR80xUhmNNJ6ppqO5KNE1KbjBNAaksU4sdFNlSp+yHwPMKJPTutWuS08CJUh5SH44
         YaKccBkM7riyagQGvD9/na5ycfNrzHMSFrCbrdfEyERHVvA4yzVjeV10j/Bw9l7OmimQ
         ayZw==
X-Gm-Message-State: AOJu0YwvL84eL/CB0eltWx+RPL+LYfKjupZUDjvVt+pGvCR0OzR33WUq
        hgmoZL/eFQ3fzlV5E+r+8hQ=
X-Google-Smtp-Source: AGHT+IG7xfJEIBpaao1AVHuot+7nF+K9gT+jAPeV2BLTz6q/or9dTrt+5Pf96dJ2k8c2f9XmlagJlQ==
X-Received: by 2002:a2e:aa28:0:b0:2be:54b4:ff90 with SMTP id bf40-20020a2eaa28000000b002be54b4ff90mr7826766ljb.53.1698151339104;
        Tue, 24 Oct 2023 05:42:19 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-230.amazon.com. [54.240.197.230])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c320900b0040644e699a0sm16610990wmp.45.2023.10.24.05.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 05:42:18 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <5ef43a7c-e535-496d-8a14-bccbadab3bc0@xen.org>
Date:   Tue, 24 Oct 2023 13:42:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 06/12] hw/xen: add get_frontend_path() method to
 XenDeviceClass
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-7-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231016151909.22133-7-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 16:19, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The primary Xen console is special. The guest's side is set up for it by
> the toolstack automatically and not by the standard PV init sequence.
> 
> Accordingly, its *frontend* doesn't appear in …/device/console/0 either;
> instead it appears under …/console in the guest's XenStore node.
> 
> To allow the Xen console driver to override the frontend path for the
> primary console, add a method to the XenDeviceClass which can be used
> instead of the standard xen_device_get_frontend_path()
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/xen/xen-bus.c         | 10 +++++++++-
>   include/hw/xen/xen-bus.h |  2 ++
>   2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/xen/xen-bus.c b/hw/xen/xen-bus.c
> index ece8ec40cd..cc524ed92c 100644
> --- a/hw/xen/xen-bus.c
> +++ b/hw/xen/xen-bus.c
> @@ -711,8 +711,16 @@ static void xen_device_frontend_create(XenDevice *xendev, Error **errp)
>   {
>       ERRP_GUARD();
>       XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
> +    XenDeviceClass *xendev_class = XEN_DEVICE_GET_CLASS(xendev);
>   
> -    xendev->frontend_path = xen_device_get_frontend_path(xendev);
> +    if (xendev_class->get_frontend_path) {
> +        xendev->frontend_path = xendev_class->get_frontend_path(xendev, errp);
> +        if (!xendev->frontend_path) {
> +            return;

I think you need to update errp here to note that you are failing to 
create the frontend.

   Paul


