Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43B713CC28
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgAOSdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:33:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729045AbgAOSdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 13:33:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579113233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=va5ZZWbJX4SIzlOtIXmCKn6cD0Cw7eHyuV0gMLwZJ6Y=;
        b=QJ4OWQ2L/O8Y01kVtY7+VUP9UB86TUNlqpX/BgofzPtboIf8UCOYmx9cnqLZgVuukclZkB
        vHVVSSVYJO16vHFePrIasWcLESuzqXf22NOhFxT7/ugfULiQ2hyUIJ6lIWY896aBHmF7t6
        zttaP5F8glf8p62DEKwljHOb1gi+VEs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-uXYO3pIvONCbYwABvvUPmg-1; Wed, 15 Jan 2020 13:33:52 -0500
X-MC-Unique: uXYO3pIvONCbYwABvvUPmg-1
Received: by mail-wr1-f72.google.com with SMTP id v17so8270328wrm.17
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:33:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=va5ZZWbJX4SIzlOtIXmCKn6cD0Cw7eHyuV0gMLwZJ6Y=;
        b=X2/P9sbvGO5krHC1/juR9pIEGxywtRmhgQWACKTI+Znr98i3hnYbsNj9gUTuMhAHGU
         ZTjrrjjP+Ysg5XARQXWZKjjGA3VI16lvQIQoQzLt8Wr92PVYiHzi28bJ9rM0V8YmxKUm
         ODCBwtGr8Moneh0+EnaACpvPl1Xd3vJ5L/+HQ94FZW4DF+OygCSVgInhW4q17V2kAsHq
         61LZlw6cE+odGyeZSOOM0k/mK6PsgCPcxHENUn3s7ZS//skqXU8xcoUhP0T+dCr4/Pt+
         Q50Hb85gANga8rEonBYhBsdUPnIHMCf1T2ktUPP0b/UM9lCARDrYXKHoc6jifYsBKEL9
         EW8w==
X-Gm-Message-State: APjAAAURDqqHIeqiECyyeueuSKUOHuVkweorBUClVo3TT5zpSqxOxIKw
        7CFazPQsSV3GQkXBMk/8J5kn5o6H95RrgjJDNU2etadunDVgUizwvjj1mqPKbrv9CFw+6pYdEIO
        Na6a/VQUTkThO
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr1330107wma.84.1579113231226;
        Wed, 15 Jan 2020 10:33:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqztcB/kOoiO34HAkrYeLeRQT3xoOdqzZnz5pLsFhD3p5EtSAPbc8H6Dz1r3rQxrhzuHO0RdNQ==
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr1330076wma.84.1579113231023;
        Wed, 15 Jan 2020 10:33:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id c17sm25545608wrr.87.2020.01.15.10.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:33:50 -0800 (PST)
Subject: Re: [PATCH v5 1/2] mm: make dev_pagemap_mapping_shift() externally
 visible
To:     Barret Rhoden <brho@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-2-brho@google.com>
 <20191213174702.GB31552@linux.intel.com>
 <e004e742-f755-c22c-57bb-acfe30971c7d@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <207bd03c-df82-f27b-bdb8-1aef33429dd7@redhat.com>
Date:   Wed, 15 Jan 2020 19:33:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <e004e742-f755-c22c-57bb-acfe30971c7d@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/19 18:59, Barret Rhoden wrote:
> Does KVM-x86 need its own names for the levels?  If not, I could convert
> the PT_PAGE_TABLE_* stuff to PG_LEVEL_* stuff.

Yes, please do.  For the 2M/4M case, it's only incorrect to use 2M here:

        if (PTTYPE == 32 && walker->level == PT_DIRECTORY_LEVEL && is_cpuid_PSE36())
                gfn += pse36_gfn_delta(pte);

And for that you can even use "> PG_LEVEL_4K" if you think it's nicer.

Paolo

