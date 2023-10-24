Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862307D514F
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbjJXNTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbjJXNTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:19:50 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9452FC2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:19:48 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id a1e0cc1a2514c-7b5fd0b7522so1213236241.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698153587; x=1698758387; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8uz4/aKpiq6hPOqfpQF/xQFDhJm3XWJwzBC0Qx2lRx0=;
        b=VbBJecfdZfPrgv/fDC5ssuT5A7qePEjgkAq51j00XDYfHYF6jL25dhM8SPJ3bKzay/
         5dcnz9A8Drn36sS4S7Fflllx1D5rEwynJ5R3LbtUcA8EUZzNvPGVhqo0/Z4YgMZXCliH
         oPlSHzj624AbEehQW/4hLJ7JMa1lMYljwY/7sOsSOHY/48yWlXMq5btiIHTzrn9VGk0C
         FUByNiGVb0dkJ2FyJpb6DxKsngO0+0tUK17ZiQTyslf8o57ai2pcyXw1KPh2SeJ3OKtz
         GhVOb0SKQd9Ncay3CpnldyGlmSzQmA9r5affGvQBYgC2Z+Pq7T3YK6fk+HvtLgZWLENH
         OP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698153587; x=1698758387;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8uz4/aKpiq6hPOqfpQF/xQFDhJm3XWJwzBC0Qx2lRx0=;
        b=myQ68n7de4pJvJwlYc6Npv+IZ960XG/YgOTwpKhfryJJJvf4jBGwI0FynGdAb/cOhz
         d+ynHAzMvAaNi8t1OqhVvMwh0Cuny6Jfq4ansCpC7PQBR5wO2WJZEIYC04puK/ZCAKOZ
         9TQwpbXnrqW7k1Rzy+UWLuVncF7hd7SysKw8WKn8j3SnDsUCL7CN7B+K0GBSC6EuOy3a
         k9Tq2eMZniwyKtadRtcqC5xkfw2P+4CZ+3U6zkjfDu9LZwDK0S1/sCS0MsCls+Fh73wE
         uCQgGeKUI1uJ95UD5LKdEI0P1hsHJsy7acMj3OdeSXT9XvecNDuPotUbrnRdEmXiH9qf
         2FqA==
X-Gm-Message-State: AOJu0Yx8BQFCTZgezlcjvHTWm4X48GvfR3YaUrQKxhm+37+8iPEHqoJ+
        tL3abYg8ncqg8qvd5ECAU/w=
X-Google-Smtp-Source: AGHT+IGnWoo4jNnLB6831fFx3CoKgHFT0A9Kla2MaDjWE9V1b5hkBs1aVIykQqV5tvtiP+hHD7VG/Q==
X-Received: by 2002:a05:6122:243:b0:4a0:8a35:6686 with SMTP id t3-20020a056122024300b004a08a356686mr7068725vko.11.1698153586115;
        Tue, 24 Oct 2023 06:19:46 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id f7-20020ac5c9a7000000b0049d6e5e8610sm1109415vkm.19.2023.10.24.06.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 06:19:45 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8f51963a-1875-4f11-939e-e7b6c7429da5@xen.org>
Date:   Tue, 24 Oct 2023 14:19:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 08/12] hw/xen: do not repeatedly try to create a failing
 backend device
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
 <20231016151909.22133-9-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231016151909.22133-9-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
> If xen_backend_device_create() fails to instantiate a device, the XenBus
> code will just keep trying over and over again each time the bus is
> re-enumerated, as long as the backend appears online and in
> XenbusStateInitialising.
> 
> The only thing which prevents the XenBus code from recreating duplicates
> of devices which already exist, is the fact that xen_device_realize()
> sets the backend state to XenbusStateInitWait. If the attempt to create
> the device doesn't get *that* far, that's when it will keep getting
> retried.
> 
> My first thought was to handle errors by setting the backend state to
> XenbusStateClosed, but that doesn't work for XenConsole which wants to
> *ignore* any device of type != "ioemu" completely.
> 
> So, make xen_backend_device_create() *keep* the XenBackendInstance for a
> failed device, and provide a new xen_backend_exists() function to allow
> xen_bus_type_enumerate() to check whether one already exists before
> creating a new one.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/xen/xen-backend.c         | 27 +++++++++++++++++++++------
>   hw/xen/xen-bus.c             |  3 ++-
>   include/hw/xen/xen-backend.h |  1 +
>   3 files changed, 24 insertions(+), 7 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

