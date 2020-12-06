Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21C82D02B2
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 11:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgLFKUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 05:20:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727714AbgLFKUw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 05:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607249965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rRL1ntqjte5rra5RPKlHfUQ/K/NBrgUEeGy6Us9suRY=;
        b=NRinEKeskwzztohGFWoEqPV41wEb0oCS5Q2DBbAN4sekGxAfCv3SvwqiqH0nhMYROHchZP
        EL4jsGpQrfc7aVMkKPWuYJWs9CpgK8wzB8FFYYYcQUbY1yrcktNYm7Mx31rvCUd3Jc5pZG
        qJc/MwjD2tR+78kjFid8YoKBgS2rdZ0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-eB99T_ITNz2p70zhN900ug-1; Sun, 06 Dec 2020 05:19:24 -0500
X-MC-Unique: eB99T_ITNz2p70zhN900ug-1
Received: by mail-wr1-f71.google.com with SMTP id v1so4124786wri.16
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 02:19:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rRL1ntqjte5rra5RPKlHfUQ/K/NBrgUEeGy6Us9suRY=;
        b=m9OeIHp5NvXFzzlGzRcvHqqitaML1+6UhWTzybq0AQpZ1ctf+0UMKKzqOmW3yfNN8t
         aRLEBNfNhwP/zj8ew4sY4gi9cgpliqRKvT8Pyg2c4CQ88Qq6Fx2R8eG5DOkiYP4lvEOx
         Jm2kcDg0ySMGytE8+DPkF3WtZbwg0mCjWCV28ntqAnAQEssAPCSMnjAwLuMDBRmztCjA
         1C4Yp/nildKpk503oKdn62L1tEb7BMcA4GcWgewNH94HQLuoEMDZm6IRuu7lXvXgOHiS
         Csj4IJvZS04pck5AL0i6n9Y3Tn9MSgqbj66ruobDG4i5Hpuxn+TFHmsG6cmN1otibfDP
         T4aA==
X-Gm-Message-State: AOAM531TVOLi9v10sRTJvEArwTNcY7E3xvkC7j+wEXVDprpTagnf9Oox
        4l71PXVs2BwJjW5Nrbta1haWfpQg2KntlPBZNWy7HHHSjjUA8KhJZCMu19fOk9NEz91AVLqlDPI
        ThZ9rJbBSQbv7
X-Received: by 2002:a5d:620e:: with SMTP id y14mr14640898wru.111.1607249962965;
        Sun, 06 Dec 2020 02:19:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5VTSGa31w3gh0fjL9GnwIZXtGmhTVP/jLMb8z8he9UUGJhgELgyqyjHdq0ERGKOu220obaw==
X-Received: by 2002:a5d:620e:: with SMTP id y14mr14640874wru.111.1607249962793;
        Sun, 06 Dec 2020 02:19:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id c9sm10582239wrp.73.2020.12.06.02.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 02:19:22 -0800 (PST)
Subject: Re: [PATCH v8 12/18] KVM: SVM: Add support for static allocation of
 unified Page Encryption Bitmap.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <17c14245a404ff679253313ffe899c5f4e966717.1588711355.git.ashish.kalra@amd.com>
 <617d3cba-cbe0-0f18-bdf2-e73a70e472d6@redhat.com>
 <20201204213852.GA1424@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4e60a01d-dfc8-bc4f-e3d2-628d69f370fa@redhat.com>
Date:   Sun, 6 Dec 2020 11:19:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204213852.GA1424@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/20 22:38, Ashish Kalra wrote:
> Earlier we used to dynamic resizing of the page encryption bitmap based
> on the guest hypercall, but potentially a malicious guest can make a hypercall
> which can trigger a really large memory allocation on the host side and may
> eventually cause denial of service.
> 
> Hence now we don't do dynamic resizing of the page encryption bitmap as
> per the hypercall and allocate it statically based on guest memory
> allocation by walking through memslots and computing it's size.
> 
> I will add the above comment to the fresh series of the patch-set i am
> going to post.

Sounds good, thanks.  If there are no other changes I can include this 
in the commit message myself.

Paolo

