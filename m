Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B3A225161
	for <lists+kvm@lfdr.de>; Sun, 19 Jul 2020 12:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgGSKrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jul 2020 06:47:24 -0400
Received: from relay5.mymailcheap.com ([159.100.248.207]:40224 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgGSKrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jul 2020 06:47:23 -0400
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.102])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id E261126283;
        Sun, 19 Jul 2020 10:47:19 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id D94EA3F157;
        Sun, 19 Jul 2020 06:47:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id B48392A3B3;
        Sun, 19 Jul 2020 06:47:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1595155637;
        bh=Efv36P2QP2SU4fscZ+1ezXV90wtvaDLxz7YK6olWc1k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=q+v7bCDFWIOKX/B7dOHDs9q8i90smhJag8tSQgnZ6jgnq58sbHcfscph/NLYGLt8A
         WYhGHqPxIjX5sVDOvfvJ3PbGFc7q1Z9Gd85Ho+Eii/SoxZk9Q+QWZqs2oh3NkoYbHg
         mPOXvMUWqMP9yJS8mxm22rmihJ6ukwjIXphecu30=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZQtubH6C6Npr; Sun, 19 Jul 2020 06:47:16 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Sun, 19 Jul 2020 06:47:16 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 456CC40856;
        Sun, 19 Jul 2020 10:47:12 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="o3YaAinj";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (ec2-18-162-62-95.ap-east-1.compute.amazonaws.com [18.162.62.95])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 04DB540854;
        Sun, 19 Jul 2020 10:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1595155498;
        bh=Efv36P2QP2SU4fscZ+1ezXV90wtvaDLxz7YK6olWc1k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=o3YaAinjatmykFPsPv18oT85EmT2nxBeqacLxGsHo4+rRxuNgDTRSEpwK2aNu0nSJ
         C86mcW/OZvZhzHcKyzP+VpZxRer2SPIQ8bMAtJd1hmfdqkg/XnaJRWsT/Gh+olG0D2
         Mmk17xiijngNrddGhEejlBm4EXnagZKOCWn5G8Vs=
Subject: Re: [PATCH] MIPS: KVM: Fix build error caused by 'kvm_run' cleanup
To:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
References: <1595154207-9787-1-git-send-email-chenhc@lemote.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <79b5e965-b509-c1a3-cabc-715780e78f3c@flygoat.com>
Date:   Sun, 19 Jul 2020 18:44:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595154207-9787-1-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 456CC40856
X-Spamd-Result: default: False [1.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[9];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[lemote.com,redhat.com,alpha.franken.de,gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         FREEMAIL_CC(0.00)[vger.kernel.org,lemote.com,gmail.com,linux.alibaba.com];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2020/7/19 ÏÂÎç6:23, Huacai Chen Ð´µÀ:
> Commit c34b26b98caca48ec9ee9 ("KVM: MIPS: clean up redundant 'kvm_run'
> parameters") remove the 'kvm_run' parameter in kvm_mips_complete_mmio_
> load(), but forget to update all callers.
>
> Fixes: c34b26b98caca48ec9ee9 ("KVM: MIPS: clean up redundant 'kvm_run' parameters")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
> I have reviewed Tianjia's patch but hadn't found the bug, I'm very very
> sorry for that.


Oops, I suspected it as my local merge conflict at my initial test.

Sorry for the inconvinence.

- Jiaxun

>
>   arch/mips/kvm/emulate.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index d242300c..3b3f7b11 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -2128,7 +2128,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>   			run->mmio.phys_addr, run->mmio.len, run->mmio.data);
>   
>   	if (!r) {
> -		kvm_mips_complete_mmio_load(vcpu, run);
> +		kvm_mips_complete_mmio_load(vcpu);
>   		vcpu->mmio_needed = 0;
>   		return EMULATE_DONE;
>   	}
