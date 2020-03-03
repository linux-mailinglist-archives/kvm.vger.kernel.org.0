Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA64177AB0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgCCPkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:40:39 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728002AbgCCPkj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 10:40:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583250038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SrF8JSKjOdBJZVRt/AXRACdTMcBXv4bNXWLtdukx5fQ=;
        b=Vvima3lg/ohuO+4hUnbJ/eyd0QAACqNLwOyERywRa1uPRbdXWW770VCEg1wXXjrINnggjX
        4qzVl4GXz1DeSJe2Y1x9qwieHiBTrNvkZGVRVVqYY6aaHtOXVjYEioI2AVW220vm4XmteB
        IOj1fAXsRX3Ebln/MS1z+CFEc1T/Eww=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-Z23hPRfCPJGfEaRIYPTOWg-1; Tue, 03 Mar 2020 10:40:36 -0500
X-MC-Unique: Z23hPRfCPJGfEaRIYPTOWg-1
Received: by mail-wr1-f72.google.com with SMTP id m13so1398009wrw.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 07:40:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SrF8JSKjOdBJZVRt/AXRACdTMcBXv4bNXWLtdukx5fQ=;
        b=ZG3LuPqNbjqoZWRCekFLhL+BL/naFhMpTLEOnnW7BuiflkbYXran1Ye5JKwNHqSfhK
         FxZ5SL8uF53ej+BAlwM8J9bKDLA4hK+ua3FG0TF3yd6p92rS76jYl4MIyFVjNhe+PUh6
         DK6aAgOSdo80Np3KjWK9S8RLcHlMU3E8j2WdTaHJiFvR7r4hcLFlrX2I+ocqVqvsayyy
         Y9PzjcZYALuL8RIL282uur/1r+i3v7C8BTRoiJsxJIlxj2ZEpd4vbyZqjxnQLLIunAu2
         9YWxh610b6E3OHuK2p3bhVjlM5jF19RPTYhQXCt/VAjdUpI2pMOXAgFK+YnqEfsMNw+w
         bHVA==
X-Gm-Message-State: ANhLgQ2i6U+wqfCWU0v3hQ0A/FNpzxANTgJuiSdGpPGF6L+Dj76aF5RK
        cgLlhrDUL3/SD6rEVFDjDs25zfH93d9a8Dm8bbmVpHbvOhw1oTPRER23gYgmcgYnARaXgfqhUxt
        ayNTZ7Yf6omJ/
X-Received: by 2002:a7b:c446:: with SMTP id l6mr4718641wmi.94.1583250034919;
        Tue, 03 Mar 2020 07:40:34 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsIy7f/SKdW2QFW2LYYoV1RsOjaZ70eCj2/ll6a/OC6f6S6aofvunS899Akpq0Wiy7IoguI/Q==
X-Received: by 2002:a7b:c446:: with SMTP id l6mr4718619wmi.94.1583250034726;
        Tue, 03 Mar 2020 07:40:34 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id z10sm4378147wmk.31.2020.03.03.07.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:40:34 -0800 (PST)
Subject: Re: [PATCH v2 36/66] KVM: x86: Handle GBPAGE CPUID adjustment for EPT
 in VMX code
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-37-sean.j.christopherson@intel.com>
 <90df7276-e586-9082-3d80-6b45e0fb4670@redhat.com>
 <20200303153550.GC1439@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c789abc9-9687-82ae-d133-bd3a6d838ca5@redhat.com>
Date:   Tue, 3 Mar 2020 16:40:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303153550.GC1439@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 16:35, Sean Christopherson wrote:
> Oof, that took me a long time to process.  You're saying that KVM can
> allow the guest to use GBPAGES when shadow paging is enabled because KVM
> can effectively emulate GBPAGES.  And IIUC, you're also saying that
> cpuid.GBPAGES should never be influenced by EPT restrictions.
> 
> That all makes sense.

Yes, exactly.

Paolo

