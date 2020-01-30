Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3617214DC0E
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbgA3NfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:35:08 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50077 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726948AbgA3NfI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 08:35:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580391306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qgWZmuhOKMFfk4VlYLuSzsR74+izZ4gtbxwoXtULvz0=;
        b=I1xmranOQAvwF+xwbgRv0FjdJwdL2veOXbAeXXVi6hU+T8iHqus245QKINa3jl6COCfRHo
        7XDODFRd8I80D0p2mcCG0IURzfhxJ1XIlz70BfnEvjIzG7pkNYy7PZcs1fAr6Izd7fHci0
        YmkbRdT3GRNEP92GgSjtNSD/WfuxFhs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-3XKzX1SGNHyTdcA7RbkEIQ-1; Thu, 30 Jan 2020 08:34:59 -0500
X-MC-Unique: 3XKzX1SGNHyTdcA7RbkEIQ-1
Received: by mail-wr1-f70.google.com with SMTP id c6so1701532wrm.18
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 05:34:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qgWZmuhOKMFfk4VlYLuSzsR74+izZ4gtbxwoXtULvz0=;
        b=Rccpiow65tP2RqFTDIV1g85gzbfbmE/aU3oDYByarVIBCPyhDD/EiiwvkgY7r1aDiK
         h/gzFxty1c50LOr5IcAROYCzlnDc2chV09uEm/fJHrj3kDpbzosrbKfOLlkQIwqbIQcs
         9/2aIwToGguRK5U1nS5SiwxnkkHQtWnzgmkAtzdRGjeRqdxQI6/moDi+KIXJZqdcIK1E
         iql+RB+/fViKdp6scKQTJoYkP2olydAZc9jlcWSeWX+stNehnjDbwjWcaR+JE99QY4lA
         u/sHVbfFnBu/6XdymU4b7AY0qkWGR4KQjWRhUk05uBrrUgL3CQnWYT3JYpsCHA6/WSo8
         h0SQ==
X-Gm-Message-State: APjAAAWdOt7dtTU0puerCyQVhEtPeb91hWE51xR3KdSHBLcrwDbT+UHX
        GecPm8EChintzIvvX5APPd+H1NsxOS+mpD812/OeJ3fYa+xcm761Kk9bunpKkmx14dzkMSSf0sK
        /kIMNLGbBUCeV
X-Received: by 2002:a7b:c216:: with SMTP id x22mr5990206wmi.51.1580391298539;
        Thu, 30 Jan 2020 05:34:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqzaK3e7+tI1ynJ6nZWf6xjV+JfROJgFKfNjftS9fcCTVFysf2JJkQdFIT9TmVxClGHNFy2SMw==
X-Received: by 2002:a7b:c216:: with SMTP id x22mr5990189wmi.51.1580391298345;
        Thu, 30 Jan 2020 05:34:58 -0800 (PST)
Received: from [192.168.1.35] (113.red-83-57-172.dynamicip.rima-tde.net. [83.57.172.113])
        by smtp.gmail.com with ESMTPSA id r6sm4272192wrp.95.2020.01.30.05.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 05:34:57 -0800 (PST)
Subject: Re: [PATCH 10/10] tests/qemu-iotests/check: Update to match Python 3
 interpreter
To:     Kevin Wolf <kwolf@redhat.com>
Cc:     qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        kvm@vger.kernel.org, Juan Quintela <quintela@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <20200129231402.23384-1-philmd@redhat.com>
 <20200129231402.23384-11-philmd@redhat.com>
 <20200130105839.GB6438@linux.fritz.box>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <f20bd922-f5b7-7acd-fcc8-9326b282a36c@redhat.com>
Date:   Thu, 30 Jan 2020 14:34:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200130105839.GB6438@linux.fritz.box>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/30/20 11:58 AM, Kevin Wolf wrote:
> Am 30.01.2020 um 00:14 hat Philippe Mathieu-Daudé geschrieben:
>> All the iotests Python scripts have been converted to search for
>> the Python 3 interpreter. Update the ./check script accordingly.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
>> diff --git a/tests/qemu-iotests/check b/tests/qemu-iotests/check
>> index 2890785a10..2e7d29d570 100755
>> --- a/tests/qemu-iotests/check
>> +++ b/tests/qemu-iotests/check
>> @@ -825,7 +825,7 @@ do
>>   
>>           start=$(_wallclock)
>>   
>> -        if [ "$(head -n 1 "$source_iotests/$seq")" == "#!/usr/bin/env python" ]; then
>> +        if [ "$(head -n 1 "$source_iotests/$seq")" == "#!/usr/bin/env python3" ]; then
>>               if $python_usable; then
>>                   run_command="$PYTHON $seq"
>>               else
> 
> Changing some test cases in patch 2 and only updating ./check now breaks
> bisectability.
> 
> I'm not sure why you separated patch 2 and 8. I think the easiest way
> would be to change all qemu-iotests cases in the same patch and also
> update ./check in that patch.

Tests in patch 2 use: if __name__ == "__main__", while tests in patch 8 
don't. If I add the check I have to re-indent the patches, some lines 
don't fit the 80char limit and require manual fixup... This doesn't look 
worthwhile.

> 
> Otherwise, you'd have to change ./check in patch 2 to accept both
> versions and could possibly remove the "python" version again here.

OK.

