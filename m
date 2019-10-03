Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC2DCA791
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 18:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406232AbfJCQwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 12:52:42 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33953 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406217AbfJCQwk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Oct 2019 12:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570121557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=tybQJeiTvUGtxO8XDYAq0hVZIN5gzAPeQsA+LVu9afc=;
        b=Waba46WaY2yd5NfmKGJO4zGMPTvomiLKa6s2EXlsCQpBMNPRITwMMX4pI5z0ur7BF0spQf
        sRStIn9P79S1N5ufo7uOWdFIEQFN241HZ08HKzK4yxqTRZ53pYqQ3UcmPKL9Qo2vKpjZBb
        ukPsCxgwNeikYNgeyviBJmtPNCYsx/k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-bdLL8FwZOra7EW-D8e3w0A-1; Thu, 03 Oct 2019 12:52:35 -0400
Received: by mail-wm1-f69.google.com with SMTP id z205so1365270wmb.7
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 09:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GnNfg+jK+d2HJELoS7JAVulpIPiPSgLEm7obVUrPELc=;
        b=X3SXs5jFmEzej8H90BbR8xaPqKXpQtJLChVl9RPNqWouJqMM8UDAUfa1BXA/2MguCL
         eSQ8VCPH6c3jLxP/IEBf5mhguNXmtYrhBu1SF3pIohTnO6ql1MWALkaiyrRcXx3O4R5x
         zjglK0V0QKG/9dtXjeVbcd3KQcDUUxWVVDVxJnlukvCfujurRksoCP0ANFlFXgEjfZk/
         /MvxwSzRnX5Kr069JPbSgUkLxfnI9P+ODI0+AJIiVyGh0hrz+c67BUvyzhgHmbKY0oMc
         NvD4Cb0+RRi1fHA/tnWTs5L4fIp4ka63DenDga5799HlAonzXB/mA+Acn+G74ku3/TVm
         3eJA==
X-Gm-Message-State: APjAAAUViN/1U1LEMsx3o/aTazY6TdM6QWCRbkmGln/BdwxRbMZ7HcVX
        u8oHWqfUsAuWtrKgw2E1PdoOCOk5tUliCUimRkZ2KEyt9jbVx0vABn59ABEqEvzaK0nq/q5xFsr
        q0exjNmGEMChD
X-Received: by 2002:a05:600c:20c4:: with SMTP id y4mr6905917wmm.87.1570121554534;
        Thu, 03 Oct 2019 09:52:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx0/6l10Ef/AQsvBHVjpnUYHEyob5QbVKn35N6gSkHr2hx75ewq5tUPpyOsg0AJOHpewPbebg==
X-Received: by 2002:a05:600c:20c4:: with SMTP id y4mr6905904wmm.87.1570121554237;
        Thu, 03 Oct 2019 09:52:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id r7sm3549284wrx.87.2019.10.03.09.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 09:52:33 -0700 (PDT)
Subject: Re: A question about INVPCID without PCID
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <CALMp9eRPgZygwsG+abEx96+dt6rKyAMQJQx0qoHVbaTKFh0CqA@mail.gmail.com>
 <6220e2b4-be59-736c-bc98-30573d506387@redhat.com>
 <CALMp9eS=QEnpQV7OQ3gS61PJecJG7vaah-yGb6MGw7CFDTFxKw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0f67871c-aa5c-d961-a913-e9ea3827938e@redhat.com>
Date:   Thu, 3 Oct 2019 18:52:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eS=QEnpQV7OQ3gS61PJecJG7vaah-yGb6MGw7CFDTFxKw@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: bdLL8FwZOra7EW-D8e3w0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 18:19, Jim Mattson wrote:
> I was actually looking at the code a few lines lower:
>=20
> if (!invpcid_enabled) {
>         exec_control &=3D ~SECONDARY_EXEC_ENABLE_INVPCID;
>         guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
> }
>=20
> The call to guest_cpuid_clear *does* disallow enumerating INVPCID if
> PCID isn't also enumerated. I'm just wondering why we bothered, since
> we do so little sanitization of guest CPUID.

Ah, that's because when INVPCID is disabled in VMX the behavior of
INVPCID is different from when !INVPCID in CPUID even if CR4.PCIDE=3D0
(#UD vs. #GP or #PF).

Paolo

