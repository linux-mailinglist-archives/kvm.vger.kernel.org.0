Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A7915C960
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 18:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgBMRYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 12:24:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30362 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728704AbgBMRYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 12:24:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581614640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMnTmMYnUeKTqStdF/IUayq9A998cBCRdlJrS4A6/Q0=;
        b=UiTlu+5uVhgG4pZuxGBiJHWD89Ew06s+qQrbBEW3kc3HFukPeo3ho2RMlwcd8lyJDWkdZM
        vit+A/PGJ7uzX5+uhfdZ1CjVZtDtX2DY2FUkSXxfemVHVUCAxn7KH8h3Gj/IMURRQ9/nuf
        43TlLMMQA6wnvj1VjpylLA3ayFfgwy8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-OqvMLV1FMGy45eiVRp23tQ-1; Thu, 13 Feb 2020 12:23:58 -0500
X-MC-Unique: OqvMLV1FMGy45eiVRp23tQ-1
Received: by mail-wr1-f69.google.com with SMTP id c6so2613495wrm.18
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 09:23:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wMnTmMYnUeKTqStdF/IUayq9A998cBCRdlJrS4A6/Q0=;
        b=e5cZ6+mjzlbJmhcI7kgHVfojn2RE2HK5+2AXFl5N8bt1w6KRtLWMK4kMRBjbFyPYWi
         RVq/N0MmaSveG/Qqqa6RErgkB+1wmXiAnyNZqyUmQNQDFv2jNezUekPolk9BZissLGHh
         +BvKgi74jLyaQM4KCmAudoBc9ZxWYvMwv3woagw6U9rmY7BWnvEMnF7PCQJ+DkYsSnwQ
         oPrKIsdWSKfxn8ywEvLbZkwXXxMeJ+RmaZ0kL2ZEusPgY+pDbMk1gptL98LC4zNngq3C
         2BX2AsLDleMfFOsQ305d7p5dHCyHQbBAYAfvCLv4Muzbr98aaPMO3WMDR4rzZ3SJ6O09
         C1gw==
X-Gm-Message-State: APjAAAXfQC8+1rHmlEBVh4hDwhlg2TCbnqbMUUnwixvn+DWljfx9utIU
        UF7JU7epdvVzdOvgOeXknFhlsdDDtZ2Mr0NREQyhrRfOvjyaa7r+QLLCn6G+XtyHAr+VoMOO7nL
        G4DZJ24k39V/z
X-Received: by 2002:a7b:c3d1:: with SMTP id t17mr6785663wmj.27.1581614637321;
        Thu, 13 Feb 2020 09:23:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqxit2af91QRwK+Xcb8iJKb3JILMHhzb3nO4ICHnub3DmetOWujwqeeuimZjBIc7F5KHwTvYgg==
X-Received: by 2002:a7b:c3d1:: with SMTP id t17mr6785636wmj.27.1581614637011;
        Thu, 13 Feb 2020 09:23:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:48f0:7b10:ad88:6d83? ([2001:b07:6468:f312:48f0:7b10:ad88:6d83])
        by smtp.gmail.com with ESMTPSA id 5sm3738471wrc.75.2020.02.13.09.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 09:23:56 -0800 (PST)
Subject: Re: "KVM: x86: enable -Werror" breaks W=1 compilation
To:     Qian Cai <cai@lca.pw>
Cc:     joe@perches.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1581601803.7365.57.camel@lca.pw>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea7614c3-b917-a646-7e9f-27022062c9d7@redhat.com>
Date:   Thu, 13 Feb 2020 18:23:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1581601803.7365.57.camel@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/20 14:50, Qian Cai wrote:
> People have been running W=1 to catch additional compilation warnings with an
> expectation that not all of warnings will be fixed, but the linux-next commit
> ead68df94d24 ("KVM: x86: enable -Werror") breaks the build for them.
> 
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:663:12: error: no previous prototype
> for ‘kvm_arch_post_init_vm’ [-Werror=missing-prototypes]
>  int __weak kvm_arch_post_init_vm(struct kvm *kvm)
>             ^~~~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:672:13: error: no previous prototype
> for ‘kvm_arch_pre_destroy_vm’ [-Werror=missing-prototypes]
>  void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)

Thanks, we already found two bugs, one of them real (it's from
-Wtype-limits).  But I'll leave out this commit for now from the pull
request, of course.

Paolo

