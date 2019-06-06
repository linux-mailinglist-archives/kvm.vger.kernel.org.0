Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD693747D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfFFMst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:48:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46249 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFMst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:48:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so2252965wrw.13
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:48:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0f1MDi7RkZGuMo3ciPlna7mjTbz5TzW0g/cwYVkmeeU=;
        b=lBd1dxPb/y0ifIFVdV9npyJeUcO7DSfXt7u4eVirxv39omwjDONbVxrYtBbayhd3oW
         oI7q1Eu6Wu9IDLtu768hXFxo4MLMvwRPdju0IWsu4M17qrUrJLq1se6niG6qsm/vUx6U
         uqVFOToS+m9mcfa8YorSiTR14tbf4u4GHkmeLbs8CDM4TylEX5rK2BMfSjnfZI0CDws+
         ZN5Pt/hLfY5oJ8WalZs8F9FXM2rSe2jcXIYl7uKotrnnjIHcQPj9u/17zk0mAzPxal1f
         ENbG0BfiBGEBBHSebWk0/hiu2+Wc+3+IsH8/nIGG8MwstAzEdKnAOReaBeGgeuuIuoVT
         ZnbQ==
X-Gm-Message-State: APjAAAWoaYQ140IYPKVEkboUAeZuAtBkPEq69XYGi4+PhPb7ZLoU2EsE
        sTqIGg2SZtN9PX/8IIpzIplvYQ==
X-Google-Smtp-Source: APXvYqwluDdVbWIgUHwt5HT91rQUYz7DymtoJFWyuTZuS2k8kbBuyp3BGpyPuk49+XnNm3OVjnOuiw==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr29550528wre.205.1559825327783;
        Thu, 06 Jun 2019 05:48:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id r16sm1280528wrj.13.2019.06.06.05.48.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:48:47 -0700 (PDT)
Subject: Re: [PATCH 0/2] kvm-unit-test: nVMX: Test "Load IA32_EFER" VM-exit
 control on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b1dfa016-0441-22f2-667a-ae4109d41752@redhat.com>
Date:   Thu, 6 Jun 2019 14:48:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/19 01:45, Krish Sadhukhan wrote:
> Patch# 1 creates a wrapper for checking if the NX bit in MSR_EFER is enabled.
> It is used in patch# 2.
> 
> Patch# 2 adds tests for "Load IA32_EFER" VM-exit control.

Queued with the change suggested by Sean, but this was also on top of
some patches that you have not sent yet because patch 2 didn't apply
cleanly.

Paolo


> 
> [PATCH 1/2] kvm-unit-test: x86: Add a wrapper to check if the CPU supports NX bit in
> [PATCH 2/2] kvm-unit-test: nVMX: Test "Load IA32_EFER" VM-exit control on vmentry of
> 
>  lib/x86/processor.h |   8 ++++
>  x86/vmexit.c        |   2 +-
>  x86/vmx_tests.c     | 121 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 130 insertions(+), 1 deletion(-)
> 
> Krish Sadhukhan (2):
>       x86: Add a wrapper to check if the CPU supports NX bit in MSR_EFER
>       nVMX: Test "Load IA32_EFER" VM-exit control on vmentry of nested guests
> 

