Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCC5E177D
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 12:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404288AbfJWKNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 06:13:41 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45353 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404264AbfJWKNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 06:13:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id y7so7781517edo.12
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 03:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ORDM/VOBs1fIrp01I0A5xms2tGNpKSAd1TbHc1PkN5w=;
        b=rXcf07Ef2MkSeZMGF3P4Q07eX4Y+LghQnjQZ4TE6fRY/lyPxphd/TGZkXWCyliyv9k
         JRVd5T1itlTVH6a/44ePIv+jYO7zyF7Vw8U0lWYqSfR2cMJlFLWaQZ9ubGE4RZKnWovT
         SeIcGZonw3JCCbt7SNCLdoY+2k5BwOiM9haBN0drd1VwFBQ9wwKEV44m5UEoOHRropd9
         iajVfoflOTx5L6VT46RC8Gblu4rebThCGjwYyQH8qPMXxlgGp0iPMXkOXOfswvy4CO88
         Ka9ggW3bx+36ONuvSwcGA+xqTCXQKNBGKl1zm09t/uFhLxEePbKOR457z8zA3/fkCpOy
         Ds9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ORDM/VOBs1fIrp01I0A5xms2tGNpKSAd1TbHc1PkN5w=;
        b=FKUuc/vuzc21c3fj5HsBfNYUqTMWDHz0qXM4j4hBsBSqMDDK+SzdfSdwY94gt1oGAc
         MwkD/7XjTt4zSFG34I4DRbjQ2fmOu4ck0r81LSyaTLuTSSge2X95Xt6fEeEr0dWTvw1/
         iTMbBGmx9v0aEcxMULC/U2FpP3FyEFFdfq4M+M6kVKdVXA1xcrD/ca6xwE2EO8hu+zuK
         Aci5dRcEon1wgdb+AEy+pUrBLy0ieSg3ThATGDGOxSC3JQq8osI0TF7n42Slbe33AxsA
         aVM17NilMh2FtzRb3FJGQmQ+kkunk1LwlkwuV+fl7mz58NLQy6/HnZgQpfbOa4hycvRF
         v67Q==
X-Gm-Message-State: APjAAAVOohPgUawTHGyiQuQEmN34KVOBL0ncbOffDcjgeWqBd7IjNlJt
        N41MOz9QQ85y6EErWSccPCMBEA==
X-Google-Smtp-Source: APXvYqyltJAbTQ9ow85BJkdjYC7irXmeeLrCr37rdhH0tOd5l2py+1UfitLMbDnJ4Ds+5iVUMRwsTg==
X-Received: by 2002:aa7:cc95:: with SMTP id p21mr9049005edt.189.1571825617836;
        Wed, 23 Oct 2019 03:13:37 -0700 (PDT)
Received: from netronome.com ([62.119.166.9])
        by smtp.gmail.com with ESMTPSA id ck10sm39035ejb.59.2019.10.23.03.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 03:13:37 -0700 (PDT)
Date:   Wed, 23 Oct 2019 12:13:31 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
Message-ID: <20191023101329.GE8732@netronome.com>
References: <20191016011041.3441-1-lingshan.zhu@intel.com>
 <20191016011041.3441-2-lingshan.zhu@intel.com>
 <20191016095347.5sb43knc7eq44ivo@netronome.com>
 <075be045-3a02-e7d8-672f-4a207c410ee8@intel.com>
 <20191021163139.GC4486@netronome.com>
 <15d94e61-9b3d-7854-b65e-6fea6db75450@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15d94e61-9b3d-7854-b65e-6fea6db75450@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 09:32:36AM +0800, Jason Wang wrote:
> 
> On 2019/10/22 上午12:31, Simon Horman wrote:
> > On Mon, Oct 21, 2019 at 05:55:33PM +0800, Zhu, Lingshan wrote:
> > > On 10/16/2019 5:53 PM, Simon Horman wrote:
> > > > Hi Zhu,
> > > > 
> > > > thanks for your patch.
> > > > 
> > > > On Wed, Oct 16, 2019 at 09:10:40AM +0800, Zhu Lingshan wrote:
> > ...
> > 
> > > > > +static void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
> > > > > +		       void *dst, int length)
> > > > > +{
> > > > > +	int i;
> > > > > +	u8 *p;
> > > > > +	u8 old_gen, new_gen;
> > > > > +
> > > > > +	do {
> > > > > +		old_gen = ioread8(&hw->common_cfg->config_generation);
> > > > > +
> > > > > +		p = dst;
> > > > > +		for (i = 0; i < length; i++)
> > > > > +			*p++ = ioread8((u8 *)hw->dev_cfg + offset + i);
> > > > > +
> > > > > +		new_gen = ioread8(&hw->common_cfg->config_generation);
> > > > > +	} while (old_gen != new_gen);
> > > > Would it be wise to limit the number of iterations of the loop above?
> > > Thanks but I don't quite get it. This is used to make sure the function
> > > would get the latest config.
> > I am worried about the possibility that it will loop forever.
> > Could that happen?
> > 
> > ...
> 
> 
> My understanding is that the function here is similar to virtio config
> generation [1]. So this can only happen for a buggy hardware.

Ok, so this circles back to my original question.
Should we put a bound on the number of times the loop runs
or should we accept that the kernel locks up if the HW is buggy?

> 
> Thanks
> 
> [1] https://docs.oasis-open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd01.html
> Section 2.4.1
> 
> 
> > 
> > > > > +static void io_write64_twopart(u64 val, u32 *lo, u32 *hi)
> > > > > +{
> > > > > +	iowrite32(val & ((1ULL << 32) - 1), lo);
> > > > > +	iowrite32(val >> 32, hi);
> > > > > +}
> > > > I see this macro is also in virtio_pci_modern.c
> > > > 
> > > > Assuming lo and hi aren't guaranteed to be sequential
> > > > and thus iowrite64_hi_lo() cannot be used perhaps
> > > > it would be good to add a common helper somewhere.
> > > Thanks, I will try after this IFC patchwork, I will cc you.
> > Thanks.
> > 
> > ...
> 
