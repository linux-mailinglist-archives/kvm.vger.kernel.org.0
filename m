Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BEB7D943C
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345559AbjJ0Jw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345406AbjJ0JwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:52:23 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A74F187
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:52:21 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-4084e49a5e5so15242425e9.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698400339; x=1699005139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2yiE3kmnMlzeuIC0wQ9aeOyHGBx7Hm50hNBXLvo1oLI=;
        b=HqNY0R2os7stj8aDfw8AVuMuiwy7+vosgpJvC3vOZWUKIEHJZ2xX/zEqjXWoS1pIP4
         ddVS+GGgMJ4RiPbukkd7KSePdU5jASbu7PnWVDAiROPQJqnwnUsqyb1u1pwOksLpSk42
         vgb+YPWoF0TSDBRJzAyNApvr5s0TVqszGfoPIkEeQDi6gZVitOfa0F5pGzpN829cyEcJ
         FZyIMB042F6wy/O0Jj5Wg8TIgjHPA24jv08tbHcChQ6U1UPBOl/BvLUqFOXMTYxhFlq/
         18+UBCtcd5Ef7Hzl1oEfvcWgUSkMYz8U3k84PSyWQ0T1vLoo0y8HSJe9jEvVFr2TY38p
         xOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698400339; x=1699005139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2yiE3kmnMlzeuIC0wQ9aeOyHGBx7Hm50hNBXLvo1oLI=;
        b=njy+LSz3irgFoFWjpBJ79BGFPMeC1CtwgUpPLESIO9PZCuQpb02b9xD5YUuOZlILe1
         ZWaEtHDN0kIx7jMGkhUk3n6dspV5xKvMn9i0TTaZK/oIlbHW8I1R7v24FBuLrYv9nKxe
         tIwF1fwl+EFO/wJBw8z6eqK2CaJa4vIFjTNi1w8tz7ozWPTMAyEjjRAPrIqElHxPZN1V
         +bJL+B2C4lGzte6Vr5GBAkPuUjAJss4I3/OcvnY7EgpSrW3gUKaAfjk/l6/7ly+3pZBO
         QzYaKiN/c4x4kRrao583IFC815MFQe7HN+IkE2uhtKhckZWa/0AZbWujFeVzNN9IsAbY
         EFTw==
X-Gm-Message-State: AOJu0YykqtalOXzB1aNMW0H4v+XKdJmGfJFtHLfCoPwDmWYH5ZML2dGk
        lbvkJfzaCft99uKjKAZlGoU=
X-Google-Smtp-Source: AGHT+IEuLWOC6r1FV8oQb3wkYtxJ/Wfx1Om4s2yzSuMliOYSNXtiWemTUbczcZfVgloepcRrPb3iTw==
X-Received: by 2002:a05:600c:4ecd:b0:403:31a:77b9 with SMTP id g13-20020a05600c4ecd00b00403031a77b9mr1829515wmq.37.1698400339330;
        Fri, 27 Oct 2023 02:52:19 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id bd6-20020a05600c1f0600b003fee53feab5sm1212290wmb.10.2023.10.27.02.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 02:52:18 -0700 (PDT)
Message-ID: <88aad170-24f2-4ec6-b43c-ac87dde81255@gmail.com>
Date:   Fri, 27 Oct 2023 10:52:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 27/28] hw/xen: use qemu_create_nic_bus_devices() to
 instantiate Xen NICs
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
 <20231025145042.627381-28-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-28-dwmw2@infradead.org>
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
> When instantiating XenBus itself, for each NIC which is configured with
> either the model unspecified, or set to to "xen" or "xen-net-device",
> create a corresponding xen-net-device for it.
> 
> Now we can launch emulated Xen guests with '-nic user', and this fixes
> the setup for Xen PV guests, which was previously broken in various
> ways and never actually managed to peer with the netdev.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/xen/xen-bus.c                    |  4 ++++
>   hw/xen/xen_devconfig.c              | 25 -------------------------
>   hw/xenpv/xen_machine_pv.c           |  9 ---------
>   include/hw/xen/xen-legacy-backend.h |  1 -
>   4 files changed, 4 insertions(+), 35 deletions(-)
> 

Yay! I've been wanting this for years but ETIME.

Reviewed-by: Paul Durrant <paul@xen.org>


