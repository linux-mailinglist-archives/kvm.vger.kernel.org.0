Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2001D5521
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 17:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgEOPvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 11:51:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726188AbgEOPvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 11:51:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589557896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pi0amNDgyXo1Ofz3SsZJ+aPmt+MZQ7l5w4BtP+olYNs=;
        b=Jss+Ewzx1qusHs+NAbJqhzQafgQ6m41wRwJf6xAA+NIjXhlpyAJ1l9oHbODoyPup0QbN+B
        ikIdXhZ2kSH80jgMffcvY/QexLSfV2UtyS7z7xldmgBiAcNeKJ5cEsKLl1AxC/qcP98HC9
        VEB+QrAdgmBVx2qRtyhZ9YgKXs/2jk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-lxwwfqDINsC6A0xLU84p6g-1; Fri, 15 May 2020 11:51:34 -0400
X-MC-Unique: lxwwfqDINsC6A0xLU84p6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71A1B474;
        Fri, 15 May 2020 15:51:33 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E37B66062;
        Fri, 15 May 2020 15:51:26 +0000 (UTC)
Date:   Fri, 15 May 2020 16:51:24 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v1 06/17] target/i386: sev: Use
 ram_block_discard_set_broken()
Message-ID: <20200515155124.GH2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-7-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506094948.76388-7-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> AMD SEV will pin all guest memory, mark discarding of RAM broken. At the
> time this is called, we cannot have anyone active that relies on discards
> to work properly.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  target/i386/sev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 846018a12d..608225f9ba 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -722,6 +722,7 @@ sev_guest_init(const char *id)
>      ram_block_notifier_add(&sev_ram_notifier);
>      qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
>      qemu_add_vm_change_state_handler(sev_vm_state_change, s);
> +    g_assert(!ram_block_discard_set_broken(true));
>  
>      return s;
>  err:
> -- 
> 2.25.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

