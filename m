Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918FBD0D9A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 13:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfJIL1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 07:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbfJIL1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 07:27:46 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7E096B
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 11:27:45 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id s19so560338wmj.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 04:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ifVLEC5uXx0xXbZ5E3zE7qcYovO4iLtIeSopENFKhCg=;
        b=b/cSZgUQBYDShQpxvVvwQcDqk5C5Gz0O+nAtJNPrk1e+kya311jZ/7FdA65kT7KmmL
         3jrjSWBQFaJtIszqQqPXAh0/otkChEhriAospSULv0Vd+/A7duoeNnyOxkGlCicNLjSL
         H65cGtoU6HXE6Qg1Uh7pKm90WXrE/QATzIxCP64Q3LjpCWiJ7Zf+gTy2AB8XcPEwSoEp
         MnvGOQ0WVoypT3szPuWjgA4qniTqjXkv2UCOIhbGKSDNPa2Hum5aYo6P+kNdcbwcoDND
         qmkCMXseH19JDYekNLjFFEPbgAvd25a3PwDFEZ7nw81EPB0GY8MiDwdF1CIM3ADBY7gH
         3+6w==
X-Gm-Message-State: APjAAAU1kErm+mpL9g9kmQ1JHy1C75h6AeJWo9tsPfHTfuGXdhezHg4O
        NdkN4jJHwXBeRIT+NumbdSeRaqpIMQuJryOPrGrB7+myeYqAxlCVA20VfostXXQl59XijEMwNR2
        NtP9SQ/3kjKbl
X-Received: by 2002:a05:600c:34b:: with SMTP id u11mr2242548wmd.176.1570620464528;
        Wed, 09 Oct 2019 04:27:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzhbHq0jBzIpVmXjFywxZ2l55Q3tKca7gUZJ83WF4NOur5t8DDjUN50FdCbtP55IeTz4hoFmQ==
X-Received: by 2002:a05:600c:34b:: with SMTP id u11mr2242532wmd.176.1570620464298;
        Wed, 09 Oct 2019 04:27:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h10sm1982665wrq.95.2019.10.09.04.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:27:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 6/8] KVM: x86: Fold 'enum kvm_ex_reg' definitions into 'enum kvm_reg'
In-Reply-To: <57cae37d-acd0-074c-26cd-aaf7a7989905@redhat.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-7-sean.j.christopherson@intel.com> <87ftke3zll.fsf@vitty.brq.redhat.com> <57cae37d-acd0-074c-26cd-aaf7a7989905@redhat.com>
Date:   Wed, 09 Oct 2019 13:27:42 +0200
Message-ID: <87a7aayx8x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 30/09/19 11:25, Vitaly Kuznetsov wrote:
>>> -enum kvm_reg_ex {
>>>  	VCPU_EXREG_PDPTR = NR_VCPU_REGS,
>> (Personally, I would've changed that to NR_VCPU_REGS + 1)
>> 
>
> Why?
>

Just so every entry in the enum is different and NR_VCPU_REGS acts as a
guardian.

-- 
Vitaly
