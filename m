Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315536EF930
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjDZRWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjDZRWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:22:12 -0400
Received: from out-58.mta1.migadu.com (out-58.mta1.migadu.com [IPv6:2001:41d0:203:375::3a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AC32701
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:22:08 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:21:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682529725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yLWhzFr0IaFOP7oGWZVxeoPyLpaGebSmTPqngfIpZG0=;
        b=fX1xUvV2g81JM+0ABsdRcIjDsB/4E25/qjtfu0mosg0PvfMF9EHtEmDRZTz3iFWTYkK0dA
        19FAfDwYGMolyePLVnuvhqZX1xWo1FbUgjHuNPt4/BF+tVLHSMDVjtXDd0o5kYB6/qHrji
        BF94HvG+MfWGhmnvQOaFbIcWpIUF+yQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 0/4] KVM: Refactor KVM stats macros and enable custom
 stat names
Message-ID: <ZEldtrUVBgmlrFOl@linux.dev>
References: <20230306190156.434452-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 11:01:52AM -0800, David Matlack wrote:
> This series refactors the KVM stats macros to reduce duplication and
> adds the support for choosing custom names for stats.
> 
> Custom name makes it possible to decouple the userspace-visible stat
> names from their internal representation in C. This can allow future
> commits to refactor the various stats structs without impacting
> userspace tools that read KVM stats.
> 
> This also allows stats to be stored in data structures such as arrays,
> without needing unions to access specific stats. Case in point, the last
> patch in this series removes the pages_{4k,2m,1g} union, which is a
> useful cleanup to prepare for sharing paging code across architectures
> [1].
> 
> And for full transparency, another motivation for this series it that at
> Google we have several out-of-tree stats that use arrays. Custom name
> support is something we added internally and it reduces our technical
> debt to get the support merged upstream.

For the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
