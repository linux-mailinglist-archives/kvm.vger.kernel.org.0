Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97D95BDBE6
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiITE5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiITE5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:57:40 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6D058DDC
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:57:38 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n10so2274337wrw.12
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=sf+yjXUZ2IXukhH5UaeERJtNyhl+QRIlnvPlc0mykq8=;
        b=INBRXUtTn4f77El/2/P3WXjwa3VcUTxtrP1wFIDUvyAEGQuR4JdU8p5dXhkW+WOyoi
         aoucRXOyi92aAnFe7bOLEAZibHBlkHtvFejKVFbXmRBMjzPIh0QtKo5E1ehhEN3by8eV
         17JDnHMtDeKFLvdX8LOcEdcAGUaBlxldWLzJeEDB059E3k0gVClrPR8sLUj64MYCBXPW
         U4IWEn9NgUDZaS84v7Xcnwa8N50RXPQuuOzX7HKjzYTF1wFu0KvbUzVHydFrkNBQIdcj
         7SYes6exvX/5Vh89DdneU4padIai8aVEZ3yvM9L6bEsaMF8cH4VwUMhR2Fe4nYLK5lrT
         f3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=sf+yjXUZ2IXukhH5UaeERJtNyhl+QRIlnvPlc0mykq8=;
        b=bYzFwbSxfAJVMgylgKKldOc4OdGOFPbFNlrb8LgthoIhbcsI7CJwbPrveFqKIM6BeE
         qXwB34AWDve8H3/wnlCI3g7CmASBGkMh0XAlRI9ovOSkuCwBD+UCTKAuL4a3AAvopFtD
         H2hE+QXlj6wVfpdnGKcwVr3sJOFbu6NIDWZVfdnK7ay/3Tyo4oHGTrmOJ+09j7zDfJ3n
         4JUsKeM+nadLpQ3a2DZNaaAEj8SWWZYHevE9iLJ0hyxpUj7rD4du2FGWP1skckGL977U
         DmYPEccWUTNsuUleLdDRMxnB8Ahy4wMYpYE8OpR+6MrFXQCNLd6G+sMTTc9ZJ9PcBiUy
         SEeA==
X-Gm-Message-State: ACrzQf3P/cb7zFLJglbwgJKJsOC7jo1oJNLqVLGYYzZ3OfIdPTjMG9Wz
        S1bVnfwXy7Nq6hhYxl/8MSU=
X-Google-Smtp-Source: AMsMyM7xk9eQhMG0hy5vzO0uxqQyyAFLD2EaloYjIUcvuXMcivTCqCiOehaR1VmADyoWYmuRlw8Yow==
X-Received: by 2002:a5d:4d4e:0:b0:22a:e7fe:e3bd with SMTP id a14-20020a5d4d4e000000b0022ae7fee3bdmr9244091wru.311.1663649856601;
        Mon, 19 Sep 2022 21:57:36 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id c3-20020a05600c0a4300b003b47ff307e1sm749536wmq.31.2022.09.19.21.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 21:57:36 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <07db3f3a-90d9-c0db-df26-de7a667620be@amsat.org>
Date:   Tue, 20 Sep 2022 06:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 6/9] target/loongarch/cpu: Remove unneeded include
 directive
Content-Language: en-US
To:     Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
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
 <20220919231720.163121-7-shentey@gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <20220919231720.163121-7-shentey@gmail.com>
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
> The cpu is used in both user and system emulation context while sysbus.h
> is system-only. Remove it since it's not needed anyway. Furthermore, it
> would cause a compile error in the next commit.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   target/loongarch/cpu.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
> index dce999aaac..c9ed2cb3e7 100644
> --- a/target/loongarch/cpu.h
> +++ b/target/loongarch/cpu.h
> @@ -13,7 +13,6 @@
>   #include "hw/registerfields.h"
>   #include "qemu/timer.h"
>   #include "exec/memory.h"
> -#include "hw/sysbus.h"
>   
>   #define IOCSRF_TEMP             0
>   #define IOCSRF_NODECNT          1

Renaming the subject as 'target: Remove unneeded "hw/sysbus.h" include 
directive' and fixing target/ppc/kvm.c:
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
