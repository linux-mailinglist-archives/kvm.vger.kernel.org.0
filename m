Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7750AEDA1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405415AbfIJOrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:47:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33653 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405395AbfIJOrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:47:02 -0400
Received: by mail-io1-f68.google.com with SMTP id m11so38140099ioo.0;
        Tue, 10 Sep 2019 07:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=83TThgQAjkQ0ae/WfN2rozL6NZ6sFqo/tzTJieGwWhY=;
        b=bctqj0dIEQG02DidTblEEKKmlRq95iuCrJbWTEZEFy6f4ldmknD9AC82Hjp7WtIcUL
         wdtgqANYPFpfuqN9RWFoV81S+TL4TZWcW/eRB1zbwCnI4axFiqpnKB/4F9Vb1ASsBmwM
         MoGeD5V7oPXNrI0TLfR8qwBLS/a5rmpBqaVS40yQVLdcqID59aFUJKp3thzSPP4Ym5fo
         oUxnlGZ+RikUHkghsxU4t9MUOUJM1V923cataTV37iHuaUS8taTW2ilbXf8zuGBL2rrr
         GFcYtmHJkRVPpjaQYbMNqFd6Z6x57kRfzb33fCPJ6liqZh8sZLRJMVMsx0Mc0ssKXqB7
         m1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=83TThgQAjkQ0ae/WfN2rozL6NZ6sFqo/tzTJieGwWhY=;
        b=W9N7gezhQNg1WG4oLf0K+lRaR7fEVZLBCpgY6d7YqL7EIUxwwd5lF+yRrnldvMTA6i
         XaS/bfqnVmrB85wRDp9NRmCrEtT7WuNy0e5vyb0G8eWkkwUgIV5E6TlxnDMRWBaK4XOv
         pgOmkyAaoudtzyp2v6rXn81jpTS1vNue8vtPwL4JvaICatc5WbsWlgZ+WUogQG6NI2Cl
         aWf4AfbJ52AVTTKqdFKK6eMJxiqdSGyn4Y8n0e0dMNfCiM+A5P+Xl2W4ZfXHNWyT6H/J
         unjia/KY650Km/BSdiA0ShdB9J3Sqsugy2NDAwXR6LgM5ti++sgy0ef9dMKGpN2ba4q2
         yj0Q==
X-Gm-Message-State: APjAAAV3mDU/E7CQnDy/X6dpky4LggsUGMCV29Vir2KS+0cNn1ORT2+y
        0iMtS4vSfO+BioA6pX29mZ/tNQpOaK2BovOgkjg=
X-Google-Smtp-Source: APXvYqxrAgxnAGDouzK82zOnS/FEXuQVFFiHhPiHvEJcvMSKDH7nqj7q9uv+1GUDlOR7M4uUZTjdaBK0SNIGv69duNM=
X-Received: by 2002:a5d:8f86:: with SMTP id l6mr20769278iol.270.1568126821359;
 Tue, 10 Sep 2019 07:47:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172528.10910.37051.stgit@localhost.localdomain> <20190910122313.GW2063@dhcp22.suse.cz>
In-Reply-To: <20190910122313.GW2063@dhcp22.suse.cz>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Sep 2019 07:46:50 -0700
Message-ID: <CAKgT0Ud1xqhEy_LL4AfMgreP0uXrkF-fSDn=6uDXfn7Pvj5AAw@mail.gmail.com>
Subject: Re: [PATCH v9 3/8] mm: Move set/get_pcppage_migratetype to mmzone.h
To:     Michal Hocko <mhocko@kernel.org>
Cc:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 5:23 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Sat 07-09-19 10:25:28, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > In order to support page reporting it will be necessary to store and
> > retrieve the migratetype of a page. To enable that I am moving the set and
> > get operations for pcppage_migratetype into the mm/internal.h header so
> > that they can be used outside of the page_alloc.c file.
>
> Please describe who is the user and why does it needs this interface.
> This is really important because migratetype is an MM internal thing and
> external users shouldn't really care about it at all. We really do not
> want a random code to call those, especially the set_pcppage_migratetype.

I was using it to store the migratetype of the page so that I could
find the boundary list that contained the reported page as the array
is indexed based on page order and migratetype. However on further
discussion I am thinking I may just use page->index directly to index
into the boundary array. Doing that I should be able to get a very
slight improvement in lookup time since I am not having to pull order
and migratetype and then compute the index based on that. In addition
it becomes much more clear as to what is going on, and if needed I
could add debug checks to verify the page is "Reported" and that the
"Buddy" page type is set.
