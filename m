Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E528B365
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfHMJIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:08:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45266 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfHMJIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:08:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id q12so16770102wrj.12
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vSEPUTqGTvTIlPA47HMgabptB4wTrjlnzVdVCCfiQHw=;
        b=PyWw0+B1MNO50oic24cEfcDmwvEkmAg1knM7/PqxkURxGGoIESPPto3TaF259nDKmX
         em/voBgEf24k0z7vSHOv5Va41DUBcQsVTkh8InylcH9oaO8j+8q6JiZUCbXrTcOJ8QG1
         EdhnFm86G7apUnmqp9YZn45BOOGFIMLj79oM3KNvGd4eF0CORLDW3AB87rpdYNLB5Lqx
         UhTi1dBc2GfXMUI0cyc944AluXhrvFJ2GkfK02MuKSxsUDglCPBO0ZD1KmZqGUn4DUrv
         hkV13gBqyFC2R9FqG/7LuQR9kB79xGyQAE23bshGQ3cVHL5vW5WoYzWlntwSZzwfHpp6
         A8HQ==
X-Gm-Message-State: APjAAAWpMKTm6FMFW/B8adqYx2cwbDwZdnWatgghIOkiYtYOCLO9UaMl
        nGZXGw3z3WMTT8JqwBuWyKlI5g==
X-Google-Smtp-Source: APXvYqxphI9IUoLpUIef25ST16HnKb9bpvR5V1zmLOhTuusS26HOW6o20LLiYcUp6Q4TqPyLCN+ZUA==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr29345197wre.114.1565687322206;
        Tue, 13 Aug 2019 02:08:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d12:7fa9:fb2d:7edb? ([2001:b07:6468:f312:5d12:7fa9:fb2d:7edb])
        by smtp.gmail.com with ESMTPSA id q18sm134649129wrw.36.2019.08.13.02.08.41
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:08:41 -0700 (PDT)
Subject: Re: [RFC PATCH v6 70/92] kvm: x86: filter out access rights only when
 tracked by the introspection tool
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-71-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8cba6816-8d3a-2498-b3b0-2ce76a98ce12@redhat.com>
Date:   Tue, 13 Aug 2019 11:08:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-71-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 18:00, Adalbert Lazăr wrote:
> It should complete the commit fd34a9518173 ("kvm: x86: consult the page tracking from kvm_mmu_get_page() and __direct_map()")
> 
> Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
> ---
>  arch/x86/kvm/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 65b6acba82da..fd64cf1115da 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2660,6 +2660,9 @@ static void clear_sp_write_flooding_count(u64 *spte)
>  static unsigned int kvm_mmu_page_track_acc(struct kvm_vcpu *vcpu, gfn_t gfn,
>  					   unsigned int acc)
>  {
> +	if (!kvmi_tracked_gfn(vcpu, gfn))
> +		return acc;
> +
>  	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREREAD))
>  		acc &= ~ACC_USER_MASK;
>  	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREWRITE) ||
> 

If this patch is always needed, then the function should be named
something like kvm_mmu_apply_introspection_access and kvmi_tracked_gfn
should be tested from the moment it is introduced.

But the commit message says nothing about _why_ it is needed, so I
cannot guess.  I would very much avoid it however.  Is it just an
optimization?

Paolo
