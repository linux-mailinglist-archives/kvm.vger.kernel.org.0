Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAFA424801
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbhJFUh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 16:37:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239514AbhJFUhY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 16:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633552532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OXUZxsK1QdLO6xng6hFlFsgbFwbh30BDsuNSdVeIo/U=;
        b=IUMqwbGK9yvUr6VUIqn1yOnunSE69mwxgUbvjifyx2AXNqRItPk3Uv/2+Xnx9xkfq5Q0+w
        82FYOzvZnS3NYXMJVRewrn3jgSqysG9nB1HpO8j+aga/OhbH9uO0EQ1g1f0yN5a5gaDRzc
        VEDP6e33eyuHlzV1UrKbMVfDzGRIf9A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-2EQoVCJCN1myNbychKjcaw-1; Wed, 06 Oct 2021 16:35:31 -0400
X-MC-Unique: 2EQoVCJCN1myNbychKjcaw-1
Received: by mail-wr1-f71.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso2978559wrg.7
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 13:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OXUZxsK1QdLO6xng6hFlFsgbFwbh30BDsuNSdVeIo/U=;
        b=tCcOGeSz17L4gWxNkMhOHqBUEQ0kzWaa/XDTQegx+ctDQDVt1IurIANWsYer3EU0ow
         rRSneBQYrHoVkgRuw7RsQzFZBPwKiTkEdA3Co0iWcb4UwfMQlhhKtgwMTEDsSAdK6NJT
         7B34orhAJq7DLlh9kqOn7me91jOJPp5kejRk6V1y+FBQGwMg+qjgkNXjFQadCPJDC9Lg
         y66N+9xduQ8zSu2NUecaIPZCpIHq6eTljllwUoUL2JzVYYVJKlw8T9zMXdBQ8NXKiHPS
         oa3+XoyZ8QOP5lUq85KvCfZM/lZOdqVmRmjmWJDc/B54+N/FJAo+dSzRL+LqkqrbS1Ns
         arUA==
X-Gm-Message-State: AOAM532PIajkfEMUXWDVsg0R6F5U+1BFxGU3It3pBKWhtYIscHb9ezrr
        pWpLey/hUGuDvD/8S+923eL7a55p1gE4+86mOyqJGTtSju3QJCzLnwGy2OpyjGgBAYwaeVcGxDa
        RQFm6N6Bz0RAb
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr12371011wmc.86.1633552529586;
        Wed, 06 Oct 2021 13:35:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAV1sU0EbX3shysQeMn1nSNxCQsb3Xblx9vhq06zqPcFS58jo633atJc2QNjsRG4oLLhGD6A==
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr12370995wmc.86.1633552529397;
        Wed, 06 Oct 2021 13:35:29 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id n186sm6489688wme.31.2021.10.06.13.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 13:35:28 -0700 (PDT)
Message-ID: <bf016462-0409-b08a-211e-91cfa34f5776@redhat.com>
Date:   Wed, 6 Oct 2021 22:35:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 22/22] MAINTAINERS: Cover AMD SEV files
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-23-philmd@redhat.com>
 <a603ce87-e315-06e0-ff53-2c961c046b82@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <a603ce87-e315-06e0-ff53-2c961c046b82@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/21 10:27, Paolo Bonzini wrote:
> On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
>> Add an entry to list SEV-related files.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   MAINTAINERS | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 50435b8d2f5..733a5201e76 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3038,6 +3038,13 @@ F: hw/core/clock-vmstate.c
>>   F: hw/core/qdev-clock.c
>>   F: docs/devel/clocks.rst
>>   +AMD Secure Encrypted Virtualization (SEV)
>> +S: Orphan
>> +F: docs/amd-memory-encryption.txt
>> +F: target/i386/sev*
>> +F: target/i386/kvm/sev-stub.c
>> +F: include/sysemu/sev.h
> 
> I don't think it qualifies as orphan; it's covered by x86 maintainers.

$ ./scripts/get_maintainer.pl -f docs/amd-memory-encryption.txt
get_maintainer.pl: No maintainers found, printing recent contributors.
get_maintainer.pl: Do not blindly cc: them on patches!  Use common sense.
Connor Kuehl <ckuehl@redhat.com> (commit_signer:2/3=67%)
Eduardo Habkost <ehabkost@redhat.com> (commit_signer:2/3=67%)
Tom Lendacky <thomas.lendacky@amd.com> (commit_signer:2/3=67%)
Laszlo Ersek <lersek@redhat.com> (commit_signer:2/3=67%)
Greg Kurz <groug@kaod.org> (commit_signer:1/3=33%)
qemu-devel@nongnu.org (open list:All patches CC here)

$ ./scripts/get_maintainer.pl -f target/i386/sev.c
get_maintainer.pl: No maintainers found, printing recent contributors.
get_maintainer.pl: Do not blindly cc: them on patches!  Use common sense.
"Philippe Mathieu-Daudé" <philmd@redhat.com> (commit_signer:15/29=52%)
"Dr. David Alan Gilbert" <dgilbert@redhat.com> (commit_signer:7/29=24%)
Paolo Bonzini <pbonzini@redhat.com> (commit_signer:7/29=24%)
David Gibson <david@gibson.dropbear.id.au> (commit_signer:7/29=24%)
Eduardo Habkost <ehabkost@redhat.com> (commit_signer:5/29=17%)
qemu-devel@nongnu.org (open list:All patches CC here)

$ ./scripts/get_maintainer.pl -f target/i386/sev.h
get_maintainer.pl: No maintainers found, printing recent contributors.
get_maintainer.pl: Do not blindly cc: them on patches!  Use common sense.
"Philippe Mathieu-Daudé" <philmd@redhat.com> (commit_signer:8/12=67%)
Paolo Bonzini <pbonzini@redhat.com> (commit_signer:4/12=33%)
James Bottomley <jejb@linux.ibm.com> (commit_signer:3/12=25%)
"Dr. David Alan Gilbert" <dgilbert@redhat.com> (commit_signer:3/12=25%)
Connor Kuehl <ckuehl@redhat.com> (commit_signer:3/12=25%)
qemu-devel@nongnu.org (open list:All patches CC here)

I will update the patch to add these files to the "X86 KVM CPUs"
section.

Thanks,

Phil.

