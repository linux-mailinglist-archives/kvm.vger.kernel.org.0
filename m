Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C8A19142C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgCXPY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:24:26 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:60924 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727483AbgCXPY0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 11:24:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585063465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IdhP0Azyb9N8XwjCYSgl0InCICLcNKUv9pzwyL2JkMM=;
        b=ZXCKlcvVDCY2iMy0EjOhOpd3IDvUBoy6a+iPMbhlfPKVn1y2bl4UXTAwuq3umaW3uUxpof
        EJLuhVsKn52yZs+Qb+Heu+ucAg7fnvmbv+OR45I0p4ZRVJsun9QBLrMbIuy2OPD8LoRYmH
        kvGmFL26qgavKFWNbl+BMch56LANRE8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-dv-wFm8oPTWenVZrWsV7Nw-1; Tue, 24 Mar 2020 11:24:23 -0400
X-MC-Unique: dv-wFm8oPTWenVZrWsV7Nw-1
Received: by mail-wm1-f69.google.com with SMTP id n188so1346512wmf.0
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 08:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IdhP0Azyb9N8XwjCYSgl0InCICLcNKUv9pzwyL2JkMM=;
        b=HZSJ+skYbZQJjKyRLE0kbVxUuFJGzM/YwyDK9/pJZ7/vb0KOr9FR8nWhSKEYAwSIZq
         y4RoLjCtrkCjHueRRhMADeNpPhF1uhIt1PjFnQTSs4m+WEcwG7XvzAUtTNns324JtlPj
         ExJdXXtxCZSQRckT0X0Mpwt8RWQbPPBJDb+JVb+MT3imOtDEJBhJgLjJ3+utgRCqjcKD
         2PzPSmBTZZuUdmbFG3ylxtDAA2UNhUlOo3C4ljOzb+iD0+VSXKyfraxea+VcwC7vM6Mk
         /DTVLFhP6QRTeUNBQZt+g01DqynUSchkQSWRZDbpdkuoahGs4qRFo4MEDaZnAGvVGRKm
         1N3g==
X-Gm-Message-State: ANhLgQ2rptetMj9KyrACN+Rq3NNlk43tSFWMK4s8WXYO+BPZbtZexIyP
        P9qBsmPEZFBUBjUDCST3Ju/WSxCz7MpTtCi7gxjtGu5jooHmBASm0pHP5YW3YAJVCqH+Mr/sWAk
        GZxeKxQDDDtuK
X-Received: by 2002:a05:6000:105:: with SMTP id o5mr13814776wrx.395.1585063462186;
        Tue, 24 Mar 2020 08:24:22 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtrl7VlsbssZAM5lvFzxwgBBMjHUhBO9PROYm8tMsljhkM0pNjMbfq7RE0Th1jENibR1JW2HA==
X-Received: by 2002:a05:6000:105:: with SMTP id o5mr13814746wrx.395.1585063461926;
        Tue, 24 Mar 2020 08:24:21 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id s7sm28279753wri.61.2020.03.24.08.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 08:24:21 -0700 (PDT)
Date:   Tue, 24 Mar 2020 11:24:16 -0400
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
Subject: Re: [PATCH v1 07/22] intel_iommu: add set/unset_iommu_context
 callback
Message-ID: <20200324152416.GV127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-8-git-send-email-yi.l.liu@intel.com>
 <20200323212911.GQ127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A20041A@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A20041A@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 11:15:24AM +0000, Liu, Yi L wrote:

[...]

> > >  struct VTDIOTLBEntry {
> > > @@ -271,6 +282,8 @@ struct IntelIOMMUState {
> > >      /*
> > >       * Protects IOMMU states in general.  Currently it protects the
> > >       * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace.
> > > +     * Protect the update/usage of HostIOMMUContext pointer cached in
> > > +     * VTDBus->dev_icx array as array elements may be updated by hotplug
> > 
> > I think the context update does not need to be updated, because they
> > should always be with the BQL, right?
> 
> Hmmmm, maybe I used bad description. My purpose is to protect the stored
> HostIOMMUContext pointer in vIOMMU. With pci_device_set/unset_iommu_context,
> vIOMMU have a copy of HostIOMMUContext. If VFIO container is released
> (e.g. hotpulg out device), HostIOMMUContext will alos be released. This
> will trigger the pci_device_unset_iommu_context() to clean the copy. To
> avoid using a staled HostIOMMUContext in vIOMMU, vIOMMU should have a
> lock to block the pci_device_unset_iommu_context() calling until other
> threads finished their HostIOMMUContext usage. Do you want a description
> update here or other preference?

Yeah, but hot plug/unplug will still take the BQL?

Ah btw I think it's also OK to take the lock if you want or not sure
about whether we'll always take the BQL in these paths.  But if so,
instead of adding another "Protect the ..." sentence to the comment,
would you mind list out what the lock is protecting?

  /*
   * iommu_lock protects:
   * - per-IOMMU IOTLB caches
   * - context entry caches
   * - ...
   */

Or anything better than that.  Thanks,

-- 
Peter Xu

