Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42590141920
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 20:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgARTZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 14:25:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44663 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726661AbgARTZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 14:25:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579375516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MeWnCRBEt1/lj9zzU/aD+y9894/woZmZF0jpYc8smfA=;
        b=GL53eDNVOYW3gdmFpzCfBOr25Sk3o1owXdy7y5bWUdOhtIXoO+10UrM6aWIwJw6IhuUxJE
        s38x3ZntHJILRrLDJ5EGJYFb1wJgd6DihRltMHMMkjrK8OQomzfkGwJ7dybXDUcq+D49xF
        si1etcdE8xKPkd3D02RS21nMGCDwmp4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-wuJ9C1gkNO-KUwdtS3rc8Q-1; Sat, 18 Jan 2020 14:25:15 -0500
X-MC-Unique: wuJ9C1gkNO-KUwdtS3rc8Q-1
Received: by mail-wr1-f71.google.com with SMTP id c6so11969232wrm.18
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 11:25:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MeWnCRBEt1/lj9zzU/aD+y9894/woZmZF0jpYc8smfA=;
        b=oNxFns9S2nSleJk6nkx/xpAH/gRFOveHZwHa3PV314DEar7Pkpliu6493J6c1G56+p
         iYruCCTS7ElonlDnmxnoBxK00PzotD4d9lmW0f3vtmYKDjiWsOjIBJAidI6K5HusLCpB
         oijljKiZzUPcy3/vczbcLDjbqegNH3l8Wks6OGIo4IDT52VoBirrj6VYeNEL/2CzgXS1
         n9VZyYgOO7LyZqhcYy9Z38ANKdLDK7pyrtNIFfMvK+YsEVuzxS4jiE6ml7mZfN1JjZxc
         vPLOm/CirfHDSN8BFUaOfJ7ma0DPtA/92x2fqlyvYPhjJjSuVjoiT3hKHFQUAZcuqM7t
         lTOA==
X-Gm-Message-State: APjAAAUb4sc6Suktwup0onFIseHTayaoUuF1Jz0CvSlsx19uaYfTdRBH
        5EysDL2eXz/JdrautOGBkoKB/t/5tiAJQuBVJv+qoztaOGjUSUmdTM110+9ahAvv61U3WkUQRxH
        +edoD+O5be7sr
X-Received: by 2002:a05:600c:2488:: with SMTP id 8mr10783085wms.152.1579375513938;
        Sat, 18 Jan 2020 11:25:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQertgn5c7dgeHgSRMaG/u+NAKzVON1iO0Tn80EPiCMtT4whNiA+qWHA/wTf/cpYpWMuJnXQ==
X-Received: by 2002:a05:600c:2488:: with SMTP id 8mr10783072wms.152.1579375513756;
        Sat, 18 Jan 2020 11:25:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id r68sm1416144wmr.43.2020.01.18.11.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 11:25:13 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 0/2] Better max VMCS field index test
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191219101006.49103-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d9e32a1-9701-8a7b-9913-b293f1e65b6c@redhat.com>
Date:   Sat, 18 Jan 2020 20:25:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191219101006.49103-1-namit@vmware.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/12/19 11:10, Nadav Amit wrote:
> The first patch improves max VMCS field index search so an exact
> comparison would be possible. The second one does some cleanup.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Nadav Amit (2):
>   x86: vmx: Comprehensive max VMCS field search
>   x86: vmx: Remove max_index tracking in check_vmcs_field()
> 
>  x86/vmx.c | 50 ++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 34 insertions(+), 16 deletions(-)
> 

Queued, thanks.

Paolo

