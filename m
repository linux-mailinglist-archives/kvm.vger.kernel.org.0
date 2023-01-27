Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F58967F217
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 00:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjA0XKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 18:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjA0XKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 18:10:44 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCCFEC7A
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 15:10:43 -0800 (PST)
Date:   Fri, 27 Jan 2023 23:10:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674861041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZO3SgWOS/7Szzg9zC9NbHnkwsueuqHnRdzYR3FBmDcU=;
        b=xuNbVLxDbxsQ6PCYOaKt2KVwp9CaRXhbKze444e3b3t8P6hrfvVh/4KXMeFme7/dvYovSD
        H5oXA22EQHRiAJUem0LVY1Y8BraVMWXrkbKNsrXEK1Y0sPiLPEmiOp8Zslm2/cgtWdmSZF
        HDPR9hhnL2PrdYlbz2XoIt+Oz/mMX1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/4] KVM: selftests: aarch64: page_fault_test S1PTW
 related fixes
Message-ID: <Y9RZ7lkKPeg8MnvE@google.com>
References: <20230127214353.245671-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 09:43:49PM +0000, Ricardo Koller wrote:

[...]

> Changes from v1:
> - added sha1's for commit "KVM: arm64: Fix S1PTW handling on RO
>   memslots" in all messages. (Oliver)
> - removed _with_af from RO macro. (Oliver)
> 
> Ricardo Koller (4):
>   KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
>   KVM: selftests: aarch64: Do not default to dirty PTE pages on all
>     S1PTWs
>   KVM: selftests: aarch64: Fix check of dirty log PT write
>   KVM: selftests: aarch64: Test read-only PT memory regions

These all LGTM, thanks for respinning. Tested these patches on an Altra
machine.

Marc, I leave it up to you if you want to grab these patches for /fixes,
otherwise I'll take them for 6.3. If you wind up applying these, for the
series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
