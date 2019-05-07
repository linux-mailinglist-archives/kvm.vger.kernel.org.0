Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A066C16CC1
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 23:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbfEGVBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 17:01:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38406 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbfEGVBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 17:01:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id v11so4051493wru.5
        for <kvm@vger.kernel.org>; Tue, 07 May 2019 14:01:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L7R3KyUF0EFfK+29MjDyJW4+R1t+Az5xupZ0O4Qqxc4=;
        b=bYkF2yhVfmMCa6cFsY1K4wFn+pE9Gw9Y7MESIoURFgslzaKI8zx8XYyfC8sjUaPx9u
         xsIIiBW0cAQ8U7n2eGhlcuQQDfQM65y9e6fDB1R+SXVSUQxt+GavC0jrV06uulnCbTUy
         75bOFS9nDpACoZexreBamLRAI/jgFp/LjIN5/ncO2vFxhq+4M2DNaWnzJrnrwAVwt75I
         BqTmXV9M2FC3pEDsIokK9B2H2U35KJpxcVBvzexO6H6RILnJ72E9RyZ75dUrLr4jMHdG
         huWgGrj53je+RmJZiSI3xL7ylGLvXPi55ocH9tPtUJJOomHYu0OHreIWiSOWu8jqFie5
         J9jw==
X-Gm-Message-State: APjAAAUVVY+vp1WXiE2ZpEyMJYeKOWmAaJuzjuUMnE/Jk505qMdsdSQh
        PLsDSV6MrWt0DanQqz2AiWdtjg==
X-Google-Smtp-Source: APXvYqyc024j1YJH+Ox0m84yRalKsRUC6qtOzZ1gvX81PScTdBJebYD1K/ocxOn8BahH0ioviSCKBg==
X-Received: by 2002:adf:f892:: with SMTP id u18mr1221004wrp.269.1557262878996;
        Tue, 07 May 2019 14:01:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cc0e:e691:1dfa:1841? ([2001:b07:6468:f312:cc0e:e691:1dfa:1841])
        by smtp.gmail.com with ESMTPSA id h81sm490465wmf.33.2019.05.07.14.01.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 14:01:18 -0700 (PDT)
Subject: Re: [PATCH 07/15] KVM: nVMX: Don't reread VMCS-agnostic state when
 switching VMCS
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-8-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f5d55c83-f5c1-0871-3cf7-0ece9b2f083f@redhat.com>
Date:   Tue, 7 May 2019 23:01:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507160640.4812-8-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 11:06, Sean Christopherson wrote:
> -void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +void __vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)

Let's call this vmx_vcpu_load_vmcs.

Paolo
