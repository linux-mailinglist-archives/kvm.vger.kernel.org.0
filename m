Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD76740067D
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350352AbhICUWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350319AbhICUWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:22:50 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90442C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:21:49 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q14so342347wrp.3
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mnk5zSmpT/p699xgSKxNbIV/1GCHbsuA6wEF56QNf+E=;
        b=GhgL9+LGgM+gjslEr/EdoI7/xsxfmmw67TehO/6U7pPlE/OPtA9LjE4SDDmXvYLAmN
         yZeX0gl3cDixUofaJ53d7PYirmx3VephL7Fp2AHgbYGFY+2vJtFBsCzJiTNZI+nj8zOU
         lX3C3n2CsiqPN2JfeGez5wPcTov60f+AYR19eDiQGHsrHnbpM5alfslIIIHhsT0nTxma
         DXlSCsL0edylOOeUn7jofbIz89KxP2tF8ZT5uMLxWfF0tNPmLeVePpEpIaz8SindXxiw
         pPRklR9Iklk2ipRx/ia9X3h7Q3ffP7aRj506nP6FYfGI6tshEguc/NBqS4OKI2Ci9Ann
         FGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mnk5zSmpT/p699xgSKxNbIV/1GCHbsuA6wEF56QNf+E=;
        b=HYj4T/4NcASDo/JG9RP/sBgVDcR73w82bEL8IVos7SjkbYig/SGksFeAA1fP4+QigK
         ZKCw/HdgWP91eK63Gdt7fJgxTn07Ci0VNxA1uP9NtpmHIsUPjp6NE6fSWkf+ePFjRjCp
         D/3dsR0gaO55I/H/aD3+nZ/tOzos+tVsdv1zSqBO0JN30XF3ESuvQunGQ2zgtKEvuPhS
         tC1DG48IcuCAAAhud5Y5cS531AD8Tv0yYzwEUXd6tzFpRHvwnf8O281P+fCRWnTzQA3w
         GxKcV7HFvAcsG71fVNNwQw6AazNor268WLUkXH59qYj9hwlLn9E9ppv7ch5FfKGuj5rN
         t9qQ==
X-Gm-Message-State: AOAM530q5QW8dnVVRGR9FddWBh6Ff4gSqjqTDG6jMvvRrkN7t3mIQaPp
        ccltzi4Dy5Y/ylv/CL4dqkZnjhPVObX1FR/zF5o=
X-Google-Smtp-Source: ABdhPJwPe1mnKhrxerAyhvhbZ2seI44kln/Bm0nN+tszrWb4ThZb+maUMAoke8HDY1589uhlj92r0g==
X-Received: by 2002:adf:8b03:: with SMTP id n3mr768062wra.439.1630700508096;
        Fri, 03 Sep 2021 13:21:48 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id r15sm402884wmh.27.2021.09.03.13.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:21:47 -0700 (PDT)
Subject: Re: [PATCH v3 12/30] target/hexagon: Remove unused has_work() handler
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kurz <groug@kaod.org>, haxm-team@intel.com,
        Kamil Rytarowski <kamil@netbsd.org>, qemu-ppc@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>, qemu-riscv@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Chris Wulff <crwulff@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, qemu-s390x@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Paul Durrant <paul@xen.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        xen-devel@lists.xenproject.org, Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Stafford Horne <shorne@gmail.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, kvm@vger.kernel.org
References: <20210902161543.417092-1-f4bug@amsat.org>
 <20210902161543.417092-13-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <5c91731f-a11c-3555-93d8-cd3379fb727e@linaro.org>
Date:   Fri, 3 Sep 2021 22:21:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-13-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> has_work() is sysemu specific, and Hexagon target only provides
> a linux-user implementation. Remove the unused hexagon_cpu_has_work().
> 
> Signed-off-by: Philippe Mathieu-Daudé<f4bug@amsat.org>
> ---
>   target/hexagon/cpu.c | 6 ------
>   1 file changed, 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
