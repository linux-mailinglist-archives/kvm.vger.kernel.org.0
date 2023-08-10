Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2244977744D
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbjHJJUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbjHJJUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:20:00 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C3D5254
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:17:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3175f17a7baso617887f8f.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691659063; x=1692263863;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QQf4LquBd65ySTnhKk68cIBvF8eXymDszmhfrBPoOXM=;
        b=EzT9qs7EF0FCAf8FT9mNBnTxzVfbxzvYti8Z4cfty3I7+xW+D+IxjrdVbLbmLVNzzc
         r3LCTYuY+aSbieOgqUrFI5aBI4QRMDjeoq565fhZT4vokXEbzR5D5lF/tmq+PQec8M5A
         5gsNG4TNfKPdK1fTBQn3LU9/QpYX64r5KdRKsKtfuw96ncNoaKf7a66sAK7g4+S4sidQ
         72ORPnxU8jcYlVIH6OAey+eI5JYo+auC3oJ27H5vHeR38bv/L4Z3XivRPhZFWy47Oep3
         VAWEf2yNPO8Y5J+mKQ1pSpWYXjrCsroclNC9IzUx+Qnl7uT2HKLNeic+Sd2XIPCwi4dK
         2oCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691659063; x=1692263863;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQf4LquBd65ySTnhKk68cIBvF8eXymDszmhfrBPoOXM=;
        b=f7MI5Ur/jMgsvZOz/bAdg8xNz6r+APAVJFa/opzIgbkO4vy2D1rZmdVq0qbWbSmJOl
         uKbDncQj67+YyOYVn9vGZTyXtdImRhodRyqR2sm53czO+50iEUsi6LNwbm30G2d28wgo
         iz3Yp3WU6K6808oy6fZHxxX3xVQ7Q9cAM9aHA72yiy7G3F/tUzzZZ1JrzHxhxgI7w7ue
         gEpYsrYUdDfZQr6gHkmELEP2HDHhFTQeA+PXKWdyoIPIjUXo253L4sQ+119AuuOjWwH0
         5V/3bmyOwA11KdQTXIL8MQj49cv2y/tNnClxOR+8MEHIDCSvjY31UWNeCFQvaESeVq2x
         K5YQ==
X-Gm-Message-State: AOJu0YxO3VB6ZG/19JIBSISKsWMWyMutuxmOEDhlDpgnn/RrzO3eg08Q
        4/eTRo88JLzNDpWiVN52KZzdsrigQV0324gtibQ=
X-Google-Smtp-Source: AGHT+IHVUZC2xblty8/WDMMkeM/XMBFZhxw55Mv09xof8YsHMJLyDXUAOmZP4Zn7njVT6X3A3C4Gzw==
X-Received: by 2002:adf:e689:0:b0:317:690e:7b39 with SMTP id r9-20020adfe689000000b00317690e7b39mr1643959wrm.12.1691659062935;
        Thu, 10 Aug 2023 02:17:42 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.158.65])
        by smtp.gmail.com with ESMTPSA id a2-20020a5d4d42000000b00317ca89f6c5sm1499244wru.107.2023.08.10.02.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 02:17:42 -0700 (PDT)
Message-ID: <183b3243-e61a-12fa-0460-73e417bf029d@linaro.org>
Date:   Thu, 10 Aug 2023 11:17:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v5 3/6] mips: Report an error when KVM_VM_MIPS_VZ is
 unavailable
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230727073134.134102-1-akihiko.odaki@daynix.com>
 <20230727073134.134102-4-akihiko.odaki@daynix.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230727073134.134102-4-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/7/23 09:31, Akihiko Odaki wrote:
> On MIPS, QEMU requires KVM_VM_MIPS_VZ type for KVM. Report an error in
> such a case as other architectures do when an error occurred during KVM
> type decision.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   target/mips/kvm.c | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

