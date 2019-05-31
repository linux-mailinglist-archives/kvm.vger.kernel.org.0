Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14FF308AA
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfEaGh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:37:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45911 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbfEaGh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:37:59 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45FZWl5Lprz9sNl; Fri, 31 May 2019 16:37:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559284675; bh=+GljktcK4Xwf7/CWzN0G1s6/a0d+2xet4huIJnsiTP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NmNNWzUw6HL9v3tPmg5Wob0NdhIDcaT09I1Ch3gvoDN1/a2SrfyfvHSEmQ37uCOyb
         GLy4bXsHdbeMPyi98X8Ca4U6WtRddZMMjVm2jdWPFtZyPvYDr/qmq3Qz+/onQgofHx
         JweOFrlgVB03QrFmCta5hVUXyaXnnU4FL1iiOkfGCNTqPEPUxwLyl76G3EHJS2gF1V
         Wqt+cDy5BAkgHD5SFF4GwvAVVvELRknNzFwmOQ0x8jwlu4I0CjCBPYZOplapd/dgG1
         viEuX1FL4gCu5gfTN7OLn+Bam/qd4VqZSpMgQ+7pBp3CXK8Q0O2QKWmoVjKpvtBDEy
         NUAdQ6nMMVciQ==
Date:   Fri, 31 May 2019 16:37:52 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Restore SPRG3 in
 kvmhv_p9_guest_entry()
Message-ID: <20190531063752.GH26651@blackberry>
References: <20190530021718.22584-1-sjitindarsingh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530021718.22584-1-sjitindarsingh@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 30, 2019 at 12:17:18PM +1000, Suraj Jitindar Singh wrote:
> The sprgs are a set of 4 general purpose sprs provided for software use.
> SPRG3 is special in that it can also be read from userspace. Thus it is
> used on linux to store the cpu and numa id of the process to speed up
> syscall access to this information.
> 
> This register is overwritten with the guest value on kvm guest entry,
> and so needs to be restored on exit again. Thus restore the value on
> the guest exit path in kvmhv_p9_guest_entry().
> 
> Fixes: 95a6432ce9038 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Thanks, patch applied to my kvm-ppc-fixes branch.

Paul.
