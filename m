Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AF031FEB8
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 19:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBSSVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 13:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhBSSVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 13:21:03 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79ADC061756
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 10:20:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o10so4834270wmc.1
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 10:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QWLOIiitmqBo5+3UaA0iJ43f4RC209g18TM/vosn6KU=;
        b=POVBAu9h6VXtheGXvk2NfpN7VuXcoirzXDBHZeSRMcMGwnLtXNDmDnbRloswSncCiu
         UUBmOonAiKAxfUdgfpFKvVHNlcCFmDWcmG8TCbHlREKDdpiW5tij6aSeDioQohoQDmeC
         l2FziYTXDZmhyOPKjnAEbFWKjYxdlG6G3js9cUC1ajMTGuLS3fEZNPbSMl5onWT1CxdM
         Q2YUQQV7bJTmWqgCLcKw5KDw4nOFUtWukP3ASDJiAqkYmBSvJTP2EuipIaJIBK23iSfg
         JQjIFR1ep2dPw3zIHeetdBiKkyAERCkBqJuP8d2NkTJ+YjJg4vONwd4TsJwMnLvHRhe0
         xrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QWLOIiitmqBo5+3UaA0iJ43f4RC209g18TM/vosn6KU=;
        b=bdKr1zfVWPK3VJxTd3MIyJHatMJQKa/RLVZduII2XPfL/UvxdfWA8oq6b28zwZB7H4
         KMR0KrubWhLhBQhaf8NWQ/psKCQ/rBrvPOFxfdn72lcx4n3ZSyZXzTeDRwIhbbkUpf4J
         vRaUUWQhkklCz0nUfBkSBG4ifXErdIwuS/59mLrjjX5Ggzfm/18uq+qFA6ujzSR1OI2z
         qEENOQeis7+H+k20tUV7ReTQqXkvg7SlQ5JiX9Nm8MT6l+DjDIX9sfUOixKHVQYvo0eK
         itnNWOT6fh/Odbx67GD+zE6hvyYZKVgCyZR/ZLMIwRRfVif5OXvGz7fDgSaMCEBZa1MM
         hSKQ==
X-Gm-Message-State: AOAM533MnC6UrpFNNb7rvqOIzOeAUCtzw86f6hAmQHigNVpyusZPbG//
        pOR41V78Uhgpvbwc2OciE64=
X-Google-Smtp-Source: ABdhPJyPeyLs0ufJRIjEcmZzmn8XKM8ztr4zDFZnUaEnnHiY3eTI/16kdMKEeG8iwgyT/uZdHskVEw==
X-Received: by 2002:a1c:a795:: with SMTP id q143mr9362251wme.113.1613758819494;
        Fri, 19 Feb 2021 10:20:19 -0800 (PST)
Received: from ?IPv6:2a00:23c5:5785:9a01:101f:7370:9e02:844f? ([2a00:23c5:5785:9a01:101f:7370:9e02:844f])
        by smtp.gmail.com with ESMTPSA id y16sm14031151wrw.46.2021.02.19.10.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 10:20:19 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 09/11] hw/xenpv: Restrict Xen Para-virtualized machine
 to Xen accelerator
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20210219173847.2054123-1-philmd@redhat.com>
 <20210219173847.2054123-10-philmd@redhat.com>
Message-ID: <f386d7c4-f139-4f17-4e5b-5a3c5288b238@xen.org>
Date:   Fri, 19 Feb 2021 18:20:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210219173847.2054123-10-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/2021 17:38, Philippe Mathieu-Daudé wrote:
> When started with other accelerator than Xen, the XenPV machine
> fails with a criptic message:
> 
>    $ qemu-system-x86_64 -M xenpv,accel=kvm
>    xen be core: can't connect to xenstored
>    qemu-system-x86_64: xen_init_pv: xen backend core setup failed
> 
> By restricting it to Xen, we display a clearer error message:
> 
>    $ qemu-system-x86_64 -M xenpv,accel=kvm
>    qemu-system-x86_64: invalid accelerator 'kvm' for machine xenpv
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

Acked-by: Paul Durrant <paul@xen.org>
