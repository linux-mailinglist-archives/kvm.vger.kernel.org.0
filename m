Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A222A0F83
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 21:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgJ3Ucv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 16:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgJ3Uca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 16:32:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AA8C0613CF;
        Fri, 30 Oct 2020 13:32:07 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604089865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nOciarPMZ3UMr6KZRi5VLlCtLQIEu0jwapoX6b79Hkk=;
        b=D1CrXC5y+UuopD9VsQY08W6p72kMoHGpALSYbEVXjhdnGeXQiIb5R3u+xtZihXs2xq3zcn
        n/YvuaV9R6QWp6xZq5fO9YTpBECtUvwfxqthvLwtXdWpu6MA7z17fk46vmPYUvU5+8njeF
        +WQy2qn7VWuM8dDKEfF0QxkahT75sEICugDawcP9KvNThWZHh0ACiza8UldvvLnFKCL7Fd
        78+NQuqfbCiatlbchHNocxK4KBSfhji30pQDVDd6CWFrqVr5q08XUv3DzGqJ/8//hP39NA
        W1N5x88AZ3yqI92p6jTrdeON0FqGhnSdoCUK5MBuVOwOmr/H1bRJT5OpaBbp0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604089865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nOciarPMZ3UMr6KZRi5VLlCtLQIEu0jwapoX6b79Hkk=;
        b=ZEVORfXFEh9eFgYmFTPdWJknr2fOfonqgIEISYzRl5FiyWMKHN/Cvv6D1Q+MTWfN9k2LSh
        peMH5SPMDD+S1bAg==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 02/17] iommu/vt-d: Add DEV-MSI support
In-Reply-To: <160408386122.912050.7027904087316715077.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com> <160408386122.912050.7027904087316715077.stgit@djiang5-desk3.ch.intel.com>
Date:   Fri, 30 Oct 2020 21:31:04 +0100
Message-ID: <87eelfmp6f.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30 2020 at 11:51, Dave Jiang wrote:
> From: Megha Dey <megha.dey@intel.com>

This conflicts with

     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/apic

Thanks,

        tglx

