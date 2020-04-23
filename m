Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C774A1B5928
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 12:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgDWK2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 06:28:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42429 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgDWK2u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 06:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587637729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F4gaJDC+0sH0pf6hQtA9epfsJhXMtyNcCCHD374PsVM=;
        b=Fkt4m5aBbycyYvz0OWF94QhrDhLLL67yA1ESLenDjh/pKH8Xkq+ZbQStxsTkIO9BF6R1GM
        ImP2jPJ2rUJPUvkq4P15KWahD42pmysGKBMx7DlWtQThV0B2JWkrGmkZlhtOx2I0s4TTu+
        7KfFcgYkpwb3+d/VEwxcLoQhoWMxz0U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-LXfq_H0vNMCEJU15GtMH6w-1; Thu, 23 Apr 2020 06:28:48 -0400
X-MC-Unique: LXfq_H0vNMCEJU15GtMH6w-1
Received: by mail-wr1-f72.google.com with SMTP id o8so2183601wrm.11
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 03:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F4gaJDC+0sH0pf6hQtA9epfsJhXMtyNcCCHD374PsVM=;
        b=VYRlq54VCmaLQlMVJoUyz/QBQU6pncAG7EJ3bYA77KnaZ9v9zfFBEi0A0M6gxE+Bp+
         MDNG5hyfntZLhInOjHLdnIGyXvuXZMI4QkJBhTsivJCwAr9twVkXXvCJKnjxYVCIYTnB
         6t9M0Lmj/+t++OeIFavPiruGWguuuz5A3aI8isVrhaxrx70YxVHJLPmy36WUuGwUT/7o
         m46CnZ+p+CQohqNIwC2A6ftf/CNxGLO/0Tm3EeM7pVYg9iOr0obnxahlWwyHk2VB0hAk
         azBrRqN+LakETbQm3RDGJxeB35KVUkTPT+Girb+BrURnkoosN7PGEAq0wtXHW49KCfd9
         ntUQ==
X-Gm-Message-State: AGi0PuZ30pptmqDIwW0Gcg/SEHcOZI7jyKeQrDvRQ/zaw7hrAqC9x7+v
        VdxS7MeAliKXvzbCU3rFyBrS1PBADqppBASL/CLDgEJjjpVhNskcHW/krj+XCO8n9NXRFtvEgLN
        Ppzqn7+DDSBye
X-Received: by 2002:a7b:c959:: with SMTP id i25mr3399721wml.20.1587637726969;
        Thu, 23 Apr 2020 03:28:46 -0700 (PDT)
X-Google-Smtp-Source: APiQypIwDLQEdjIxqk+ixiCPh718UOGXUU8SgMs4SSKoJavwX9XPgwvm+sHaWDIv6J+rTgsp3KH5Kg==
X-Received: by 2002:a7b:c959:: with SMTP id i25mr3399700wml.20.1587637726785;
        Thu, 23 Apr 2020 03:28:46 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w10sm3295066wrg.52.2020.04.23.03.28.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 03:28:46 -0700 (PDT)
Subject: Re: [PATCH v2 4/5] KVM: X86: TSCDEADLINE MSR emulation fastpath
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-5-git-send-email-wanpengli@tencent.com>
 <1309372a-0dcf-cba6-9d65-e50139bbe46b@redhat.com>
 <CANRm+CwwUO9Snyvuhyg8zbLf9DRhQ8RhRddkrdu+wRjF8v5tdw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <45bc6124-c07f-9336-376a-20ed2694fa01@redhat.com>
Date:   Thu, 23 Apr 2020 12:28:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CwwUO9Snyvuhyg8zbLf9DRhQ8RhRddkrdu+wRjF8v5tdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 11:54, Wanpeng Li wrote:
>> and then you don't need kvm_set_lapic_tscdeadline_msr_fast and
>
> I guess you mean don't need tscdeadline_expired_timer_fast().

Both.

Paolo

