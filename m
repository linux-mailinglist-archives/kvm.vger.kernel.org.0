Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DACF184801
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 14:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgCMNZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 09:25:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36470 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726426AbgCMNZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 09:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584105956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zsg2hmxrQyD4xVASw0wlu0Vs2nauojeVgAGZZ0zLUOQ=;
        b=AHON1tREv5GLNBHaY2+cXp9CLr1ohknZ7I2Q/RSgDpIdGx95Y3uxtfHfrj6ivljd+Ic+Di
        Ap4GLsZbw4ufNyHT+3oiZ121A08sb2vSvFbRe+LBPv6HP9lBTVKJcPoIBnNOtdVuvKWrvT
        wZrLFtJ3Nuj/dDKFO3kpXO0MVAeWExo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-1ov7AGDSOJa3gefRXTNS-A-1; Fri, 13 Mar 2020 09:25:54 -0400
X-MC-Unique: 1ov7AGDSOJa3gefRXTNS-A-1
Received: by mail-wm1-f70.google.com with SMTP id f207so3428658wme.6
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 06:25:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Zsg2hmxrQyD4xVASw0wlu0Vs2nauojeVgAGZZ0zLUOQ=;
        b=RJ4cxloLfCHtcrXBMZwJQGZUHNJJUfredw0ZaJMZLRjYQvMlfhUDog9rlZ5rQpGqKD
         ktcgfqvhCcOpvQPehR8x6GbvzOtgtYzZrD1a4igTtHbw0REOSfbi0OVsUs5iQ/fwNsPe
         WTiQwMRnyWX0TqOHbw7veszcHCTKH2/CNMnPZw2R2lvI3jEfjbqQcVVksvDrQTStmdXK
         F4eDJ3wOh+RirzLwQAvwYmFWO3Weja/ZZSp0LuO+eKOiq3DfXuYskzeiVcPcu3dQt5UF
         f7DJLYamEhrA3bX3b+xLCmQjh0ydQjGhYnS2ow3hbmwu2JZXA9/7JZuF6HIFkYCGkqVy
         nlRg==
X-Gm-Message-State: ANhLgQ1wKJOKeMaGXdweB5clwu7tXSXY34ZkMYWaiq9FZgA6ZxuKo2Xy
        UPnmc/m9IGfoqZ1iomaJ87EOPV31npl9hrCp5BQ4nx83HAssTex38s9a/GYoRU44yaWmnkPHgEE
        +07BG7JylUZuw
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr12354286wrn.106.1584105953550;
        Fri, 13 Mar 2020 06:25:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtNNOSsAUJeY4L6aedmncWQYrdwJODwZaTfEPbLD9g0Egg8iJWDxx35ffXEP6v/Wqy7JF7pIA==
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr12354264wrn.106.1584105953338;
        Fri, 13 Mar 2020 06:25:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w22sm17104519wmk.34.2020.03.13.06.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 06:25:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pbonzini@redhat.com, peterx@redhat.com
Subject: Re: [Patch v2] KVM: x86: Initializing all kvm_lapic_irq fields in ioapic_write_indirect
In-Reply-To: <1584105384-4864-1-git-send-email-nitesh@redhat.com>
References: <1584105384-4864-1-git-send-email-nitesh@redhat.com>
Date:   Fri, 13 Mar 2020 14:25:51 +0100
Message-ID: <871rpwpesg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nitesh Narayan Lal <nitesh@redhat.com> writes:

> Previously all fields of structure kvm_lapic_irq were not initialized
> before it was passed to kvm_bitmap_or_dest_vcpus(). Which will cause
> an issue when any of those fields are used for processing a request.
> For example not initializing the msi_redir_hint field before passing
> to the kvm_bitmap_or_dest_vcpus(), may lead to a misbehavior of
> kvm_apic_map_get_dest_lapic(). This will specifically happen when the
> kvm_lowest_prio_delivery() returns TRUE due to a non-zero garbage
> value of msi_redir_hint, which should not happen as the request belongs
> to APIC fixed delivery mode and we do not want to deliver the
> interrupt only to the lowest priority candidate.
>
> This patch initializes all the fields of kvm_lapic_irq based on the
> values of ioapic redirect_entry object before passing it on to
> kvm_bitmap_or_dest_vcpus().
>
> Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  arch/x86/kvm/ioapic.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 7668fed..3a8467d 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -378,12 +378,15 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  		if (e->fields.delivery_mode == APIC_DM_FIXED) {
>  			struct kvm_lapic_irq irq;
>  
> -			irq.shorthand = APIC_DEST_NOSHORT;
>  			irq.vector = e->fields.vector;
>  			irq.delivery_mode = e->fields.delivery_mode << 8;
> -			irq.dest_id = e->fields.dest_id;
>  			irq.dest_mode =
>  			    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
> +			irq.level = 1;

'level' is bool in struct kvm_lapic_irq but other than that, is there a
reason we set it to 'true' here? I understand that any particular
setting is likely better than random and it should actually not be used
without setting it first but still?

> +			irq.trig_mode = e->fields.trig_mode;
> +			irq.shorthand = APIC_DEST_NOSHORT;
> +			irq.dest_id = e->fields.dest_id;
> +			irq.msi_redir_hint = false;
>  			bitmap_zero(&vcpu_bitmap, 16);
>  			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  						 &vcpu_bitmap);

-- 
Vitaly

