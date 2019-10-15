Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D518D70E2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 10:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfJOIWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 04:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfJOIWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 04:22:01 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A6EA811DC
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 08:22:01 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id k184so8293573wmk.1
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 01:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4XCdYGBXgpm0bocpCasqCHuINSD48ZL6bGb+DpNrsjk=;
        b=C6fF1jRmzveL0vUPLpJrZYqExSouY6HOea7cKRlyneagsfYCIzvXhbg7S1NrNAIAS0
         3B461AazcuuJWA8RrNm6aaBHGnc4OvU1Oi6fM5FvlVSC/yMt0e8Pzuea/GeJ0FzWu1qT
         xdzxcQtXvn8ZsQJQMfMw1rtD3P3lvbvwLrHbOukf02xcVuoA5q4jqud6yqozmDHmmmuP
         V0k1olX+hhZTKp4jxPq8cfUxSa4GWmHr/HRzETHMSjpHyA1L3LOQo7eW/PwycKSqiZum
         utbir89M39bzp/zrHZ7uKhzcoBnMAiIK+Ljlv3QiokmWnzMhIbIXzqKhV1ckOt1yCnV/
         kIog==
X-Gm-Message-State: APjAAAWQsHeSIeSydbjUmGCdgsXWabV88pAmR7wQWYh5vYdfDd+xZxKU
        QJxG52lxSrJ37E15Gg4LO4XE2S3VCjDm49FqZTEiAAsMQz1vw8w3booJa7ONy+NCrJyiIb7Xvxb
        6+TSdc0QyQf0H
X-Received: by 2002:a1c:1a4c:: with SMTP id a73mr18125844wma.124.1571127719712;
        Tue, 15 Oct 2019 01:21:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxKc8Jm/JgcHD/AD/1dyiUKrdBMoPSwMtLcSNr+lQLEPVUUfQPP0WRLafdscfoBCDPfVMeRYA==
X-Received: by 2002:a1c:1a4c:: with SMTP id a73mr18125819wma.124.1571127719363;
        Tue, 15 Oct 2019 01:21:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id n1sm26097437wrg.67.2019.10.15.01.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 01:21:58 -0700 (PDT)
Subject: Re: [PATCH 02/14] KVM: monolithic: x86: disable linking vmx and svm
 at the same time into the kernel
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-3-aarcange@redhat.com>
 <20191015031619.GD24895@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <94f1e36e-90b8-8b7d-57a5-031c65e415c4@redhat.com>
Date:   Tue, 15 Oct 2019 10:21:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015031619.GD24895@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 05:16, Sean Christopherson wrote:
> I think short and sweet is enough for the prompt, with the details of how
> build both buried in the help text.
> 
> choice
> 	prompt "KVM built-in support"
> 	help
> 	  Here be a long and detailed help text.
> 
> config KVM_AMD_STATIC
> 	select KVM_AMD
> 	bool "KVM AMD"
> 
> config KVM_INTEL_STATIC
> 	select KVM_INTEL
> 	bool "KVM Intel"

Or even just

	bool "AMD"
	...
	bool "Intel"

> endchoice
> 
> The ends up looking like:
> 
>    <*>   Kernel-based Virtual Machine (KVM) support
>            KVM built-in support (KVM Intel)  --->
>    -*-   KVM for Intel processors support

On top of this, it's also nice to hide the KVM_INTEL/KVM_AMD prompts if
linking statically.  You can achieve that with

config KVM_INTEL
    tristate
    prompt "KVM for Intel processors support" if KVM=m
    depends on (KVM=m && m) || KVM_INTEL_STATIC

config KVM_AMD
    tristate
    prompt "KVM for AMD processors support" if KVM=m
    depends on (KVM=m && m) || KVM_AMD_STATIC

The left side of the "||" ensures that, if KVM=m, you can only choose
module build for both KVM_INTEL and KVM_AMD.  Having just "depends on
KVM" would allow a pre-existing .config to choose the now-invalid
combination

	CONFIG_KVM=y
	CONFIG_KVM_INTEL=y
	CONFIG_KVM_AMD=y

The right side of the "||" part is just for documentation, to avoid that
a selected symbol does not satisfy its dependencies.

Thanks,

Paolo
