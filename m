Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77045310950
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhBEKko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 05:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhBEKi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:38:27 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A061C061786
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:37:46 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c12so7091997wrc.7
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Kd2byfHaARQhUQU5WUzt6+JATiB0vXTvA5FnkbWMLRg=;
        b=WeU+EstOTxTGhthIDXKJe+nLMJFmVsq26ZRD40cgcOIuo1mgcrU68BVKgFWF5jZ6uA
         +tZikrJpOqnFiudM99IT/NXtDtALzsNVtUXWjz6pGKGszGdvR2s6CubwOUryI27QAWfM
         K/lq1Puhao93sA7oNyOEYo/BdJjY28TJipouFkxroMl+WgQJ9I0Wzs4FmfOrUOSxjJq7
         oP7OLG2/y5MwgoK6/EnXwjugcaMAFcC1t53Quh2Oy5IMBoSv3AnvxSLAM9A+zTBYTGTW
         87qATDDTFAvZCPqAMUUK/0eR9klXdw5ocC5cl8C3hhSGsBcZ8UzlDlidoozr+Hu9MJ9V
         3Lvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Kd2byfHaARQhUQU5WUzt6+JATiB0vXTvA5FnkbWMLRg=;
        b=fGckFEHB3MByqyk+s8casuH5HMYMnsvetqGpXwynXlqzJbQa5UOdNTjV/V74nJofQu
         VGVZp8RgKWYfbbhhiA7pnOVm9YvAd0E43AoSslYbg0zdv6paEteDKMzS8Xkv4WFk0eKf
         WFQFJjmziMnlXdMH3XQR8E9HAKTkw9nizd6kfs8duAuJ/uscHIT6I0vNKObzQkJCo/Z3
         3oaJWueUQH7fIg6nWgDa+wtaanCmZqSJ9Fr7JK9/IPMap+3XpkjiIpHtczNKFdGU0rPq
         23lhgJz6n7ooMZhpFsdJ6YGl6/EgoB6NL2UcAiIWrGkAN/tnROrywq+Zip62H/hbub50
         rFJQ==
X-Gm-Message-State: AOAM532v25ERQrJ21hcskLqXFhTkbSak9TP6cWuy4N9KxX6T4E+uNfFW
        Hp8HQHCv9/mYh5AskYVRcoHmEA==
X-Google-Smtp-Source: ABdhPJzRzzXAu8k8E12qBDt7XckS3wL6JnCbC8UsPBflguhsR6RMvOskiWQ+26Ql+7Xg9iLqJRzTYg==
X-Received: by 2002:a5d:440a:: with SMTP id z10mr4343724wrq.266.1612521465302;
        Fri, 05 Feb 2021 02:37:45 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id y11sm11289086wrh.16.2021.02.05.02.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 02:37:44 -0800 (PST)
Date:   Fri, 5 Feb 2021 11:37:25 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Shenming Lu <lushenming@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Message-ID: <YB0f5Yno9frihQq4@myrica>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
 <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
 <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Feb 04, 2021 at 06:52:10AM +0000, Tian, Kevin wrote:
> > >>> The static pinning and mapping problem in VFIO and possible solutions
> > >>> have been discussed a lot [1, 2]. One of the solutions is to add I/O
> > >>> page fault support for VFIO devices. Different from those relatively
> > >>> complicated software approaches such as presenting a vIOMMU that
> > >> provides
> > >>> the DMA buffer information (might include para-virtualized
> > optimizations),

I'm curious about the performance difference between this and the
map/unmap vIOMMU, as well as the coIOMMU. This is probably a lot faster
but those don't depend on IOPF which is a pretty rare feature at the
moment.

[...]
> > > In reality, many
> > > devices allow I/O faulting only in selective contexts. However, there
> > > is no standard way (e.g. PCISIG) for the device to report whether
> > > arbitrary I/O fault is allowed. Then we may have to maintain device
> > > specific knowledge in software, e.g. in an opt-in table to list devices
> > > which allows arbitrary faults. For devices which only support selective
> > > faulting, a mediator (either through vendor extensions on vfio-pci-core
> > > or a mdev wrapper) might be necessary to help lock down non-faultable
> > > mappings and then enable faulting on the rest mappings.
> > 
> > For devices which only support selective faulting, they could tell it to the
> > IOMMU driver and let it filter out non-faultable faults? Do I get it wrong?
> 
> Not exactly to IOMMU driver. There is already a vfio_pin_pages() for
> selectively page-pinning. The matter is that 'they' imply some device
> specific logic to decide which pages must be pinned and such knowledge
> is outside of VFIO.
> 
> From enabling p.o.v we could possibly do it in phased approach. First 
> handles devices which tolerate arbitrary DMA faults, and then extends
> to devices with selective-faulting. The former is simpler, but with one
> main open whether we want to maintain such device IDs in a static
> table in VFIO or rely on some hints from other components (e.g. PF
> driver in VF assignment case). Let's see how Alex thinks about it.

Do you think selective-faulting will be the norm, or only a problem for
initial IOPF implementations?  To me it's the selective-faulting kind of
device that will be the odd one out, but that's pure speculation. Either
way maintaining a device list seems like a pain.

[...]
> Yes, it's in plan but just not happened yet. We are still focusing on guest
> SVA part thus only the 1st-level page fault (+Yi/Jacob). It's always welcomed 
> to collaborate/help if you have time. 😊

By the way the current fault report API is missing a way to invalidate
partial faults: when the IOMMU device's PRI queue overflows, it may
auto-respond to page request groups that were already partially reported
by the IOMMU driver. Upon detecting an overflow, the IOMMU driver needs to
tell all fault consumers to discard their partial groups.
iopf_queue_discard_partial() [1] does this for the internal IOPF handler
but we have nothing for the lower-level fault handler at the moment. And
it gets more complicated when injecting IOPFs to guests, we'd need a
mechanism to recall partial groups all the way through kernel->userspace
and userspace->guest.

Shenming suggests [2] to also use the IOPF handler for IOPFs managed by
device drivers. It's worth considering in my opinion because we could hold
partial groups within the kernel and only report full groups to device
drivers (and guests). In addition we'd consolidate tracking of IOPFs,
since they're done both by iommu_report_device_fault() and the IOPF
handler at the moment.

Note that I plan to upstream the IOPF patch [1] as is because it was
already in good shape for 5.12, and consolidating the fault handler will
require some thinking.

Thanks,
Jean


[1] https://lore.kernel.org/linux-iommu/20210127154322.3959196-7-jean-philippe@linaro.org/
[2] https://lore.kernel.org/linux-iommu/f79f06be-e46b-a65a-3951-3e7dbfa66b4a@huawei.com/
