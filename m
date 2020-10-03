Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03EF2822F1
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgJCJNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJCJNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 05:13:20 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE1EC0613D0
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 02:13:20 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id y25so984069oog.4
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 02:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V+N6roBMczoEkvPQ/1usVDxzLXsrnEaEaI6P98ExkN8=;
        b=awPMnOdq1T4kpdut+GKLndz1VMH3tU2JmzebXVpH05JbWXk7EoVLkSYl8ZnXq6eU48
         bDayG73Ko/u7QHfYe6uxBIoDoX7Nbigndip70Vq5hmz46vDAhcNGmdn/z5iXMTvYggbf
         3pLgIHGCxbBRAIc+CH8Ais12lN9xMhbBPYEZNOZk2yAmXy5F2ezPQtpdG0aOsKFjgSC8
         imSOaI9gf4lF+cYjtC4xyUXIPpG7/DhHd9wO0WhVZ2FWV4NY+yGOVBTUipZEDGSDjsdn
         nrOVgO7gImyrafJVHirXd+QwElxd4DGscn38ywe0xXikkZYkyU36V1tInwbz9V93vO9Q
         LiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V+N6roBMczoEkvPQ/1usVDxzLXsrnEaEaI6P98ExkN8=;
        b=Xs8s87JMTAYoVLou85M68M4LHgYvl3CAj33oAPxBiZL0Wpj+c0++qxOvgvv1oEEEnY
         ZEJkqWx33OCu8qLqvPsKcgOpe0m+OEnm2n8+9v1bMX/CNpwdlgA+1M+PYmakDYIP1YY6
         1wGSUx7kpbjkmnF8tpXWgz6W7DP9oioJ3jT5weDJnlVPrUlxsNZ2xP0/tCW6oDPma86s
         uqKWhqcjT39c055jIIYkEOYeJXopds3CGnJDp7dblFkkEqdsEwM7UFqdzb7+Y3QRSGbf
         hqpVU7kh/xAlvtUcs98fYea0BxPkKcatWNIPMe0pGCkOSRobxtb9DQclEkYAyGyhSUkR
         ZyrA==
X-Gm-Message-State: AOAM531Cvj6eY4VSQt4q/T410Q/wIO94kxgWPtnN92zluGtTPPlykhI2
        6dKzyfSsjN58PyF5z9HkUnDGEw==
X-Google-Smtp-Source: ABdhPJwDyS+3vQCCE/z6hQPZsQUkioDfS81B5I/mwT+QjHwuP7aEz8vec/vBRXJPG9lK5OrPrnuzEg==
X-Received: by 2002:a4a:d38c:: with SMTP id i12mr5006756oos.81.1601716399988;
        Sat, 03 Oct 2020 02:13:19 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id n23sm132277oon.14.2020.10.03.02.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 02:13:18 -0700 (PDT)
Subject: Re: [PATCH v4 02/12] meson: Allow optional target/${ARCH}/Kconfig
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-3-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <31a173bf-6aa3-1ce8-7d14-5e8f11e2a279@linaro.org>
Date:   Sat, 3 Oct 2020 04:13:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-3-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
> +++ b/meson.build
> @@ -529,6 +529,7 @@ kconfig_external_symbols = [
>  ]
>  ignored = ['TARGET_XML_FILES', 'TARGET_ABI_DIR', 'TARGET_DIRS']
>  
> +fs = import('fs')

Note that I have this in the capstone update, and I placed it closer to the top
of the file with some other imports.


>  foreach target : target_dirs
>    config_target = keyval.load(meson.current_build_dir() / target / 'config-target.mak')
>  
> @@ -569,8 +570,13 @@ foreach target : target_dirs
>      endforeach
>  
>      config_devices_mak = target + '-config-devices.mak'
> +    target_kconfig = 'target' / config_target['TARGET_BASE_ARCH'] / 'Kconfig'
> +    minikconf_input = ['default-configs' / target + '.mak', 'Kconfig']
> +    if fs.is_file(target_kconfig)

Missing a meson.current_source_dir()?
Leastwise that was a comment that Paolo had for me.


r~
