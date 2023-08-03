Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0229676F027
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbjHCQ5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbjHCQ5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:57:06 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AC64226
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:56:17 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b962c226ceso18667651fa.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691081772; x=1691686572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qEowLIfYXc6RIyRT91PkflonDDx/X3GfoYD39DoAO1A=;
        b=UxsdCkBg1bcFlErPzGOaMvsw+uZ638VKGAjxqZsrPcmWnR91jIz7QgETMyzZjXdybV
         BYeoKm+M+VCC8mXrVkehOS0tMpbtFTuZBDk4pzAbsyWvIvAuRYpvmKtH5iXZpFRMm6r0
         C7X6a5NfojO3I+K8VEqkH40p+/gplL2opNVfDKq4a6Ku+wpTH/D7DITTMB7jlPaIUSkx
         tV/cWEi4YiSRxleUUi5nIK53RyDqlTmDpHy0oMjjiRIlnJOQ9XO0gx5iyb9dNxUCMZKO
         SPYul0fsSTHkBsQVfEn7helxNIZA771UFY3D2T07sxyEKd8pNvzlX0HA0Lxlgs4IafPH
         SCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691081772; x=1691686572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEowLIfYXc6RIyRT91PkflonDDx/X3GfoYD39DoAO1A=;
        b=XL1MlCbiGqa6Tn7/bctx5h5fzgwbfvi3mlOlR5Q85RzdnIf/fwVkJZycsL2E2y8aRt
         /4FNNfPg2S6okKgqaZFmpvHDjGf8oSwiZAdAkF7Y9f36jULgFB73xrujq/1sPqrr6zjO
         OBmI/W3KfquhZ0FPJm+oje4CfE8KXkWrGC6Xhi+rtBkLgzMXpaiHBoVvXEuqLGvKlLWj
         CCyS1YzDamkLBhOurnq2YxP0SdW2QfCfRxebiuN9Z/zy4dTa11p33ESL0je1CZA5BN0M
         Xa8IqMpvRSIWeqqqh1uphU8oHps8kd2QqFACm0WilhzcDyItcw8wq3EB4dNhoA2d27Fm
         sFOQ==
X-Gm-Message-State: ABy/qLZ4KoP2ks+0cJmZnIzzmH2P56qxGd0X9oZvWivzZTvPVPduZ8l5
        lyBN+YmCswKtD7VnrZQJxRVKig==
X-Google-Smtp-Source: APBJJlGUXdW2NNz10Fux/nRQpZltqjxWUmDtdM4q1KLlj+1iviOxOtVo+24jR9d34ugZjDtaBVHrnA==
X-Received: by 2002:a2e:9593:0:b0:2b5:8bb9:4dd6 with SMTP id w19-20020a2e9593000000b002b58bb94dd6mr7964571ljh.12.1691081772282;
        Thu, 03 Aug 2023 09:56:12 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id h4-20020a1709062dc400b0099bc2d1429csm73228eji.72.2023.08.03.09.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:56:11 -0700 (PDT)
Date:   Thu, 3 Aug 2023 19:56:10 +0300
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, anup@brainfault.org, atishp@atishpatra.org
Subject: Re: [PATCH v4 00/10] RISC-V: KVM: change get_reg/set_reg error code
Message-ID: <20230803-2e2c22d06763eb9caedade6f@orel>
References: <20230803163302.445167-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803163302.445167-1-dbarboza@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 01:32:52PM -0300, Daniel Henrique Barboza wrote:
> Hi,
> 
> This version includes a diff that Andrew mentioned in v2 [1] that I
> missed. They were squashed into patch 1.
> 
> No other changes made. Patches rebased on top of riscv_kvm_queue.
> 
> Changes from v3:
> - patch 1:
>   - added missing EINVAL - ENOENT conversions
> - v3 link: https://lore.kernel.org/kvm/20230803140022.399333-1-dbarboza@ventanamicro.com/
> 
> [1] https://lore.kernel.org/kvm/20230801222629.210929-1-dbarboza@ventanamicro.com/
> 
>

For the series,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
