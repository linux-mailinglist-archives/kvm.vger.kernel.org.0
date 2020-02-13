Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A41515C111
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 16:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgBMPJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 10:09:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47535 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727558AbgBMPJB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Feb 2020 10:09:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581606540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TTCs0FYlF7ncgzuKAoKWZgYBOizTPZCqyTpm/Xkwuxg=;
        b=daRJiMGcjAWLnIJhjWVdu2KkHLsn0YFsAc6kHlgQmzNDaDw1AQGGylZrfgUjqys08DN0Vl
        HD1kpVQEXDYFdOudlzarmXW5a+b9mDinRdn3YK60tCEvMGDA7neTSH7ChqdX9W3yzmDYcw
        qKHa3gcKxVqSA9N+06ier12ObSmmcY0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-JdEfkAXLMnGeRpDsR3yqLg-1; Thu, 13 Feb 2020 10:08:57 -0500
X-MC-Unique: JdEfkAXLMnGeRpDsR3yqLg-1
Received: by mail-qv1-f69.google.com with SMTP id k2so3647809qvu.22
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 07:08:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TTCs0FYlF7ncgzuKAoKWZgYBOizTPZCqyTpm/Xkwuxg=;
        b=jbROV7LqJO+khzh5r4Q3HQJ7g76pwAyNaddn26/4ze/hNPPad/MusXJy44EXZVdFDi
         T6Xzm/i/WeO6x1gPAGh7+oaileyoCF0fs7JoMPPmq5sv6PmR3t2YWSXIP5Fb3ohzIGH+
         VNPQNrCcAr2z0k85zMwbRjdZXIYgjJ+Ozi6epEiDiXltJAJ63AKY1lm/rflAp0bs3o3h
         HjkQo1I7gfKC90tExXUBERlZBkxkB8dgJ2+/fr9ujzEDv1KGePVRwJqR5z8G3YTE3owc
         J4gk9CbzeWGOvXLeeJQls3kww+Vl9ZSeQ/A8gs+y7elA5/+OE/H1wHrGRjJ45JCr921C
         tPYA==
X-Gm-Message-State: APjAAAUgOsc/WuIgeRylXGMPMAFhsB4AauupU0B0LzjDTyrWmpU7pZB7
        SoPez9Ix+U8T8eT/jdVPhMCv2xzK5L8maNmjFYuH88E5aAM2u0fjs1Tk5wzLphf6Gw5952Ya6AU
        ntucdHpeNtYpm
X-Received: by 2002:a05:620a:663:: with SMTP id a3mr16110923qkh.310.1581606537258;
        Thu, 13 Feb 2020 07:08:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUgLATtaYNS3Kg0ZyRQURNj5rc+bKl6duQGjBd/h/0kPnf2VPQA4IkJPSzdtqTGd9fGBjJUw==
X-Received: by 2002:a05:620a:663:: with SMTP id a3mr16110888qkh.310.1581606536927;
        Thu, 13 Feb 2020 07:08:56 -0800 (PST)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id l19sm1441196qkl.3.2020.02.13.07.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:08:56 -0800 (PST)
Date:   Thu, 13 Feb 2020 10:08:53 -0500
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
Subject: Re: [RFC v3 14/25] intel_iommu: add virtual command capability
 support
Message-ID: <20200213150853.GB1103216@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-15-git-send-email-yi.l.liu@intel.com>
 <20200211215630.GN984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BBBF4@SHSMSX104.ccr.corp.intel.com>
 <20200213143110.GA1103216@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200213143110.GA1103216@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 09:31:10AM -0500, Peter Xu wrote:

[...]

> > > Apart of this: also I just noticed (when reading the latter part of
> > > the series) that the time that a pasid table walk can consume will
> > > depend on this value too.  I'd suggest to make this as small as we
> > > can, as long as it satisfies the usage.  We can even bump it in the
> > > future.
> > 
> > I see. This looks to be an optimization. right? Instead of modify the
> > value of this macro,  I think we can do this optimization by tracking
> > the allocated PASIDs in QEMU. Thus, the pasid table walk  would be more
> > efficient and also no dependency on the VTD_MAX_HPASID. Does it make
> > sense to you? :-)
> 
> Yeah sounds good. :)

Just to make sure it's safe even for when the global allocation is not
happening (full emulation devices?  Do they need the PASID table walk
too?).  Anyway, be careful to not miss some valid PASID entries, or we
can still use the MIN(PASID_MAX, CONTEXT_ENTRY_SIZE) to be safe as a
first version.  Thanks,

-- 
Peter Xu

