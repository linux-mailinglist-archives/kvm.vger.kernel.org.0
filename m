Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D743159BCC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 22:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgBKV4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 16:56:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727029AbgBKV4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 16:56:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581458196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NE1dJdRP/8g3ODXzP6iKZBLufSoTvZmJMR+yVmTI/CI=;
        b=jAPNCP5uRLfsgCDlerO9N06xU/bMX4+EkwLZyXuRPeAY7zF0ab1aFLi0i/0DhuZHugXZeb
        ClnwtnPu0uTWds6WIa6Xq5HmFwzlK5Gh8dTipNKbEsJ07Gu5HswTrDryVzs54FN1PYITYp
        hqBnC3dh5Xdl+JyhRHZfphv1yZt/LuY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-2guaJNUmO5esLoyInBip3w-1; Tue, 11 Feb 2020 16:56:34 -0500
X-MC-Unique: 2guaJNUmO5esLoyInBip3w-1
Received: by mail-qt1-f200.google.com with SMTP id r9so7648807qtc.4
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 13:56:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NE1dJdRP/8g3ODXzP6iKZBLufSoTvZmJMR+yVmTI/CI=;
        b=b2AExSLe8A7qV/6U3F3GT1NOwbPPCarn0uUc+OLJw6bGXEV23gm/H2I9oMPGQPX+YA
         lCUshNPmT11U5/38/8T8RRfKluLyZi5ryKTRT8pAeuSaSLWTraJTQ6mVYoEBTr742JlO
         kw61ObmPQN+2f1xpJZ94jxawa8fSHHHZmursMMQr5sp8POsR8eYrxKJmtB7U8GeAc0pl
         rAMliHceUyyPjCsQE0W/Ct4tFvCWb90by3WDsxPXsQCp87s3ubEo5FH1YIqZZFSHgdUw
         7r2dw4MIg6PEQD2b2yzQdXSrje3DKf6Nom5aPg8q/031JIlkTH3q4DsR0eVpevvrAkMO
         ffrQ==
X-Gm-Message-State: APjAAAW8U9nQ+OkfFi5iUneN7l/M7881Evii2rlzd0l61fiVaCNtzqZV
        cQUHzc/MvcXufQh68cx+fxh1GWzTXDFF/jl5K7uh+P3cu/WI1F0hMBrFcj7GWyVhQugPvBnSIjm
        8TFWwe7UjGIxI
X-Received: by 2002:ac8:7217:: with SMTP id a23mr4515665qtp.241.1581458193889;
        Tue, 11 Feb 2020 13:56:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqwioyKgRYLaTQid+3oBIsHiXJuXHFBKGSGp0uoPUY/asYhxAfwPjPD4w7PnbofIELfwZSqrjQ==
X-Received: by 2002:ac8:7217:: with SMTP id a23mr4515642qtp.241.1581458193578;
        Tue, 11 Feb 2020 13:56:33 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id o189sm2774095qkd.124.2020.02.11.13.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 13:56:32 -0800 (PST)
Date:   Tue, 11 Feb 2020 16:56:30 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        eric.auger@redhat.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v3 14/25] intel_iommu: add virtual command capability
 support
Message-ID: <20200211215630.GN984290@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-15-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1580300216-86172-15-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 29, 2020 at 04:16:45AM -0800, Liu, Yi L wrote:
> +/*
> + * The basic idea is to let hypervisor to set a range for available
> + * PASIDs for VMs. One of the reasons is PASID #0 is reserved by
> + * RID_PASID usage. We have no idea how many reserved PASIDs in future,
> + * so here just an evaluated value. Honestly, set it as "1" is enough
> + * at current stage.
> + */
> +#define VTD_MIN_HPASID              1
> +#define VTD_MAX_HPASID              0xFFFFF

One more question: I see that PASID is defined as 20bits long.  It's
fine.  However I start to get confused on how the Scalable Mode PASID
Directory could service that much of PASID entries.

I'm looking at spec 3.4.3, Figure 3-8.

Firstly, we only have two levels for a PASID table.  The context entry
of a device stores a pointer to the "Scalable Mode PASID Directory"
page. I see that there're 2^14 entries in "Scalable Mode PASID
Directory" page, each is a "Scalable Mode PASID Table".
However... how do we fit in the 4K page if each entry is a pointer of
x86_64 (8 bytes) while there're 2^14 entries?  A simple math gives me
4K/8 = 512, which means the "Scalable Mode PASID Directory" page can
only have 512 entries, then how the 2^14 come from?  Hmm??

Apart of this: also I just noticed (when reading the latter part of
the series) that the time that a pasid table walk can consume will
depend on this value too.  I'd suggest to make this as small as we
can, as long as it satisfies the usage.  We can even bump it in the
future.

-- 
Peter Xu

