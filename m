Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195662A0FB8
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 21:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgJ3Usd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 16:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgJ3Usd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 16:48:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87FFC0613CF;
        Fri, 30 Oct 2020 13:48:32 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604090911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZfJWaG7ev2qljT+ieaDGxkIgb/WuF3LfKzynT9foX4=;
        b=ByevYznDMYjqf6G6Sn/uMI4O7DCIqkUWI0YsOR+hfYSMxatcuy1GmtKyPMu2eTlP34IyBE
        L8l2qK8sIF90ikzPnMm5I2frtqCYc9AKswrydfEtLRARdjDVReDB5bREBgwdz7C/Pat1Dt
        cLE9eI/HYBbjxkck9XHaS0xlF/m0IfqF6bZ83PwtGVMGAtut2Ad+IMmQCOuOhGxFR6euZ2
        9kZfnj5oV1Y99y3rf7PrQAlWq4A3xU9369tIhMBd8+/k6YEHuHDdGymQcRIzpPrQL2Na74
        gt18OhJ1nc5e6Nb6EXM7RKiDfxJw25CfnGFP2ryNuUeiasWCsmBtT5xeFP07wQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604090911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZfJWaG7ev2qljT+ieaDGxkIgb/WuF3LfKzynT9foX4=;
        b=Q4y0lhQ3OUOqktMxgvHMiRHWLGed8ooMTumCvJK1rrh1JDG3fBrxqZn0VyEfUfjO3V2mq1
        xRjKR1MDUOXHr4AA==
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
Cc:     Megha Dey <megha.dey@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI support for the idxd driver
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
Date:   Fri, 30 Oct 2020 21:48:30 +0100
Message-ID: <878sbnmodd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30 2020 at 11:50, Dave Jiang wrote:
> The code has dependency on Thomas=E2=80=99s MSI restructuring patch serie=
s:
> https://lore.kernel.org/lkml/20200826111628.794979401@linutronix.de/

which is outdated and not longer applicable.

Thanks,

        tglx
