Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D03525786
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 00:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359036AbiELWCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 18:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348898AbiELWCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 18:02:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C2E27F114;
        Thu, 12 May 2022 15:02:21 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 35AD51EC06F6;
        Fri, 13 May 2022 00:02:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1652392935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZfuYJJ1ehnbQI3XEJGqmrBwq17rMtkdXP7hCyuWOyIU=;
        b=Z+TIOI+76qq7P9+x82jo8GiZLgA/fLMKqZtWLtrU4WG9CMW+5DEM+9eBqbuzGf0fs9Mr2f
        8FKg+QQ7L7GXqx3/w6uo3ZdRvUukBWuVN/Lp9jAJDYiT77fj+E0OxnJaZ7GchkkvP5xkEw
        f/XZlWCU1w0NKh+zA+ogvobv/UScyDc=
Date:   Fri, 13 May 2022 00:02:21 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, theflow@google.com,
        rientjes@google.com, pgonda@google.com, john.allen@amd.com
Subject: Re: [PATCH] KVM: SVM: Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak.
Message-ID: <Yn2D7UjbBAiwxChT@zn.tnic>
References: <20220512202328.2453895-1-Ashish.Kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512202328.2453895-1-Ashish.Kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 08:23:28PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> For some sev ioctl interfaces, the length parameter that is passed maybe
> less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
> that PSP firmware returns. In this case, kmalloc will allocate memory
> that is the size of the input rather than the size of the data.
> Since PSP firmware doesn't fully overwrite the allocated buffer, these
> sev ioctl interface may return uninitialized kernel slab memory.
> 
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Peter Gonda <pgonda@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

This looks like it needs one (or more) Fixes: tags pointing to the
patch(es) adding those kmalloc calls...

And then Cc: <stable@vger.kernel.org> too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
