Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04E5180004
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgCJOTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:19:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31683 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726591AbgCJOTI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 10:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583849946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CLT2RA5SUURWmsLjASg70cp/vjsXgOMPTwKZtH6acFQ=;
        b=Fj0crWzxlMfA36XVFDttHR/Z3GoLv7ntFCjuLbMLSbko8ho7axYsUiEcO7DT916RYfRcRr
        Ol7KnkC0q09zP0hTIhgNXptTaBtyeOxwCRaR7QZ4U/s3XbD6SdDTPrGWV5GWQyM3h5rCWP
        89KIhiKj700W8LYawq5J7YrQxIMrzNY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-9aFClHXxOxiKq80KfhrROQ-1; Tue, 10 Mar 2020 10:19:05 -0400
X-MC-Unique: 9aFClHXxOxiKq80KfhrROQ-1
Received: by mail-qk1-f200.google.com with SMTP id b22so9801136qkk.15
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 07:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CLT2RA5SUURWmsLjASg70cp/vjsXgOMPTwKZtH6acFQ=;
        b=Lkz8vhrur5MJ0r7Ntx1bJ4iG+yYD0YfFNeDvZm3EjGBvIBIKo3Sj7GO4c3W5S+T+rq
         DtmHV1kfXRqjgh67Z60hf4YJsfIeF50jNXTfQrSZ7HEV78+UdNmz+tIgC2DpYsSLq8Kg
         QyUlzKhcakIRytM4SidgqJDT2gWwEnozUH27ZiP34NpcVdGk1oa9WM/mXm6x/bYRQtZ6
         B5WMi+2O3oKo6FVqaCaBKVJaTnEyi6HMTLai+v4Y9qQKAtu57/sjfZGL8PN8ri8HOzj/
         jlUN305atqShVFOfnAjpIE2A+8kqNP1VNcUuvGDf+eEgCKyiYuTPVUZKlq88ISPGSYH2
         5/5w==
X-Gm-Message-State: ANhLgQ1fbfS9pMqlv/XAO0aknhvZyCcozaodgjtT7J9wHeV5bKDoO1wA
        wxc2ATQY5tJvaXmMfY0HOUqy8tNYJuVCJthmnNP/KmFRpT7GuLZs13Loh+qcO28eF5P6eC56K71
        50KovrRLFq96G
X-Received: by 2002:ac8:24ee:: with SMTP id t43mr19370549qtt.5.1583849944547;
        Tue, 10 Mar 2020 07:19:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvbLInUYGyyBaSkTuX8MpCYO9twVHQpnHtWU2LMTP/RRdtqsEsL8hRnvWZPpPKEbp/TBnoJRA==
X-Received: by 2002:ac8:24ee:: with SMTP id t43mr19370525qtt.5.1583849944291;
        Tue, 10 Mar 2020 07:19:04 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w13sm17099618qtn.83.2020.03.10.07.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 07:19:03 -0700 (PDT)
Date:   Tue, 10 Mar 2020 10:19:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20200310141901.GE326977@xz-x1>
References: <20200304174947.69595-6-peterx@redhat.com>
 <202003061911.MfG74mgX%lkp@intel.com>
 <20200309213554.GF4206@xz-x1>
 <20200310022931-mutt-send-email-mst@kernel.org>
 <20200310140921.GD326977@xz-x1>
 <20200310101039-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200310101039-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 10:11:30AM -0400, Michael S. Tsirkin wrote:
> On Tue, Mar 10, 2020 at 10:09:21AM -0400, Peter Xu wrote:
> > On Tue, Mar 10, 2020 at 02:31:55AM -0400, Michael S. Tsirkin wrote:
> > > On Mon, Mar 09, 2020 at 05:35:54PM -0400, Peter Xu wrote:
> > > > I'll probably also
> > > > move KVM_DIRTY_LOG_PAGE_OFFSET==0 definition to uapi/linux/kvm.h.
> > > 
> > > 
> > > IMHO KVM_DIRTY_LOG_PAGE_OFFSET is kind of pointless anyway - 
> > > we won't be able to move data around just by changing the
> > > uapi value since userspace isn't
> > > recompiled when kernel changes ...
> > 
> > Yes I think we can even drop this KVM_DIRTY_LOG_PAGE_OFFSET==0
> > definition.  IMHO it's only a matter of whether we would like to
> > directly reference this value in the common code (e.g., for kernel
> > virt/kvm_main.c) or we want quite a few of this instead:
> > 
> > #ifdef KVM_DIRTY_LOG_PAGE_OFFSET
> > ..
> > #endif
> 
> Hmm do other arches define it to a different value?
> Maybe I'm confused.
> If they do then it makes sense.

Yes they can. So far with this series only x86 will define it to
nonzero (64). But logically other archs can define it to different
values.

We can reference this to existing offsets that we've defined already
for different archs, like KVM_COALESCED_MMIO_PAGE_OFFSET:

  - For ppc, it's defined as 1 (arch/powerpc/include/uapi/asm/kvm.h)
  - For x86, it's defined as 2 (arch/x86/include/uapi/asm/kvm.h)
  - ...

Thanks,

> 
> > I slightly prefer to not use lots of "#ifdef"s so I chose to make sure
> > it's defined.  However I've no strong opinion on this either. So I'm
> > open to change that if anyone insists with some reasons.
> > 
> > Thanks,
> > 
> > -- 
> > Peter Xu
> 

-- 
Peter Xu

