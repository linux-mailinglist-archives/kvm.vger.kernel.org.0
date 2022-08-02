Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31535587A39
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 12:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbiHBJ74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 05:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbiHBJ7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 05:59:54 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70E64B0DB;
        Tue,  2 Aug 2022 02:59:36 -0700 (PDT)
Date:   Tue, 2 Aug 2022 11:59:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659434369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ay3K85QSYV80PgriqnDkVzOzpOoV2c7weEjvxL7cKPY=;
        b=EErbkf1WcAr23f4tDfnoXIoO0O3PzqBeahzq+IrvtLYahUN8X1lozZfc8KLspUvcI8bC3K
        /RVI1FQzZ5rR/uRwPesjYsuGiRRupFhPMq0UD2y/MpEXY8Bk+BaRC7RlvwmvtiVMZkv97n
        t4Ehm3/+JhXlpZS2pZp3IlEVjJF7DFI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com
Subject: Re: [V2 01/11] KVM: selftests: move vm_phy_pages_alloc() earlier in
 file
Message-ID: <20220802095928.ex63dnyilii5raeg@kamzik>
References: <20220801201109.825284-1-pgonda@google.com>
 <20220801201109.825284-2-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801201109.825284-2-pgonda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022 at 01:10:59PM -0700, Peter Gonda wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> Subsequent patches will break some of this code out into file-local
> helper functions, which will be used by functions like vm_vaddr_alloc(),
> which currently are defined earlier in the file, so a forward
> declaration would be needed.
> 
> Instead, move it earlier in the file, just above vm_vaddr_alloc() and
> and friends, which are the main users.
> 
> Reviewed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 145 ++++++++++-----------
>  1 file changed, 72 insertions(+), 73 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
