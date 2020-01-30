Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6454014DD7C
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 16:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgA3PE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 10:04:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31334 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726948AbgA3PEZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 10:04:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580396665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+pA3NLtlRLp/xXGeaDKzY9dGlJ8lliR+4HjYXaDfcw=;
        b=jJcdUcnSbKoWMxs9ozeHBKT/IhptD3NlPdCfxwRUi4rMQOEWt5q1uVd+swk1nCAjW/WO5T
        CCgwycN712xtkG8PnTccYunegHzeaG0Dx3OA8DNsdzrXVJB+QnkEXwTI5uxOqppZwKO3/L
        mmSfQ80g/ctwfPSCNfkIBHbga5cP/RA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-zhVUWzObNji3gCQ03TabJQ-1; Thu, 30 Jan 2020 10:04:08 -0500
X-MC-Unique: zhVUWzObNji3gCQ03TabJQ-1
Received: by mail-wr1-f70.google.com with SMTP id 50so958726wrc.2
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:04:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H+pA3NLtlRLp/xXGeaDKzY9dGlJ8lliR+4HjYXaDfcw=;
        b=YVd95LvfHjjSfO9ZMB0DfAYF/GLiGdVT1ekO7kwIJEBoh+Iv0+ey6ONO6enX9k4RVH
         mIyrxKUcC1GqsXDr8et+VaQdH7XEI3r5D9E7I+NKUsUDgaUHuBMxI1HeA4Lza7quR3bA
         RX7z+99USxo7KGXaaQGArbyvRN4cv5P0dmTV0+7Cdw7LqFjhbeMqbezO3BjBg4CVW+Uw
         mBYc8HskiukVIES1A89VRab/NAR0KCurLXpK9vKsj40UBkl0w+pzRyVpiILW4Nzi+i8J
         8R70i/ZFaLOooJLNXKav17gWk2aFqXl1Pbsb3IGzMFOJtEk9/hRUpjFUp5LVprPDp7UO
         CltQ==
X-Gm-Message-State: APjAAAUKe/fiWQtbdfdQWm7TLmL130ujdg+JF7MgJkHIAbhJ/ylSqScT
        nSPPmYS7sYzyAIMYiwlKTPIp4iTfXkPBAK9uhOcCnlwWKVmXC/2FxZVB7OiMjnNes7KOd4M8kgx
        AiotxjJ2Nwz9R
X-Received: by 2002:a5d:610a:: with SMTP id v10mr5959389wrt.267.1580396647549;
        Thu, 30 Jan 2020 07:04:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyKd8yaN6Raqr8KT6xqQ2scRw/p2O+KF9xHnhwrBF0+vxeB4t7HGXk3dHQMXFcRtXNZS03LOw==
X-Received: by 2002:a5d:610a:: with SMTP id v10mr5959349wrt.267.1580396647092;
        Thu, 30 Jan 2020 07:04:07 -0800 (PST)
Received: from [192.168.1.35] (113.red-83-57-172.dynamicip.rima-tde.net. [83.57.172.113])
        by smtp.gmail.com with ESMTPSA id v14sm7826521wrm.28.2020.01.30.07.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 07:04:06 -0800 (PST)
Subject: Re: [PATCH 00/10] python: Explicit usage of Python 3
To:     Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-devel@nongnu.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Kevin Wolf <kwolf@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <20200129231402.23384-1-philmd@redhat.com>
 <0a858225-685d-3ffd-845c-6c1f8a438307@virtuozzo.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <c90ce40e-428a-ed5e-531f-b2ca99121dfc@redhat.com>
Date:   Thu, 30 Jan 2020 16:04:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0a858225-685d-3ffd-845c-6c1f8a438307@virtuozzo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/30/20 3:02 PM, Vladimir Sementsov-Ogievskiy wrote:
> First, thanks for handling this!
> 
> 30.01.2020 2:13, Philippe Mathieu-Daudé wrote:
>> Hello,
>>
>> These are mechanical sed patches used to convert the
>> code base to Python 3, as suggested on this thread:
>> https://www.mail-archive.com/qemu-devel@nongnu.org/msg675024.html
>>
>> Regards,
>>
>> Phil.
>>
>> Philippe Mathieu-Daudé (10):
>>    scripts: Explicit usage of Python 3
>>    tests/qemu-iotests: Explicit usage of Python 3
>>    tests: Explicit usage of Python 3
>>    scripts/minikconf: Explicit usage of Python 3
>>    tests/acceptance: Remove shebang header
>>    scripts/tracetool: Remove shebang header
>>    tests/vm: Remove shebang header
>>    tests/qemu-iotests: Explicit usage of Python 3
>>    scripts: Explicit usage of Python 3
>>    tests/qemu-iotests/check: Update to match Python 3 interpreter
>>
> 
> Could you please not use same subject for different patches? Such things 
> are hard to manage during patch porting from version to version.

I can change but I'm not understanding what you want.

> 
> Also, will you update checkpatch.pl, to avoid appearing unversioned 
> python again?

I'm not sure I can because checkpatch.pl is written in Perl, but I'll try.

