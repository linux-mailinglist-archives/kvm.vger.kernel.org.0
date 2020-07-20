Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9209226CF5
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 19:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732434AbgGTRMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 13:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732391AbgGTRMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 13:12:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE74C061794
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 10:12:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id md7so132926pjb.1
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 10:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h9NtaO/dHZN+veRlqrp09RfatabewzBYbBRadCS8hT8=;
        b=SHQxkrQ/7aFL+rUTetoqRdouvD8Tuj57jBwL2pjQf9JXaQX9bMh9cx1s7q96QOp703
         FY1DnWEzMdEUZfvv/QCi1Q9pZsDTsC3OCRb4epofwkRlF9Yfi0BJIFN7DdtFWyEZhGrZ
         /GpkRLpgJAp/HLN/a3L7k+6fBJ24TeU7OK1J8IaPvzoG7cCmMxGzQCHhJ6yg1OwJ6MhS
         +yOaHvCbwNNDsBk9d0iefc6a3X78Yy8X3cj/YRtZX2O9SmwOiuHqHkNegDLgZgZE3szE
         dTZ9DMuBQklHyKIadB6vMbIiFuzoqt9/QXIPor0e4GdGt5yDAoJCUXIqzvVvsYY1HDLn
         zvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h9NtaO/dHZN+veRlqrp09RfatabewzBYbBRadCS8hT8=;
        b=Wd3ueLsd+Li47oaf8/cq6M4uhpgK7cY7kfUqCzhv0y2iitFEYlZPeszSW0Ubatxxfq
         BkTaFm/gkVnwA/BCLhISpDj0WU5gmev8Y50FMT3n7PIOD5izYNy65pzLDVhrO/U7q8BS
         pH/Si9VvTFN5EEPw2WfLQf9OJEsLbR6NdfE83t7p6PdZ2Wzagxjgn3p/SHagQa1nHDC8
         gjJ4HLceAWC8EISt9SVxB2czzGS7TbwwIx7yBIKWlmSbv6B/44P3ki1FEEArrNRjLp5i
         pU/i76uBL2bjOi6hXH60Dogt2m6KuonDaHbFVxDXlA0pO6x4hGI+LzqdOHSPVye38t5y
         /9hw==
X-Gm-Message-State: AOAM533hD/woJQq8Ipeb1zGdK+B11KB9fAMga44eZK+dxTbagNwDogjm
        /xJxK9oAmNyzMDenQj5I9k/abcS6XMTT4bmHENo=
X-Google-Smtp-Source: ABdhPJzxrLgGlCYLg80UlkG2fYoZCS/8ojPQP0S/YJX7K6Xr/jpwuSVgkza3xGs1oBKuqH7crPIgSAFbuaUbrz1me1Y=
X-Received: by 2002:a17:902:6bca:: with SMTP id m10mr19014520plt.210.1595265124545;
 Mon, 20 Jul 2020 10:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com> <20200715112342.GD18817@stefanha-x1.localdomain>
In-Reply-To: <20200715112342.GD18817@stefanha-x1.localdomain>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 20 Jul 2020 18:11:53 +0100
Message-ID: <CAJSP0QU78mAK-DiOYXvTOEa3=CAEy1rQtyTBe5rrKDs=yfptAg@mail.gmail.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Nikos Dragazis <ndragazis@arrikto.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Jag Raman <jag.raman@oracle.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you everyone who joined!

I didn't take notes but two things stood out:

1. The ivshmem v2 and virtio-vhost-user use cases are quite different
so combining them does not seem realistic. ivshmem v2 needs to be as
simple for the hypervisor to implement as possible even if this
involves some sacrifices (e.g. not transparent to the Driver VM that
is accessing the device, performance). virtio-vhost-user is more aimed
at general-purpose device emulation although support for arbitrary
devices (e.g. PCI) would be important to serve all use cases.

2. Alexander Graf's idea for a new Linux driver that provides an
enforcing software IOMMU. This would be a character device driver that
is mmapped by the device emulation process (either vhost-user-style on
the host or another VMM for inter-VM device emulation). The Driver VMM
can program mappings into the device and the page tables in the device
emulation process will be updated. This way the Driver VMM can share
memory specific regions of guest RAM with the device emulation process
and revoke those mappings later.

Stefan
