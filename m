Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4167B71DD
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 21:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240895AbjJCTh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 15:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240785AbjJCTh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 15:37:57 -0400
Received: from out-205.mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A522AF
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 12:37:52 -0700 (PDT)
Date:   Tue, 3 Oct 2023 19:37:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696361870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YtXaNvHngFX0IzJjRWG18vIM/JoRqgDDYQKMe9T+5DM=;
        b=iyACOp9wXrqlmaJgyYpxZku3S64gdoFa3AQZON6MwlcUh4giHAMLkJWkwc4d0/4/xDeyY8
        ctsx/M45mK9XfRHdMHRZiIeOXw4UkvrIo8aUjf8NaFhgD/+VqkbvCyWqZx0Y3FaibNpdLF
        s0t20gZh9R5Vfdg1SCxuU5KbGc86Gpc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kernel test robot <lkp@intel.com>
Cc:     kvmarm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v10 10/12] KVM: arm64: Document vCPU feature selection
 UAPIs
Message-ID: <ZRxtiKlKHiCBBlZE@linux.dev>
References: <20230920183310.1163034-11-oliver.upton@linux.dev>
 <202309271037.rM4DMYYZ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202309271037.rM4DMYYZ-lkp@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 10:45:34AM +0800, kernel test robot wrote:
> Hi Oliver,
> 
> kernel test robot noticed the following build warnings:

Looks like I failed to include the diff that adds the labels I'm
referencing, which is addressed with the following:


diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8cd91bc550bc..6068b711cdb0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3370,6 +3370,8 @@ return indicates the attribute is implemented.  It does not necessarily
 indicate that the attribute can be read or written in the device's
 current state.  "addr" is ignored.
 
+.. _KVM_ARM_VCPU_INIT:
+
 4.82 KVM_ARM_VCPU_INIT
 ----------------------
 
@@ -6070,6 +6072,8 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+.. _KVM_ARM_GET_REG_WRITABLE_MASKS:
+
 4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
 -------------------------------------------
 
-- 
Thanks,
Oliver
