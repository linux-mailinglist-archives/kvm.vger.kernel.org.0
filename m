Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3FC37530
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 15:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfFFN0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 09:26:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52808 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfFFN0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 09:26:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so2451716wms.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 06:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9wSjXPH8rNO7SJCB3GaTq5vtXd55xhL3x51N5Y3ikYk=;
        b=lny5ZuZTWK7wxnF9z1YTjnPxCLpk48t+YlnKQ6OG4CHuiBOhWBLtdt5C1F1nrG1msi
         QYgPBDS6ok9UmjFFy2k3COQWKR7G/Ug49sEPcAnq4/onPMLfHTZHJ/aq6IA4f0gAvDlp
         YMC6ptnxuVdxHrBJTaDGQTyP1PEiV1hifv9mtgGMZOTrxbOWzLIWnFHxoYCEdcLimXAK
         p8PoRqfMq64qfYceTa4hkB26IH8s9LPpHj68Lb+WJ4dbO2wak11erguCHAg0wNLGoXPT
         a6lSNpHxMdSb25U7A3KplBHZaJk7s/33RFk7IkkLKFieYspsKzP1xcf1hDtRcHZIRXtF
         P5AQ==
X-Gm-Message-State: APjAAAV+pZBVnNqg1r1PiIWSmks47YhoTQy7mQVGJpAjtDfS+k4Hpkin
        KRdaPJAqGgTnRVsn3BbO7bV1Dg==
X-Google-Smtp-Source: APXvYqxa5AnIEdt4DsFLD1DYpyFqndHE9b4Qcoj/75WCvGOiNGeCXAxRktiQMhQRzPfyAFYw+eGT6Q==
X-Received: by 2002:a1c:452:: with SMTP id 79mr3493261wme.149.1559827609011;
        Thu, 06 Jun 2019 06:26:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id b14sm1135803wro.5.2019.06.06.06.26.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 06:26:48 -0700 (PDT)
Subject: Re: [PATCH 1/7] KVM: nVMX: Intercept VMWRITEs to read-only shadow
 VMCS fields
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
 <20190507153629.3681-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21044f4f-80e8-7a15-9a8c-daaec888d3d0@redhat.com>
Date:   Thu, 6 Jun 2019 15:26:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507153629.3681-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 17:36, Sean Christopherson wrote:
> Note, "writable" in this context means
> + * "writable by the guest", i.e. tagged SHADOW_FIELD_RW.  Note #2, the set of
> + * fields tagged SHADOW_FIELD_RO may or may not align with the "read-only"
> + * VM-exit information fields (which are actually writable if the vCPU is
> + * configured to support "VMWRITE to any supported field in the VMCS").


"There's a few more pages of P.S.'s here"
(https://youtu.be/rKlrTJ7WN18?t=170)

Paolo
