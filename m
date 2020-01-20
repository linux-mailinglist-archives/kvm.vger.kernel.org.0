Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A80142C8D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 14:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgATNvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 08:51:36 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55983 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbgATNvg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 08:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579528295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LayzTmfI9tt8icMlZ4vxXXVEjOS+TCI8dYAoQTD0v24=;
        b=hIvDugfj0hKUjghutNRfbw/Apb8Dr736AUNXd1mVqSgAxNwgkDDbWdTELoxMvy82+8NKwA
        lUB1td/U+mXI0uQvmya9FmIva7ugZbTnJ0nUKcAbH80htmcjVtxMChmc99xQtnacK3B3ea
        Xe7aoqhxgJeRwmvr80c8ZZTjlX9WmRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-BitWFVWnPIGwIT2FxLW-Pg-1; Mon, 20 Jan 2020 08:51:34 -0500
X-MC-Unique: BitWFVWnPIGwIT2FxLW-Pg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A40C1005510;
        Mon, 20 Jan 2020 13:51:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 544C510013A7;
        Mon, 20 Jan 2020 13:51:32 +0000 (UTC)
Date:   Mon, 20 Jan 2020 14:51:29 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] arm64: KVM: Add XXX UAPI notes for swapped registers
Message-ID: <20200120135129.tgucvvwbeef2q3js@kamzik.brq.redhat.com>
References: <20200120130825.28838-1-drjones@redhat.com>
 <99903fdb3e0d34cb7957981b484fc28c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99903fdb3e0d34cb7957981b484fc28c@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 20, 2020 at 01:26:32PM +0000, Marc Zyngier wrote:
> Hi Andrew,
> 
> Many thanks for this. Comments below.
> 
> On 2020-01-20 13:08, Andrew Jones wrote:
> > Two UAPI system register IDs do not derive their values from the
> > ARM system register encodings. This is because their values were
> > accidentally swapped. As the IDs are API, they cannot be changed.
> > Add XXX notes to point them out.
> > 
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.txt    |  8 ++++++++
> >  arch/arm64/include/uapi/asm/kvm.h | 11 +++++++++--
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.txt
> > b/Documentation/virt/kvm/api.txt
> > index ebb37b34dcfc..11556fc457c3 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -2196,6 +2196,14 @@ arm64 CCSIDR registers are demultiplexed by
> > CSSELR value:
> >  arm64 system registers have the following id bit patterns:
> >    0x6030 0000 0013 <op0:2> <op1:3> <crn:4> <crm:4> <op2:3>
> > 
> > +XXX: Two system register IDs do not follow the specified pattern.
> > These
> > +     are KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT, which map to
> > +     system registers CNTV_CVAL_EL0 and CNTVCT_EL0 respectively.  These
> > +     two had their values accidentally swapped, which means TIMER_CVAL
> > is
> > +     derived from the register encoding for CNTVCT_EL0 and TIMER_CNT is
> > +     derived from the register encoding for CNTV_CVAL_EL0.  As this is
> > +     API, it must remain this way.
> 
> Is 'XXX' an establiched way of documenting this kind of misfeature?
> I couldn't find any other occurrence in Documentation, but I haven't
> searched very hard.

I didn't find anything claiming it was the standard way of doing it. I
also considered using 'NOTE', but I was afraid it wouldn't stand out
as a "problem" enough. And, even though 'BUG' would certainly stand out,
I felt it implied we should be posting a fix.

Anyway, I'd be happy to change it to whatever the consensus is.

Thanks,
drew

> 
> If nobody has a better idea, I'll queue it as is.
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
> 

