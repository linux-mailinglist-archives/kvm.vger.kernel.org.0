Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9E445362E
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbhKPPps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238500AbhKPPo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 10:44:56 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E18BC061207;
        Tue, 16 Nov 2021 07:41:59 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id e136so58644193ybc.4;
        Tue, 16 Nov 2021 07:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JeB67wKKYkmYpABTeJ3dUTEOLmNuPtc5YikBcZnWqdY=;
        b=ne++BIx1ByaGEvgTfsJ30VTSG+XVIrvdceUggDGwQphTLUvDL3VSTQ3fwG4JZatnkm
         PD3cHUZSUdxryzmfSQukjiI7HLe3EjwiThbdTzoAhUIDJWJ88pYpOXXMwM3J87JIUZsT
         9t6fo0nNfFHE7+7kw+lWJbkCrNc1BqAZrNxFs5tNNLbbDy8IPaH921n6Fcl3hkYMZ280
         vSr2CPs7tSYVHuLdqFNu8N6gn15k4pdOHhH/VRuHmKwnQ4aJN7WNnnWQ8/opxCT3bFbg
         ernX1vuyj3wpJquqid/B/xio84FubTKdupMEW7JigqEbTRQNwZTO3/mewg+pdWuN3azz
         1LaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JeB67wKKYkmYpABTeJ3dUTEOLmNuPtc5YikBcZnWqdY=;
        b=uLRCuIpOA09edkGr0dA1UVz/bI/a7H+ZtyJwYU5avr3Vw52/FXM/nfI/jXAIo3VGao
         rhy/+fkiv1wcbn9jNdcWXc3goEN5cW2Kr5BJfjMgzXZTic9ZieLaZXkG4QRIf7EdmGdT
         NCt3Yau3OY98sL7VqFczDAk46aGovBFgl4qmSZtsJmk95eMeIeAmNkGdR4Nzvc2FfHb/
         wLGOjadB7nEkqVhaGdDuvsUJ8V3FnyztnEhzpTzgv+1TlfhfE8NmqpxxwETacIJ6cLKX
         7wrJGuriL9EAFkz66yMRkurZnTilWsFt0F91lOs2DA/0qbn6T4yCCGQB+SFGdbRMdurH
         WaOw==
X-Gm-Message-State: AOAM5316VIpSNMzC9zHrg5l2Uvpl/Yvlby1RrVqZaICyLf9Mq/596KTC
        SAAGlGMHnntHVnol02NvuH8PCt2RLdvPcEwJ1hs=
X-Google-Smtp-Source: ABdhPJzacMZbfRM0BT4keVhfVbuX+teU+iXirl6LpwV6iont1LhweuIu4SyVn/0rIg16Z4BJ0p6ClJZhT15WwRLAaIg=
X-Received: by 2002:a25:cb12:: with SMTP id b18mr9533751ybg.139.1637077318358;
 Tue, 16 Nov 2021 07:41:58 -0800 (PST)
MIME-Version: 1.0
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
 <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
In-Reply-To: <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Tue, 16 Nov 2021 23:41:48 +0800
Message-ID: <CAFcO6XMyBDU8hYNAa7s9sGHEntTz5iJmLF2QbRN-S8PPpYd_ZQ@mail.gmail.com>
Subject: Re: There is a null-ptr-deref bug in kvm_dirty_ring_get in virt/kvm/dirty_ring.c
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 For this issue, I have reviewed the implementation code of vm
creating,vCPU creating and dirty_ring creating,
 I have some ideas.If only judge kvm->dirty_ring_size, determine
whether to call kvm_dirty_ring_push(), this condition  is not
sufficient.
can we add a judgement on kvm->created_vcpus. kvm->created_vcpus is not NULL.
After all, there is a situation, no vCPU was created, but
kvm->dirty_ring_size has a value.

Regards,
 butt3rflyh4ck.

On Fri, Oct 22, 2021 at 4:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 18/10/21 19:14, butt3rflyh4ck wrote:
> > {
> > struct kvm_vcpu *vcpu = kvm_get_running_vcpu();  //-------> invoke
> > kvm_get_running_vcpu() to get a vcpu.
> >
> > WARN_ON_ONCE(vcpu->kvm != kvm); [1]
> >
> > return &vcpu->dirty_ring;
> > }
> > ```
> > but we had not called KVM_CREATE_VCPU ioctl to create a kvm_vcpu so
> > vcpu is NULL.
>
> It's not just because there was no call to KVM_CREATE_VCPU; in general
> kvm->dirty_ring_size only works if all writes are associated to a
> specific vCPU, which is not the case for the one of
> kvm_xen_shared_info_init.
>
> David, what do you think?  Making dirty-page ring buffer incompatible
> with Xen is ugly and I'd rather avoid it; taking the mutex for vcpu 0 is
> not an option because, as the reporter said, you might not have even
> created a vCPU yet when you call KVM_XEN_HVM_SET_ATTR.  The remaining
> option would be just "do not mark the page as dirty if the ring buffer
> is active".  This is feasible because userspace itself has passed the
> shared info gfn; but again, it's ugly...
>
> Paolo
>


-- 
Active Defense Lab of Venustech
