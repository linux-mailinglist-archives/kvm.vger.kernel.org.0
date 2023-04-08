Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909986DB7B6
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 02:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDHARC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 20:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDHARB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 20:17:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4496212BCA
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 17:17:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v9so4890748pjk.0
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 17:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680913019;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7cwNQrhKFMtaLgzbF1sx/y8o+P1z23KbhinULFm+gc=;
        b=em19M48QhkYSSHPVPnPx3CBQeDPaBNoUVnovdrq69dJTBmnna4fWnqm96S09zwVhj6
         SPIuz3TlxjPmkdMk6KyWGgjZYfvivLawGALDYsN6SXT+hGkBjGsV2p0ahSO1uVcq5MNv
         GSg2HF5VY5ma8dHV5LwAEDH/dDprkrTD5VUko9hGQIfj8jzz7wt4DqwuCUw0F162cDZy
         JtFmJ2einuPBhc/NgQPWQHgBo2VWek6bMFNIAaacQ6p7NOZdYcYikpcVWZwKUdXm0G3R
         Ayy2D336Uu8kZmd03N3WkOqyoy76vmmcolin7aUrfmbUm/WOhHjbbNEoBz1INDCiCUiA
         PNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680913019;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W7cwNQrhKFMtaLgzbF1sx/y8o+P1z23KbhinULFm+gc=;
        b=zXT944jxhBc2bae0YIlD1YJnhs6C7JHCLfvlOfUergNlXCke+sH3lOwqae5VAuh6eV
         Kjxfj3kz/S0auYvRJ+rMaM2fKYg/hDn3x7y5hG2rD91TVR+DgR8h3V6/XG074cJ2PY0/
         4iaEq/2p7hxFQvrRIdUXg/9+pQME5HfZ/nBIVDVd5hmCtGpqTUPwvt+zfRFdKOrjUPxa
         9pTeefsw0Xzm3zFf9SRvDtgU5VyQKtNs6peH7o+Ej1H80E5GgTrxRJtUNkKYv5nAths7
         1ccS+JbxqtePvrbbFTKciUqh1djW5Qoltz75tZ7Un4bJvC+zNc1AHP52z43Cui6FFGVK
         mKzw==
X-Gm-Message-State: AAQBX9eRjsMsP/kxqqjjhjzOZLO2NBzPULqxCsiPf39QUlqjuL6ExLXZ
        ML3cANbrxD6ZuK4ECK25JGaESg==
X-Google-Smtp-Source: AKy350Z6S/V6iPcFxAsexzytePwFO9OrjXUaunvxoRyTjJA47ucqwC2NcJ6HQ7t06511pumZwpjjCw==
X-Received: by 2002:a05:6a20:2a0a:b0:de:9f78:f677 with SMTP id e10-20020a056a202a0a00b000de9f78f677mr4233959pzh.23.1680913019625;
        Fri, 07 Apr 2023 17:16:59 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id z14-20020aa785ce000000b0062dd1c55346sm3596844pfn.67.2023.04.07.17.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 17:16:59 -0700 (PDT)
Message-ID: <4cd70b77-807a-07be-c82d-d62eaf3b19ee@linaro.org>
Date:   Fri, 7 Apr 2023 17:16:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] accel/stubs: Remove kvm_flush_coalesced_mmio_buffer()
 stub
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org
References: <20230405161356.98004-1-philmd@linaro.org>
 <20230405161356.98004-2-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405161356.98004-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 09:13, Philippe Mathieu-Daudé wrote:
> kvm_flush_coalesced_mmio_buffer() is only called from
> qemu_flush_coalesced_mmio_buffer() where it is protected
> by a kvm_enabled() check. When KVM is not available, the
> call is elided, there is no need for a stub definition.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
