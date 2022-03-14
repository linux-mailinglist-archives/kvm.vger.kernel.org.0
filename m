Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660914D8A13
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 17:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244526AbiCNQoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 12:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243795AbiCNQnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 12:43:15 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4959347ACE
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 09:41:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id rm8-20020a17090b3ec800b001c55791fdb1so7395999pjb.1
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 09:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W0zrBM+N0hxFD4HvfoclDpELnmJr/18GN6q0lPZatEw=;
        b=fmpUDGOi8OZUJgMmHkU4ZiecIW8QqM1a02qsRb5yuKVzZqkKGRd0gAv5AfPJZciLC2
         wyfwXolLcpsITp6G/VgGOl4n+QuCOLQk3Yq16Z7BHeO1D5wgcSAf/IDLm72KrjEXZHV/
         M4BRhf0N2E/JnyG/RHuUFZTe+nWC8OwxMU8ozx661gpkTL/UO2ghlDIt48sBGxo0Msdh
         /YNfia3uEbrZh1oI7H2fo/d1bB9/w6wpunLJALQRD5SqFqrj8TQigLM4Ted+4sWSxOKR
         FPVMqV/tM1261P8Mf1g7qtmMopnyahbNNaai7t7ssi2iWy+HgxXH9dvrAsqdbHKia6V5
         abag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W0zrBM+N0hxFD4HvfoclDpELnmJr/18GN6q0lPZatEw=;
        b=0vz37SNy2jacQF2Y2eEeiYoODJE7s4F+gcmqHZmQwuMZQ9AgQiLzogPMZdzcLpuU9f
         k2t/64SNqnZFXa+Y0vHPUPZjUYvZlgfpQg3HVPT0bkgbIV44UWn+TwelAzJYYWqBtFMv
         M3x+gfumj0xv6CJjPL7e8PyV0f17Kmen9uRCpBVNaJBTTrg4FT5oMDBIAqrAZAGrtX5h
         8VUZHDBy7Ffa2N7Mcf3TIaOSHdR1T+7MBPuqn8OnjaDzSALQwDOzYFRSBY6MxAhfzq4i
         /Qs2BMNJtj50/iaBZH3hAFMzKW4BzutF+D+nWHw6Zwpn/FU3oJE/H2ioxrszSmgZn9XS
         /Nag==
X-Gm-Message-State: AOAM530sQ/efz12GllIDDHWLeA5SYhU0tCHqp8k32TJV1Q83tEQOi6xX
        Ew5oJp4LWc79u1CIXaUe0Rc=
X-Google-Smtp-Source: ABdhPJwPi5HHkN9qRkorFbCauI5zttPHA5P4ioPiaxV0wCn1Jl6lXBIv9n8vWOh2Ce6Vb5rH2bPC8Q==
X-Received: by 2002:a17:90a:1b4a:b0:1bf:1112:5ef with SMTP id q68-20020a17090a1b4a00b001bf111205efmr36323pjq.143.1647276087626;
        Mon, 14 Mar 2022 09:41:27 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id s1-20020a056a00178100b004f731a1a952sm22043486pfg.168.2022.03.14.09.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 09:41:27 -0700 (PDT)
Message-ID: <8ac83023-3609-4b24-6ffc-9f93478ce69b@gmail.com>
Date:   Mon, 14 Mar 2022 17:41:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 0/3] Use g_new() & friends where that makes obvious
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, xen-devel@lists.xenproject.org,
        qemu-ppc@nongnu.org, qemu-block@nongnu.org, haxm-team@intel.com,
        qemu-s390x@nongnu.org
References: <20220314160108.1440470-1-armbru@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <20220314160108.1440470-1-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/3/22 17:01, Markus Armbruster wrote:
> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
> for two reasons.  One, it catches multiplication overflowing size_t.
> Two, it returns T * rather than void *, which lets the compiler catch
> more type errors.
> 
> This series only touches allocations with size arguments of the form
> sizeof(T).  It's mechanical, except for a tiny fix in PATCH 2.
> 
> PATCH 1 adds the Coccinelle script.
> 
> PATCH 2 cleans up the virtio-9p subsystem, and fixes a harmless typing
> error uncovered by the cleanup.
> 
> PATCH 3 cleans up everything else.  I started to split it up, but
> splitting is a lot of decisions, and I just can't see the value.
> 
> For instance, MAINTAINERS tells me to split for subsystem "virtio",
> patching
> 
>      hw/char/virtio-serial-bus.c
>      hw/display/virtio-gpu.c
>      hw/net/virtio-net.c
>      hw/virtio/virtio-crypto.c
>      hw/virtio/virtio-iommu.c
>      hw/virtio/virtio.c
> 
> But it also tells me to split for subsystem "Character devices",
> patching
> 
>      hw/char/parallel.c                       |  2 +-
>      hw/char/riscv_htif.c                     |  2 +-
>      hw/char/virtio-serial-bus.c              |  6 +-
> 
> and for subsystem "Network devices", patching
> 
>      hw/net/virtio-net.c
> 
> and for subsystem "virtio-gpu", patching
> 
>      hw/display/virtio-gpu.c
> 
> I guess I'd go with "virtio".  Six files down, 103 to go.  Thanks, but
> no thanks.
> 
> Since the transformation is local to a function call, dropping is
> completely safe.  We can deal with conflicts by dropping conflicting
> hunks, with "git-pull -s recursive -X ours".  Or drop entire files
> with conflicts.
> 
> If you want me to split off certain parts, please tell me exactly what
> you want split off, and I'll gladly do the splitting.  I don't mind
> the splitting part, I do mind the *thinking* part.
> 
> Markus Armbruster (3):
>    scripts/coccinelle: New use-g_new-etc.cocci
>    9pfs: Use g_new() & friends where that makes obvious sense
>    Use g_new() & friends where that makes obvious sense

Series:
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
