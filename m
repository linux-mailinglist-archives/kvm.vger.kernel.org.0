Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7BF1D1985
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 17:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgEMPfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 11:35:18 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40279 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728678AbgEMPfR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 11:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589384116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xlSz7XzVoxz8t9/FxrVpi2jDEt51rDwF9jzT8629/kg=;
        b=I8xcWBewLA6hEGTacNvm8EkxQI9NOePLLZ042O3hjwMc9o7ra8xAalMRwT+yCllWQBE1yC
        gglv9zKzqUxRk/gqWJh8/CcPFINTXS8VVEpacXJKxOqb2Tq3cbgohKWKeWK01yx4t+PUFo
        bW7upd0o1WEfL2xab5nhqmfbp0j+1i8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-938T_bndO8qT8cKumQcP2w-1; Wed, 13 May 2020 11:35:14 -0400
X-MC-Unique: 938T_bndO8qT8cKumQcP2w-1
Received: by mail-wr1-f72.google.com with SMTP id z10so4848110wrs.2
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 08:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xlSz7XzVoxz8t9/FxrVpi2jDEt51rDwF9jzT8629/kg=;
        b=SaUq+7sQlaKbFT4bNrn+/tslRWkg64B90CbXkvtLwDoe9OaVGnsLBiRGJBh8ItJZAF
         NAsMzU2uB4Pswbf4EmhCH4KJzIYFuft/pe32RTFCGf5ALLawsSXLRd+T5F04w0Gqow8F
         3S11i08bbP1Zw7uR5HOO+k97shHlQV7EaKjMnnUTgWznKqD2ddJJT6xM9xje926xgMqg
         rhZ+L/q8b3sa9hj+kwUuXe1tLcB0n46WzAGZWwgJaE04kVgYs1xTs39dIXV1QW+qZWNw
         WxeEiwLFoz8z5hIXSqt7NyTxblBOVgf/VpD96xAGyNsZzyqGDdRkSDjMsOLclja5uHhw
         YypA==
X-Gm-Message-State: AGi0PubDZm2NjeyuwsmqOcDmq8FsN0f2fqcg87lpuiuQ4yr5KaRpIZ1M
        rM7r3g//c2y1r2Qwx/s0L/tbyMkDAtsZAKmPL3DbWYUzubBDRNXyV1TxdUDus9ROy5XQ9AHfP0A
        LJdslbvMK0Lvo
X-Received: by 2002:adf:a285:: with SMTP id s5mr34674043wra.60.1589384113323;
        Wed, 13 May 2020 08:35:13 -0700 (PDT)
X-Google-Smtp-Source: APiQypIA84YuCLMye/q5eJye3p3ezHVL2W4N4sgoCRYfBUJD2arrSnmJhUj2IXdzTelP3klz+QGLcg==
X-Received: by 2002:adf:a285:: with SMTP id s5mr34673990wra.60.1589384113097;
        Wed, 13 May 2020 08:35:13 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.85.171])
        by smtp.gmail.com with ESMTPSA id b23sm33621926wmb.26.2020.05.13.08.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 08:35:12 -0700 (PDT)
Subject: Re: [PATCH v4 0/3] arch/x86: Enable MPK feature on AMD
To:     Babu Moger <babu.moger@amd.com>, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8cef30e5-5bb5-d3e2-3e0c-d30ec98818da@redhat.com>
Date:   Wed, 13 May 2020 17:35:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/20 01:58, Babu Moger wrote:
> AMD's next generation of EPYC processors support the MPK (Memory
> Protection Keys) feature.
> 
> This series enables the feature on AMD and updates config parameters
> and documentation to reflect the MPK support on x86 platforms.
> 
> AMD documentation for MPK feature is available at "AMD64 Architecture
> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
> Section 5.6.6 Memory Protection Keys (MPK) Bit".
> 
> The documentation can be obtained at the link below:
> https://bugzilla.kernel.org/show_bug.cgi?id=206537

I'm queuing patches 2 and 3, since they are do not need any support in
common code.

Paolo

