Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CBB4363D2
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhJUON7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:13:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhJUON5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 10:13:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634825500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEGKw1JXCuFm2P2hiMnuEAZ6d/dj917JhH8p7zOM9UQ=;
        b=gZpd8/uvb4ekz3fvqxvtT5QOL+l3jLS1vSv4idfXH3ePYHVmIIo7H3rhDR7J3nTvnWUFa9
        X7od33zunrCgLAOa7B80DQyi1OcDfOohl8XDlVX8x+WBR+dZXEIkJ9OuAWSHJRRkqRtNTa
        5PRbWpZDbH8lD5sPYhivc5RYrU2gGRQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-JoD6BgwiMeuBbP13KqlFeg-1; Thu, 21 Oct 2021 10:11:39 -0400
X-MC-Unique: JoD6BgwiMeuBbP13KqlFeg-1
Received: by mail-ed1-f69.google.com with SMTP id p20-20020a50cd94000000b003db23619472so434489edi.19
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kEGKw1JXCuFm2P2hiMnuEAZ6d/dj917JhH8p7zOM9UQ=;
        b=NDKEA22vT34iRw7nCHZRcOVS/RH+t41Po3YhpL6crhuwRisOTpNAjKo9z2Gt9yGGss
         n7wp8lQKBIcyu41Mgn6Grihb8HnuFfIK9EVGSn4WL36528wthXdQcgvSbGeLSpTVP8qY
         4lbJAo5H/4ZJuxjuwAVURV32lYsuo2SPQKqMeqvObzfK7D8bjq2StljeU8YDrp1M4M5m
         3WdTyy4Jya3MP6r9h/K6xB56vVhpNpv/BSqSA2Dy+vuUanFWyEcLp8cdE0xePnAci62H
         PVjWqYEpT5kr04FCeJcneeAzE12dYpICfSLPfe+nidbLtdGBH9LApXcoUD1EQNbKZB5U
         SJHg==
X-Gm-Message-State: AOAM531NLQ4Wf0iLhtSzUT/nJkUWAiajguIF0ipzfxGXoAIeLnvRoVJC
        5kVlYr2Aqyp4rTQKfWomwLpDFHkojKCdrptVyy8AfVpTpY95iR74js87KhNI6b8TnH1PC9D2dPZ
        e+alTM+NYbohJ
X-Received: by 2002:a17:907:1119:: with SMTP id qu25mr7330401ejb.245.1634825498578;
        Thu, 21 Oct 2021 07:11:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHQz9ROZWQQD6mJjgFVTvCvKqfpK4eVc0xt1EdQTk6vqkDF4uXy1SGixfBrZTO6GGnY7l/0g==
X-Received: by 2002:a17:907:1119:: with SMTP id qu25mr7330381ejb.245.1634825498360;
        Thu, 21 Oct 2021 07:11:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id u4sm2529633ejc.19.2021.10.21.07.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:11:37 -0700 (PDT)
Message-ID: <b3adf3ee-d36f-6588-dd3b-60e6b4405554@redhat.com>
Date:   Thu, 21 Oct 2021 16:11:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 05/17] x86 UEFI: Boot from UEFI
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-6-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211004204931.1537823-6-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/21 22:49, Zixuan Wang wrote:
> +"$TEST_DIR/run" \
> +	-drive file="$EFI_UEFI",format=raw,if=pflash \
> +	-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw \

For what it's worth, SEV doesn't work for me unless I add ",if=virtio" 
to the second -drive option.  Since it's a good idea anyway, I squashed 
it into the patch.

Paolo

