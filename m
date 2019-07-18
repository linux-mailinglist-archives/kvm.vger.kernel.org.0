Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729576CED9
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfGRNaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 09:30:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38311 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfGRNaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 09:30:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so4343521wmj.3
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 06:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZE7qeIo+WhLKExx8RJE14kSmCWYHFTAnkh+UlLH0SC8=;
        b=UtSrEAZaYrW/pAqsufYME4je0b9bBCW75me226Al0sRX/WFRTRSkMIbgg2Ia1jsj2o
         Gr+AbQ+znQOJicM0j4a5Zzu1/1a684tsNiB/0EixcWfFOnlzrmW+Uj7c8GpvKN8aDbbm
         ItoTKYRFFPLI877SOtEnqILRJNK/LzcfQqWEuDt79/B1q3CgaEjTFCNYMfS2F5JF+8f1
         /xT2gQFce5s1CijY83c0jzT2MtNmOaLjwzQGCwYZlEADfFhb3d73nGWCzjI67wVEa+VF
         jaD8EwipC3avpWfOdmeoNH2KeH6vGUMEa0+xohhbGa47tuAt3V4kLZhVMVIDhC2WrzH/
         n31w==
X-Gm-Message-State: APjAAAX4F2YX62FbNpKRyNdYNEMP2oM2s8lG4RC8Ltk9HzIBEvL5g2v3
        0xeJmVucybMgYAEYxj3daIYfcg==
X-Google-Smtp-Source: APXvYqx3V5p2CKlfwWpWyhN/va1NPlp3PYMM04M8eSKtHjS8zhgid38VQPsLoaAWTYKhki9qOPdqrw==
X-Received: by 2002:a05:600c:2218:: with SMTP id z24mr42485323wml.84.1563456618835;
        Thu, 18 Jul 2019 06:30:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id k124sm42226579wmk.47.2019.07.18.06.30.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 06:30:18 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: Boosting vCPUs that are delivering interrupts
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Marc Zyngier <maz@kernel.org>
References: <1563449947-7749-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c4c23d93-879b-1783-afa5-b6e053f32990@redhat.com>
Date:   Thu, 18 Jul 2019 15:30:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1563449947-7749-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/07/19 13:39, Wanpeng Li wrote:
> -	if (kvm_vcpu_wake_up(vcpu))
> +	if (kvm_vcpu_wake_up(vcpu)) {
> +		vcpu->ready = true;
>  		return;
> +	}

Why here and not in kvm_vcpu_wake_up (which would allow further
simplification of s390 code)?

Paolo

Paolo
