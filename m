Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D16114943B
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 10:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgAYJnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jan 2020 04:43:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33505 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgAYJnz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Jan 2020 04:43:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579945434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtwLk/B10zADjQXX+X2MD/P1lF7/5erRqITn7FrO66M=;
        b=GBCIoLoHmfzwFfB4okYz2LYhWRqVWM17xU1pelrjpoP0eVGg/PPVVHL56FIyGL1/gqtuYg
        90AkeQ4fxfPocIfMvbHkAyrOiPl7jl1DWyeCkQt0aZFCVl37A6GNVlzHHUHLDGoSQ1JLGZ
        5Lkgz66qnzp/etstIRzJtiLyzi37X0U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-TcXIpHPCM6yojFMV2fNKeA-1; Sat, 25 Jan 2020 04:43:52 -0500
X-MC-Unique: TcXIpHPCM6yojFMV2fNKeA-1
Received: by mail-wr1-f72.google.com with SMTP id i9so2771579wru.1
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2020 01:43:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vtwLk/B10zADjQXX+X2MD/P1lF7/5erRqITn7FrO66M=;
        b=EiGqPYHjoL4IS5ADX6Ibd2tyF4hpSkQof+IOUrwnVAZsfS5CUb3Cqen0k7mR0z9D2x
         U4rjzvD7xxKEKDTr292njEXtwW61yk5X1U8syYzSty7dWoLgsIpd1GU2HE7u5EOPngCb
         Yskgkb7IZWeB4OFApGJ2T5LktioGfzl2dihwRW5GSgEqhL5nE2jebja8Sj1P4aTKYNUn
         IOB/io1E4YB20Oel/gKrwd6wsqTFoyZ/Xq4JJtA7FUDdrrOAluNKdqQdk4ZGCVRtCMxj
         KUL8uVX+vZEptAdyUuqCiNIKgnqhnUbzS5DI9MWs75gUBmRyXTt7VPfgBnI/tjNs4n4+
         75Ow==
X-Gm-Message-State: APjAAAUpoRecDxBQDNjQ5uB/Ppnf8mR4wgRhj3XikjvpBeYzQW5rhJMW
        +Rct49x9q6Fy6pVuNBqaUqINCQgZoggEA9aKQeqzOaqflmx9sE13geN4YazG3uBZ7HkmJdcz+SE
        GwxdvtRQYG9cC
X-Received: by 2002:a5d:494b:: with SMTP id r11mr9366396wrs.184.1579945429335;
        Sat, 25 Jan 2020 01:43:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqytPPRY/S7t6ebfJWMn9qDMOKtgxtMkFE1VzGCeIERw87jrfrhEtkIl6RQpqHYAiKtSmVpgrg==
X-Received: by 2002:a5d:494b:: with SMTP id r11mr9366372wrs.184.1579945429077;
        Sat, 25 Jan 2020 01:43:49 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a14sm12246332wrx.81.2020.01.25.01.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 01:43:48 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
To:     Nadav Amit <nadav.amit@gmail.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e6e7038-bd41-9f53-b220-f8fc2878b2bb@redhat.com>
Date:   Sat, 25 Jan 2020 10:43:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/01/20 00:13, Nadav Amit wrote:
> Running this test on bare-metal I get:
> 
>   Test suite: rdtsc_vmexit_diff_test
>   FAIL: RDTSC to VM-exit delta too high in 117 of 100000 iterations
> 
> Any idea why? Should I just play with the 750 cycles magic number?

Either the 750 cycles number, or the 99.9%.  Do you see it on all hosts?
 Some are more SMI-happy than others.

Paolo

