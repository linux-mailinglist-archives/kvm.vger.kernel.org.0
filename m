Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67ECA177D8F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 18:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgCCRdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 12:33:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36094 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730411AbgCCRdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 12:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583256822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gxnMDm1mj8e+e8hgSCFPYUZNViu0FuRVXA/Vwdb0hRY=;
        b=aQddCnVNTlmjNTbqd3RKlgw+4WofFZsYqbbNJ57z1G2IEcHye3APctRI+3RXlF6DtqydPN
        bfv+MkPMU8eZjeslhDJTzgcMl3xYvOGnLCzyAQhYT88U5cgLVVaY8sBrqGqt/d36YQkHZp
        3ma/t4luj1Ij+/badpkPeCfipV7e2c8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-4rN-72XvNjefgmbguNp6Qg-1; Tue, 03 Mar 2020 12:33:41 -0500
X-MC-Unique: 4rN-72XvNjefgmbguNp6Qg-1
Received: by mail-qt1-f199.google.com with SMTP id h90so2663108qtd.23
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 09:33:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gxnMDm1mj8e+e8hgSCFPYUZNViu0FuRVXA/Vwdb0hRY=;
        b=NmR0UN8XSSywSnW4jc3QlbIPkKUaDjAQSv4N/JVu5h5eyLT/SbO81TK55HnwYMJ6oB
         dUVACvcPetBs3jR4FGSnwN8Yfg8QewvjOEf5zH7sIfnVS+SZCuQrDnDlY+LERPsbcwpF
         cjKTRDKe9+vzKxkmpBJQ4cR5fy+Nhlj4zCLaY7vWs4zL/1ia5aXkc6mbAo0p4TOqPdzt
         ELvckqxN/1FrKVjHvCunNg+VlXKn1rF7NUSqHoiljeCOE2j1SnMZ6ms1mnTXTcCRfx4i
         +s99xSGOxRz2FtHbra6uQp/EHsVtFXlWgsScBtqzuWqQ+tFbXIkhIq4eDHIFudFEs0L4
         F74A==
X-Gm-Message-State: ANhLgQ3QzFcXzAY53p+kr5sAEPlU1+rS+f98XydVb1mCQ7JY9hNapHYW
        JVD0/+hYheL/rFx4T8NzyJH8PTWZcMxkTeyi0yNihanbiq2ST/Vz01OvAOwxG1ZumL/RIPjiblt
        aPBzQ7bIVqe5D
X-Received: by 2002:a0c:f707:: with SMTP id w7mr5015554qvn.46.1583256819815;
        Tue, 03 Mar 2020 09:33:39 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuHtSJyfYDqXoUN1urEzaepBYjtUM0hwlk7Vp2mQmweuGkMQhYrGhiK0np00+bkmmUz680EJw==
X-Received: by 2002:a0c:f707:: with SMTP id w7mr5015528qvn.46.1583256819589;
        Tue, 03 Mar 2020 09:33:39 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id m1sm4095574qkk.103.2020.03.03.09.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 09:33:38 -0800 (PST)
Date:   Tue, 3 Mar 2020 12:33:34 -0500
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v4 00/14] KVM: Dirty ring interface
Message-ID: <20200303173334.GE464129@xz-x1>
References: <20200205025105.367213-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205025105.367213-1-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 09:50:51PM -0500, Peter Xu wrote:
> KVM branch:
>   https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> 
> QEMU branch for testing:
>   https://github.com/xzpeter/qemu/tree/kvm-dirty-ring
> 
> v4 changelog:
> 
> - refactor ring layout: remove indices, use bit 0/1 in the gfn.flags
>   field to encode GFN status (invalid, dirtied, collected) [Michael,
>   Paolo]
> - patch memslot_valid_for_gpte() too to check against memslot flags
>   rather than dirty_bitmap pointer
> - fix build on non-x86 arch [syzbot]
> - fix comment for kvm_dirty_gfn [Michael]
> - check against VM_EXEC, VM_SHARED for mmaps [Michael]
> - fix "KVM: X86: Don't track dirty for
>   KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]" to unbreak
>   unrestricted_guest=N [Sean]
> - some rework in the test code, e.g., more comments

Any comments before I repost another version?  Thanks,

-- 
Peter Xu

