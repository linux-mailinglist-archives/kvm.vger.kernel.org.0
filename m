Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A8A3EDA05
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhHPPjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:39:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236598AbhHPPjd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:39:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629128341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pvc9wD1lUPZTfEZnpljO9gINIugTu0C8zAih8i4bqK0=;
        b=SdXbXP6SqVC9WvomXX12B40sDd9XagEro4Q/4x+Ep/zckKCtYNjH5xWypyfdjHHSzLp7GZ
        GAqN7TQFl1wWB5hqFiUwH5qKH1RAomfJZGifSZXOF9hQQqVAQGVFyC+FUXhSE+18ODOqYv
        P7p//79DDlLpuUXEceCNiTqrGwH++7I=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-BtIk3FMGMhe3ZA_gZOEHwg-1; Mon, 16 Aug 2021 11:38:59 -0400
X-MC-Unique: BtIk3FMGMhe3ZA_gZOEHwg-1
Received: by mail-ej1-f70.google.com with SMTP id e1-20020a170906c001b02905b53c2f6542so4855603ejz.7
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 08:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pvc9wD1lUPZTfEZnpljO9gINIugTu0C8zAih8i4bqK0=;
        b=VVUJCsQGSNFAI7Z9T02G0lJ0iqBMhOouVl/ab97Uq5O+22iSO+vBeYt2WDOO0vmnPv
         L3hm8vSG+rMH9iKEYwXxzd83BVb3x9Q6esg6cHKhONfKOBWFvNUhr6yx6VeniFl18B+p
         mImuF0Vp4/TC/ZyKpTBHhA03Kv64oPTXU0Ul3o4rIgpCGxbVX+Fcou60n0Ku5z4BTZ9R
         QGSpdFZUsLpF6IC0zWfcc/FWYM66sgV3uCjI7qJhQY5Gtvo6ad19HBMFhlq5fn9PjeJP
         sWZCv2EaIhfcAXVUrHoTSDkeSr8uVEyXm+mltDsRvaXLAkk/PdQrEcp7Z73EJL65K/sW
         XhgA==
X-Gm-Message-State: AOAM532qqGhwOtYAOYEAcVcKeYEiI3vezO3XH8qqSNoEYIAHcSbs3Z+w
        lDDZt3BQ0zntW4CXq+n3ytxTEkJZJMU37DGhqfj6oTZxlwDKPf2zi+gVr8kDsawO7SJadRBCZVs
        w/cUPCMHSow/kMJpw9v+y++awLKEPRZ9wHR6PYXdcBwOG+rh4mBtujAIk/T07wPlt
X-Received: by 2002:aa7:c457:: with SMTP id n23mr21099036edr.89.1629128337949;
        Mon, 16 Aug 2021 08:38:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbx6t+UCiHCtE2k3BVUa1TE/xC6yoZ7+wjHEFzqAH3fHJRZmBdRJpiNntuibcz2UlNgdA5jQ==
X-Received: by 2002:aa7:c457:: with SMTP id n23mr21098999edr.89.1629128337731;
        Mon, 16 Aug 2021 08:38:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id hg25sm3829443ejc.109.2021.08.16.08.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 08:38:57 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     qemu-devel@nongnu.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <20210816144413.GA29881@ashkalra_ubuntu_server>
 <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
 <20210816151349.GA29903@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
Date:   Mon, 16 Aug 2021 17:38:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816151349.GA29903@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 17:13, Ashish Kalra wrote:
>>> I think that once the mirror VM starts booting and running the UEFI
>>> code, it might be only during the PEI or DXE phase where it will
>>> start actually running the MH code, so mirror VM probably still need
>>> to handles KVM_EXIT_IO when SEC phase does I/O, I can see PIC
>>> accesses and Debug Agent initialization stuff in SEC startup code.
>> That may be a design of the migration helper code that you were working
>> with, but it's not necessary.
>>
> Actually my comments are about a more generic MH code.

I don't think that would be a good idea; designing QEMU's migration 
helper interface to be as constrained as possible is a good thing.  The 
migration helper is extremely security sensitive code, so it should not 
expose itself to the attack surface of the whole of QEMU.

Paolo

