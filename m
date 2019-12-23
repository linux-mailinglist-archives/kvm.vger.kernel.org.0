Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409D9129955
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 18:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLWR1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 12:27:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48769 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726766AbfLWR1m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Dec 2019 12:27:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577122061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2FQpGKHqmKgP8roRbgRwKHYu0GCskB3t0E3YVUxgG0w=;
        b=ZlDgbEMsk/Z8Zas4xcpQE7OkH2+XW4TGyCqJ5E8cmFqgPqsUvA6a2zLnCVBVqKngelaSvo
        MTvIHSxy7eGgTGWkGNgQZ+wv22SZbSj+V2FhZHuoTR7bXLA9O3SNWE6bTTLXpuNZy943QX
        n/9DQZm7kwJQ4v4DLaHK0u8i5bIDUDI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-a-FTD6LVMBuRxaDF2DU2Gw-1; Mon, 23 Dec 2019 12:27:40 -0500
X-MC-Unique: a-FTD6LVMBuRxaDF2DU2Gw-1
Received: by mail-qk1-f197.google.com with SMTP id s9so11499362qkg.21
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2019 09:27:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2FQpGKHqmKgP8roRbgRwKHYu0GCskB3t0E3YVUxgG0w=;
        b=SN6LO7TgtxLx1xqjeyLzXduV5BHm4oB5UvyG30v6IZX8SdlGaG0szciVz4gHdRPSGK
         06GUMPJpXn5RcWV/IlgXqfYy8CIeccVsx+XRlngKQi1HzciyaUEp4J6YTcoUETgJfAOZ
         QM8SMyoWeTodU2sfFuiTKzGoHZ2CqXwWk+oQ4A98PEbomdrRQ7Hwkd3QLowFjBpry+Ah
         HldxeMeRWs6hk6b4/+KxYV3pxt4HBAQky+zk6fw3FvUfV27xD4ijV3gMh7kqoFFAtL0D
         nXzzUPg00JlkKqGN5RJqU4TtaBiiEong2AEb3q3W4yrngKKLW9oeKUYGZX6W/dx2RHO8
         p1dw==
X-Gm-Message-State: APjAAAXj7in4Z1ispB1MilJNdVeUkSlu6rVa0oXNo79GBjqRlq/YOAU+
        yXyiRDf/3/K7t4IbETbI3FNK8HOyKULqVYkQX7F831hdjSlHnHEMR2rFS6wZPwG5laXRdS8Ogj3
        LWaZFKRtjK1AH
X-Received: by 2002:a37:a70c:: with SMTP id q12mr15555622qke.484.1577122059614;
        Mon, 23 Dec 2019 09:27:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYzt7+Hss5QmOIfwnIr/JMapF2vhOFE7agaZrdLdvNu9aXaC3w6bEL5ww3BUrHUWO1SQNPIw==
X-Received: by 2002:a37:a70c:: with SMTP id q12mr15555594qke.484.1577122059322;
        Mon, 23 Dec 2019 09:27:39 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id l4sm422045qkb.37.2019.12.23.09.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 09:27:38 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:27:37 -0500
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
Message-ID: <20191223172737.GA81196@xz-x1>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-4-peterx@redhat.com>
 <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 21, 2019 at 02:51:52PM +0100, Paolo Bonzini wrote:
> On 21/12/19 02:49, Peter Xu wrote:
> > Originally, we have three code paths that can dirty a page without
> > vcpu context for X86:
> > 
> >   - init_rmode_identity_map
> >   - init_rmode_tss
> >   - kvmgt_rw_gpa
> > 
> > init_rmode_identity_map and init_rmode_tss will be setup on
> > destination VM no matter what (and the guest cannot even see them), so
> > it does not make sense to track them at all.
> > 
> > To do this, a new parameter is added to kvm_[write|clear]_guest_page()
> > to show whether we would like to track dirty bits for the operations.
> > With that, pass in "false" to this new parameter for any guest memory
> > write of the ioctls (KVM_SET_TSS_ADDR, KVM_SET_IDENTITY_MAP_ADDR).
> 
> We can also return the hva from x86_set_memory_region and
> __x86_set_memory_region.

Yes.  Though it is a bit tricky in that then we'll also need to make
sure to take slots_lock or srcu to protect that hva (say, we must drop
that hva reference before we release the locks, otherwise the hva
could gone under us, iiuc).  So if we want to do that we'd better
comment on that hva value very explicitly, just in case some future
callers of __x86_set_memory_region could cache it somewhere.

(Side topic: I feel like the srcu_read_lock() pair in
 init_rmode_identity_map() is redundant..)

-- 
Peter Xu

