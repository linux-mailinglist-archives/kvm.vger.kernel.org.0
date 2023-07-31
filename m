Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE64176A3F5
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 00:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjGaWLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 18:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjGaWLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 18:11:48 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0580B1981;
        Mon, 31 Jul 2023 15:11:41 -0700 (PDT)
Received: from [192.168.105.249] ([75.104.94.137])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 36VM7txf3103048
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 31 Jul 2023 15:08:00 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 36VM7txf3103048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023071101; t=1690841375;
        bh=X+M4w9IgqyGhFftvL0ts+Txt2pH1wocbrviAaT7WSp0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XFcw8mHtRsl4TcZ5Z+9TuwZ7pfjvdNqSpwDLDpFsAfd/pRi+FbwrTEcqslERWxffC
         cgFKch7rqXk7xeaKLgEYkT1cKGAy6lNFxl6xQJ0fbNDJ7sv9zpYGWXBRa8N2lEo5DR
         G/GCfDVd/qzoFF9SUxuA7hRU/ROGNY4q6TBtRqRfJXYuVJskDXCrkKAQal43XsJ7PX
         PlycbEss3tGY6NKNX7yE7ihX3QPEQjBg9VfjApas+qZFkVyB7AoO2WWrlZ+j8SXiEq
         CQq7y33RknpAiyzIOPtVrS0p+SqzFZP4pjxOjHk1xtmUQ70RjsXjOD9F2NjeIVYHD8
         KsFoANCn7EDLw==
Message-ID: <da169e64-9dad-18a8-611b-57ff74006285@zytor.com>
Date:   Mon, 31 Jul 2023 15:07:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 29/36] x86/fred: FRED entry/exit and dispatch code
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@Oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, Fei Li <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
References: <20230731064119.3870-1-xin3.li@intel.com>
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20230731064119.3870-1-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/30/23 23:41, Xin Li wrote:
> +static DEFINE_FRED_HANDLER(fred_other_default)
> +{
> +	regs->vector = X86_TRAP_UD;
> +	fred_emulate_fault(regs);
> +}
> +
> +static DEFINE_FRED_HANDLER(fred_syscall)
> +{
> +	regs->orig_ax = regs->ax;
> +	regs->ax = -ENOSYS;
> +	do_syscall_64(regs, regs->orig_ax);
> +}
> +
> +#if IS_ENABLED(CONFIG_IA32_EMULATION)
> +/*
> + * Emulate SYSENTER if applicable. This is not the preferred system
> + * call in 32-bit mode under FRED, rather int $0x80 is preferred and
> + * exported in the vdso.
> + */
> +static DEFINE_FRED_HANDLER(fred_sysenter)
> +{
> +	regs->orig_ax = regs->ax;
> +	regs->ax = -ENOSYS;
> +	do_fast_syscall_32(regs);
> +}
> +#else
> +#define fred_sysenter fred_other_default
> +#endif
> +
> +static DEFINE_FRED_HANDLER(fred_other)
> +{
> +	static const fred_handler user_other_handlers[FRED_NUM_OTHER_VECTORS] =
> +	{
> +		/*
> +		 * Vector 0 of the other event type is not used
> +		 * per FRED spec 5.0.
> +		 */
> +		[0]		= fred_other_default,
> +		[FRED_SYSCALL]	= fred_syscall,
> +		[FRED_SYSENTER]	= fred_sysenter
> +	};
> +
> +	user_other_handlers[regs->vector](regs);
> +}

OK, this is wrong.

Dispatching like fred_syscall() is only valid for syscall64, which means 
you have to check regs->l is set in addition to the correct regs->vector 
to determine validity.

Similarly, sysenter is only valid if regs->l is clear.

The best way is probably to drop the dispatch table here and just do an 
if ... else if ... else statement; gcc is smart enough that it will 
combine the vector test and the L bit test into a single mask and 
compare. This also allows stubs to be inlined.

However, emulating #UD on events other than wrong mode of SYSCALL and 
SYSENTER may be a bad idea. It would probably be better to invoke 
fred_bad_event() in that case.

Something like this:

+static DEFINE_FRED_HANDLER(fred_other_default)
+{
+	regs->vector = X86_TRAP_UD;
+	fred_emulate_fault(regs);
+}

1) rename this to fred_emulate_ud (since that is what it actually does.)

... then ...

	/* The compiler can fold these into a single test */

	if (likely(regs->vector == FRED_SYSCALL && regs->l)) {
		fred_syscall64(regs);
	} else if (likely(regs->vector == FRED_SYSENTER && !regs->l)) {
		fred_sysenter32(regs);
	} else if (regs->vector == FRED_SYSCALL ||
		   regs->vector == FRED_SYSENTER) {
		/* Invalid SYSCALL or SYSENTER instruction */
		fred_emulate_ud(regs);
	} else {
		/* Unknown event */
		fred_bad_event(regs);
	}

... or the SYSCALL64 and SYSENTER32 can be inlined with the appropriate 
comment (gcc will do so regardless.)

	-hpa



	-hpa
