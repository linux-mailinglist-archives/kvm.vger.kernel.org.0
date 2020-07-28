Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE072314A6
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 23:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgG1VdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 17:33:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:30601 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729243AbgG1VdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 17:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595971984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tRkGnyzqKHRRkTXTWcsNzSOxx1eWlUkHoONVn8oVbU=;
        b=H80t/34dV/TM/hUmHDn3hGfohAQeRjAwv6zhq+TDW0S2iZhVv6EgPoDKrTvdHjWJkoowpb
        uqIDIfg/emlC6IDdz3Mb58nZ5YSEEiP67H/svDgTvqDOsh0Av6Dymd40I/43XpDp6JYg++
        R+kyt1h5GzEFwvSuuty+LCl3GXMkSxs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-GHdEguXyM7ao4rVmbcP8jA-1; Tue, 28 Jul 2020 17:26:54 -0400
X-MC-Unique: GHdEguXyM7ao4rVmbcP8jA-1
Received: by mail-wr1-f70.google.com with SMTP id m7so5745755wrb.20
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 14:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4tRkGnyzqKHRRkTXTWcsNzSOxx1eWlUkHoONVn8oVbU=;
        b=SfGXGO84x8xFPxkvD1i6EweIda0eDNNgO6+BTuXd6skJf4b5pmsvAGJpQbNcA/DWaj
         5jL03CqJkEbWhbrEVt049pNxmnMAa85oN2iCwra04ZvvSzPCrevPyO9sX5MV2pUQtm4x
         469VMWX1mXtySyQAuHGGGKRUo9i9ipnwPl2akqu/Qs1jtp6ABhHRp6ZIpuU7nyskh71u
         4zkPVQGwgOSxHI66PjKgiECV9sF1XZFVaFdrKMimzduNpeb27qn6nyrA+wwkRRomccjK
         BVhlg7/lsiDXLk+BN6BLEVNaOFgXP7cJgqs5Ftape5Kofe83Y5T/+xJ6kxfq9KhiePI5
         +Bkw==
X-Gm-Message-State: AOAM5336KsWZC+9MslnxbB4aD7mb5gBKMAR1TsiyZMagVwRg8iJExAh9
        4G44N5f3ONl5hu7YGv4vlaaqP6AWJ2yH19RbIps/ayeH5UpCh28OtH6nfqheE8Wh2C0eK8fFPLe
        0gZNwHFL8KErR
X-Received: by 2002:adf:eccc:: with SMTP id s12mr29669297wro.157.1595971612918;
        Tue, 28 Jul 2020 14:26:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPd9ABSQmgySw61onPkT/4kcEyW91Hbgc8a5AzA1wJikfOsBOAoNxBdYfY0N8gdvg2NU+HrQ==
X-Received: by 2002:adf:eccc:: with SMTP id s12mr29669289wro.157.1595971612740;
        Tue, 28 Jul 2020 14:26:52 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id p6sm285417wmg.0.2020.07.28.14.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:26:52 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/2] nVMX: Two PCIDE related fixes
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Karl Heubaum <karl.heubaum@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20200714002355.538-1-sean.j.christopherson@intel.com>
 <e96bc66b-856e-7454-28fb-7662343c4940@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c03a6d6a-80dd-b88a-a04b-e1e780114376@redhat.com>
Date:   Tue, 28 Jul 2020 23:26:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e96bc66b-856e-7454-28fb-7662343c4940@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/20 23:31, Krish Sadhukhan wrote:
> 
> On 7/13/20 5:23 PM, Sean Christopherson wrote:
>> PCIDE fixes for two completely unrelated tests that managed to combine
>> powers and create a super confusing error where the MTF test loads CR3
>> with 0 and sends things into the weeds.
>>
>> Sean Christopherson (2):
>>    nVMX: Restore active host RIP/CR4 after test_host_addr_size()
>>    nVMX: Use the standard non-canonical value in test_mtf3
>>
>>   x86/vmx_tests.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> 

Queued, thanks.

Paolo

