Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA4C4F6DBD
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 00:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiDFWNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 18:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiDFWN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 18:13:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59265C351;
        Wed,  6 Apr 2022 15:11:30 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649283088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kjO+FcQEbzxNg96q+CVmF00/Fnf4v+c6IvBo4ypadGM=;
        b=MDuDrMsLXT/GQRVb1ZTFGX5T1I+FdkjJWTul1ShjgI4pL+Dl8SLAHZGvNn6gjOifz29Aij
        LtwQGLnBbbAaxhNsSJHXixYSJPAkT5PXM/LIHVVsjwRHIA82U5PyFhHwUhMHpnjg9DkUpK
        XDWhiJALkz/J82FdRql2L4Tn8dExuRbpLwTkBxOkzOggDC9O/J7n4iyYlkAgRFii0kky9M
        gRCUhTIW+opQ9cHKacXd0v31t0o4eyOWXV/GnPY9wHGeXfgphZ3nvpglWFHLl+iKOJVNf0
        bx7RuROx41KU9bEMsqOpKLZpSHOyBvPMo89txpgbl+CjlIz2XxqPfK1OS2X4oA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649283088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kjO+FcQEbzxNg96q+CVmF00/Fnf4v+c6IvBo4ypadGM=;
        b=/JM3+JRbyPJzN47EjFTCmy7kGOujjw4LAotjVETTRqG+McDzrvIwV7iirZ2G3TRLNTSinL
        FgoFrheKZGhP44AQ==
To:     Reto Buerki <reet@codelabs.ch>, dwmw2@infradead.org
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        decui@microsoft.com
Subject: Re: [PATCH] x86/msi: Fix msi message data shadow struct
In-Reply-To: <20220406083624.38739-2-reet@codelabs.ch>
References: <20201024213535.443185-13-dwmw2@infradead.org>
 <20220406083624.38739-1-reet@codelabs.ch>
 <20220406083624.38739-2-reet@codelabs.ch>
Date:   Thu, 07 Apr 2022 00:11:28 +0200
Message-ID: <87pmltzwtr.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reto,

On Wed, Apr 06 2022 at 10:36, Reto Buerki wrote:

> The x86 MSI message data is 32 bits in total and is either in
> compatibility or remappable format, see Intel Virtualization Technology
> for Directed I/O, section 5.1.2.
>
> Fixes: 6285aa50736 ("x86/msi: Provide msi message shadow structs")
> Signed-off-by: Reto Buerki <reet@codelabs.ch>
> Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>

This signed-off by chain is incorrect. It would be correct if Adrian-Ken
would have sent the patch.

If you both worked on that then please use the Co-developed-by tag
according to Documentation/process/

Thanks,

        tglx
