Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC9364EF38
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiLPQe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiLPQeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:34:15 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979483885
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:34:14 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id v19-20020a9d5a13000000b0066e82a3872dso1667466oth.5
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P2e7AtmItaDVcZaaxrpoeObvU+3azD/QhwCEZ5e4+FY=;
        b=bc7oZhD4qn6w5YgbGlSb0r/KBfW+eMLS1ApsLfGNPDBjMZc2OVWb031cBzF2Ol4Kl6
         OjtcIbuGUXhUuHDWIgkDVU6w4oMeL1iAUe5HfhJr6ZtcJ+3//QZYGi9SPbSpCtGaw8NO
         +kbBdIgxDvlCnrIl/iazViJzk+cXpCASQtcu4n6i2h7tBR/jOFgjLWV0Ibua7vUIhv60
         Xrk+3lpVF3kuuAybLft6gpc3HY1emKDRZju2B/AYIW47oAGGWnPTttZ6g8np/3dTSNRN
         X/A1H0CWgtM1y51Ywg0GfqHzc0651fq+fZQGYkO7qAj6BY1JhROOxYWTTteLXgk/v6ag
         t0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P2e7AtmItaDVcZaaxrpoeObvU+3azD/QhwCEZ5e4+FY=;
        b=Id3BvbZZ/tQSyMlJY0HlN96xDjzVWeD/++UxlKD7RNGUUi03Uppanw0phs+//3AyVm
         XxklcqPIDaK9MFpZICnxU55Tv2uip14fIsG7vVcVmSQiY0nBoLVlKaSlsrgMNh2slv0w
         gwUT9ZZhfW2LD/yohemvQRof0aV/kFnhWW8E1amKrK8XK6XRBbuIzAD++SvPMNebiaj0
         gBtsXkvsiPSYyxoCvB4G1GxZ/IRlAcEpfwiYjL9+RpswsXSe8e9AEFxIsEe3OosXyAjg
         96bEe57aeyYPsYM8Vb4zCnMWsQgYRq/E9Jok4Ixq19hbSqjGfhc7o/280w5ldjNPB/am
         Zbaw==
X-Gm-Message-State: AFqh2krNGjNxhdN3rttFDPoe2a664Uo1nNkPQD9GnbR+CYgu6b/tx2T+
        GhDkq4h2PyCWVueafSaqQl4=
X-Google-Smtp-Source: AMrXdXs+2OkfmuHGpgYpx2jvQTw3h72iszdz45Si5eBCPO21IKfn1pl2Yxs2wuJ228X+S+ojkxAyxA==
X-Received: by 2002:a05:6830:93:b0:676:1802:661f with SMTP id a19-20020a056830009300b006761802661fmr2048378oto.25.1671208453875;
        Fri, 16 Dec 2022 08:34:13 -0800 (PST)
Received: from [192.168.68.106] (201-43-103-101.dsl.telesp.net.br. [201.43.103.101])
        by smtp.gmail.com with ESMTPSA id u19-20020a0568301f5300b0066da36d2c45sm1022445oth.22.2022.12.16.08.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 08:34:13 -0800 (PST)
Message-ID: <667d1c5c-19fc-c5f0-2474-519230ae8a94@gmail.com>
Date:   Fri, 16 Dec 2022 13:34:09 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH-for-8.0 3/4] hw/ppc/spapr: Reduce "vof.h" inclusion
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
References: <20221213123550.39302-1-philmd@linaro.org>
 <20221213123550.39302-4-philmd@linaro.org>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20221213123550.39302-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/22 09:35, Philippe Mathieu-Daudé wrote:
> Currently objects including "hw/ppc/spapr.h" are forced to be
> target specific due to the inclusion of "vof.h" in "spapr.h".
> 
> "spapr.h" only uses a Vof pointer, so doesn't require the structure
> declaration. The only place where Vof structure is accessed is in
> spapr.c, so include "vof.h" there, and forward declare the structure
> in "spapr.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>

>   hw/ppc/spapr.c         | 1 +
>   include/hw/ppc/spapr.h | 3 ++-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index 66b414d2e9..f38a851ee3 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -62,6 +62,7 @@
>   #include "hw/ppc/fdt.h"
>   #include "hw/ppc/spapr.h"
>   #include "hw/ppc/spapr_vio.h"
> +#include "hw/ppc/vof.h"
>   #include "hw/qdev-properties.h"
>   #include "hw/pci-host/spapr.h"
>   #include "hw/pci/msi.h"
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 04a95669ab..5c8aabd444 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -12,7 +12,6 @@
>   #include "hw/ppc/spapr_xive.h"  /* For SpaprXive */
>   #include "hw/ppc/xics.h"        /* For ICSState */
>   #include "hw/ppc/spapr_tpm_proxy.h"
> -#include "hw/ppc/vof.h"
>   
>   struct SpaprVioBus;
>   struct SpaprPhbState;
> @@ -22,6 +21,8 @@ typedef struct SpaprEventLogEntry SpaprEventLogEntry;
>   typedef struct SpaprEventSource SpaprEventSource;
>   typedef struct SpaprPendingHpt SpaprPendingHpt;
>   
> +typedef struct Vof Vof;
> +
>   #define HPTE64_V_HPTE_DIRTY     0x0000000000000040ULL
>   #define SPAPR_ENTRY_POINT       0x100
>   
