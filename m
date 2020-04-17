Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80281AD6A0
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 09:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgDQHAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 03:00:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31127 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbgDQHAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 03:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587106845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HHXuJKrO3Zwa2hpy5yi+VWtyY5H3hj/QRMxFcZxvFA=;
        b=C2R/JxqvUg2ZyEekbnFzbMtdpvXKtCu0VSS1ORca+Dh0zl2K8kJJ0cZCwpkqj1EczzT/9i
        t15pAWeoLnEYSZcrOHb0uRe8vWFjdxptRczF4U9hRxcztaqUdBFsvVwx+gwivHMugX1qyD
        zvCyj4rRUv49RjNvTDbCcXMLME8xtMo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-YOLEoAtzMLSywjmjf8RXGQ-1; Fri, 17 Apr 2020 03:00:44 -0400
X-MC-Unique: YOLEoAtzMLSywjmjf8RXGQ-1
Received: by mail-wr1-f71.google.com with SMTP id f15so550924wrj.2
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 00:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5HHXuJKrO3Zwa2hpy5yi+VWtyY5H3hj/QRMxFcZxvFA=;
        b=gPqFV9bzp/74ME2EJmHiIv4K+dkfXL2Zd04wnVImQyveauxcVGN4TZTdEVTlqj0Di4
         3JLn0eRqewArrHfocoKXHS7smrNuGoN1gaCJBgFmowvjLem9ReV2MDMGVtgTRP5vE6AH
         JaK4RLNrSAgb7JhXwi/RhhMWbZmnrhkC1dzVRYrP6uxrbCcAfYUS8T7GVp2nJohmQKEd
         VWrbhP8Rc6uUliSz62rKRmiNNgFaXRRM4qpxUF9jIJa+3mmVONsqraLYlO8KPHBzbxPI
         YVVsFzxmMx786PDMWdHG1gCD7kGXooorpddDJ6+QDpOQDf/ntINcYTRTt6xLV8hOYuol
         MRiA==
X-Gm-Message-State: AGi0PuYe4fdOkH1jb1+RXB4FkBjoHgnC7TDWoOD1lC0qOsrrdV/ThIN8
        84BlCSl/aWPCXY5k25Mz4iuKS02et+x1/yQreiaqzj6oe+WZin1xdUHCYur9Pl5yjuN4xP8w/Qf
        X/B3o54l/4LpX
X-Received: by 2002:a1c:f312:: with SMTP id q18mr1767779wmq.175.1587106842795;
        Fri, 17 Apr 2020 00:00:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypLt/8N+o0sdg/xJTUyaIHOADyaOks4w6ey9O5y5Wd4Q0ZIqdrRJDc5bg5Kn+qb/YznsDj4RbA==
X-Received: by 2002:a1c:f312:: with SMTP id q18mr1767758wmq.175.1587106842567;
        Fri, 17 Apr 2020 00:00:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id l15sm6387727wmi.48.2020.04.17.00.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 00:00:41 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] nVMX: Add testcase to cover VMWRITE to
 nonexistent CR3-target values
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200416162814.32065-1-sean.j.christopherson@intel.com>
 <d0423845-db40-b9ce-62b7-63bc36006a28@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b673c58-0440-883e-2a29-b06603e49aad@redhat.com>
Date:   Fri, 17 Apr 2020 09:00:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d0423845-db40-b9ce-62b7-63bc36006a28@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/04/20 03:35, Krish Sadhukhan wrote:
> 
> On 4/16/20 9:28 AM, Sean Christopherson wrote:
>> Enhance test_cr3_targets() to verify that attempting to write CR3-target
>> value fields beyond the reported number of supported targets fails.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>   x86/vmx_tests.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 1f97fe3..f5c72e6 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -3570,6 +3570,10 @@ static void test_cr3_targets(void)
>>       for (i = 0; i <= supported_targets + 1; i++)
>>           try_cr3_target_count(i, supported_targets);
>>       vmcs_write(CR3_TARGET_COUNT, cr3_targets);
>> +
>> +    /* VMWRITE to nonexistent target fields should fail. */
>> +    for (i = supported_targets; i < 256; i++)
>> +        TEST_ASSERT(vmcs_write(CR3_TARGET_0 + i*2, 0));
>>   }
>>     /*
> We don't need VMREAD testing ?

Patches are welcome. :D

Paolo

