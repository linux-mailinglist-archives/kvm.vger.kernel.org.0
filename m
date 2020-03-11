Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B0181FD5
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 18:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbgCKRpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 13:45:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46526 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730666AbgCKRpG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 13:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583948705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rW7pu79lKkKAPsdVQOo/aJ4urBOrtpq5oK5W7qCpQMY=;
        b=E4nYMCIrGWKW+1xY69Ew/e8DzYWPVuIWgdFcuGBUGoNJUQh29C6XydCIHbk0QdBaCtLFM7
        zvAStnMXBC3LyamxuZr5oJNO+2yb9Nd538P3Gs7c2IQk/c0D0TIFMcToNtlzsIXhM1O2VX
        HYaIcrtPEIw5NwF6SJ/nyp06bbaiI4M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-9cjQnBF7NIWlWlV43KyHAw-1; Wed, 11 Mar 2020 13:45:03 -0400
X-MC-Unique: 9cjQnBF7NIWlWlV43KyHAw-1
Received: by mail-wm1-f72.google.com with SMTP id w12so902720wmc.3
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 10:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rW7pu79lKkKAPsdVQOo/aJ4urBOrtpq5oK5W7qCpQMY=;
        b=EH56rPZw+w+AI4ULfPhEa0FPoYuY7gNX5bSX6xQOE2Zs2UnLuqloSHkk9Bf+M9knNH
         NR3p7ZFEFnPHFIaiykj78fp8WLAF837OTVwB3pZOAKO2JqIUjzrtROtycNYXKR3ZvzTD
         NM9IyHgjA6qJSGA0TGY1fvWnAbpAUPNhBRVj4bMVINpwXvqO//l/b/YVc/zrUZ6JMmla
         JD0cTCIaH0VqmkqERAXj+jp2nlQO7K3ywwBwfyQSscKX3Sq5WSKILzhhaKd0l9Dy/VTe
         u+XCd+oianLDORaW7xdM46L6+M0ecoLJ11IYp2J7Rxy4FVBTAEJ5SpiOe3yRppR2quR8
         pxvQ==
X-Gm-Message-State: ANhLgQ1QY/6CapF1O+Dki0KrvQUdSo0bEyEl/KFqOVBxW15qE8xWXCLz
        st9DfnCLdWRpD9ZLoWmT7Xi6LF7pTA4jo5RMZetZsnY1xf96Dqwo7Da1AnbcxGeCEJ6SbuvjAC5
        0cSS8d5DKetbn
X-Received: by 2002:a1c:4805:: with SMTP id v5mr770348wma.98.1583948702488;
        Wed, 11 Mar 2020 10:45:02 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvb2cSXhwPBa8avHtfP3up4fDySjC14dqD45ZcSdTFyPdocWJAOkwI8QHYiJr+lnsYF+iTknA==
X-Received: by 2002:a1c:4805:: with SMTP id v5mr770331wma.98.1583948702237;
        Wed, 11 Mar 2020 10:45:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4887:2313:c0bc:e3a8? ([2001:b07:6468:f312:4887:2313:c0bc:e3a8])
        by smtp.gmail.com with ESMTPSA id a13sm340949wrh.80.2020.03.11.10.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 10:45:01 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: nVMX: nested_vmx_handle_enlightened_vmptrld()
 can be static
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
References: <20200309155216.204752-4-vkuznets@redhat.com>
 <20200310200830.GA84412@69fab159caf3> <87d09jaz7q.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6fbd3df7-2fb6-337c-a9ce-e663f3742009@redhat.com>
Date:   Wed, 11 Mar 2020 18:45:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87d09jaz7q.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/03/20 12:49, Vitaly Kuznetsov wrote:
> kbuild test robot <lkp@intel.com> writes:
> 
>> Fixes: e3fd8bda412e ("KVM: nVMX: properly handle errors in nested_vmx_handle_enlightened_vmptrld()")
>> Signed-off-by: kbuild test robot <lkp@intel.com>
>> ---
>>  nested.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 65df8bcbb9c86..1d9ab1e9933fb 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1910,7 +1910,7 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>>   * This is an equivalent of the nested hypervisor executing the vmptrld
>>   * instruction.
>>   */
>> -enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>> +static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>>  	struct kvm_vcpu *vcpu, bool from_launch)
>>  {
>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>
> 
> Yea,
> 
> I accidentially dropped 'static' in PATCH3, will restore it in v2.

No problem, I will squash.

Paolo

