Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5727C7612
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 20:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441912AbjJLSm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 14:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379655AbjJLSmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 14:42:55 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3909883
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 11:42:52 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5333fb34be3so2259021a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 11:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697136170; x=1697740970; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ASAniN18QZFRch4hHbbIvuqpTci7nid/Sw0rHmtrIM=;
        b=Wl1RhfpWa92XIiNqt+V0/SlOMHd9++MTEnn7v1vcjbSUT27BMvzjJy2JVfT6PHosSa
         jmsV6m6CXWbobJVXeBJEEOk4HrmKnbb0lfQD78wrS3suwCAK4lVITfS93hxJd+z96KjF
         1PHJVl/0KXFl0wlu7E7lAQm7Iq7Fhpq4j1LYPKBLx3EcLhU2MS5sdypAcgMUfZ/wslDu
         lP7zE5E+PBBQKiKMi2150dfdDZHFXO8+EheAPTqsTw0ASnO4uHh4SQMlWLoZeFa52sPT
         liSL0kOY3j33f8cVcYnjwu+DcF+gctaJ33fZsoALkLY2sUFFEGSBUhsnQui6lCQx8ENp
         bMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697136170; x=1697740970;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ASAniN18QZFRch4hHbbIvuqpTci7nid/Sw0rHmtrIM=;
        b=Z9kSNHaYBBuXiFG39Jk15eP2EUKMNyldNWlOchkGlTvX5YQWx9u4C3kjxVLjBDvMSp
         ANotBN9Fg99zrI8MZRYWzMKDlenhtGOlMsg1XaNcB9igHF0Af7TAfrLrPEpgKdvaOS23
         AD1aw9RQT112+DdWJeBAvHP5BzHe22DF4sYf02DHYnNoLTXFRR6dqwwe1EFnB4WIZv5Q
         Ij4p9rYADLS+cI7nva8pjdBkaQWzIpvGsN4v5sMfdAsUqGjQK/Y1dkEpGGWRQJzbbVPs
         vJQvbTi92Q8VKxdPVM0aa6KtqSaw3y7ISvCb7G+txybC+oa7kJF3eMY2AnI+sGT8rBqC
         L8hw==
X-Gm-Message-State: AOJu0YyTBgZ585NDdb3BJZN+aEh+nB6ft4qQZ7zovx3o5kt7bWP2L0lM
        rry2bbQ4+ZCnGbe0Qg1aYpaVVQ==
X-Google-Smtp-Source: AGHT+IFWtuhhigFSgsoSTkjgJ41qxJL6r4RxNHmtcIA3n3+G5XfBw7m3mAfLBOf7W8G8wl9JTbmGRg==
X-Received: by 2002:a05:6402:1cab:b0:53d:f180:3cc5 with SMTP id cz11-20020a0564021cab00b0053df1803cc5mr3854665edb.20.1697136170725;
        Thu, 12 Oct 2023 11:42:50 -0700 (PDT)
Received: from [192.168.69.115] (176-131-211-232.abo.bbox.fr. [176.131.211.232])
        by smtp.gmail.com with ESMTPSA id b25-20020aa7df99000000b0053808d83f0fsm10459023edy.9.2023.10.12.11.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 11:42:50 -0700 (PDT)
Message-ID: <b71e0108-b95e-1182-f0fb-d9aeddc3b3bf@linaro.org>
Date:   Thu, 12 Oct 2023 20:42:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 0/4] target/ppc: Prohibit target specific KVM
 prototypes on user emulation
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20231003070427.69621-1-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20231003070427.69621-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/10/23 09:04, Philippe Mathieu-Daudé wrote:
> Since v1:
> - Addressed Michael review comments,
> - Added Daniel R-b tag.
> 
> Implement Kevin's suggestion to remove KVM declarations
> for user emulation builds, so if KVM prototype are used
> we directly get a compile failure.
> 
> Philippe Mathieu-Daudé (4):
>    sysemu/kvm: Restrict kvmppc_get_radix_page_info() to ppc targets
>    hw/ppc/e500: Restrict ppce500_init_mpic_kvm() to KVM
>    target/ppc: Restrict KVM objects to system emulation
>    target/ppc: Prohibit target specific KVM prototypes on user emulation

Ping?

