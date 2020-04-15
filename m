Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F9A1A92CB
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 07:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441071AbgDOF7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 01:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2441062AbgDOF7m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 01:59:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0D8C061A0C;
        Tue, 14 Apr 2020 22:59:41 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i10so17579603wrv.10;
        Tue, 14 Apr 2020 22:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bsdw+AlvxpaYVY8Lcjiqb5lWVO+/dV7fKji2stjWQoM=;
        b=JcWcWuiDWGrat7PLbbGGpy+VPCwZm+B8+b6wIR5Qlxfxy+BWIl7W3IQIkJhpT9dMQ/
         KHWM043X+68VVMlKeKimAMxZXIuFAWaKNOyTQ7mygKJZirRFrXpLfga5nca6/yN7sb7m
         JeQn2eTsJoY0SsenEcw6+1hEASroKswAcE4X35r0YOiPZ5jGBKQApmHqFZ4sq4gHjKdG
         Y3n6+YfWWVguF7/onY60Kqj/u2fjv8erG23gS8RGAkzk0bQHYB1BDVnfjrHaE8CS5aSt
         Rjr7k+3et5/Y/3dqyE09ehmdQNqJPeeYs/kLKup/xCUwjwdd68D89T8FnDTSl+XL6fb+
         smZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bsdw+AlvxpaYVY8Lcjiqb5lWVO+/dV7fKji2stjWQoM=;
        b=daNe2Lm+Is6pfWmordGgi+Cxl+3yMz9wigDI7lbCmY7hs6nBsKZORcwYYw63CRJ6ja
         oHOPSZML964TT0S9kiQlG8gohW6Bcvv4JOWTp0nZ4KXuKFuUJcFp9udKmnMr+/BkpR7o
         7H1Nd1GvsFVa52dulJRhddNnCu1EcWBeUZUw7f8n4QrCdWe2MZrzMNlx6cFQFFOIq9ok
         +A4U8XtexsXPrt6PFhQGhgTcT4xpYCWWMqoH2bUG53vfcQ0c04xDIBWJSBbkSBCIMtd7
         +xzl/W4z+P9BaQm7ri2W89HhK4HC1XqBoWoH2t8Q6OU3Umo5nym9xbCM2qy4Dg/mZadZ
         QaFA==
X-Gm-Message-State: AGi0Pub6l2ehgXKpJyn4uGnY1dznb+JpzCeGnE4peFmHlYpEc5rD7GIF
        pGTfLc+wBR8N6c+jHrB/QSRHTT5C2g2zq3ZdGso=
X-Google-Smtp-Source: APiQypLIUSKaAEG1Gvkn2HdyUu7XOJ1Ks6l0f/YpHQQasnkp1D78E3DW2NpedLoUJjzQcwbl8mvUogTsn+2/TeKZq4Y=
X-Received: by 2002:adf:db4d:: with SMTP id f13mr6637560wrj.289.1586930380463;
 Tue, 14 Apr 2020 22:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200311171422.10484-1-david@redhat.com> <20200311171422.10484-2-david@redhat.com>
In-Reply-To: <20200311171422.10484-2-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 15 Apr 2020 07:59:28 +0200
Message-ID: <CAM9Jb+ic2e3A9uaD3whMB9G+dXfeX877vtjF7TgiPKhwZ2nvzQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] virtio-mem: Paravirtualized memory hotplug
To:     David Hildenbrand <david@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I spent quite some time to review and also tested this driver.
This looks good to me. Feel free to add.

Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
