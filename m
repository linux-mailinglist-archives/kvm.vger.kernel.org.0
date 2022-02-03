Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14CA4A7D41
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348768AbiBCBIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiBCBIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:08:49 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3ECC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:08:48 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id q8so1655746oiw.7
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fgZO7dn3J2u5T4Z4Lyj+x75wE1AnRUDS910RNLAN26s=;
        b=J+H3Oz0tROR+2vZXFcHKO1afcXyI8HGOtlvXSXIw/mkHtjG8zjMlXDz0g9hxFlAUWG
         3yW04Ljjw56UvsANMWwucyMfSw1Jj14cSn7GJtGLSjUott1dPEZ2SOyQtnq6UYo3vO7M
         tCUtZoMxDxaHrrdRSzpifrMZycnQBbw9yf9bw7+bP2AvYXSLoc0r7R0Ki/+K2rhjFQoT
         32uFf5VoYmrpNWFjnAsM9xbAnRk5sm7WTM0NvZ5Eool5EuYPO/2NSY1ndDaG/DjM+u2o
         t+UjeHEJqb80Lo73vEj5A2P0g1LqXnjZJz7zSvC5Yuw9Z50+FriywtiKnbtzBdaqOGCJ
         UmNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fgZO7dn3J2u5T4Z4Lyj+x75wE1AnRUDS910RNLAN26s=;
        b=5Xx8Vd/+/UZFyI6Uqimf1dxsVP0hYnsWITkKTZ7IKrvL58DgSfKiL/e4mNY6Pl+8Xo
         Uv/sKWmtNH8tgQlyaUbWGTMBLcd2XyhvK72FVFal4+asFIbie/pMXVn7faDVOVOlXZdi
         xYYZoCEWONyo4WsVB7IcLYT9xL876pz+rlbxhLn3g5HWV2/lWKu2bLsva2BMpdps+WMv
         dDYV+OrIJqKOo2x+gKj8FOwmf9sYZnbJ1UTL+j56Cfj5ySZ2GcArjKp6GkrvMun5XPlZ
         HuAYi8SZJKqY0LnVfsraVCN9vTMmyaGgrlIBBsQFL5SQCKITRqPfrDJZOOIr50d/F8SZ
         YEoA==
X-Gm-Message-State: AOAM531rEqgwGv3qGm6ogOgS96sU24LYxdyClGO6PpRCeubfRVq9D+x+
        TcEGxP7FYvhKqurDl28CgovIoG5JQDHY6G9i8VTXaw==
X-Google-Smtp-Source: ABdhPJwHu3OUVlJaYrsox4VFjxz6qJkblu+rXPwgvQqBcVzV2+Tn++JN69Hjr+/buZFJYa3KNPZzhNzG4SMghIm4/wQ=
X-Received: by 2002:a05:6808:1292:: with SMTP id a18mr6333185oiw.314.1643850527926;
 Wed, 02 Feb 2022 17:08:47 -0800 (PST)
MIME-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com> <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
 <Yfsi2dSZ6Ga3SnIh@google.com> <CAOQ_Qsiv=QqKGr4H2dP30DEozzvmSpa1SLjX8T5vhSfv=gTy3g@mail.gmail.com>
 <YfsoBECWPpP0BpOW@google.com>
In-Reply-To: <YfsoBECWPpP0BpOW@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Feb 2022 17:08:36 -0800
Message-ID: <CALMp9eQyRHf=_COs0AZ4=66b97ttLfmEYokQPwo=ruH3etbthA@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 4:55 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Feb 02, 2022, Oliver Upton wrote:
> > On Wed, Feb 2, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
> > > MSR_IA32_FEAT_CTL has this same issue.  But that mess also highlights an issue
> > > with this series: if userspace relies on KVM to do the updates, it will break the
> > > existing ABI, e.g. I'm pretty sure older versions of QEMU rely on KVM to adjust
> > > the MSRs.
> >
> > I realize I failed to add a note about exactly this in the cover
> > letter. It seems, based on the commit 5f76f6f5ff96 ("KVM: nVMX: Do not
> > expose MPX VMX controls when guest MPX disabled") we opted to handle
> > the VMX capability MSR in-kernel rather than expecting userspace to
> > pick a sane value that matches the set CPUID. So what really has
> > become ABI here? It seems as though one could broadly state that KVM
> > owns VMX VM-{Entry,Exit} control MSRs without opt-in, or narrowly
> > assert that only the bits in this series are in fact ABI.
>
> I don't know Paolo's position, but personally I feel quite strongly that KVM should
> not manipulate the guest vCPU model.  KVM should reject changes that put the kernel
> at risk, but otherwise userspace should have full control.

I agree wholeheartedly. Userspace should not have to do KVM_GET_CPUID2
after KVM_SET_CPUID2 to find out what the guest's actual CPUID table
looks like. However, today, it does.

Similarly, for read-only MSRs, userspace should be able to assume that
KVM_GET_MSRS will always return the same value that was passed to
KVM_SET_MSRS. However, that is not the case today, either.
