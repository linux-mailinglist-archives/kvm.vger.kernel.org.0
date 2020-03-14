Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67CC5185935
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgCOCiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:38:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726873AbgCOCiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584239893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8fXoDgGhJ92EE8IqO5VxMhR5fjvfyZ3SQGsS261Nmz8=;
        b=TJF3VrH8W5O9wXWmzcrAotAZGozGj3tqSwhFnoW3opJpLcYsnzVKLkllWvpykrfCrF+bHi
        V1FMO9wfOyX/ibAN4j+jKf7jHS4VxrL3SMpIVsvTGX0z5/h0qQYr7jhYHTt2DpsvytNNAw
        A8BTVUiQKrBva1IymTVNZikSZ7gPwcE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-byNpg8uKNhKCpsSw14MaJw-1; Sat, 14 Mar 2020 06:35:18 -0400
X-MC-Unique: byNpg8uKNhKCpsSw14MaJw-1
Received: by mail-wr1-f70.google.com with SMTP id z16so5734629wrm.15
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 03:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8fXoDgGhJ92EE8IqO5VxMhR5fjvfyZ3SQGsS261Nmz8=;
        b=lWrKbLwwKaZbrKQM5Wtw+YcPvJhXLkbTIBc3o+kaGNLw1jFy2y9uDp4UElLzSnsWcv
         fav0bhetGOewkFQoV9ovzB+L2xGDi0dVp0eM/Z3d46B7d9EShw9pPFSQIUlUAosfZOw2
         eIe693MXW85L/qd37cjJxYjCCSHW1oSFjmmp6fLUT64pV6zAO/1YbYvlRJWfenp+pzcX
         FqXXTpAAi7+C5YN6qREm1xCcF5m43rEToHcJpkuLONP4QnT19bcfQmOCx0z7e+YaHuyO
         XPtpvpLXdmbTMHVcLy4d7d/2+PeNz2MSQ9nDi4TjS+Gbaf8cnjjorglG408A/xQHJMJC
         VNkw==
X-Gm-Message-State: ANhLgQ2awDt32GDafQu/EG5VIzU4skge2EZciq9HoiyJqQkJI0DVsrYP
        XOPhebyUxJX4iPKjSbc/O67w5Nb49S05/35Ns5kSwgWwTG9ZSB1wcU6PIGLu8Xy01oI1vF70bTT
        I4R0nq8c4s48R
X-Received: by 2002:adf:a419:: with SMTP id d25mr24724882wra.210.1584182117421;
        Sat, 14 Mar 2020 03:35:17 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuF30RHC7/9R+Xx3Ukae0RxoBE5Cf0TCe9XBmZJBY3UTJye/SvS0S3JlUOQEKxKlFFYDE9SNA==
X-Received: by 2002:adf:a419:: with SMTP id d25mr24724861wra.210.1584182117170;
        Sat, 14 Mar 2020 03:35:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7de8:5d90:2370:d1ac? ([2001:b07:6468:f312:7de8:5d90:2370:d1ac])
        by smtp.gmail.com with ESMTPSA id v8sm81163776wrw.2.2020.03.14.03.35.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 03:35:16 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/8] nVMX: Clean up __enter_guest() and co.
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6d53a962-667e-2d8a-bdf7-32ca5ea42ad6@redhat.com>
Date:   Sat, 14 Mar 2020 11:35:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/03/20 00:27, Sean Christopherson wrote:
> Start chipping away at the crustiness in the nVMX tests by refactoring
> "struct vmentry_failure" into "struct vmentry_result", with the full
> VM-Exit stored in vmentry_result.  Capturing the exit reason allows for a
> variety of cleanups and consolidations.
> 
> This series really only dives into the v1 tests.  I'd like to also clean
> up the v2 tests, e.g. take the expected exit reason in enter_guest() so
> that the expected behavior is more obvious, but that's a more invasive
> cleanup for another day.
> 
> Sean Christopherson (8):
>   nVMX: Eliminate superfluous entry_failure_handler() wrapper
>   nVMX: Refactor VM-Entry "failure" struct into "result"
>   nVMX: Consolidate non-canonical code in test_canonical()
>   nVMX: Drop redundant check for guest termination
>   nVMX: Expose __enter_guest() and consolidate guest state test code
>   nVMX: Pass exit reason union to v1 exit handlers
>   nVMX: Pass exit reason union to is_hypercall()
>   nVMX: Pass exit reason enum to print_vmexit_info()
> 
>  x86/vmx.c       | 191 +++++++++++--------------
>  x86/vmx.h       |  50 +++++--
>  x86/vmx_tests.c | 366 +++++++++++++++++++-----------------------------
>  3 files changed, 263 insertions(+), 344 deletions(-)
> 

Queued, thanks.

Paolo

