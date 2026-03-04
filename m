Return-Path: <kvm+bounces-72747-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKXVLF6UqGkLvwAAu9opvQ
	(envelope-from <kvm+bounces-72747-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 21:21:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7D3207909
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 21:21:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA0753062FA9
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 20:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68AD371871;
	Wed,  4 Mar 2026 20:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ePsaqoVG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B714827E049;
	Wed,  4 Mar 2026 20:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772655553; cv=none; b=SrW+/mE8L3kCTdKwmfqqHCU2+C8SedSKPFoJvepgzIBA2w1jmbx81p2Z9SwvwKUANLKDi9+UBmyhlpFwpsBq7bTPMvWzeiO0FE+4SL1ezPgHgMHnUZNGncYkGnnzh/q9fWNrh/Bu4BruYnGl34NtSEVQLy735iHaiaXjJEdGmKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772655553; c=relaxed/simple;
	bh=74Jsu255Q/euPKCA7TGkWaEIhAZUiCCjebu+ZFLEpvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f+YaTbaD8FbAST6rNsLr2ymhrAr//M61vkuT/dAZIX49H3BsGLjVjks6fkdny5cuyyoLwN42+nqb8VR1L/VWh9dPloEQM4ZScjTPvHNsYpjI9c1N/maZvEXqgwvsnqq1D2KNQxZgeQOXKnOrhrCxsWwh+qKZSzm2sWR/sTIOJGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ePsaqoVG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624GC2fx126572;
	Wed, 4 Mar 2026 20:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ROJ1wb
	6krvufzOwRxM+wjsf8/DGIK/Eus7rvFKTwMQ0=; b=ePsaqoVGaHiqs4Z350LukY
	4mhM9wGBuCL/R2L1imFUoveSVZC/4TuszMMjpzn1dwd7w6ATIE6o/kfkZveBvhPs
	AK7xccR2dbesmLFGYuK9uMjFOmn7X2nlBvL8iSPhCu2maBRMODH3xfigWkvgrsIu
	a9d/SfczPEWYidj1LLv6+rvs3dIlgPqnk6IR7xTK3BZoJhCQDxN/cbOkTSyKTW61
	rQQ/g6M6Y3tz850s3cAVKJQYDvZAwKhleXP6bg6hADXP3PEOT3LYFPnWMOmANcJj
	fmruHJSVt8yufdNcSna7IHGyiF0ZuEtCmx4abgl390lF5sOvh8GO+p3Bp/iApOzg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckssmrpau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 20:19:10 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 624JbY08010309;
	Wed, 4 Mar 2026 20:19:09 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmc6k86r9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 20:19:09 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 624KJ8S76619850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Mar 2026 20:19:08 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FA5158055;
	Wed,  4 Mar 2026 20:19:08 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 896265804B;
	Wed,  4 Mar 2026 20:19:07 +0000 (GMT)
Received: from [9.61.30.112] (unknown [9.61.30.112])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Mar 2026 20:19:07 +0000 (GMT)
Message-ID: <cef95ca6-f55a-43b4-b65c-ee7372530eee@linux.ibm.com>
Date: Wed, 4 Mar 2026 15:19:07 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: s390: selftests: Add IRQ routing address
 offset tests
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, freimuth@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
References: <20260303135250.3665-1-frankja@linux.ibm.com>
 <20260303135250.3665-3-frankja@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20260303135250.3665-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDE2NSBTYWx0ZWRfX0tVphaYwDiaC
 etPnsd/vRMgSh8weskcIGelvMWsxfZymmnro7sXt7iuDy1cqvYCD9cjD9Nwu6+IlhIZX3Ty8e7f
 //0kDu2igx29KZryAICQtfh9zNwZQq/PjpYkHdIyP9Ue/QX+onk82asEia5aIW/K2OlNxSrf/um
 Ddm5LcXSM5F673wqppY15jsqZDtXOKz+Oc+F2M/jUGylTXG+jxdf05yzF8mF7KGFFiq5qe9FXpg
 wem/PXFfqUujpvama5Du/4To5jmAR5wUQiNfiftnawEaKNHDjT/G/xkhOBFuYG/XtrgFxKyD+cp
 C8ndR2702qAWLL1rPOCFMmPER5oMKr46zciTep9R5n9sYf521s0tjp4vXCypl260qmWiwd/4e/e
 HHurwElseHzZZJ1UR8QSCaRhT8tLx50hemzWz33goQhyZpA8dru0hpnxF7GJtCmgfUGJyFoAtIy
 Ia4Rki//SwvWIUoRAow==
X-Proofpoint-ORIG-GUID: vRuvqDHo7QiszxEdWFjcnNWYSncQHklz
X-Proofpoint-GUID: vRuvqDHo7QiszxEdWFjcnNWYSncQHklz
X-Authority-Analysis: v=2.4 cv=AobjHe9P c=1 sm=1 tr=0 ts=69a893be cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=GmlhtUVhPKtlo-jr32YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_07,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040165
X-Rspamd-Queue-Id: 1A7D3207909
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72747-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.ibm.com:mid];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[mjrosato@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

On 3/3/26 8:46 AM, Janosch Frank wrote:
> This test tries to setup routes which have address + offset
> combinations which cross a page.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---

LGTM, verified half of these tests fail without the first patch from this series; all pass once it is applied.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>


>  tools/testing/selftests/kvm/Makefile.kvm      |  1 +
>  .../testing/selftests/kvm/s390/irq_routing.c  | 75 +++++++++++++++++++
>  2 files changed, 76 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/s390/irq_routing.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index fdec90e85467..271cbb63af36 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -205,6 +205,7 @@ TEST_GEN_PROGS_s390 += s390/ucontrol_test
>  TEST_GEN_PROGS_s390 += s390/user_operexec
>  TEST_GEN_PROGS_s390 += s390/keyop
>  TEST_GEN_PROGS_s390 += rseq_test
> +TEST_GEN_PROGS_s390 += s390/irq_routing
>  
>  TEST_GEN_PROGS_riscv = $(TEST_GEN_PROGS_COMMON)
>  TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
> diff --git a/tools/testing/selftests/kvm/s390/irq_routing.c b/tools/testing/selftests/kvm/s390/irq_routing.c
> new file mode 100644
> index 000000000000..7819a0af19a8
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/s390/irq_routing.c
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * IRQ routing offset tests.
> + *
> + * Copyright IBM Corp. 2026
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "kselftest.h"
> +#include "ucall_common.h"
> +
> +extern char guest_code[];
> +asm("guest_code:\n"
> +    "diag %r0,%r0,0\n"
> +    "j .\n");
> +
> +static void test(void)
> +{
> +	struct kvm_irq_routing *routing;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	vm_paddr_t mem;
> +	int ret;
> +
> +	struct kvm_irq_routing_entry ue = {
> +		.type = KVM_IRQ_ROUTING_S390_ADAPTER,
> +		.gsi = 1,
> +	};
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	mem = vm_phy_pages_alloc(vm, 2, 4096 * 42, 0);
> +
> +	routing = kvm_gsi_routing_create();
> +	routing->nr = 1;
> +	routing->entries[0] = ue;
> +	routing->entries[0].u.adapter.summary_addr = (uintptr_t)mem;
> +	routing->entries[0].u.adapter.ind_addr = (uintptr_t)mem;
> +
> +	routing->entries[0].u.adapter.summary_offset = 4096 * 8;
> +	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
> +	ksft_test_result(ret == -1 && errno == EINVAL, "summary offset outside of page\n");
> +
> +	routing->entries[0].u.adapter.summary_offset -= 4;
> +	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
> +	ksft_test_result(ret == 0, "summary offset inside of page\n");
> +
> +	routing->entries[0].u.adapter.ind_offset = 4096 * 8;
> +	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
> +	ksft_test_result(ret == -1 && errno == EINVAL, "ind offset outside of page\n");
> +
> +	routing->entries[0].u.adapter.ind_offset -= 4;
> +	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
> +	ksft_test_result(ret == 0, "ind offset inside of page\n");
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_IRQ_ROUTING));
> +
> +	ksft_print_header();
> +	ksft_set_plan(4);
> +	test();
> +
> +	ksft_finished();	/* Print results and exit() accordingly */
> +}


