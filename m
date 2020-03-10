Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7AF17FFDF
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgCJOLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:11:45 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53155 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbgCJOLn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 10:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583849502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4VMlPSkkEaFEV/UY+CJNGIQlRtniz4tmHocOHXLHtXw=;
        b=YffjYSymLwRq2Vnn9m546Fi2mQ1vf49ASO5EuGf4jpi2xBMG4ApQJ0bROQBmj3HABPqVtw
        aORiOLCeDFgCI/7CnLR+LNP/igS3BB9VJuSBw9THSi/WYjW8kvmWfbgNDILRZ7EEfFG6AH
        0HzSDxnMd0VTS+DJmeYUidxxi7fHvF8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-a7GrYIVdMD2x2R0lDvAEew-1; Tue, 10 Mar 2020 10:11:38 -0400
X-MC-Unique: a7GrYIVdMD2x2R0lDvAEew-1
Received: by mail-qt1-f197.google.com with SMTP id k20so9195275qtm.11
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 07:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4VMlPSkkEaFEV/UY+CJNGIQlRtniz4tmHocOHXLHtXw=;
        b=r4tZ+85o6NI855v9kcs6/zgx5T84wnxnAkOvJBM+JVWUmw3jMwlMPB71xtwrnJEsio
         mbpLxO/7sjc24D9Z8eyX20j1S/rtLfjn/xg2wFD2vcMafH+aEWpUSwDSAkOZ9yLLW4z6
         5q5zwu0AUj6TLWv+0sSv2Lr22Ito59y819Du65XujnLxZi118BS+gbT/00oWKd/qJ8Ym
         HtrM54ndRI1MfbEFxrnQ9Dt6md9bUxPhFeQjVo4XfDpAbsrW2dWsQFBKrEEObbPn/pu4
         w7lSeSL4vG2sxJmBoEMKGAbp1x1rRhCTuaTBnPO+aIPbgbbOC1irWwNLXmcZ7wnKOCXG
         M1rQ==
X-Gm-Message-State: ANhLgQ0RYEk+mFWN1BP1iINxKQlTiqkvyE/cj7oX0uIILBO3dVXTtXm5
        wfKELP14uzIzIhcfKG7j+lSDT76fBlqjKuAPgOjn3cGY6FsQGmn9G8NxcrhIZCgHxZ3w3WC/Lhl
        phgMZNvaWHpzF
X-Received: by 2002:ad4:498c:: with SMTP id t12mr13713737qvx.27.1583849498210;
        Tue, 10 Mar 2020 07:11:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuq5Hd2E1gOPKAjD/xk0yU5tPclVVvaT0lJDm/8lSD7XYa6TVP1JdMFzrX8lvQtFIZQU5Qu7g==
X-Received: by 2002:ad4:498c:: with SMTP id t12mr13713704qvx.27.1583849497927;
        Tue, 10 Mar 2020 07:11:37 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id i4sm24289819qkf.111.2020.03.10.07.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 07:11:36 -0700 (PDT)
Date:   Tue, 10 Mar 2020 10:11:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v5 05/14] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200310101039-mutt-send-email-mst@kernel.org>
References: <20200304174947.69595-6-peterx@redhat.com>
 <202003061911.MfG74mgX%lkp@intel.com>
 <20200309213554.GF4206@xz-x1>
 <20200310022931-mutt-send-email-mst@kernel.org>
 <20200310140921.GD326977@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310140921.GD326977@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 10:09:21AM -0400, Peter Xu wrote:
> On Tue, Mar 10, 2020 at 02:31:55AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Mar 09, 2020 at 05:35:54PM -0400, Peter Xu wrote:
> > > I'll probably also
> > > move KVM_DIRTY_LOG_PAGE_OFFSET==0 definition to uapi/linux/kvm.h.
> > 
> > 
> > IMHO KVM_DIRTY_LOG_PAGE_OFFSET is kind of pointless anyway - 
> > we won't be able to move data around just by changing the
> > uapi value since userspace isn't
> > recompiled when kernel changes ...
> 
> Yes I think we can even drop this KVM_DIRTY_LOG_PAGE_OFFSET==0
> definition.  IMHO it's only a matter of whether we would like to
> directly reference this value in the common code (e.g., for kernel
> virt/kvm_main.c) or we want quite a few of this instead:
> 
> #ifdef KVM_DIRTY_LOG_PAGE_OFFSET
> ..
> #endif

Hmm do other arches define it to a different value?
Maybe I'm confused.
If they do then it makes sense.

> I slightly prefer to not use lots of "#ifdef"s so I chose to make sure
> it's defined.  However I've no strong opinion on this either. So I'm
> open to change that if anyone insists with some reasons.
> 
> Thanks,
> 
> -- 
> Peter Xu

