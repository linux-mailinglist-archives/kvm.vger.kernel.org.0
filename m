Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BE3343DF7
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 11:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhCVKcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 06:32:39 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33994 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhCVKbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 06:31:44 -0400
Received: from zn.tnic (p200300ec2f06670063ce2fe2d87b4e47.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:6700:63ce:2fe2:d87b:4e47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D6BE41EC04D1;
        Mon, 22 Mar 2021 11:31:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616409098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=A7X6xqWwvrumHxCzhE/jGhlXXWmEGnnV8W9n3h7zfrM=;
        b=fj4dFah2LjRf9lhNjzR/HlbwH48kifin9iJOUdTZmYEdAiilXgsbAeb5WHR8m96PB7Sn0L
        lHKxRt3adznDjYY6mQ7MGn3t68KdPDS8Ezj8B8o5waytw+6P6DI6iv8YzvEp1MOijTLE6e
        Hu/AHI4jQw9pBhZf2S2ejjsBZpxCJ+A=
Date:   Mon, 22 Mar 2021 11:31:37 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Subject: Re: [PATCH v3 00/25] KVM SGX virtualization support
Message-ID: <20210322103137.GB6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <YFS6kTe1SuAjiMFN@kernel.org>
 <d876e5abb1a7e4fce160bfcb217bf3ab675f44a8.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d876e5abb1a7e4fce160bfcb217bf3ab675f44a8.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 11:03:28PM +1300, Kai Huang wrote:
> If there's no other comments, should I send another version

No need.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
