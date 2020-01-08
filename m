Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54BCE134B58
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 20:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgAHTPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 14:15:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44883 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726363AbgAHTPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 14:15:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578510915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3z9gNLCSXB8aO3xtxIUun5FqOxfpI/aizS1bLtGDjNA=;
        b=PAZlRLhLKEnyZzXjJsvffIp+BSjxSRGAbO7BMYRU/a2kmgfuoj+Med6AcZwciPQCv0d9v6
        aSrR3BUGNuce9nvYM5ln5JFGcNLqxVJGWMsPySKraGyEhjWHt+7PpvmQBZU8UjUPTpjssL
        IYBxKmw1aTixrX+InzjkMSn+bK26Xek=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-sWiGlX9POeK6WMa03KJrvA-1; Wed, 08 Jan 2020 14:15:14 -0500
X-MC-Unique: sWiGlX9POeK6WMa03KJrvA-1
Received: by mail-qv1-f72.google.com with SMTP id d7so2560342qvq.12
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:15:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3z9gNLCSXB8aO3xtxIUun5FqOxfpI/aizS1bLtGDjNA=;
        b=QDF12sgcCGk48AE+0ElW9V4wDBLPlTSJh7aFI286snBC3+74jBR5+1X0UwcEAwfQMk
         zqFrhjLQpotaW7g1BP47tns3pHZmRHiBDoQI9gTyGoIuDfaoHO9JyFVCGKlDqZ1gYvJ4
         LHW7bHLHRcb+IyJvaUg7d8KVY9gVCZA8hF1s+afnyQAoH2kfPYQ3SveQXFrFd9ueBEpO
         Eiv57X9eBf7VjntVkNE66bnszq8tBgKGfBlxJdZz1EUjPREgCxFoQVxMBFcKzIg1251P
         7lnUOPzaH58GECKnWomx01i22OO9+UDjrTojHLTWvYlGEqY/8ESD/bIFGtnEBQQ6GnXN
         4wFg==
X-Gm-Message-State: APjAAAVP7K4wnOQOAbQAKICw/oimIWoSWtTdxc8qdZBvCeQ/5ynlcA7n
        PRuir09fs2Xn37ZXDkNGPQOyJLLeoYYnHm2+dEReJaDi7wdqG3vZhO4eXfJHHyW8jX0wBiCpl5S
        mowjY6fpdcaUD
X-Received: by 2002:ad4:5421:: with SMTP id g1mr5431495qvt.57.1578510914190;
        Wed, 08 Jan 2020 11:15:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqzaG+N6wIv/vcQ8oG8Xb91kma1URsYhdGn0JWu2TkG83LPrJ3CDlvwx1GR3NbfXuD16HiWg5g==
X-Received: by 2002:ad4:5421:: with SMTP id g1mr5431470qvt.57.1578510913932;
        Wed, 08 Jan 2020 11:15:13 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id l44sm1020260qtb.48.2020.01.08.11.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 11:15:13 -0800 (PST)
Date:   Wed, 8 Jan 2020 14:15:12 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RESEND v2 03/17] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200108191512.GF7096@xz-x1>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-4-peterx@redhat.com>
 <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
 <20191223172737.GA81196@xz-x1>
 <851bd9ed-3ff3-6aef-725c-b586d819211c@redhat.com>
 <20191223201024.GB90172@xz-x1>
 <e56d4157-1a0a-3f45-0e02-ac7c10fccf96@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e56d4157-1a0a-3f45-0e02-ac7c10fccf96@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 08, 2020 at 06:46:30PM +0100, Paolo Bonzini wrote:
> On 23/12/19 21:10, Peter Xu wrote:
> >> Yes, kvm->slots_lock is taken by x86_set_memory_region.  We need to move
> >> that to the callers, of which several are already taking the lock (all
> >> except vmx_set_tss_addr and kvm_arch_destroy_vm).
> > OK, will do.  I'll directly replace the x86_set_memory_region() calls
> > in kvm_arch_destroy_vm() to be __x86_set_memory_region() since IIUC
> > the slots_lock is helpless when destroying the vm... then drop the
> > x86_set_memory_region() helper in the next version.  Thanks,
> 
> Be careful because it may cause issues with lockdep.  Better just take
> the lock.

But you seemed to have fixed that already? :)

3898da947bba ("KVM: avoid using rcu_dereference_protected", 2017-08-02)

And this path is after kvm_destroy_vm() so kvm->users_count should be 0.
Or I feel like we need to have more places to take the lock..

-- 
Peter Xu

