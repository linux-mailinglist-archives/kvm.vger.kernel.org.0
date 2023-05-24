Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0AC70EA2F
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 02:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbjEXAWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 20:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjEXAWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 20:22:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A7DC2
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:22:04 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64d24136663so131723b3a.0
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1684887724; x=1687479724;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kvW5odmav81YCuU2xaxrVKZjDJTjkbhDO7IJyae5Ly0=;
        b=LS3sS8i6pcOP3Z/1u/W/pb1HW/gNPJV9pCBq9zXKwqnTKBoB9Y3l9XsoyYn0H4mYMt
         wycd6iPEdZsALvcUaSRDYknHogWQzUx5YuECRFRWelJviVYM3NWtOHNyllj5bPZrV4C2
         tlkFh8IEBwvI3SKEbM+QHEaIVvL9xxGveePO7+A/pBsQMechOyBwFGzvI+Vt9U6edYfW
         S90Otv7palIzLHfc7mMlbe+XO3fGj75NIqNnpsEk61c0ENR3iu4r13TUs8s/1Y88tGgU
         k1nVfll23GNpWJCtry6uI56Qx6aBduWvsKuUcPDE9CeRSs6f/NrcrBfyqWlgEuWoNi3w
         nsPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684887724; x=1687479724;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kvW5odmav81YCuU2xaxrVKZjDJTjkbhDO7IJyae5Ly0=;
        b=MYnlDv4ckqrNvg2cxPV0iAeq46YI3yWsGSNQL2bQBuGmGaHdVJGX2JvizYmZH7vf7F
         S41vXTyoYmVAdT5YU7lx7FoVngTeU4i9dUuaPRBNh7bdnOdkefrLlg0l1456yXvuCd4O
         k0P82nRDeHoaMjhLZCvh+IM0CVEF0cU4IAdgUu40jadlRXgrOlyW+U8j4ebQCg56EP2N
         Y+S4xO8QvYiJOm5XxULXWIdP5+N65ZQOstDZs2rDuqyvacdD/aVxNvHSvbG+TqZ9l80n
         6GqoCZSqy/i85jk3H6F++e+lz5OY5jcTeymZfoN3ueWU8qhZAXNKTnJdhzLHObJiWGsN
         E/Vg==
X-Gm-Message-State: AC+VfDxC0L4lkHNH2K6HEBo70PTcyh/MgGYXEnHWfw+5oq6BhFnHf6dA
        q/JnEfYRowHkr1cHToTRy+oPzg==
X-Google-Smtp-Source: ACHHUZ7IhEOip6ee757qzLCooYkp+ZnG4A+THUuF1wxxUAgFkFu+d/JnFGBSydGfvXaf+AD5p2ehMw==
X-Received: by 2002:a17:902:c40d:b0:1ac:66c4:6071 with SMTP id k13-20020a170902c40d00b001ac66c46071mr17814804plk.57.1684887723916;
        Tue, 23 May 2023 17:22:03 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id p1-20020a170902bd0100b001a24cded097sm7307340pls.236.2023.05.23.17.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 17:22:03 -0700 (PDT)
Date:   Tue, 23 May 2023 17:22:03 -0700 (PDT)
X-Google-Original-Date: Tue, 23 May 2023 17:21:33 PDT (-0700)
Subject:     Re: [PATCH -next v20 23/26] riscv: Enable Vector code to be built
In-Reply-To: <20230518-rented-jogging-b84c705f7d76@spud>
CC:     andy.chiu@sifive.com, linux-riscv@lists.infradead.org,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Conor Dooley <conor@kernel.org>
Message-ID: <mhng-4f11f1da-100c-452f-8717-e059d6e1d44b@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 May 2023 10:31:37 PDT (-0700), Conor Dooley wrote:
> On Thu, May 18, 2023 at 04:19:46PM +0000, Andy Chiu wrote:
>> From: Guo Ren <guoren@linux.alibaba.com>
>> 
>> This patch adds configs for building Vector code. First it detects the
>> reqired toolchain support for building the code. Then it provides an
>> option setting whether Vector is implicitly enabled to userspace.
>> 
>> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
>> Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
>> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
>
>> Suggested-by: Conor Dooley <conor.dooley@microchip.com>>
>
> You can drop this tag if you respin, I just provided review comments ;)
> Also, it has an extra > at the end.
>
> Otherwise, I am still not sold on the "default y", but we can always
> flip it if there is in fact a regression.

It's definately the riskier of the options, but the uABI issue will only 
manifest on systems that have V hardware.  Those don't exist yet, so 
aside from folks running QEMU (who probably want V) we're only risking 
tripping up users on pre-release silicion -- and that's always a 
headache, so whatever ;)

> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>
> Thanks.
