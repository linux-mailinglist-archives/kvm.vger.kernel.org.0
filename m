Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51E842AA51
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhJLRMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLRME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 13:12:04 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C00C061570;
        Tue, 12 Oct 2021 10:10:02 -0700 (PDT)
Received: from zn.tnic (p200300ec2f19420044c1262ed1e42b8c.dip0.t-ipconnect.de [IPv6:2003:ec:2f19:4200:44c1:262e:d1e4:2b8c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0B5711EC047E;
        Tue, 12 Oct 2021 19:10:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634058601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5XXrAwi78Q69Ix9g7lfGOZiqH51XbjufhpwYqX5+3ow=;
        b=dZaBPVImnZGeME91U+Ej+ASNChXafT1CvzAUwHeQM1nsXq+DEM2MW4UgTFuJkXceYqBPvs
        5hupoB64Y/KZAYdGjawfi53hCFVsxAmdcyy3gmB/LKD+8fUDSYIuCb3dyd4j8kkxy/TdkT
        r6dvlrlkh94ULcBzZUpyeTsou0aVMRE=
Date:   Tue, 12 Oct 2021 19:10:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 16/31] x86/fpu: Replace KVMs homebrewn FPU copy to user
Message-ID: <YWXBa/3ck8vg7uyM@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.249593446@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011223611.249593446@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 02:00:22AM +0200, Thomas Gleixner wrote:
> Similar to the copy from user function the FPU core has this already
implemented with all bells and whistels.

"whistles"

And also, same nitpicks as here:

https://lore.kernel.org/r/YWW/PEQyQAwS9/qv@zn.tnic

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
