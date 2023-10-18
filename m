Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883F87CEC6E
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 01:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjJRX7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 19:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJRX7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 19:59:17 -0400
Received: from out-200.mta0.migadu.com (out-200.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FED115
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 16:59:15 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697673552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXtxycsIRWACTBlOqPuvqXHAAfrq9Omn9IbRbTB3OX4=;
        b=G8ZxDLh2HCsn40hzC/W78ktfbucHlzrLQIkFyKx0dYmo+rt8BpKHWEcCVklQFEkIsA3wY9
        n+EoRf7snRKnmR6of8FOQbOkqNCnoIlZsD/4FReM3X2NQrPGrwdmbuPA41XXqxKiTmHL6U
        mY//GD1eu4VqeHQLLm/5KYEc+hTiLcs=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Ian Rogers <irogers@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, kvmarm@lists.linux.dev,
        Jing Zhang <jingzhangos@google.com>,
        linux-perf-users@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH v3 0/5] KVM: selftests: Add ID reg test, update headers
Date:   Wed, 18 Oct 2023 23:58:53 +0000
Message-ID: <169767345671.3025692.5465679144497115091.b4-ty@linux.dev>
In-Reply-To: <20231011195740.3349631-1-oliver.upton@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Oct 2023 19:57:35 +0000, Oliver Upton wrote:
> v2: https://lore.kernel.org/kvmarm/20231010011023.2497088-1-oliver.upton@linux.dev/
> 
> v2 -> v3:
>  - Use the kernel's script/data for generating the header instad of a
>    copy (broonie)
> 
> Jing Zhang (2):
>   tools headers arm64: Update sysreg.h with kernel sources
>   KVM: arm64: selftests: Test for setting ID register from usersapce
> 
> [...]

Applied to kvmarm/next, thanks!

[1/5] tools: arm64: Add a Makefile for generating sysreg-defs.h
      https://git.kernel.org/kvmarm/kvmarm/c/02e85f74668e
[2/5] perf build: Generate arm64's sysreg-defs.h and add to include path
      https://git.kernel.org/kvmarm/kvmarm/c/e2bdd172e665
[3/5] KVM: selftests: Generate sysreg-defs.h and add to include path
      https://git.kernel.org/kvmarm/kvmarm/c/9697d84cc3b6
[4/5] tools headers arm64: Update sysreg.h with kernel sources
      https://git.kernel.org/kvmarm/kvmarm/c/0359c946b131
[5/5] KVM: arm64: selftests: Test for setting ID register from usersapce
      https://git.kernel.org/kvmarm/kvmarm/c/54a9ea73527d

--
Best,
Oliver
