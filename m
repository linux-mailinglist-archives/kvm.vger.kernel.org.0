Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3637D9025
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 09:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345527AbjJ0Hoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 03:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345523AbjJ0Hou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 03:44:50 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBCE1BB
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:44:48 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-4083740f92dso14074435e9.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698392687; x=1698997487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=weNLTHsNEHd1AKAqcG0eLkMfm7+O04Gb2EjgMXPk2o8=;
        b=PiGV3IHKJr5CtGpD0m6YupndCW9ShruZSuDIeUqCKaRkWIoNtzkpcxPdGJwJ8ELLoi
         p6Vc2ufphzmzAyE+Oy1D8FZLbCdV9zS0VQCzQTnh2AYBqObPMXNfm4+ppVrNRrJ1MAXe
         kmO4yNWjsky4dH/RQ+cH2v9YJlL3atOkrSyI6LMstOF6Ay9HGZevyR32Iz53VUb5Gc0R
         i7B6ZVu1mVsqWCfFxk3sbiMwgvQtQmk8++bEVKbNDTF/vQRLC2juNzUr1ZdAGIEgBUrS
         vs0yS7+n+/FdZu+07Fwvxxqa5mSYYNh/LgSj6fHNNYVG/nPLxfHruia4NFE7qTityd4Q
         4qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698392687; x=1698997487;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=weNLTHsNEHd1AKAqcG0eLkMfm7+O04Gb2EjgMXPk2o8=;
        b=gUAvFx1j5zSQ4HEnLIR4QXP7bkBLcTvCl6EZ5u5vH+kDIp5fh/+yCXbwW6i9/sn34l
         jaMUbwnbwrqjj4gNMgd70KtG221M5APxghOpIyy/H9KPOhVqjoTb6I3LcoHgBaMGJqJ6
         K1qZ0Hitxo3Z4HzRYEcTUJVknqaYJRvgTmVwYdL0nkL6MNMllxFleUFahT5Oncu4qeOP
         8jK9ABsiQBNntxbfQa4fHJ4OP3LXWnbTzftkSqncPVKUFZmF/EFA7wc5PW4XLmAWcSfM
         6Ci0zaWXrSP3LCPK7Vdwpr1xeB1aT7nXvAwabI46r0MW1KLyFJGf+DufAzOrQwnYdMM2
         j+7g==
X-Gm-Message-State: AOJu0Ywr6xBA5l+s62Rc1V6mELG4z6hZJIfmi26iR9RoOztGD/iF9kr9
        5YnBT4rH60VEQVuKMtAp+kgg5hHWD8nHNg==
X-Google-Smtp-Source: AGHT+IGfHlZcElg4jlYC+dM2f33yrgLaTa3lKMccWGDiPJqAf0Qf0ppM0UHBxCctTNhgycC9pq53SA==
X-Received: by 2002:a05:600c:45d3:b0:405:3dd0:6ee9 with SMTP id s19-20020a05600c45d300b004053dd06ee9mr1653222wmo.34.1698392686518;
        Fri, 27 Oct 2023 00:44:46 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id g12-20020a05600c310c00b004068e09a70bsm940661wmo.31.2023.10.27.00.44.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 00:44:45 -0700 (PDT)
Message-ID: <d58639b8-09de-4820-88ae-53de0db55f7f@gmail.com>
Date:   Fri, 27 Oct 2023 08:44:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 17/28] hw/xen: add support for Xen primary console in
 emulated mode
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
 <20231025145042.627381-18-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-18-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The primary console is special because the toolstack maps a page into
> the guest for its ring, and also allocates the guest-side event channel.
> The guest's grant table is even primed to export that page using a known
> grant ref#. Add support for all that in emulated mode, so that we can
> have a primary console.
> 
> For reasons unclear, the backends running under real Xen don't just use
> a mapping of the well-known GNTTAB_RESERVED_CONSOLE grant ref (which
> would also be in the ring-ref node in XenStore). Instead, the toolstack
> sets the ring-ref node of the primary console to the GFN of the guest
> page. The backend is expected to handle that special case and map it
> with foreignmem operations instead.
> 
> We don't have an implementation of foreignmem ops for emulated Xen mode,
> so just make it map GNTTAB_RESERVED_CONSOLE instead. This would probably
> work for real Xen too, but we can't work out how to make real Xen create
> a primary console of type "ioemu" to make QEMU drive it, so we can't
> test that; might as well leave it as it is for now under Xen.
> 
> Now at last we can boot the Xen PV shim and run PV kernels in QEMU.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/char/xen_console.c             |  78 ++++++++----
>   hw/i386/kvm/meson.build           |   1 +
>   hw/i386/kvm/trace-events          |   2 +
>   hw/i386/kvm/xen-stubs.c           |   8 ++
>   hw/i386/kvm/xen_gnttab.c          |   7 +-
>   hw/i386/kvm/xen_primary_console.c | 193 ++++++++++++++++++++++++++++++
>   hw/i386/kvm/xen_primary_console.h |  23 ++++
>   hw/i386/kvm/xen_xenstore.c        |  10 ++
>   hw/xen/xen-bus.c                  |   5 +
>   include/hw/xen/xen-bus.h          |   1 +
>   target/i386/kvm/xen-emu.c         |  23 +++-
>   11 files changed, 328 insertions(+), 23 deletions(-)
>   create mode 100644 hw/i386/kvm/xen_primary_console.c
>   create mode 100644 hw/i386/kvm/xen_primary_console.h
> 

Reviewed-by: Paul Durrant <paul@xen.org>


