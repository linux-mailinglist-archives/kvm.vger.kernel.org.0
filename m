Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E5F52CFCD
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 11:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbiESJxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 05:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236073AbiESJx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 05:53:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 140937CDE4
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 02:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652954006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X4Hc7oPg7Dc4v7R501n1E+y9g1lc145Wm50Xy6t9M6E=;
        b=CCA/y9psPeAwM17wwqMCp5N//6y1IPKo6IxJBA2Zg48zyESUozKBdSSvyPJw5rp+aZkqdO
        dhwGCTJoA0LqMdvt6/AwiYAAlZZMYoVVbvs8EL68RXwXsA8DkExIfO1nZvt4WLq+DrzdiS
        /NekvNsK+JncAXS9mYdqysDVjHyiYsY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-u60RSznPP9eYlDMeM7928g-1; Thu, 19 May 2022 05:53:24 -0400
X-MC-Unique: u60RSznPP9eYlDMeM7928g-1
Received: by mail-wm1-f69.google.com with SMTP id e9-20020a05600c4e4900b00394779649b1so4291676wmq.3
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 02:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X4Hc7oPg7Dc4v7R501n1E+y9g1lc145Wm50Xy6t9M6E=;
        b=N8K0BvalXfvT4IAO/S0AEYS+G+UKOJsbSJJXiEqkC56QSBPIs5KArtuR+pdVaD9Xm3
         +pFdUFIOZihk6x5EK8m24JitZfGFvVLELakt9RljB7lUisUMsOGWQXfTxDwtHf7k8ggg
         TIMYZ+55oG+p38tM9eDPJDSECt40VyMl5bUa8U5H+o0XExerPEf0PfypUi9jZRou5SPL
         ywneBnQH/SMSrh1/WtExo6gfkr608yG+q1yTZSYU3W2KCwWjBGYxyEHgZq1Pi+lbZDvv
         L3G2bXTUochjSnFVOMCKdUPy71Sjir5XkGyKkz4YNPDzv/g6P/dk0SxgHWDHZYcoYCNv
         wa5g==
X-Gm-Message-State: AOAM532ZILZC1o4xJcNJmDT2LnvHOwxMQvPtLelMWguz/r0dl8q0Yr5g
        a5ii1JzsLDfczrKUHG8UgfHuzd3T5iJNnETWHivc7jHeRg8TJ3G+OL35UEDm03LfZpGiG9UEpvT
        masygCZosPbel
X-Received: by 2002:a05:600c:3c8b:b0:397:2db3:97a8 with SMTP id bg11-20020a05600c3c8b00b003972db397a8mr2050911wmb.132.1652954003576;
        Thu, 19 May 2022 02:53:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwClD6Xl1wuZOXw6WIEnqYp08A4B6e8M299sztnFOoq+Ug7DGA2wBVM29sLRHSf8KLSpWntcQ==
X-Received: by 2002:a05:600c:3c8b:b0:397:2db3:97a8 with SMTP id bg11-20020a05600c3c8b00b003972db397a8mr2050899wmb.132.1652954003382;
        Thu, 19 May 2022 02:53:23 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-176-97.web.vodafone.de. [109.43.176.97])
        by smtp.gmail.com with ESMTPSA id j38-20020a05600c1c2600b00395f15d993fsm6827506wms.5.2022.05.19.02.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 02:53:22 -0700 (PDT)
Message-ID: <5d48ad3f-a93a-0989-3872-cdff0bc6eb92@redhat.com>
Date:   Thu, 19 May 2022 11:53:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Dan Cross <cross@oxidecomputer.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <Yn2ErGvi4XKJuQjI@google.com>
 <20220513010740.8544-1-cross@oxidecomputer.com>
 <20220513010740.8544-3-cross@oxidecomputer.com> <Yn5skgiL8SenOHWy@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <Yn5skgiL8SenOHWy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2022 16.34, Sean Christopherson wrote:
> Adding the official KUT maintainers, they undoubtedly know more about the getopt
> stuff than me.
> 
> On Fri, May 13, 2022, Dan Cross wrote:
>> This change modifies the `configure` script to run under illumos
> 
> Nit, use imperative mood.  KUT follows the kernel's rules/guidelines for the most
> part.  From Linux's Documentation/process/submitting-patches.rst:
> 
>    Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>    instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>    to do frotz", as if you are giving orders to the codebase to change
>    its behaviour.
> 
> 
> E.g.
> 
>    Exempt illumos, which reports itself as SunOS, from the `getopt -T` check
>    for enhanced getopt.   blah blah blah...
> 
>> by not probing for, `getopt -T` (illumos `getopt` supports the
>> required functionality, but exits with a different return status
>> when invoked with `-T`).
>>
>> Signed-off-by: Dan Cross <cross@oxidecomputer.com>
>> ---
>>   configure | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 86c3095..7193811 100755
>> --- a/configure
>> +++ b/configure
>> @@ -15,6 +15,7 @@ objdump=objdump
>>   ar=ar
>>   addr2line=addr2line
>>   arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>> +os=$(uname -s)
>>   host=$arch
>>   cross_prefix=
>>   endian=""
>> @@ -317,9 +318,9 @@ EOF
>>     rm -f lib-test.{o,S}
>>   fi
>>   
>> -# require enhanced getopt
>> +# require enhanced getopt everywhere except illumos
>>   getopt -T > /dev/null
>> -if [ $? -ne 4 ]; then
>> +if [ $? -ne 4 ] && [ "$os" != "SunOS" ]; then
> 
> What does illumos return for `getopt -T`?  Unless it's a direct collision with
> the "old" getopt, why not check for illumos' return?  The SunOS check could be
> kept (or not).  E.g. IMO this is much more self-documenting (though does $? get
> clobbered by the check?  I'm terrible at shell scripts...).

According to https://illumos.org/man/1/getopt :

  NOTES

        getopt will not be supported in the next major release.
        ...

So even if we apply this fix now, this will likely break soon again. Is 
there another solution to this problem?

  Thomas

