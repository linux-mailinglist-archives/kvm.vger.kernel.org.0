Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BB5214AAA
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 08:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGEGik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 02:38:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbgGEGik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jul 2020 02:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593931119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=24kvZ8cufteQtUL1LAHWLweWV8v301eRyGPNi5FPGgo=;
        b=PxFD7i3Jp45LUTVHMqrwVZMsX5+YYxlqYh24ppK4U3YOwk2ByIgtoRbZKWiTuUU7imcErp
        Zakgi0EgdJQdUwtsDE8p9Kq+2JctbeT1Qf1x38F9DyCCJlG076+SHYrVRvbJqTVYmuzt8n
        uR/5jW9JTgxrEAQkqnov1PqY5T5ywr8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-0PoFjxO5MMi65btlZKh5oQ-1; Sun, 05 Jul 2020 02:38:37 -0400
X-MC-Unique: 0PoFjxO5MMi65btlZKh5oQ-1
Received: by mail-wr1-f71.google.com with SMTP id i14so37582847wru.17
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 23:38:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=24kvZ8cufteQtUL1LAHWLweWV8v301eRyGPNi5FPGgo=;
        b=HJWRK0HhZ+U+H0U42q3QQzhz7KIkqrDGeJj/WKSFUYayYqTsBsanRp1vR6+SBb1Z9y
         pcsZbzVq/3OGpSoIxIaY51xU7y2DaT3789020gqOed59/9hHL4ZMJRpgsYGLcypAuSAj
         /s0RfkvHPWT7gSWy5mnAdAxNdaQ5LkAmm3YA8p+RWh4l7+MAniLDwkUTQzRnq5km4sCd
         vBklDFDMG4FtnH5X18d2rPDQ2uUpcQfK9lodkgLPgn0RL6aPQ6vcN6Ca1wgXwt9fWiuN
         jeaQu+PSrPkls1B8nsBDcUzalffd+gkXQHizACg+xWLUvrt5CSZ2SZ4M8rvj4lNplgEx
         WJyA==
X-Gm-Message-State: AOAM5331eT3ClEeGfdBXTfBZ76BeVyRLcT29zuUyReaMGPPm0tHW5mlX
        BnZTh7eJEr3lZOQGtaHTFVcHh5e8ObBvarFliZ7zQtlx8JJ3aH334bB3pFXszOkq9iVDjT6Fpp6
        Jv6914KV93ATJ
X-Received: by 2002:a5d:4604:: with SMTP id t4mr11629736wrq.0.1593931116012;
        Sat, 04 Jul 2020 23:38:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwknNrP5yg9oIgizWKVGLC2/q9KxZ2rdI9t1WUKedrFm57F0AsD5syzsBzFQLcyQiCaQB7Cfw==
X-Received: by 2002:a5d:4604:: with SMTP id t4mr11629725wrq.0.1593931115833;
        Sat, 04 Jul 2020 23:38:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:adf2:29a0:7689:d40c? ([2001:b07:6468:f312:adf2:29a0:7689:d40c])
        by smtp.gmail.com with ESMTPSA id f186sm18364988wmf.29.2020.07.04.23.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 23:38:35 -0700 (PDT)
Subject: Re: Question regarding nested_svm_inject_npf_exit()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>
References: <DAFEA995-CFBA-4466-989B-D63466815AB1@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f297ebf8-15b8-57d3-4c56-fdf3f5d16b9d@redhat.com>
Date:   Sun, 5 Jul 2020 08:38:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <DAFEA995-CFBA-4466-989B-D63466815AB1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/20 02:00, Nadav Amit wrote:
> Hello Paolo,
> 
> I encountered an issue while running some svm tests. Apparently, the tests
> “npt_rw_pfwalk” and “npt_rsv_pfwalk” expect the present bit to be clear.
> 
> KVM indeed clears this bit in nested_svm_inject_npf_exit():
> 
>        /*
>         * The present bit is always zero for page structure faults on real
>         * hardware.
>         */
>        if (svm->vmcb->control.exit_info_1 & (2ULL << 32))
>                svm->vmcb->control.exit_info_1 &= ~1;
> 
> 
> I could not find documentation of this behavior. Unfortunately, I do not
> have a bare-metal AMD machine to test the behavior (and some enabling of
> kvm-unit-tests/svm is required, e.g. this test does not run with more than
> 4GB of memory).
> 
> Are you sure that this is the way AMD machines behave?

No, I'm not.  The code was added when NPF was changed to synthesize
EXITINFO1, instead of simply propagating L0's EXITINFO1 into L1 (see
commit 5e3525195196, "KVM: nSVM: propagate the NPF EXITINFO to the
guest", 2014-09-03).  With six more years of understanding of KVM, the
lack of a present bit might well have been a consequence of how the MMU
works.

One of these days I'd like to run the SVM tests under QEMU without KVM.
 It would probably find bugs in both.

Paolo

