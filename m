Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE02D7CB30F
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 20:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbjJPS4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 14:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbjJPS4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 14:56:22 -0400
Received: from out-207.mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C1CF1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 11:56:20 -0700 (PDT)
Date:   Mon, 16 Oct 2023 18:56:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697482578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vQQjQAquEUHFwTIOlRFc3Dl960V1gEuDYXsEMW41hrg=;
        b=dGIxdwwu0go+SPqMkAQeXvTySrcjqTh7FTLzo7L9hDFzYMVDpLGf56T5UONIfHu49Pl7aw
        5mOrJeiBw9bvoyFlzmevT+RURj/La/O4xoxz23Pe2pKXFMvPeeT41nA6bE3uZTYvpplZVT
        i8LGlJgQvezm30ap3Rk/VbRPKOpjlRw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
Message-ID: <ZS2HTdhFO2aywPpe@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-11-rananta@google.com>
 <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com>
 <65b8bbdb-2187-3c85-0e5d-24befcf01333@redhat.com>
 <CAJHc60zPc6eM+t7pOM19aKbf_9cMvj_LnPnG1EO35=EP0jG+Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60zPc6eM+t7pOM19aKbf_9cMvj_LnPnG1EO35=EP0jG+Tg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 02:05:29PM -0700, Raghavendra Rao Ananta wrote:
> Oliver,
> 
> Aren't the selftest patches from the 'Enable writable ID regs' series
> [1] merged into kvmarm/next? Looking at the log, I couldn't find them
> and the last patch that went from the series was [2]. Am I missing
> something?
> 
> Thank you.
> Raghavendra
> 
> [1]: https://lore.kernel.org/all/169644154288.3677537.15121340860793882283.b4-ty@linux.dev/
> [2]: https://lore.kernel.org/all/20231003230408.3405722-11-oliver.upton@linux.dev/

This is intentional, updating the tools headers as it was done in the
original series broke the perftool build. I backed out the selftest
patches, but took the rest of the kernel changes into kvmarm/next so
they could soak while we sort out the selftests mess. Hopefully we can
get the fix reviewed in time [*]...

[*] https://lore.kernel.org/kvmarm/20231011195740.3349631-1-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
