Return-Path: <kvm+bounces-3284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57FF6802A2C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 03:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 091381F20F10
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 02:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F71117F4;
	Mon,  4 Dec 2023 02:12:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id D28E8B3;
	Sun,  3 Dec 2023 18:12:01 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Cx7+twNW1lJ6I+AA--.58446S3;
	Mon, 04 Dec 2023 10:12:00 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxO9xsNW1le8lTAA--.53472S3;
	Mon, 04 Dec 2023 10:11:58 +0800 (CST)
Subject: Re: [PATCH v5 4/4] KVM: selftests: Add test cases for LoongArch
To: Tianrui Zhao <zhaotianrui@loongson.cn>, Shuah Khan <shuah@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 loongarch@lists.linux.dev, Peter Xu <peterx@redhat.com>,
 Vipin Sharma <vipinsh@google.com>
References: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
 <20231130111804.2227570-5-zhaotianrui@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <ebdc956b-6235-370f-97d1-c24540c05047@loongson.cn>
Date: Mon, 4 Dec 2023 10:11:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231130111804.2227570-5-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxO9xsNW1le8lTAA--.53472S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7uw17Kr4DtFyDCF4kGFW3urX_yoW8KFWrpF
	yI9r1jvFWxurs3Jwn3Gw4DZan3Cr9Fgr40gFy3Kw18ur98J348JF1xKasrKFsYgw45Xa1Y
	v3WrKwnruayDA3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
	WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU00eHDUUUU
	U==



On 2023/11/30 下午7:18, Tianrui Zhao wrote:
> There are some KVM common test cases supported by LoongArch:
> 	demand_paging_test
> 	dirty_log_perf_test
> 	dirty_log_test
> 	guest_print_test
> 	kvm_binary_stats_test
> 	kvm_create_max_vcpus
> 	kvm_page_table_test
> 	memslot_modification_stress_test
> 	memslot_perf_test
> 	set_memory_region_test
> And other test cases are not supported by LoongArch. For example,
> we do not support rseq_test, as the glibc do not support it.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   tools/testing/selftests/kvm/Makefile | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index a5963ab9215..9d099d48013 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -65,6 +65,10 @@ LIBKVM_s390x += lib/s390x/ucall.c
>   LIBKVM_riscv += lib/riscv/processor.c
>   LIBKVM_riscv += lib/riscv/ucall.c
>   
> +LIBKVM_loongarch += lib/loongarch/processor.c
> +LIBKVM_loongarch += lib/loongarch/ucall.c
> +LIBKVM_loongarch += lib/loongarch/exception.S
> +
>   # Non-compiled test targets
>   TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
>   
> @@ -202,6 +206,17 @@ TEST_GEN_PROGS_riscv += kvm_binary_stats_test
>   
>   SPLIT_TESTS += get-reg-list
>   
> +TEST_GEN_PROGS_loongarch += demand_paging_test
> +TEST_GEN_PROGS_loongarch += dirty_log_perf_test
> +TEST_GEN_PROGS_loongarch += dirty_log_test
> +TEST_GEN_PROGS_loongarch += guest_print_test
> +TEST_GEN_PROGS_loongarch += kvm_binary_stats_test
> +TEST_GEN_PROGS_loongarch += kvm_create_max_vcpus
> +TEST_GEN_PROGS_loongarch += kvm_page_table_test
> +TEST_GEN_PROGS_loongarch += memslot_modification_stress_test
> +TEST_GEN_PROGS_loongarch += memslot_perf_test
> +TEST_GEN_PROGS_loongarch += set_memory_region_test
rseq_test is not supported by LoongArch kernel, and get-reg-list 
interface is not supported by KVM now, arch specific testcases
will be added later also.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> +
>   TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
>   TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
>   TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
> 


