Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3225A617E78
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 14:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiKCNzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 09:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiKCNzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 09:55:41 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F038B15A19;
        Thu,  3 Nov 2022 06:55:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p21so1989430plr.7;
        Thu, 03 Nov 2022 06:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2s5CjDAaY+90OmXPKcOa8nR9wP4LZVJneib6FSefkRA=;
        b=MS8/7KEh2OptfpY9W5htuDaz/SSTGx+/DggQYwJvqUceNYlopOwfxW2JcjxE64vnew
         xWEu8xE3P1/zcBWNS0oftj50W/EpNPO4oulM3NodbDZF9gOsSFwko/9dEa9Pg3ggylGD
         YUbtOtBdNW3kyrysWmdapq36lB0UUBHiHjoPslEBvMimAo9BHhSwe6g7GcDKVmfz/cND
         KU6iMth5PLHzvKuChZ6m9xMSj9BtW+oyuWHMhnKortAp9W0O4O/s6Hdt9VC4TsuGSxcR
         HjYax0FMkw+QXQhELnw4bIW1xXbd+hLyHEQp1zQr2WIkqF3ydF22p1CdqDXVS56UtBE4
         9b1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2s5CjDAaY+90OmXPKcOa8nR9wP4LZVJneib6FSefkRA=;
        b=dpWkKiureZoweG1Na9wJZdM7lFLhb2eI9FNdWjoFMPsLl1kZ2x/ZoYQnJ2DnW7z23P
         4DS4S3byg+PiV9iWDDkhfp6aVKo/38yd0NnWj8tRGZ9lTc6EaQXAzBFNDQ64HT9ZqpSP
         ZDA6tGbuZTtOaVP1zXjUZdNid5WRUtJptYH/RQQYLkinS9KNHRETJii2qPA0UMzEvUnI
         tuUuymij58QA6iLQwBTS114BF2lZAVlysynlsXhdO61rqke34EdqSffqVbQb9j6Oja21
         5bcEQr/6B9dD2faLI3rA9sZue4MOmffZeAnZcTK5QC3+/tkj1yLohyhJT/IqBexMcZ6D
         qs5w==
X-Gm-Message-State: ACrzQf2Tops+nWZls/AgoXOzH26AwtKjkJo3lV1CPmEgfgWC8emK/fHK
        EDWDUF9Fq5yahyIXlptmNAqHHFa1An9XxQ==
X-Google-Smtp-Source: AMsMyM7jLL4puj7iVEGlPCsNA/AfQoaXr2wHeqikdv+S7v8dxTEzekFXavxGHIU/DhFhAmAr4eRXNA==
X-Received: by 2002:a17:902:aa0b:b0:187:34e8:7285 with SMTP id be11-20020a170902aa0b00b0018734e87285mr15105196plb.156.1667483737439;
        Thu, 03 Nov 2022 06:55:37 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902714900b00185480a85f1sm608717plm.285.2022.11.03.06.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 06:55:37 -0700 (PDT)
Message-ID: <24d81fe9-7cd1-71eb-8c35-0739f638b3df@gmail.com>
Date:   Thu, 3 Nov 2022 20:55:29 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
To:     Usama Arif <usama.arif@bytedance.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221103131210.3603385-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 20:12, Usama Arif wrote:
> This includes table format and using reST labels for
> cross-referencing to vcpu.rst.
> 
> Suggested-by:  Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>

This is not what people normally do when given suggestion diff like
what I sent before [1]. Instead, they just apply and squash the
suggestion (while also applying requested changes from reviewers).

Please reroll your series [2] with suggestion applied.

Thanks.

[1]: https://lore.kernel.org/linux-doc/Y2M6eU6xW7jjVQNx@debian.me/
[2]: https://lore.kernel.org/linux-doc/20221102161340.2982090-1-usama.arif@bytedance.com/

-- 
An old man doll... just what I always wanted! - Clara

