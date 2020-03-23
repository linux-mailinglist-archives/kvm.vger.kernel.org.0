Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A86418FE03
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCWTrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:47:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47661 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbgCWTrP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 15:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584992834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S9IrSlxfJapkU8CWMBvfg1IPzMz8/r3SznAfCQ6EPKg=;
        b=ABhf+ki+rkoiNIvF2nJ2ccJgKERwridUKlzAtp/yygNpJePK9olsjW9CWmjpGkW1EcESUQ
        knRS0B7pIUoBvt5c/JcW3guS2TS7wH0WhtGscW+tNCL6Z4FNI084zLTB+lem8mmZL8xTRB
        tzhq1gVsy2HJjHKhSJTmEv3KVhRrx3g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-m0Nns42mPKaudWtely7bUQ-1; Mon, 23 Mar 2020 15:47:09 -0400
X-MC-Unique: m0Nns42mPKaudWtely7bUQ-1
Received: by mail-wr1-f69.google.com with SMTP id w12so1252241wrl.23
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 12:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S9IrSlxfJapkU8CWMBvfg1IPzMz8/r3SznAfCQ6EPKg=;
        b=ZXVLuYC2qsRnURY36fFzMeUvRLgqIVcDrRUnG+GG8+sJw+SBEGGEb0BRzob1rDqFOL
         J0X0SK9l5YlLNc/GZor1GCg4eccnatFxdczfNpJ6kJkU1jj+5dzcM4a6yik90gyqIlcE
         pxhveJoTeUy2jVwamy0LBUh/RGTr0wfIBzlVe8PcwPLdutwwjdLKtrrQbMwiYSCNQ5qB
         IUIxxEc4IwxPR/FzQyrydGg9/dqQchghP7b2agUzAQAhjerQOy222OmSyTfyKyYhvQvs
         oZ/Usyyul41TvgLyCOsmjg+6H1qVZX5Mn1DxqrQw5uCq86Vjw6hMasqaKeAp/igo+L3q
         nSHg==
X-Gm-Message-State: ANhLgQ0smW3+Ffno6jHl1jOVvPdthS0+BhX9kfAMkuqRTrM0gLNhuxBU
        94LkLCbTT+hF4qTSh21y++VT2/6IQ/TmdnFl2bZFL03g3Fa3i4ulOPSDM0mNkbYm0JYHwkIMG6w
        xgkiMpgU4pxhE
X-Received: by 2002:a5d:674f:: with SMTP id l15mr13381432wrw.196.1584992828064;
        Mon, 23 Mar 2020 12:47:08 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtUWmDK4thpwexQ8hdryAgmCprB22NosAirhPOI+x5C3asXpfwyOua+gaEuAwr0M9NrGpUzvQ==
X-Received: by 2002:a5d:674f:: with SMTP id l15mr13381412wrw.196.1584992827855;
        Mon, 23 Mar 2020 12:47:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01? ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
        by smtp.gmail.com with ESMTPSA id a186sm756486wmh.33.2020.03.23.12.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 12:47:07 -0700 (PDT)
Subject: Re: [PATCH v3 2/9] KVM: x86: Move init-only kvm_x86_ops to separate
 struct
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-3-sean.j.christopherson@intel.com>
 <87lfnr9sqn.fsf@vitty.brq.redhat.com>
 <20200323152909.GE28711@linux.intel.com>
 <87o8sn82ef.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30b847cf-98db-145f-8aa0-a847146d5649@redhat.com>
Date:   Mon, 23 Mar 2020 20:47:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87o8sn82ef.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 17:24, Vitaly Kuznetsov wrote:
> Sounds cool! (not sure that with only two implementations people won't
> call it 'over-engineered' but cool). 

Yes, something like

#define KVM_X86_OP(name) .name = vmx_##name

(svm_##name for svm.c) and then

	KVM_X86_OP(check_nested_events)

etc.

> My personal wish would just be that
> function names in function implementations are not auto-generated so
> e.g. a simple 'git grep vmx_hardware_setup' works

Yes, absolutely; the function names would still be written by hand.

Paolo

> but the way how we
> fill vmx_x86_ops in can be macroed I guess.

