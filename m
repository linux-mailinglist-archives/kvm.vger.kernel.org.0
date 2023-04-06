Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88A46D9226
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 10:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbjDFI6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 04:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjDFI6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 04:58:37 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898134EFD
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 01:58:36 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o32so22204453wms.1
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 01:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680771515;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHzSA/w+tX29wdWiyiod4QQFWJP9A2SW72Qr9AlU6gA=;
        b=CfPEMKLKqOz/c3+hZ29YAY4dhnm3/P8Qdd5ytuaG4hm36heD2Zf/Ekwv2bz3sieyAU
         lCS9A60SVmslx2d+mK0nvxajpqAbWWH58sSX50rXMYKxvlOJT8cQtIKonxVMWaQJgpr2
         z9ZCuQsrxcXpHJS4q4vmTB5xM1uqNH2aZXDpGq8XaLTUE+9L4Qj3x4aveWKuZTctKpoq
         f8HBIJM2csKrijwyNxnz2n8JvCN9mEFcSyULbkVvfCxdojQtvuuPHIcmvsnvIdlISU8C
         08sGcS1Kmk+2IN2DdDH14DbP5n3N0njIrvaDv8nFRT+8d50kImoO+gz6xnUFNzAelVyz
         NqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680771515;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hHzSA/w+tX29wdWiyiod4QQFWJP9A2SW72Qr9AlU6gA=;
        b=qQL7UObcukgkRICym89QqTnytDNyLD11CPgoMfCGxCmPdrOyLwla4FRJG5zZ/6KngZ
         +63JFiKlzgtW+KZRQQ668gqZKi3D7NiB7Zh2FEJodOLasCd3dVLwk8+AQsEAa6l0f3dq
         /ogalTbXgh3GO9Uf/76sdp78jMdfGWC6pr2JDBOW/YPoD3kmDNKrjDbKcftdjHX0d4uX
         Cr6ntDSkQ1QFBdIP4t2sn4sajv+FiULcuLyO6oK0PwzUawRL652N2iK1z21zoV65QJeW
         lUmmIGrToyPMKhqT6rWtmacdq2lzrgO9G65RLRLEqTIB27r7Synu/aN4GA9PFTv+Cktp
         JYew==
X-Gm-Message-State: AAQBX9dnbGCls5KldSKF5OxDw10IqGHdkt+YCGezJuWqhzUXesRoTSuT
        l/52CxuVWaEW7+aH9ugzpPZknQ==
X-Google-Smtp-Source: AKy350ZvO2HEFpt6fKATtkVuDR9PZfHcx1kRVj+R7uhiRUrRmPQtOUp51lr7nDaatafZ7WJbFafRmg==
X-Received: by 2002:a7b:c34d:0:b0:3f0:44d1:3ba7 with SMTP id l13-20020a7bc34d000000b003f044d13ba7mr3420294wmj.17.1680771515016;
        Thu, 06 Apr 2023 01:58:35 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id i16-20020a05600c355000b003ede6540190sm4772378wmq.0.2023.04.06.01.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:58:34 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 2B7231FFB7;
        Thu,  6 Apr 2023 09:58:34 +0100 (BST)
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-2-philmd@linaro.org>
User-agent: mu4e 1.10.0; emacs 29.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, qemu-s390x@nongnu.org,
        qemu-riscv@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/10] sysemu/kvm: Remove unused headers
Date:   Thu, 06 Apr 2023 09:58:24 +0100
In-reply-to: <20230405160454.97436-2-philmd@linaro.org>
Message-ID: <87ile9jsjp.fsf@linaro.org>
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

> All types used are forward-declared in "qemu/typedefs.h".
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
