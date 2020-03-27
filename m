Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A5E195BB8
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 17:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgC0Q6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 12:58:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45003 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgC0Q6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 12:58:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id m17so12202704wrw.11;
        Fri, 27 Mar 2020 09:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8myQ8m6QT+OfnFyYa3rJCzYETwGb1X4YRdpvRBB8Fjo=;
        b=tGAt2/cTVP1pYV1Hni5tu/E1I7NppNmA3JxIKWeam/+KNZ5BIulpko2YIPWTTwH6GE
         a017A53dyrMtd4azj6e/5cGI+i9S5xYVnQYXJ3r+GHgHsjG83k4K//k/XmD8t3/ZWlIz
         hiW735EzVv3cNmXzOVMdOdIP1FxFp1Ci/z/qs0JIRzrE3OwMswRN6cOjWfMXpd/ZdxK5
         dE94HtORG5Qc1DP4LUxUbEAYwFtfIpLQJ3JJcPO4P2i8hfVHAeyBG1nSZj0n1wGnIyTR
         Drrjqy6kQoH3EGTPVFgF3nyLj0dPlZ2EmzO65FuCIlYeDspPXX11E0Zu6QjO4CIRnVc+
         7h+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8myQ8m6QT+OfnFyYa3rJCzYETwGb1X4YRdpvRBB8Fjo=;
        b=kmMOAl/glSEuWwTXD3GqPbJ4KpeyD4mlPpTAAPDcbFDEK1+iaunTSD4zFwRZc6Kvah
         pIbgSbJuupYdJJ9fSHM0aWeb0H5qSicYTeetk7tHbQJ0YcxR5PAcYcX74udnwzVvnZc4
         rRB7d58mXRSIPa504mGQOSry/FpGG6lqNw5BTreoExLQLrBaFS6gzSzL8ES6q90RtkUo
         ory8tif/ZOlx52tGDEyiAerwM/UjjJpFOUwN37KhLmbSpUhTkuNtAxvAp+EhtMplT7Vy
         sJ0ZUGxGMX+JUE1ynYzPoHjN/Npdmy5fNJa4h6/hQw0c7+/NTflq2HaO44E5JESGjByp
         5r7Q==
X-Gm-Message-State: ANhLgQ2RLVTF0JwvpwPCloRwJH00Hgki2S8gmUx/W+K6CaO3ygUpcoZK
        NcRxa1CfdOwUsOLX2vCv3xN5FGLNaWaOvMEzkRE=
X-Google-Smtp-Source: ADFU+vv/BmrwpACOCUazG3UpBbViq39YbY5NMBmmZ7/x6GugNATYQvg4phENFpn/2eUViu7WdDsWWpU0rYqQVWJBJTg=
X-Received: by 2002:adf:ee12:: with SMTP id y18mr307207wrn.289.1585328315282;
 Fri, 27 Mar 2020 09:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200311171422.10484-1-david@redhat.com>
In-Reply-To: <20200311171422.10484-1-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Fri, 27 Mar 2020 17:58:24 +0100
Message-ID: <CAM9Jb+g6DEL1=L1ESfW+Jnr_rfO5rEtOwnp10eCLpajaAv8wvg@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] virtio-mem: paravirtualized memory
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Trying to test the series with the Qemu branch(virtio-mem) mentioned.
Unfortunately,
not able to hotplug memory. Is anything changed from your previous posting
or I am doing something wrong?

After giving value to "requested-size", I see size as zero.

(qemu) qom-set vm0 requested-size 10G
(qemu) info memory-devices
Memory device [virtio-mem]: "vm0"
  memaddr: 0x240000000
  node: 0
  requested-size: 10737418240
  size: 0
  max-size: 107374182400
  block-size: 2097152
  memdev: /objects/mem0

Guest kernel: 5.6.0-rc4
Using same Qemu commandline arguments mentioned in cover-letter.

Thanks,
Pankaj
