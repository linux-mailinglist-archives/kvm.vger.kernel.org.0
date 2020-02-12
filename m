Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3080415A816
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgBLLnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:43:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56990 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725874AbgBLLnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581507793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IEsa1BUq0bWPEOZUtW+wdRfon7IBIMbGMK3y3jxH0WI=;
        b=XgqXDyTci9kc+rOUxebQ3foyNSJg5XWv6WzUhLjx7aMnxOrJhRSm7kkN3GTnYNT8C9wPE/
        vrO1BrQ2atawpUuQY+f1q0r9gvTdIwt5dEZNpZ9kXI0gxOoYLSnQpraiGOjllOA3VD0069
        TJdO7x9SIFBg9kb9kzrKqZAiE0SO8WE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-Ed_xZ-UNNneCQklGU0XylQ-1; Wed, 12 Feb 2020 06:43:11 -0500
X-MC-Unique: Ed_xZ-UNNneCQklGU0XylQ-1
Received: by mail-wr1-f71.google.com with SMTP id z15so718155wrw.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:43:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IEsa1BUq0bWPEOZUtW+wdRfon7IBIMbGMK3y3jxH0WI=;
        b=Zt86a6F1V2Wa+Hztu21mQr2R+su0arfEeSg/fQtVog6Vwnt8LBw3hj2wd9AaB/LZ6B
         ufrq7Jz5nAEVUI62AKZY3ikDDtvhyi/yLjuovuTzntSIUGs6husZxbLSCfa4G1Cck1N1
         iq3Jp+9xzE0G/jlZB/mWVZRRoe5lslIsQvItJgsqxeWbDm/THC+EwioE83AYZdEmpCJt
         JvsWPk6hZM3XD70NYx5qXV7kM0gJEEloOAMK4NXAKMO+x+j4m3UEEF6qWW6L9et5K3jl
         ZzT6hWgQ7aIN0w3Ije/ehVaCpb/vTAzwtVGcGovNTqTiI/UEaSuGmov/0O1A7rBwW6Aa
         /4EA==
X-Gm-Message-State: APjAAAWh9Ze6ngaWnTEE2nDhxXiu5qMVmHmEX4Xkc8FsAc8wAmfDbEND
        Z5IRLBezJpAn4Nt66FWT9UJMMVVCbtbqBI65xr43BTAc9jjfytGR/cxc1//WLm2d9Tkm6lTFU1O
        95WIUwC4INysi
X-Received: by 2002:a7b:c0c7:: with SMTP id s7mr13029515wmh.129.1581507790625;
        Wed, 12 Feb 2020 03:43:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvvGB6t9rTwkD5wOcWPzS3g4rf1aL3jnLVeGk4ga2e33TJdyaD2AbO4OgPZgsH90lWZaY+4Q==
X-Received: by 2002:a7b:c0c7:: with SMTP id s7mr13029498wmh.129.1581507790434;
        Wed, 12 Feb 2020 03:43:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id n3sm389509wmc.27.2020.02.12.03.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:43:08 -0800 (PST)
Subject: Re: [PATCH v4 3/3] selftests: KVM: SVM: Add vmcall test
To:     Auger Eric <eric.auger@redhat.com>, Wei Huang <wei.huang2@amd.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com, thuth@redhat.com,
        drjones@redhat.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-4-eric.auger@redhat.com>
 <20200206173931.GC2465308@weiserver.amd.com>
 <130c32bc-7533-1b4e-b913-d9596ed4e94d@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7f9c89b5-c1df-011f-917d-89d2e880049d@redhat.com>
Date:   Wed, 12 Feb 2020 12:43:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <130c32bc-7533-1b4e-b913-d9596ed4e94d@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 11:15, Auger Eric wrote:
>> Probably rename the file to svm_nested_vmcall_test.c. This matches with
>> the naming convention of VMX's nested tests. Otherwise people might not know
>> it is a nested one.
> From what I understand, all the vmx_* (including vmx_tsc_adjust_test for
> instance) are related to nested. So I'd rather leave svm_ prefix for
> nested SVM.

That is not strictly necessary, as there could be tests for Intel or
AMD-specific bugs or features.  But in practice you are right, "vmx_"
right now means it's testing nested.  We can rename all of them to
"nvmx_*" and "nsvm_*", but in the meanwhile your patch does not
introduce any inconsistency.

Queued, thanks!

Paolo

