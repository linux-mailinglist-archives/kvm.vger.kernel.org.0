Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A250E31C70A
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 08:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBPHzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 02:55:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhBPHz2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 02:55:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613462034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2epUNgUKFXXf/WkQydvQpPBCPqOVb/ITJWd0srB/i6k=;
        b=G9LOBnz7xcEV9nHiN1qFqJQ+Yu89phHPcStVpLt1bXICkLrmBTByGDmcg5pa34RSPRC8np
        nX0LUaxggRm0BiJmA5d2f5+MuFkxJpwng18pa0jKSV5x8md/4eagrOkXe1cY6EX408D9to
        NjvDhgblYZnEG5vFkDDa650P9cIIpig=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-P0SLCw3oPsCdR9IYGb-83w-1; Tue, 16 Feb 2021 02:53:53 -0500
X-MC-Unique: P0SLCw3oPsCdR9IYGb-83w-1
Received: by mail-wm1-f72.google.com with SMTP id u186so7825602wmb.0
        for <kvm@vger.kernel.org>; Mon, 15 Feb 2021 23:53:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2epUNgUKFXXf/WkQydvQpPBCPqOVb/ITJWd0srB/i6k=;
        b=SW2fT46H3oWAkp9+UmjlRO6dOhSHb16QBoiyaOfJhvZk14uXpw/TLoht4JJA21lPNr
         LUiPBSSjmC0TdkVvevNXV57pgakR7QuPPP9zE9ZEVjXazhZ7wZkurS+UxdjDztBmMxDq
         DD6HSuFOqLBzqhp7mGTzLws52GtI2lfTDgIH34lZFgnr00rchngvMf9nDDCubxiTTZOz
         sWzMgcoRvWXPw2Wn3j8bJtSs0oePhRMf3eO/tzIiXKaQwCUhjUW8ll+txgq0mgZzgqnS
         27OQDM4FGo744WWRgjED+z95F8KZsN9TzYleUIo8cQZjlryKqWPqj4mgg0EukaZwH8s/
         6otQ==
X-Gm-Message-State: AOAM531Gby6aL3PN7eWvRch0lrfmZmxF7xNoclpjxwkZTdWhZ6ZaOdmH
        ugB4rBn5EJHSK7v7vNg4Xlo0zDiiKVtA74u7AonCljYELE4z4+51AtZtdwERQ6CHWcdovvOFwsJ
        vMkJmK4wh8UJOJiXxeD9oRCCniQcujfJAgeFB/gZWV1Q8vL08y+2OUzD75k2BiA==
X-Received: by 2002:a7b:c055:: with SMTP id u21mr2175102wmc.68.1613462031502;
        Mon, 15 Feb 2021 23:53:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyU6+LqWqrIkoytZyv4fR9m2jLGm4uxVvxAATHjRscloe7rJCIBkiXgVEsytNrpXC/Qp1kOBw==
X-Received: by 2002:a7b:c055:: with SMTP id u21mr2175076wmc.68.1613462031315;
        Mon, 15 Feb 2021 23:53:51 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id y1sm17508323wrr.41.2021.02.15.23.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 23:53:50 -0800 (PST)
Subject: Re: [RFC PATCH 01/23] target/i386: Expose
 x86_cpu_get_supported_feature_word() for TDX
To:     Isaku Yamahata <isaku.yamahata@intel.com>, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        isaku.yamahata@gmail.com, kvm@vger.kernel.org
References: <cover.1613188118.git.isaku.yamahata@intel.com>
 <c77664a9e03d53ed870635064551caa663b3dfc4.1613188118.git.isaku.yamahata@intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <ee62127e-3cf9-9da4-d248-7809324a8879@redhat.com>
Date:   Tue, 16 Feb 2021 08:53:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c77664a9e03d53ed870635064551caa663b3dfc4.1613188118.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/16/21 3:12 AM, Isaku Yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Expose x86_cpu_get_supported_feature_word() outside of cpu.c so that it
> can be used by TDX to setup the VM-wide CPUID configuration.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  target/i386/cpu.c | 4 ++--
>  target/i386/cpu.h | 3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

