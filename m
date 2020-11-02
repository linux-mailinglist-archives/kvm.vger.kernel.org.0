Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2612A263A
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 09:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgKBIip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 03:38:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727953AbgKBIip (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 03:38:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604306324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iKprBlRGMj1c6o4rrrCoX/rFjaOYaPOS8vcmwCUOrZI=;
        b=fDolofl1Da3dJwYOYpCkKQzHoKb5my5163AoRjvaPuDzmSUd3Tl1DM+bBsyu6faYuoDVpT
        hffV9kcoH3EphqCWX7LWZ99DqDA0+H7COaD3eVJWEI8WQq9oSJaYxb4QG4bFMn8EsMu8yF
        B8sqhnIj4x6KMmElvPzC8q77Lz+Hzy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-p-ZdT5QJPvGRJvwdzpI1sg-1; Mon, 02 Nov 2020 03:38:43 -0500
X-MC-Unique: p-ZdT5QJPvGRJvwdzpI1sg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB8B66414D;
        Mon,  2 Nov 2020 08:38:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8D1E1002C13;
        Mon,  2 Nov 2020 08:38:36 +0000 (UTC)
Date:   Mon, 2 Nov 2020 09:38:33 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, Dave.Martin@arm.com, peter.maydell@linaro.org,
        eric.auger@redhat.com
Subject: Re: [PATCH 3/4] KVM: selftests: Update aarch64 get-reg-list blessed
 list
Message-ID: <20201102083833.zjqrlmyvwfir2du4@kamzik.brq.redhat.com>
References: <20201029201703.102716-1-drjones@redhat.com>
 <20201029201703.102716-4-drjones@redhat.com>
 <875z6qdy63.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z6qdy63.wl-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 31, 2020 at 06:53:56PM +0000, Marc Zyngier wrote:
> On Thu, 29 Oct 2020 20:17:02 +0000,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > The new registers come from the following commits:
> > 
> > commit 99adb567632b ("KVM: arm/arm64: Add save/restore support for
> > firmware workaround state")
> > 
> > commit c773ae2b3476 ("KVM: arm64: Save/Restore guest DISR_EL1")
> > 
> > commit 03fdfb269009 ("KVM: arm64: Don't write junk to sysregs on reset")
> > 
> > The last commit, which adds ARM64_SYS_REG(3, 3, 9, 12, 0) (PMCR_EL0),
> > and was committed for v5.3, doesn't indicate in its commit message that
> > enumerating it for save/restore was the plan, so doing so may have
> > been by accident.
> 
> It definitely was.
> 
> > It's a good idea anyway, though, since the other PMU registers have
> > been enumerated since v4.10.
> 
> Quite. The state of the PMU is pretty much unknown on restore until then.
> 
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > index 3aeb3de780a1..3ff097f6886e 100644
> > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > @@ -352,7 +352,8 @@ int main(int ac, char **av)
> >  }
> >  
> >  /*
> > - * The current blessed list comes from kernel version v4.15 with --core-reg-fixup
> > + * The current blessed list was primed with the output of kernel version
> > + * v4.15 with --core-reg-fixup and then later updated with new registers.
> 
> Maybe have a reference to the last kernel version this was checked
> against? Either here or in the commit message?

Good idea. I'll put it in the comment in list form, encouraging the list
to be continued as we add more.

Thanks,
drew

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 

