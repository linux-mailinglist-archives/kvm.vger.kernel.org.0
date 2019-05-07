Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1075116BE1
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 22:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfEGUJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 16:09:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53123 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfEGUJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 16:09:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id o25so184452wmf.2
        for <kvm@vger.kernel.org>; Tue, 07 May 2019 13:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H1nNuVrk+MA/DXSyLMP71Qoe6uYqOWefoMawy3ihxoM=;
        b=EkmalRMby8XxKzjKvm9tWQtPk9fBaUnyZFkJ8/LoXfMVRJSche99ugRVYbGYPC54G/
         rhW+Qd0yExnP81QdQ1kR7HCbXKQ9YWwYwNXo7yodrYrxn1YqPMzCXqA/7fxIXEsuYBLk
         4sTOp/LxYfmwyBgcqaeQPckroWRi7EOYde+4S24KT314myEGF0wkXIOb4Qg+5Zau0Xdz
         1X83Uxhza4yWNRh76EDEuJAurcCle+L04bUk8g6+63nodRX4vKucW8wp4abFp+sYOaQe
         OSyp2AmhCg0SFOAPBKuZrfuNCDx5PubAKsjLvvvLNC+7U6V8IY+Thn/eUqK8rzSch9Hv
         wYLA==
X-Gm-Message-State: APjAAAWj+3FH9OW0CpwxeIP01o2DQIJrK+E1XINP1+/RTzxVQdqItRp8
        qNUe/t8rZwPHbjQpFymIIWKqwA==
X-Google-Smtp-Source: APXvYqwL2nNOaBeyu7cg5iBNSL/GvpipvTbCTcI9THcS5q0VsXQdFxui08fvtnmUTITIgCboaze5rQ==
X-Received: by 2002:a05:600c:3cb:: with SMTP id z11mr143330wmd.140.1557259772604;
        Tue, 07 May 2019 13:09:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cc0e:e691:1dfa:1841? ([2001:b07:6468:f312:cc0e:e691:1dfa:1841])
        by smtp.gmail.com with ESMTPSA id y7sm36018770wrg.45.2019.05.07.13.09.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 13:09:32 -0700 (PDT)
Subject: Re: [PATCH 01/15] KVM: nVMX: Don't dump VMCS if virtual APIC page
 can't be mapped
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce40bdf7-f893-443d-7976-c07795caa390@redhat.com>
Date:   Tue, 7 May 2019 22:09:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507160640.4812-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 11:06, Sean Christopherson wrote:
> ... as a malicious userspace can run a toy guest to generate invalid
> virtual-APIC page addresses in L1, i.e. flood the kernel log with error
> messages.
> 
> Fixes: 690908104e39d ("KVM: nVMX: allow tests to use bad virtual-APIC page address")
> Cc: stable@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

The same is true even of dump_vmcs caused by emulation failures.  I'm
thinking of just hiding dump_vmcs beneath a module parameter.

Paolo
