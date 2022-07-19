Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACEC57A3F3
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 18:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbiGSQJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 12:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiGSQJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 12:09:17 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC16D48C97
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 09:09:16 -0700 (PDT)
Date:   Tue, 19 Jul 2022 18:09:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658246955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PomFpD3Ft8w4EXIcYYRbknb5gcDF6SvykBWXXItNT0c=;
        b=ZQscM/HaNvvMWtE+3xtYVK1Y1KfJVFKdwbQK7NtOAXgE6prda7P5ZnNPgn/7VD8vIvevoI
        T0El26QA0gKHGJkIg1aZ2CxbOBGhkN15IU4l3TZLe5vkyYEAyTntpntlWOyiknMwtxVV/I
        GzVwSxH0hedgmJ7+V1kac6NrpcGBjvY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 0/3] selftests: KVM: Improvements to binary stats test
Message-ID: <20220719160914.tqpujfddvifhyfxh@kamzik>
References: <20220719143134.3246798-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719143134.3246798-1-oliver.upton@linux.dev>
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

On Tue, Jul 19, 2022 at 02:31:31PM +0000, Oliver Upton wrote:
> From: Oliver Upton <oupton@google.com>
> 
> Small series to improve the debuggability of the binary stats test w/
> more descriptive test assertions + add coverage for boolean stats.
> 
> Applies to kvm/queue, with the following patches applied:
> 
>  - 1b870fa5573e ("kvm: stats: tell userspace which values are boolean")
>  - https://lore.kernel.org/kvm/20220719125229.2934273-1-oupton@google.com/
> 
> First time sending patches from my new inbox, apologies if I've screwed
> something up.
> 
> Oliver Upton (3):
>   selftests: KVM: Check stat name before other fields
>   selftests: KVM: Provide descriptive assertions in
>     kvm_binary_stats_test
>   selftests: KVM: Add exponent check for boolean stats
> 
>  .../selftests/kvm/kvm_binary_stats_test.c     | 38 +++++++++++++------
>  1 file changed, 27 insertions(+), 11 deletions(-)
> 
> -- 
> 2.37.0.170.g444d1eabd0-goog
>

For the series,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
