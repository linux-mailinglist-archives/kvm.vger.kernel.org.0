Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663871F0A65
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 09:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgFGHj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jun 2020 03:39:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726192AbgFGHj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jun 2020 03:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591515566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aPxOctvuqxqnbhZwljS2gAqFDLDMhwYYqIKqplLlD90=;
        b=RQwEdcDEb9xrOtP9ddjvOCD8FfEiYWL7eB6i/J2Qik3JeRh/QRWM5w/xPdavgzPeAZiv9m
        FTuYV/09DKsTr2lFXmX2zQRqx4IcS3XLurOxfCqoT7wgQyLrCe60xzMYn5sfTJ1a0ZOBSr
        k1hbA2xLJejHv+ZIevB9h2UugXuxom4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-WLACFa4nPoCW6Qi4Ew_6pw-1; Sun, 07 Jun 2020 03:39:24 -0400
X-MC-Unique: WLACFa4nPoCW6Qi4Ew_6pw-1
Received: by mail-wm1-f72.google.com with SMTP id t145so4139967wmt.2
        for <kvm@vger.kernel.org>; Sun, 07 Jun 2020 00:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aPxOctvuqxqnbhZwljS2gAqFDLDMhwYYqIKqplLlD90=;
        b=GrSsRiL9brJHWcBtcVOdFkaNXJu4YNcidU3gxsLnp/1xdhRpmmZFga8bM5gj+t4goA
         v26+4TbvCm/jnmXq8J0L1NzL4zt0cFYyFeHVqwpVT58ueu1Y9hCabP0kh1y79AYEaDWf
         aX2HPYHJ23VgBbghHPdJ2ONdu0o6kw9lzj+h0OUpeh/VgxExg6aL1xKGrEaIvzUU2guh
         6Uu7kYPD6IfXWjItCotixX4r5NUZwD6BqbZo6sWDFnqgQtQxkeyrYpwlTzZppsyxdKjR
         DTT1fPf0xGBXDZuEHMgrNklkWsbbPQCOOM5FDHDv4kffNacvmP/Uz+GSv5f3FkQkNo74
         1Kow==
X-Gm-Message-State: AOAM530hvKd+4d0v2ZykvjDc39s7mhcgJ9PP3MZWB36+8CMp3lQXX54a
        pegz6JAsev82+qN48BHtLdV9yI8HYLN2XrrYU1Y58MVQZMC3lrdjpNF8NanVaeNTJH6SHRCiljM
        UnFfbgakKiy3q
X-Received: by 2002:a1c:6a0d:: with SMTP id f13mr10933446wmc.180.1591515563037;
        Sun, 07 Jun 2020 00:39:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIHEhzSqDFLn756skBbmNZ7FmjftF4hDhkryd3J6mqhjd1sVVDGYYfLDbsGMd69xeQoYXf7g==
X-Received: by 2002:a1c:6a0d:: with SMTP id f13mr10933433wmc.180.1591515562767;
        Sun, 07 Jun 2020 00:39:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a973:d537:5f93:b58? ([2001:b07:6468:f312:a973:d537:5f93:b58])
        by smtp.gmail.com with ESMTPSA id m129sm19349888wmf.2.2020.06.07.00.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 00:39:22 -0700 (PDT)
Subject: Re: What will happen to hugetlbfs backed guest memory when
 nx_huge_pages is enabled?
To:     Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc:     kvm@vger.kernel.org
References: <CANR1yOopgAkoT6UmXZjUaFHe2rPBn_R2K=i_WNzFpDRdtR-uDQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e57ba8c-7dfe-d52f-3bde-a8c28081026b@redhat.com>
Date:   Sun, 7 Jun 2020 09:39:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANR1yOopgAkoT6UmXZjUaFHe2rPBn_R2K=i_WNzFpDRdtR-uDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/20 05:43, Takuya Yoshikawa wrote:
> I understand how this works for THP backed guest memory, but what 
> will happen to hugetlbfs backed guest memory?
> 
> When a huge amount of system memory is reserved as the hugetlbfs
> pool and QEMU is said to use pages from there by the -mem-path
> option, is it safe to enable the nx_huge_pages mitigation?

The erratum arises when the guest sets up two iTLB entries of different
sizes for the same page.  Using 4 KiB EPT pages for executable areas
ensures that iTLB entries will all be for 4 KiB pages, independent of
the page size from the guest's page tables.

Therefore, even with hugetlbfs the EPT tables will be split.  There's no
requirement for EPT pages to be the same size as the host page tables.

Thanks,

Paolo

