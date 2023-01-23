Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A7D678C31
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjAWXmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjAWXmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:42:02 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BAF1207B
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:42:02 -0800 (PST)
Date:   Mon, 23 Jan 2023 23:41:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674517320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ufEGUYBZo2g28O9xzm2kDLdhCGHd7hEr8U0o7tIo63I=;
        b=xvgu9pW7eZ98nlMTWWdC0SEsBOmsq4hqrQNaWfsmKGLsW5WMhpU80IlPLwHEmIFLE88xY/
        xpTfVmk2F0fuK6+TCbVoYlTwZVsNhPf7f1noMoEBkIQuqcnepmjTg4sho35o1TSromgcbz
        ipCbZzzE2fjHY5BZYOuwJ4ZvK+Qfne8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] KVM: selftests: aarch64: page_fault_test S1PTW
 related fixes
Message-ID: <Y88bRSisoRAML0M6@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110022432.330151-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 02:24:28AM +0000, Ricardo Koller wrote:
> Commit "KVM: arm64: Fix S1PTW handling on RO memslots" changed the way
> S1PTW faults were handled by KVM.

I understand that this commit wasn't in Linus' tree at the time you sent
these patches, could you please attribute it as:

  commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")

in v2?

--
Thanks,
Oliver
