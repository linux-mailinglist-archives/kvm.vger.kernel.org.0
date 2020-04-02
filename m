Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE98A19C894
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388164AbgDBSNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:13:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43800 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727412AbgDBSNH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 14:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585851187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/w1XPcFrLz6tQEiDvBsmFImZ8MWG7D8gxR/TGmyIOfc=;
        b=HDUU6nkNeP45JJLvxLi2tB8y8UbK2rIC63TCQpQeLIBJQOHBm90TI6tH75km1OXqLcZcqc
        Ko3B4kVfZidQmZ179RtEWuoBRgPkCHcy4JjTbt7KzQ2QlHeJno7e/x78qhy8T1caw6z8wW
        Pgg72O9jW7ExFtavNZcs5evsMSG32yI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-EMLM6qtHMdmsOWIyCJX6Yw-1; Thu, 02 Apr 2020 14:13:03 -0400
X-MC-Unique: EMLM6qtHMdmsOWIyCJX6Yw-1
Received: by mail-wr1-f70.google.com with SMTP id w12so1807656wrl.23
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 11:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/w1XPcFrLz6tQEiDvBsmFImZ8MWG7D8gxR/TGmyIOfc=;
        b=FJrhd2lDftGZXqCXu7aCe3nQiiaC82F7gtlLrngBmwB7FCjIESbCkKP78/c8EgSCWT
         xP4eVXhnk1yYNJsvmwu1zYgDJfYDTcxusWj+5xZ+5ACrmMSaKHaLOLkpBziTG6yBtpw2
         yzd2zZuCPei/wjznL1zNDCzG9BxcnJYyK2ACMQDAAJUb13z2xOl0+YgfyMf0F6kCQTrf
         ztsMspfi+cd+jwzLyQxTfEjRBxSBOJEkTIECoFLBU3MJ2EVE0HnsJKC5MhciSJtwgtnp
         Feo7Uf6zqrN+VDpDulM0SYf1nxf0iFPkN6OZecWSwCwWl7RADWiqtWv/bWzquSDxA0gn
         uKRg==
X-Gm-Message-State: AGi0PuYsGNu9yCOBfE0IMG97Vz2fEQC+0B03IT9aQW5joaywaAhOvnCz
        Qeg3p7nwdEzEycurppM2dC0ynW7kn6ys5sBnByORH0Go8/SwuuDFCIeNXPlMfZcqu8UEKa4TTCv
        WEzJCKg0wiA8R
X-Received: by 2002:adf:82a6:: with SMTP id 35mr4724819wrc.307.1585851182461;
        Thu, 02 Apr 2020 11:13:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypIXdqRzArUH2ZsL1EUSB0H8v1U9gywPCW/4wSXhaIAX48AOcIA+658s2GAe64Wr/fSqOsWFWA==
X-Received: by 2002:adf:82a6:: with SMTP id 35mr4724805wrc.307.1585851182296;
        Thu, 02 Apr 2020 11:13:02 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id h26sm7882608wmb.19.2020.04.02.11.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 11:13:01 -0700 (PDT)
Date:   Thu, 2 Apr 2020 14:12:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org
Subject: Re: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Message-ID: <20200402181255.GE103677@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 29, 2020 at 09:24:39PM -0700, Liu Yi L wrote:
> Tests: basci vSVA functionality test,

Could you elaborate what's the functionality test?  Does that contains
at least some IOs go through the SVA-capable device so the nested page
table is used?  I thought it was a yes, but after I notice that the
BIND message flags seems to be wrong, I really think I should ask this
loud..

> VM reboot/shutdown/crash,

What's the VM crash test?

> kernel build in
> guest, boot VM with vSVA disabled, full comapilation with all archs.

I believe I've said similar things, but...  I'd appreciate if you can
also smoke on 2nd-level only with the series applied.

Thanks,

-- 
Peter Xu

