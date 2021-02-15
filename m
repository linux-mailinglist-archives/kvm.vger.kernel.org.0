Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AB231BFD1
	for <lists+kvm@lfdr.de>; Mon, 15 Feb 2021 17:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhBOQxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 11:53:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232067AbhBOQvE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Feb 2021 11:51:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613407777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LRbtxpXqKrR8QuiDDi8Ze61usuM6LZNN2msu97PV1S0=;
        b=eZwBj9umG9BJoHks/ftHNEACiUuosrMyf0/HoWOhW+G/ZGdDk2WT9S+NrTh8Vyg5EFnraf
        hh2wCWLo34iDx2l/c1eh+wdrN289F58vxvtcNXD/GqhBBQ1Rn3q9zLPXutbA82zGCTPN+e
        hCQkaSHmlbhwIgqWwBaNjvc0wG3vESo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-e9OqUnLEOUSaXlxQRTzvIA-1; Mon, 15 Feb 2021 11:49:36 -0500
X-MC-Unique: e9OqUnLEOUSaXlxQRTzvIA-1
Received: by mail-ej1-f71.google.com with SMTP id yd11so4807027ejb.9
        for <kvm@vger.kernel.org>; Mon, 15 Feb 2021 08:49:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LRbtxpXqKrR8QuiDDi8Ze61usuM6LZNN2msu97PV1S0=;
        b=TalvMgiXld0XKHy9lJ5/LcJuDTUvdIrnGciJ6h3P1eoQNbJd7/SduQDJgXY4o8yc3p
         FllnermIFqHe+O/HQ1TitFD0O1nSNr+aSUg2gUkbfM844oP77coZZ4PHGBHwDyy83ySL
         uLR3kq95c62MphOYNDU4y3JEfA50OBblWuKsx+GJWEZdGM/Z7uCuPLyRMuqEQ1xh0A0S
         9Ux9Dq/Zj2Sqmh4MrcAQXL6YHsL1WUh3vjlHPOSjvlWB8zxc+RErEnJPExsttlVdStBJ
         tTXnnZjcjO+K1H8Vf9yY8BYHWIPoL/HRKf1QJz3BhNt+QW3kjsrYVP+E/Q8vAjfW1JVM
         Cqug==
X-Gm-Message-State: AOAM533Lpe+Kzk6yqbjwhBVSXkz7O3V80+zcwVTebsS8McT4uP0+R9dm
        MzylVTzPtni/nu8TH3u0TMAbNYF9Zh4bQyTp6QlTSBazy5yWJrXVBge09RgZZCB1k8ZYD06rA49
        kqQOZcwMUBY9OoASFXfXoqY7xJXDqyi9hxJ2nUVHHjr0S35ORnfJAEH6vOwAKcYgu
X-Received: by 2002:a17:906:503:: with SMTP id j3mr16426000eja.172.1613407774685;
        Mon, 15 Feb 2021 08:49:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8qldyA33OUR4bhDefBLIL/JmuIHCQWaC9+NPLKURxH+VRvobML85iHkW9c0aEqj0whW7edg==
X-Received: by 2002:a17:906:503:: with SMTP id j3mr16425974eja.172.1613407774417;
        Mon, 15 Feb 2021 08:49:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g2sm10855082ejk.108.2021.02.15.08.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 08:49:33 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 0/4] x86: PCID test adjustments
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210212010606.1118184-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f06db131-7958-4f0a-4468-099c2acdd146@redhat.com>
Date:   Mon, 15 Feb 2021 17:49:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210212010606.1118184-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/21 02:06, Sean Christopherson wrote:
> Adjust the PCID test to remove the enforment that INVPCID is enabled iff
> PCID is enabled, and add explicit coverage of the newly allowed scneario.
> 
> Sean Christopherson (4):
>    x86: Remove PCID test that INVPCID isn't enabled without PCID
>    x86: Iterate over all INVPCID types in the enabled test
>    x86: Add a testcase for !PCID && INVPCID
>    x86: Add a 'pcid' group for the various PCID+INVPCID permutations
> 
>   x86/pcid.c        | 35 ++++++++++++++++++-----------------
>   x86/unittests.cfg | 10 +++++++++-
>   2 files changed, 27 insertions(+), 18 deletions(-)
> 

Queued, thanks.

Paolo

