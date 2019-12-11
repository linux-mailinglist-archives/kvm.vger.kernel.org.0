Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E921611A676
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 10:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfLKJID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 04:08:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48600 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbfLKJIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 04:08:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576055281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y+7CWlGvo3J1aqX5URICLxANHtApPrtUz6Ly50hT0k8=;
        b=eUU0+R8rlkWJu6UV9lzVPzoCZe/eXLpqO0TlaFKr4wVW20lMflNVcbcrp/AsJQYx6b0FG1
        rwDmHqkWrbI1LRQJgY5RQ68DkkRx37LJu1+fBMhCFAr0TpKY2w3pZazRi4v+SRM0G9u5rz
        DlCL53n2J2Q4vxNpAiveveooJ3dyDLU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-gg8HbXx6MGC_n8iYldd0ag-1; Wed, 11 Dec 2019 04:07:58 -0500
Received: by mail-wr1-f71.google.com with SMTP id f10so722781wro.14
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 01:07:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y+7CWlGvo3J1aqX5URICLxANHtApPrtUz6Ly50hT0k8=;
        b=ApJh5x0Ex+bHW8dZzO9TOXUP88BEdDIKy1Jq9VnKMEQmXlT01ECvml0OMVTSHdac8Z
         u6ZXxAsGfGJLuCShokw/hSFRYMDYgjmV0LKeGrFgTsnoDHULs4wI5MPh4nkEvTW+kCc4
         nChUvSX8WYAgVb9wuJY/fSo9GMuo3xqjAJ89hCO3R1Cp91YdrWDyp1HM5/DtiMia8ADs
         bOVeGLqIOkbuvz0QeEFkvKHjjGqUqqH7jwESjRuBJRt+del83KRgUJD0oXzqIOfyuCL1
         2amew+XXt420QoIIX+pp7Cw1Kaa+q2WLgxBgsKZn22rz5Z5vm101SupxlRYvxpM9IcV3
         IEhA==
X-Gm-Message-State: APjAAAXiE4aml+hzT7nNoel3y89uQojMEBA9jf+ZGgEGeFei5/xF/7sj
        oK+NPPgT9onw+LY7lFkT6oVHZgnLLuPvdvJtLT1QL/eEqHXP4xix4ZV+zZbA6jXyEQSm7J26JlJ
        nclV9Avh9mheF
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr2392695wrw.255.1576055276749;
        Wed, 11 Dec 2019 01:07:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqyk530KPtCatGmVOoZqOVtdEa4CHIdMd2QUgErjQSW25mSow9KbdltraJ00JOs309bCAh7DDw==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr2392670wrw.255.1576055276544;
        Wed, 11 Dec 2019 01:07:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id g2sm1496891wrw.76.2019.12.11.01.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 01:07:55 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     "Huang, Kai" <kai.huang@intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
 <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
 <7b885f53-e0d3-2036-6a06-9cdcbb738ae2@redhat.com>
 <3efabf0da4954239662e90ea08d99212a654977a.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <62438ac9-e186-32a7-d12f-5806054d56b2@redhat.com>
Date:   Wed, 11 Dec 2019 10:07:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <3efabf0da4954239662e90ea08d99212a654977a.camel@intel.com>
Content-Language: en-US
X-MC-Unique: gg8HbXx6MGC_n8iYldd0ag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 01:11, Huang, Kai wrote:
>> kvm_get_shadow_phys_bits() must be conservative in that:
>>
>> 1) if a bit is reserved it _can_ return a value higher than its index
>>
>> 2) if a bit is used by the processor (for physical address or anything
>> else) it _must_ return a value higher than its index.
>>
>> In the SEV case we're not obeying (2), because the function returns 43
>> when the C bit is bit 47.  The patch fixes that.
> Could we guarantee that C-bit is always below bits reported by CPUID?

That's a question for AMD. :)  The C bit can move (and probably will,
otherwise they wouldn't have bothered adding it to CPUID) in future
generations of the processor.

Paolo

