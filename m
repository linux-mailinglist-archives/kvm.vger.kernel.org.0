Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239302D10D2
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 13:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgLGMrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 07:47:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgLGMrk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 07:47:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607345173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tyOz5Tc9PqhiNlZWIQPWc0O+She1E1/qQZR6bIJl32A=;
        b=TFT5gCyh0sYW7vZSRiFYl044JhkHSyrllUZ+Tn6h2CWvo6JckS5E2WEu4QjjInEM3MVe0c
        c8wLxb4/ebw9CQsTy+B9UkGOMjN3oh738XxcHDcjVTIHM3LdLXySiBsmAMKZJSFyMkoICc
        5taaEZOGfFRzACDXHEpWXvOAZqmZius=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-OX_cxnIgOoe3cygcb1rAsw-1; Mon, 07 Dec 2020 07:46:12 -0500
X-MC-Unique: OX_cxnIgOoe3cygcb1rAsw-1
Received: by mail-wr1-f69.google.com with SMTP id 91so4743384wrk.17
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 04:46:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tyOz5Tc9PqhiNlZWIQPWc0O+She1E1/qQZR6bIJl32A=;
        b=kfqw2Nr1ifpVXM7UL0fUIsLIIabyUSGMpAzX0RnYKi8OV9/zJPGYjalxXykeeXihUn
         lzaOOdYrbBebhp7fAJJ6XKWEH4DVSpxn2Vr4bCucg/gC5misGGnBwRTOLs2jNkKYKcZE
         fCt5pUJlllEHnGBepws4AOwCti3Lpjqm5maviEQ2bN2IEGGYWP1FmbNrGuVmq8cA/Y1G
         jZbg83dq7WFcrXiGxR7ThPFeqpmMuAgY9s+Js8TFbx4D4sSj16fobKEMz4PkzmbgkaYD
         R5b5ima+XOaRvS2FGLRYQbk5dEAnvKfmYMPWWn/zIid7w5zXQMqV/aPl+hqDfsPBl1WP
         6PjA==
X-Gm-Message-State: AOAM530yLQ9eZJfuqPueYMLRFnrne9CYoRy+MQl47D1qlusI5xhSD4nd
        4Vz4TlFEpRkDDdpueiVsXMt25SZtfS49hMi/lHSS5k5VEdhOFXicxDosDX56/HhUMYTxv6OK8aw
        DTD7G2OG2sFxM
X-Received: by 2002:a1c:9d8b:: with SMTP id g133mr18420818wme.189.1607345170870;
        Mon, 07 Dec 2020 04:46:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxp1cQ0YqyVCzSrPnn6i9/5M4B45ElmdNAkkARQoGv3NPSs4feaDlLXpquqrHa2sqmKk3jUew==
X-Received: by 2002:a1c:9d8b:: with SMTP id g133mr18420802wme.189.1607345170698;
        Mon, 07 Dec 2020 04:46:10 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h20sm13745748wmb.29.2020.12.07.04.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 04:46:10 -0800 (PST)
Subject: Re: [PATCH v2 5/5] gitlab-ci: Add Xen cross-build jobs
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>, qemu-s390x@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>
References: <20201207112353.3814480-1-philmd@redhat.com>
 <20201207112353.3814480-6-philmd@redhat.com>
 <9bfd1ed4-baa2-ece8-5b96-ec8fc7a8c547@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <c335d1f5-e8cb-a9c2-9718-822dc0248fda@redhat.com>
Date:   Mon, 7 Dec 2020 13:46:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <9bfd1ed4-baa2-ece8-5b96-ec8fc7a8c547@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 12:51 PM, Thomas Huth wrote:
> On 07/12/2020 12.23, Philippe Mathieu-Daudé wrote:
>> Cross-build ARM and X86 targets with only Xen accelerator enabled.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  .gitlab-ci.d/crossbuilds.yml | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
>> index 7a94a66b4b3..31f10f1e145 100644
>> --- a/.gitlab-ci.d/crossbuilds.yml
>> +++ b/.gitlab-ci.d/crossbuilds.yml
>> @@ -135,3 +135,18 @@ cross-win64-system:
>>    extends: .cross_system_build_job
>>    variables:
>>      IMAGE: fedora-win64-cross
>> +
>> +cross-amd64-xen:
>> +  extends: .cross_accel_build_job
>> +  variables:
>> +    IMAGE: debian-amd64-cross
>> +    ACCEL: xen
>> +    TARGETS: i386-softmmu,x86_64-softmmu
>> +    ACCEL_CONFIGURE_OPTS: --disable-tcg --disable-kvm
>> +
>> +cross-arm64-xen:
>> +  extends: .cross_accel_build_job
>> +  variables:
>> +    IMAGE: debian-arm64-cross
>> +    ACCEL: xen
>> +    TARGETS: aarch64-softmmu
> Could you please simply replace aarch64-softmmu by arm-softmmu in the
> target-list-exclude statement in this file instead of adding a new job for
> arm64? That should have the same results and will spare us one job...

Ah, I now see my mistake, this is not the job I wanted to add,
I probably messed during rebase. I'll respin with the proper
xen-only config.

> 
>  Thanks,
>   Thomas
> 

