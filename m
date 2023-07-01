Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D4E744A2A
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjGAOxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 10:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjGAOxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 10:53:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD2835BC
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 07:53:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-51d804c7d14so3053170a12.3
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 07:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688223229; x=1690815229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4z5avgOZM94E55xJX5yHh1jEBdl/Nv8eTHj3o1PmFnI=;
        b=IqkaY/63sYcOG0vwtmF02wpU+mNr/gP2fHYz9of1UNY2Q45RQUGKnr0nycE74z3Vq+
         vRH+iq/bEWHzZQJFNk5D1eABcSm/7HMxFYJiaIg+wuXbW55cwpQiwwq7ZbxPO2QlnkIj
         9iVfVrEWAevgKZSOtWpo/0swSzpiq3/5R0+5tvpX1ycDHSi/sX9HFmLv96haLzn08jMc
         DY4baiQluiuE8NdVxL1tqe/WSUZ5z1uxB9P1GEc7MeQjDLyJWrhwO9i9VTqG5iE4w+Nj
         cKCOO9fcg9SfxcuWGrOsZkI7RcxYFElB3npOI1snh4RreMoNrKyv6N+PeDCQ9R1qg56C
         GLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688223229; x=1690815229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4z5avgOZM94E55xJX5yHh1jEBdl/Nv8eTHj3o1PmFnI=;
        b=VuhJOoIbRKmCi2TunAzV3YWsQa+b9QNCHj4CJ+u51b87uAwi2NdCnihAu3R+9nvj5E
         wBKhTxehdnZ+r4u8YkpZ0aKjmAfaj0OaY5ztfSksjVBNsx8M/GnJ0Ho2WxsAn0xXYLgx
         9IVHrv1sNLDJsBaN9OkvxrSquo/+aIZzYKm6iTF1afLWJlNXRUWkt++AdTi34jALZXq9
         LGfsFr0IizVJwHzxhsLZ1OQy4W6uUxgzk3VCwH8KBdvfJqb0QQtFA4wtXtpGGEMjiL/f
         tESjwJhk3bCOxZKUuJ5800IW8/XFy4hTL9V4DXjEjHI02ZQyDD1OEEgdF3e6yjUU8Ucu
         W72g==
X-Gm-Message-State: AC+VfDw3HLcV0+yuheCSdSKrAW+EuYW4V9ZfOUvfi5K2rMWDY+Icrzfn
        FT2WABn4YWbJCWngox4mwGN6eQ==
X-Google-Smtp-Source: APBJJlFbTncNQknWuK6Y34dd/Vq9wobBPzkzq5+JVS2JfwhQSw4EsBA/mzFykhnRWmdndPeE2HFOZQ==
X-Received: by 2002:a17:906:4093:b0:992:a85d:278b with SMTP id u19-20020a170906409300b00992a85d278bmr3179852ejj.59.1688223228877;
        Sat, 01 Jul 2023 07:53:48 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id lf1-20020a170907174100b0098d2261d189sm1025110ejc.19.2023.07.01.07.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Jul 2023 07:53:48 -0700 (PDT)
Date:   Sat, 1 Jul 2023 16:53:47 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Haibo Xu <haibo1.xu@intel.com>
Cc:     xiaobo55x@gmail.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Shuah Khan <shuah@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kselftest@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 00/13] RISCV: Add KVM_GET_REG_LIST API
Message-ID: <20230701-e1bff47a0ed38ec3ab6ca252@orel>
References: <cover.1688010022.git.haibo1.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1688010022.git.haibo1.xu@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 01, 2023 at 09:42:48PM +0800, Haibo Xu wrote:
> KVM_GET_REG_LIST will dump all register IDs that are available to
> KVM_GET/SET_ONE_REG and It's very useful to identify some platform
> regression issue during VM migration.
> 
> Patch 1-7 re-structured the get-reg-list test in aarch64 to make some
> of the code as common test framework that can be shared by riscv.
> 
> Patch 8 move reject_set check logic to a function so as to check for
> different errno for different registers.
> Patch 9 move finalize_vcpu back to run_test so that riscv can implement
> its specific operation.
> Patch 10 change to do the get/set operation only on present-blessed list.
> Patch 11 add the skip_set facilities so that riscv can skip set operation
> on some registers.
> Patch 12 enabled the KVM_GET_REG_LIST API in riscv.
> patch 13 added the corresponding kselftest for checking possible
> register regressions.
> 
> The get-reg-list kvm selftest was ported from aarch64 and tested with
> Linux v6.4 on a Qemu riscv64 virt machine.

Hi Haibo,

This series needs a rebase on top of these recent patches

 commit ee053e03b08e ("KVM: selftests: get-reg-list: support ID register features")
 commit 5f0419a0083b ("KVM: selftests: get-reg-list: add Permission Indirection registers")

The conflicts will be in my patches, which do the splitting of the test.
I'll do the rebase and push it to a branch for you to pick up.

Thanks,
drew
