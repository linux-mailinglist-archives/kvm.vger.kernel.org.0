Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E829E6106DD
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 02:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiJ1Abk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 20:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbiJ1Abj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 20:31:39 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102419AF94
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:31:37 -0700 (PDT)
Date:   Fri, 28 Oct 2022 00:31:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666917096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PWuFABbLpqs2NAt/gdQJrSTxN1tTAAGw3VvyTSX82Q4=;
        b=o1RskzbvFutkErsWCwGYjImhMuupkGgeqEHUyt5yh/abpipttj2iGC4UPtNb6aYekYZsFX
        LE+LDPYsaJusmbUecSTAF7v31hu2EDHfvQ6BhIYspMxKtnFfOKl0mvGGFdCOfDzFJ9ANun
        8nCuFiBekyvEutRBRo/y+7AsiT6KJWY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 04/25] KVM: arm64: Fix-up hyp stage-1 refcounts for
 all pages mapped at EL2
Message-ID: <Y1si442I6GsEmwz1@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-5-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020133827.5541-5-will@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022 at 02:38:06PM +0100, Will Deacon wrote:
> From: Quentin Perret <qperret@google.com>
> 
> In order to allow unmapping arbitrary memory pages from the hypervisor
> stage-1 page-table, fix-up the initial refcount for pages that have been
> mapped before the 'vmemmap' array was up and running so that it
> accurately accounts for all existing hypervisor mappings.
> 
> This is achieved by traversing the entire hypervisor stage-1 page-table
> during initialisation of EL2 and updating the corresponding
> 'struct hyp_page' for each valid mapping.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
