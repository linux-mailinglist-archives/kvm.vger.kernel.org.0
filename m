Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057627D56CD
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343648AbjJXPoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343547AbjJXPoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:44:12 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0F8A3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:44:09 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-32da7ac5c4fso3139340f8f.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698162248; x=1698767048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yS5KTEoFqSeFaD9KDbOtnwK71r/T1IzAy2dMzIuLI5s=;
        b=NfZtzZi7BoFtQd2u7GMyQGZ/cwHJgY7afjpo6ZV5KEc83ZXrlVSA4R+I5Tc5rtzhhD
         giHs1zDFociLxDgUSRiIOGClBSU2QbF+pu1wnmC8yqe80bohtR99+pMZ1RptlyASqOso
         WdtUMmqz64+qQaI4sO9LWacLbxIi4nKLQNmk1wvgmLoYput1jlvJsWyXQQx2FxjMe40C
         b8ECc9TxCvPBpmeZuW8dYc8DoRwSixw5BRfxUbxs6M+rZIkWlo5bOhg0X/lkBO9n5DnX
         jOiTmQ+lB9RJ1l+MT5QKz6NSe/W8zdXuHCAMSu20uO9UQM9NOfvCtDp1tpinNPLeIafT
         zb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698162248; x=1698767048;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yS5KTEoFqSeFaD9KDbOtnwK71r/T1IzAy2dMzIuLI5s=;
        b=pj83Il2B+0Z/uwPzpv1XJ3A4TiAPfGDzedG6sFGUiQsnhU0Kr1KO1Tq5ad8J/Vmwc+
         J2VDyCuoy8l7Qdm4zdf5Chz3u1v/l7x8TFPLPMj57lxDCspVA+/G3atNdY17/LB7DDtv
         Ohm8QCSvsWRQB10z2v/vcrA5cOXCnZt7LexGXCR3d8f0FYkZBbelMZjeopQ7xr6i5cSQ
         999Y1TrzRzFHRS+qfzQ0si+Iwfn9NGEKyQUpdL6EoR89OJ0Cu79Goz+Onz1fmYeOC2cd
         b4ilLe8AL6anV2UeZw/vf7uH2NDtv0KvW6wtyNhrCtXyhDXRslBUrEDj+egcIXTtv2sQ
         vGcw==
X-Gm-Message-State: AOJu0YxzQXTaYkmYarjNGaFeHe4sJ00hp1JAXnZByL2LYihdTqy7PeGC
        z7JHwVBq73Ra5aEpKE63N70=
X-Google-Smtp-Source: AGHT+IGOdFp+c3H/OzmD6auBGTwD1zTQ8nmXRdo9qvd7R6YRSUetpKZX659Ae1VnlHjErrywnw2Ypg==
X-Received: by 2002:a5d:560d:0:b0:32d:d756:2cd3 with SMTP id l13-20020a5d560d000000b0032dd7562cd3mr8359004wrv.22.1698162247852;
        Tue, 24 Oct 2023 08:44:07 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id b14-20020a5d550e000000b0032d9caeab0fsm10133987wrv.77.2023.10.24.08.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:44:07 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8ba01df3-6189-4e1e-a70f-37a2d4dd21ed@xen.org>
Date:   Tue, 24 Oct 2023 16:44:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 16/24] hw/xen: handle soft reset for primary console
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231019154020.99080-1-dwmw2@infradead.org>
 <20231019154020.99080-17-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231019154020.99080-17-dwmw2@infradead.org>
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

On 19/10/2023 16:40, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> On soft reset, the prinary console event channel needs to be rebound to
> the backend port (in the xen-console driver). We could put that into the
> xen-console driver itself, but it's slightly less ugly to keep it within
> the KVM/Xen code, by stashing the backend port# on event channel reset
> and then rebinding in the primary console reset when it has to recreate
> the guest port anyway.

Does Xen re-bind the primary console on EVTCHNOP_reset? That's news to 
me. I go check.

   Paul

> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_evtchn.c          |  9 +++++++++
>   hw/i386/kvm/xen_primary_console.c | 29 ++++++++++++++++++++++++++++-
>   hw/i386/kvm/xen_primary_console.h |  1 +
>   3 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
> index d72dca6591..ce4da6d37a 100644
> --- a/hw/i386/kvm/xen_evtchn.c
> +++ b/hw/i386/kvm/xen_evtchn.c
> @@ -40,6 +40,7 @@
>   #include "xen_evtchn.h"
>   #include "xen_overlay.h"
>   #include "xen_xenstore.h"
> +#include "xen_primary_console.h"
>   
>   #include "sysemu/kvm.h"
>   #include "sysemu/kvm_xen.h"
> @@ -1098,6 +1099,7 @@ int xen_evtchn_soft_reset(void)
>   {
>       XenEvtchnState *s = xen_evtchn_singleton;
>       bool flush_kvm_routes;
> +    uint16_t con_port = xen_primary_console_get_port();
>       int i;
>   
>       if (!s) {
> @@ -1108,6 +1110,13 @@ int xen_evtchn_soft_reset(void)
>   
>       qemu_mutex_lock(&s->port_lock);
>   
> +    if (con_port) {
> +        XenEvtchnPort *p = &s->port_table[con_port];
> +        if (p->type == EVTCHNSTAT_interdomain) {
> +            xen_primary_console_set_be_port(p->u.interdomain.port);
> +        }
> +    }
> +
>       for (i = 0; i < s->nr_ports; i++) {
>           close_port(s, i, &flush_kvm_routes);
>       }
> diff --git a/hw/i386/kvm/xen_primary_console.c b/hw/i386/kvm/xen_primary_console.c
> index 0aa1c16ad6..5e6e085ac7 100644
> --- a/hw/i386/kvm/xen_primary_console.c
> +++ b/hw/i386/kvm/xen_primary_console.c
> @@ -112,6 +112,15 @@ uint16_t xen_primary_console_get_port(void)
>       return s->guest_port;
>   }
>   
> +void xen_primary_console_set_be_port(uint16_t port)
> +{
> +    XenPrimaryConsoleState *s = xen_primary_console_singleton;
> +    if (s) {
> +        printf("be port set to %d\n", port);
> +        s->be_port = port;
> +    }
> +}
> +
>   uint64_t xen_primary_console_get_pfn(void)
>   {
>       XenPrimaryConsoleState *s = xen_primary_console_singleton;
> @@ -142,6 +151,20 @@ static void alloc_guest_port(XenPrimaryConsoleState *s)
>       }
>   }
>   
> +static void rebind_guest_port(XenPrimaryConsoleState *s)
> +{
> +    struct evtchn_bind_interdomain inter = {
> +        .remote_dom = DOMID_QEMU,
> +        .remote_port = s->be_port,
> +    };
> +
> +    if (!xen_evtchn_bind_interdomain_op(&inter)) {
> +        s->guest_port = inter.local_port;
> +    }
> +
> +    s->be_port = 0;
> +}
> +
>   int xen_primary_console_reset(void)
>   {
>       XenPrimaryConsoleState *s = xen_primary_console_singleton;
> @@ -154,7 +177,11 @@ int xen_primary_console_reset(void)
>           xen_overlay_do_map_page(&s->console_page, gpa);
>       }
>   
> -    alloc_guest_port(s);
> +    if (s->be_port) {
> +        rebind_guest_port(s);
> +    } else {
> +        alloc_guest_port(s);
> +    }
>   
>       trace_xen_primary_console_reset(s->guest_port);
>   
> diff --git a/hw/i386/kvm/xen_primary_console.h b/hw/i386/kvm/xen_primary_console.h
> index dd4922f3f4..7e2989ea0d 100644
> --- a/hw/i386/kvm/xen_primary_console.h
> +++ b/hw/i386/kvm/xen_primary_console.h
> @@ -16,6 +16,7 @@ void xen_primary_console_create(void);
>   int xen_primary_console_reset(void);
>   
>   uint16_t xen_primary_console_get_port(void);
> +void xen_primary_console_set_be_port(uint16_t port);
>   uint64_t xen_primary_console_get_pfn(void);
>   void *xen_primary_console_get_map(void);
>   

