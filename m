Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBF7134A12
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 19:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgAHSEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 13:04:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24170 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727090AbgAHSEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 13:04:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578506687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0zUcF9pqTV19OYl2z0DlOJZz0I1r8IoB8VMNbcbDJec=;
        b=cFKSdn368hjkZgmiixbwPQfQt/JVWuZ7//+gX3pJd2vACYPcqTjZA8qnfBI+61ge/Ly3iQ
        /dDddIvYgjz2P1FEEQrKsO2TmKgjQyaJpjDCzP4mZZCHI9uKwLuCLdMFPdHoxEyepJLLoB
        R4LiP6FfH/NqI1KJNYDRTcNsqKcbE6s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-DYwitGgCMsuHhc9DEyV6IA-1; Wed, 08 Jan 2020 13:04:46 -0500
X-MC-Unique: DYwitGgCMsuHhc9DEyV6IA-1
Received: by mail-wm1-f69.google.com with SMTP id f25so1130217wmb.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 10:04:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0zUcF9pqTV19OYl2z0DlOJZz0I1r8IoB8VMNbcbDJec=;
        b=AuThXEEknfakRBX/97iyp86//kBKHLveTTBjgf3kGxe6aWwgeyKtRShAynEuMOL07c
         uGrVCRTNLkZAec7L+oiGPwD2o/7IkLnT3y834JxMNq26CoybCbtciYwVfkZtSC/q15AM
         pqodyC/m7ZCXEfgMojFuevPYyqSw1frwk840HqKDNR7Nx0iy7oXq27xZT9lNstuqXBSQ
         iPYX2HpIK5Fz2qKCMaVJbgkpSAQ6wFM3VhfdXARZWl30N1B7/ltURz+uiO4qOHUk10pm
         KlBy+r6F0N8tD3j3Q5tWX8NPS6Ss7qmO96/tot+wFCVIjduE0RNwb/b0Htj+3lnGYcPj
         uweg==
X-Gm-Message-State: APjAAAUJrWbgOQlDWBWvNVB14MajvPGPATvA6IHfBsWfcDDbLr0cY6hl
        x8AviQf5iMJsFHcL2Lz2xQKCqkVyUqLvHOwtPu/xgU4T6v+b84BdWtfI3N97nMYozYKme1K+ZrI
        bTE57s7wtijrs
X-Received: by 2002:a5d:480b:: with SMTP id l11mr6180684wrq.129.1578506685139;
        Wed, 08 Jan 2020 10:04:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqw3Mtmmp5RC+OiSc6EPfBgguvGC4qGQ3LPWGOmy/AdRf+vFfwP/a0qUtRmvH6rAcLcAiTaD5A==
X-Received: by 2002:a5d:480b:: with SMTP id l11mr6180672wrq.129.1578506684956;
        Wed, 08 Jan 2020 10:04:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id v62sm4791585wmg.3.2020.01.08.10.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 10:04:44 -0800 (PST)
Subject: Re: [PULL kvm-unit-tests 00/17] arm/arm64: fixes and updates
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20200106100347.1559-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <76ca358b-9d1a-676f-328e-3a09996dc76b@redhat.com>
Date:   Wed, 8 Jan 2020 19:04:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/01/20 11:03, Andrew Jones wrote:
>   https://github.com/rhdrjones/kvm-unit-tests arm/queue

Pulled, thanks.

Paolo

