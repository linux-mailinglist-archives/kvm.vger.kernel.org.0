Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5704FCB50A
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 09:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbfJDHdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 03:33:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59637 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728625AbfJDHdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 03:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570174421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=8Y//Zmntx4ufnGGRI8hf20Nrx5NIc6pYNaUZckNMkBo=;
        b=VQCZ4JuKJl3MrdqvF2AiRQlqKVlAxS9iOVKDaFi6WIRgVOW5WVJYh5P3+6Ng4l6t6aVMSw
        BWNtlvLCvjCVjabtQM3Lx4ph10yss2pvEf1E1iD26QSs78rFAnt3dU314jyyggH0Pm4ftg
        CndjwenTNfa/v4PhCstlJZkTAD8UgRU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-lF3yqzOTPgCXKx-Y6IlWPw-1; Fri, 04 Oct 2019 03:33:37 -0400
Received: by mail-wm1-f70.google.com with SMTP id o188so2257151wmo.5
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 00:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t4ppAKkwTNFOQrRrntnYHnidIdCMVMlsgWRFlLoEftU=;
        b=GgH0bLFHatYA4BmHpQZkzj8zT3QwRa+5Y1OpLJeQ7ygmuf/RS7r8VuG0OtE8A2pq71
         ulPqxVVVFgYeyHz3I9kMXzIQb9j+kECB5UYt8csDWcF9FFDdXxWR9lT4hmg8YSY67Mdn
         OkTD9DCgq0RwalRavvqqlYe3rhvFkabp2XsEd1f7RQKi3O8A+WK3099su28rGS9gV5Rk
         FHAedb64+8qqz+dVWlQmdB4Z3z2PbiPakcjn4OkgwGHGTHxe+dwiwzrPfAmXgAOWyucP
         TKcemptP3sg3phW3+0m3l2PtuBj5JbyPiqO9zxjQI2jRiFfsXL3DjpzodTu68kjgTvvW
         VyFw==
X-Gm-Message-State: APjAAAWUjzxw8oYbpNSdKdd09VtA2yAFKIDuW/KugP0M/L7hNurE7//v
        nAWF/CxWnTxekMBxASm49kdr517B3RuTlWh5WSOOhQNhOZB0pUpbIOPDqvP7Xg9YdT7qqHt1l4g
        Ew0kHz5KMvxhk
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr11022756wrt.100.1570174416797;
        Fri, 04 Oct 2019 00:33:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwHyEyM3S+vayaNWQN/Gp53Rbi7fPv/uH0l0mxTG5dhQxQVT8pRgCbd+4675sQR97/I/iY/tg==
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr11022736wrt.100.1570174416564;
        Fri, 04 Oct 2019 00:33:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id e9sm15809881wme.3.2019.10.04.00.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 00:33:36 -0700 (PDT)
Subject: Re: [RFC PATCH 10/13] x86/mm: Add NR page bit for KVM XO
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        luto@kernel.org, peterz@infradead.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-11-rick.p.edgecombe@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <19d7bde0-6063-c337-994f-0c75cbcfb721@redhat.com>
Date:   Fri, 4 Oct 2019 09:33:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003212400.31130-11-rick.p.edgecombe@intel.com>
Content-Language: en-US
X-MC-Unique: lF3yqzOTPgCXKx-Y6IlWPw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 23:23, Rick Edgecombe wrote:
> +/* KVM based not-readable: only valid after cpuid check */
> +#define _PAGE_BIT_NR=09=09(__pgtable_kvmxo_bit)
> +#else /* defined(CONFIG_KVM_XO) && !defined(__ASSEMBLY__) */
> +#define _PAGE_BIT_NR=09=090
> +#endif /* defined(CONFIG_KVM_XO) && !defined(__ASSEMBLY__) */

Please do not #define _PAGE_BIT_NR and _PAGE_NR, so that it's clear that
they are variables.

Paolo

