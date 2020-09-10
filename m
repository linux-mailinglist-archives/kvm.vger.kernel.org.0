Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20DE265431
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 23:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgIJVnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 17:43:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31817 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730383AbgIJMug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 08:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599742215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZXGj6k8riNs9Vj4UP7tEqOTrYQ5CAKfprkP6QZPSeR4=;
        b=c3mJVdEgnbMVsq7qaHoKPZ8fJGUJiqOTQ9renp8VAlCraP4vzN9NfUH4NHckUuRrpK0ML2
        p2GfZSOSvX8LjHZBtlkLvNjg3EeQRPNQEWSXvYQ/MxDwMc7d/vLwhnT8rnlwJP66hrpBN4
        Qxb7jhvuDmg9/a2JF5gZmI3tX/4nWO4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-U04ae9iWPeWU-uZ_AL94hw-1; Thu, 10 Sep 2020 08:50:14 -0400
X-MC-Unique: U04ae9iWPeWU-uZ_AL94hw-1
Received: by mail-wm1-f70.google.com with SMTP id b73so2098314wmb.0
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 05:50:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXGj6k8riNs9Vj4UP7tEqOTrYQ5CAKfprkP6QZPSeR4=;
        b=YHL5OQCmtI9QwpcHf46+p2aqgFLQh4zbPiwZi8s7YSGOf6CapBIWB1ke6KDS0EUPX5
         IlwGxiQb4Z6sLes4p7zChtFdcAGWAX99MwmhLgeeFZonp3camdIlFE0vicpvTbZdtmcr
         1H9CnOZyHARNQB75oA3q5x4TB7MVERinhVv1O2+cHqlDhN/nfqMXGhJiPTAHxnmQVA9x
         gRS3aB4yQcfjbFGvbsrU6v7OzPFXyF0VrJn114owNYaBOdRHvqWWF/6UMRNYNn+XSQv6
         MkG9RmyzYh5CvIlNsyFBByz+Q/VCFJmGvlSDdpUc/87Szc20RIKCUaKe3omgNvqx5LXx
         RkWQ==
X-Gm-Message-State: AOAM5330XvpUv/DGW2D3ZMLOQEmfk9Ja17tycjqexlV883U2jD8+NF9P
        juX1EEdmKCXW0/K11BIs++zARz5Wce5jXM3tqk3TaD+GM+29K2XI/Jsfgm1wQbFnBO/9f5FpSkO
        eEEUaACz6zxS+
X-Received: by 2002:a1c:c910:: with SMTP id f16mr8297049wmb.82.1599742213070;
        Thu, 10 Sep 2020 05:50:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyXdpf4+Lc20wLIFYpjKwJB8sAx70dr7armMg6ykw8vcU9X+1byflhkDA11+n1XlghezjXOQ==
X-Received: by 2002:a1c:c910:: with SMTP id f16mr8297020wmb.82.1599742212834;
        Thu, 10 Sep 2020 05:50:12 -0700 (PDT)
Received: from pop-os ([109.79.57.111])
        by smtp.gmail.com with ESMTPSA id v7sm3484718wmj.28.2020.09.10.05.50.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Sep 2020 05:50:12 -0700 (PDT)
Message-ID: <7cebcb6c8d1a1452b43e8358ee6ee18a150a0238.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Daniel =?ISO-8859-1?Q?P=2EBerrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn, intel-gvt-dev@lists.freedesktop.org,
        eskultet@redhat.com, Jiri Pirko <jiri@mellanox.com>,
        dinechin@redhat.com, devel@ovirt.org
Date:   Thu, 10 Sep 2020 13:50:11 +0100
In-Reply-To: <20200910143822.2071eca4.cohuck@redhat.com>
References: <20200818113652.5d81a392.cohuck@redhat.com>
         <20200820003922.GE21172@joy-OptiPlex-7040>
         <20200819212234.223667b3@x1.home>
         <20200820031621.GA24997@joy-OptiPlex-7040>
         <20200825163925.1c19b0f0.cohuck@redhat.com>
         <20200826064117.GA22243@joy-OptiPlex-7040>
         <20200828154741.30cfc1a3.cohuck@redhat.com>
         <8f5345be73ebf4f8f7f51d6cdc9c2a0d8e0aa45e.camel@redhat.com>
         <20200831044344.GB13784@joy-OptiPlex-7040>
         <20200908164130.2fe0d106.cohuck@redhat.com>
         <20200909021308.GA1277@joy-OptiPlex-7040>
         <20200910143822.2071eca4.cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-09-10 at 14:38 +0200, Cornelia Huck wrote:
> On Wed, 9 Sep 2020 10:13:09 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > > > still, I'd like to put it more explicitly to make ensure it's not missed:
> > > > the reason we want to specify compatible_type as a trait and check
> > > > whether target compatible_type is the superset of source
> > > > compatible_type is for the consideration of backward compatibility.
> > > > e.g.
> > > > an old generation device may have a mdev type xxx-v4-yyy, while a newer
> > > > generation  device may be of mdev type xxx-v5-yyy.
> > > > with the compatible_type traits, the old generation device is still
> > > > able to be regarded as compatible to newer generation device even their
> > > > mdev types are not equal.  
> > > 
> > > If you want to support migration from v4 to v5, can't the (presumably
> > > newer) driver that supports v5 simply register the v4 type as well, so
> > > that the mdev can be created as v4? (Just like QEMU versioned machine
> > > types work.)  
> > 
> > yes, it should work in some conditions.
> > but it may not be that good in some cases when v5 and v4 in the name string
> > of mdev type identify hardware generation (e.g. v4 for gen8, and v5 for
> > gen9)
> > 
> > e.g.
> > (1). when src mdev type is v4 and target mdev type is v5 as
> > software does not support it initially, and v4 and v5 identify hardware
> > differences.
> 
> My first hunch here is: Don't introduce types that may be compatible
> later. Either make them compatible, or make them distinct by design,
> and possibly add a different, compatible type later.
> 
> > then after software upgrade, v5 is now compatible to v4, should the
> > software now downgrade mdev type from v5 to v4?
> > not sure if moving hardware generation info into a separate attribute
> > from mdev type name is better. e.g. remove v4, v5 in mdev type, while use
> > compatible_pci_ids to identify compatibility.
> 
> If the generations are compatible, don't mention it in the mdev type.
> If they aren't, use distinct types, so that management software doesn't
> have to guess. At least that would be my naive approach here.
yep that is what i would prefer to see too.
> 
> > 
> > (2) name string of mdev type is composed by "driver_name + type_name".
> > in some devices, e.g. qat, different generations of devices are binding to
> > drivers of different names, e.g. "qat-v4", "qat-v5".
> > then though type_name is equal, mdev type is not equal. e.g.
> > "qat-v4-type1", "qat-v5-type1".
> 
> I guess that shows a shortcoming of that "driver_name + type_name"
> approach? Or maybe I'm just confused.
yes i really dont like haveing the version in the mdev-type name 
i would stongly perfger just qat-type-1 wehere qat is just there as a way of namespacing.
although symmetric-cryto, asymmetric-cryto and compression woudl be a better name then type-1, type-2, type-3 if
that is what they would end up mapping too. e.g. qat-compression or qat-aes is a much better name then type-1
higher layers of software are unlikely to parse the mdev names but as a human looking at them its much eaiser to
understand if the names are meaningful. the qat prefix i think is important however to make sure that your mdev-types
dont colide with other vendeors mdev types. so i woudl encurage all vendors to prefix there mdev types with etiher the
device name or the vendor.
> 

