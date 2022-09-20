Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1CF5BDBD0
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiITEvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiITEu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:50:59 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D553719F
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:50:57 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n10so2259785wrw.12
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=AOjdR7SFZiHY1uiELRpo0rpHv870srIhKUXZHTwkqUI=;
        b=MfFJU2m3Hp+LpkC7yASngF/y3vweUTL23ftLfII94KRq1fh9uTp6TvbPfhA5JM7g/4
         BVreu+b5bogN3xvS5EzGpIbQ3ng9dHhuRm5e0Vic64Hq0UMgtlOEtv6O2XVqLujTsiv+
         6KwJpHbGhyeJM9cFKDzK2kyye8yL1PlPeQc88f8cJP9g1alsMDm8NjaIbYUlA7jlTSSm
         LQm1oSmvlVAB4NutamOypWH24lc9dzVMwaSgX/dOayiJh8AZara/qgGIpz+9dkwcj6y7
         O5rpwXra/Dcl72TDHgcZpvuttTtBdPNyqw9sm6ljJOpkgbDiG4P62kLG+lMBo2jwJzze
         Fw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=AOjdR7SFZiHY1uiELRpo0rpHv870srIhKUXZHTwkqUI=;
        b=Mao+/Z95YMdHCN1Cb0DVyIOKE4N94mySARchu7gucedDRj9Btd/FWi977bo+pVqyAb
         Gxv5OKemJqSES2yzio8C/EdzsCvR7xKbazomBZ8xRHFShTQ2pAf0AmBPpdnOUdIq8Gxw
         k6/fIE33lXm/xgk7OsijgcfRjcFLQL+JbsajnMw4qUw1HnM15gVKYFIpqvvkKRxILERs
         WPjN5DpCqDA7OQMI6/SEIUJ8TEq6JSTMegqUZNXi3OZ8fuiCtctb1fs60QUVC8h6wr0a
         hMBuq8dcAIKS/Kz1PyrAehKjx/IyLFEAN5nRcfOyQapg+Fh5G/7aODbxWX5woV6B0++Y
         7GDg==
X-Gm-Message-State: ACrzQf0iYvO+dDSSGdiA41akpYmRNYfzVpxQvGqR4hN4Yc/ZhM0cOgvZ
        +iIOOJRyvUWJvnxRFX6IRF0=
X-Google-Smtp-Source: AMsMyM5Zw3Yb5SwTXaejaf1oX7/x3SNh9tZo3tfn0QC4ZXWZZxDxIYm9wdK1FGZNM51fQBEYeXIOWA==
X-Received: by 2002:a5d:550c:0:b0:22b:1942:4bf6 with SMTP id b12-20020a5d550c000000b0022b19424bf6mr190273wrv.520.1663649456084;
        Mon, 19 Sep 2022 21:50:56 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id f12-20020a05600c154c00b003a62052053csm20902170wmg.18.2022.09.19.21.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 21:50:55 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <3fcb707c-47c3-7696-86ec-62048e39bfe1@amsat.org>
Date:   Tue, 20 Sep 2022 06:50:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 2/9] exec/hwaddr.h: Add missing include
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
 <20220919231720.163121-3-shentey@gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <20220919231720.163121-3-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
> The next commit would not compile w/o the include directive.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   include/exec/hwaddr.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/exec/hwaddr.h b/include/exec/hwaddr.h
> index 8f16d179a8..616255317c 100644
> --- a/include/exec/hwaddr.h
> +++ b/include/exec/hwaddr.h
> @@ -3,6 +3,7 @@
>   #ifndef HWADDR_H
>   #define HWADDR_H
>   
> +#include "qemu/osdep.h"

NAck: This is an anti-pattern. "qemu/osdep.h" must not be included
in .h, only in .c.

Isn't including "hw/qdev-core.h" in "include/hw/boards.h" enough in
the next patch?
