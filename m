Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24116D443C
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 14:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjDCMST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 08:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDCMSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 08:18:16 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE99FF03
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 05:18:14 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i5-20020a05600c354500b003edd24054e0so19705285wmq.4
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 05:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680524292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0sZyqGTmONd+OiUWWgNg/LaGCmZOm5KGMk/U72UVlI4=;
        b=D9P1MRGXZC536z7u7xjW5lffWdsS3+t+jC8Qc/CwcuZltSkm4vLA+Pi0pRztpK0UaU
         R5BdMvC/2Jy4MJAts4xNkzkg7YEfAmeJ4SREriJPstsMm8jEf2P2z4CzhjhLjzCKm99M
         MOS6syZGTgFg3S+xOueXJwJlzldIt1aD15QBVjXNKlLLX66YwcJ8MfFtJG6fzJecuav7
         GS7qtb4iLXTuzAqYtZugZi3rluQwuTyaKqjTk/OXn7i9Kup/YRryND3B4+L2XJE3pj3R
         x4wFTQaAxmrD6E5MjlcAQRmj5y4gsaOiwpeIBNLffIkw16z+MROQLM1EVesASDQROnBr
         PPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680524292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sZyqGTmONd+OiUWWgNg/LaGCmZOm5KGMk/U72UVlI4=;
        b=Vge1bUFq/Zc/din/EIU0B/YOOfE3kiYACeTTBnjMNCrc2DmzD0WhSYTlXSeU43yaR/
         lQ0He/5nM9CwhNcIrAMu2dYoZnVAV4GKSETbQd7YZmm0awxdDZjAV61ZtXPWqG7Buf9y
         Xa9rVMmoF1KjHm5Dymt9k6cowDJlrbceJZtQ51Wl7PKNWQFTMjSDi1bSakw/uIxML53O
         43THIyvqV3rfVXsv/FVTlF57QMu8bjSmdm7MjweBL3voA1AzM+0Y/zLjwJgpw0LOD9RQ
         KSpACAP2e/ki6w9M8B6wDWmEJH21j/ySeBBjfJUbzIkvSYQyoUXk//Hfm++C0pzQaTme
         KLKA==
X-Gm-Message-State: AO0yUKUN5iFOQAnJntxSIoA4Vfw9favVtSgYn6Coi8d27B5ToNpe41Ou
        AdlsJPZRHhzBySZi1jEaQI9pYQ==
X-Google-Smtp-Source: AK7set+DP1TDktb9pra/DZHm3KlYQXRnDfWDma3weJvCWw8pMrNMdh3WQQDAT7tLqsQjUFzSNVkztQ==
X-Received: by 2002:a05:600c:2114:b0:3dc:1687:9ba2 with SMTP id u20-20020a05600c211400b003dc16879ba2mr25285632wml.35.1680524292674;
        Mon, 03 Apr 2023 05:18:12 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 7-20020a05600c024700b003ee63fe5203sm11922415wmj.36.2023.04.03.05.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 05:18:12 -0700 (PDT)
Date:   Mon, 3 Apr 2023 14:18:11 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] RISC-V: KVM: Implement subtype for CSR ONE_REG
 interface
Message-ID: <t2xcol77el5zebqnjvigqzysiyv3w2xcc6i45f2gthr5dbntnt@eu4obey7lxgf>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-6-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403093310.2271142-6-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 03:03:07PM +0530, Anup Patel wrote:
> To make the CSR ONE_REG interface extensible, we implement subtype
> for the CSR ONE_REG IDs. The existing CSR ONE_REG IDs are treated
> as subtype = 0 (aka General CSRs).
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  3 +-
>  arch/riscv/kvm/vcpu.c             | 88 +++++++++++++++++++++++--------
>  2 files changed, 69 insertions(+), 22 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
