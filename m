Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741DDBBFD7
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 04:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408471AbfIXCAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 22:00:15 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57683 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403911AbfIXCAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 22:00:15 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46cksm0bnJz9sPD; Tue, 24 Sep 2019 12:00:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1569290412; bh=F0DERsYtSEB1KeU4aXE2khuRBkBPk2w2y5WkNRrb5aQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U5I2mKiTRnLAblbxjNp3TURp4m5h/YNumK+o2L+lMu8qC9u7PBm8ZD8dWnVZnFpvx
         wvvx5fJlaxPPqbLj8BujB+S2Q28JJZClZDKGCIyfMVAtHPJFuVR8E2jwym77EXzhL/
         aDBW9SBEXOQnCnH2ob3e/iuhPZ6z/zADqRQgTN+7oeqd/sepr8cZTJgwewDizLNDq8
         Xk1ymUyK41pJ22VxxuOfKbO+x9tBLzhaXYUs+BgBCONDv2XyviHR/dodSrLCP/Jsz+
         n66G/UQTE/4H8JO/jfmXaqE9uxUofAiUSK6M01tJEuu9v8GZyn5sXEUOIXNNiZH70h
         0PNvaH7p6qb9A==
Date:   Tue, 24 Sep 2019 12:00:08 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 0/3] Replace current->mm by kvm->mm on powerpc/kvm
Message-ID: <20190924020008.GA4011@oak.ozlabs.ibm.com>
References: <20190923212409.7153-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923212409.7153-1-leonardo@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 06:24:06PM -0300, Leonardo Bras wrote:
> By replacing, we would reduce the use of 'global' current on code,
> relying more in the contents of kvm struct.
> 
> On code, I found that in kvm_create_vm() there is:
> kvm->mm = current->mm;
> 
> And that on every kvm_*_ioctl we have tests like that:
> if (kvm->mm != current->mm)
>         return -EIO;
> 
> So this change would be safe.
> 
> I split the changes in 3 patches, so it would be easier to read
> and reject separated parts. If decided that squashing is better,
> I see no problem doing that.

The patch series looks fine.  It has missed the 5.4 merge window, and
it doesn't fix any bugs, so I will queue it up for the 5.5 merge
window, meaning that I will put it into my kvm-ppc-next branch when I
prepare it for the 5.5 merge window, probably in about a month from
now.

This remark also applies to your other patch "Reduce calls to get
current->mm by storing the value locally".

Thanks,
Paul.
