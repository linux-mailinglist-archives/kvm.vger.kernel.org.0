Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B481B5CC4
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgDWNnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 09:43:18 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50841 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgDWNnS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 09:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587649397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KkSCE0JzSlg9odwhbBRC3mYNWh8RC/9N7mx5EiFBY6g=;
        b=VvRIo+KoptrpGuBV5og84nB87pmA9VW4SFmmN17TDyHMBCjzYhJm7QvnwZqEGUuTSJyllP
        BO1AiotSUlxX5/WUDxtRe2WjEUw65X75G65kOpsqN7gwO0ScCbmkUf/VdwyeglREVhAy3f
        kjMc7FbELb3imPS5ZgWd7kHKUA3eOJk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-ZuDyUcPhPRaFocyOIVRkzA-1; Thu, 23 Apr 2020 09:43:14 -0400
X-MC-Unique: ZuDyUcPhPRaFocyOIVRkzA-1
Received: by mail-wr1-f71.google.com with SMTP id f15so2892268wrj.2
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 06:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KkSCE0JzSlg9odwhbBRC3mYNWh8RC/9N7mx5EiFBY6g=;
        b=RTrSVyJHCoIrbXSKgzpNOWeFchXjhIGrmOoLLiCk6zMUlMYgQfieLINz/wEJ1aOuS1
         eltQfxPCKa07vkta6oEZZMDC79ak3M0CUCW5ZVmN+gJQ3FifQ5hMoeN2cw+S48UOzbbU
         ZYDDuXPm6jV6Mt6oIqc3liGqw4KarTAheZ28HDlkgSuUFdyIEpLXrWDmxU8yi9Piqc+u
         3L7vR4tp8n8u2OeRZKrU2qhYaMOTdoPuoRYXbScS3lne8h+YrewSRwlt1p+7szjeg32K
         cL0QfbcaKluTa22lS/alHdkLgNx63pKib1GZJwpwvwTqoLyve1q3YQZErSED/nDCGWb/
         3zgA==
X-Gm-Message-State: AGi0Pubt/K7DY2cLIesElrvYl702yniPXp2cuiIZ/Excp+wtgvFKJHJF
        6VlB+5i8D0BxAkZ4+zE90V5LyPmxcVNx6a+i1sqdGGAyR8bDVaKfr8V9EN+lobFb1VOsvU4USH/
        nm1Ra/zRziJ1c
X-Received: by 2002:a5d:6607:: with SMTP id n7mr5326236wru.150.1587649393476;
        Thu, 23 Apr 2020 06:43:13 -0700 (PDT)
X-Google-Smtp-Source: APiQypJa1WY71QlS4JoH4ExfIQ/Mcb3+xBPD0CWFeuWO/5cLjqXMXckSK/nstqWU4jJUxZY0ARTRPA==
X-Received: by 2002:a5d:6607:: with SMTP id n7mr5326219wru.150.1587649393280;
        Thu, 23 Apr 2020 06:43:13 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id o7sm3582902wmh.46.2020.04.23.06.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 06:43:12 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: SVM: Implement check_nested_events for NMI
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
References: <20200414201107.22952-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c3f87de-525a-63d5-0134-606250d8c945@redhat.com>
Date:   Thu, 23 Apr 2020 15:43:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414201107.22952-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/20 22:11, Cathy Avery wrote:
> Moved nested NMI exit to new check_nested_events.
> The second patch fixes the NMI pending race condition that now occurs.
> 
> Cathy Avery (2):
>   KVM: SVM: Implement check_nested_events for NMI
>   KVM: x86: check_nested_events if there is an injectable NMI
> 
>  arch/x86/kvm/svm/nested.c | 21 +++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c    |  2 +-
>  arch/x86/kvm/svm/svm.h    | 15 ---------------
>  arch/x86/kvm/x86.c        | 15 +++++++++++----
>  4 files changed, 33 insertions(+), 20 deletions(-)
> 

Thanks, I've integrated this in Sean's event reinjection series and will
post soon my own take on both.

Paolo

