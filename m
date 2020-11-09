Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0AD2AC1DD
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 18:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbgKIRKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 12:10:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729776AbgKIRJ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 12:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604941798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DF6kIbesKIdPKV7reK7F1kXdzuUQEDq7Vmh4nCVDjiU=;
        b=aU90p46DGGz+fOroDqGzLnGutDGQCMhq4QtOkSQIqqoKdykEgOiE4d039BYFM1t6uhgbOq
        MI8hMb0dATqlJn4q0TlvrmL/Rgm+5e/nf7AoJT/0aA0lBqrunmZ5lYVKH+n37LKzaMKJ1i
        xqLV9a1ldSdbdbH2jwhf4VrEIJeYKFM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-lJfpJiNrM2ebdop-N7SkhQ-1; Mon, 09 Nov 2020 12:09:55 -0500
X-MC-Unique: lJfpJiNrM2ebdop-N7SkhQ-1
Received: by mail-wm1-f71.google.com with SMTP id h2so32482wmm.0
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 09:09:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DF6kIbesKIdPKV7reK7F1kXdzuUQEDq7Vmh4nCVDjiU=;
        b=iCdb01w8Das1R0Il5KB3tZ6ilVmUgPXTaQzc5g2uW1ffRzrVDh368qOZLQ2ZtrBBPh
         SP4ZOrtynlV6Lxeo5zFuk6+6Zspjs8lriB9DgO0iJcOGIYZxRXbX834hyqa68xnNkDJn
         O7IdhBUls+CP+6IzhZliJzt3VvntxZkGouURLUEQ7I5lGn/ntFvdFN76Wom+5wvOJDn4
         d5kqoH1ZFdoz6hp9DMSHssd0SRTO7ddqKpavtda1PAi1twFMxVAU7WCSqjk8Rliesmp3
         00hTAhjblT6is0dNXIEYf4p9dVBVgGSE0+G0AFJCAUtB+NsLtjXhon4Xn6y/kmxtOx6P
         WXgA==
X-Gm-Message-State: AOAM530ytOEuOARLslUHn54wRTp/Ib3TPbbDGu7JVQzxukLYwQoKG3lV
        N+L8/hOuvS6Xsw4AuTprCxL/qdUmzr8aLVFzXbthTlthuBR3/WkhwaHFaQboEDcLH2Ri+AHAIg5
        CGvhnrhpHC1RW
X-Received: by 2002:a1c:a952:: with SMTP id s79mr104158wme.155.1604941793558;
        Mon, 09 Nov 2020 09:09:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFOhBl7OFnqcmRWt0VlvqiDlIrHULbljLMAl1ECN9PhZkfDkQczetj9OsDY/gzhzZaOWGL5g==
X-Received: by 2002:a1c:a952:: with SMTP id s79mr104137wme.155.1604941793363;
        Mon, 09 Nov 2020 09:09:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f17sm30374wmf.41.2020.11.09.09.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 09:09:52 -0800 (PST)
Subject: Re: [PATCH v3 4/4] selftests: kvm: Test MSR exiting to userspace
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <20201012194716.3950330-1-aaronlewis@google.com>
 <20201012194716.3950330-5-aaronlewis@google.com>
 <CAAAPnDGP13jh5cC1xBF_gL4VStoNPd01UjWvkDqdctDRNKw0bQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1e7c370b-1904-4b54-db8a-c9d475bb4bf5@redhat.com>
Date:   Mon, 9 Nov 2020 18:09:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDGP13jh5cC1xBF_gL4VStoNPd01UjWvkDqdctDRNKw0bQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/20 17:58, Aaron Lewis wrote:
>> Signed-off-by: Aaron Lewis<aaronlewis@google.com>
>> Reviewed-by: Alexander Graf<graf@amazon.com>
>> ---
>>   tools/testing/selftests/kvm/.gitignore        |   1 +
>>   tools/testing/selftests/kvm/Makefile          |   1 +
>>   tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +
>>   .../kvm/x86_64/userspace_msr_exit_test.c      | 560 ++++++++++++++++++
>>   4 files changed, 564 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
>>
> It looks like the rest of this patchset has been accepted upstream.
> Is this one okay to be taken too?
> 

I needed more time to understand the overlap between the tests, but yes.

Paolo

