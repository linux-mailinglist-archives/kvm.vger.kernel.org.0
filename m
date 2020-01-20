Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A14143019
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 17:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgATQkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 11:40:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52141 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726897AbgATQkM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 11:40:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579538411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8tvpA9/Y4Qewt6OlrjGLcu0zgEePrnq1IOmYVdg2kZU=;
        b=H1QKIOaSfJMdbhs7csly2+/ICnkKxPdU2Gxfm1yJxyl4wdTsCXu0m8v6wfRPOs8gVbr6rQ
        Uiry9CS80D/xiqqVUGNp6S/q5QWnNnjpWWb3MOkUHgWOlKNb8mPJtt9GCrnBTV8cgcvL72
        OMwDwuzE4QyfDCy9gki4rLCiB3Gvmpo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-ytUpnh2pM0abBFGwtibgwg-1; Mon, 20 Jan 2020 11:40:09 -0500
X-MC-Unique: ytUpnh2pM0abBFGwtibgwg-1
Received: by mail-wr1-f70.google.com with SMTP id f10so40922wro.14
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 08:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8tvpA9/Y4Qewt6OlrjGLcu0zgEePrnq1IOmYVdg2kZU=;
        b=t/+WVcP4T6rxiHWfUNZ8IBorTVCQqTrPnEer3ePzk7JlRTgmfgc8YivQakj8Va91JA
         E6HLR15pNVUEdKOR5KLBuOInd9DGiec63WHpOF/GgnN0n27pcHZg3ZWVDZmNolf/yz+p
         bgj22THio2QMu/aheo31bHphhkTxnONA26IVpXo1lvKLPJeUkTnJf6PP3gk9ciEg1qEe
         A9FPEM6b4ZaTth2BszdoKCYimjLSt22QNXSvMGe8PvafmmXS/G7efZ33PYVZPGIrMX45
         FXz+YGF0HobItoAzdWZJ0XJDM9P9YeAUzMnrcDCyUvUkHMerZSRYrTW3nmXISROPA883
         dBUg==
X-Gm-Message-State: APjAAAXrNcm1TjI3FAWGrkaQ3yLWZh3ISQOUDixo50KP+ijkJy9EkHQ3
        GUvVli/MaOCaIJwTcC73KuVXVCbrndJACT4iJijWsrIM3AchwVPToBZv6ZEVI6b1CqZw+5hWS9S
        SqdMvUek2kuAR
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr352068wrx.109.1579538408092;
        Mon, 20 Jan 2020 08:40:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqyiE8pOqmjfGlid2Io78X8iGQvpRLqrU5v2S78XCSmH8UM9vg975NqPeWVl8Fhlar1IIm+pdA==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr352045wrx.109.1579538407773;
        Mon, 20 Jan 2020 08:40:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id e18sm48728888wrr.95.2020.01.20.08.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 08:40:07 -0800 (PST)
Subject: Re: [RFC] Revert "kvm: nVMX: Restrict VMX capability MSR changes"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>
References: <20200120151141.227254-1-vkuznets@redhat.com>
 <30525d58-10de-abb4-8dad-228da766ff82@redhat.com>
 <87k15mf5pl.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eeef5ff3-8ca9-4f21-7e48-d6c930985059@redhat.com>
Date:   Mon, 20 Jan 2020 17:40:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87k15mf5pl.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/20 17:33, Vitaly Kuznetsov wrote:
>> I think this should be fixed in QEMU, by doing KVM_SET_MSRS for feature
>> MSRs way earlier.  I'll do it since I'm currently working on a patch to
>> add a KVM_SET_MSR for the microcode revision.
> Works for me, thanks)
> 
> The bigger issue is that the vCPU setup sequence (like QEMU's
> kvm_arch_put_registers()) effectively becomes an API convention and as
> it gets more complex it would be great to document it for KVM.

Indeed, it's tricky to get right.  Though this is smaller compared to
the issue of the ordering between VCPU events and everything else.

Paolo

