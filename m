Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A356400677
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350231AbhICUVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhICUVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:21:15 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1550C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:20:13 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b6so309956wrh.10
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xsif4pme6nhSpsi7vEWmXFg/Hnrb7mhQtjIRT3kxFkM=;
        b=muTFofn/yHs0EYKIsGha4ps6z/nsFLgk7o50hQ1bBL3mlCLJN3dqh2EbQA90EnwZiK
         NECjyG+jXGItzTA4QlZoqJEuj4/2GopLUtjAu+ncqdo/FFyEUWUPbBu236/GFMudcuCK
         D9DyjDbkUkta9IAKG6+3m2r8+8jv4lYsuurqFUi0rWz/gxe73U7hLmg/mrm5hqKdTbiF
         Opmfkr9N/UDCqcJTgk0JtowcRFkQ/LeFaRp+RBrZIUFfJTbIekWq6l07SbB0VGTU8eH+
         /SKP943AfE5+gEB6opgLoUtMGZRq5vBaEZuA49fASyXmNkP+xk+3PmUF6tFbonUn2CoS
         6yWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xsif4pme6nhSpsi7vEWmXFg/Hnrb7mhQtjIRT3kxFkM=;
        b=j5YPzZTZKjIgDJal829K0HOYxITzegsP1PEE88u9NYo0R24oa73s9JQXy2ViuE1uVL
         J459dE0k4iR9PBUhs24S5cVagO2FydljguzC5daCN0rAG5MVVtN1NXLU9i5fkUYCuCNO
         OZWdBip+lnCcN8Ex5OHLuNabg2k7pb0dhRP7wNWZHl0raKAU40BQee3Gw7aYJZZxae0G
         NEMojiOPKZlwaUgpjDRVjAfZXoxVMYiaLxcIU1rSgNjp8gVaZFac+Cr8GqceR9gvXmWj
         IScbcSfRbsPNVWoDEt3vxGYKkqIk6leVb0Jj2iSi99xAniha9qqvAVbLkRAcPuyuuBh1
         yWJw==
X-Gm-Message-State: AOAM530CbC629fv1629taWbODHjLqzz5sMZ0/+0raWpT8C3N6EeHaQbo
        M+y74Z/QXdzIiR4XXNQwCJ8xBHNfrTIoostAt8M=
X-Google-Smtp-Source: ABdhPJxCxEUNKk9CrXrBQLK7GjqB1EVrT8+iyYBGoXf53+iVgrOG7SDx81iHjmDeuA92Igp3EWy9+w==
X-Received: by 2002:adf:dd4f:: with SMTP id u15mr825520wrm.237.1630700412182;
        Fri, 03 Sep 2021 13:20:12 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id o8sm266012wmp.42.2021.09.03.13.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:20:11 -0700 (PDT)
Subject: Re: [PATCH v3 10/30] target/avr: Restrict has_work() handler to
 sysemu and TCG
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
 <20210902161543.417092-11-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <1833210b-e250-33f5-be38-9d543539b4aa@linaro.org>
Date:   Fri, 3 Sep 2021 22:20:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-11-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> Restrict has_work() to TCG sysemu.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>   target/avr/cpu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/target/avr/cpu.c b/target/avr/cpu.c
> index e9fa54c9777..6267cc6d530 100644
> --- a/target/avr/cpu.c
> +++ b/target/avr/cpu.c
> @@ -32,6 +32,7 @@ static void avr_cpu_set_pc(CPUState *cs, vaddr value)
>       cpu->env.pc_w = value / 2; /* internally PC points to words */
>   }
>   
> +#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
>   static bool avr_cpu_has_work(CPUState *cs)

No CONFIG_TCG or CONFIG_USER_ONLY test for avr.

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
