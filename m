Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3212F9C94
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388855AbhARJuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 04:50:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389067AbhARJnJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 04:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610962896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RK/GHwVnIsKFl5HYTBp/hacekTXz1maNcQXoruESCDo=;
        b=EA1oQCbz1WU9SQe2MnB1X+KIQlw+4FfUsh42tbN4zNacgZBWd+XGY/6/IVkXQ/Mu8fm5eD
        hTIL0jqDj1pS3l31GAAtIqr7sGja9+xjvJ7BO1Nl7z+8MXLRK9KhDrhvy+N5J++Vj+sru+
        ikqcZPcCHtDkKr+OTZobAuzoaze8sL4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-Ri2QYFnBNpe9dz6ZdbHq5g-1; Mon, 18 Jan 2021 04:41:33 -0500
X-MC-Unique: Ri2QYFnBNpe9dz6ZdbHq5g-1
Received: by mail-wm1-f69.google.com with SMTP id n17so97967wmk.3
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 01:41:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RK/GHwVnIsKFl5HYTBp/hacekTXz1maNcQXoruESCDo=;
        b=q43KXcVBV4u1sUgJ1Xm1Zu1CljRqi3xwzEU6ykq0yLYIEsotrrfVQ9ZvNsjSdOaPNj
         YWrjyj7xtgWRnJASdXYlH8vWNQdmaduycAN/fnNspOXzFgz5D0q9jwST5JmzIdaXcTyA
         QlRUKuLPTk5U3sGDGyX1DOWJ+K74UyrQqXmPH9sDs//0bOsrLJxfgea/imOl1dUuZ3Il
         W1wiJxyoU4CEr6Yq89Higuk0P6Ov4Y73s+9C4rjKEo+P0S6Bk4UBkTTjTDx18LiQgU5E
         Ed3KKmf/s+GL7Z5Fnj1+tnFh5G/hjTo7WNr7J7rfV2v57wJsjVu0Zy4A4R+VF7kR3rDS
         JPew==
X-Gm-Message-State: AOAM532vf0v1x87T92yHI+kvbRuKVGkZdNdIHxEA/gwCgpvG6XTEZIGr
        9szBT2QZcX2rSHj/jE7xO/HK0kLW5Ygkv6ESMqS7oEsQLXOaus676LW1TmI7ANLA4A77i0AkF3e
        K+q2wgx+F5Is3
X-Received: by 2002:a7b:c849:: with SMTP id c9mr19706458wml.11.1610962891962;
        Mon, 18 Jan 2021 01:41:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBvRFWZht/IHZvozu0wO6u/1uswFcf9xvWp4osS0W4KzXLCffBO3VyCqDeYcPFpuuEvRlgoA==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr19706453wml.11.1610962891842;
        Mon, 18 Jan 2021 01:41:31 -0800 (PST)
Received: from [192.168.1.36] (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id o124sm26126427wmb.5.2021.01.18.01.41.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 01:41:31 -0800 (PST)
Subject: Re: [PATCH v2 3/9] osdep.h: Remove <sys/signal.h> include
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
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Michael Forney <mforney@mforney.org>,
        Eric Blake <eblake@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-4-jiaxun.yang@flygoat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <f1ea6ea8-0ade-6f6f-ff30-99c0df6bf82b@redhat.com>
Date:   Mon, 18 Jan 2021 10:41:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118063808.12471-4-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/21 7:38 AM, Jiaxun Yang wrote:
> From: Michael Forney <mforney@mforney.org>
> 
> Prior to 2a4b472c3c, sys/signal.h was only included on OpenBSD
> (apart from two .c files). The POSIX standard location for this
> header is just <signal.h> and in fact, OpenBSD's signal.h includes
> sys/signal.h itself.
> 
> Unconditionally including <sys/signal.h> on musl causes warnings
> for just about every source file:
> 
>   /usr/include/sys/signal.h:1:2: warning: #warning redirecting incorrect #include <sys/signal.h> to <signal.h> [-Wcpp]
>       1 | #warning redirecting incorrect #include <sys/signal.h> to <signal.h>
>         |  ^~~~~~~
> 
> Since there don't seem to be any platforms which require including
> <sys/signal.h> in addition to <signal.h>, and some platforms like
> Haiku lack it completely, just remove it.
> 
> Tested building on OpenBSD after removing this include.
> 
> Signed-off-by: Michael Forney <mforney@mforney.org>
> Reviewed-by: Eric Blake <eblake@redhat.com>
> [jiaxun.yang@flygoat.com: Move to meson]
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  meson.build          | 1 -
>  include/qemu/osdep.h | 4 ----
>  2 files changed, 5 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

