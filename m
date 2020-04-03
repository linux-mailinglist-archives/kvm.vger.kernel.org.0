Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A5319D6D9
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgDCMkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 08:40:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33308 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgDCMkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 08:40:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so8396706wrd.0
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 05:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4UoTuchVPcQbessFRne4dgixRRmQ3IULpwTbXSdSKjI=;
        b=ptml5nxSRSHJqKFQi24/vBmgB1JRiVOfz6FKiC4gpmUxkWrdbIyK3uvOqzLg5W8uwh
         yk1CyLp9obg1oU+Hr7N6V0Qazv6OJMEPqjaiFOV+KsBE1iJSqdyMfGbI2Rl+ueZPP0RD
         q7v1i7bZgnoLW05nP9LCgF1a+3JHpfALZxf0xfNQn1SzUNgm31+sKib0d1IHusr6S6GN
         S3M6fCUQu+ra4TFkCP3PW0+YRlA/SrhwExhXWORiYZ0CKq/Y1szY6G0V/0lW1/+ql3PT
         vjcqmIc/VrpfqtHRjppi/1GU3b/+N4+HcwayMIoWnVrI9mhF+z3SZAPdivgHOcuQhmg3
         M9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4UoTuchVPcQbessFRne4dgixRRmQ3IULpwTbXSdSKjI=;
        b=ijb37C0CdlgSE31xmeL+ik6X8K1R2vDpeVYgltdVWbFD2bi9rj9hUG8is3Xja4Ei+4
         mMS7wxmS5XFd1Apvne4TGAjvkGk8AIIroKo4NY4hmwxc/lhpE/3wmFUkukTVXxPWYvWY
         1kSiYqJaJnC5vmwWFOeAQe4+jBA32npoM528jsHHqUgy7MfqS5b2+fqkyx55O0MuKTF3
         RsLa8l8Kdr1ARGBW7tFoBKErYnk4b+FCa8kT41Mkyot6mss73jAbw73PCJ/mgqcn1xXu
         3qYAsq6/3h37ejoOET1MrAAluDIQBTZc2D4srB4YDbVpJh4kAWnHEJuqgLKNadqvhzsf
         EN+w==
X-Gm-Message-State: AGi0PuYfBqnNnkKklnBEbRxyDoYvHBQ4/2I82TXgu4o03VrL72lxFwQ1
        Jm0udtL8fKvshSRlh2YAYGtSOQ==
X-Google-Smtp-Source: APiQypJxxsi5NWBorLzelVFk5jRcSOCtWuTo4mTy/DlCSSr3s65XnB3k77Ei4DFGaxZmRYKmvHULRg==
X-Received: by 2002:a5d:44c3:: with SMTP id z3mr8800515wrr.284.1585917599670;
        Fri, 03 Apr 2020 05:39:59 -0700 (PDT)
Received: from myrica ([2001:171b:226b:54a0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id 91sm5994296wrf.79.2020.04.03.05.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:39:59 -0700 (PDT)
Date:   Fri, 3 Apr 2020 14:39:51 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20200403123951.GA1410438@myrica>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
 <20200402135240.GE1176452@myrica>
 <A2975661238FB949B60364EF0F2C25743A2209E3@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A2209E3@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 03, 2020 at 11:56:09AM +0000, Liu, Yi L wrote:
> > >  /**
> > > + * VFIO_MM objects - create, release, get, put, search
> > > + * Caller of the function should have held vfio.vfio_mm_lock.
> > > + */
> > > +static struct vfio_mm *vfio_create_mm(struct mm_struct *mm)
> > > +{
> > > +	struct vfio_mm *vmm;
> > > +	struct vfio_mm_token *token;
> > > +	int ret = 0;
> > > +
> > > +	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
> > > +	if (!vmm)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	/* Per mm IOASID set used for quota control and group operations */
> > > +	ret = ioasid_alloc_set((struct ioasid_set *) mm,
> > 
> > Hmm, either we need to change the token of ioasid_alloc_set() to "void *",
> > or pass an actual ioasid_set struct, but this cast doesn't look good :)
> >
> > As I commented on the IOASID series, I think we could embed a struct
> > ioasid_set into vfio_mm, pass that struct to all other ioasid_* functions,
> > and get rid of ioasid_sid.
> 
> I think change to "void *" is better as we needs the token to ensure all
> threads within a single VM share the same ioasid_set.

Don't they share the same vfio_mm?

Thanks,
Jean
> 
> > > +			       VFIO_DEFAULT_PASID_QUOTA, &vmm->ioasid_sid);
> > > +	if (ret) {
> > > +		kfree(vmm);
> > > +		return ERR_PTR(ret);
> > > +	}
> > > +
> > > +	kref_init(&vmm->kref);
> > > +	token = &vmm->token;
> > > +	token->val = mm;
> > 
> > Why the intermediate token struct?  Could we just store the mm_struct
> > pointer within vfio_mm?
> 
> Hmm, here we only want to use the pointer as a token, instead of using
> the structure behind the pointer. If store the mm_struct directly, may
> leave a space to further use its content, this is not good.
> 
> Regards,
> Yi Liu
> 
