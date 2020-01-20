Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69194142EF7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 16:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgATPla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 10:41:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35941 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbgATPl3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 10:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579534888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfFFq+70X6qMf8r4MuhAIxjiC5PLXTTi4WgHQp9hBEw=;
        b=VIIncSWaXCSFCAzCDHRvM7Svzpxmm56oFCWZpexN1XuWEof1KLAsbJsqW8mgMCkDY0LgKQ
        +zxsVmZw1Hfcx2iE1QGBtKbI/QqUwfA3065xwytYBigJptR2hxKJsjtqd2wqplRtXrfuzO
        hBQee3nKDMXc825vVKNUu195UnDEPmY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-EmiJ3mQ_Nfyb-qMJK686GQ-1; Mon, 20 Jan 2020 10:41:27 -0500
X-MC-Unique: EmiJ3mQ_Nfyb-qMJK686GQ-1
Received: by mail-wr1-f69.google.com with SMTP id f15so14389413wrr.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 07:41:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NfFFq+70X6qMf8r4MuhAIxjiC5PLXTTi4WgHQp9hBEw=;
        b=QVZZV4Di0KAvzmPXbulC4ltcDuf3dwd2HvRH2YQAu4oN5nzJlOWkoElcJ2l1HxfOmF
         8kNApqKJ+wrAiXuUbZzt63/tTrs7LTcO4p5ROBwG1om3wBWLkm+6urxTrufdd+xDe4Yx
         a+hNQ/kFeCw1wVvftgZFN1wsZyk9tLqjjS3IfdORHB5WyTBwXEIngAZ+UP8YRd9MEA5N
         Tk40hkjaC9i+aS6HR1VtWKRE7CWUw9MC1z7qPrtjBWqvd1RzxbaaYZUNP0VebOuzmfvd
         XNO1F1w+rzh/R9FjTMXcVOWO50n5pj5KBTjrjMHEU+x+Ri12V1sjHKAsPg1lTN7ZzllF
         fT/Q==
X-Gm-Message-State: APjAAAWaPZ61g5SUYeyAsIVdb9hdbt0YkjKTNxJH8+bkmrAaYI9SeuoU
        d02lYfRbg30FKfkhd6PfzuxIEFO45hlayGB4Ni3jNE3Hj+SfPFPTznhYyLxXGnAMqv2HkoxY0Jo
        7Isz0PtuSSSNC
X-Received: by 2002:adf:f091:: with SMTP id n17mr68440wro.387.1579534885718;
        Mon, 20 Jan 2020 07:41:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxeN1H9XOiFOvdvahLayiiufSFu8dp6MB099coHjd9OyFt/De8dDdWWcXre82VFxJtVqeW/4A==
X-Received: by 2002:adf:f091:: with SMTP id n17mr68392wro.387.1579534885056;
        Mon, 20 Jan 2020 07:41:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id s65sm4968546wmf.48.2020.01.20.07.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 07:41:24 -0800 (PST)
Subject: Re: [RFC] Revert "kvm: nVMX: Restrict VMX capability MSR changes"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>
References: <20200120151141.227254-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30525d58-10de-abb4-8dad-228da766ff82@redhat.com>
Date:   Mon, 20 Jan 2020 16:41:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200120151141.227254-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/20 16:11, Vitaly Kuznetsov wrote:
> 
> RFC. I think the check for vmx->nested.vmxon is legitimate for everything
> but restore so removing it (what I do with the revert) is likely a no-go.
> I'd like to gather opinions on the proper fix: should we somehow check
> that the vCPU is in 'restore' start (has never being run) and make
> KVM_SET_MSRS pass or should we actually mandate that KVM_SET_NESTED_STATE
> is run after KVM_SET_MSRS by userspace?
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I think this should be fixed in QEMU, by doing KVM_SET_MSRS for feature
MSRs way earlier.  I'll do it since I'm currently working on a patch to
add a KVM_SET_MSR for the microcode revision.

Thanks,

Paolo

