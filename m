Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DAE424D6A
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 08:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhJGGwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 02:52:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231279AbhJGGwG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 02:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633589412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gR2IuP1xBNRrFxO5rgcYezdc7GQgLXrw0dvVXdXEOfw=;
        b=YHVJtODcGOMHceWdGyRlQz2quMJ9kgXmJ49ZCtGOz2XFWXYmT7gaa+GrXOQaqnRSGPI/fY
        s9jaFa2xA74I0GY/MnjpfnhcUdReshEaEeC2c3bQfibKMhbdy8xH8fqH1KGR5EaktacBSg
        P293khEuALJJqW66YYJn9VntTLTdGJI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-FqdktL9FOFClfloRf0pA8g-1; Thu, 07 Oct 2021 02:50:11 -0400
X-MC-Unique: FqdktL9FOFClfloRf0pA8g-1
Received: by mail-wr1-f72.google.com with SMTP id l9-20020adfc789000000b00160111fd4e8so3874629wrg.17
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 23:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gR2IuP1xBNRrFxO5rgcYezdc7GQgLXrw0dvVXdXEOfw=;
        b=0rcfuato6nATbmgk/TIyGgn8nzZIbYDrfkCxGVP/wjQyUuBhpqwUSubBmGNygXU1iW
         9Flx4Tm8RfgO/gGJIL0NFOS6BXnRgrxF/L0yxjo4tFrZLU1YLv9SM+CzPmcMahEXnK59
         /HIV1eRyf1iMoFjm1c+syUIe9qnLtcav7ymKnTHvXpRCZkjqZC1+9Fb60zEvhya+gvUf
         5Dq0NiNMFgVDJQq0HgGjpIPkUZMTl7M6Cb0ydbCGZ0oIErzkMnZGHR35Q7zzjwuoSHvI
         xbZfN6oOKAgSx8oxM1p+o1tE+QizTTX14e5qVtKipd3QaQEwqBFqrq+RB8RHDObOZBxl
         VVlw==
X-Gm-Message-State: AOAM533tdAUJOOHSADPhN1x6fHLEOhZ7ukYEtlOY+6DuNxo+SfcL++8U
        diPlAqEKFcwkJo9saFyJNTNQ2a3PiFEfiKWEn0GGrjc47ijSV8gG9TCRa+daAkla8QTDF9qTpy2
        kggJg6hd0UeRW
X-Received: by 2002:a1c:35c7:: with SMTP id c190mr14465354wma.57.1633589410170;
        Wed, 06 Oct 2021 23:50:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOuotUHTyBwzACujoGsab4OKfZgTHAnsCxJt/5wgt430jvUDzX9d4Oglqagdduip5iSkLI0w==
X-Received: by 2002:a1c:35c7:: with SMTP id c190mr14465339wma.57.1633589409957;
        Wed, 06 Oct 2021 23:50:09 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id k8sm597084wmr.32.2021.10.06.23.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 23:50:09 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 5/5] Use report_pass(...) instead of
 report(1/true, ...)
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-6-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f4617a8a-d274-c6ae-d395-73cdba19663c@redhat.com>
Date:   Thu, 7 Oct 2021 08:50:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005090921.1816373-6-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/2021 11.09, Janis Schoetterl-Glausch wrote:
> Whitespace is kept consistent with the rest of the file.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   s390x/css.c         |  4 ++--
>   s390x/diag288.c     |  2 +-
>   s390x/selftest.c    |  2 +-
>   s390x/smp.c         | 16 ++++++++--------
>   s390x/spec_ex.c     |  7 +++----
>   x86/asyncpf.c       |  7 +++----
>   x86/emulator.c      |  2 +-
>   x86/hyperv_stimer.c | 18 ++++++++----------
>   x86/svm_tests.c     | 17 ++++++++---------
>   x86/syscall.c       |  2 +-
>   x86/taskswitch2.c   |  2 +-
>   x86/tsc_adjust.c    |  2 +-
>   x86/vmx.c           |  6 +++---
>   x86/vmx_tests.c     | 36 ++++++++++++++++++------------------
>   14 files changed, 59 insertions(+), 64 deletions(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index dcb4d70..881206b 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -31,7 +31,7 @@ static void test_enumerate(void)
>   {
>   	test_device_sid = css_enumerate();
>   	if (test_device_sid & SCHID_ONE) {
> -		report(1, "Schid of first I/O device: 0x%08x", test_device_sid);
> +		report_pass("Schid of first I/O device: 0x%08x", test_device_sid);
>   		return;
>   	}
...

Thanks, I've applied patches 3 - 5 now to the repository, since there were 
no objections and they are independent from your spec_ex work. (Dropped the 
hunk to spec_ex.c here of course, so please integrate that in the next 
version of that patch directly instead).

  Thomas


