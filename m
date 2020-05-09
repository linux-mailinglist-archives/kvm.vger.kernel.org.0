Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5A81CC183
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 14:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgEIM4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 08:56:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46092 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726891AbgEIM4W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 08:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589028981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcPsPY6WHfZmHSMfmoBW7sCFJwh7lt3phoZvy4n953E=;
        b=UsjvN1BYydwqwsvg7lkamPyyOaxwFc1GjpqcahPIYumTNEfqO9+SHnNEhBHoPCkpLI01Q3
        aS24/G70J7Pg3AF6I9jIWYQGM6jVO6ICpDs0CKxqfOuAJowDjBxEeE3MaJ2ax5ckOv6iZJ
        uroiFo9EVkmMXNMMxpIcOeQtDbMBKao=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-MMdA9wMmN6GiWA0CS8yKGA-1; Sat, 09 May 2020 08:56:19 -0400
X-MC-Unique: MMdA9wMmN6GiWA0CS8yKGA-1
Received: by mail-wr1-f69.google.com with SMTP id u4so2350110wrm.13
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 05:56:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OcPsPY6WHfZmHSMfmoBW7sCFJwh7lt3phoZvy4n953E=;
        b=ajvk/tSQFRX2OYJ7BtHdvF0JOZpN8SoRyDz96PGa9IngGcOUi9Im5eWkghk6qbvr6e
         JZKnjol0qBTLrU7OebNtTPr+Zcb/h/lbKwjaYWuTINCU1hD8HLBN7SnLANFpwi9fonjA
         SkrZae3MKbg3n+5u3vi3T/BgAbagUmiz6WKcmMQobvs6jbla3tmjKTj5cMoVFMX64PjN
         /GMoE84O3DxotFq7MQNp84L2pPi4ZQUO0DN71mc73tM15a9cmpUxlspdUzGdkhGRCA4d
         0oTpSCYEKSali/Tha3Rf5eawk8+wcnY2iX7e5b80Iv1Ekj0lxrGg2VtKcoj97P+bTFTR
         AwnA==
X-Gm-Message-State: AGi0PuZH/KgJZaRsUTYdCKqrKrBfb6VzkhqA2PfChoSkYb2Sca7sD4io
        TxFlw4piTV/N/NuWzp/ncc4BU1A+p8B+K+2KoinkfInCuNRErxAPsCkaxRiNp9cJ+EU964AOnYZ
        NTg9hLPb9s/f8
X-Received: by 2002:a1c:384:: with SMTP id 126mr21473489wmd.58.1589028978695;
        Sat, 09 May 2020 05:56:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ2G1FPcqVncKvwGprCUBt/39qdkx14SFZxtsnzsgHgSdpuEf+JOw3PH3uIJOL0AFcfBCkjZw==
X-Received: by 2002:a1c:384:: with SMTP id 126mr21473476wmd.58.1589028978491;
        Sat, 09 May 2020 05:56:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id w9sm8649045wrc.27.2020.05.09.05.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 05:56:18 -0700 (PDT)
Subject: Re: [PATCH 1/3 v2] KVM: x86: Create mask for guest CR4 reserved bits
 in kvm_update_cpuid()
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200509003652.25178-1-krish.sadhukhan@oracle.com>
 <20200509003652.25178-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3b3650b2-1f9f-6567-bf6e-28d7eca2ed89@redhat.com>
Date:   Sat, 9 May 2020 14:56:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200509003652.25178-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/05/20 02:36, Krish Sadhukhan wrote:
> +extern u64 __guest_cr4_reserved_bits;
> +
>  int kvm_update_cpuid(struct kvm_vcpu *vcpu)

This cannot be a global, it is different for each guest since it depends
on their CPUID.  Please put it in vcpu->arch.

Paolo

