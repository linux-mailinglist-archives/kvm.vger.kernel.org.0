Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30A8128223
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 19:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfLTSTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 13:19:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24355 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727422AbfLTSTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 13:19:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576865958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wRPsI5uu/RlvtNtQkmdecNgQ+higXOu9C0HzOxCB15M=;
        b=QDTlNi0Zbv8Hh7JDrN1op9IZw4fQDsVhsgwWu8y1bLOLYSsryb4nWw+3z2frZ3bOBjGDLK
        tA18XXVwmu68WfFfuEZ6x/3y3ua/tH42DOJbWGe+yxgdMnhOvKq5nGNzPwWCrM3+jypC8i
        +xPQI/AXJ+/0nAxdilR6tvLvD0xDT9U=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-VTeYLZwjPgy5pNwqzUs5Eg-1; Fri, 20 Dec 2019 13:19:17 -0500
X-MC-Unique: VTeYLZwjPgy5pNwqzUs5Eg-1
Received: by mail-qt1-f197.google.com with SMTP id r9so6493772qtc.4
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 10:19:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wRPsI5uu/RlvtNtQkmdecNgQ+higXOu9C0HzOxCB15M=;
        b=YhTKGdoBEzS48YT75yOFklrQAjOXu3kVAK2AkUWauFgxqmzaJrLaNjJRMSnTyN0gJN
         NylD/WfUGyNWknR7wtfeVNoYgFmKWMiCW4Lu5Zq3XlB3+0X7r+20DpLTtRtfYJSYaGrG
         fMhq6iaAZO9SUXxg38mb7tzg/g8/rgyN/BMPzfgr4KXIFi0upgDDW437Uy1YwVNdq0Eb
         drhlL1Z7IqKq6YUUIJYLWzHR/v+U8m0Pnt/xCOqbUpJEEfxqJFsQR8EGHWTFU93KF/ae
         OxT0GJUwiDykEb3DxCPJ2TC1QmgTrSWPrZ4+Hve5m9z7sRgb3ErMX6vrt24Szfcpy1Gb
         KX5A==
X-Gm-Message-State: APjAAAWiZ4Drrr+VOafaS7Z/oanC95V5b/fBU8m+WrhFfLE5qhS7ch6J
        m+zTqJGd8U7KfqKfTCKlzTo7f/SjwN985hGb0jKYNrL+p3a3KtlofXOxOyJbeplhv/QpHgrVWu0
        vM313nO050LJv
X-Received: by 2002:aed:3c16:: with SMTP id t22mr12486449qte.92.1576865956867;
        Fri, 20 Dec 2019 10:19:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhZQS6vB9mGEB6JcCGztbXsAUJN86mcE/m9Xumhu7+42YFiz9lJtvxy372U/8V1JAbBGeXBA==
X-Received: by 2002:aed:3c16:: with SMTP id t22mr12486417qte.92.1576865956609;
        Fri, 20 Dec 2019 10:19:16 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id l49sm3326579qtk.7.2019.12.20.10.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:19:15 -0800 (PST)
Date:   Fri, 20 Dec 2019 13:19:14 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191220181914.GB3780@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191213202324.GI16429@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 03:23:24PM -0500, Peter Xu wrote:
> > > +If one of the ring buffers is full, the guest will exit to userspace
> > > +with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the
> > > +KVM_RUN ioctl will return -EINTR. Once that happens, userspace
> > > +should pause all the vcpus, then harvest all the dirty pages and
> > > +rearm the dirty traps. It can unpause the guest after that.
> > 
> > Except for the condition above, why is it necessary to pause other VCPUs
> > than the one being harvested?
> 
> This is a good question.  Paolo could correct me if I'm wrong.
> 
> Firstly I think this should rarely happen if the userspace is
> collecting the dirty bits from time to time.  If it happens, we'll
> need to call KVM_RESET_DIRTY_RINGS to reset all the rings.  Then the
> question actually becomes to: Whether we'd like to have per-vcpu
> KVM_RESET_DIRTY_RINGS?

Hmm when I'm rethinking this, I could have errornously deduced
something from Christophe's question.  Christophe was asking about why
kicking other vcpus, while it does not mean that the RESET will need
to do per-vcpu.

So now I tend to agree here with Christophe that I can't find a reason
why we need to kick all vcpus out.  Even if we need to do tlb flushing
for all vcpus when RESET, we can simply collect all the rings before
sending the RESET, then it's not really a reason to explicitly kick
them from userspace.  So I plan to remove this sentence in the next
version (which is only a document update).

-- 
Peter Xu

