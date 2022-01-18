Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E24492B8F
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346352AbiARQvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:51:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232705AbiARQvd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 11:51:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642524693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKYWJjHaKkDqGDgJvDNQ90dTK1NUYRCdx7+/Kujc9qs=;
        b=TE6MLH/lbT1fDM4G5DreztkC5q3bQNo7Bb/Eak8la+kbvy9X0DQV3QSvJJvouppqyiweZN
        dsDf0+orhi+PKh5X0QGKvvyqjZXlHTKCn5xMLjm8FPoeT1QznaPTFDuQObdI4QwepFBRpA
        mky3F0ezKxx2q+lWuXSzhH1KoU1zdvU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-iWkcEOCZPeK6ks5QZdJyKQ-1; Tue, 18 Jan 2022 11:51:31 -0500
X-MC-Unique: iWkcEOCZPeK6ks5QZdJyKQ-1
Received: by mail-ed1-f71.google.com with SMTP id j10-20020a05640211ca00b003ff0e234fdfso17635526edw.0
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EKYWJjHaKkDqGDgJvDNQ90dTK1NUYRCdx7+/Kujc9qs=;
        b=PmZVJsR0sd4tHSxO5o7bwBeVzemGZR80eKRTMc4FVFkIX7IdCwG+ZOW70c5rzBwxIm
         Gjjqj7Czgad0TlMaZLpX3EvkZYjxmwUzRMyOcH+j6lJWejkBHjvSI65w3nBWpWSABOCf
         8S85F8MsA/Gzo6GsdGxSlNbE12aNhod2z08syCFGsQP0dyDBE9WySEzy1jhkbHl6/xvy
         w2PeC/+hx6DFVPaaFkkhJiaUpFwrEXm9OJ2p3C+/aTNbAElq4oBkX1mQSFWrAYGPfo1k
         W4B5PTT0sr3M/31ufV90rNWUMttDTd7WOpd3qxRkUa1VYLf7K8yE9WCyclYBZv0aRCwq
         5YEA==
X-Gm-Message-State: AOAM5318PZJVTByOR8q76PGY5UX2gpxbrFJJW4E3CNGqPEyTKTuyx3TL
        tyYDZ+aqFNVJJjHc08pJNE2QKJ4eG8CBYC9XXCOH3j3d2DnezoyO0fIsNnM6Ya11xGmRPAoqlwK
        X9K8AW0iE1kYy
X-Received: by 2002:a17:906:c441:: with SMTP id ck1mr20757505ejb.257.1642524689528;
        Tue, 18 Jan 2022 08:51:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6XsBPjVky+XVFRmlTClcsK61iNNWb7Jo1vjw9LBtCMDyvfGsj430MAqDJzEpJhDqFFemIwQ==
X-Received: by 2002:a17:906:c441:: with SMTP id ck1mr20757484ejb.257.1642524689248;
        Tue, 18 Jan 2022 08:51:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id q20sm103835edt.13.2022.01.18.08.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 08:51:28 -0800 (PST)
Message-ID: <7ecac5d3-a132-73cd-e5b9-8f35cf946d4b@redhat.com>
Date:   Tue, 18 Jan 2022 17:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH v2 00/10] x86_64 UEFI set up process
 refactor and scripts fixes
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211116204053.220523-1-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116204053.220523-1-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 21:40, Zixuan Wang wrote:
> Hello,
> 
> This patch series refactors the x86_64 UEFI set up process, fixes the
> `run-tests.sh` script to run under UEFI, and improves the boot speed
> under UEFI. The patches are organized as four parts.
> 
> The first part (patches 1-3) refactors the x86_64 UEFI set up process.
> The previous UEFI setup calls arch-specific setup functions twice and
> generates arch-specific data structure. As Andrew suggested [1], we
> refactor this process to make only one call to the arch-specific
> function and generate arch-neutral data structures. This simplifies the
> set up process and makes it easier to develop UEFI support for other
> architectures.
> 
> The second part (patch 4) converts several x86 test cases to
> position-independent code (PIC) to run under UEFI. This patch is ported
> from the initial UEFI support patchset [2] with fixes to the 32-bit
> compilation.
> 
> The third part (patches 5-8) fixes the UEFI runner scripts. Patch 5
> sets UEFI OVMF image as read-only. Patch 6 fixes test cases' return
> code under UEFI, enabling Patch 7-8 to fix the `run-tests.sh` script
> under UEFI.
> 
> The fourth part (patches 9-10) improves the boot speed under UEFI.
> Patch 9 renames the EFI executables to EFI/BOOT/BOOTX64.EFI. UEFI OVMF
> recognizes this file by default and skips the 5-second user input
> waiting. Patch 10 makes `run-tests.sh` work with this new EFI
> executable filename.
> 
> This patchset is based on the `uefi` branch.

Hi, I have now merged this series and the uefi branch into master.

Paolo

