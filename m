Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4A942EE65
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 12:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbhJOKIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 06:08:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58365 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230353AbhJOKIA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 06:08:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634292353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b0uHWXZnqeTxhuKyqKx8y/HRcY8yBSsrr8AiAitLaHk=;
        b=UD/PEFeyM/xCZx3njuGiQNg2mHfVPV1syzCnDVybQVjnPg2sz5dqOIHxCPNheMcmDrft0x
        m1Y2MDHoWxQxPSd3FJ6rwc8uNOd1gCJ6r4TcQ+v397PkVVr95pKwTlix4rPMLqxCK2bcxp
        c31HrJCfr+jwVyARG5IZBcscsVgP1iY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-BtMFqJs2M8GsPntUw7-eQw-1; Fri, 15 Oct 2021 06:05:52 -0400
X-MC-Unique: BtMFqJs2M8GsPntUw7-eQw-1
Received: by mail-wr1-f72.google.com with SMTP id a15-20020a056000188f00b00161068d8461so5777300wri.11
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 03:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b0uHWXZnqeTxhuKyqKx8y/HRcY8yBSsrr8AiAitLaHk=;
        b=iAangSOXStJYlKq1qXuoTmGp+AW31Gsms9ZofEcS7ByZTk4cbpYadwFfAp1JI5Knnk
         DUnCo1WdWp2h09SJZvf8xWkyrxYY6wtBfHEKAjuMu9BAV9hR04aYVcD/iv13TALqkwAT
         sXZDVbirEb5BRKmM66ZVwdeDkSranMf058RvKiIr9fHUDniFh7xxwHnZgBquk32/B93O
         cxDTTeZYzLSZNbxPxVI4eIOxoZ51LoboMTjJ4qE4QD09Eg98Kote+SMEuH29cxwjd9bh
         TO5zn1WYOKdh2ru1FpoTCqgwIVuFTnR436FLmVRd8sKZ2SCAzOoPEoImGTJhhlmmS4D9
         KTbQ==
X-Gm-Message-State: AOAM530jTqKWx+CHSaPngOuyXHbYTwruNpHy4w1Dg1j0P9MkzA9JscAW
        ylq4dRoYUPYLuY77xXlDLfwyws3jxDIlv9diF/bg4cGBE8Ut55z9kzIRnnErcQm1rtCpqIFg/XX
        V6ovriJSbyWS/
X-Received: by 2002:a1c:a791:: with SMTP id q139mr11551237wme.102.1634292351349;
        Fri, 15 Oct 2021 03:05:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfXBNIKizN+SJiZFGqzqQgnO0A5xN/k3JphvbQHlTMEeg7cXSlABUxCwsJlYSRI54rXUqToQ==
X-Received: by 2002:a1c:a791:: with SMTP id q139mr11551220wme.102.1634292351151;
        Fri, 15 Oct 2021 03:05:51 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id a2sm4558837wru.82.2021.10.15.03.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 03:05:50 -0700 (PDT)
Date:   Fri, 15 Oct 2021 12:05:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH 0/5] KVM: arm64: Reorganise vcpu first run
Message-ID: <20211015100548.4yd2ukon5rypexoo@gator>
References: <20211015090822.2994920-1-maz@kernel.org>
 <20211015094900.pl2gyysitpnszojy@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015094900.pl2gyysitpnszojy@gator>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 11:49:00AM +0200, Andrew Jones wrote:
> On Fri, Oct 15, 2021 at 10:08:17AM +0100, Marc Zyngier wrote:
> > KVM/arm64 relies heavily on a bunch of things to be done on the first
> > run of the vcpu. We also do a bunch of things on PID change. It turns
> > out that these two things are pretty similar (the first PID change is
> > also the first run).
> > 
> > This small series aims at simplifying all that, and to get rid of the
> > vcpu->arch.has_run_once state.
> > 
> > Marc Zyngier (5):
> >   KVM: arm64: Move SVE state mapping at HYP to finalize-time
> >   KVM: arm64: Move kvm_arch_vcpu_run_pid_change() out of line
> >   KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and
> >     kvm_vcpu_first_run_init()
> >   KVM: arm64: Restructure the point where has_run_once is advertised
> 
> Maybe do the restructuring before the merging in order to avoid the
> potential for bizarre states?

Also, before we do the merge I think we need to duplicate the

        if (unlikely(!kvm_vcpu_initialized(vcpu)))
                return -ENOEXEC;

that we currently have above the call of kvm_vcpu_first_run_init()
into kvm_arch_vcpu_run_pid_change() because
kvm_arch_vcpu_run_pid_change() is called before kvm_arch_vcpu_ioctl_run()
in KVM_RUN.

Thanks,
drew

> 
> >   KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid
> > 
> >  arch/arm64/include/asm/kvm_host.h | 12 +++------
> >  arch/arm64/kvm/arm.c              | 43 ++++++++++++++++++-------------
> >  arch/arm64/kvm/fpsimd.c           | 11 --------
> >  arch/arm64/kvm/reset.c            | 11 +++++++-
> >  arch/arm64/kvm/vgic/vgic-init.c   |  2 +-
> >  5 files changed, 39 insertions(+), 40 deletions(-)
> > 
> > -- 
> > 2.30.2
> > 
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
> 
> For the series
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> Thanks,
> drew

