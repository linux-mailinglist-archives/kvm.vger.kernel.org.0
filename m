Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4D3647F40
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 09:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLII3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 03:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiLII3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 03:29:15 -0500
Received: from out-1.mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9BB6310
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 00:29:13 -0800 (PST)
Date:   Fri, 9 Dec 2022 08:29:08 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
Message-ID: <Y5Lx1KhQvqtAvHoc@google.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209082423.yideydkw6ig6x5zg@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209082423.yideydkw6ig6x5zg@kamzik>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 09:24:23AM +0100, Andrew Jones wrote:
> On Fri, Dec 09, 2022 at 01:52:59AM +0000, Oliver Upton wrote:
> > base-commit: 89b2395859651113375101bb07cd6340b1ba3637
> 
> This commit doesn't seem to exist linux-next or kvm/queue, but the patch
> context seems to match up with linux-next pretty well. Anyway,

Ah, a force push to kvm/queue likely explains it :) I believe Paolo has
taken the first two patches in his merge resolution now on kvm/next.

> For the series
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks!

--
Best,
Oliver
