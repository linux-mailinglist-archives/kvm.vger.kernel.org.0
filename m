Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA9620584D
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 19:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732958AbgFWRM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 13:12:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60305 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732548AbgFWRM5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 13:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592932376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bjSHi5j3igysNj9l7cpgMqXLiUPBi+Ky+x4600a3LLI=;
        b=JbyvPPaH1gFsSyxhELE7YY/Kdxv+Tm5/FOB5BcONcENeznXX/vhEULnvw7Uh6KWC37DQSm
        rBZHTb89YR92NHhZvHS4u04pp4ORZBNSU6QGciIDzgvVOvbajGekZF3259Ow7MwwBQgoLc
        QUf7FKnO/DwH31Vy8lKuJvDL5VVW28w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-bd3dgAftNcqdGN6mXJmiUA-1; Tue, 23 Jun 2020 13:12:54 -0400
X-MC-Unique: bd3dgAftNcqdGN6mXJmiUA-1
Received: by mail-wr1-f72.google.com with SMTP id o25so14411292wro.16
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:12:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bjSHi5j3igysNj9l7cpgMqXLiUPBi+Ky+x4600a3LLI=;
        b=igVj6+nD9vNZuK3nMMhVaJX1w9MEb5RNrY8S+JcMVdpevui78KuNN79ogt12554PCC
         /QxIGe4OmsgioGPW7sSYQXPLpXmxoLmD5nLDpUKau/4/i8kwuwgvhyCWLMS+SXc4kOvE
         8N4AgEwAke8URZcZ6kHcxdDACaKbwKA24K+XaANDCeiW7TmTGRYm1u/Osms7rObOyW+N
         Ps7W5iKwGpEmZe79AnIHeI+V1PzQHhGKZQ78ny1GVhVqLRDvM598ZBgMSryvXZEl4XB7
         G42zlOl+KcsL+NT+fjUufshX/2W/g1iXVCVO/unbPm5/yowOalmfHUbDGwsyZJygygai
         yiyg==
X-Gm-Message-State: AOAM531VNAfD9wvJvUcF4iPvwjm1w2saoHMIIP2jjjPtZJIreSA3lcIy
        PQV8g8pLi7nTzzoWOy8RHKyzRxIBBHjOjbqiWU9e28SJDQ2NxWBEthPENU0TP5qRWY3IErjTM36
        QV7eKdC+dTQBr
X-Received: by 2002:a5d:60d1:: with SMTP id x17mr14975275wrt.293.1592932372956;
        Tue, 23 Jun 2020 10:12:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRuMtyw/dGzTkDP+Lg+Hs1P60eNiOELYrqxHsVCwOUVolT1dJnEB/9IIlJTdqeYRbPpr31iw==
X-Received: by 2002:a5d:60d1:: with SMTP id x17mr14975254wrt.293.1592932372705;
        Tue, 23 Jun 2020 10:12:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id 207sm5303231wme.13.2020.06.23.10.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 10:12:52 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] vmx: remove unnecessary #ifdef __x86_64__
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200623092045.271835-1-pbonzini@redhat.com>
 <AB6977D0-7844-49AE-A631-FF98A74E60FB@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0e052425-0eb6-0bca-1948-8485d5c76ac1@redhat.com>
Date:   Tue, 23 Jun 2020 19:12:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <AB6977D0-7844-49AE-A631-FF98A74E60FB@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 19:02, Nadav Amit wrote:
>> On Jun 23, 2020, at 2:20 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> The VMX tests are 64-bit only, so checking the architecture is
>> unnecessary.  Also, if the tests supported 32-bits environments
>> the #ifdef would probably go in test_canonical.
> 
> Why do you say that the VMX tests are 64-bit only? I ran it the other day on
> 32-bit and it was working.
> 

Because it is not listed in either x86/Makefile.i386 or
x86/Makefile.common. :)

Paolo

