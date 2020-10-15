Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB828F3A4
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 15:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgJONvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 09:51:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729647AbgJONvW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 09:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602769881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+AoVAtyDE55i0JIt68mkjIbtN2St1ZBCJvDHSgf89lk=;
        b=OkVRoBS0S6IEEhoUx89ohIzEFg3sEcamNbsn1n5aPSFP1nG9x5ovlY8xhhIziA2e8Vyq9Z
        A5sYlNsUNpha3rSny3gVXF7/tbZy3Sfi/XfUnA3vE+fb6ziM4VJSK1z1McVujmyOM8ZIc+
        B+5EeIbHwFq1RQAPmcQrrHptRCvuD40=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-2ErPkkoYPSSvDr3AstkM1A-1; Thu, 15 Oct 2020 09:51:19 -0400
X-MC-Unique: 2ErPkkoYPSSvDr3AstkM1A-1
Received: by mail-wm1-f72.google.com with SMTP id v14so1903509wmj.6
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 06:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+AoVAtyDE55i0JIt68mkjIbtN2St1ZBCJvDHSgf89lk=;
        b=nSla8VAGj3K2szlzZ6uAyVBTzROh+oTtN1RlhEVHyJmXr9WLcZ/sgJZG0oN4bn0fZS
         zdLOcZyv8opn6vZu+CfLZE5uAsuRwFg2ZP89JlvSw1Rpgmv5cVkvomKnf6NMAs2xvVPa
         tmO5pBvxOM0o+Ek1kr49XIv3nGmM6Z5R95LJduqDzUul/S+Vedv/yfqTgfEmTYwtwAZ5
         LXXSPDF7mug+YSzgQHtSfnrf0dGB9rYy2XAr79Z5i0PP5UN6GVLqAtP4Vq3nXnlWFKLc
         r7U1582ahEUJAGR7+Fy4FFHq2FT5xdR8Fkb20e3+nxRdv5ecAX4IDfrjz8zrHsod2yDl
         Zn5Q==
X-Gm-Message-State: AOAM530AgbLrKIX3DQbq4Xx2MUeqG+GGszpzs/BZrSyW1OZY5S2GfYHZ
        A9QTxemoj0lBFLM5LbEcgICA19Ene1mczpoEYMSiel35R0ZlcsPACtom6Hgtx0V9gqvlhk00ibV
        UiVAf5iHvyHmT
X-Received: by 2002:adf:f3cb:: with SMTP id g11mr4805850wrp.210.1602769878398;
        Thu, 15 Oct 2020 06:51:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsmjK/IIOm6eUdGDXYnLGNC8sdj8uW5iF96UkOo7GpxKlSPtD74MwKPyJHerEDjabE5yynqw==
X-Received: by 2002:adf:f3cb:: with SMTP id g11mr4805820wrp.210.1602769878185;
        Thu, 15 Oct 2020 06:51:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j5sm4657269wrx.88.2020.10.15.06.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 06:51:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 kvm-unit-tests] runtime.bash: skip test when checked file doesn't exist
In-Reply-To: <ff61058b-0960-a61b-d35b-af059c1a23bf@redhat.com>
References: <20201015083808.2488268-1-vkuznets@redhat.com> <ff61058b-0960-a61b-d35b-af059c1a23bf@redhat.com>
Date:   Thu, 15 Oct 2020 15:51:16 +0200
Message-ID: <87ft6f61ij.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 15/10/20 10:38, Vitaly Kuznetsov wrote:
>> Currently, we have the following check condition in x86/unittests.cfg:
>> 
>> check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
>> 
>> the check, however, passes successfully on AMD because the checked file
>> is just missing. This doesn't sound right, reverse the check: fail
>> if the content of the file doesn't match the expectation or if the
>> file is not there.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Hi Vitaly, I had already posted a fix for this but I pushed it only to
> my repo and not to upstream (still getting used to CI!).  I pushed it
> now.

Hm, I still don't see it on gitlab but as long as the bug is fixed I'm
fine ;-)

>
> My fix actually checked whether ${check} was not empty at all.  That
> said, the usage of ${check[@]} is wrong because $check is not an array.
>  So it would break if we wanted to have more than one check.

Oh, yes, I see.

>
> Paolo
>
>> ---
>> Changes since v1:
>> - tabs -> spaces [Thomas]
>> ---
>>  scripts/runtime.bash | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index 3121c1ffdae8..99d242d5cf8c 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -118,7 +118,10 @@ function run()
>>      for check_param in "${check[@]}"; do
>>          path=${check_param%%=*}
>>          value=${check_param#*=}
>> -        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
>> +        if [ -z "$path" ]; then
>> +            continue
>> +        fi
>> +        if [ ! -f "$path" ] || [ "$(cat $path)" != "$value" ]; then
>>              print_result "SKIP" $testname "" "$path not equal to $value"
>>              return 2
>>          fi
>> 
>

-- 
Vitaly

