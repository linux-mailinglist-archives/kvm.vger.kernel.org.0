Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A9E1F5C59
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 22:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgFJUCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 16:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbgFJUCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 16:02:41 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F33CC03E96B
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 13:02:40 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id n31so754209ooi.10
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 13:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qZencQASJRki6VdoOxeOIlcGGGCewAGYJOEcSk5Dgfg=;
        b=XPCKVMMke8Jf+Pi0GeiBzPCLOfLL99hToskxvMW9JaU93d5m/VZrbXmZ+BJHO2KYD2
         fd0PX66ZFMMUASpCcUTx+csortjmYseBTRm5zDvPp1sPEPWZlF5tFHPGZ+zKneKiMcbn
         w1WLGwVGRZWqrVddPQrdpY8vL3pEYAYieSbdk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZencQASJRki6VdoOxeOIlcGGGCewAGYJOEcSk5Dgfg=;
        b=l0g2qXZJiXeUWGv68Zdyrg1JvXverRLySFFHzBefn1KZV6A5dMQ7wyVKHLwJ+1WGuD
         +wluM8Ibz7Cz2noHr0NVdNmfK78KkK1SnS6sKk+74QCbwy0UFvO/8Y8sZEek1rkokrQN
         je2Vdodroc+gqDrb6Ro37pEGURSvPRyqGBPTWlsk6r2cYzf454FdRl6Z6ZnCyNy4WSSd
         +ZPOqhYmTg9siWM47erjBPA5P2TMm8VAkmrj0pR7tX0UJjuWvW3e2Ef7KmJpIQlOnTaB
         dEIBHdRDVn3x+ySGIK9xOszSmVOm0fjmYzLFhvlv9B5khwFT/T0sQbiyIunn52Za1VD/
         /4vA==
X-Gm-Message-State: AOAM530siGOmyC5kijyRmhoZW4uG4jJkdgDvzgurtb1jZ7hzbzaEmq4W
        DxHm9OscoKDX1NNWbA5iiid4Eg==
X-Google-Smtp-Source: ABdhPJx2LGg3UiOse93yQL2bCLbO3dMSH80eybn0HTimfQXaya+ujg9M8lnVVwZh1xpt3pxmPlsRUA==
X-Received: by 2002:a4a:e836:: with SMTP id d22mr3907706ood.54.1591819359255;
        Wed, 10 Jun 2020 13:02:39 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 10sm210430otq.52.2020.06.10.13.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 13:02:38 -0700 (PDT)
Subject: Re: [PATCH] kselftest: runner: fix TAP output for skipped tests
To:     "Bird, Tim" <Tim.Bird@sony.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "shuah@kernel.org" <shuah@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200610154447.15826-1-pbonzini@redhat.com>
 <ac2c1eaa-acd7-7ac6-0666-6e6c0cbd546b@linuxfoundation.org>
 <CY4PR13MB1175A17F29B281642DF05A6DFD830@CY4PR13MB1175.namprd13.prod.outlook.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fbce656a-fdf0-7662-2fcf-4f0daae8cf33@linuxfoundation.org>
Date:   Wed, 10 Jun 2020 14:02:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CY4PR13MB1175A17F29B281642DF05A6DFD830@CY4PR13MB1175.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/10/20 11:43 AM, Bird, Tim wrote:
> 
> 
>> -----Original Message-----
>> From: linux-kselftest-owner@vger.kernel.org <linux-kselftest-owner@vger.kernel.org> On Behalf Of Shuah Khan
>>
>> On 6/10/20 9:44 AM, Paolo Bonzini wrote:
>>> According to the TAP specification, a skipped test must be marked as "ok"
>>> and annotated with the SKIP directive, for example
>>>
>>>      ok 23 # skip Insufficient flogiston pressure.
>>>      (https://testanything.org/tap-specification.html)
>>>
>>> Fix the runner script to match this.
>>>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>    tools/testing/selftests/kselftest/runner.sh | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
>>> index 676b3a8b114d..f4815cbcd60f 100644
>>> --- a/tools/testing/selftests/kselftest/runner.sh
>>> +++ b/tools/testing/selftests/kselftest/runner.sh
>>> @@ -77,7 +77,7 @@ run_one()
>>>    		echo "ok $test_num $TEST_HDR_MSG") ||
>>>    		(rc=$?;	\
>>>    		if [ $rc -eq $skip_rc ]; then	\
>>> -			echo "not ok $test_num $TEST_HDR_MSG # SKIP"
>>> +			echo "ok $test_num $TEST_HDR_MSG # SKIP"
> 
> This is a pretty big change, and might break upstream CIs that have come to
> rely on kselftest's existing behavior.  I know it's going to break Fuego's parsing
> of results.
> 

Thanks for chiming in. We don't want to break CI workflow.

> kselftest has a few conventions that are different from the TAP spec,
> and a few items it does that are extensions to the TAP spec.
> IMHO, the TAP spec got this one wrong, but I could be convinced
> otherwise.  But I think we should discuss this among CI users of
> kselftest before making the change.
> 
> I started work quite a while ago on an effort to document the
> conventions used by kselftest (particularly where it deviates
> from the TAP spec),  but never submitted it.
> 
> I'm going to submit what I've got as an RFC now, for discussion,
> even though it's not finished.  I'll do that in a separate thread.
> 
> 
>>>    		elif [ $rc -eq $timeout_rc ]; then \
>>>    			echo "#"
>>>    			echo "not ok $test_num $TEST_HDR_MSG # TIMEOUT"
>>>
>>
>> Thanks. I will pull this in for Linux 5.8-rc2
> Shuah - can you hold off on this until we discuss it?
> 

Of course. Thanks for getting my attention before I pulled it in.

thanks,
-- Shuah

