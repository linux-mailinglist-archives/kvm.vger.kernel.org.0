Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6248B1A3DB
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 22:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfEJUPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 16:15:41 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40645 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbfEJUPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 16:15:41 -0400
Received: by mail-ot1-f67.google.com with SMTP id w6so6703020otl.7
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 13:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=haQb/JJEXbzGwY8djXGgfBZiIn+/x5Yv5AUgQ4m38OM=;
        b=WEeqre45hj7sSv58I/e7A5coRY+GxRJHinyFbk3h7U4aJrBJYpdYkhq9T1r4+5or5d
         jRR3GR4Z+c950AiPGFzXe4QQXlx4J3RcgRXk7RadE4sRSsQK7+mC+RHs2IEhRwKUI7Zy
         /T1NcmREZZ/qpW4sfz6npTMRE2tie3uif+puXikMYRBthExnMytzYTF00hoiHxBr5/P0
         7jNqauenyRbY3EQ6raNfL+QovOy++Rd9rquniNrMmi7pGZFEPwXRnlT7u+kZ42rUMzcD
         v4eAUwbD5Njo6W9aRbjgU1OhGsIT/fgW+T3LVLT6M51FFHqJTii+xqDcL8xDANdQWGtc
         2Dxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=haQb/JJEXbzGwY8djXGgfBZiIn+/x5Yv5AUgQ4m38OM=;
        b=oEPWWH1y6rTvjJ+5x/mdNffOfL6tO6A5s/BBUso9gbU6CLUV/C7CIU07/0ghz5aoJ1
         aYMtP3rZt+7MAMOQcyplZPX99ZJR4M3J5//UGaDaEnOGYf6c/vBLp/dAI6DLCgJVAleB
         ksfVESKpAgqqgLmq89MBH7P1nCSt4KtegQUz1905d64hapRGQHMcUKWcZsKRdwn+hfmC
         LGCZw2xKaSmfMdU2Z10ybZOznCn+lcxkhfT8gcuShe5V4Su+g3wuGVmufV7eNzbhuDVh
         a9T1lNQ51s7Radg/L8DXL+R0E1DgcTWJbg+86WD9rhm6YVOnPq5Z3RUfM028Az2y9zva
         3riA==
X-Gm-Message-State: APjAAAUTuGqY3Bq/K6YaqShDff1o4HqrFRhXQMvXM5rPiGsrPiLUJ2uI
        K2pbNYCymFDOoaVOuY6WeM6piDpAC9az8tRPNfMRiQ==
X-Google-Smtp-Source: APXvYqzGzV4vCYOWqp7L7v2b9h2jjvTQectDwMiq79aWZo81gT17ipgMl7EwlMGGL3BIVEygxWA2BmYfTI9FLFAVAXk=
X-Received: by 2002:a9d:6f19:: with SMTP id n25mr2918893otq.367.1557519340452;
 Fri, 10 May 2019 13:15:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190510155202.14737-1-pagupta@redhat.com>
In-Reply-To: <20190510155202.14737-1-pagupta@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 May 2019 13:15:29 -0700
Message-ID: <CAPcyv4joEZaePvzc__N9Q3nozoHgQn7hNFPjBVo5BP6cc4rkEA@mail.gmail.com>
Subject: Re: [PATCH v8 0/6] virtio pmem driver
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Ross Zwisler <zwisler@kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Christoph Hellwig <hch@infradead.org>,
        Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        jmoyer <jmoyer@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        david <david@fromorbit.com>, cohuck@redhat.com,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adam Borowski <kilobyte@angband.pl>,
        yuval shaia <yuval.shaia@oracle.com>, jstaron@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 10, 2019 at 8:52 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>  Hi Michael & Dan,
>
>  Please review/ack the patch series from LIBNVDIMM & VIRTIO side.
>  We have ack on ext4, xfs patches(4, 5 & 6) patch 2. Still need
>  your ack on nvdimm patches(1 & 3) & virtio patch 2.

I was planning to merge these via the nvdimm tree, not ack them. Did
you have another maintainer lined up to take these patches?
