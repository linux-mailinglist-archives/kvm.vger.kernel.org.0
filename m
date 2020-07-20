Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F56225CE5
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 12:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgGTKuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 06:50:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728200AbgGTKt7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 06:49:59 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KAWMJe023123;
        Mon, 20 Jul 2020 06:49:58 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32d7b7vnu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 06:49:58 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KAjldY062694;
        Mon, 20 Jul 2020 06:49:58 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32d7b7vntk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 06:49:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KAUZKY018846;
        Mon, 20 Jul 2020 10:49:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 32brq82jdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 10:49:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KAnr5O62062630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 10:49:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A00BEAE045;
        Mon, 20 Jul 2020 10:49:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DF01AE051;
        Mon, 20 Jul 2020 10:49:53 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.8.245])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 10:49:53 +0000 (GMT)
Date:   Mon, 20 Jul 2020 12:42:31 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
Message-ID: <20200720124231.1ce43261@ibm-vm>
In-Reply-To: <20200717145813.62573-3-frankja@linux.ibm.com>
References: <20200717145813.62573-1-frankja@linux.ibm.com>
        <20200717145813.62573-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_05:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Jul 2020 10:58:12 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> If a exception new psw mask contains a key a specification exception
> instead of a special operation exception is presented. Let's test
> that.
> 
> Also let's add the test to unittests.cfg so it is run more often.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/skrf.c        | 81
> +++++++++++++++++++++++++++++++++++++++++++++ s390x/unittests.cfg |
> 4 +++ 2 files changed, 85 insertions(+)
> 
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index 9cae589..9733412 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -15,6 +15,8 @@
>  #include <asm/page.h>
>  #include <asm/facility.h>
>  #include <asm/mem.h>
> +#include <asm/sigp.h>
> +#include <smp.h>
>  
>  static uint8_t pagebuf[PAGE_SIZE * 2]
> __attribute__((aligned(PAGE_SIZE * 2))); 
> @@ -106,6 +108,84 @@ static void test_tprot(void)
>  	report_prefix_pop();
>  }
>  
> +#include <asm-generic/barrier.h>
> +static int testflag = 0;
> +
> +static void wait_for_flag(void)
> +{
> +	while (!testflag)
> +		mb();
> +}
> +
> +static void set_flag(int val)
> +{
> +	mb();
> +	testflag = val;
> +	mb();
> +}
> +
> +static void ecall_cleanup(void)
> +{
> +	struct lowcore *lc = (void *)0x0;
> +
> +	lc->ext_new_psw.mask = 0x0000000180000000UL;
> +	lc->sw_int_crs[0] = 0x0000000000040000;
> +
> +	/*
> +	 * PGM old contains the ext new PSW, we need to clean it up,
> +	 * so we don't get a special oepration exception on the lpswe
> +	 * of pgm old.
> +	 */
> +	lc->pgm_old_psw.mask = 0x0000000180000000UL;
> +	lc->pgm_old_psw.addr = (unsigned long)wait_for_flag;
> +
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	set_flag(1);
> +}
> +
> +/* Set a key into the external new psw mask and open external call
> masks */ +static void ecall_setup(void)
> +{
> +	struct lowcore *lc = (void *)0x0;
> +	uint64_t mask;
> +
> +	register_pgm_int_func(ecall_cleanup);
> +	expect_pgm_int();
> +	/* Put a skey into the ext new psw */
> +	lc->ext_new_psw.mask = 0x00F0000180000000UL;
> +	/* Open up ext masks */
> +	ctl_set_bit(0, 13);
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +	/* Tell cpu 0 that we're ready */
> +	set_flag(1);
> +}
> +
> +static void test_exception_ext_new(void)
> +{
> +	struct psw psw = {
> +		.mask = extract_psw_mask(),
> +		.addr = (unsigned long)ecall_setup
> +	};
> +
> +	report_prefix_push("exception external new");
> +	if (smp_query_num_cpus() < 2) {
> +		report_skip("Need second cpu for exception external
> new test.");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	smp_cpu_setup(1, psw);
> +	wait_for_flag();
> +	set_flag(0);
> +
> +	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
> +	wait_for_flag();
> +	smp_cpu_stop(1);
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("skrf");
> @@ -121,6 +201,7 @@ int main(void)
>  	test_mvcos();
>  	test_spka();
>  	test_tprot();
> +	test_exception_ext_new();
>  
>  done:
>  	report_prefix_pop();
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 0f156af..b35269b 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -88,3 +88,7 @@ extra_params = -m 3G
>  [css]
>  file = css.elf
>  extra_params = -device virtio-net-ccw
> +
> +[skrf]
> +file = skrf.elf
> +smp = 2

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
