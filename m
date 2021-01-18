Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA342F9C9A
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388722AbhARJ7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 04:59:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389204AbhARJpj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 04:45:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610963052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=juo0Knj0PHakqWhUiaclcX3+DfYXH1XU/VqsFKd99hE=;
        b=WAhIyCwDpeMRkvyIJzaYyyEKUVZ96OTUEcpcP42edMvPPfFXkRYijsjOeUCxa9CbS7GgH4
        vSK+HwQP7cVINSKgLZqLvLU00hGoGCCxGrXkGlksYojDr4FSl8nh49gwnILztj9KIvh/Fc
        7ZdrUuOizWK4ZhW1fzmeOD3ygxTvBGM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-ABehqz_KPsOmk5usms5W5g-1; Mon, 18 Jan 2021 04:44:07 -0500
X-MC-Unique: ABehqz_KPsOmk5usms5W5g-1
Received: by mail-wr1-f69.google.com with SMTP id o17so8024519wra.8
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 01:44:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=juo0Knj0PHakqWhUiaclcX3+DfYXH1XU/VqsFKd99hE=;
        b=BRXOzO1VcbzX8HnwGiWiajonskjJA9NaQAxOP6TnJ5/6YzdmgZITsmn0Mk+eHbbIez
         WWUn5qvQoAQtT47vVBkPD0Kvn1grgC7lsXXiRf4WKev7xe+btzYuJRACqVDpIbLp6SG4
         K4uj2Eu2LRtXKOFKt97pOmO64nWpmwKezud9EzDBwn1KkKGxA29o4HF+tstNRHG9t798
         DALU6FlnZ/mCiW02DWvJnRNGG7varvA4CZKlmivX1ZI7Ibaqbtk5D6mLKFYZZ8JG7Gd8
         LQMkkelqK3rClohZCdqJ73k4+77X6xA8Y9DM0lUlyjPcXzP8X07pMiULCc4zAeqQK4zh
         kitQ==
X-Gm-Message-State: AOAM531dC5+qvhfziVAcPy8+Tv5r0Us2n+XrFw147xHKt2oyWW5cOuwR
        9EZ7sNTB/pMiHVBf2/JYHFb8fcrnpNWoY8kgz1DLhifhKSsquun0pMPvkmPR1xgMDdr8XEgMdUc
        1OeiqyJQTjZmE
X-Received: by 2002:adf:9427:: with SMTP id 36mr15289179wrq.271.1610963046450;
        Mon, 18 Jan 2021 01:44:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyc0jqY2v+rKGRN12C2mn5NX35ITrXn7MgCfzcumIjwfhKN5BoFzagIIQOvkpADuYMLfr67wA==
X-Received: by 2002:adf:9427:: with SMTP id 36mr15289172wrq.271.1610963046339;
        Mon, 18 Jan 2021 01:44:06 -0800 (PST)
Received: from [192.168.1.36] (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id c78sm25377725wme.42.2021.01.18.01.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 01:44:05 -0800 (PST)
Subject: Re: [PATCH v2 4/9] hw/block/nand: Rename PAGE_SIZE to NAND_PAGE_SIZE
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
 <20210118063808.12471-5-jiaxun.yang@flygoat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <537e90d4-8c14-0338-0b4c-ee26caced113@redhat.com>
Date:   Mon, 18 Jan 2021 10:44:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118063808.12471-5-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/21 7:38 AM, Jiaxun Yang wrote:
> As per POSIX specification of limits.h [1], OS libc may define
> PAGE_SIZE in limits.h.
> 
> To prevent collosion of definition, we rename PAGE_SIZE here.
> 
> [1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  hw/block/nand.c | 40 ++++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
...

> -# define PAGE_SIZE		256
> +# define NAND_PAGE_SIZE     256
>  # define PAGE_SHIFT		8
>  # define PAGE_SECTORS		1
>  # define ADDR_SHIFT		8
>  # include "nand.c"

Why not rename all SIZE/SHIFT/SECTORS at once, to avoid
having half NAND and half generic names?

