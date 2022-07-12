Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A925715D0
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiGLJdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiGLJdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:33:21 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069FF9FE03
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 02:33:20 -0700 (PDT)
Date:   Tue, 12 Jul 2022 11:33:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657618399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QtyGWX9Gz9azNLT42QqAs9tRlWogPt/scdNZm8zwqnw=;
        b=S/x4GPRV7jQfxZuhsFSChrANVRnSNO7IEM/NSJu/y6kThr9N2g2KtJXNTlig0qg7cppUpt
        PaA6K7FE+Ir2aaDhVXlSaOqiwhf46T6hQ0NuMM1gpQB5gzYf9FiJoM7TfvVMnXCTDFjI/b
        XJYBh3/r1QiJldnKg96GQnPDHPK3WyU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v4 04/13] KVM: selftests: aarch64: Export _virt_pg_map
 with a pt_memslot arg
Message-ID: <20220712093317.jvm436y3noqam76h@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-5-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 02:32:48PM -0700, Ricardo Koller wrote:
> Add an argument, pt_memslot, into _virt_pg_map in order to use a
> specific memslot for the page-table allocations performed when creating
> a new map. This will be used in a future commit to test having PTEs
> stored on memslots with different setups (e.g., hugetlb with a hole).
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h        |  3 +++
>  tools/testing/selftests/kvm/lib/aarch64/processor.c  | 12 ++++++------
>  2 files changed, 9 insertions(+), 6 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
