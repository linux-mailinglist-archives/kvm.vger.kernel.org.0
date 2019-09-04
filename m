Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3954A948B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 23:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfIDVLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 17:11:18 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35662 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730391AbfIDVLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 17:11:17 -0400
Received: by mail-ot1-f67.google.com with SMTP id 100so22201258otn.2
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 14:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOJXX029rLk7A9iwm08b8/Tl49pqEw9N8S7iikumjN8=;
        b=V7EVPD+fthp2Q80ZJwJy+hxX6duKEdu7/VTcx6YCk7q0HWNV0qSkz0sS9fajCv9YLt
         kZ7Fmdk++yNzXS4WboBmvS9IZXHfPN+px0XZmekfpGt0/v+IMmaJXO3lW9jhZA9ffiyC
         MPCKZ1ratNZUFYN5RMYbhqOF5wbt25Pw2FFNks7TFpiuxNqkYnlebEOfluG1zKezJgib
         35GgMnC6P6PF2XOMZp8gk//4CUwUh0NXqzem0UlUM6zKjJEuBAaF0TdbOoTqwGnUr4OX
         hYqx6+7zIYDjo/zUUndobyd6up0UDtz1acNvOWuwmD906+9+y6Y7iiFn576BF/OZAfMP
         457A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOJXX029rLk7A9iwm08b8/Tl49pqEw9N8S7iikumjN8=;
        b=VyGZs2i+YM3lvNgh3aUiXq7LBMvigeo8ydkLbMROX5QvKWiIlThvYoXQPymWISgASA
         2edz/Swpy4rpW6BrgjNW6nExe/z0eerMM7uNFLzU4U4HcCkazkrm9ryY/z3U2T7glNE/
         dpfm+vgGEuk8tQvU59aiw3Q3SabLkP7Y6yAGtY3DeRgUtO5mzwCLJpVtcwyJ/XNQVXdS
         cdZ1CPN3YUGpm675PfpCloE4My+ebNr9bYVv7JCebysk7Lr+my8Mc55c+HJ8CIX+ohB1
         hzQKXTTbz6h/hEtSnZz6I9jXYpc0ZcnyS7s++x+HFi4jQ4wcjJb2Us7MtNWoCLqm71OH
         OTbw==
X-Gm-Message-State: APjAAAWO/XXfUuBKHalB7xVJWZVwdRJiO2aOXJSyopnlemcOjBGt85mm
        9FXUJxCX1Qi7yO41Py20s47IzVQgRK4CqSldhY2PAw==
X-Google-Smtp-Source: APXvYqx9jKkBHnd+DQIWXHwkuc52sRnnbaAsQKgvUKsZGTAH48zPPbXcKFWapnRn7Rw3Hu49a3/TdCstzgRe3NrlpAw=
X-Received: by 2002:a9d:2642:: with SMTP id a60mr9252305otb.247.1567631476902;
 Wed, 04 Sep 2019 14:11:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190904150920.13848.32271.stgit@localhost.localdomain> <20190904151036.13848.36062.stgit@localhost.localdomain>
In-Reply-To: <20190904151036.13848.36062.stgit@localhost.localdomain>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 4 Sep 2019 14:11:06 -0700
Message-ID: <CAPcyv4hHdRbb2pLgeAYep8fXRxYwG3QixFBVfsO9FNtAzvo6mg@mail.gmail.com>
Subject: Re: [PATCH v7 2/6] mm: Move set/get_pcppage_migratetype to mmzone.h
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, KVM list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtio-dev@lists.oasis-open.org,
        Oscar Salvador <osalvador@suse.de>, yang.zhang.wz@gmail.com,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 4, 2019 at 8:11 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> In order to support page reporting it will be necessary to store and
> retrieve the migratetype of a page. To enable that I am moving the set and
> get operations for pcppage_migratetype into the mm/internal.h header so
> that they can be used outside of the page_alloc.c file.
>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
