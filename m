Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB2E1762B0
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 19:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgCBS31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 13:29:27 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34986 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbgCBS31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 13:29:27 -0500
Received: by mail-wm1-f68.google.com with SMTP id m3so136776wmi.0;
        Mon, 02 Mar 2020 10:29:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hKkgF2JN7gykCZKvbDhRvANS70H1+8HoXvuiM9rtoLA=;
        b=qZVioLE+WftFPjkmp8r/hCYKdNuz8Nqd1wQhgTv41irFucKMUR8GCL3f6CiChOsl7I
         EHwGHd1nwc+fgobvS5tYHhWAHRgv7BwxM3MWN7a+2k6u+P1YmBk9spBgpaZh6jf7bR+d
         VuI2rEofepRiOAjbvnfygNfF0rV03rijolL1OsJQGozw2uowdZ/G5HG8TIaf7va/fm/K
         TNGb7sv+xx6dgeeZWVcXtt+nJAgJjNsAD3w6s+/5Bt9QmuOnR2x/5vRoD2/sqoDhvcNB
         CPlztvlVe67kfYmvrsh2dOIWMBtahM3cPpQj4t7KMfEM7SL60uKw0qzbMX3dBx9HWVSn
         YHXw==
X-Gm-Message-State: ANhLgQ3DAwbynbWPKVx/ta/GRhMZsmpyt5mgECs+mJYnPHpfdeucNsRe
        1RO8MF1mySGVwE19/vh3Zw0=
X-Google-Smtp-Source: ADFU+vuD+iUqdIsN7GsQwMdgoFIg5mjnb/d3Y1e+SHBuYQQus1FBM/XQRItFBGMXPRhig1FWUl0HpQ==
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr330579wmi.21.1583173764395;
        Mon, 02 Mar 2020 10:29:24 -0800 (PST)
Received: from localhost (ip-37-188-163-134.eurotel.cz. [37.188.163.134])
        by smtp.gmail.com with ESMTPSA id j5sm29915868wrw.24.2020.03.02.10.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 10:29:23 -0800 (PST)
Date:   Mon, 2 Mar 2020 19:29:22 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
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
Subject: Re: [PATCH v1 00/11] virtio-mem: paravirtualized memory
Message-ID: <20200302182922.GT4380@dhcp22.suse.cz>
References: <20200302134941.315212-1-david@redhat.com>
 <7f8a9225-99f2-b00d-241f-ef934395c667@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f8a9225-99f2-b00d-241f-ef934395c667@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon 02-03-20 19:15:09, David Hildenbrand wrote:
[...]
> As requested by Michal, I will squash some patches.

Just to clarify. If I am the only one to care then do not bother.
Btw. I still have patch 6 on the todo list to review. I just didn't find
time for it today.

-- 
Michal Hocko
SUSE Labs
