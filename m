Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5AC19D1BF
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389998AbgDCIFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 04:05:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59142 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388793AbgDCIFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 04:05:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03384U2Q031524;
        Fri, 3 Apr 2020 08:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hIIh0o6V+KGB/5zN5BmtmvHGRj2kNsEuUXxhuxZ9qKk=;
 b=WyWbTSRuetmauXspBerhqpvSKaB1AaQ762FI0ssUT5jbFk78gNF1L2N2ijCiAc8nSeeg
 BKU2w9pobfJshbjxiGZDf3Ly+SiWgS3CsIXjRliyq9P/sIyL/uVxu/jB8/9I7lzTxzef
 oUhi0shQvQHETN/Dp2htM1M0KqAJ40mM1Ai6KjZ2icPeLP4lx+MChGGZaZ0M+LGSRxNP
 gP5vz/N0f4uVeBZUa0IFSjUs9jDOBHvvwvguw1bRwd5XYPjKcJwhjEtoswm725vXIppM
 BAZR1xzqNuRIDlI2XoXjJZBwWT/bfLdJclhfysHv2nkLykD0RrFgfYKuYlp1LL7A63tT uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yunj6ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 08:04:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03383Bxd112603;
        Fri, 3 Apr 2020 08:04:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 304sjs245t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 08:04:35 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03384REW028792;
        Fri, 3 Apr 2020 08:04:27 GMT
Received: from linux-1.home (/92.157.90.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 01:04:27 -0700
Subject: Re: [RESEND][patch V3 03/23] vmlinux.lds.h: Create section for
 protection against instrumentation
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200320175956.033706968@linutronix.de>
 <20200320180032.708673769@linutronix.de>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <c3dcdb3c-3883-7913-510b-8c39d0e0390b@oracle.com>
Date:   Fri, 3 Apr 2020 10:08:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200320180032.708673769@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030068
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/20 6:59 PM, Thomas Gleixner wrote:
> Some code pathes, especially the low level entry code, must be protected
> against instrumentation for various reasons:
> 
>   - Low level entry code can be a fragile beast, especially on x86.
> 
>   - With NO_HZ_FULL RCU state needs to be established before using it.
> 
> Having a dedicated section for such code allows to validate with tooling
> that no unsafe functions are invoked.
> 
> Add the .noinstr.text section and the noinstr attribute to mark
> functions. noinstr implies notrace. Kprobes will gain a section check
> later.
> 
> Provide also two sets of markers:
> 
>   - instr_begin()/end()
> 
>     This is used to mark code inside in a noinstr function which calls
>     into regular instrumentable text section as safe.
> 
>   - noinstr_call_begin()/end()
> 
>     Same as above but used to mark indirect calls which cannot be tracked by
>     tooling and need to be audited manually.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>   include/asm-generic/sections.h    |    3 +++
>   include/asm-generic/vmlinux.lds.h |    4 ++++
>   include/linux/compiler.h          |   24 ++++++++++++++++++++++++
>   include/linux/compiler_types.h    |    4 ++++
>   scripts/mod/modpost.c             |    2 +-
>   5 files changed, 36 insertions(+), 1 deletion(-)
> 
> --- a/include/asm-generic/sections.h
> +++ b/include/asm-generic/sections.h
> @@ -53,6 +53,9 @@ extern char __ctors_start[], __ctors_end
>   /* Start and end of .opd section - used for function descriptors. */
>   extern char __start_opd[], __end_opd[];
>   
> +/* Start and end of instrumentation protected text section */
> +extern char __noinstr_text_start[], __noinstr_text_end[];
> +
>   extern __visible const void __nosave_begin, __nosave_end;
>   
>   /* Function descriptor handling (if any).  Override in asm/sections.h */
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -550,6 +550,10 @@
>   #define TEXT_TEXT							\
>   		ALIGN_FUNCTION();					\
>   		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
> +		ALIGN_FUNCTION();					\
> +		__noinstr_text_start = .;				\
> +		*(.noinstr.text)					\
> +		__noinstr_text_end = .;					\
>   		*(.text..refcount)					\
>   		*(.ref.text)						\
>   	MEM_KEEP(init.text*)						\
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -120,12 +120,36 @@ void ftrace_likely_update(struct ftrace_
>   /* Annotate a C jump table to allow objtool to follow the code flow */
>   #define __annotate_jump_table __section(.rodata..c_jump_table)
>   
> +/* Begin/end of an instrumentation safe region */
> +#define instr_begin() ({						\
> +	asm volatile("%c0:\n\t"						\
> +		     ".pushsection .discard.instr_begin\n\t"		\
> +		     ".long %c0b - .\n\t"				\
> +		     ".popsection\n\t" : : "i" (__COUNTER__));		\
> +})
> +
> +#define instr_end() ({							\
> +	asm volatile("%c0:\n\t"						\
> +		     ".pushsection .discard.instr_end\n\t"		\
> +		     ".long %c0b - .\n\t"				\
> +		     ".popsection\n\t" : : "i" (__COUNTER__));		\
> +})
> +
>   #else
>   #define annotate_reachable()
>   #define annotate_unreachable()
>   #define __annotate_jump_table
> +#define instr_begin()		do { } while(0)
> +#define instr_end()		do { } while(0)
>   #endif
>   
> +/*
> + * Annotation for audited indirect calls. Distinct from instr_begin() on
> + * purpose because the called function has to be noinstr as well.
> + */
> +#define noinstr_call_begin()		instr_begin()
> +#define noinstr_call_end()		instr_end()
> +

Do you have an example of noinstr_call_begin()/end() usage? I have some
hard time figuring out why we need to call them out.

Thanks,

alex.


>   #ifndef ASM_UNREACHABLE
>   # define ASM_UNREACHABLE
>   #endif
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -118,6 +118,10 @@ struct ftrace_likely_data {
>   #define notrace			__attribute__((__no_instrument_function__))
>   #endif
>   
> +/* Section for code which can't be instrumented at all */
> +#define noinstr								\
> +	noinline notrace __attribute((__section__(".noinstr.text")))
> +
>   /*
>    * it doesn't make sense on ARM (currently the only user of __naked)
>    * to trace naked functions because then mcount is called without
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -953,7 +953,7 @@ static void check_section(const char *mo
>   
>   #define DATA_SECTIONS ".data", ".data.rel"
>   #define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
> -		".kprobes.text", ".cpuidle.text"
> +		".kprobes.text", ".cpuidle.text", ".noinstr.text"
>   #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
>   		".fixup", ".entry.text", ".exception.text", ".text.*", \
>   		".coldtext"
> 
