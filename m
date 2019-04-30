Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F68F3D5
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 12:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfD3KMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 06:12:05 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59917 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfD3KL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:56 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tcky07jRz9sBV; Tue, 30 Apr 2019 20:11:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619114; bh=LuIQ+iCOSPu2/Ni+p1+F+mQ9pmu8qAjX69x2EKev9Gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nWgWHRCVCv0YVRSwgzPruOcOC5sz5H0ClQUHjE1Xu6ZLCuO2GYkC0BWKQMWm7bf/W
         RtkUXdl4e9r94Fh6+7kmjG/k2MS9J11evt8ZUZ88fIrFZ8Nx0usqxmmfv4uxtLl+SF
         2SV21HXZtmN4D6SiX8wgzGljXkDK//2HX4fy2euR+k5WDhwW1YTAFdntx+taW1JdlN
         6PC+au/EgjBPpjmCSaxcldby8pJc1ukUvdxeSnsd7FhWXgACSMPdLJl/uSHRSU0Azn
         8X1EPT4y35iU5TCLjJXk8HEd4NuyGZAQL1nT2HsmpyphTyOlIYy8eF5HLI7zsBEaNH
         OWKsz0nOC/Frw==
Date:   Tue, 30 Apr 2019 20:08:52 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Save/restore vrsave register in
 kvmhv_p9_guest_entry()
Message-ID: <20190430100852.GI32205@blackberry>
References: <20190430004123.1189-1-sjitindarsingh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430004123.1189-1-sjitindarsingh@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 30, 2019 at 10:41:23AM +1000, Suraj Jitindar Singh wrote:
> On POWER9 and later processors where the host can schedule vcpus on a
> per thread basis, there is a streamlined entry path used when the guest
> is radix. This entry path saves/restores the fp and vr state in
> kvmhv_p9_guest_entry() by calling store_[fp/vr]_state() and
> load_[fp/vr]_state(). This is the same as the old entry path however the
> old entry path also saved/restored the VRSAVE register, which isn't done
> in the new entry path.
> 
> This means that the vrsave register is now volatile across guest exit,
> which is an incorrect change in behaviour.
> 
> Fix this by saving/restoring the vrsave register in kvmhv_p9_guest_entry().
> This restores the old, correct, behaviour.
> 
> Fixes: 95a6432ce9038 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Thanks, patch applied to my kvm-ppc-next tree.

Paul.
