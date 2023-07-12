Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11109750A45
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 16:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjGLOA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 10:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjGLOA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 10:00:27 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D46110CB;
        Wed, 12 Jul 2023 07:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JsHjcfEV6pSPK+JxFib1lSkQZn17orkL6Jg4+w81zvo=; b=f/NATlp2IbP6+NFN57dKsFEcgm
        aDbcRCX8GsAUD+nmdol9bs7acSM82xypzP6JF6YB/uT7YS3GIe0YID3a99Lphpsm1cYijtGmup35p
        UFNho8uPCIZkmys8ja49MoLOOaRA1+jhPeiL+cS+BocgjGy+fLQLa21fmPKCgLOwEDLIzRzuUC1Lg
        VAiE+KldIbNvbQBphCNLMqmRsFj0bTQtoDynP0QPcdy6mUvw+SAGvCcR8wQZ8ExiKI5/lyGoTDi/w
        A+JjLnnwrjAzafafV7RwqLpQyC3G/lO5SWpn4bHWZ1D+4WB12b65CvJHsFl4HtFGnJVa4Q+P2PkkQ
        vR39Uz7Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJaNr-003fiV-0A;
        Wed, 12 Jul 2023 13:59:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 613EB3001E7;
        Wed, 12 Jul 2023 15:59:57 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 11F8D24408320; Wed, 12 Jul 2023 15:59:57 +0200 (CEST)
Date:   Wed, 12 Jul 2023 15:59:56 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     huzhi001@208suo.com
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SVM: Fix warnings in svm.h
Message-ID: <20230712135956.GA3100121@hirez.programming.kicks-ass.net>
References: <tencent_B97FAD99B25D9BCC5AB9EA89BA04061D7B07@qq.com>
 <e541a2b2fe55ade4277f34fa64953683@208suo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e541a2b2fe55ade4277f34fa64953683@208suo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 09:39:24PM +0800, huzhi001@208suo.com wrote:
> The following checkpatch warnings are removed:
> WARNING: Prefer __packed over __attribute__((__packed__))

Can you please stop with these pointless checkpatch things?
