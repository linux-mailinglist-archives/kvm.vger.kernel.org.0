Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C7544D86A
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 15:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhKKOjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 09:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhKKOjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 09:39:43 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B28C0613F5
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 06:36:53 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y7so6043213plp.0
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 06:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=34jJgzawqYQ+YIWRQzr5npm3PT61iRNMpUEdh2zYEW0=;
        b=Q9Iei7K8qZ4eZBpVsI63utgUETJb06coQ9roecARAgmfSCbcIfROT8BZMXf13XB9lK
         OmX6R8+E/iYmVz5UZO4sBFI115DQwFqvqUtghrHCwzO4AkJtKOO9ADvq3IQ2F6B+yhZ2
         ptNamZPTRYWzyZRr6g6zFSATIkdVRfBEt/jkKLXT8lLSa5c8nrqS0C06f3XNiP+ln33t
         3ZXIxC/bm0JuGNqS1StgBx1CQhyhOo6T6kAPGxJb213oZpXsEvw9jtEKGJ7NXdTSGHwx
         JLtZ/ecQ+YKRcdWxcl6LzDy3MS/Y4ufvEeVGuOm/zzCRyUmZ1ukoT7Rac8MFcpF5aXMy
         FzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=34jJgzawqYQ+YIWRQzr5npm3PT61iRNMpUEdh2zYEW0=;
        b=0PzNjUqFMl0gP138w4DI7r7aV9dVMJXIHhAYC0Bj1bEGfkT/mBngeQukZ/HS6J7IKO
         lBvJNUPRYECSfK4dcl8UZ9f39rnvOmiEW8PVBkLVFvNp7/CccSpt0OfnyucV4fSP2Cpu
         na2w79PUxcPT57TfHYr4VIfOy7bZ3iqWHX/dau/SBEnjz4rH9r3JPooIrEsKoqGl2noP
         njLAiL0/uG2Y2lOrLAEOQs3NbkMGMSF/hI8rnGUmVsw1RVHozfgmQJlXPg/pQxvChWpM
         s0EGXHgzsJgdh0DvwL4QjDeBzu3v5ogp2wgThEp/NtsT/vOnP5h5J4iKMAfy9aHduBEC
         jUjw==
X-Gm-Message-State: AOAM533UfweiSEUbHO8MJ2lwdRCbU//S/EnGi//lHCQKlflJJXjrGGzt
        e3SEwaoX04N+XuWnNVtGP+xT3Q==
X-Google-Smtp-Source: ABdhPJzlwtX57K6+V5Tv7VOOUCk5L8popOisLaIWyi20afrwM79POuBw74n+k4YSIZAIqjE9+E0+pg==
X-Received: by 2002:a17:90a:9a8e:: with SMTP id e14mr8753922pjp.231.1636641413245;
        Thu, 11 Nov 2021 06:36:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v10sm3495127pfg.162.2021.11.11.06.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 06:36:52 -0800 (PST)
Date:   Thu, 11 Nov 2021 14:36:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
Message-ID: <YY0qgUqM3CuDHWgB@google.com>
References: <20211111134733.86601-1-vkuznets@redhat.com>
 <5cdb6982-d4ec-118e-2534-9498196d11b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cdb6982-d4ec-118e-2534-9498196d11b8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021, Paolo Bonzini wrote:
> On 11/11/21 14:47, Vitaly Kuznetsov wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ac83d873d65b..91ef1b872b90 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4137,7 +4137,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >   		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
> >   		break;
> >   	case KVM_CAP_NR_VCPUS:
> > -		r = KVM_SOFT_MAX_VCPUS;
> > +		r = num_online_cpus();

I doubt it matters much in practice, but this really should be

		r = min(num_online_cpus(), KVM_MAX_VCPUS);

> >   		break;
> >   	case KVM_CAP_MAX_VCPUS:
> >   		r = KVM_MAX_VCPUS;
> > 
> 
