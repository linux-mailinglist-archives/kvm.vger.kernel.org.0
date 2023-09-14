Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D4F7A04BA
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 15:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbjINNBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 09:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbjINNBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 09:01:43 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C235E1FD5
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:01:38 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-404539209ffso6419365e9.0
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1694696497; x=1695301297; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ddiGkE6j5Yqjx2YChUyXAKUMjOfVYGR2wU1BDa/uOVM=;
        b=R/7QQUfIOihU7dGQ6BLubDNlHg4kFo2L3RePq6XZ9UzkbShQ72beoYkykdPtNO9ojO
         hOi7dAks7mgoG/wxJR4kvEWG1ZNr3QcSdYw4xWD4k3oDGO+9xgWVlnqXDnDxVQPu7jx3
         FvCAIOzKqJjiMBjCK7g4R7Ctiafan+9onbcyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694696497; x=1695301297;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ddiGkE6j5Yqjx2YChUyXAKUMjOfVYGR2wU1BDa/uOVM=;
        b=FVtL6bHFFhkVHn1AuyIM0tIu4GP5ZNcDF9+ZcMnDIZlRjmdCAfr5YLcUBDuUWQrE/b
         S51ZWUiJ7xRAT00849pWCyZ9Y5vLlXmrMIlpRvsU20Im+c8ceHnCXbPWDm5Md4zw153E
         w5nu3OPBjz4fMXJ8JIfquEZVrPCIMSwPxLEU4XnqVVj8WLqkDjdEDxnDLthnwKFYXg0E
         ikDiGd8/dkV8gLArOpc0tkL6eSUu0wvq0mttsGv5CwClWFuVQ8A4vAPqFnFQ+I88ov0A
         DAeQk8FNESPC5RRxRMr0ED8ooebm8RzDPPy21RZnh6hoIB5D8pwBP7IQ6DZ9jD13W0Ve
         N0sA==
X-Gm-Message-State: AOJu0YxYiUYYmtl+vAES5B6S2wa+YE+vuZGqpoxs6XU9IEYkWNDzoXLx
        d+5lGHx1VsRQijr4elrhTPXwX3/Ivo9IEOabqZwKow==
X-Google-Smtp-Source: AGHT+IGu9ZokynanEidxo6b4ugwjHDqKzn9EMgeKgnKUXWugWLtEAMgf7RA8IhMPo5oq1q9TPG+E9Q==
X-Received: by 2002:a05:600c:b5a:b0:401:eb0:a98d with SMTP id k26-20020a05600c0b5a00b004010eb0a98dmr4538194wmr.24.1694696496369;
        Thu, 14 Sep 2023 06:01:36 -0700 (PDT)
Received: from [10.80.67.28] (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id c20-20020a7bc854000000b003fee6f027c7sm4769165wml.19.2023.09.14.06.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 06:01:35 -0700 (PDT)
Message-ID: <b894ba89-27b2-88a9-6adf-7d53e2c51c02@citrix.com>
Date:   Thu, 14 Sep 2023 14:01:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From:   andrew.cooper3@citrix.com
Subject: Re: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
Content-Language: en-GB
To:     Juergen Gross <jgross@suse.com>, Xin Li <xin3.li@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, jiangshanlai@gmail.com
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-4-xin3.li@intel.com>
 <48d312f4-50cd-468d-af70-51314796b0d8@suse.com>
In-Reply-To: <48d312f4-50cd-468d-af70-51314796b0d8@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/2023 7:02 am, Juergen Gross wrote:
> On 14.09.23 06:47, Xin Li wrote:
>> Add an always inline API __wrmsrns() to embed the WRMSRNS instruction
>> into the code.
>>
>> Tested-by: Shan Kang <shan.kang@intel.com>
>> Signed-off-by: Xin Li <xin3.li@intel.com>
>
> In order to avoid having to add paravirt support for WRMSRNS I think
> xen_init_capabilities() should gain:
>
> +    setup_clear_cpu_cap(X86_FEATURE_WRMSRNS);

Xen PV guests will never ever see WRMSRNS.  Operating in CPL3, they have
no possible way of adjusting an MSR which isn't serialising, because
even the hypercall forms are serialising.

Xen only exposes the bit for HVM guests.

~Andrew
