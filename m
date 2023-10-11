Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B837C47EA
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 04:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344850AbjJKCoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 22:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344791AbjJKCoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 22:44:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BD48E
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 19:44:28 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-53db360294fso1142107a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 19:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696992267; x=1697597067; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vPcG6O3r6R6vmrpuD+agRdb/Qy6XShXq47ZdTDFc2eA=;
        b=J6d9Ol+ur9nMqtJ9tLClWjk90QaCg4gS4MGAEJQzAak+19ueK0oJWlpz8giDEJ3Hzm
         W08PBdrGhDn1E5J6u/y5z4prNkY1cxGVv8xAlrcOtF8RMLTCCV90rTMsE0/qBcQGrJPR
         Cquw6ANl7Clv4+nYyszcjAhDgOWgHzRq8d45pbx1zNhCbxWLbbKdUtmTOHKABJwvqHk5
         qzlzWfqjJYHDn6KQ8oGDeoOJ5D/I6FF4JWiD0MTOxapd+z3EqR678/PrUqyJT9Lt8pBw
         aVQALzZUlnpn0xJ85MdmwZvU6hfN3lGLm0A0+KfiP8QgtMwCA/xo9pHY9UHHPzTVamz9
         4sLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696992267; x=1697597067;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPcG6O3r6R6vmrpuD+agRdb/Qy6XShXq47ZdTDFc2eA=;
        b=Tf3D7LAVtLEIGLUodgUE/uNxYFWMed8GzEwudWZq1noq0bnTZEVmVfwJZnfE1Pb67k
         ct3keZrr6Idbaa55QJXT7/BHRiMSX35HWiqVWgHnee0oURB19OyetK5XVs8FGKfmQd0X
         dg1OZFQKE7wp/bemcDG8g3onUGtA/7y/53ITO8vUsLC2RUipr2h1ICSJlJUwuODgh3tJ
         TgQ33vJ+SKnFt5E1Za/7CKrZfheZ5v0Pts/hC1O4lybW9i24MVhK/I61rYVi1+wVrh7r
         kZNUyFpmaE05wm24QNG897Rz9i9Rw925mPRpUkcudjvJq4PCs82gAMRw2/6DEZOw095+
         YkIA==
X-Gm-Message-State: AOJu0YxAPD6t9pvxQ3shcQTInXgXGDjIz2I1xGhvJwwgH+7+Bs4T5KL7
        /KG3BHdVTAQ1jLwHtITU19y8Qw==
X-Google-Smtp-Source: AGHT+IGrvLpbuah4ZRoZ7fyUqP8vmpOVTR49mUeF4b4dk54RFBRBiJRaaJfylkIQSsRLFAs05vI+XA==
X-Received: by 2002:aa7:cf90:0:b0:530:c536:443 with SMTP id z16-20020aa7cf90000000b00530c5360443mr18956850edx.1.1696992267090;
        Tue, 10 Oct 2023 19:44:27 -0700 (PDT)
Received: from [192.168.69.115] (mdq11-h01-176-173-161-48.dsl.sta.abo.bbox.fr. [176.173.161.48])
        by smtp.gmail.com with ESMTPSA id n24-20020aa7d058000000b0053331f9094dsm8332754edo.52.2023.10.10.19.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Oct 2023 19:44:26 -0700 (PDT)
Message-ID: <f5a296f8-cfc6-b98b-4e5e-ca4c448495d6@linaro.org>
Date:   Wed, 11 Oct 2023 04:44:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 1/3] arm/kvm: convert to kvm_set_one_reg
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20231010142453.224369-1-cohuck@redhat.com>
 <20231010142453.224369-2-cohuck@redhat.com>
Content-Language: en-US
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20231010142453.224369-2-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/23 16:24, Cornelia Huck wrote:
> We can neaten the code by switching to the kvm_set_one_reg function.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   target/arm/kvm.c   | 13 +++------
>   target/arm/kvm64.c | 66 +++++++++++++---------------------------------
>   2 files changed, 21 insertions(+), 58 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

