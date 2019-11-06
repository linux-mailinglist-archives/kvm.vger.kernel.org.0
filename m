Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BABF17D3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 15:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbfKFOBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 09:01:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfKFOBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 09:01:00 -0500
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B3FCC85542
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 14:00:59 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id a186so22561376qkb.18
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 06:00:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0LKmjm2kgwMLtFXnFKb46iWSmule+FGeOkfZ8vW8Tv8=;
        b=GvgyMFhp2Hfi2ASfLNWNZ4sfY7nI0SKVEoVY3/ayaOGHZU+BfzbympSaEvDu83o+uH
         hX4FGyYj82C0BMTcmZk3YszjD7e6KqSJy5dgSuSBxo4vg32Ws7N9F/q3cHjY3g8MZ59a
         aemSBLcTex6NYWHINOmS6Ue70cv+fTaICo5DmtqqHKa0lOOj6g/HDz3bmPSF8WVetStZ
         c8DSCJraYBywFB0sX9rrmoR3OYoD+fo0AFaEkG6cUKWvRXZzdPx22aK6J+qG8bi4CCmN
         xkGhuZf2Lkzcc+KB4k3cwyMQZpb6G7hhj4hhmDVKNvbS0/oF/apbOn94N6sUshS1Y4aY
         hH5w==
X-Gm-Message-State: APjAAAWQSTfbag63JCaKinxYjJGrdcP9j0eXDLgE5TZFZQBy16mbW9re
        wkGBeQiAg/+oKlAV15BZT1L46K0ZAFbUXXq11UgQwDii+nhJERVlWWGcRHl0hn9ChdDxBfQgftD
        HnY41LbaMBbrX
X-Received: by 2002:ac8:70c9:: with SMTP id g9mr2408085qtp.389.1573048859010;
        Wed, 06 Nov 2019 06:00:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqzYBwA9VHtXa0cwopfImD1a8xgyjvIhUBfTl2Jz+yDCyF5Y3ZWfBgQaIDmPXLlT1Q2nONAHyg==
X-Received: by 2002:ac8:70c9:: with SMTP id g9mr2407996qtp.389.1573048858156;
        Wed, 06 Nov 2019 06:00:58 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a137sm363522qkg.75.2019.11.06.06.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:00:57 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:00:55 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 10/22] intel_iommu: add virtual command capability
 support
Message-ID: <20191106140055.GA29717@xz-x1>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-11-git-send-email-yi.l.liu@intel.com>
 <20191101180544.GF8888@xz-x1.metropole.lan>
 <A2975661238FB949B60364EF0F2C25743A0EF337@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0EF337@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 12:40:41PM +0000, Liu, Yi L wrote:
> > 
> > Do you know what should happen on bare-metal from spec-wise that when
> > the guest e.g. writes 2 bytes to these mmio regions?
> 
> I've no idea to your question. It is not a bare-metal capability. Personally, I
> prefer to have a toggle bit to mark the full written of a cmd to VMCD_REG.
> Reason is that we have no control on guest software. It may write new cmd
> to VCMD_REG in a bad manner. e.g. write high 32 bits first and then write the
> low 32 bits. Then it will have two traps. Apparently, for the first trap, it fills
> in the VCMD_REG and no need to handle it since it is not a full written. I'm
> checking it and evaluating it. How do you think on it?

Oh I just noticed that vtd_mem_ops.min_access_size==4 now so writting
2B should never happen at least.  Then we'll bail out at
memory_region_access_valid().  Seems fine.

> 
> > 
> > > +        if (!vtd_handle_vcmd_write(s, val)) {
> > > +            vtd_set_long(s, addr, val);
> > > +        }
> > > +        break;
> > > +
> > >      default:
> > >          if (size == 4) {
> > >              vtd_set_long(s, addr, val);
> > > @@ -3617,7 +3769,8 @@ static void vtd_init(IntelIOMMUState *s)
> > >              s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
> > >          } else if (!strcmp(s->scalable_mode, "modern")) {
> > >              s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
> > > -                       | VTD_ECAP_FLTS | VTD_ECAP_PSS;
> > > +                       | VTD_ECAP_FLTS | VTD_ECAP_PSS | VTD_ECAP_VCS;
> > > +            s->vccap |= VTD_VCCAP_PAS;
> > >          }
> > >      }
> > >
> > 
> > [...]
> > 
> > > +#define VTD_VCMD_CMD_MASK           0xffUL
> > > +#define VTD_VCMD_PASID_VALUE(val)   (((val) >> 8) & 0xfffff)
> > > +
> > > +#define VTD_VCRSP_RSLT(val)         ((val) << 8)
> > > +#define VTD_VCRSP_SC(val)           (((val) & 0x3) << 1)
> > > +
> > > +#define VTD_VCMD_UNDEFINED_CMD         1ULL
> > > +#define VTD_VCMD_NO_AVAILABLE_PASID    2ULL
> > 
> > According to 10.4.44 - should this be 1?
> 
> It's 2 now per VT-d spec 3.1 (2019 June). I should have mentioned it in the cover
> letter...

Well you're right... I hope there won't be other "major" things get
changed otherwise it'll be really a pain of working on all of these
before things settle...

Thanks,

-- 
Peter Xu
