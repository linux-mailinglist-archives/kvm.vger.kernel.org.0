Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF561457BC
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAVOYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:24:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47439 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729031AbgAVOYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 09:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579703086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqT6CKkFGq3yewDVX4rWRr0dGnPZkXFg3u7EsnPq/64=;
        b=gFfdY4a1CTVtqebu4zMtGxsFs6Lu25oLORhYFeqoUC6C3HjL3PyH7RjBcvmmRIM2PYR6kE
        nCWd+u45ZKEM55FHegJW4hDp0WRuAmr/aGI5lP9X5r7tnGwCPjcP4znyZTVNVyfC+XbO+V
        4sPFVGPgL903ZCa2okuRSraTGHfEisc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-DPKSoz44MXmxURSnLavkxw-1; Wed, 22 Jan 2020 09:24:44 -0500
X-MC-Unique: DPKSoz44MXmxURSnLavkxw-1
Received: by mail-wr1-f71.google.com with SMTP id w6so3128191wrm.16
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 06:24:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqT6CKkFGq3yewDVX4rWRr0dGnPZkXFg3u7EsnPq/64=;
        b=FKNZ1dXqYfhVK26x3cpiSeb0RaqY1uVRNeERflQlB4FL5x76Zx99T+ca/rneOWSvhj
         n3B/3wbvXbSXH/USMva/eJ/cx9Bg2BmehECYeVSVMAkHKPiX+CodjJ0hKu/QOn/SE0+r
         fYDZ8V2dGLEpYOm/yKUFexNb8Lxi04PoTlDHqYkNRFTcqZsEtN2OvgZ3cFihp4AiJF8C
         J62hJ/hGY6tHYlKvOQGdtgtxNH6QISDMOcZCq26Eexcsvpu7tNq8vFa0+HrCHQAEL0/b
         9QNGpPn5AYaK+BM27vlV6R1wP13r5Z58nvjCMo1HgJpaFZ4DUdIQTnWxNzHT3TCMOo3+
         c0IA==
X-Gm-Message-State: APjAAAUxPoklIBLFl34k4AhcU930AMs4R1zVeAHxKQi8Y7pb3MeviN6r
        ugciS8JOoghetzgwSacxPLnPVm9gv+5H9WHZU2ajJjMBib9hWFiCrlPtxIUDNXbu1AATWW+/V61
        y9By2dKwHBwO+
X-Received: by 2002:adf:f54d:: with SMTP id j13mr11499364wrp.19.1579703083587;
        Wed, 22 Jan 2020 06:24:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/2ceqwR2kycBEWzkQorXDtWBW1IKh4GGt2+mtCymg1sayhTfnKvWGxkroPEuUM2HmBy7NKg==
X-Received: by 2002:adf:f54d:: with SMTP id j13mr11499329wrp.19.1579703083264;
        Wed, 22 Jan 2020 06:24:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id m3sm55904641wrs.53.2020.01.22.06.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:24:42 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Add 'else' to unify fastop and execute call
 path
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     rkrcmar@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <1579663304-14524-1-git-send-email-linmiaohe@huawei.com>
 <20200122044256.GA18513@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0914980e-30dd-5b39-a951-ca73e1b86ab3@redhat.com>
Date:   Wed, 22 Jan 2020 15:24:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200122044256.GA18513@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/20 05:42, Sean Christopherson wrote:
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Queued, thanks to both!

Paolo

