Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3840F1C9600
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 18:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgEGQHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 12:07:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43825 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgEGQH3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 12:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588867648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TVkUGlndYRsrJ6GuB0QJNmxWHRQpppH9nmOEYApMHa0=;
        b=Y9GYRe4tWUkf4o+XCYzAuTcdWSH98NILnKGe3cW9x7bsbPCjm64XeEq9L1jSQP8ugNFud+
        s0+EUN7oSjY3mqRaIC9RQWesv3eVypKHvE/OdAPVJAXft5cskI2QwSCPiYtsNirz8KwuiE
        eUxnJqTPwQ/9UkqPxijYNgNva8IK2Co=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-TG7rmntTO2qeoLxQ0MNHRg-1; Thu, 07 May 2020 12:07:26 -0400
X-MC-Unique: TG7rmntTO2qeoLxQ0MNHRg-1
Received: by mail-wr1-f70.google.com with SMTP id u4so3719922wrm.13
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 09:07:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TVkUGlndYRsrJ6GuB0QJNmxWHRQpppH9nmOEYApMHa0=;
        b=fEyS0sqxSMyIwc8k4DxY2nKCaiU/k98u7x6Rvfg0SmmksR24Ug7e6RM5UGNmsrZxOk
         8VPg5RM/J36Mu6LlfT2rFmo/e0CTMNyZL+GG6ljyCNUwvESv/YJLyIVPeC51sCVobUzP
         7KnUYuR3l0uAIHHDs5zjA2EViixb+CASAA3WPTZPCEOwm0G0Kb9tN2V5NvAHdQsOmIhH
         mUgeCZI9HESXBORi+AxS8Yw+9KXCT3c5BikAY3JTF1xv+CbYoXxaOSVUDowp4ZBGrcuY
         6TGdZoPuDqDAblSqhlnOVdchETRrDm+QNq1l3VGKeZnEiLpWNDpNnFU3gknKlhIx0PmX
         qrIg==
X-Gm-Message-State: AGi0PuYEsnJ8pL+zhQVtyaPrAej9xfAXBoIYuZR/OY7d8+suJWvlIQ0l
        Zinn4L7Yai6csTnLPR0GhniWEC1sl3npgLYGUr+oh5flQwptB5NC0I4ADTG84mXB9tT4beeq+tm
        K37cdzBO/mHKL
X-Received: by 2002:a05:6000:11cb:: with SMTP id i11mr16832754wrx.339.1588867643670;
        Thu, 07 May 2020 09:07:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypJrsnIwn711ocBoJ5VmUIXNnismQsGA3fzwGJOXjtTQBl/vtvfQv9CinCpMtfRVom3cfct6tA==
X-Received: by 2002:a05:6000:11cb:: with SMTP id i11mr16832692wrx.339.1588867643399;
        Thu, 07 May 2020 09:07:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id b22sm16622632wmj.1.2020.05.07.09.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 09:07:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] arch/x86: Rename config
 X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
To:     Babu Moger <babu.moger@amd.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, sean.j.christopherson@intel.com, x86@kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
 <158880253347.11615.8499618616856685179.stgit@naples-babu.amd.com>
 <4d86b207-77af-dc5d-88a4-f092be0043f6@intel.com>
 <20200507072934.d5l6cpqyy54lrrla@linutronix.de>
 <034cfb90-7f75-8e36-5b1e-ceaef0dfa50d@intel.com>
 <1aca7824-f917-c027-ef02-d3a9e7780c3b@redhat.com>
 <4ca2dd51-c30a-c400-146a-8079ac4526c6@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <97773339-adf6-eab4-fbbc-4e20bbb7e024@redhat.com>
Date:   Thu, 7 May 2020 18:07:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <4ca2dd51-c30a-c400-146a-8079ac4526c6@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 18:06, Babu Moger wrote:
>>> So, for now my preference would be to change the prompt, but leave the
>>> CONFIG_ naming in place.
>> I agree.
>>
>> What's in a name?  An Intel rose by any other name would smell as sweet.
> 
> How about X86_MPK? Or I will use already proposed name
> X86_MEMORY_PROTECTION_KEYS.

Dave is proposing to keep the CONFIG_ as is and only change the prompt.

Paolo

