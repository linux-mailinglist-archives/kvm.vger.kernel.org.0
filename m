Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD6C19C2E3
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 15:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbgDBNos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 09:44:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47221 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388602AbgDBNor (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 09:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585835085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gvQ2R8y99CBBi8RZRazk2nffx/pgU8Suz+ahqIPXbdM=;
        b=Y3GpHctOFuZoF0h9FGLYU6eHhJAhftJP7fkm4Mmc/5v/OVGV4btc0Zhqu5FkGhUnWfrbur
        G18TDMWDMr18w4OmiMuNCoch7DfcNOZ76e/HmkitYgYBJXcgASNOlWYqOcgXQFBdeXDgyO
        tEjJfYjwFuffqjhHELwK3j+5yz6m+dE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-gyUPnMVePfmyS1RQBFGd1w-1; Thu, 02 Apr 2020 09:44:44 -0400
X-MC-Unique: gyUPnMVePfmyS1RQBFGd1w-1
Received: by mail-wr1-f69.google.com with SMTP id v17so1488834wro.21
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 06:44:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gvQ2R8y99CBBi8RZRazk2nffx/pgU8Suz+ahqIPXbdM=;
        b=U5MGYfqnrmrwakFGehooGOW72OPFneoBCte6b8gihqntN+5CvNuzGM1i1GAzsvr8LR
         A3El5QWxCpirpdzSM7wzHcwsfEN4ApsJ1BV1Zf6RK2nQz3HhmSt6np0IdszrMoCK2vNg
         limBeNZn4IkNHI38Y+VZNhP8K2AoJ+jwUsIDfnRhqUNaaAOAZGJymx6JP4zr8/9iyIVF
         vUmpTOuefqi2a0A93lKV9CMtQ6Yc98KPZyrljLUMPkla1K0sisOGotri7eneHj5oCp7l
         HmRsk35ANb2qpMZaSDQmBc9WMjVravUu28QKPPY2P1rvRZAPdjzsn34OiCjm8+EILyBo
         Zkzg==
X-Gm-Message-State: AGi0PuaWNIP2O9LCGjk4L57r1BL8+mde7htbd6bsfQ8ycL6NIMFS7lk7
        NSsiOIsW2i4HXh2SZmLn29z/GNv1YweHbVHKq+Pq4cncoXtZpOqLbTphhnz61ka7sKTve+wTSD7
        0cDl0IMr7L368
X-Received: by 2002:a7b:c148:: with SMTP id z8mr3475039wmi.31.1585835082970;
        Thu, 02 Apr 2020 06:44:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypLx20559FBmzYn1zSgVJF/1OJmxG/m/FZix8ZKxUksypGr3hxHYdG87RbmNwxVxHM8SPltmSw==
X-Received: by 2002:a7b:c148:: with SMTP id z8mr3475005wmi.31.1585835082622;
        Thu, 02 Apr 2020 06:44:42 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id z129sm7277739wmb.7.2020.04.02.06.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 06:44:41 -0700 (PDT)
Date:   Thu, 2 Apr 2020 09:44:36 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v2 13/22] intel_iommu: add PASID cache management
 infrastructure
Message-ID: <20200402134436.GI7174@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-14-git-send-email-yi.l.liu@intel.com>
 <20200402000225.GC7174@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A21EAAD@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A21EAAD@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 06:46:11AM +0000, Liu, Yi L wrote:

[...]

