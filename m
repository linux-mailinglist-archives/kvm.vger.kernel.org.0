Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B030143000
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 17:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgATQdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 11:33:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23756 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726901AbgATQdb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 11:33:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579538010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K1zcq54gP0pXiBRG1fF2BRNY1nGBgHmf0naqBgZVYZA=;
        b=jMrUkcJnmYqziVQeI1QHaidzwzvXfmAPLJ2K1rS+HH3nTNQyIGddrkL7VPbI2q/3LVOrfO
        C23SQyCJq5I405s196qRrJQDIdSlPcaydjyKLOGclP2nPvQEZLDTq0Gm8v9yG8IeSW2qnL
        s4qdOZUEZRcJXrM9ao0A2ufkgTBYwdA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-wS97HA4xMU2QUXuCm0_H8g-1; Mon, 20 Jan 2020 11:33:29 -0500
X-MC-Unique: wS97HA4xMU2QUXuCm0_H8g-1
Received: by mail-wm1-f71.google.com with SMTP id 18so11195wmp.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 08:33:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=K1zcq54gP0pXiBRG1fF2BRNY1nGBgHmf0naqBgZVYZA=;
        b=VuxS++R4xmTZdCSCONvgXjE9oy3DIU503jiHnwUmZITw11VVPZ9wZdTyRxtVCTvSjx
         xk0b0nouajCEYDi9bK+QfWqmP+mDbe+u90DRmaB08/gObdaFQ+oXc4vjSZWiYMryc0V2
         91lLg6IK40NHWpCyWX3mOnzt59vTmnIeSFofp7u4ABp2GDbB1NJXr9YjeO1MMIFvKGIA
         iiHWxEYLIB+0OLuvRzTxc1E/io+IVhVUhpgZYn1ZxxrWvLf3oF+5q/Sil1KFsAnHp6/h
         eaj2jbNNLcDtNDWOgK/B/TlNK+cB/kHxcCH4NeI840AwXW7eUZclFkkPVm/gesnf7j7N
         eJnA==
X-Gm-Message-State: APjAAAU3eRpkmifOazpBSEo1I+Iyx8Kje61U4gqxDTNneeOvQUgUhp8Y
        M5DCQWShr3MuttJCBngexVsBs5xATG10Z0qFiTexYBPhpT4odcPmHEaYBO2hrAklL3vMmG+aHdd
        uKMMidbToN0GZ
X-Received: by 2002:a5d:45c4:: with SMTP id b4mr298155wrs.303.1579538008686;
        Mon, 20 Jan 2020 08:33:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqyH1y6QHBvoU2MiBx+BCIkxLVbqTXcXlc6sAqVsfOSnE//yyWWeKTqmGdEFekqNwtFNoZ6hIw==
X-Received: by 2002:a5d:45c4:: with SMTP id b4mr298137wrs.303.1579538008452;
        Mon, 20 Jan 2020 08:33:28 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v22sm22281449wml.11.2020.01.20.08.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:33:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [RFC] Revert "kvm: nVMX: Restrict VMX capability MSR changes"
In-Reply-To: <30525d58-10de-abb4-8dad-228da766ff82@redhat.com>
References: <20200120151141.227254-1-vkuznets@redhat.com> <30525d58-10de-abb4-8dad-228da766ff82@redhat.com>
Date:   Mon, 20 Jan 2020 17:33:26 +0100
Message-ID: <87k15mf5pl.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 20/01/20 16:11, Vitaly Kuznetsov wrote:
>> 
>> RFC. I think the check for vmx->nested.vmxon is legitimate for everything
>> but restore so removing it (what I do with the revert) is likely a no-go.
>> I'd like to gather opinions on the proper fix: should we somehow check
>> that the vCPU is in 'restore' start (has never being run) and make
>> KVM_SET_MSRS pass or should we actually mandate that KVM_SET_NESTED_STATE
>> is run after KVM_SET_MSRS by userspace?
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> I think this should be fixed in QEMU, by doing KVM_SET_MSRS for feature
> MSRs way earlier.  I'll do it since I'm currently working on a patch to
> add a KVM_SET_MSR for the microcode revision.

Works for me, thanks)

The bigger issue is that the vCPU setup sequence (like QEMU's
kvm_arch_put_registers()) effectively becomes an API convention and as
it gets more complex it would be great to document it for KVM.

-- 
Vitaly

