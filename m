Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA735BDF75
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 10:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiITINT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 04:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiITIMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 04:12:54 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5073F65557
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 01:11:27 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:11:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663661485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IvIE9X5YUprn8h5Q381bwxFzt3tBqNH7d8uNh/hNzKM=;
        b=liVpl5RmHhBpg55o+aveJ1IsNlFPe4sV0wFdLENB/TrpxF6bGjJ8gdNNAudiEacERddxw5
        EwkMYQVkriCHMyoxw+7WIPoWH3WhMfDHIOjdqhO6ETMSy+pTuN8vk8hlApKfrTzxjjhmYl
        U8Ud7N1+pBLcwvoJQyEA+2Y06G7qcWQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 01/19] Makefile: Define __ASSEMBLY__
 for assembly files
Message-ID: <20220920081124.ebxjqel6nxdy3uj6@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-2-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:40AM +0100, Alexandru Elisei wrote:
> There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
> with functionality relies on the __ASSEMBLY__ prepocessor constant being
> correctly defined to work correctly. So far, kvm-unit-tests has relied on
> the assembly files to define the constant before including any header
> files which depend on it.
> 
> Let's make sure that nobody gets this wrong and define it as a compiler
> constant when compiling assembly files. __ASSEMBLY__ is now defined for all
> .S files, even those that didn't set it explicitely before.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Makefile           | 5 ++++-
>  arm/cstart.S       | 1 -
>  arm/cstart64.S     | 1 -
>  powerpc/cstart64.S | 1 -
>  4 files changed, 4 insertions(+), 4 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
