Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B425A4360D1
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhJULwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230347AbhJULws (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 07:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634817033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EUB/I3LOvvRpF1h2TnG013GM/MMWYNklc8NR07/znl8=;
        b=BfJKytZtZPRcixBF3hgOzHK3x+8iGbifKkc6BOavvnvzW9xKr/GmVW842DRyXonUA2THYF
        dEdwEvySjRq8/CLyl5hecTigkAbefBYNH4dr1mB1V6I5AvAb8srpkNacrX7RSfYp+JZ9mG
        fKpVDbAYDpKVBr6y0bWQ5JqVwEix2DU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-kqmlgRGIPh6SaZAqMhiGvw-1; Thu, 21 Oct 2021 07:50:31 -0400
X-MC-Unique: kqmlgRGIPh6SaZAqMhiGvw-1
Received: by mail-ed1-f72.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso48418edv.9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 04:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EUB/I3LOvvRpF1h2TnG013GM/MMWYNklc8NR07/znl8=;
        b=qj2W7eIwIl1L72z8BWg2fM5F10DwbykFTYu44hOIEAVxNuHr/ZNSUn5qEpoVsWHxs9
         OOjTzvFQ7LSstfo26iywOnSiUuYU/nTKF6P8mWtdcBTseuC9L8YPeOJZjrRXrX/FrUGQ
         fNJs7qF/BDF5AkpfB2Jk/WS1IvgVZluRNqEsyjVQObsyG364hcxfNFZzKFdrIE9/Vj63
         mkza2+Ms+eb5WNajOVTw/vzNpen1lO6nspC3p8WMc8oUvtCSrXmwfMl8ntY1TV2o25K8
         xT7eSduyvXyMA4V6IGuj+pbT8W4bVTjImKnST6tFJZ1D47uQmlabNhNGTVBK00yFuBom
         Ck7g==
X-Gm-Message-State: AOAM532jOUssTxIyM12BUl8d6TIagkHRVK5ussw6nalq5fRm/uva7Civ
        tCSlBwsS9QDIrRKJRkt+s89/YnZMMHdG2RE0icIj/9EkjMg71RR0Ezz7Zlktd4+JIk1gKMKmBVC
        f7IlWqgma0NOF
X-Received: by 2002:a17:907:20ec:: with SMTP id rh12mr6842634ejb.15.1634817030670;
        Thu, 21 Oct 2021 04:50:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJUI0tkaGM1E9WO5uxjkOvPB7jRwa+70lk3SHap8pJUXSIBxZRghQ/jOsvwZUv0t4wG7jzBQ==
X-Received: by 2002:a17:907:20ec:: with SMTP id rh12mr6842602ejb.15.1634817030419;
        Thu, 21 Oct 2021 04:50:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id dd3sm2414832ejb.55.2021.10.21.04.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 04:50:29 -0700 (PDT)
Message-ID: <4827d6b6-b28a-484a-64a9-4ba9cb948b2c@redhat.com>
Date:   Thu, 21 Oct 2021 13:50:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 01/17] x86: Move IDT, GDT and TSS to
 desc.c
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com,
        "Singh, Brijesh" <brijesh.singh@amd.com>, Thomas.Lendacky@amd.com,
        Varad Gautam <varad.gautam@suse.com>, jroedel@suse.de,
        bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-2-zxwang42@gmail.com>
 <e1e6c07a-132d-ba11-cca2-282315b23eb3@redhat.com>
 <CAEDJ5ZSZMdUC=B2y0ZsVe30G-xZUe+xW2dVhH5R9vdcVS45Ecg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAEDJ5ZSZMdUC=B2y0ZsVe30G-xZUe+xW2dVhH5R9vdcVS45Ecg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 19:56, Zixuan Wang wrote:
>> tss_descr is completely broken in the current code, I'll send a patch to
>> fix it so you don't have to deal with it.
>>
>> Paolo
> I just noticed the new patchset to fix the tss_descr, I will build the
> V4 patchset based on that fix.

Don't worry, there's a lot more work to cleanup GDT/TSS/IDT and I don't 
want to "force" you to do that.  Let me go on with the review of this 
series so that you can concentrate on the UEFI bits.

Paolo

