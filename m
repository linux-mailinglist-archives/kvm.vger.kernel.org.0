Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC4036D67B
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhD1Lb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 07:31:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229920AbhD1Lb2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 07:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619609443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jdsbTTMzPGFGxDRh0SbwnkbDTsMuhtjbRoLXEGmuhf8=;
        b=IKcPOyE7fXkVbne5YCYlCzAK/KBVrB0NbM45LjH/oVFaj94txBmYZcgOp0rdzbj4EOWXb7
        58xlBhCfUi9VjpcKdCXmkaZnG+qeFGcfsKgEfOn895YQjQgw2yv+X0ttPby9sDj54jH1jf
        3H4iB3/qbzJCDhSbt+716XzjVr8PiYA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-GuV4UrLdNR2i_z7Z8TD8_g-1; Wed, 28 Apr 2021 07:30:41 -0400
X-MC-Unique: GuV4UrLdNR2i_z7Z8TD8_g-1
Received: by mail-ed1-f71.google.com with SMTP id z21-20020a05640235d5b029038795ac4cdaso5721028edc.22
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 04:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jdsbTTMzPGFGxDRh0SbwnkbDTsMuhtjbRoLXEGmuhf8=;
        b=jjOo5392rU1zPbTaIWocquhvjTOFTU2fYNDXV2cElbubaZyUeEOO80hYkJ3eDqW158
         OA/DfLvx4M4Djqju967XTzSElpcdjVOpOrRnJ6fGmScfQvtlEdt3AgJ0V/HlNXsNbQQ/
         52mG8BnaQ/yLIP2+5K23rbnmnjjZoEfuXShByDNXXfqFWOoAIXS9/PSLT7G1WLm99h8v
         l8L4t3h9HS8KhzoDOJJQUzCzO7oLbubnD7vQT/Qd6Mcx1ZOlghLzU99nVnNk/vGE2ewa
         4G1AZgngDOCKyg7/YwAneufaAMfQ2LryLoA5crUfDeR+LkuNYyWX2aBi6WBm4uWP9il/
         SRew==
X-Gm-Message-State: AOAM532b+vNfGVe8Z15YX4FRumIIp+F++bccGhQydlbXmjt70zsZBD29
        NymZu5mDvbodYVMqDEETdK2h+QKO/B+xV7gYJlqfjaceS6b2Mvn6GZC3/+xgjLVfWWkfWXJ3YTH
        EIigg0/PWWkGL+PsSQnRLzI5UeJv0sxnS/Oy4QMf8Y2RA7xZe46X3cPkzY15VUYPQ
X-Received: by 2002:a17:906:747:: with SMTP id z7mr1756738ejb.252.1619609440562;
        Wed, 28 Apr 2021 04:30:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWZO6y9ftLimupDCzGBMR+ik/03erDzkGLxMFCaB0DrpSuF6wU/r1zL4EsXfYR4R3ey0+p+w==
X-Received: by 2002:a17:906:747:: with SMTP id z7mr1756712ejb.252.1619609440395;
        Wed, 28 Apr 2021 04:30:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q25sm1727304ejd.9.2021.04.28.04.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 04:30:40 -0700 (PDT)
Subject: Re: [PATCH 3/3] x86/msr: Rename MSR_K8_SYSCFG to MSR_AMD64_SYSCFG
To:     Borislav Petkov <bp@alien8.de>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210427111636.1207-1-brijesh.singh@amd.com>
 <20210427111636.1207-4-brijesh.singh@amd.com> <YIk8c+/Vwf30Fh6G@zn.tnic>
 <9e687194-5b68-9b4c-bf7f-0914e656d08f@redhat.com> <YIlGvdxZVa0kiJf4@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8dee542f-889f-ab38-80cf-214af2fcd369@redhat.com>
Date:   Wed, 28 Apr 2021 13:30:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YIlGvdxZVa0kiJf4@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 13:27, Borislav Petkov wrote:
> On Wed, Apr 28, 2021 at 12:55:26PM +0200, Paolo Bonzini wrote:
>> There shouldn't be any conflicts right now, but perhaps it's easiest to
>> merge the whole series for -rc2.
> 
> You mean, merge it upstream or into tip? I think you mean upstream
> because then it would be easy for everyone to base new stuff ontop.

Yes, upstream.

Paolo

