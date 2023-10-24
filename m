Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5C07D4E09
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 12:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbjJXKhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 06:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbjJXKhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 06:37:04 -0400
Received: from out-208.mta1.migadu.com (out-208.mta1.migadu.com [IPv6:2001:41d0:203:375::d0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2D3E9
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 03:37:02 -0700 (PDT)
Date:   Tue, 24 Oct 2023 10:36:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698143820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RaUc/Jh4+pZIFR1fAHzmEjaXtHZw7YWxzJm5LgrjjuY=;
        b=WU3amu7+Q5EXmgP9gUt1h0OgzkOD7zhq9OHo9UNenhwInKHnBObC/0S5S+UVCgnt9ovhYQ
        jy9NQY1SpdyoSGenZuSPFLA30au1dorNNAfSfueDjGgghHaWHvXeZLTt73DcLS1qya06pe
        /ILtcar6fYZy/j4RNgVsRgm/VwQ4KQI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v8 13/13] KVM: selftests: aarch64: vPMU test for
 immutability
Message-ID: <ZTeeR7xHmMELgVGZ@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-14-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020214053.2144305-14-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 09:40:53PM +0000, Raghavendra Rao Ananta wrote:
> KVM marks some of the vPMU registers as immutable to
> userspace once the vCPU has started running. Add a test
> scenario to check this behavior.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Now that PMCR_EL0.N is the only thing that's getting the immutability
treatment this patch fails. I'll probably drop it.

-- 
Thanks,
Oliver
