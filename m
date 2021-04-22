Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B357D367B3F
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhDVHkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:40:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230285AbhDVHkY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 03:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619077189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=am3oqcwbAZTewEAL1q1sVytef24ZvvJQGjQNV10DXgc=;
        b=GrCMllvSBB5nQikp3L+H/BehBzbqusbciq17rGcTjUTcdS89wdMnhJczjRXlXi7nWSCT7L
        zdXP6wP4BC8hLa6ueggQZYu1+kzp4jnaFZ4kzWKWDmShHb0b0XQ3560o2u7ZJgWXkS+9Q3
        Cx69wj6mDf5Zom1IsXve80CHzidiFlg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-mVm3a7ZGM1iMYJvzIo5ypQ-1; Thu, 22 Apr 2021 03:39:47 -0400
X-MC-Unique: mVm3a7ZGM1iMYJvzIo5ypQ-1
Received: by mail-ej1-f69.google.com with SMTP id ne22-20020a1709077b96b02903803a047edeso5557575ejc.3
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 00:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=am3oqcwbAZTewEAL1q1sVytef24ZvvJQGjQNV10DXgc=;
        b=G5vszEdAsYlWGtBViBtNPcbWMY2gwsKcER7HhYvCrZodqRilVHgAzOFI+HRqaYee8K
         SOUPKcMyqePr/O6DBkYs/RW7BI+qPMImpW/swzPDNqgcqcvNWu1x/KkoK5HpO2ruedkz
         XCTAvlm8Lq52+I/jiQ4qkNPMQPLPr1MsMbkaA0Z++UCHH7nZqTD/Js+AgHZYJNqr1m9C
         KpMcMJ9yO1beVQAjTs9C079PvsHdR7Qj+ofRhPgZQBzT4KIRc9Cnsscdlx8QIvuJAJXd
         PZ4pik/oPgkOf36Apb92QywMJuJQggOhi8k6SFFDTepX8m19WzOLV3sbDFMU1IBseRds
         edwg==
X-Gm-Message-State: AOAM533AuyFJMZ5mHZU85QkkaXwcpjZF+NRrqb7odEJqFW2fPH220i6t
        NGNdZ3TEvUw2cYKNi7vhfpQALxQBLMTTA4mMlagNB3NEa4YmsS1smuPNFy6feRAtWInzEeYfFDj
        YNGfEAt1iikGtWboYfvhD7Oupu7dG4nXxemksqrqBfHn/3tQEorj4VRp1h0LWZrZ2
X-Received: by 2002:a05:6402:2216:: with SMTP id cq22mr2110190edb.265.1619077186253;
        Thu, 22 Apr 2021 00:39:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXe6pUNVLy4SO311qYFQSldx6jeUN9EJ6GcueT0+4hhV+Bw8HtI6VFQxxnnAjdrxiij30c1g==
X-Received: by 2002:a05:6402:2216:: with SMTP id cq22mr2110170edb.265.1619077186016;
        Thu, 22 Apr 2021 00:39:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a17sm1255511ejx.13.2021.04.22.00.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 00:39:45 -0700 (PDT)
To:     Thomas Huth <thuth@redhat.com>, Jacob Xu <jacobhxu@google.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20210421191611.2557051-1-jacobhxu@google.com>
 <edc3df0e-0eb7-108d-3371-2e13f285d632@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] update git tree location in MAINTAINERS to
 point at gitlab
Message-ID: <97adb2d3-47f4-385a-18b4-90572c9f486a@redhat.com>
Date:   Thu, 22 Apr 2021 09:39:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <edc3df0e-0eb7-108d-3371-2e13f285d632@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 05:42, Thomas Huth wrote:
> On 21/04/2021 21.16, Jacob Xu wrote:
>> The MAINTAINERS file appears to have been forgotten during the migration
>> to gitlab from the kernel.org. Let's update it now.
>>
>> Signed-off-by: Jacob Xu <jacobhxu@google.com>
>> ---
>>   MAINTAINERS | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 54124f6..e0c8e99 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -55,7 +55,7 @@ Maintainers
>>   -----------
>>   M: Paolo Bonzini <pbonzini@redhat.com>
>>   L: kvm@vger.kernel.org
>> -T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
>> +T:    https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>

You're too humble, Thomas. :)  Since Drew and you have commit access 
this could very well be:

diff --git a/MAINTAINERS b/MAINTAINERS
index ef7e9af..0082e58 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -54,8 +54,9 @@ Descriptions of section entries:
  Maintainers
  -----------
  M: Paolo Bonzini <pbonzini@redhat.com>
+M: Thomas Huth <thuth@redhat.com>
+M: Andrew Jones <drjones@redhat.com>
  L: kvm@vger.kernel.org
-T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
+T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git

  Architecture Specific Code:
  ---------------------------

And also, while at it:

diff --git a/MAINTAINERS b/MAINTAINERS
index ef7e9af..0082e58 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -92,3 +94,4 @@ M: Paolo Bonzini <pbonzini@redhat.com>
  L: kvm@vger.kernel.org
  F: x86/*
  F: lib/x86/*
+T: https://gitlab.com/bonzini/kvm-unit-tests.git