> > > +/**
> > > + * This function replay the guest pasid bindings to hots by
> > > + * walking the guest PASID table. This ensures host will have
> > > + * latest guest pasid bindings. Caller should hold iommu_lock.
> > > + */
> > > +static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
> > > +                                            VTDPASIDCacheInfo
> > > +*pc_info) {
> > > +    VTDHostIOMMUContext *vtd_dev_icx;
> > > +    int start = 0, end = VTD_HPASID_MAX;
> > > +    vtd_pasid_table_walk_info walk_info = {.flags = 0};
> > 
> > So vtd_pasid_table_walk_info is still used.  I thought we had reached a consensus
> > that this can be dropped?
> 
> yeah, I did have considered your suggestion and plan to do it. But when
> I started coding, it looks a little bit weird to me:
> For one, there is an input VTDPASIDCacheInfo in this function. It may be
> nature to think about passing the parameter to further calling
> (vtd_replay_pasid_bind_for_dev()). But, we can't do that. The vtd_bus/devfn
> fields should be filled when looping the assigned devices, not the one
> passed by vtd_replay_guest_pasid_bindings() caller.

Hacky way is we can directly modify VTDPASIDCacheInfo* with bus/devfn
for the loop.  Otherwise we can duplicate the object when looping, so
that we can avoid introducing a new struct which seems to contain
mostly the same information.

> For two, reusing the VTDPASIDCacheInfo for passing walk info may require
> the final user do the same thing as what the vtd_replay_guest_pasid_bindings()
> has done here.

I don't see it happen, could you explain?

> 
> So kept the vtd_pasid_table_walk_info.

[...]

> > > +/**
> > > + * This function syncs the pasid bindings between guest and host.
> > > + * It includes updating the pasid cache in vIOMMU and updating the
> > > + * pasid bindings per guest's latest pasid entry presence.
> > > + */
> > > +static void vtd_pasid_cache_sync(IntelIOMMUState *s,
> > > +                                 VTDPASIDCacheInfo *pc_info) {
> > > +    /*
> > > +     * Regards to a pasid cache invalidation, e.g. a PSI.
> > > +     * it could be either cases of below:
> > > +     * a) a present pasid entry moved to non-present
> > > +     * b) a present pasid entry to be a present entry
> > > +     * c) a non-present pasid entry moved to present
> > > +     *
> > > +     * Different invalidation granularity may affect different device
> > > +     * scope and pasid scope. But for each invalidation granularity,
> > > +     * it needs to do two steps to sync host and guest pasid binding.
> > > +     *
> > > +     * Here is the handling of a PSI:
> > > +     * 1) loop all the existing vtd_pasid_as instances to update them
> > > +     *    according to the latest guest pasid entry in pasid table.
> > > +     *    this will make sure affected existing vtd_pasid_as instances
> > > +     *    cached the latest pasid entries. Also, during the loop, the
> > > +     *    host should be notified if needed. e.g. pasid unbind or pasid
> > > +     *    update. Should be able to cover case a) and case b).
> > > +     *
> > > +     * 2) loop all devices to cover case c)
> > > +     *    - For devices which have HostIOMMUContext instances,
> > > +     *      we loop them and check if guest pasid entry exists. If yes,
> > > +     *      it is case c), we update the pasid cache and also notify
> > > +     *      host.
> > > +     *    - For devices which have no HostIOMMUContext, it is not
> > > +     *      necessary to create pasid cache at this phase since it
> > > +     *      could be created when vIOMMU does DMA address translation.
> > > +     *      This is not yet implemented since there is no emulated
> > > +     *      pasid-capable devices today. If we have such devices in
> > > +     *      future, the pasid cache shall be created there.
> > > +     * Other granularity follow the same steps, just with different scope
> > > +     *
> > > +     */
> > > +
> > > +    vtd_iommu_lock(s);
> > > +    /* Step 1: loop all the exisitng vtd_pasid_as instances */
> > > +    g_hash_table_foreach_remove(s->vtd_pasid_as,
> > > +                                vtd_flush_pasid, pc_info);
> > 
> > OK the series is evolving along with our discussions, and /me too on understanding
> > your series... Now I'm not very sure whether this operation is still useful...
> > 
> > The major point is you'll need to do pasid table walk for all the registered
> > devices
> > below.  So IIUC vtd_replay_guest_pasid_bindings() will be able to also detect
> > addition, removal or modification of pasid address spaces.  Am I right?
> 
> It's true if there is only assigned pasid-capable devices. If there is
> emualted pasid-capable device, it would be a problem as emualted devices
> won't register HostIOMMUContext. Somehow, the pasid cahce invalidation
> for emualted device would be missed. So I chose to make the step 1 cover
> the "real" cache invalidation(a.k.a. removal), while step 2 to cover
> addition and modification.

OK.  Btw, I think modification should still belongs to step 1 then (I
think you're doing that, though).

Thanks,

-- 
Peter Xu

