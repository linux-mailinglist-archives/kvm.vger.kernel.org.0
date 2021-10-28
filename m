Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5BD43DC44
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 09:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhJ1Hot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 03:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhJ1Hos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 03:44:48 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78031C061570;
        Thu, 28 Oct 2021 00:42:21 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id t127so12925740ybf.13;
        Thu, 28 Oct 2021 00:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jg8omDm1zuEDYPy2wE96j8MIp8X+Ixp0yvqeM2ZpT0g=;
        b=KA1YcV+oqiq8WH3aVGXJM18kP7H/wclsYSoUmbKqww/bQPKzs9CJtDAqYY8PekzznP
         aO3Ryl3VH9yQWVnq9OmuBOlynAhLo4NFRVS6EkioResNdxBJI/ITkqQDkCuE0aenNqYX
         SpyalUqhdLFPWFpjuDpH+L9UYYF2MnnEZziK72BnGVkfRBHywxt7YKztfPbi6y8IKiRN
         1vwU/CRM+BfRGZrUAUY3Ap60xJKQOui9Oh0B195Pp6OFoK4EAorIqJBGhbNwvo6BtB5u
         pYdJ8ENi52vSCnhp02vWuUy8Ppyr6e9nzg76PMvkXErbgGBs7eJO7+bm8w6gEBYRkwxB
         0oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jg8omDm1zuEDYPy2wE96j8MIp8X+Ixp0yvqeM2ZpT0g=;
        b=vfwh7TUByeruekWfivDPetMruh00jOw2FsMyE7vtL6O6KQ29CgqOaZLpG5vGapt/8f
         3hAIAhuUuIiG+DQ0bYA/ppeejcA0vv4SPuemXwr9/9AUQtu2UJDdskFSRK2SOa9mAGIH
         8/fvCITaTic082go+ky3oXOSP8EeBejqMa0pQUJDChnhcP+S0rtKpIkV/9dm5Q+4jWx1
         tv9TzsPSVZOuNmlb+1BlxPFQIuTgnmUq1zzv7SXlr0QrADFbSCf6zxOqtjznet6/i31M
         Z4T8koT8YBLmPbWv29AWs2d0xYoZtOBPeGvMuAqHIuCtOu4c/d3F3WwEzGjFpO5PAyFW
         XOCQ==
X-Gm-Message-State: AOAM531vEdG4pf7IMaRaw2VGiBkLkaLXvOywzAv3NBKZJ7wNzGM10GP8
        PTCBd+wmY1aY+ZLPXtmP+NLPA/Li+a8fXtMAgwcb3jN0d9xY3BmW
X-Google-Smtp-Source: ABdhPJx8TRc2pBelVwfWJtgvJIqkXLIPcG50fiUihdVHkF0f9haejbKjz7kVZOG51P9njEiIiOUr8G2SKv48mxzEPgE=
X-Received: by 2002:a5b:a92:: with SMTP id h18mr2872386ybq.439.1635406940758;
 Thu, 28 Oct 2021 00:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
 <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
In-Reply-To: <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Thu, 28 Oct 2021 15:42:10 +0800
Message-ID: <CAFcO6XO7YMxHN+TwZvr3fxFypTt_nE3xLdvuBKPF_j0-ApsiFg@mail.gmail.com>
Subject: Re: There is a null-ptr-deref bug in kvm_dirty_ring_get in virt/kvm/dirty_ring.c
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I agree with you. But I don=E2=80=99t have a good idea how to fix it


Regards,

  butt3rflyh4ck.

On Fri, Oct 22, 2021 at 4:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 18/10/21 19:14, butt3rflyh4ck wrote:
> > {
> > struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();  //-------> invoke
> > kvm_get_running_vcpu() to get a vcpu.
> >
> > WARN_ON_ONCE(vcpu->kvm !=3D kvm); [1]
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


--=20
Active Defense Lab of Venustech
