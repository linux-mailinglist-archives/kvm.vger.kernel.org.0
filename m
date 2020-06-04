Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAA01EE249
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 12:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgFDKRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 06:17:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31345 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726735AbgFDKRm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 06:17:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591265860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2AztqKvzgy7aFiXghmWU8gdfGqSDj8pW4Rz5e+UFG6I=;
        b=ZHnhhjKCJ4kMWcm3yu2QJJ1MsUEzKnZmqaJULruTnWMxTeVcDJNncsaHfcfjUrqVKeY4E9
        tgR74dNADfu9dzQzRS+irIONTE12pjpNeCxIbUM/yuA927uF7xbK/EPTDdfiy/dguQwArF
        cWZ6ZtZjEZB0R1eOPcEjqj+ROZ04yqA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-PnlzWhaxMmyYmdM_3KX33Q-1; Thu, 04 Jun 2020 06:17:38 -0400
X-MC-Unique: PnlzWhaxMmyYmdM_3KX33Q-1
Received: by mail-wm1-f72.google.com with SMTP id j128so1817489wmj.6
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 03:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2AztqKvzgy7aFiXghmWU8gdfGqSDj8pW4Rz5e+UFG6I=;
        b=fxxcsbI6PnJSleBCd9fpfP1GEuqoG2F/CGoLSBGPTWs9m5P7qdTV/qNuFzbXiDyg1S
         KOO7cteCWJ/KAMZ9Pu0tWowaZCFsfjuHIMn3gChQTJEFPyMxg0x58ckmxwmeDI2PlL0B
         Ta+8u56t5a9VSOFIbaRF0BHRRa+mKv57ecYZhzmzcxdGn9zmjxqedKq8jH5b0DS+rSSX
         rodYvv0KnakuzoDvNT6EJtgVX+xc7ppO2CfA6awFZUKHFS/c5SfwobYiT2T9qgkNN4zs
         bMRsa4sOfnRaR0YUYmSidjAqOT6kaKUBTegfdpzhOzPMkcmggrqTRnlrebs0JeqiJKWB
         pKJg==
X-Gm-Message-State: AOAM530rPgCYh3rrgfNrJn84lI6hvR6a4GEmYSf8zebufoUacaK9ZENp
        tE6WkQHAsVEYmTDkIdB2rv+2vCe9ohcGSZWR4jt+StdaTx15upsOl3Iqm6p5y2husxAOoite50S
        fZVZPS6LVibln
X-Received: by 2002:a1c:a3c1:: with SMTP id m184mr3568708wme.91.1591265857924;
        Thu, 04 Jun 2020 03:17:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJO213xAQF9M1ot7ZZba5ozFLdbD1Lq18fiEmWZFnyrw/++lJWGikXa82it32Q87Xgmp4QWw==
X-Received: by 2002:a1c:a3c1:: with SMTP id m184mr3568671wme.91.1591265857625;
        Thu, 04 Jun 2020 03:17:37 -0700 (PDT)
Received: from redhat.com ([2a00:a040:185:f65:9a3b:8fff:fed3:ad8d])
        by smtp.gmail.com with ESMTPSA id s8sm7754324wrg.50.2020.06.04.03.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 03:17:37 -0700 (PDT)
Date:   Thu, 4 Jun 2020 06:17:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 07/13] vhost: format-independent API for used buffers
Message-ID: <20200604060732-mutt-send-email-mst@kernel.org>
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-8-mst@redhat.com>
 <6d98f2cc-2084-cde0-c938-4ca01692adf9@redhat.com>
 <20200604050135-mutt-send-email-mst@kernel.org>
 <b39e6fb8-a59a-2b3f-a1eb-1ccea2fe1b86@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b39e6fb8-a59a-2b3f-a1eb-1ccea2fe1b86@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 05:18:00PM +0800, Jason Wang wrote:
> 
> On 2020/6/4 下午5:03, Michael S. Tsirkin wrote:
> > > >    static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
> > > >    {
> > > >    	__u16 old, new;
> > > > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > > > index a67bda9792ec..6c10e99ff334 100644
> > > > --- a/drivers/vhost/vhost.h
> > > > +++ b/drivers/vhost/vhost.h
> > > > @@ -67,6 +67,13 @@ struct vhost_desc {
> > > >    	u16 id;
> > > >    };
> > > > +struct vhost_buf {
> > > > +	u32 out_len;
> > > > +	u32 in_len;
> > > > +	u16 descs;
> > > > +	u16 id;
> > > > +};
> > > So it looks to me the struct vhost_buf can work for both split ring and
> > > packed ring.
> > > 
> > > If this is true, we'd better make struct vhost_desc work for both.
> > > 
> > > Thanks
> > Both vhost_desc and vhost_buf can work for split and packed.
> > 
> > Do you mean we should add packed ring support based on this?
> > For sure, this is one of the motivators for the patchset.
> > 
> 
> Somehow. But the reason I ask is that I see "split" suffix is used in patch
> 1 as:
> 
> peek_split_desc()
> pop_split_desc()
> push_split_desc()
> 
> But that suffix is not used for the new used ring API invented in this
> patch.
> 
> Thanks
> 

And that is intentional: split is *not* part of API. The whole idea is
that ring APIs are format agnostic using "buffer" terminology from spec.
The split things are all static within vhost.c

OK so where I had to add a bunch of new format specific code, that was
tagged as "split" to make it easier to spot that they only support a
specific format.  At the same time, I did not rename existing code
adding "split" in the name. I agree it's a useful additional step for
packed ring format support, and it's fairly easy. I just didn't want
to do it automatically.



-- 
MST

