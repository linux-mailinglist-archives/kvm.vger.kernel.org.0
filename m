Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90430282356
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJCJwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 05:52:30 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3166C0613D0
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 02:52:28 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id s66so3867054otb.2
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 02:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dI6MSQceoyGQyNafcDDo8z39Xp3NtkmKrboZO4BdFlk=;
        b=AVr+lCE/snv+lozpJPbVz/EkxCcF0kdHV3N5+gfeT20nS0trBBohCQvjOAEqCH4Sv1
         sWJ0AQbReEfOZw+0K2ysVziBRY9bm53Z+ea9MUOPxph+oNNMgQz1m0qsLLtB9fyeJyHg
         MIjd55Yoag32Grnx7P/N64EciS/fDgCMkvA/LVgaxPRuJEjQpD9yBUaCLtGN3ZT/blsl
         2fCU8a02Aq+ukFN6WzYxtG6U8dKqegI4GjzYtKmz+i+p7daZLRBEgFz9Kwrd29u5ke++
         I1kCMXfkektIkmbnFAqOQlo3Y/vEyhuXvHeL+jSL5OfFOAImYo+x9RPMlWnAeFnzbkKB
         U1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dI6MSQceoyGQyNafcDDo8z39Xp3NtkmKrboZO4BdFlk=;
        b=EUfLnG3dGpfAFPCaUNXizB97cNMTilavml1O/5pi8Pj2d866Fpq/mOg0318ysINRgd
         eO6pMXCJJQZ+IhpuecDvF4A9mRO2ADMSga37ua9/VhgiW+AspVMHyPUjKgiXdAXtRhFW
         dHyQvQipG9442HPGcbXOxAcW518OnU0DmgmYitoAzz2V3CSxA6VtVG2lHhW4Cuu4Jqp/
         SNZhU8sGMl4G0b59s6rf+Fz5abwTCKS5b6GnAZ30DBUgVYzAl4u6hPurrfhxfm+Nzdhx
         vXEe8nPDciepwddrCBpEMTX+tQEzrJF9UyoISRlJ3Qp4DgznKts5dyAzs+22jbh2ZxFC
         dNXQ==
X-Gm-Message-State: AOAM531eiFUjCRMEzP+4oJrMUZTPVXuQmJHpHOTzZEZhSDwk8UzbwFjd
        TLAtv3qVuTLqh6uiJiY8A+oWRA==
X-Google-Smtp-Source: ABdhPJxD+MErIQ5oDaFwq19v45SWlpim50VTqiCPIanBQsgODnWQ97qXiW4/uYJQvwb9yxEZEhm4Wg==
X-Received: by 2002:a05:6830:188:: with SMTP id q8mr5046280ota.278.1601718748230;
        Sat, 03 Oct 2020 02:52:28 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id i205sm882668oih.23.2020.10.03.02.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 02:52:26 -0700 (PDT)
Subject: Re: [PATCH v4 10/12] target/arm: Do not build TCG objects when TCG is
 off
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        Samuel Ortiz <sameo@linux.intel.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-11-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <59ecbee0-3f6c-d63a-13c8-01b47de4c78a@linaro.org>
Date:   Sat, 3 Oct 2020 04:52:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-11-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
> -arm_ss.add(when: 'CONFIG_TCG', if_true: files('arm-semi.c'))

Aha, so you remove the line in the next patch anyway.
I suspect that you can not add it in the previous.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
