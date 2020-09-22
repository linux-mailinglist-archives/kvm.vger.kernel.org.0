Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FE627494E
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 21:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgIVTjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 15:39:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbgIVTjP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 15:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600803554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gm4WKlExxdbBw9OINaibFzjDTAjcV9DROeX1pw3/lvo=;
        b=KcKeV2xRo0eZcOpOP+7SV48xUDIA7Tn1N4D4f1hbhPaxiNPxcbu7Jh7TDP6kmwsyu8t7/v
        Kycr4EHnkpQTMO6kgkE5f16nhfhw8BDWT7AoY9m56wUtenb71B6FAg3TwVWuO8gYJZ2wsr
        Gyfkzeo53McSqLbEppjEk8qz9l4HFdM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-e9a6LsHLPEWntkxAzhZVIQ-1; Tue, 22 Sep 2020 15:39:09 -0400
X-MC-Unique: e9a6LsHLPEWntkxAzhZVIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0D6F186DD28;
        Tue, 22 Sep 2020 19:39:08 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43E73614F5;
        Tue, 22 Sep 2020 19:39:04 +0000 (UTC)
Date:   Tue, 22 Sep 2020 15:39:03 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, qemu-devel@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        1896263@bugs.launchpad.net, kvm@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH] i386: Don't try to set MSR_KVM_ASYNC_PF_EN if
 kernel-irqchip=off
Message-ID: <20200922193903.GA2044576@habkost.net>
References: <20200922151455.1763896-1-ehabkost@redhat.com>
 <87v9g5es9n.fsf@vitty.brq.redhat.com>
 <20200922161055.GY57321@habkost.net>
 <87pn6depau.fsf@vitty.brq.redhat.com>
 <20200922172229.GB57321@habkost.net>
 <b22127f4-9a68-99b8-bf55-b6ede236dee0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b22127f4-9a68-99b8-bf55-b6ede236dee0@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 07:26:42PM +0200, Paolo Bonzini wrote:
> On 22/09/20 19:22, Eduardo Habkost wrote:
> > If it was possible, did KVM break live migration of
> > kernel-irqchip=off guests that enabled APF?  This would mean my
> > patch is replacing a crash with a silent migration bug.  Not nice
> > either way.
> 
> Let's drop kernel-irqchip=off completely so migration is not broken. :)
> 
> I'm actually serious, I don't think we need a deprecation period even.

I wasn't sure about this, but then I've noticed the man page says
"disabling the in-kernel irqchip completely is not recommended
except for debugging purposes."

Does this note apply to all architectures?

-- 
Eduardo

