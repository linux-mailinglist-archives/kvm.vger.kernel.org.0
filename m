Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667FB18D394
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgCTQIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:08:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47032 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbgCTQIv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R+2BZLljduDR4gY9kJvfaxoG77rg51FKrPLFzBeLubM=;
        b=KZhx8odyDLqY/cCqwW445AjCK9R7MnjzROOB/V0psd2U1rzrG9On1cjxWYvk0XxfNvipyH
        VU/06jYO9lk8oUgJ8nDs/uVqaMi5FHx3Xo70bwfbx5SmfpnSYgJHpUhRtlH/EM0koWv/vR
        GKBNP05f/YrFQmsPS/iVxtwONL+u46s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-Hzfp_iVnOSGZJHG0uhihkA-1; Fri, 20 Mar 2020 12:08:48 -0400
X-MC-Unique: Hzfp_iVnOSGZJHG0uhihkA-1
Received: by mail-wm1-f70.google.com with SMTP id n188so1974045wmf.0
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 09:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=R+2BZLljduDR4gY9kJvfaxoG77rg51FKrPLFzBeLubM=;
        b=V+Khie4Bi2Cx1PpVd6FyIWinwfeKUTUzq0GXjduwFrflPS5I17+33hYMR6VfYKW6+Y
         EO3LtK1b4oEaBSrLmMathB4n4v/WEjXbF0OW59AR8x/1NUXgNfeDgFtgmM26RqyildMB
         cIxhCuJfZnkLgOYr3FHqfpwtRilaTuNuMxb6k4TJlrd7fEQWd7Bw8mAnnp0hKbt+l2oW
         U7T66yKZsp+VDv2TNEdWTh23l1yYTI79O/9rbbKjDiJ2jhLJYaBXoBu12Ap10Cu73jl0
         xQLT7/lAtGzz0zaZP43NdT+qv/vRYbVp6JN1e7Ht94Nc16eO6uM3ixoXRjsbVAXKaEEd
         0/gA==
X-Gm-Message-State: ANhLgQ1bei1QRRt1LZpNnVw1OICLzr2QJe6HITVm/q8iw3rwc8i43ym9
        rH+o4qBUcAR0Zd4xelFJORmrrqOoY2R68UN3ezy3pAEY/l7+2vqcCfCS5/d6YDnw4XqH+jFZKUU
        pCALBApsh7LNz
X-Received: by 2002:a05:6000:370:: with SMTP id f16mr12276230wrf.9.1584720527389;
        Fri, 20 Mar 2020 09:08:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvO1+wVJWGCOAIsUa5XTIUbHwop7hDHw1XAgSOqKk8kdtayaPKfI3Y8uamOGk69TeQA1/LHmQ==
X-Received: by 2002:a05:6000:370:: with SMTP id f16mr12276192wrf.9.1584720527078;
        Fri, 20 Mar 2020 09:08:47 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id x5sm9157795wrv.67.2020.03.20.09.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 09:08:46 -0700 (PDT)
Date:   Fri, 20 Mar 2020 12:08:42 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Qian Cai <cai@lca.pw>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: slab-out-of-bounds due to "KVM: Dynamically size memslot array
 based on number of used slots"
Message-ID: <20200320160842.GE127076@xz-x1>
References: <8922D835-ED2A-4C48-840A-F568E20B5A7C@lca.pw>
 <20200320043403.GH11305@linux.intel.com>
 <5FF6AF4E-EB99-4111-BBB2-FE09FFBEF5C4@lca.pw>
 <20200320135346.GA16533@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200320135346.GA16533@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 06:53:46AM -0700, Sean Christopherson wrote:
> On Fri, Mar 20, 2020 at 09:49:03AM -0400, Qian Cai wrote:
> > 
> > 
> > > On Mar 20, 2020, at 12:34 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > > 
> > > On Thu, Mar 19, 2020 at 11:59:23PM -0400, Qian Cai wrote:
> > >> Reverted the linux-next commit 36947254e5f98 (“KVM: Dynamically size memslot array based on number of used slots”)
> > >> fixed illegal slab object redzone accesses.
> > >> 
> > >> [6727.939776][ T1818] BUG: KASAN: slab-out-of-bounds in gfn_to_hva+0xc1/0x2b0 [kvm]
> > >> search_memslots at include/linux/kvm_host.h:1035
> > > 
> > > Drat.  I'm guessing lru_slot is out of range after a memslot is deleted.
> > > This should fix the issue, though it may not be the most proper fix, e.g.
> > > it might be better to reset lru_slot when deleting a memslot.  I'll try and
> > > reproduce tomorrow, unless you can confirm this does the trick.
> > 
> > It works fine.
> 
> Thanks!  I'll send a proper patch in a bit, tweaking a selftest to try and
> hit this as well.

Would resetting lru_slot be better?  So to avoid other potential
references to an obsolete lru_slot outside search_memslots().  E.g., I
see that s390 has another function (gfn_to_memslot_approx) used it.

Thanks,

-- 
Peter Xu

