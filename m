Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EA06DB705
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDGXNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjDGXNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:13:40 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C1DE056
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:13:03 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so44463365pjb.0
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680909182;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aYIkZBIFK2ZpHWvSfO0jyCWHXEmHKEa00eKczku2HgE=;
        b=vKfScPpZZuTSQjVvlLzoq0nu/oNEzhegH0VN4qBbTDX1lF4jluykpN2c1wbw5Qjmnj
         Rb66ndQEM5IDPq+PkYMGfaYi9++yYdHMhB0dAtUmxQ0utcdT4d11dzuZmSQZmMmkR0YZ
         f19qZTPpNtjEBVCVK7fCUEY08KnyfjOg+z/5iwxAqvdo+K6M9MEOq/E2MXr0jeAqB+Kq
         suEXAJqiAwgQTQ/MyX+nLK78aB5JsXiZWTSWLDWgP46FZ/9UiE6oqKOC79oVNQyZQwyZ
         gs3Q/speYE/HWvXViIfmClwbFvilbHwN6YPaYwEE4apNDw1NyVzvGBqI622hYSkVaakq
         kurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680909182;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aYIkZBIFK2ZpHWvSfO0jyCWHXEmHKEa00eKczku2HgE=;
        b=RJFURbOwT8/Pl2Nt6U11X5fgWmse2y6xr/PBITeQsaQFV+kI3mmLxmc6iMfoLunc84
         7/TgE1EQsnXRnlGZ0D6arsVHfZ9jaQG3oCku2kl1EOzqbHgBZaXglRmO9sk7UXlgiuc3
         c8qW0BfYwYJbIQXSNG/cgSqbOnRi1BOfMYlH3aTGeL3nhJdl4PzyGMvJtS31i/Pl2X31
         Zgd7vibOwBeP6QQrreY9IdW6CRfOW9XeDvJL6/b9MZtRAz0X1iJ4mCUaGbRfDl7cej3b
         ligv+2O8O3z2oSd9VWBTR6Yp/NqgXvf0ntdNeT7w9bydix0wBeNSM2Vx8r5OrunCY2Kf
         wAwg==
X-Gm-Message-State: AAQBX9dSvMadVYgGjktmD2Ik9oD/gkEox4ecZxgPoJ01p9RiyAjSZO9o
        eh3BDvoyy8XiJsjBCq2lv1xZFQ==
X-Google-Smtp-Source: AKy350bDgHCmk88fi7lKmF1o3TyQSTwibPI+P0wHGQ0hTOjZ8sVom4CqWEwPGykeBzb76cAn0hafQQ==
X-Received: by 2002:a05:6a20:4ca3:b0:d9:dbb6:2e67 with SMTP id fq35-20020a056a204ca300b000d9dbb62e67mr4159798pzb.31.1680909182482;
        Fri, 07 Apr 2023 16:13:02 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id g24-20020a63dd58000000b004fcda0e59c3sm3091950pgj.69.2023.04.07.16.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:13:02 -0700 (PDT)
Message-ID: <5a0297f8-ddc6-4fac-b896-1b1ecede844e@linaro.org>
Date:   Fri, 7 Apr 2023 16:13:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 12/14] accel: Rename WHPX struct whpx_vcpu -> struct
 AccelvCPUState
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-13-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-13-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 03:18, Philippe Mathieu-Daudé wrote:
> We want all accelerators to share the same opaque pointer in
> CPUState. Rename WHPX 'whpx_vcpu' as 'AccelvCPUState'.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/whpx/whpx-all.c | 30 +++++++++++++++---------------
>   1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
> index 70eadb7f05..2372c4227a 100644
> --- a/target/i386/whpx/whpx-all.c
> +++ b/target/i386/whpx/whpx-all.c
> @@ -229,7 +229,7 @@ typedef enum WhpxStepMode {
>       WHPX_STEP_EXCLUSIVE,
>   } WhpxStepMode;
>   
> -struct whpx_vcpu {
> +struct AccelvCPUState {
>       WHV_EMULATOR_HANDLE emulator;
>       bool window_registered;
>       bool interruptable;
> @@ -260,9 +260,9 @@ static bool whpx_has_xsave(void)
>    * VP support
>    */
>   
> -static struct whpx_vcpu *get_whpx_vcpu(CPUState *cpu)
> +static struct AccelvCPUState *get_whpx_vcpu(CPUState *cpu)
>   {
> -    return (struct whpx_vcpu *)cpu->accel;
> +    return (struct AccelvCPUState *)cpu->accel;

Same comment about removing 'struct'.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


> -    vcpu = g_new0(struct whpx_vcpu, 1);
> +    vcpu = g_new0(struct AccelvCPUState, 1);
>   
>       if (!vcpu) {
>           error_report("WHPX: Failed to allocte VCPU context.");

Hah.  And a "can't happen" error_report, since we're not actually using try here.  :-P


r~

