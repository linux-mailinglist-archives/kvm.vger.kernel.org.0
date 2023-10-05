Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655857BABA7
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 22:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjJEU4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 16:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjJEU4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 16:56:05 -0400
Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83DA93
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 13:56:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696539360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJvpeX8dRZRs8G3JgP1/dgBnAZGzrRNm5drTSTvXqgg=;
        b=Ft5UZ5EqgZBx2djNqKbw1/QXaF7Yw0xytQNnfbAVcMLMy93gyEweR8JDS+MksVHZvpi5+f
        v2Zj/ZQMK+cvP/EDXo5M/yiDClAXymEKPG9cz2uO0uSleHmKuKKvn7UgdAK4enMy+NrfyK
        76gjiNvOAHaYsnKigehyqF5pgJnqadQ=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Cleanups for managing SMCCC filter maple tree
Date:   Thu,  5 Oct 2023 20:55:50 +0000
Message-ID: <169653934673.541059.14944448680189862613.b4-ty@linux.dev>
In-Reply-To: <20231004234947.207507-1-oliver.upton@linux.dev>
References: <20231004234947.207507-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 Oct 2023 23:49:44 +0000, Oliver Upton wrote:
> Small series to clean up the way KVM manages the maple tree
> representation of the SMCCC filter, only allocating nodes in the tree if
> the SMCCC filter is used.
> 
> The other ugly bit that this fixes is the error path when 'reserved'
> ranges cannot be inserted into the maple tree, instead returning an
> error to userspace.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/3] KVM: arm64: Add a predicate for testing if SMCCC filter is configured
      https://git.kernel.org/kvmarm/kvmarm/c/bb17fb31f00e
[2/3] KVM: arm64: Only insert reserved ranges when SMCCC filter is used
      https://git.kernel.org/kvmarm/kvmarm/c/d34b76489ea0
[3/3] KVM: arm64: Use mtree_empty() to determine if SMCCC filter configured
      https://git.kernel.org/kvmarm/kvmarm/c/4202bcac5e65

--
Best,
Oliver
