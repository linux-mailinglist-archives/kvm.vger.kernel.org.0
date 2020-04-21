Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812461B2506
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 13:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgDULY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 07:24:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42624 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbgDULY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 07:24:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id j2so16019244wrs.9;
        Tue, 21 Apr 2020 04:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uw5Mt3dr851vXMgQW7w805be/4p/xjN24EpU6Jg+KuI=;
        b=U+N1LdOvCnF5dNiwvHg6EkD9zXMtH5p8EBLP6ji8/LHF4gFwKs4UOh9BYcRLW1XSp0
         Xi2Cd2BzUvzg6xZ7JTq2kyIrGLBxw4fXlUKxP23ZfI2mqzN/Y5s9oB1PpHETDRFgnAPt
         NrGkCn49VT2eZvVFkxjKM3cJjn8gEpYtlBiwaaHi40qlEgL38YRqNxeqHaFeFic/0Dcu
         20Y7EiipAcIGsRUKW9tkD9BIWYDPH1vwvNlBYbTmfpNSbYNGxCcO4C6A1+czy9AWk+f5
         XdeU/U9j62HbRUjUkvLJ15ka/pV5YjoHsgFjxVOD0EFb/hsfFRQBEJjiGsbOuOtaQdMK
         +r9w==
X-Gm-Message-State: AGi0PuYZYcafIW2pHXdQ7YtYkGHYfICt0SS+Onr9tso0etLj1aeRMwC/
        wYd9NmZ0KoC7q8eu7SaJ7PA=
X-Google-Smtp-Source: APiQypKIOz64WBIPNC1vP7IZm+bGZABOXsf+uqklLx137SNl/bO/F/ZPKc/k4XFnhiCePsMafSCWRg==
X-Received: by 2002:a5d:670d:: with SMTP id o13mr3695315wru.29.1587468265518;
        Tue, 21 Apr 2020 04:24:25 -0700 (PDT)
Received: from debian (44.142.6.51.dyn.plus.net. [51.6.142.44])
        by smtp.gmail.com with ESMTPSA id j10sm3142275wmi.18.2020.04.21.04.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 04:24:24 -0700 (PDT)
Date:   Tue, 21 Apr 2020 12:24:22 +0100
From:   Wei Liu <wei.liu@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/4] Split hyperv-tlfs.h into generic and arch specific
 files
Message-ID: <20200421112422.j4ihb4se7i5tddih@debian>
References: <20200420173838.24672-1-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420173838.24672-1-mikelley@microsoft.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 20, 2020 at 10:38:34AM -0700, Michael Kelley wrote:
> Michael Kelley (4):
>   KVM: x86: hyperv: Remove duplicate definitions of Reference TSC Page
>   x86/hyperv: Remove HV_PROCESSOR_POWER_STATE #defines
>   x86/hyperv: Split hyperv-tlfs.h into arch dependent and independent
>     files
>   asm-generic/hyperv: Add definitions for Get/SetVpRegister hypercalls
> 
>  arch/x86/include/asm/hyperv-tlfs.h | 472 +++--------------------------
>  arch/x86/include/asm/kvm_host.h    |   2 +-
>  arch/x86/kvm/hyperv.c              |   4 +-
>  include/asm-generic/hyperv-tlfs.h  | 470 ++++++++++++++++++++++++++++
>  4 files changed, 509 insertions(+), 439 deletions(-)
>  create mode 100644 include/asm-generic/hyperv-tlfs.h

This series looks good to me.

I will wait for a few days before actually queueing it to hyperv-next so
that other people can have a chance to comment.

Wei.
