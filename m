Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69332D9E5F
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408679AbgLNR7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 12:59:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502539AbgLNR6O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 12:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607968607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=79cm79IVkiUIbLvmmmEIZwiax7dBoLljm3f9FmIzx+g=;
        b=a+2u/O8yIUDeiD2ks0/1+QGGI+vVIY9quXLqD8yM/UDhi+YDiBlerCT4jmZTXmWRubLVGQ
        eB949Sx2hsSRkO2mAtYh2VeEoDDr/HzomMIkkQty8597t1W0q5jXb+0QJg8zq3RHywMP/1
        wx5qKf2Zo+S0ohhFHieItr1nVHmmJX4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-rpoS7FtiPW-F_cyS7NLhSg-1; Mon, 14 Dec 2020 12:56:46 -0500
X-MC-Unique: rpoS7FtiPW-F_cyS7NLhSg-1
Received: by mail-ed1-f69.google.com with SMTP id e11so8673060edn.11
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 09:56:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=79cm79IVkiUIbLvmmmEIZwiax7dBoLljm3f9FmIzx+g=;
        b=NdnL6gsvb+U5cKCdA21y5Csfys/U1dP43atNN6UhkrP34CMIY8OapKPgNEulzHXhuI
         OkPrZ/GeCDrVZrPqyCxmhHrqqgqr5WmAWAkhjsKIVVQ4GO/psZ11U8owf9MIpj2V0qkf
         BSdiopwRqzpmNzKncTynTUZkXIC/BDDdut3X5CKWEC5HGGUH0wl8GxA+79tgXVpKMltX
         Vs7zubaQ2uO3u3V2dBCZBI+AmfgfwLiOwsSOflVCqAlTgSNT7DXs0Pn7leuqgeGM+fNx
         SVw2faC4ROWjU/gZ5FKOQUvjgaTZMK/7KlQo2rnFl0M5LTabt78pUOlpIhKvpv1ULrb5
         7jRg==
X-Gm-Message-State: AOAM530YcrkCP2L7GmaLB6/eVk0ssyhblcTn7YzZcRnBm4T6SNvamiDx
        FDDli5wieewfpvnxQJmj8UmNt4UxvbPEworyi/ytWX7POgfjvAUjajpEviuQRgfERMaQO1V7Jbs
        q3efnhgLAS4NB
X-Received: by 2002:a17:907:101c:: with SMTP id ox28mr22119721ejb.201.1607968604819;
        Mon, 14 Dec 2020 09:56:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDh7obIu90aOomr8vENCNh64r6dOqJ66dyirZU/BAXGxgxblE1fizw2ZRdkIUwFSn8NMbp1w==
X-Received: by 2002:a17:907:101c:: with SMTP id ox28mr22119703ejb.201.1607968604600;
        Mon, 14 Dec 2020 09:56:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o13sm15733009edr.94.2020.12.14.09.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 09:56:43 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.11
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        James Morse <james.morse@arm.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shenming Lu <lushenming@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20201214174848.1501502-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f94b87f5-fcc5-273d-f774-48b816eafa2b@redhat.com>
Date:   Mon, 14 Dec 2020 18:56:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201214174848.1501502-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/20 18:48, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the initial set of KVM/arm64 updates for 5.11. The most notable
> change is the "PSCI relay" at EL2, which is the first "user visible"
> feature required by the Protected KVM effort. The rest is a mixed bag
> of architecture compliance (PMU accesses when no PMU is present, cache
> hierarchy discovery), cleanups (EL2 vector allocation, AArch32 sysreg
> handling), internal rework (exception injection, EL2 function
> pointers), and general improvements (advertising CSV3, reduced GICv4
> entry latency).
> 
> Note that this pull request comes with some additional bonuses in the
> shape of a shared branch with the arm64 tree (arm64/for-next/uaccess),
> as it was conflicting*very*  badly with the new PSCI relay code.
> 
> I already have a bunch of fixes earmarked for after the merge window,
> but that is probably something for another year!

Ok, cool!  Expect my PR to Linus around the Thu-Fri.  Better set 
expectations right after the mess from 5.10.

Paolo

