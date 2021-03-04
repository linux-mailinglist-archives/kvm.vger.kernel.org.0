Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3A632DA5A
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 20:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhCDT0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 14:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbhCDT0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 14:26:41 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6E8C061574
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 11:26:01 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o7-20020a05600c4fc7b029010a0247d5f0so4996870wmq.1
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 11:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K1rMeJSzwzcq98KjXfKjITR3jsmxskM8W7FX7UnUdWM=;
        b=rs/4W8tPuM/MAzTPkgfenRbbFQ6m5CgD1CMLfCmkzwDx6edd20DBZfdu2FVs+csbW2
         zaW+sJs14dqT8/OldzMk4ZszUthHC5efW4jrHjLxIDbrbheBa9Zrrnl76WR6O0SWlg2g
         pnMG33E2WFIW20rwbZ8mYo6lpB8/Ol4fOCtTVL2TdIABnY6bUMeg21x0gmfS+dbBiViJ
         QFST5anZaibLJrEoTrdat03q2w50wJINbxElELmvcfRR8GtdCntct781h+3GVbUKB5l8
         co/VHfEmv0d1U6KrS43SFn3gzRcDBeVeu/C7Fd+T5w4FEUj4QMnq3bjcXBhdYQsJ746V
         M3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K1rMeJSzwzcq98KjXfKjITR3jsmxskM8W7FX7UnUdWM=;
        b=VfJPBH4E3ygz2h9ka6LehBMhmjRRkowm37fdH2Z4+YWCRCFAokXRdEvm4W0mTH+1Ql
         NTczFCJSNj6OIr03ZLLhMJSlGk3tLjVZLouLw+b6wU0UITXe8Fh98t8PQcIG3rBxNykt
         orXnkwuBjVjRgLITqjS9UEVsAPF8pHOEQBCskRf0M/Bn9fZ/LE/sUQy0l9pvLXFt2VcY
         R5PodOvCDagJg1+hDMPLer+PQKHOs19sIq/woL82Mb62v03wbZY1BPlWco4v0P5ncsZm
         JZZ4MLBUR1CAS5uQrV7QWDXfxL3WDARlE82fuB8xF/KGXdVmyVn9+erYwGvuRYtrJeUF
         gR9g==
X-Gm-Message-State: AOAM531VWx+6Zy+y0D+MrseKR+CQukyNFfm2E4qudNCsSE34ETak9NeM
        4hpGCeDwVJk1yUzd5y2l+NE=
X-Google-Smtp-Source: ABdhPJzXyamAlrjSNY+hfTRG5LpIrWByypnuH95AHlow2cjiddxnz8x8p06b5lPMQcGulA1U84Mr4Q==
X-Received: by 2002:a05:600c:22d9:: with SMTP id 25mr4561826wmg.108.1614885959999;
        Thu, 04 Mar 2021 11:25:59 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id i8sm332582wry.90.2021.03.04.11.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 11:25:59 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v6 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
To:     Claudio Fontana <cfontana@suse.de>, qemu-devel@nongnu.org
Cc:     Fam Zheng <fam@euphon.net>, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>, qemu-arm@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-4-f4bug@amsat.org>
 <1f571396-c225-0372-12f2-1a366ad181c7@suse.de>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <3c84ad2a-7fb9-241d-c0ba-81ff16269240@amsat.org>
Date:   Thu, 4 Mar 2021 20:25:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1f571396-c225-0372-12f2-1a366ad181c7@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/21 12:55 PM, Claudio Fontana wrote:
> Hi,
> 
> I am trying to take these patches,
> in the hope that they help with some of the test issues I am having with the kvm-only build,
> 
> but they fail with:
> 
> target/arm/Kconfig: does not exist in index
> 
> so I guess I need the "target/arm/Kconfig" series right, how can I find that one?

See the Based-on in the cover ;)
https://www.mail-archive.com/qemu-block@nongnu.org/msg79924.html

Regards,

Phil.
