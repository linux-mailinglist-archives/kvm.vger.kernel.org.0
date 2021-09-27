Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4C1419053
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 10:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhI0IEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 04:04:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233279AbhI0IEM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 04:04:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632729755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=viA+Po6ot5+NJUfYPKO28JfyaPbgS3yG5+KW67uyHus=;
        b=X0mEndwaZEBXShNdcye0OO6QHq7QGkUAslk5aTasqYeeilAbm3vQx/5gP82alTfjMXDQjs
        zeuuilebe6mZ/7oz+Rh6jNPdxeEHRmreHk/gQHuwduLUF3BvwyUuYC8xycLv3luR6187Q5
        +4qFshv7LO7QOhMtF3E2voV6v+VG6CY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-MOGy3fzLOhyVLEzTqcn05Q-1; Mon, 27 Sep 2021 04:02:33 -0400
X-MC-Unique: MOGy3fzLOhyVLEzTqcn05Q-1
Received: by mail-wr1-f72.google.com with SMTP id w2-20020a5d5442000000b0016061c95fb7so2866016wrv.12
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 01:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=viA+Po6ot5+NJUfYPKO28JfyaPbgS3yG5+KW67uyHus=;
        b=etSUB58g//c0YSpD5IWF2mIXNBzCu16QRQSZ8qPJSQ5XhzMxS0hcldr8zR+WOjP1Z2
         Qdd2WX3Z5WojG5tcuehxQXUZYW0yOEiIyFcJZt+uJs4U3IL4KQ0943wAWdoVHzcVwtIe
         EL76eClicQgww7//C5J/cH3cXE1fBnC0J/NlpmbZBBAciktU4+emJn5sVMDxqdvFLgb2
         iCjW0gecnmiZd+lVhFbulkH9mIK8ev3qvnFZgJpCZAWvcSJmMLl5251GH0IIgNz2ZWlq
         nqF4O7cs92HEOxsq52FeToxky7Bl6IgqDqYT44ZRychZvnB/swbHHqVYxAqCqGLdOOC0
         zEAA==
X-Gm-Message-State: AOAM533E/z7yi2RSY//DZ4uS3ygLfigYM8JI5EPUslqjkl50RYNeStaa
        pwDsdzO1qeMGnmV1tQja5al77lKzoJ5OtEatT35yRnbrBLcght2owCSRMgqVndRhmuxNC/lVxqh
        xi1pHR3fbIZFU
X-Received: by 2002:a5d:530a:: with SMTP id e10mr27352709wrv.277.1632729752247;
        Mon, 27 Sep 2021 01:02:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3eKr2OlMGSP+aCQ/HorRHKG4E/C5ugJ1l/mHzAfCQdxUYgbtcbDrJj+PoJM/A5JX16An9rA==
X-Received: by 2002:a5d:530a:: with SMTP id e10mr27352691wrv.277.1632729752102;
        Mon, 27 Sep 2021 01:02:32 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id x4sm7816504wmi.22.2021.09.27.01.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 01:02:31 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: add S lines
To:     Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210923114814.229844-1-pbonzini@redhat.com>
 <ea922e07-bacd-350b-4a8e-898444f25ee8@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9a4fb722-201c-7398-9fab-2680b62220f9@redhat.com>
Date:   Mon, 27 Sep 2021 10:02:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ea922e07-bacd-350b-4a8e-898444f25ee8@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/2021 10.00, Janosch Frank wrote:
> On 9/23/21 1:48 PM, Paolo Bonzini wrote:
>> Mark PPC as maintained since it is a bit more stagnant than the rest.
>>
>> Everything else is supported---strange but true.
>>
>> Cc: Laurent Vivier <lvivier@redhat.com>
>> Cc: Thomas Huth <thuth@redhat.com>
>> Cc: Janosch Frank <frankja@linux.ibm.com>
>> Cc: Andrew Jones <drjones@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Is there a reason why we suddenly want to add this i.e. is that
> indication used by anyone right now?

I think it's for the get_maintainers.pl script that has just been pushed to 
the repository some days ago.

  Thomas

