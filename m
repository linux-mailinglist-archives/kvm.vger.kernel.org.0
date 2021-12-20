Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498A247AA3F
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhLTNUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhLTNUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:20:02 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E0BC061574;
        Mon, 20 Dec 2021 05:20:01 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e3so38243237edu.4;
        Mon, 20 Dec 2021 05:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sznSBYv8ZRRqDdS/2Qsbhy2f6IN9OI8osrxjG8Xj5LI=;
        b=TvWBRzsSITWz4iGYO28BrrdkIqMHhav+rpgRxv6vqS6SOuueX3zs5DP2CONkx+quHO
         qCEl+9lhe9IP0o1OeBkBn55lMdn5ln8fiz5/xmUvyC0Xa7FV3ZmdPD1Mby/8l1h9CG/C
         EKbkAFntS63UfhGKblYbRo/XZ5cD19492ZlL/S9EHrmhsfYtXTTfyIHF8gAUvrlKNrB4
         0DFrlWqAAmA2pu+IJBKG8EuvhlHB6dyQLHDS+BflhojVxdvzoOJ/FyDX0CB1ScQAsAFz
         tQT2Uus+eLUE8/BJo1s+ImHnN0YN3SepslJ7xmSMWtSbTbChE4cf1n2zwV2vm+P5wgmG
         Bk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sznSBYv8ZRRqDdS/2Qsbhy2f6IN9OI8osrxjG8Xj5LI=;
        b=Tdz0810Fd7f0GA8kE0jOQUxziZAEqbqeoV1OpT6BV+Ie//SI0s9YSzQOQFgu3b4acL
         f25JXS9hJLbbINWssSFHonkPCklJ3XlVBt6xMEBs+2KqKoA4hsnBxnncT5aJk6g6uhvR
         XLlzBGXfd6aE0nOWokhSXmk68w3Uo2u1rN4ioIg/6mSw7IIpwbgaauzMwVrndQYglDB2
         kmRnH9y7+wDE6kBec+os8Dd8rYQnMO0qR18mufNATx2W1AQtM2fPSWLx2kByqfW4uyHr
         MomKazPUg/LKryExi09t0Tagsv81XCNYnB3zgnZUoqCxVQRoB4FPD8V9mxZeKH8UksvS
         D38A==
X-Gm-Message-State: AOAM532+5o2jsauGQBuW4anZMemD46AfQkFrJh3mgJ0Zu9rEfltzi01V
        Bj3cvMqx/iTtxiG3EYG15h8=
X-Google-Smtp-Source: ABdhPJyTBIHrCoL/bg48I4qJRB9AS/YnRAl5DgSTMqM63PNQWNfZuFmuhHtU7NM0trEkiCOcdhvyYg==
X-Received: by 2002:a50:9ec9:: with SMTP id a67mr15927283edf.238.1640006400247;
        Mon, 20 Dec 2021 05:20:00 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id bx6sm1306840edb.78.2021.12.20.05.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 05:19:59 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e20f590b-b9d9-237d-3b9c-77dd82a24b40@redhat.com>
Date:   Mon, 20 Dec 2021 14:19:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 19/23] kvm: selftests: Add support for KVM_CAP_XSAVE2
Content-Language: en-US
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, guang.zeng@intel.com,
        wei.w.wang@intel.com, yang.zhong@intel.com
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-20-jing2.liu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217153003.1719189-20-jing2.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 16:29, Jing Liu wrote:
> @@ -370,6 +397,10 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>   #ifdef __x86_64__
>   	vm_create_irqchip(vm);
>   #endif
> +	/*
> +	 * Permission needs to be requested before KVM_SET_CPUID2.
> +	 */
> +	vm_xsave_req_perm();
>   
>   	for (i = 0; i < nr_vcpus; ++i) {
>   		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;

I don't think it's necessary to enable this unconditionally?

Paolo
