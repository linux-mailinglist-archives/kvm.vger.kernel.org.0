Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D7474386D
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjF3Jf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbjF3JfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:35:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B9619C;
        Fri, 30 Jun 2023 02:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gjvjkCCihEKSHCtNs55Vy6HK0fcX8LSjTlJEivouiKY=; b=q6KW/ltdiPKvvuRUgkhRpG5tiX
        xYPuaOz5D40BDLakmqRRweDB6CAbOHn5CbNRYUObwWPty+Rz7sxXyh62XDqPKlr/cq5bQYuU+k9h7
        K/Z8H3HKvofJrY19uhf+RIta3h1hV8kLApOolc7NVHrSdb6RvUTaT7JwZwTxPX4LI9+9Xy72rG22a
        kF4L29JAf6v+j0l75hsaiKVdYYzy4PchGG9Q60FBOH9LaYWPbILZaeajIyiNXj6/KlV7DAJEmT9hP
        BYlCELyihyg0JOiaLMm4xWuaDdkxkPdRq+iPXtofR+QiyEtQp9l52W6yIUpwyqXXZdZGFCgArrW7A
        1yKY3AjA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qFAWa-007wV9-29;
        Fri, 30 Jun 2023 09:34:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 21D78300118;
        Fri, 30 Jun 2023 11:34:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 07396245D3645; Fri, 30 Jun 2023 11:34:44 +0200 (CEST)
Date:   Fri, 30 Jun 2023 11:34:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230630093443.GE2533791@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
 <20230628141011.GG2438817@hirez.programming.kicks-ass.net>
 <d759c22d1360a56aa43796700a7fa3a9106d9fa9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d759c22d1360a56aa43796700a7fa3a9106d9fa9.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 09:15:39AM +0000, Huang, Kai wrote:

> Sure.  How about below?
> 
> +       /*
> +        * TDH.SYS.INFO writes the TDSYSINFO_STRUCT and the CMR array
> +        * to the buffers provided by the kernel (via RCX and R8
> +        * respectively).  The buffer size of the TDSYSINFO_STRUCT
> +        * (via RDX) and the maximum entries of the CMR array (via R9)
> +        * passed to this SEAMCALL must be at least the size of
> +        * TDSYSINFO_STRUCT and MAX_CMRS respectively.
> +        *
> +        * Upon a successful return, R9 contains the actual entries
> +        * written to the CMR array.
> +        */
>         sysinfo_pa = __pa(sysinfo);
>         cmr_array_pa = __pa(cmr_array);
>         ret = seamcall(TDH_SYS_INFO, sysinfo_pa, TDSYSINFO_STRUCT_SIZE,

> Or should I just repeat the spec like below?

> +       /*
> +        * TDH.SYS.INFO writes the TDSYSINFO_STRUCT and the CMR array
> +        * to the buffers provided by the kernel:
> +        *
> +        * Input:
> +        *  - RCX: The buffer of TDSYSINFO_STRUCT
> +        *  - RDX: The size of the TDSYSINFO_STRUCT buffer, must be at
> +        *         at least the size of TDSYSINFO_STRUCT
> +        *  - R8: The buffer of the CMR array
> +        *  - R9: The entry number of the array, must be at least
> +        *        MAX_CMRS.
> +        *
> +        * Output (successful):
> +        *  - RDX: The actual bytes written to the TDSYSINFO_STRUCT
> +        *         buffer
> +        *  - R9: The actual entries written to the CMR array.
> +        */
>         sysinfo_pa = __pa(sysinfo);
>         cmr_array_pa = __pa(cmr_array);
>         ret = seamcall(TDH_SYS_INFO, sysinfo_pa, TDSYSINFO_STRUCT_SIZE,

Either of them work for me, thanks!

> > SDM doesn't seem to be the place. That doesn't
> > even list TDCALL/SEAMCALL in Volume 2 :-( Let alone describe the magic
> > values.
> > 
> 
> TDX has it's own specs at here:
> 
> https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html
> 
> For this one you can find it in here:
> 
> https://cdrdv2.intel.com/v1/dl/getContent/733568

Yeah, eventually found it. I still think both TDCALL and SEAMCALL should
be listed in SDM Vol.2 instruction listing -- every valid instruction
should be found there IMO.

I also feel strongly that a global ABI should be decided upon for them
and the SDM would be a good place to mention that.  leaving this to
individual calls like now is a giant pain in the rear.

As is, we have TDCALL leaf-0 with a giant regset but every other leaf
has (c,d,8,9) for input and +(10,11) for output. Lets fix that in stone.

Obviously I also very strongly feel any such ABI must not confict with
pre-existing calling conventions -- IOW, using BP is out, must not
happen.
