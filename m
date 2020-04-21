Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C79A1B2C76
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 18:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDUQTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 12:19:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20639 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725963AbgDUQTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 12:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587485960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OMcMRkM6CTuHPozam45N2SC6f9ykAvtZFSzHRVou/uA=;
        b=H/cW8PGhf+FTGhGTO5/B0VgW89TkUJeOjc6AgPUWZnyK6Cd1WU2JiLt1eo8HVRBWfyF+rq
        t+CsbAhQt36JptkTynrEmChxs8JBNKYtw5feBtUk5C1vMhLQvBrEBIHvhEY3wf0mnQO7ub
        p+B03EaBtL8uFiV6TKVK4BFWZfLNb/g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-QhIG-xWUNZKWdl-MSiDypg-1; Tue, 21 Apr 2020 12:19:18 -0400
X-MC-Unique: QhIG-xWUNZKWdl-MSiDypg-1
Received: by mail-wr1-f70.google.com with SMTP id e5so7738324wrs.23
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 09:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OMcMRkM6CTuHPozam45N2SC6f9ykAvtZFSzHRVou/uA=;
        b=Zl+LzSzg+2yHAKcgI3SahzCF5ijbZCj2WhT7yTRN0JAtXbDpTnQ6DPhHMUH9tf/iu9
         R0BSF4R5+z4z5848gVfyeQvrbDp0kRTnuExPFaYvqzjvE+iRHzWk6gwT0FN3NtbaSZJQ
         U9K5nc2RgrRn5Mvx4FqmFF8QZL9LdkhJoBZ6lN1B9RYZvWQnwuLFRad7n0kbMvT7WdeC
         maf70Ba8kL2PIdvInGnsr7dFgGAyR+qLUJ+FCi+hOkxQt1sRMO/icyp78lK8SRd8CHhs
         riaCqa20If4dYRwj04gLGptAEsZWnweNTyi5YcMqeY6G8b/9XoZ7swzKG8SeWOPzmvnA
         m/TA==
X-Gm-Message-State: AGi0PuaFe/sVNL1Qm618aUPOkk8UCHz0xlHpUE4QZZ20PuWJvRfxCGBB
        CkkfoOO1kVRtBQp9v0CDyMd0oARbObBWL2BN6uNXqrMT9r0z8UPuum/ZK4iIqIpktHEfIL9SI2m
        FEVsWNIhzEPZo
X-Received: by 2002:a5d:6504:: with SMTP id x4mr26598664wru.164.1587485957603;
        Tue, 21 Apr 2020 09:19:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypLBExtm46kFG/q5uOgEqHEeaUuSrp481aTEfOfkh5uRE39whBLwSFtgA3GXRG/Qo3jvvfG+iQ==
X-Received: by 2002:a5d:6504:: with SMTP id x4mr26598644wru.164.1587485957403;
        Tue, 21 Apr 2020 09:19:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id s8sm4112831wru.38.2020.04.21.09.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 09:19:16 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] KVM: VMX: Unionize vcpu_vmx.exit_reason
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200421075328.14458-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bcf9cbba-6cce-f10b-da94-232403a3f7f6@redhat.com>
Date:   Tue, 21 Apr 2020 18:19:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421075328.14458-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 09:53, Sean Christopherson wrote:
> Minor fixup patch for a mishandled conflict between the vmcs.INTR_INFO
> caching series and the union series, plus the actual unionization patch
> rebased onto kvm/queue, commit 604e8bba0dc5 ("KVM: Remove redundant ...").
> 
> Sean Christopherson (2):
>   KVM: nVMX: Drop a redundant call to vmx_get_intr_info()
>   KVM: VMX: Convert vcpu_vmx.exit_reason to a union
> 
>  arch/x86/kvm/vmx/nested.c | 39 ++++++++++++++---------
>  arch/x86/kvm/vmx/vmx.c    | 65 ++++++++++++++++++++-------------------
>  arch/x86/kvm/vmx/vmx.h    | 25 ++++++++++++++-
>  3 files changed, 83 insertions(+), 46 deletions(-)
> 

Thanks, I queued patch 1.  I am not too enthusiastic about patch 2, but
when SGX comes around it may be a better idea.

Paolo

