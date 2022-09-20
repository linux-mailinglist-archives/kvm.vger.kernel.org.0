Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291D95BDBC4
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiITErd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiITErc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:47:32 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D8C5853E
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:47:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id h130-20020a1c2188000000b003b4cadadce7so4779026wmh.3
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=KtR01irQlKfoVSoywg7Q8i2vGYnSpe0gOOi9G0TIGZk=;
        b=iy+ELMmiklQjwT1+jywydBJ5+uxMHApNzethnZSDLsOLcpqYwTl/L3jMA4qoDz8Vgt
         w+Zblb3q8eecZv5hoyVTkxAUKOUB7SjAcJt3mU0KYDPm/VaDxqRWiQ0wC9/zbVrZZis7
         j9gdYkWkuaAmuo0z60zuslsYYToAfBKPXwZmVQJBEG5mP6JtBMvspJdkUhGczPVSyVLW
         AMWpvBS0kLE3Jl8TbBbkf0NLUdIlCsuxnOQtGToWq/POoImJ6W1ldYQRqwX3nm/fduu3
         H7pHiAfteys/6W/f75pZmmz+EK8R5Vq1pd/eDZvZGiBh7iRrJr8vbFyQVn5huf1FeiG9
         ojLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=KtR01irQlKfoVSoywg7Q8i2vGYnSpe0gOOi9G0TIGZk=;
        b=jdW2tDMsXUZdYHEzJ4Q2L1uKhd2lN79UxALtIzW7Jr6t8Etn3BxLBXY8tQfB9wmcwR
         MohV9fDkOhNQN+YQliA1t5gFC9cMqRejy+wWSzkooDWhMfG456QM7jL9mCsv+1McfX9u
         g2meUaS+eLpnmUN4w5mKSdb91pQrCjdSDiM044UgS2sxQ43CQm+n77SRkngHSlXzoaaO
         Z6RMv8BpfLLaxvOWIlF8UnGgovCbZTHzHF3dangklwDZcu3YVlFSr0vYCgsMjdDF83ky
         PWYEttFfnXg5wmGxJU/GoLamwt5uAF9B0Y4LS6V1LiTSqSjAa7fX9lM/O9+hQp/CisbQ
         IY+g==
X-Gm-Message-State: ACrzQf2tOI6YPHbbyAbonUdY2fQbT19cVx9sCJmVUrnJqBNQ3UHw8SHJ
        kyPkEmDBcIwwWFme8p7pads=
X-Google-Smtp-Source: AMsMyM6/3r6XZlxjTcSgaP6bxzxf2Ik/wGOXJdYrZFcBlYSJNyYytY3sWi+uthO+WMCqXKrc3KkApA==
X-Received: by 2002:a05:600c:3b94:b0:3b4:9cdc:dbd4 with SMTP id n20-20020a05600c3b9400b003b49cdcdbd4mr887376wms.159.1663649248092;
        Mon, 19 Sep 2022 21:47:28 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id t17-20020a5d6a51000000b0022a3517d3besm422533wrw.5.2022.09.19.21.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 21:47:27 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <86328362-ec6c-8ff5-7533-321f2eef86fe@amsat.org>
Date:   Tue, 20 Sep 2022 06:47:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 1/9] hw/riscv/sifive_e: Fix inheritance of SiFiveEState
Content-Language: en-US
To:     Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org,
        Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bandan Das <bsd@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Sergio Lopez <slp@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Cameron Esfahani <dirty@apple.com>,
        Michael Rolnik <mrolnik@gmail.com>,
        Song Gao <gaosong@loongson.cn>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Greg Kurz <groug@kaod.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Peter Xu <peterx@redhat.com>, Joel Stanley <joel@jms.id.au>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        qemu-ppc@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Helge Deller <deller@gmx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        qemu-riscv@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Alexander Graf <agraf@csgraf.de>,
        Thomas Huth <thuth@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Eric Farman <farman@linux.ibm.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Alexander Bulekov <alxndr@bu.edu>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        xen-devel@lists.xenproject.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Snow <jsnow@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair@alistair23.me>,
        Jason Herne <jjherne@linux.ibm.com>
References: <20220919231720.163121-1-shentey@gmail.com>
 <20220919231720.163121-2-shentey@gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <20220919231720.163121-2-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/9/22 01:17, Bernhard Beschow wrote:
> SiFiveEState inherits from SysBusDevice while it's TypeInfo claims it to
> inherit from TYPE_MACHINE. This is an inconsistency which can cause
> undefined behavior such as memory corruption.
> 
> Change SiFiveEState to inherit from MachineState since it is registered
> as a machine.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   include/hw/riscv/sifive_e.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/hw/riscv/sifive_e.h b/include/hw/riscv/sifive_e.h
> index 83604da805..d738745925 100644
> --- a/include/hw/riscv/sifive_e.h
> +++ b/include/hw/riscv/sifive_e.h
> @@ -22,6 +22,7 @@
>   #include "hw/riscv/riscv_hart.h"
>   #include "hw/riscv/sifive_cpu.h"
>   #include "hw/gpio/sifive_gpio.h"
> +#include "hw/boards.h"
>   
>   #define TYPE_RISCV_E_SOC "riscv.sifive.e.soc"
>   #define RISCV_E_SOC(obj) \
> @@ -41,7 +42,7 @@ typedef struct SiFiveESoCState {
>   
>   typedef struct SiFiveEState {
>       /*< private >*/
> -    SysBusDevice parent_obj;
> +    MachineState parent_obj;

Ouch.

Fixes: 0869490b1c ("riscv: sifive_e: Manually define the machine")

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
