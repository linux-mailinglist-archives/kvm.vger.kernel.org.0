Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3536E2B4FF9
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgKPSkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:40:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgKPSkV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 13:40:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605552020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sAgl3gDH6G3SQeERNWPgxq6ZahGt/HzW3OGrSYVSsZw=;
        b=IDN1GSUPv4XGgzU8VrpJNdQpRNm1+63M8k6n5LRia9HxS3J2ekTaJ/mg8Sx4V+VjkvmSQD
        DZQLzgo236R00ktrgGBWz9eiQTYPCoHO+Qb5GYBrNB5eRzO8m2phke2v6Yd6iUySWFkMzF
        pd9y4P8nrVKmRsDZM2yh2W7CBO7y4uM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-oevYcbdUNduzHPETgxX4IQ-1; Mon, 16 Nov 2020 13:40:14 -0500
X-MC-Unique: oevYcbdUNduzHPETgxX4IQ-1
Received: by mail-qt1-f198.google.com with SMTP id x20so10787952qts.19
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 10:40:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sAgl3gDH6G3SQeERNWPgxq6ZahGt/HzW3OGrSYVSsZw=;
        b=fMkSZgLEno/gCwvXduztrkJgQRoKWhsRdj0nwhBvRUL3wqbge0tkwkkjORg+qrX8xW
         iLQ0oCIkVT5+fw8S1CcQx/XTzQ0eFbPtyWvTeD4BAKFRDn2O4ZCyaAW6J6AjjiUIKT7v
         uaFoNOfIxq6fPKR6AzR4u0U6WdpJ6E5nHqgMmgggBZ6zHiKQ4YWIdFpgcButQQ0RktEu
         2FdZhqI/jWEwe464O1MaltyosiX26Y/AMpgZx3omsndMW2bNXEGX4y1PLty1NidXvUUG
         W73TpT28VA9DdhfQdUL+MF1juBMWBApEEgbK4COiF81DIrYc3C/XLBu8AMs2Z9jWOY3H
         +8DA==
X-Gm-Message-State: AOAM532o1d+nURHdBP2FQOWEiqSyiEh0fZIH1TgjsNQQcL3xawMn3MRw
        XoxyhEIuRhuwnW7rtwPdJNVSbD7s/TI1EgQ9oeSvuxKiPMkKyQWwRxWKEtBYnf/mUo9N/4ptDGD
        POUgvrjY+ZoKX
X-Received: by 2002:a37:a97:: with SMTP id 145mr6216895qkk.465.1605552013995;
        Mon, 16 Nov 2020 10:40:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoRPVwMTrcS1lBu+VsiLhBIF6PfslugO9bKe8iS2bPkCdN4r8LS5mT864J/GlAVDvLTpIHqQ==
X-Received: by 2002:a37:a97:: with SMTP id 145mr6216871qkk.465.1605552013731;
        Mon, 16 Nov 2020 10:40:13 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id h12sm12342007qta.94.2020.11.16.10.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 10:40:13 -0800 (PST)
Date:   Mon, 16 Nov 2020 13:40:11 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
Message-ID: <20201116184011.GB19950@xz-x1>
References: <20201116121942.55031-1-drjones@redhat.com>
 <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 07:16:50PM +0100, Paolo Bonzini wrote:
> On 16/11/20 13:19, Andrew Jones wrote:
> > This series attempts to clean up demand_paging_test, dirty_log_perf_test,
> > and dirty_log_test by factoring out common code, creating some new API
> > along the way. It also splits include/perf_test_util.h into a more
> > conventional header and source pair.
> > 
> > I've tested on x86 and AArch64 (one config each), but not s390x.
> > 
> > v3:
> >   - Rebased remaining four patches from v2 onto kvm/queue
> >   - Picked up r-b's from Peter and Ben
> > 
> > v2: https://www.spinics.net/lists/kvm/msg228711.html
> 
> Unfortunately patch 2 is still broken:
> 
> $ ./dirty_log_test -M dirty-ring
> Setting log mode to: 'dirty-ring'
> Test iterations: 32, interval: 10 (ms)
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> ==== Test Assertion Failure ====
>   lib/kvm_util.c:85: ret == 0
>   pid=2010122 tid=2010122 - Invalid argument
>      1	0x0000000000402ee7: vm_enable_cap at kvm_util.c:84
>      2	0x0000000000403004: vm_enable_dirty_ring at kvm_util.c:124
>      3	0x00000000004021a5: log_mode_create_vm_done at dirty_log_test.c:453
>      4	 (inlined by) run_test at dirty_log_test.c:683
>      5	0x000000000040b643: for_each_guest_mode at guest_modes.c:37
>      6	0x00000000004019c2: main at dirty_log_test.c:864
>      7	0x00007fe3f48207b2: ?? ??:0
>      8	0x0000000000401aad: _start at ??:?
>   KVM_ENABLE_CAP IOCTL failed,
>   rc: -1 errno: 22
> 
> (Also fails without -M).

It should be because of the ordering of creating vcpu and enabling dirty rings,
since currently for simplicity when enabling dirty ring we must have not
created any vcpus:

+       if (kvm->created_vcpus) {
+               /* We don't allow to change this value after vcpu created */
+               r = -EINVAL;
+       } else {
+               kvm->dirty_ring_size = size;
+               r = 0;
+       }

We may need to call log_mode_create_vm_done() before creating any vcpus
somehow.  Sorry to not have noticed that when reviewing it.

-- 
Peter Xu

