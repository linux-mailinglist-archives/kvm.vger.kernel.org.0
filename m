Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFA42850E2
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 19:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgJFRff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 13:35:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgJFRff (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 13:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602005734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ybm7bx/2hLVzC/qs9Aik0Q9f8yt1VNXDeAzYuJE6DP8=;
        b=XzPpaONjqlOaqH6JDACAX4Ry0PyZQxX+2upffwZdD70NO5ZWXe2USccw/Xln85u3unV9hs
        hx24NF8rDcIeyqmctLkT+H3UFGP63dNuNShml8K4yHml7l+w57RWRb26hN4acgtI4wBJ1T
        +QREPADFAgTXKPNGLgK47HQtE5MlXvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-BLJsxStUNgeO1dIWijuUYw-1; Tue, 06 Oct 2020 13:35:32 -0400
X-MC-Unique: BLJsxStUNgeO1dIWijuUYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 455E01054F8A;
        Tue,  6 Oct 2020 17:35:31 +0000 (UTC)
Received: from horse.redhat.com (ovpn-117-72.rdu2.redhat.com [10.10.117.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E242355782;
        Tue,  6 Oct 2020 17:35:27 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 7616E220AD7; Tue,  6 Oct 2020 13:35:27 -0400 (EDT)
Date:   Tue, 6 Oct 2020 13:35:27 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201006173527.GG5306@redhat.com>
References: <20201005161620.GC11938@linux.intel.com>
 <20201006134629.GB5306@redhat.com>
 <877ds38n6r.fsf@vitty.brq.redhat.com>
 <20201006141501.GC5306@redhat.com>
 <874kn78l2z.fsf@vitty.brq.redhat.com>
 <20201006150817.GD5306@redhat.com>
 <871rib8ji1.fsf@vitty.brq.redhat.com>
 <20201006161200.GB17610@linux.intel.com>
 <87y2kj71gj.fsf@vitty.brq.redhat.com>
 <20201006171704.GC17610@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006171704.GC17610@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 10:17:04AM -0700, Sean Christopherson wrote:

[..]
> > > Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> > > into the guest is not an option.  
> > 
> > Not even #MC? So sad :-)
> 
> Heh, #MC isn't allowed either, yet...

If #MC is not allowd, logic related to hwpoison memory will not work
as that seems to inject #MC.

Vivek

