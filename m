Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACB37D9319
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjJ0JJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjJ0JJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:09:02 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B2E187
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:08:58 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-40859c46447so12669085e9.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698397736; x=1699002536; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xk4l/7iC4UJ4bxYDA1m/0zWstbr1oMvAsUPXmEV1lqw=;
        b=BW+D1QSMWIJYcFxX5OM/6E8rNF3/WQ3IKh0rKPnbbGJQDKD0n93hhDgOgWRyEAlgTW
         x40YKrxsfP8VoNodOSD9QnwZ7YfLiUVDQIOE8xUjEdD7q4VMe+J5xeZ7UpZ24dTYpWXc
         ed1BwWkdsBUuz6gt3LIjF8Ka0qH413sU7gcW8Lif4o1iUzo0AJxYsQfZw9yzC3CnQV0b
         ti4BwZPr6vDNz2sXJr6leFYAHybNDsJQgphrkKUb5WQqogJWa2FHqDK8j+0mBqu/ES7g
         NBw39RGUZ5XNUDpBgbAo8jWvqg9blOZWQmYpUb+QuxKiM8X5peSRxhwCBO+kcLPWDd11
         Stcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698397736; x=1699002536;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xk4l/7iC4UJ4bxYDA1m/0zWstbr1oMvAsUPXmEV1lqw=;
        b=KGjEu5/UlOcqv8Gq83rsJ0U+1FM/7hrGP7N4CanEL+VLqOb/eXhTk2D5vZHndlrADi
         J0HhnvWrboddXsqs9pja8Pk50Ny2+PYiM6ZoUnYcT57oK08MW4/rlBupJCiQQU4JUPPP
         e0pZ//qkCnjpLH3FMTUJ8wXbE4JgMnRLO8Khxz2Q0JZNj91QNvmKFtwLVy4vzRrZI1wE
         084F5i9s1WgHHVPsTl5FkwvnhfghZFelpA4gPpNQ50peuOB13ekBn/PfBQPh7kxRY0Yx
         TVD1RN9/6LAUke0cndPjSKAm1IqCnzM/u+uYRxEYMk1tuTgIYWNZgVBMB7JyXpd3VcZH
         4G/g==
X-Gm-Message-State: AOJu0YxXBVrLIkiyfArlXkSkzeWipdZzWoTXul1GJBaYUWIsEXJYcXjB
        566lwb9zBBwognslaHbO9CA=
X-Google-Smtp-Source: AGHT+IHrQB1bpAc743TK730kpsbJOspNGIhwFQpbDW8MoZPSXg+FX7Yyui8H9QO36a/HiwExPsj/DA==
X-Received: by 2002:a05:600c:4514:b0:408:53d6:10b3 with SMTP id t20-20020a05600c451400b0040853d610b3mr1725341wmo.22.1698397736127;
        Fri, 27 Oct 2023 02:08:56 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id g12-20020a05600c310c00b004068e09a70bsm1109446wmo.31.2023.10.27.02.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 02:08:55 -0700 (PDT)
Message-ID: <053171c9-fb82-4e19-abda-d41af7b43378@gmail.com>
Date:   Fri, 27 Oct 2023 10:08:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 21/28] xen-platform: unplug AHCI disks
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
 <20231025145042.627381-22-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-22-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> To support Xen guests using the Q35 chipset, the unplug protocol needs
> to also remove AHCI disks.
> 
> Make pci_xen_ide_unplug() more generic, iterating over the children
> of the PCI device and destroying the "ide-hd" devices. That works the
> same for both AHCI and IDE, as does the detection of the primary disk
> as unit 0 on the bus named "ide.0".
> 
> Then pci_xen_ide_unplug() can be used for both AHCI and IDE devices.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/xen/xen_platform.c | 68 +++++++++++++++++++++++++-------------
>   1 file changed, 45 insertions(+), 23 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

