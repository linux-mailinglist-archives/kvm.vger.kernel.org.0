Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32B839D93C
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 12:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFGKEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 06:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhFGKEp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 06:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623060174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDxOcIV3LOZMskX0TR+s6vQHpg3Tao4QIKopLA2bBSk=;
        b=ibiaJWghrqhD6Z5uofX6tx9DRsntjcRic6KpVgQhBxkCu2XbzrbJFdmaen5rynlQQJI7yV
        1ewmwTZqYDGYUmDAHRs5NfJ9RBEE9LyEv3bMg2s4yudOXVhThsTUP1csDMkOvPqpi4P3Qj
        BavBJAGev6UemjH+RYbtnlrVATQ4yVI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-jxiioBXVN_6PkswXXUzl-g-1; Mon, 07 Jun 2021 06:02:51 -0400
X-MC-Unique: jxiioBXVN_6PkswXXUzl-g-1
Received: by mail-wr1-f72.google.com with SMTP id z13-20020adfec8d0000b0290114cc6b21c4so7586353wrn.22
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 03:02:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QDxOcIV3LOZMskX0TR+s6vQHpg3Tao4QIKopLA2bBSk=;
        b=cQE9R4dcDtZaJI4LzxukM7GcDrXs/AfbGC+RGI+cFGVkRxLiuaciKB5OL69EatNW34
         qgrhH3PxVHjzRyNHREeOkx6Sx0k7kVccB67fzhl3xB5Zb2UPld3tdHir3sxESdByOkle
         hLnwdOgaFufvARUUXJmCl6ajuSaliTCRFpwEcL+EN7y5LKLA72VBZDy0IvWOEsJnZ/Sj
         +MbY9moI6xzOi91u5Hc/91VYUcCdd+c3hOeKOeFqoNw997uLTnEqmde+MGPjhUbINN4C
         FMugbVeSTT8r5jGytJAxatGCBrAZOwmtqW29Jk+R9kua7cuDA+jm4OwgLhgvncmByUpn
         EDLg==
X-Gm-Message-State: AOAM533yaBbm9cATRcO6GvrnCc9efW53ynSmH+hSY40m31rKZ46BMKvG
        2vqddKAYRUuXccjs6GNfSLV0mGqr5JWYnyDXRJDytCSXpItKgHXcGr2mKbv8vZfHbnQXypzeTAf
        gS0TIuvNhOZoI
X-Received: by 2002:a5d:64c8:: with SMTP id f8mr15962963wri.386.1623060170821;
        Mon, 07 Jun 2021 03:02:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzL4k2ErUlnKNJsph+jyfsDApfgauXG26LfkRzqkoYWhTta0sLsvXg3BmjHcbSsGp6qar3B8A==
X-Received: by 2002:a5d:64c8:: with SMTP id f8mr15962951wri.386.1623060170708;
        Mon, 07 Jun 2021 03:02:50 -0700 (PDT)
Received: from thuth.remote.csb (pd957536e.dip0.t-ipconnect.de. [217.87.83.110])
        by smtp.gmail.com with ESMTPSA id p187sm14203741wmp.28.2021.06.07.03.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 03:02:50 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: run: Skip PV tests when tcg is
 the accelerator
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210318125015.45502-1-frankja@linux.ibm.com>
 <20210318125015.45502-4-frankja@linux.ibm.com>
 <92be69b9-227a-d01c-6877-738a4482b8c6@redhat.com>
 <656f9301-70ec-a1e1-2d24-48ede0b07aca@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9fec70e1-a5a0-9f65-7a79-5106757e38cb@redhat.com>
Date:   Mon, 7 Jun 2021 12:02:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <656f9301-70ec-a1e1-2d24-48ede0b07aca@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/2021 11.57, David Hildenbrand wrote:
> On 07.06.21 11:54, Thomas Huth wrote:
>> On 18/03/2021 13.50, Janosch Frank wrote:
>>> TCG doesn't support PV.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    s390x/run | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/s390x/run b/s390x/run
>>> index df7ef5ca..82922701 100755
>>> --- a/s390x/run
>>> +++ b/s390x/run
>>> @@ -19,6 +19,11 @@ else
>>>        ACCEL=$DEF_ACCEL
>>>    fi
>>> +if [ "${1: -7}" == ".pv.bin" ] || [ "${TESTNAME: -3}" == "_PV" ] && [ 
>>> $ACCEL == "tcg" ]; then
>>
>> Put $ACCEL in quotes?
>>
>> With that nit fixed:
>>
> 
> Should these "==" be "=" ? Bash string comparisons always mess with my mind.

Oh, right. I also always have to check "man test" to get the right answer, 
but "=" is more portable, indeed. (Well, k-u-t are hard-wired to bash, but 
it's better to write clean shell code anyway)

  Thomas

