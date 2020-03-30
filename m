Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38833197A5B
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 13:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgC3LFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 07:05:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35934 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgC3LFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 07:05:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so21055654wrs.3;
        Mon, 30 Mar 2020 04:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XkBazEXFPT2Evha6vjR9imItMnoqhOw7XhTfpTqH9rw=;
        b=QySTWIlxqN9pAwfMxquLPaJoQKBaN/DAuMKqalJdqXhJUF07P9NMQC9Dl1xJCZjHan
         qJRdybwAx2Es1k6MDaQz5dai4A5zW2DZoptXwGK8ncQLsBN8Xnz2MFy73c2e6dkEOL/s
         YliynkpfajzEsVeIoSfU4zHpFNiTnuLpXhYEag4phtrI83z/YOIBqrWn5kjybu11X1rt
         DV7CuyyiGRHqO3UNHk4DVPQL9USuvXbwWfw1+Kt1EibO5MX8BE8Q44CtA7/5mDWYt2Is
         WaMgW9WstUWpl7nQe6HIKPe7nrZj+AGFJXlMAFCnuhBgp4eMhH17kex820smo7xEPGuP
         /kiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XkBazEXFPT2Evha6vjR9imItMnoqhOw7XhTfpTqH9rw=;
        b=tFGTguT5qEpzCEjHqKz99EaV4fc8/xbG8pjBXgyleSJipMY/w5ZAleL/N1yi25wn7M
         9a+wy4L0RrOj91QyyCCLQUnac8+lKRhMrhPKxb1uRjRq48zHMim+7/bRkmtX9N1EjN+e
         Z6wAWlBapzMntCRbTdPRZnQQBwa9z7rNJB4j4/SyGZ5gHFP0gQ5wZUSJpVZx6pK+UCwL
         1eAuxd9zvWWLTa0R87OXj+M+3CsPy0kStl3yYyzr2zGiHPy/qFun2MfSgloJ4eKejgMn
         v/rMpuOqhgQ170VexRhlEkh2wpYzFAcd4Zam6Vn9+PoV3Fu94KJdIGkr40E8dMXg0r/J
         at5g==
X-Gm-Message-State: ANhLgQ2LBL1En9q/JgnSN1kc0N3JfMUYHtMiRGN2HGm9HTmphMRLKvwC
        1CJF+HRqPAuEzdyR3NtT/5M69u6OxmduH4l47SQ=
X-Google-Smtp-Source: ADFU+vsmeeWN6BFqjDs6ZOZJhwtVkxoEL3SPj+KuoGqJhs7MxebsaCNQ9XQMTvBxapDW4HOx5kzYXH7N63O9EtZcpJM=
X-Received: by 2002:adf:f48d:: with SMTP id l13mr14634041wro.96.1585566297673;
 Mon, 30 Mar 2020 04:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200311171422.10484-1-david@redhat.com> <20200311171422.10484-3-david@redhat.com>
In-Reply-To: <20200311171422.10484-3-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Mon, 30 Mar 2020 13:04:46 +0200
Message-ID: <CAM9Jb+iLe7inqnAVmmaq2bsRGVKn+dwJqLD=M4yU3KQf+Au9hA@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] virtio-mem: Allow to specify an ACPI PXM as nid
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
