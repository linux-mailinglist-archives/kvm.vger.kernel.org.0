Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEC61F67DD
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgFKMbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgFKMbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:31:10 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F79FC08C5C1
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 05:31:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r9so4812997wmh.2
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 05:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dme-org.20150623.gappssmtp.com; s=20150623;
        h=to:cc:subject:in-reply-to:references:from:date:message-id
         :mime-version;
        bh=HOVgqrNF+UZt/ZblEAeFnOGGk9HKC6a+IPi5bRclrK0=;
        b=qUn5CTYI8cZYIMeIBiuuqxWu/2eka/1oKU+kMldfJVkB0LvFxa8bmNn9Y8g76bB/9r
         0Ck4SxxFXBOu3Z13kgwq6h8tObchc8+WOoh63G+V4JZUDRoUZdC3yenvMEhNakL2+E+S
         thwYd02jYjoE7oWXGJ3rZfB7Nou0HwRuKkA1ZhqDMSVeBjri+Atq2d4DCqVN0/4XqnYs
         45e4AICWUBWbsrl3o8czMtgJKlZMzWVvEmwh+CmZ/J1Tb7/ik99iPimvsbAeJXTx/sOg
         KVucFC4QBF6jbhebJx7qcxes2gq38NawTuNI/wOX63UYbi2EmC5HvybQbqtO3DblNasB
         VHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:subject:in-reply-to:references:from:date
         :message-id:mime-version;
        bh=HOVgqrNF+UZt/ZblEAeFnOGGk9HKC6a+IPi5bRclrK0=;
        b=ejgsG7LZ/MPmVRnniUJOUWlFOB8vlYl6aS9kGG6QpCvhVERJBiU43OjOAGQ9jSg5Aq
         UrGTda6YW6N59os0aLV22yHkRxWnebM+8mXvTt1AdIMXUaDfBc4vlKTLUXjv1WkmUKeG
         h7o1YETr8FkSZ9IqkYbDqxmOwH3LgwPZHfd0gXxNnYsh2/WiHBWN1Udalfbc9v5v9+3E
         bbrgFwYC293tshwh3GVG68IA6jUskqDKrh9gXApFuwd9LTb5rh3TEi3fAh0PTRh2Lald
         e0anFjxorNUP4DI2rO47ofg9NrpzoJt5npJLYOylzYaLbfQW0opwIQ2lsQLny4hyHS+J
         nI4g==
X-Gm-Message-State: AOAM533ZUIQvI8Lga/1sGIPPPsE5fI32cnWjK3pUiYqKZs8dnIqtyN6o
        ftUEjAFGoPwd17gtLMSVIcidfg==
X-Google-Smtp-Source: ABdhPJzly/94q8CC3aGfhn5rP0EVxTOYZ3cG/SeJ/YVte9ql+owmzzWAtksVFoCrYrXOn6Kkl+Qfjg==
X-Received: by 2002:a05:600c:4401:: with SMTP id u1mr7839800wmn.36.1591878668383;
        Thu, 11 Jun 2020 05:31:08 -0700 (PDT)
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net. [2001:8b0:bb71:7140:64::1])
        by smtp.gmail.com with ESMTPSA id z12sm5268974wrg.9.2020.06.11.05.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 05:31:07 -0700 (PDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 894f5699;
        Thu, 11 Jun 2020 12:31:06 +0000 (UTC)
To:     Yan Zhao <yan.y.zhao@intel.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, shaopeng.he@intel.com,
        yi.l.liu@intel.com, xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 04/10] vfio/pci: let vfio_pci know number of
 vendor regions and vendor irqs
In-Reply-To: <20200605021542.GG12300@joy-OptiPlex-7040>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
 <20200518024944.14263-1-yan.y.zhao@intel.com>
 <20200604172515.614e9864.cohuck@redhat.com>
 <20200605021542.GG12300@joy-OptiPlex-7040>
X-HGTTG: heart-of-gold
From:   David Edmondson <dme@dme.org>
Date:   Thu, 11 Jun 2020 13:31:05 +0100
Message-ID: <m23671943a.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2020-06-04 at 22:15:42 -04, Yan Zhao wrote:

> On Thu, Jun 04, 2020 at 05:25:15PM +0200, Cornelia Huck wrote:
>> On Sun, 17 May 2020 22:49:44 -0400
>> Yan Zhao <yan.y.zhao@intel.com> wrote:
>> 
>> > This allows a simpler VFIO_DEVICE_GET_INFO ioctl in vendor driver
>> > 
>> > Cc: Kevin Tian <kevin.tian@intel.com>
>> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>> > ---
>> >  drivers/vfio/pci/vfio_pci.c         | 23 +++++++++++++++++++++--
>> >  drivers/vfio/pci/vfio_pci_private.h |  2 ++
>> >  include/linux/vfio.h                |  3 +++
>> >  3 files changed, 26 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> > index 290b7ab55ecf..30137c1c5308 100644
>> > --- a/drivers/vfio/pci/vfio_pci.c
>> > +++ b/drivers/vfio/pci/vfio_pci.c
>> > @@ -105,6 +105,24 @@ void *vfio_pci_vendor_data(void *device_data)
>> >  }
>> >  EXPORT_SYMBOL_GPL(vfio_pci_vendor_data);
>> >  
>> > +int vfio_pci_set_vendor_regions(void *device_data, int num_vendor_regions)
>> > +{
>> > +	struct vfio_pci_device *vdev = device_data;
>> > +
>> > +	vdev->num_vendor_regions = num_vendor_regions;
>> 
>> Do we need any kind of sanity check here, in case this is called with a
>> bogus value?
>>
> you are right. it at least needs to be >=0.
> maybe type of "unsigned int" is more appropriate for num_vendor_regions.
> we don't need to check its max value as QEMU would check it.

That seems like a bad precedent - the caller may not be QEMU.

dme.
-- 
I'm not the reason you're looking for redemption.
