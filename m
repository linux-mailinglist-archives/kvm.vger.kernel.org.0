Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2E7B65C3
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 11:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239681AbjJCJod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 05:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239649AbjJCJoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 05:44:32 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C2EB0
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 02:44:27 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-4064876e8b8so7177535e9.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 02:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696326266; x=1696931066; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8SiphgAucNQGHkryF9frgBMe7PR/MSSiUUKJotN2TEg=;
        b=Bx1omZ+RuPTkkJvsAnbvQztWAxTmYeY/mOxjvJ0euqSYCvNvFiP50dIHPFp0IOg6eC
         FB+4pDPdkI97K+t1e6MuaEKg4u9CE+DSbtuh31yw8EgRN0TNwdIAeM+Oi7aMr5KudiNO
         9e233cjB/UDHMSLQjKED2RW23oqOUJkb+8RuhlyX9igZGzbyC/4jsHSjT1WWgijQcrlX
         lM/E1Sgjdpi6tT+xkar1gTpNy+QKbxvN/qNvJ6nwet75AgCR6BheJRQQ5qj8A/baChbg
         chtO6bGED4MjvoTRUWOpO5lUUYCyyXI1sI4sInakBYbz5zNppMFNPmnJwn1+FHa2GxwB
         RO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696326266; x=1696931066;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8SiphgAucNQGHkryF9frgBMe7PR/MSSiUUKJotN2TEg=;
        b=H+e54j9KQE8/BLv+zQ+RDg4I6S34ntPpksJGrL6+dO6Qe8kCtaXyDY42gwftgw9nSw
         oFE0LDRQTXxSydA1L/Kw0hoXZB2rcrF4TYfUoYqYsUuQRbC8RD9llRZZkJk3+DPLMkQW
         urWM1PGiPG9Mj+YUBzb6C1LREtmDvwW5Ckm+sNgS82xX1Z/nIJhnzYu7Yetb66N4bjgy
         if0LGppuDxM4PsEw2HgY8Vw+dcYe+XAK/fH7/tNK4XtxSs1VhcyG4tVPaXqzOte770WT
         5Wc5bPqcP6VSA+pPQuTvDUP/Kcxsneh+9kUPBQp/WkGcrRjzvglntZu/giOfrauazpw8
         57Zw==
X-Gm-Message-State: AOJu0YwLdAlI28ZowjIuORExIojwzxeW/2m4DV+H/jMrutLAbP1LCa5i
        4WZxoUaRP90FoqJ+8lkGSAZ79g==
X-Google-Smtp-Source: AGHT+IGCM3/s1kXMoc0VE92CwctV0Hho3NjC09QRAkR719GNUddg3X21PBuO4Q5zhOifZ+nAKkpCjw==
X-Received: by 2002:a05:600c:1c1a:b0:406:53c0:3c71 with SMTP id j26-20020a05600c1c1a00b0040653c03c71mr11663731wms.37.1696326265861;
        Tue, 03 Oct 2023 02:44:25 -0700 (PDT)
Received: from [192.168.69.115] (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id w6-20020a5d6806000000b003196b1bb528sm1153901wru.64.2023.10.03.02.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 02:44:25 -0700 (PDT)
Message-ID: <213c8a98-5025-6fc1-2926-8f6f15180835@linaro.org>
Date:   Tue, 3 Oct 2023 11:44:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 3/5] accel: Declare AccelClass::[un]realize_cpu() handlers
Content-Language: en-US
To:     Claudio Fontana <cfontana@suse.de>, qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230915190009.68404-1-philmd@linaro.org>
 <20230915190009.68404-4-philmd@linaro.org>
 <39bac54e-be9f-f425-81be-62395633ad13@suse.de>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <39bac54e-be9f-f425-81be-62395633ad13@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/10/23 10:55, Claudio Fontana wrote:
> On 9/15/23 21:00, Philippe Mathieu-Daudé wrote:
>> Currently accel_cpu_realize() only performs target-specific
>> realization. Introduce the [un]realize_cpu fields in the
>> base AccelClass to be able to perform target-agnostic
>> [un]realization of vCPUs.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> Just thinking, for the benefit of the reader trying to understand the code later on,
> maybe putting in a "target_" in there somewhere in the function name?
> like "realize_cpu_target", vs "realize_cpu_generic" ?

Good idea, I like it, thanks!

