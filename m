Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FF7215C33
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgGFQsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 12:48:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50467 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729441AbgGFQsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 12:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594054117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=18sZu3vv7B5MP8l+3RggnmnKzDbqVsZQ4T7AXFsrsWg=;
        b=EiIPA0uUZykO2Icj7qN2spqNxLBN7cGvf8wbzbu5Ly4OiwgseybdT23Ly6tdDtZsRZmkoO
        LNmoa3OnO/rXehZxxpWt8iZ69s8ERZaL/ShtsJhX/Pyhg9jWMrxzQgrKzL26mKk2S469H8
        D3WPfkHmZuo906NgFXVD0F5HwZG/Ks8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-DfZbmKDJNea-KQx6pBHsZQ-1; Mon, 06 Jul 2020 12:48:36 -0400
X-MC-Unique: DfZbmKDJNea-KQx6pBHsZQ-1
Received: by mail-wr1-f70.google.com with SMTP id i14so44118253wru.17
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 09:48:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=18sZu3vv7B5MP8l+3RggnmnKzDbqVsZQ4T7AXFsrsWg=;
        b=Y8DeSR6j8fFnfzc4ZTM+E4T2CIsTndhUNdaA0Cg+vAglmLE9BDYpdfxABcDEBoRhIO
         UEBWnqFzjMbpdXk0VvqZW3iop1dXG3rT7KhdwRCvB4YnKygfaPmwRyP8hZ78Z2ssL+QI
         OWgrZ/cOuCWFxar88Nr9gCkYQfctaPUNUj2CIEMjcEiA9izVYN3om3aPBiVcjvTfHexT
         H8IfCmCnvd4XPGKp39zH2Djc5uaeVB2ekw22QxL2f+KVA7p4d8SiHsrnmvv5e36PeaHF
         XqvkRNNkZehfasEAFAbXUrkpqhs68FXs4rjtMJX+s0zQ8YV5fBT/VYi+ROW6OVzMIOk7
         cIQA==
X-Gm-Message-State: AOAM530lNXJUYcmaiDaCNwFtBKauQFpcDfEOhZQAe1ZI7GJeh78nvMWh
        6RGjgoD6UAqqd6tT2HQkOmcPMAt7U0PIKsqJvatbWMfwe6PLUwWH5dR4a0sXJF9EZDxFWnMAVe8
        TJ3hlEt2eySKy
X-Received: by 2002:a5d:4a4f:: with SMTP id v15mr47479563wrs.87.1594054114272;
        Mon, 06 Jul 2020 09:48:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrefLVRHqdbCP7KfiTa6gi793vGCeUdfCNFfe26jq+3KrSz6KZiluI4WR1IPMuqOXJ3HW/wA==
X-Received: by 2002:a5d:4a4f:: with SMTP id v15mr47479552wrs.87.1594054114067;
        Mon, 06 Jul 2020 09:48:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3181:5745:c591:c33e? ([2001:b07:6468:f312:3181:5745:c591:c33e])
        by smtp.gmail.com with ESMTPSA id x7sm25499615wrr.72.2020.07.06.09.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 09:48:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 0/4] More lib/alloc cleanup and a minor
 improvement
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com
References: <20200706164324.81123-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c73486db-65ec-1499-cd51-d4d8fcc3ba13@redhat.com>
Date:   Mon, 6 Jul 2020 18:48:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200706164324.81123-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/20 18:43, Claudio Imbrenda wrote:
> Some more cleanup of lib/alloc in light of upcoming changes
> 
> The first real feature: allow aligned virtual allocations with
> alignment greater than one page.
> 
> Also export a function for allocating aligned non-backed virtual pages.
> 
> v1->v2
> * rename helper function to alloc_vpages_aligned, call it directly
> * alloc_vpages_aligned now expects a page order as alignment
> 
> Claudio Imbrenda (4):
>   lib/vmalloc: fix pages count local variable to be size_t
>   lib/alloc_page: change some parameter types
>   lib/alloc_page: move get_order and is_power_of_2 to a bitops.h
>   lib/vmalloc: allow vm_memalign with alignment > PAGE_SIZE
> 
>  lib/alloc_page.h |  7 +++----
>  lib/bitops.h     | 10 ++++++++++
>  lib/libcflat.h   |  5 -----
>  lib/vmalloc.h    |  3 +++
>  lib/alloc.c      |  1 +
>  lib/alloc_page.c | 13 ++++---------
>  lib/vmalloc.c    | 37 ++++++++++++++++++++++++++++---------
>  7 files changed, 49 insertions(+), 27 deletions(-)
> 

Queued, thanks.

Paolo

