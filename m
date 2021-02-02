Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC12630C901
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238156AbhBBSG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:06:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238212AbhBBSEt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 13:04:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612289003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mLPn7R460RnvC3cVkzpTkUrq1JeELO52BKdk3debVIg=;
        b=POwiJ7SW4jjuLVWoR+c7itUbsA/B4tn4/WEhQ1VwhmmVh8VrYK1F65BWk7cVr7YPhEfldF
        87dR0wujdk8idNTbu1Golwng/o3JlQni4DkPlA7ezzH3XYpIh+M7m10gfZ0a+kpSImwfNJ
        EdNXkoCUal1bsNdVK6M4jpdD0gglags=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-dPb05ZMAOEmJJ5Bbxa9q2g-1; Tue, 02 Feb 2021 13:03:20 -0500
X-MC-Unique: dPb05ZMAOEmJJ5Bbxa9q2g-1
Received: by mail-ej1-f69.google.com with SMTP id ox17so10350309ejb.2
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:03:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mLPn7R460RnvC3cVkzpTkUrq1JeELO52BKdk3debVIg=;
        b=VjOwTEikOqi1d1kAqBrSBe4C6H6D9FbSjKDz2Z4gHbk/vussuvsrNtV6XFzRvM96lc
         vmWFd78N+Wpn0OED+tiplsPx3Iwe1IFkgt3cgxAWjLILVx+ZV8mgP2mNbA1Lh5sGHCKa
         ujrHaxQRgQuQlXDyA22YDuG44SqyORc/n0Umdy/z9+8Moi3e9IffW7Qjc9J9kcOf3WlB
         lXFmG7L3iNw4FtP0g+OruPvQ/9Lq4v6cTMBol0rZ3ZfE6nAcA8SZkMiG7kSax58+hoQT
         D4FLHJuqauVL5xxyD2clghWs7EtpyaGLphQoZaITQbE0SH8IDgI6c2zJYPq4JHQnSZN9
         o6KA==
X-Gm-Message-State: AOAM530bRmjT/Sxe+lUV91CS4L7D4KwwqRttygXtDsfOvGSh48ah7uZN
        j5dHP1FGr4J+nGImftbmpwYafMtTsyMNzdn6xemuqjh4/YjQZ/zlM9t5W4Syox99cIMSpbfXDtW
        KMkQub4LTd+1A
X-Received: by 2002:a17:906:178d:: with SMTP id t13mr23170036eje.455.1612288999408;
        Tue, 02 Feb 2021 10:03:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzADgOhy6qNZuRtdUs4hh0I8tuFK0SynhOmPwZtOUx5lL+jJiUlY5P4NVnCn9SVSxL6EgWhzg==
X-Received: by 2002:a17:906:178d:: with SMTP id t13mr23170023eje.455.1612288999265;
        Tue, 02 Feb 2021 10:03:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm9567406ejd.110.2021.02.02.10.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 10:03:18 -0800 (PST)
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
To:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, haitao.huang@intel.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
References: <cover.1611634586.git.kai.huang@intel.com>
 <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
 <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
 <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
 <YBVdNl+pTBBm6igw@kernel.org>
 <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
 <89755f15-a873-badc-b3d6-d4f0f817326e@redhat.com>
 <87a8a3f4-3775-21f1-cb67-107cca1a78e5@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <88e25510-a2e0-c4b8-4dcf-0afb78d5532c@redhat.com>
Date:   Tue, 2 Feb 2021 19:03:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87a8a3f4-3775-21f1-cb67-107cca1a78e5@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:00, Dave Hansen wrote:
>> /* "" Basic SGX */
>> /* "" SGX Enclave Dynamic Memory Mgmt */
> Do you actually want to suppress these from /proc/cpuinfo with the ""?
> 

sgx1 yes.  However sgx2 can be useful to have there, I guess.

Paolo

