Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AE06D922B
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 10:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbjDFI7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 04:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbjDFI7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 04:59:43 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678725B88
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 01:59:42 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso25144944wms.1
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 01:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680771581;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5sRssPNnjk3FAAC+e6GI9oX98dvbrVIoKM4xtqCLlrA=;
        b=YII4xabBar2qgebAcPiklW/unkEMHWDuzLRCvxFk/UIH+PpgClheiQltRIEzpj77Pa
         E7NN+ACG3OIepEIJguzVWYGdlql7j7gya/NrJMMN2xMiJ4rHV6C4ykgh0KcgMUswajQF
         F0S8b5Gg/tq5SaNEEi6s16L142Z9mzJDOIPY3P0t3k1iH+VgJQ2Y1JXs5lWKp3Hzz2Wm
         yu1ioq8GHSxJHChSiUwRj5hZFWsTNj6lOH6K9PWeVBkLPCjaPaqs1Y+AhZflGsfkSnbN
         sKCN6wWH+p/G8uVtjuoNxP+Pc98XX49VuoY6NYEyhoXdAvUIPpGMSldLMRAFYdodaZyU
         5yVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680771581;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5sRssPNnjk3FAAC+e6GI9oX98dvbrVIoKM4xtqCLlrA=;
        b=t4v9FbDJzw8cZStzz8h24ji1zAXIKpClX5yA5a2XHaml4pK8F5pzU6mpIZViH8xyjW
         W9eTJbIBHiUHmr9Mwvq2AsR5px2UgL9isSKtEQw2jbnbSa2dlFgMmAK+S2KGiTPk6vC4
         B6tVIdJ62dvuMHtupvXOZAps0Vj0UJkuoar9SEAfytjiplXZav6qdlF5lAbafB813sm3
         AQfKEp5N+a1anWfdir/z39OKQj97sphZh0GrQN5vKJkFN4RcXyNNNH5NI5bYL6GlPrez
         lsV8X7EnVQyApG+MkkMmwg0UdG8Hw03oLlFYiStiZNHruZuT6/08ob+2evTpqQNSxxBY
         7Nxw==
X-Gm-Message-State: AAQBX9d5cQiYddJIkrWaHWgjDOsZZ/L0zZINLvBzJoHIbqbrBkUdiu2N
        vOB97me88vXk/yAI3F4atEV50A==
X-Google-Smtp-Source: AKy350a5z9Vn/jqwCz8XAy+NdfPZbRY6wD5oyyp/lb/ETDZgLXHhcUAhKvVEQnxfzLFAT9HuflqkFw==
X-Received: by 2002:a7b:cb4d:0:b0:3f0:6b33:a5e1 with SMTP id v13-20020a7bcb4d000000b003f06b33a5e1mr862961wmj.9.1680771580873;
        Thu, 06 Apr 2023 01:59:40 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003ef6f87118dsm4798573wmo.42.2023.04.06.01.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:59:40 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 32B481FFB7;
        Thu,  6 Apr 2023 09:59:40 +0100 (BST)
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-3-philmd@linaro.org>
User-agent: mu4e 1.10.0; emacs 29.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, qemu-s390x@nongnu.org,
        qemu-riscv@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 02/10] accel/kvm: Declare kvm_direct_msi_allowed in stubs
Date:   Thu, 06 Apr 2023 09:59:23 +0100
In-reply-to: <20230405160454.97436-3-philmd@linaro.org>
Message-ID: <87edoxjshv.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Avoid when calling kvm_direct_msi_enabled() from
> arm_gicv3_its_common.c the next commit:
>
>   Undefined symbols for architecture arm64:
>     "_kvm_direct_msi_allowed", referenced from:
>         _its_class_name in hw_intc_arm_gicv3_its_common.c.o
>   ld: symbol(s) not found for architecture arm64
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
