Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F1119DB4D
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404337AbgDCQTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 12:19:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40982 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403834AbgDCQTl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Apr 2020 12:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585930779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jC5f8fZGiX7uKor8bbyTsCc+YaC+MPnESGHQw8UFRR4=;
        b=Gf4Vn9EHJbTs+BRMg74Fhw3IYVIcwQZ0myaDiOPRCsZgT6ypziMzudA6diLoqncdPVtZIq
        Pr3fc6pkiLeHHZwows4vkwdm+BH/OLhqIjl4bHdBHmZLF01CFWVbu+Xwoi6UZjY1FqmmZz
        CS64/DFOXce7ceyIxoQICtSZ0plhEdo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-foK-fHGuNveUUDFRrjxrTA-1; Fri, 03 Apr 2020 12:19:37 -0400
X-MC-Unique: foK-fHGuNveUUDFRrjxrTA-1
Received: by mail-wr1-f72.google.com with SMTP id o18so3340894wrx.9
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 09:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jC5f8fZGiX7uKor8bbyTsCc+YaC+MPnESGHQw8UFRR4=;
        b=LeMxVxbyfZFRAtiUvzOcMuq/FKN0OBTSSz8YYAKIar38dCLQGqON64u5XtLDx+Nmx1
         r0GKySVLsXFlzSv5SoGdYXX6jX3KKVEl3/srtALtp3QkEfhC7BzvKr/ov/xpoKcFeoOz
         ewyhlHyIruFGjbKaowl+0xrFL46cJipR3IvrTwczN2vq/fIS0iAUptLOWsDq4JlLe6aa
         v3dM7YDaPvPph5aNidfsLB4R5bcYzC5lZID4l71WWQtTp6ZSIO3PR816MTF2SyG2Gtld
         mha/uqaiEl2rfrqWggBYcCm13d8VlD0QGVuJaMb4bNrdBdRUQj/jWm0mNL2lEnAhFPl+
         nc6g==
X-Gm-Message-State: AGi0PuY1XR452U7SV/BVt+YwYxb3dhbCfCcr9VpaWp6tu9mgmJql6mg9
        /Rs6Dzq4X36g00Wnbu3H9jYwpU/325NSAYDJZQPbgLM3+qcP3LIEgPREtjZNJ/OnTE2ROelYadt
        /R0fymspAfpmR
X-Received: by 2002:a1c:5410:: with SMTP id i16mr9509900wmb.150.1585930776479;
        Fri, 03 Apr 2020 09:19:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypLY+zT3xRq5nEtQagJKJDJGIGotV34rqRYEb9vMb//qbdDy8BDqxKwC2pquDy6yEduGRb4pJA==
X-Received: by 2002:a1c:5410:: with SMTP id i16mr9509883wmb.150.1585930776266;
        Fri, 03 Apr 2020 09:19:36 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::3])
        by smtp.gmail.com with ESMTPSA id 127sm12731831wmd.38.2020.04.03.09.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:19:35 -0700 (PDT)
Date:   Fri, 3 Apr 2020 12:19:31 -0400
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
Message-ID: <20200403161931.GO103677@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-14-git-send-email-yi.l.liu@intel.com>
 <20200402000225.GC7174@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A21EAAD@SHSMSX104.ccr.corp.intel.com>
 <20200402134436.GI7174@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A220DE7@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A220DE7@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 03, 2020 at 03:05:57PM +0000, Liu, Yi L wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Thursday, April 2, 2020 9:45 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v2 13/22] intel_iommu: add PASID cache management
> > infrastructure
> > 
> > On Thu, Apr 02, 2020 at 06:46:11AM +0000, Liu, Yi L wrote:
> > 
> > [...]
> > 
> > > > > +/**
> > > > > + * This function replay the guest pasid bindings to hots by
> > > > > + * walking the guest PASID table. This ensures host will have
> > > > > + * latest guest pasid bindings. Caller should hold iommu_lock.
> > > > > + */
> > > > > +static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
> > > > > +                                            VTDPASIDCacheInfo
> > > > > +*pc_info) {
> > > > > +    VTDHostIOMMUContext *vtd_dev_icx;
> > > > > +    int start = 0, end = VTD_HPASID_MAX;
> > > > > +    vtd_pasid_table_walk_info walk_info = {.flags = 0};
> > > >
> > > > So vtd_pasid_table_walk_info is still used.  I thought we had
> > > > reached a consensus that this can be dropped?
> > >
> > > yeah, I did have considered your suggestion and plan to do it. But
> > > when I started coding, it looks a little bit weird to me:
> > > For one, there is an input VTDPASIDCacheInfo in this function. It may
> > > be nature to think about passing the parameter to further calling
> > > (vtd_replay_pasid_bind_for_dev()). But, we can't do that. The
> > > vtd_bus/devfn fields should be filled when looping the assigned
> > > devices, not the one passed by vtd_replay_guest_pasid_bindings() caller.
> > 
> > Hacky way is we can directly modify VTDPASIDCacheInfo* with bus/devfn for the
> > loop.  Otherwise we can duplicate the object when looping, so that we can avoid
> > introducing a new struct which seems to contain mostly the same information.
> 
> I see. Please see below reply.
> 
> > > For two, reusing the VTDPASIDCacheInfo for passing walk info may
> > > require the final user do the same thing as what the
> > > vtd_replay_guest_pasid_bindings() has done here.
> > 
> > I don't see it happen, could you explain?
> 
> my concern is around flags field in VTDPASIDCacheInfo. The flags not
> only indicates the invalidation granularity, but also indicates the
> field presence. e.g. VTD_PASID_CACHE_DEVSI indicates the vtd_bus/devfn
> fields are valid. If reuse it to pass walk info to vtd_sm_pasid_table_walk_one,
> it would be meaningless as vtd_bus/devfn fields are always valid. But
> I'm fine to reuse it's more prefered. Instead of modifying the vtd_bus/devn
> in VTDPASIDCacheInfo*, I'd rather to define another VTDPASIDCacheInfo variable
> and pass it to vtd_sm_pasid_table_walk_one. This may not affect the future
> caller of vtd_replay_guest_pasid_bindings() as vtd_bus/devfn field are not
> designed to bring something back to caller.

Yeah, let's give it a shot.  I know it's not ideal, but IMHO it's
still better than defining the page_walk struct and that might confuse
readers on what's the difference between the two.  When duplicating
the object, we can add some comment explaining this.

Thanks,

-- 
Peter Xu

