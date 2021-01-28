Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C315930745C
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 12:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhA1LE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 06:04:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229786AbhA1LEL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 06:04:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611831763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a1m/cLEY13tDBo0h/pnmMRjcNA7DsFWhW2/f2XTrp0s=;
        b=DfJWTj6TqHXXPx4ljIjNyHRdISoA+vYnoJKfqPCFiUIKjrVes7+vZneQ/CGbZnLu315rpe
        P+aU9EfXYyYaYCByqUaoxyvjixjTIDa+9q1RSz096+hSzYTjQSc2OXSCudBHi/GNTYE074
        DyfPfeZR+FfnOf++2nG+n7XcNnnM/Uo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-C0XcoJ88PiSuQy3UOIcTGQ-1; Thu, 28 Jan 2021 06:02:41 -0500
X-MC-Unique: C0XcoJ88PiSuQy3UOIcTGQ-1
Received: by mail-ej1-f70.google.com with SMTP id md20so2016034ejb.7
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 03:02:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a1m/cLEY13tDBo0h/pnmMRjcNA7DsFWhW2/f2XTrp0s=;
        b=NQkLO+D+Yit/9nQJYADi3d496hUdP13rZ+184OkssK2MejyDCwgN/19xu3WStsE4GR
         foHHDRZXj5OXZu/gE4PNIdbJpVLb7LNjorle/csC2++z/9kC15fSV7xHg7R2F7Hozil5
         I8e7dJeb6lpjdwtP0eXigb0GDVkvweM65PXE0XEvXK6vJ/uvZSp9UWr+tdEUe8gyWNyJ
         VXaBtSE0g/kX3rvDUEs8nTuj1px4OdbrOpKgRfB0MH09+d64inPT0eSJWi4rksVzJvmi
         Rk+H7rUXUYCI09sC2rwfvThHU43YnbFMNJLKkMWVhNPBvLq1wcdHp9nKqPYm1Ctb27KS
         2iAA==
X-Gm-Message-State: AOAM53155kLViu7Y3oXs2nru+Bt8qddIqBQNnnLhEFLccQ+MH8ksRCap
        UEZmqyEp4VOFYsnTHUqr8SZsHZCN/SJsyCwC5iqMYfW3fpWiWzxLZiVV8nihsovvsiYkQL+aEOq
        Uu3RG6T1Y4r7X
X-Received: by 2002:a50:a684:: with SMTP id e4mr13175033edc.148.1611831759975;
        Thu, 28 Jan 2021 03:02:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5o0yFDHCP7AW+sMzk1kU26igHGH7CIrhoMMQUw8WORBv6tISsBZGWNtT/9Otdx6ekWCpc4w==
X-Received: by 2002:a50:a684:: with SMTP id e4mr13175005edc.148.1611831759796;
        Thu, 28 Jan 2021 03:02:39 -0800 (PST)
Received: from [192.168.1.36] (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id e27sm2164457ejl.122.2021.01.28.03.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 03:02:39 -0800 (PST)
Subject: Re: [PATCH v4 00/12] Support disabling TCG on ARM (part 2)
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>
Cc:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <87r1m5x56h.fsf@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <98f06a0a-efe6-c630-8e68-0e4559f04d58@redhat.com>
Date:   Thu, 28 Jan 2021 12:02:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87r1m5x56h.fsf@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 1/28/21 1:41 AM, Alex Bennée wrote:
> Philippe Mathieu-Daudé <philmd@redhat.com> writes:
> 
>> Cover from Samuel Ortiz from (part 1) [1]:
>>
>>   This patchset allows for building and running ARM targets with TCG
>>   disabled. [...]
>>
>>   The rationale behind this work comes from the NEMU project where we're
>>   trying to only support x86 and ARM 64-bit architectures, without
>>   including the TCG code base. We can only do so if we can build and run
>>   ARM binaries with TCG disabled.
>>
>> v4 almost 2 years later... [2]:
>> - Rebased on Meson
>> - Addressed Richard review comments
>> - Addressed Claudio review comments
> 
> Have you re-based recently because I was having a look but ran into
> merge conflicts. I'd like to get the merged at some point because I ran
> into similar issues with the Xen only build without TCG.

I addressed most of this review comments locally. Since Claudio's
accelerator series was getting more attention (and is bigger) I was
waiting it gets merged first. He just respun v14:
https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg07171.html

