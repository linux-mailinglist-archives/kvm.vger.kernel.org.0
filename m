Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE352AB55B
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 11:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgKIKsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 05:48:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbgKIKsu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 05:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604918929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjIW7SNSQYr8EJyuUd9g1avOYFsF3nB3CS3kzOxLyyk=;
        b=MGENTmMRtlSnKPR8o220j0wHhIAdLYTtm+AlNWXYzeKRyYlQUScjkD/vGKQCWUzNE1lrca
        Qok9uxASFTyS+Z4I59eBE42WA+R9awRSXjYMsZtsEUiZ7La1JLUNlgxXuv53P7h9FyY+BU
        lypZ9uVz8HhdbCa+rxOZktdq+UtW4mA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-CEfBLGGrOGSs8rm-_MEwYg-1; Mon, 09 Nov 2020 05:48:45 -0500
X-MC-Unique: CEfBLGGrOGSs8rm-_MEwYg-1
Received: by mail-ed1-f69.google.com with SMTP id a73so2547236edf.16
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 02:48:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xjIW7SNSQYr8EJyuUd9g1avOYFsF3nB3CS3kzOxLyyk=;
        b=N4MzQIdjaqPZkT1TARzcHn6GyC93IJDxaJUnsxSDnDozMIZm2WjXLOe1Cp1J7h4hVy
         zzoAXzyEzQuXb5WgmpTcz3J8m64BRkCqlL/fX5IzwgqeOPHJ5MNdkACyS3g9PHaHrEdy
         pVXgJH9vWCuJlYjIdQzX4kamhQgH4jxYxjrCqxl8oZycg01e273g5XghDbmJR4/Ij7CV
         MSp3q6dZYEJMswmaJDWYhNY8cfm196LmX9ErfN63wAzzHkczKnDt9FH6vjJLNZH0SY1f
         qZF9j6Hs6EBofLWLxXyH3OIMROoWqpARfDuYIahlMUl7+Zlk8F8ctKnCauleLQrOYZmk
         pDWQ==
X-Gm-Message-State: AOAM532rB8+bH54G8ApEQgX8Kvve7Osc+ZWUX0wWexzPBsuV23cttGG9
        6erbBxvLLvgaSD0OYrcYxFULfVvOJXoyC0ae3G5iaUp5w7zHJ7T7I6AQnmBsiEVW5jOpeZMhyBV
        PDh+CEMNDD5WY
X-Received: by 2002:aa7:d493:: with SMTP id b19mr14195402edr.279.1604918923949;
        Mon, 09 Nov 2020 02:48:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwGyjQcEQHuJsGmMR3q+M3Aam01DGov0mbzg5FjFye+7zH2MQwsAALof2H5gUNEjktm/dAhgg==
X-Received: by 2002:aa7:d493:: with SMTP id b19mr14195386edr.279.1604918923751;
        Mon, 09 Nov 2020 02:48:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j9sm6432834edv.92.2020.11.09.02.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 02:48:43 -0800 (PST)
Subject: Re: [PATCH 1/3] accel: Only include TCG stubs in user-mode only
 builds
To:     Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org
References: <20201109094547.2456385-1-f4bug@amsat.org>
 <20201109094547.2456385-2-f4bug@amsat.org>
 <e9837717-b010-077e-2d68-0f03300793c4@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <49ae582b-1b4d-9a0e-118c-fb4bcb714bdd@redhat.com>
Date:   Mon, 9 Nov 2020 11:48:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <e9837717-b010-077e-2d68-0f03300793c4@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/20 10:55, Claudio Fontana wrote:
> Ciao Philippe,
> 
> I thought that the pattern used by Paolo was, recurse always, and put
> the check inside the recursed dir meson.build . Paolo did you indeed
> intend meson use this way?

Generally yeah, I preferred to recurse always.  In this specific case, 
however, an even bigger qualm with the patch is that the patch content 
does not match the commit message.

I also don't understand why it's useful, because patch 2 makes 
everything conditional on CONFIG_SOFTMMU.

Paolo

