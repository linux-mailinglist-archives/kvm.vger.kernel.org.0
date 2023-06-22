Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1311E73A75C
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 19:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjFVRhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 13:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjFVRhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 13:37:06 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24521A2
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:37:05 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so10153305e87.2
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687455423; x=1690047423;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/fsL2cVXAXnCdY15L3MolzVIRIDo39bn2bc5jAVthdc=;
        b=kK9ms6oxy4w18XnqLzRC42c2y3VtHaZF6WjXDGqNMNiQNvba5S8AHyOTZEqCY8BDzY
         gSHrJgC8UlnZMr3hGroun6OS37q7nTj7t0rJS1s4dj4kEV/EdOM8bG6f6JAbd91UV8Re
         ovlIHAL3ZTFS25sFLjk1CL4w9JQHOOEo3xYK1FUH6doAfwuUX/AZyGxw7CjLF/N9xRPE
         Ce6z40LRpgoVSeaffnwM6XvFDi1MLGoP0rPfRGV9+UEr6gsStEfKCmRCH3QhxI4LKpZy
         17/b15DUPPGEIlxPBA4ymfRxYz11wMz+nZmLgkeWJndJ0QllQ7EC1vHkRYpy6UOVehTP
         gASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687455423; x=1690047423;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/fsL2cVXAXnCdY15L3MolzVIRIDo39bn2bc5jAVthdc=;
        b=aRlDnAM0n1wAD3TfXhGjStpP2oZJKZuwa8Kn4s/er1jBzEMTw0ZnjoXRJGaJb5aKYw
         Hd2ukwGjwiwalF7a4zu3BX2TRlKAOedIcqew3K60JuX/vBhIblvkkGZOUMDyKD0RRJeQ
         JR1XhMpA3pVlqCQGlaYSLisHI3mau0+Rvj1eBiUNBP/pzoSdoqwDqZYkzMWYqA1lT9C4
         ODCorRFbYJxjtYjRt9JxrUat2XylCouUIV38KLYCYhe89U+5r7WDdpmpm8n5XB4gNbMO
         myjGImND5dGmwgECmQh1UKobYDP3jPp2fxTJzoUkioF26z6GtTe3AMLlEPpYyqE0Kkoh
         yAkw==
X-Gm-Message-State: AC+VfDxhTpwSXa2taMu1YqU5KyHf+oYyuk4lxbVdfAcI4Q8WeskMk+Ff
        Yq4WRTOPuS3WwzIHa1h7jcxioQ==
X-Google-Smtp-Source: ACHHUZ4hXNqmNTn6U0F9nFN6Me87Rr7UBrptzXZ7Yf1Vq5uPEksRCjxnuN8AqvGh0D6IfBMleD+RSQ==
X-Received: by 2002:a05:6512:1284:b0:4f9:5ca5:f1a6 with SMTP id u4-20020a056512128400b004f95ca5f1a6mr4238864lfs.17.1687455423332;
        Thu, 22 Jun 2023 10:37:03 -0700 (PDT)
Received: from [192.168.157.227] ([91.223.100.47])
        by smtp.gmail.com with ESMTPSA id ep8-20020a056512484800b004f26f437ad8sm1181122lfb.53.2023.06.22.10.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jun 2023 10:37:02 -0700 (PDT)
Message-ID: <960b4b4f-8899-b263-4f31-5a4ea798e034@linaro.org>
Date:   Thu, 22 Jun 2023 19:36:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 05/16] accel: Destroy HAX vCPU threads once done
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
References: <20230622160823.71851-1-philmd@linaro.org>
 <20230622160823.71851-6-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230622160823.71851-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/23 18:08, Philippe Mathieu-Daudé wrote:
> When the vCPU thread finished its processing, destroy
> it and signal its destruction to generic vCPU management
> layer.
> 
> Add a sanity check for the vCPU accelerator context.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/i386/hax/hax-accel-ops.c | 3 +++
>   target/i386/hax/hax-all.c       | 1 +
>   2 files changed, 4 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
