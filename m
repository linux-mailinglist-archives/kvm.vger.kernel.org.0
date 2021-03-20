Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AF6342F72
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 21:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhCTUGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Mar 2021 16:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhCTUFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Mar 2021 16:05:37 -0400
X-Greylist: delayed 3141 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 20 Mar 2021 13:05:37 PDT
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8452BC061574
        for <kvm@vger.kernel.org>; Sat, 20 Mar 2021 13:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        References:Message-ID:In-Reply-To:Subject:cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pTqic6AnLx3tpQzBR4QDTvs303YgjQmrFKX5ZdEXxb0=; b=fzwWbiT/Uifrd0kOfF+YECegId
        TSYYmoB4zuS/cBK6EvhmrWlB7shS3b3cz6s1s3rcL0PBtvwC36519F4J+0O9XRqzN35Acrpqwzeaa
        WX1XXAb8u1GlX3j5aAJqaS26CqNDF2tiRp6p5mrYsnTwlxzUTBFSmTFVpcMvPqs3vXDyJhIONye6x
        PJQWjz1dQGQ4VLcjcq5Mp2CmsEe1enuuFYMoCKTn2Fmip132XG1qeyapUVBmAR6sBbs9+yYTWo9dQ
        idGgVYPCn+dJkI1AbBf8dflZ1cnaabqWCg+e75EJ2Ly9+K67pgxKXZBHLf7/VQTFYQBml68WIaPcW
        tQSNpDqQ==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lNh1b-001zsq-OP; Sat, 20 Mar 2021 19:12:40 +0000
Date:   Sat, 20 Mar 2021 12:12:39 -0700 (PDT)
From:   Randy Dunlap <rdunlap@bombadil.infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: A typo fix
In-Reply-To: <20210320190425.18743-1-unixbhaskar@gmail.com>
Message-ID: <f9d4429-d594-8898-935a-e222bb8c247@bombadil.infradead.org>
References: <20210320190425.18743-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: Randy Dunlap <rdunlap@infradead.org>
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210320_121239_816284_FD52668F 
X-CRM114-Status: GOOD (  11.44  )
X-Spam-Score: -0.0 (/)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Sun, 21 Mar 2021, Bhaskar Chowdhury wrote: > > s/resued/resumed/
    > > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com> Acked-by: Randy
    Dunlap <rdunlap@infradead.org> 
 Content analysis details:   (-0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 NO_RELAYS              Informational: message was not relayed via SMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Sun, 21 Mar 2021, Bhaskar Chowdhury wrote:

>
> s/resued/resumed/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
> arch/x86/include/asm/kvm_host.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9bc091ecaaeb..eae82551acb1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1470,7 +1470,7 @@ extern u64 kvm_mce_cap_supported;
> /*
>  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
>  *			userspace I/O) to indicate that the emulation context
> - *			should be resued as is, i.e. skip initialization of
> + *			should be resumed as is, i.e. skip initialization of
>  *			emulation context, instruction fetch and decode.
>  *
>  * EMULTYPE_TRAP_UD - Set when emulating an intercepted #UD from hardware.
> --
> 2.26.2
>
>
