Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349595BE09C
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 10:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiITIqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 04:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiITIp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 04:45:56 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C88D248C6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 01:45:55 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:45:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663663554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lMg8dliGJzByApcJFv4j6u1kjHjAp/4NbWInC1+sFlA=;
        b=oPo+LehcYlQPGSyYqZ6y8gkPKtAGt6xIaMLXot7pMzW8JpnxTtavDoTPRlwinKwA9rtxKn
        EgsNsq1zk71pLcJGebkUBQjgZcvJ/3V7uwPEMg8U+K0j0xUL/+ckH2OTtS9w+YKiKxaYQj
        FrW7Yckk5dRn8Gm/0X7JuJFyJAhRM68=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 05/19] lib/alloc_phys: Remove locking
Message-ID: <20220920084553.734jvkqpognzgfpr@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-6-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-6-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:44AM +0100, Alexandru Elisei wrote:
> With powerpc moving the page allocator, there are no architectures left
> which use the physical allocator after the boot setup:  arm, arm64,
> s390x and powerpc drain the physical allocator to initialize the page
> allocator; and x86 calls setup_vm() to drain the allocator for each of
> the tests that allocate memory.

Please put the motivation for this change in the commit message. I looked
ahead at the next patch to find it, but I'm not sure I agree with it. We
should be able to keep the locking even when used early, since we probably
need our locking to be something we can use early elsewhere anyway.

Thanks,
drew
