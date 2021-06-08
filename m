Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174E839EF5B
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 09:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFHHTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 03:19:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229678AbhFHHTb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 03:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623136659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZTmXo+HPt2tUCA6PmOrzdthBV1Q2yugHfu32WlEqc8g=;
        b=ZBnbltPpzO+fCM7aMaR882hFKhqcEVB5o7AyL6yLNjCKjgtt47GCsyrUPQyucaFZkS82E2
        iSgOX897H4nyS1lBjT1Ja5O5yld0/vuk58WElC40t8gmxxRlFLxdjl6hNZ/i8g8EQcwQgI
        Hh1kf+ygAReXhPQWA7kVjKm+jpAzx+I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-8SPJva2CPYGyINScowjfwQ-1; Tue, 08 Jun 2021 03:17:37 -0400
X-MC-Unique: 8SPJva2CPYGyINScowjfwQ-1
Received: by mail-wr1-f71.google.com with SMTP id x9-20020a5d49090000b0290118d8746e06so9045250wrq.10
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 00:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZTmXo+HPt2tUCA6PmOrzdthBV1Q2yugHfu32WlEqc8g=;
        b=NG8KYSuD3I1WA1fNmBZglvu3xXsLLi6kNNPu12Gl3z1IvJ5q0BJC9F0vtOGZL9nlOh
         njrbhDyWjeVa9WLTgSFbVQNUyN+hK/sFWS1Z3jBzmf2Ea6nv1g6/CVdH+gbx8EVarlt+
         EyFQMqmi+G8hfkI8K7j12kHWZQDaXeJZr0KnW/2s4AZVSgkuFtJPTFzwlXN67AOrzt1j
         v3MdelHUEkF6aYyeE2uMLxpvL64b5lz8oAcuD3rO8q98qmtCUFVAUcjW7fiIcJlYnkBY
         I6jWTW+qasCqem8tZ/cGkhDIkq10e/abWTo2iw+YJLVFt9skHEjjHDEEH6ObZ3ZTTeqX
         X2lw==
X-Gm-Message-State: AOAM531M6R64OuUF/gzUlHHANvTjOgzUYiB8gjWhOkbmNUTk1dJaoBcQ
        7Z4sUmAWg6VIfoIy4ROHSB5jqxzgqd5+Q10/eRm2Rec/J1x0PWb0CK9WJ5p/ZDkHoY1jbqcUveU
        xX5TCPtbT/SKb
X-Received: by 2002:a5d:618a:: with SMTP id j10mr21266968wru.229.1623136656648;
        Tue, 08 Jun 2021 00:17:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhXC3AcN3eNaQCnjSjYVSzk82kFl4HOaJ53frXDMBrihWA3bT5OwhUcuB4wr5mTwwKe5bOgw==
X-Received: by 2002:a5d:618a:: with SMTP id j10mr21266951wru.229.1623136656461;
        Tue, 08 Jun 2021 00:17:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h9sm1885572wmm.33.2021.06.08.00.17.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 00:17:35 -0700 (PDT)
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>
References: <20200417163843.71624-1-pbonzini@redhat.com>
 <20200417163843.71624-2-pbonzini@redhat.com> <YL70kh5/vLW8gmAY@eldamar.lan>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
Message-ID: <24b6a7e2-5059-1c5c-aed1-1ea713d78bf3@redhat.com>
Date:   Tue, 8 Jun 2021 09:17:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YL70kh5/vLW8gmAY@eldamar.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/21 06:39, Salvatore Bonaccorso wrote:
> 
> Did this simply felt through the cracks here or is it not worth
> backporting to older series? At least
> https://bugzilla.redhat.com/show_bug.cgi?id=1947982#c3  seem to
> indicate it might not be worth of if there is risk for regression if I
> understand Wanpeng Li. Is this right?

It's not particularly interesting, because the loop can be broken with 
just Ctrl-C (or any signal for that matter) and the guest was 
misbehaving anyway.  You can read from that bugzilla link my opinion on 
this "vulnerability": if you run a VM for somebody and they want to 
waste your CPU time, they can just run a while(1) loop.

It's a bug and it is caught by the kvm-unit-tests, so I marked it for 
stable at the time because it can be useful to run kvm-unit-tests on 
stable kernels and hanging is a bit impolite (the test harness has a 
timeout, but of course tests that hang have the risk missing other 
regressions).

I will review gladly a backport, but if it is just because of that CVE 
report, documenting that the vulnerability is bogus would be time spent 
better that doing and testing the backport.

Paolo

