Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E1326BE6C
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 09:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgIPHpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 03:45:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgIPHpD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 03:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600242301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=76Bg72r+p2k9IbrpPzmK8vSWwjQMu3f6+BQBefJMooI=;
        b=Z95L63N4niMwzv+AZOwJsWBI52WMPD78I04qPws1LljydajlOJYwFLobe7+yrYQOWr6Ue7
        aOdWUTZkOK3VjMv2n6sJpq3ei9MfuiVrMsxlP3IYTuR2pzt+efGpEL3Nbisvt8sO/BEwQu
        B75sMQFLD0GhAVFK2AonlVodJPw0KyI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-8Qe_GojEO0-3A86wL8lqPw-1; Wed, 16 Sep 2020 03:44:59 -0400
X-MC-Unique: 8Qe_GojEO0-3A86wL8lqPw-1
Received: by mail-wm1-f72.google.com with SMTP id p20so520433wmg.0
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 00:44:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=76Bg72r+p2k9IbrpPzmK8vSWwjQMu3f6+BQBefJMooI=;
        b=rmB+jKw9vZ0/p1Mzda1xJkA5EEptlg1Tp2wuBvsL4KT4uS1IwWu2HgFcwGvRISjbFD
         TRqdtnso3V1QNkN0P9Oxc3ROp1FOohsHem4QfC/KZbfb8nAwRAz7+EzW11yIimd0kmS5
         T70mX07O679XB4YjGby8y9g7fyRpv8D/H9q0aIYBK9xY7Qu+RqRo3TJ/y1tL/qWGlMuw
         ISeNdP0QozEhTrnyIhJJcVIG6uA+SglgMh93Jvoqoh0aKictcu6gEYyL5pHG9MBcQY6J
         U/5CglzAK1vj1FkToO6HvPbrIJcM/2IZBNFF1UpEuVKN9bkga+I0UpQERh/uujOHKSsn
         95HQ==
X-Gm-Message-State: AOAM530dWi66EmDD3XcVKlq6McgMj95mCYPCr4yoyefw5u/FBLXZ7Hg2
        HJiLzfTC196Vp9bIUZYt2c3LYGwhk5Itiq81U79s+6Cdefzr01JcRe6OAtKRxZY3cJqGIa3Tcet
        qoip784xUyFdq
X-Received: by 2002:adf:f5ce:: with SMTP id k14mr24488477wrp.286.1600242298766;
        Wed, 16 Sep 2020 00:44:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsgIFXCA27c2dR/aCnezA+DSHlWHcYyw+U3VYecZmYQdFB52Dpqfdp2DqjmjEACv3IRl6R3Q==
X-Received: by 2002:adf:f5ce:: with SMTP id k14mr24488461wrp.286.1600242298564;
        Wed, 16 Sep 2020 00:44:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h186sm3815236wmf.24.2020.09.16.00.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 00:44:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, Wei Huang <whuang2@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] KVM: x86: allow for more CPUID entries
In-Reply-To: <20200916034905.GA508748@weilap>
References: <20200915154306.724953-1-vkuznets@redhat.com> <20200915165131.GC2922@work-vm> <20200916034905.GA508748@weilap>
Date:   Wed, 16 Sep 2020 09:44:55 +0200
Message-ID: <87k0wui2rs.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wei Huang <wei.huang2@amd.com> writes:

> On 09/15 05:51, Dr. David Alan Gilbert wrote:
>> * Vitaly Kuznetsov (vkuznets@redhat.com) wrote:
>> > With QEMU and newer AMD CPUs (namely: Epyc 'Rome') the current limit for
>
> Could you elaborate on this limit? On Rome, I counted ~35 CPUID functions which
> include Fn0000_xxxx, Fn4000_xxxx and Fn8000_xxxx.

Some CPUID functions have indicies (e.g. 0x00000004, 0x8000001d, ...)
and each existing index requires a separate entry. E.g. on my AMD EPYC
7401P host I can see:

# cpuid -r -1 | wc -l
53

Hyper-V emulation accounts for 11 leaves (we don't currently set them
all in QEMU but eventually we will). Also, we sometimes set both Intel
and AMD cpuid leaves in QEMU (David can probably elaborate on which/why)
and this all adds up. '80' seems to be an easy target to hit even with
existing CPUs :-)

-- 
Vitaly

