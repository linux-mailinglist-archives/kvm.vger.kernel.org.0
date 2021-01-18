Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605D52F9C9D
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389421AbhARKBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 05:01:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389058AbhARJmv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 04:42:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610962884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AS4KzKOJ0cVVXMB6IwF7klX32A2gREYdrqbMEnGdHOs=;
        b=MfrEAzc2mKU7nWI3+G404u5oGOQipNxpuuc2xRJeXJ3vpYynKW+2H+uQWcuBnftBPgP9ZK
        2ytu0ff0fNBNeY7tAZj0V6eRCM1lH4vtkDWjAWz9Oz7okViBrb9Ymhw9HvF4HK6nG5R/Xr
        wm8pwm7vPLi29m9cSnvWVCYJv7w9QMw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-2cnFUOqJPtW0KvpMEnQ_Cg-1; Mon, 18 Jan 2021 04:41:22 -0500
X-MC-Unique: 2cnFUOqJPtW0KvpMEnQ_Cg-1
Received: by mail-wr1-f70.google.com with SMTP id v5so8029809wrr.0
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 01:41:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AS4KzKOJ0cVVXMB6IwF7klX32A2gREYdrqbMEnGdHOs=;
        b=afgwA2bQjFI1Vn3mYF5qRgZ4mWW5PB1Xyju8/VksHT+xnCLg10g93B0jRlCwDJCPtw
         quU9k2J2Zrq9HP2xyvdWilhPAKFoxCxH5OhjWLohIcAX9zFhqhJnGpzLCIs8FxcQJOG3
         2oZvcOQkLKfcMl215YS02FAoF7XPtFtDEhmQPAlgFQTuMupj+wJF9q9ISyQp1P6nbRL7
         65H5rUG+oTQjp6UE5nNipkeLITr5pw1V57B9biJsqaK6qHnwylY5FZquTJe942n+s3QO
         jRcmvXTVBH7iq3tn5STKuoqz+z2h0kWxNfbATz6DQgg91gXgrcuIXmeuogZdZpGy8eBK
         61eA==
X-Gm-Message-State: AOAM530ON5fN/yVKqghsallHQX3CLbReReeIyVVtDWqv18AOjvOKMrNI
        YIK0jtC2U2BTOKLXEh35YduJ2M+2X249kxLMa20RVid0waS2Gq8/AMRf0RzznRa+mmncH1PYqTp
        AKe/Qf/h0qzut
X-Received: by 2002:adf:b781:: with SMTP id s1mr21050171wre.290.1610962881769;
        Mon, 18 Jan 2021 01:41:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2Oo2/AneHcPKIpu5/8J8qKp39igwQWmLm5ZZWFuFtdvlChiLOzc/BPuDuIGUfn1ZqbB+RSA==
X-Received: by 2002:adf:b781:: with SMTP id s1mr21050157wre.290.1610962881664;
        Mon, 18 Jan 2021 01:41:21 -0800 (PST)
Received: from [192.168.1.36] (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id 62sm5847482wmd.34.2021.01.18.01.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 01:41:21 -0800 (PST)
Subject: Re: [PATCH v2 2/9] libvhost-user: Include poll.h instead of
 sys/poll.h
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-3-jiaxun.yang@flygoat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <eae88670-9f5b-09ef-dcfb-6e4f00d0011a@redhat.com>
Date:   Mon, 18 Jan 2021 10:41:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118063808.12471-3-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/21 7:38 AM, Jiaxun Yang wrote:
> Musl libc complains about it's wrong usage.
> 
> In file included from ../subprojects/libvhost-user/libvhost-user.h:20,
>                  from ../subprojects/libvhost-user/libvhost-user-glib.h:19,
>                  from ../subprojects/libvhost-user/libvhost-user-glib.c:15:
> /usr/include/sys/poll.h:1:2: error: #warning redirecting incorrect #include <sys/poll.h> to <poll.h> [-Werror=cpp]
>     1 | #warning redirecting incorrect #include <sys/poll.h> to <poll.h>
>       |  ^~~~~~~
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  subprojects/libvhost-user/libvhost-user.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

