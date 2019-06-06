Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D4A379CB
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfFFQfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:35:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45642 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbfFFQfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:35:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so3095156wre.12
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 09:35:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2YAwQZ6F2Oin7UeaeHR7jWvN1MztsFepPPmb0OIZ8lo=;
        b=D4H4bXPJi7Zielmy7LBCtbwaqj+HblJsGbFJs05orCps1Wv9XDO49iWrvMT6ipFoxy
         jLL+HoZumwFEhIMMB0QfvwXgpHVjNmG2CZV8idU3h6JoVAnWkWJ19gllM9SQVwgJNl9P
         +UehQKu/ceslXjk7SVfbBvQ3q5GAhsoydyZke9gdCaxEycdDWvi5Glu/BZSRHC3Fzm/w
         1hEKUvYlRxXtpU9eoARp79wdfnOehCG4eycr0RdybtcHLu1s058G/ckKAa0ygdc2t7fJ
         6sGyvYaeSqqD+jihKuCum5GeG1EYZ5nuPsM9vbL2DmIATmmVyLnR+0tGzge/2AkZHnMl
         v9oA==
X-Gm-Message-State: APjAAAVbFtW3P3dVCgIRbCM+JRmLf4KDx5pmfm1azlwLmilsy8HV+Xk0
        efJf74UlNecS9tvpIz1twjvHxw==
X-Google-Smtp-Source: APXvYqwFgvCtjIjRotgN2TGf7zkLGcbb06298Fu+mD06LsZqnlvbk0S/qhYxi6JF2Rf9nIWGHTu0mA==
X-Received: by 2002:a5d:4dd1:: with SMTP id f17mr5914316wru.43.1559838950304;
        Thu, 06 Jun 2019 09:35:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id n1sm2402061wrx.39.2019.06.06.09.35.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:35:49 -0700 (PDT)
Subject: Re: [PATCH 11/15] KVM: nVMX: Update vmcs12 for SYSENTER MSRs when
 they're written
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-12-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a15122d-07f5-b240-9161-3765c8bc578c@redhat.com>
Date:   Thu, 6 Jun 2019 18:35:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507160640.4812-12-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 18:06, Sean Christopherson wrote:
> -	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
> -	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
> -	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);

I moved these a bit earlier, together with all other fields that are
unconditional and simply have to be vmread from the vmcs02 into the vmcs12.

Paolo

>  	if (kvm_mpx_supported())
>  		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);

