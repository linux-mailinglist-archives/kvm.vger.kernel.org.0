Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8D197EC3
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 16:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgC3Oqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 10:46:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:35756 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727769AbgC3Oqw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 10:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585579611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FPOODXZeqHak8yNUsaPvPmUoEMONp5wZGn66sHTps20=;
        b=PYB5djc5awuXtOiO/wo+/qUiWWwakkvVWIT+aKohItZM4KaKIEcSRoP1eXuqO6oAm3DlJB
        bpxy5cnPJYIgNZiVw8Kqggx/hYT5GWPgGmcrAeSfj/KiNeAg/vFXQmChNmb/hs4SzkqOKl
        fwzaNFYogaHp4oJS148PAtxkw+O/Ek0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-fY3nxr7YNQW0r3eFPTtE7w-1; Mon, 30 Mar 2020 10:46:49 -0400
X-MC-Unique: fY3nxr7YNQW0r3eFPTtE7w-1
Received: by mail-wm1-f72.google.com with SMTP id g9so8031404wmh.1
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 07:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FPOODXZeqHak8yNUsaPvPmUoEMONp5wZGn66sHTps20=;
        b=I+KiTTPKxKjqW7HbVAQvT4jVwXSjp+fmVsTHFqcVTdArwo0/aYLziWRa3Q/W5wYLGo
         1g037Jsbt8+PnuaL3pEAwsuaKH3ddYl+nJHHYi/+H/xa2mumZbMmd05ErRpJ3IswBSc+
         N2vZXUgqx5iz71gJxTXkqb9stLRG/iSBPI5M08mpSePefXMKR5AeQpZJPX3i7VKel6uv
         OhXuwuP/l0m0dsor5CiWqO9u1O58KFRWC7Au6sS7yq3x4ZIQkhr/lbFo+Egk5N1vY5N7
         EdDGrFya3iNDUN07CjkbRGv+dM4UNOPqnqCtySk9icnjAcYBN/4jIWzjvWrL4HsVhW0a
         2vqQ==
X-Gm-Message-State: ANhLgQ0mO9HNyF15ubEL++X8u7h+kOdjskezQ0F8yGnxMhjFWM0zNaxP
        lC1iYuPZV+O3VtPQOS4FoBnpbRRZGayx4jEhJQNBITJxB9mhgWvW6t8rSYbWWOzhTWG2JQ7+Aup
        sYtHnuGMjlv5T
X-Received: by 2002:a1c:4645:: with SMTP id t66mr13970590wma.6.1585579608038;
        Mon, 30 Mar 2020 07:46:48 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu11Bf/4QJ0PMAXy7op2XTLz+TvVZsEHoWaya5YO1UeYVBfTuMaKjTcgmjpUGV7NkTe5j/1dA==
X-Received: by 2002:a1c:4645:: with SMTP id t66mr13970564wma.6.1585579607779;
        Mon, 30 Mar 2020 07:46:47 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w7sm22220373wrr.60.2020.03.30.07.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 07:46:46 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:46:40 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org
Subject: Re: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Message-ID: <20200330144640.GC522868@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <e709e36f-dc50-2e70-3a1e-62f08533e454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e709e36f-dc50-2e70-3a1e-62f08533e454@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 12:36:23PM +0200, Auger Eric wrote:
> I think in general, as long as the kernel dependencies are not resolved,
> the QEMU series is supposed to stay in RFC state.

Yeah I agree. I think the subject is not extremely important, but we
definitely should wait for the kernel part to be ready before merging
the series.

Side note: I offered quite a few r-bs for the series (and I still plan
to move on reading it this week since there's a new version, and try
to offer more r-bs when I still have some context in my brain-cache),
however they're mostly only for myself to avoid re-reading the whole
series again in the future especially because it's huge... :)

Thanks,

-- 
Peter Xu

