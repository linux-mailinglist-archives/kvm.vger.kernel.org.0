Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593301EF64D
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 13:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgFELP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 07:15:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726782AbgFELP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 07:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591355757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8a2f7F+3vcKM6ztM/s5dArCF02jWdgvQcQyvf03Ew0=;
        b=It7x1aurSz7sqSBEFlTeOvv4g6OA/D+B1Oz5hIOro/lTp+uwYOCDZ4UeKJOUZ2EzEHLP+x
        ZunuzfhzXqwVsR0SJva1SnmqNc+KTVIOUgxjhMGVT9+V9PFuihmVAu4tiwR435AcVayW+5
        nhFYVp0J+NDYM+k2tWAE/dJa554WxMk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-35fq1nxMMOODF-vqnKjWtg-1; Fri, 05 Jun 2020 07:15:55 -0400
X-MC-Unique: 35fq1nxMMOODF-vqnKjWtg-1
Received: by mail-wm1-f70.google.com with SMTP id b63so3734322wme.1
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 04:15:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I8a2f7F+3vcKM6ztM/s5dArCF02jWdgvQcQyvf03Ew0=;
        b=owkX75tyv/WbVmBVYz8ToScoQY40KX3DH61bp0JiSbuzwRjZAWEgwuMtrFBqpZj274
         MHR7FwzDaTXWIkmUSeOlWj/O5GAbpTqnSjBJQa1UOmXnEIbh4ZjD/skF5Z1grDaZNcFa
         54U7CuyhCqJIgurD9B+OAWXSm6mukWoiZchXh8ZDzMSKvODVVPkLudhWeqwKq6l0mrGy
         Kjo/+z2pXba7s+xoZbv9l72NxPtQ4rn93SQoga2zpY5+ggNx+juDMIxKHrI9TpG6qlTS
         3+XYQqC1/jTCjJOSua9V27oFzGTPFJmUSgOYHH5asXjn/OfV2EyyCdXuI8gD0VM0osAh
         y7Zw==
X-Gm-Message-State: AOAM533WHCqd0JxoBabpumFql1S+dghRyLfd4f1YpaAgr+Mq+7ZrzeV8
        Y1msQ7KLXfX+J4aFi/NH+n7ESMhX3Q4wPe+y9/XBHdJU2xCF0mhvI0sW1okjw9/6DPl1gO+EYBw
        gbkX9XdZhSUSk
X-Received: by 2002:a7b:c951:: with SMTP id i17mr2133194wml.44.1591355754775;
        Fri, 05 Jun 2020 04:15:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVGG6rFBv8a0ZRPRpzrY2u/qF8bg879nEI6FUkBwSoWqVtIk43Mjl/J9pn3/3MezPpMKQYiA==
X-Received: by 2002:a7b:c951:: with SMTP id i17mr2133161wml.44.1591355754512;
        Fri, 05 Jun 2020 04:15:54 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.243.176])
        by smtp.gmail.com with ESMTPSA id q1sm10556883wmc.12.2020.06.05.04.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 04:15:53 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbUEFUQ0hdW3Y2XSBLVk06IFg4Njog?=
 =?UTF-8?Q?support_APERF/MPERF_registers?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        Like Xu <like.xu@linux.intel.com>,
        "like.xu@intel.com" <like.xu@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
 <be39b88c-bfb7-0634-c53b-f00d8fde643c@intel.com>
 <c21c6ffa19b6483ea57feab3f98f279c@baidu.com>
 <3a88bd63-ff51-ad70-d92e-893660c63bca@linux.intel.com>
 <c67d15322f9942aa92b6cf57011c0abe@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d4edabf8-b8c6-e60b-1a78-6aaa9bb7b5e1@redhat.com>
Date:   Fri, 5 Jun 2020 13:15:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <c67d15322f9942aa92b6cf57011c0abe@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 11:41, Li,Rongqing wrote:
>>
>> As you said, "Pass-though: it is only suitable for KVM_HINTS_REALTIME", which
>> means, KVM needs to make sure the kvm->arch.aperfmperf_mode value could
>> "only" be set to KVM_APERFMPERF_PT when the check
>> kvm_para_has_hint(KVM_HINTS_REALTIME) is passed.
>>
> pining vcpu can ensure that guest get correct mperf/aperf, but a user
> has the choice to not pin, at that condition, do not think it is bug, this wants to say

Also, userspace can also pin without exposing KVM_HINTS_REALTIME.  So
it's better not to check.

Paolo

