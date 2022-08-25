Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A90C5A1748
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbiHYQzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 12:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiHYQzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 12:55:43 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64A67D782
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 09:55:42 -0700 (PDT)
Date:   Thu, 25 Aug 2022 09:55:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661446541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9PfudzHyIjixtFNm5kgg7UxDCq4e85X2Ko7C0v0c3ck=;
        b=h/i5/9locmY84qikMVi6UMBRsAO2h+115nn8A9ZwnwU0o/1tsyPJ46EuWAw2DZjp0JqAIB
        /gKE0uBk0AEeN8SkUSMhech2DK6BKlwecNaPdOCFj4fAQf4+RTmBCSUgP1hbVEGbzmJTnU
        vmlz/ELltbeY/1diG1mklx0iHrjIKtY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
Message-ID: <Ywepg6c4FT7DvJ83@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-4-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-4-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 10:08:40PM -0700, Reiji Watanabe wrote:
> Remove the hard-coded {break,watch}point #0 from the guest_code()
> in debug-exceptions to allow {break,watch}point number to be
> specified.  Subsequent patches will add test cases for non-zero
> {break,watch}points.

Also worth mentioning that you're opportunistically zeroing the debug
registers as their values are UNKNOWN out of reset.

--
Thanks,
Oliver
