Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16CB18008A
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgCJOrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:47:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33527 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726546AbgCJOrH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 10:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583851626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/K2o/46tRWBXyxtbLA8WN6DhZTWN58tPFLWETT0m6mA=;
        b=C3mo8dK9VFXrZBtZykkT5QuexLjpALDp7k92869xT8CuIH3cHMNBBygKsgJ5AilmPMYbAX
        8zX8OAQR8OdBXNllrB8lwlrM99P1eoxdmM/8WXl3a7BcOFuT1qNpuyG495YmZxRsS+U4p5
        KfgTVwMmEKlbmpsROjXBaHTbwWHuSHs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-Pg-3EXhqNiuPU7g3rnoS7Q-1; Tue, 10 Mar 2020 10:47:04 -0400
X-MC-Unique: Pg-3EXhqNiuPU7g3rnoS7Q-1
Received: by mail-qt1-f200.google.com with SMTP id l21so9324760qtq.1
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 07:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/K2o/46tRWBXyxtbLA8WN6DhZTWN58tPFLWETT0m6mA=;
        b=WoC6Tvbe3ieshcsJH4V50bzMjWBGzDfx2aEcAoFZ7wTtG26qqnXHKvsx8Ar189d4FK
         168XWjvhX8mloJnX95YPiDSLrT8kW1E6HZCzlMKmK6vBJQX/1oEZG5FlhubdibfYqrQT
         UnXV7iofasqLDsF75wvRt9PrBZzTCLOBOlzpveF3wWxLDY0Ttfd7H1iKM8N+ERJ2wKUY
         MxQh5uafWIQrMuBAyK2asAXZjQrigqAdJGpISulblo7r5gLrKH6myDB+8W+EH2DnWwud
         pqqJLUwRVanEQ2AIkyUABP14PvS8tf5dKvrVuiA4lMrf/oxye7A2+n//CtXngl/AWSng
         MaCA==
X-Gm-Message-State: ANhLgQ2SO03ufCWQ+w3rddMo0K8b3hyXqex4p46ipa97DVG2T48ueT9j
        e7QbaSf/kBEEeAI8Ct6MWjQyYBs7oSn6FhpJxdHBtIAfB7CzqTJMbfznV3HIX+c7OYiywi9Fb2J
        dKneLARYC1zYv
X-Received: by 2002:a37:ac0d:: with SMTP id e13mr12961399qkm.322.1583851624189;
        Tue, 10 Mar 2020 07:47:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsO5t96TYULUQ/OWhsrr/bJIx5RPnb2BGkPM43s56kyXIhd56DU7c0qnH9J8f51YYvCI8slrQ==
X-Received: by 2002:a37:ac0d:: with SMTP id e13mr12961366qkm.322.1583851623887;
        Tue, 10 Mar 2020 07:47:03 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id x7sm17997027qkx.110.2020.03.10.07.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 07:47:03 -0700 (PDT)
Date:   Tue, 10 Mar 2020 10:46:56 -0400
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
Message-ID: <20200310104627-mutt-send-email-mst@kernel.org>
References: <20200304174947.69595-6-peterx@redhat.com>
 <202003061911.MfG74mgX%lkp@intel.com>
 <20200309213554.GF4206@xz-x1>
 <20200310022931-mutt-send-email-mst@kernel.org>
 <20200310140921.GD326977@xz-x1>
 <20200310101039-mutt-send-email-mst@kernel.org>
 <20200310141901.GE326977@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310141901.GE326977@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 10:19:01AM -0400, Peter Xu wrote:
> On Tue, Mar 10, 2020 at 10:11:30AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Mar 10, 2020 at 10:09:21AM -0400, Peter Xu wrote:
> > > On Tue, Mar 10, 2020 at 02:31:55AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Mar 09, 2020 at 05:35:54PM -0400, Peter Xu wrote:
> > > > > I'll probably also
> > > > > move KVM_DIRTY_LOG_PAGE_OFFSET==0 definition to uapi/linux/kvm.h.
> > > > 
> > > > 
> > > > IMHO KVM_DIRTY_LOG_PAGE_OFFSET is kind of pointless anyway - 
> > > > we won't be able to move data around just by changing the
> > > > uapi value since userspace isn't
> > > > recompiled when kernel changes ...
> > > 
> > > Yes I think we can even drop this KVM_DIRTY_LOG_PAGE_OFFSET==0
> > > definition.  IMHO it's only a matter of whether we would like to
> > > directly reference this value in the common code (e.g., for kernel
> > > virt/kvm_main.c) or we want quite a few of this instead:
> > > 
> > > #ifdef KVM_DIRTY_LOG_PAGE_OFFSET
> > > ..
> > > #endif
> > 
> > Hmm do other arches define it to a different value?
> > Maybe I'm confused.
> > If they do then it makes sense.
> 
> Yes they can. So far with this series only x86 will define it to
> nonzero (64). But logically other archs can define it to different
> values.


Oh ok then. somehow I thought it's 0 for all arches.
Sorry about the noise, pls ignore this comment.

> 
> We can reference this to existing offsets that we've defined already
> for different archs, like KVM_COALESCED_MMIO_PAGE_OFFSET:
> 
>   - For ppc, it's defined as 1 (arch/powerpc/include/uapi/asm/kvm.h)
>   - For x86, it's defined as 2 (arch/x86/include/uapi/asm/kvm.h)
>   - ...
> 
> Thanks,
> > 
> > > I slightly prefer to not use lots of "#ifdef"s so I chose to make sure
> > > it's defined.  However I've no strong opinion on this either. So I'm
> > > open to change that if anyone insists with some reasons.
> > > 
> > > Thanks,
> > > 
> > > -- 
> > > Peter Xu
> > 
> 
> -- 
> Peter Xu

