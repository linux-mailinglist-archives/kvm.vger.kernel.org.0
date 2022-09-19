Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC495BC305
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 08:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiISGnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 02:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiISGnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 02:43:01 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97481C92A
        for <kvm@vger.kernel.org>; Sun, 18 Sep 2022 23:43:00 -0700 (PDT)
Date:   Mon, 19 Sep 2022 08:42:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663569779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V55IcGWC137wb1mX5jb0CcQxI2h3KFxl4Z1unw0DYyI=;
        b=afv2NcPDfwLGBkt7LzgUp8YX1eUOzKas9p1j/sC1C0zrQyf6uqoInK+c02N8pjQvtrZ+O1
        6KVrycYkdod1AsD7xWjg6Gc5+Mmuq/fV8K0Ov3G88Ne8WedsidNsQG7wRA/11vKYaziBdQ
        uxqQS9ClHcElYIbQbPureYOW26K93vU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v6 08/13] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
Message-ID: <20220919064258.4et35qlpdkkcbi4n@kamzik>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-9-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 06:09:25PM +0000, Ricardo Koller wrote:
> The previous commit added support for callers of ____vm_create() to specify
> what memslots to use for code, page-tables, and data allocations. Change
> them accordingly:
> 
> - stacks, code, and exception tables use the code memslot
> - page tables and the pgd use the pt memslot
> - data (anything allocated with vm_vaddr_alloc()) uses the data memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 +
>  .../selftests/kvm/lib/aarch64/processor.c     | 11 ++--
>  tools/testing/selftests/kvm/lib/elf.c         |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
>  .../selftests/kvm/lib/riscv/processor.c       |  7 ++-
>  .../selftests/kvm/lib/s390x/processor.c       |  7 ++-
>  .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
>  7 files changed, 61 insertions(+), 40 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
