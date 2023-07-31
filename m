Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB76376A342
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 23:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjGaVrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 17:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjGaVrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 17:47:45 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C174114;
        Mon, 31 Jul 2023 14:47:43 -0700 (PDT)
Received: from [192.168.105.249] ([75.104.94.137])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 36VLiSLD3093143
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 31 Jul 2023 14:44:34 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 36VLiSLD3093143
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023071101; t=1690839952;
        bh=Hg2XSL3316ANoXYXjd63x+cCNIVtiqBW14cv6sKLqfM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OJyzPW65vrM8sDH6eNGy+5kWbcB7PMYBpzWhQpIWkaAZClwYLyiR8q3r0h24DHa+i
         plc1tYwGV1X0jnVZoHyMcH21g4d3T5nrZNciwkD9pXyPp9eyd7deKj5//687qepUUN
         GajcQAPfiwt5T7KF3w3EDPjhuU+UOb+SXF0Ey3xPLdCdh2vlXfVnIDfD1LR2iQn1Q3
         +p5bLyY/BkC4u9rExXSQvakREpl4pn+K6rV/GzfnNnDvo8xR1x7/0XAWYi0JZGxsUi
         6sYcbHmh6hzcml78uw2uhAQKsHCzb+/6sFfciH7vXjmIcsvNRtd0H0JUkcPZnEheRh
         J+lI/W952JXBg==
Message-ID: <4ccbf0e9-716d-dfe0-537c-210e5455418c@zytor.com>
Date:   Mon, 31 Jul 2023 14:44:20 -0700
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
> +
> +static DEFINE_FRED_HANDLER(fred_sw_interrupt_user)
> +{
> +	/*
> +	 * In compat mode INT $0x80 (32bit system call) is
> +	 * performance-critical. Handle it first.
> +	 */
> +	if (IS_ENABLED(CONFIG_IA32_EMULATION) &&
> +	    likely(regs->vector == IA32_SYSCALL_VECTOR)) {
> +		regs->orig_ax = regs->ax;
> +		regs->ax = -ENOSYS;
> +		return do_int80_syscall_32(regs);
> +	}

We can presumably drop the early out here as well...

> +
> +	/*
> +	 * Some software exceptions can also be triggered as
> +	 * int instructions, for historical reasons.
> +	 */
> +	switch (regs->vector) {
> +	case X86_TRAP_BP:
> +	case X86_TRAP_OF:
> +		fred_emulate_trap(regs);
> +		break;
> +	default:
> +		regs->vector = X86_TRAP_GP;
> +		fred_emulate_fault(regs);
> +		break;
> +	}
> +}
> +

