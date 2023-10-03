Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1797B629E
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 09:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjJCHkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 03:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjJCHkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 03:40:10 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D5690
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 00:40:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3231dff4343so304519f8f.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 00:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696318805; x=1696923605; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WfwaRtkJhgz1kzbARp9S8/ZcPDCtTZfWdoKPp3HywLc=;
        b=zfLNlbUtUy58H+ygyd7PFlRim/PHILNKDJXgDRtJ8Zn1VBNYkpqtcWYXBEHRhmqP6p
         Vf8FDOZSQgTlqhl1neVSQY0uXJZhXCg8QedBywUmDSx6KCqfnTtJlzAkLps51buZ086d
         jf70IknHeSvaBkNr1NVw9d55C7Hy4utzWvZG2tXx6/OzBFg54RLiN1uJnoCCrkUPzFkQ
         fBMeQmMcepRECEpVD/nkH+lfFmZ4TA9uBMB3xUEQbIqOaUXwJYCiLeMO/DGOm9OdgQRr
         yIZo3bEqmqL9TFbBnZyYEmiBG3gufSKwwmJiP29PekpKWKw9z197d2xbkkimHa1QPH6B
         L2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696318805; x=1696923605;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WfwaRtkJhgz1kzbARp9S8/ZcPDCtTZfWdoKPp3HywLc=;
        b=VaTG1X6+rbfZjtEna4Jr5sKNfZmxpZgffexIlhsg7jeI0ceJ+IIyb+jVVAqDdPOe8L
         jggAF9iR9MSyY26BjaJZSTfO8Jl/EClOEts/I3Xrw837gbWcL/WmgOUBug8owhQ/16US
         KtceUVzN1lv6PmH+Zkygt2pDlkhHtcdSlOLVA0QZ+EBYBhIjKmheDVtWB4L5kxDARNUZ
         jZMEB4AKiSBYIFY9ui2VDf2gBnF+SnO1WdXfPzlg33dAOqWmoaUy6QaAd4d/Dvct+tIX
         gHW8JIK0yRF1v0mVN6TIXSmDX/Oq5IRbDKywDUPAcSmiAGsZ91YCfEi+sALdk3olpaK2
         rrGg==
X-Gm-Message-State: AOJu0Yz86ivpD5m9nNUMGB+/69d1CHq83eds97xDx7n8GW1FFKOo38+u
        YB6550RgN2/WJTioS8K3//XMtQ==
X-Google-Smtp-Source: AGHT+IFQumuMjOTW1uKZQSkiTBfGJlr5/807UTqWQzzYkCW1RNhEqi/kZVZ3yktWLc1ySpsCpLVbYw==
X-Received: by 2002:adf:e806:0:b0:31f:fa48:2056 with SMTP id o6-20020adfe806000000b0031ffa482056mr1239081wrm.27.1696318805632;
        Tue, 03 Oct 2023 00:40:05 -0700 (PDT)
Received: from [192.168.69.115] (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d444f000000b0031c5e9c2ed7sm896779wrr.92.2023.10.03.00.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 00:40:05 -0700 (PDT)
Message-ID: <1fbe8877-aaa5-1b6f-e18c-1d231a31d2e7@linaro.org>
Date:   Tue, 3 Oct 2023 09:40:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>, nipun.gupta@amd.com,
        nikhil.agarwal@amd.com, alex.williamson@redhat.com
Cc:     ndesaulniers@google.com, trix@redhat.com, shubham.rohila@amd.com,
        kvm@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nathan,

On 2/10/23 19:53, Nathan Chancellor wrote:
> When building with clang, there is a warning (or error with
> CONFIG_WERROR=y) due to a bitwise AND and logical NOT in
> vfio_cdx_bm_ctrl():
> 
>    drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>       77 |         if (!vdev->flags & BME_SUPPORT)
>          |             ^            ~
>    drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to evaluate the bitwise operator first
>       77 |         if (!vdev->flags & BME_SUPPORT)
>          |             ^
>          |              (                        )
>    drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand side expression to silence this warning
>       77 |         if (!vdev->flags & BME_SUPPORT)
>          |             ^
>          |             (           )
>    1 error generated.
> 
> Add the parentheses as suggested in the first note, which is clearly
> what was intended here.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support")

My current /master points to commit ce36c8b14987 which doesn't include
8a97ab9b8b31, so maybe this can be squashed / reordered in the VFIO tree
(where I assume this commit is). That said, the fix is correct, so:

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Regards,

Phil.

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/vfio/cdx/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index a437630be354..a63744302b5e 100644
> --- a/drivers/vfio/cdx/main.c
> +++ b/drivers/vfio/cdx/main.c
> @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
>   	struct vfio_device_feature_bus_master ops;
>   	int ret;
>   
> -	if (!vdev->flags & BME_SUPPORT)
> +	if (!(vdev->flags & BME_SUPPORT))
>   		return -ENOTTY;
>   
>   	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> 
> ---
> base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
> 
> Best regards,

