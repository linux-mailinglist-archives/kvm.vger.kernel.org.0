Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A28189C8E
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 14:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgCRNHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 09:07:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:21738 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbgCRNHG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 09:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584536824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3BBcjDC15PIowTErMckPAIkUo80vgbtjzOal8sa8YAA=;
        b=OM95a5HJ0+JssvjY/nMbHlOK4qE+eRUr/dKqqUSWyqff/qH2KWjyrc5X8c88TXZ/cNRnQo
        RbZO6n6i4GRiQNYoHupqbZsuRG3r0OkzGWt5437SLdqjhcGiiaqUAc0GleTREEfV0r/tKS
        Mwp7BMi8aJR86uc7fJqbyrRtWnX3eyw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-R7fMpSGgNdmtjGtEm5q7ug-1; Wed, 18 Mar 2020 09:07:03 -0400
X-MC-Unique: R7fMpSGgNdmtjGtEm5q7ug-1
Received: by mail-wm1-f71.google.com with SMTP id 20so1032741wmk.1
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 06:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3BBcjDC15PIowTErMckPAIkUo80vgbtjzOal8sa8YAA=;
        b=TbhySZm6jsl1+JN5XG6KnlW+DoDzY/mb7jk+EaIeSFZdqq9BgdfoX74aZalVkPwtOR
         mzWqlQJLMeltd4RO3xNtLEnuk1Faojy8XEMuSYqw+g5MDYk2NXsnLvbHkPPbBRs9GVZV
         aP1l2C1a4GPMu3oc8E2laGBRiCwOXoKVyBvvZmdoAIEh/y3zN80om1154ggbtsgtI2Tk
         8oFPol8MY9zsKd6JDkqfFUl8votxlQGd3BLSXTYfPy4Av6Sk2j0FSQ9P33gcjVnaCxqE
         8Zz9FWgCNXP8bJxQyLQ+1iimLK/uKoQ7ZpzfZiVHI2E38MY5SdznboRl04JDXWQVNX43
         HLww==
X-Gm-Message-State: ANhLgQ0ypr/hap1/ZBooeDaLoR5WL3wE42p29Th22KRDStYGF8I0Joox
        ECnapJBsYmSdijCVNFBAj/FlhOs57JG+GuapLBTKYo9KOBudAbkwFmEq03rHZhpRpxuSIaO6U4o
        ZKZARU1w+bL/z
X-Received: by 2002:a5d:440a:: with SMTP id z10mr5623578wrq.177.1584536821844;
        Wed, 18 Mar 2020 06:07:01 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvRRau89YmnPuPI20+jpyIjRf6aJ08Rz6UabuQmz1Ed4lYIMEloHayXR+rEkQDXtj6fbmfKyw==
X-Received: by 2002:a5d:440a:: with SMTP id z10mr5623553wrq.177.1584536821649;
        Wed, 18 Mar 2020 06:07:01 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id 9sm3795572wmx.32.2020.03.18.06.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 06:07:01 -0700 (PDT)
Subject: Re: [PATCH 0/2 v2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry
 control on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <1584472530-31728-1-git-send-email-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d142825-07ee-daec-6238-33bf916ffdb0@redhat.com>
Date:   Wed, 18 Mar 2020 14:07:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584472530-31728-1-git-send-email-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 20:15, Krish Sadhukhan wrote:
> v1 -> v2:
> 	Rebased to the latest Upstream repo. No other changes.
> 
> 
> Patch# 1: Adds the required enum values to the header file
> Patch# 2: Adds the test code
> 
> [PATCH 1/2 v2] kvm-unit-test: VMX: Add enum for GUEST_BNDCFGS field and LOAD_BNDCFGS
> [PATCH 2/2 v2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of
> 
>  x86/vmx.h       |  2 ++
>  x86/vmx_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> Krish Sadhukhan (2):
>       VMX: Add enum for GUEST_BNDCFGS field and LOAD_BNDCFGS vmentry control fie
>       nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of nested guests
> 

Queued, thanks.

Paolo

