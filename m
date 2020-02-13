Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978E915C125
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 16:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgBMPOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 10:14:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27313 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgBMPOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 10:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581606862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D7J324WQAoq2u/kCpVQoNxxqWQHNOPZCO9rtsI+SE2g=;
        b=OchlOT2Kgqo5S2jBVVTgRUx3XnEKs+S8k49kqHpGIhwpNWJt43uoTPFpVd4n+U8qCh/iPP
        7JspLohNCJURTpzJ+72/bh+mAqr8Ktw24LUbm+KZTkcNMep6/arXTstRvqvnrLleJiyF4J
        LLsK1Ynus9P5S9jX6KAlB01IsgoYDus=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-ntE5VmTxOcuscH20aLWHUg-1; Thu, 13 Feb 2020 10:14:21 -0500
X-MC-Unique: ntE5VmTxOcuscH20aLWHUg-1
Received: by mail-qv1-f70.google.com with SMTP id z39so3698564qve.5
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 07:14:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=D7J324WQAoq2u/kCpVQoNxxqWQHNOPZCO9rtsI+SE2g=;
        b=oNCrIFvDw7thagIRjjPFvQ0i6ypw3uUH3d4tbLAO425aVSoYfu9QvdQY+sH3Y+SIiZ
         COiBsMc6hUeBcsUKCNLwXt3tAGPrHgR6XxlrAZC0oFNz7IMIz84CzTeAgdgyC/Ph1RMO
         +9EErKhhGT6dyaZ5/rmk6BH5nRVc8qHrZOvnGz+aN5NKhCDZahN/kWAly/ToTcAbeHaQ
         AcOWl2cmEfjCDh6+Mi5HcBlkuSBBqGplV7kKS+Ec55t2HMeJdXSr5Lxhn1rVAWI3I16K
         kPwzUfylOQ8rJLptEWHfW3PajGITA301qVMQZWowHpgK2tiYlRwx82MY16nGOPxVBEp1
         C52g==
X-Gm-Message-State: APjAAAVS/o8/LbA2WVN8u2aZrT7f3bkdo+CMhnkrEttE1YNbYaBJpJZL
        PlBnzzO5TXj/jtgCnEB+/tN7INflEobLBWJCd9GwCj37xrfKKZcpvrNrHfAi0IsZAFZgwtffS9x
        Xj8YFTN2qWLPn
X-Received: by 2002:ac8:3fd7:: with SMTP id v23mr11839174qtk.293.1581606858701;
        Thu, 13 Feb 2020 07:14:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqz/olUw67aKcDa7V3uIGbnjWmagwwd8gdJGvG4T5y4R5j6P9/7zwS0mga+7AjKw14eAlN5l8Q==
X-Received: by 2002:ac8:3fd7:: with SMTP id v23mr11839146qtk.293.1581606858479;
        Thu, 13 Feb 2020 07:14:18 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id 73sm1605499qtg.40.2020.02.13.07.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:14:17 -0800 (PST)
Date:   Thu, 13 Feb 2020 10:14:15 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v3 16/25] intel_iommu: add PASID cache management
 infrastructure
Message-ID: <20200213151415.GC1103216@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-17-git-send-email-yi.l.liu@intel.com>
 <20200211233548.GO984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BA669@SHSMSX104.ccr.corp.intel.com>
 <20200212152629.GA1083891@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BBCA9@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1BBCA9@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 02:59:37AM +0000, Liu, Yi L wrote:
> > - Remove the vtd_pasid_as check right below because it's not needed.
> > 
> > >
> > >
> > > > > +        if (vtd_pasid_as &&
> >                    ^^^^^^^^^^^^
> 
> yes, it is. In current series vtd_add_find_pasid_as() doesn’t check the
> result of vtd_pasid_as mem allocation, so no need to check vtd_pasid_as
> here either. However, it might be better to check the allocation result
> or it will result in issue if allocation failed. What's your preference
> here?

That should not be needed, because IIRC g_malloc0() will directly
coredump if allocation fails.  Even if not, it'll coredump in
vtd_add_find_pasid_as() soon when accessing the NULL pointer.

-- 
Peter Xu

