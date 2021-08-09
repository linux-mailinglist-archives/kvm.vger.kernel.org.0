Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C05F3E43D3
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 12:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhHIKWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 06:22:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234439AbhHIKWs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 06:22:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179A3rfm042896;
        Mon, 9 Aug 2021 06:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eTr0pdBcD0hN9WUoXPvd07TFA2GXsju/lTwKF0TUGi8=;
 b=ivZJShNUDxWOSF+umj/umnokyXEozn+lQ/M7a6cIe1vFFa7aRHi8/fy0iUVHEkqPOy3a
 Fpd9DefjJwe5OwS7WShzB1cq1/cwMnqJ6hApBMXyKbDkfbdrd+d7NXmR/TwVL5GHnFWV
 Sv05BL2q/pl1iNpQfIFEZFc3nDL3XqGAONjSEQ74jEmYxZNqcC8r1sZZSWKtZdsSTnfE
 foo7fej0HTPxSQ/U3yLFpwjjcFi9wbxC6do+4EbYNV3NNHGrEuHZMmMeQxv2unKhPw+j
 z4UWUmkgeZ/KIL7JW6XiE7wsH4hNRrlX99ENiYQgAZBN90Wj/1h50/aX5NQfboFquAaN 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab1j81j8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:22:28 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179A4Qc4046269;
        Mon, 9 Aug 2021 06:22:27 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab1j81j89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:22:27 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179AC6et016900;
        Mon, 9 Aug 2021 10:22:25 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8us7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:22:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179AMLVb55378414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 10:22:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2ECA52051;
        Mon,  9 Aug 2021 10:22:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.223])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 714A752065;
        Mon,  9 Aug 2021 10:22:21 +0000 (GMT)
Date:   Mon, 9 Aug 2021 12:22:12 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: Topology: checking
 Configuration Topology Information
Message-ID: <20210809122212.6dbaafea@p-imbrenda>
In-Reply-To: <1628498934-20735-5-git-send-email-pmorel@linux.ibm.com>
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
        <1628498934-20735-5-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n8C-wM5mqcFX3bKQG68lTglYa5Qp5o6y
X-Proofpoint-ORIG-GUID: pRcYzyVqYbjUrKwbpkVz0vgLiH2GMZKl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_03:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 Aug 2021 10:48:54 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> STSI with function code 15 is used to store the CPU configuration
> topology.
> 
> We check if the topology stored is coherent with the QEMU -smp
> parameters.
> The current check is done on the number of CPUs, the maximum number
> of CPUs, the number of sockets and the number of cores per sockets.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/topology.c    | 207
> ++++++++++++++++++++++++++++++++++++++++++++ s390x/unittests.cfg |
> 1 + 2 files changed, 208 insertions(+)
> 
> diff --git a/s390x/topology.c b/s390x/topology.c
> index 4146189a..1eb463fd 100644
> --- a/s390x/topology.c
> +++ b/s390x/topology.c
> @@ -19,6 +19,51 @@
>  static uint8_t pagebuf[PAGE_SIZE * 2]
> __attribute__((aligned(PAGE_SIZE * 2))); int machine_level;
>  int mnest;
> +static long max_cpus;
> +static long cores;
> +static long sockets;
> +static long books;
> +static long drawers;
> +static long nodes;
> +static long ncpus;
> +
> +struct topology_core {
> +	unsigned char nl;
> +	unsigned char reserved0[3];
> +	unsigned char :5;
> +	unsigned char d:1;
> +	unsigned char pp:2;
> +	unsigned char type;
> +	unsigned short origin;
> +	unsigned long mask;
> +};
> +
> +struct topology_container {
> +	unsigned char nl;
> +	unsigned char reserved[6];
> +	unsigned char id;
> +};
> +
> +union topology_entry {
> +	unsigned char nl;
> +	struct topology_core cpu;
> +	struct topology_container container;
> +};
> +
> +struct sysinfo_15_1_x {
> +	unsigned char reserved0[2];
> +	unsigned short length;
> +	unsigned char mag6;
> +	unsigned char mag5;
> +	unsigned char mag4;
> +	unsigned char mag3;
> +	unsigned char mag2;
> +	unsigned char mag1;
> +	unsigned char reserved1;
> +	unsigned char mnest;
> +	unsigned char reserved2[4];
> +	union topology_entry tle[0];
> +};
>  
>  #define PTF_HORIZONTAL	0
>  #define PTF_VERTICAL	1
> @@ -70,9 +115,170 @@ static void test_ptf(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info)
> +{
> +	struct topology_container *tc, *end;
> +	struct topology_core *cpus;
> +	int nb_nl0 = 0, nb_nl1 = 0, nb_nl2 = 0, nb_nl3 = 0;
> +
> +	if (mnest > 5)
> +		report(info->mag6 == 0, "topology level 6");
> +	if (mnest > 4)
> +		report(info->mag5 == nodes, "Maximum number of
> nodes");
> +	if (mnest > 3)
> +		report(info->mag4 == drawers, "Maximum number of
> drawers");
> +	if (mnest > 2)
> +		report(info->mag3 == books, "Maximum number of
> book");

* books

> +	/* Both levels 2 and 1 are always valid */
> +	report(info->mag2 == sockets, "Maximum number of sockets");
> +	report(info->mag1 == cores, "Maximum number of cores");
> +
> +	tc = (void *)&info->tle[0];
> +	end = (struct topology_container *)((unsigned long)info +
> info->length); +
> +	while (tc < end) {
> +		switch (tc->nl) {
> +		case 3:
> +			report_info("drawer: %d %d", tc->nl, tc->id);
> +			nb_nl3++;
> +			break;
> +		case 2:
> +			report_info("book  : %d %d", tc->nl, tc->id);
> +			nb_nl2++;
> +			break;
> +		case 1:
> +			report_info("socket: %d %d", tc->nl, tc->id);
> +			nb_nl1++;
> +			break;
> +		case 0:
> +			cpus = (struct topology_core *) tc;
> +			report_info("cpu type %02x  d: %d pp: %d",
> cpus->type, cpus->d, cpus->pp);
> +			report_info("origin : %04x mask %016lx",
> cpus->origin, cpus->mask);
> +			tc++;
> +			nb_nl0++;
> +			break;
> +		default:
> +			report_abort("Unexpected TL Entry: tle->nl:
> %d", tc->nl);
> +			return;
> +		}
> +		tc++;
> +	}
> +	/*
> +	 * As we accept only 1 type of CPU, and only horizontal and
> dedicated CPUs
> +	 * We expect max_cpus / cores CPU entries
> +	 */
> +	report(nb_nl0 ==  (1 + (ncpus - 1) / cores),
> +			  "Check count of cores: %d %ld", nb_nl0,
> ncpus / cores);
> +	/* We expect the same count of sockets and CPU entries */
> +	report(nb_nl1 ==  nb_nl0, "Check count of sockets");
> +	if (mnest > 2)
> +		report(nb_nl2 == nb_nl1 / sockets, "Checks count of
> books");
> +	if (mnest > 3)
> +		report(nb_nl3 == nb_nl2 / books, "Checks count of
> drawers"); +}
> +
> +static void test_stsi(void)
> +{
> +	int ret;
> +
> +	report_info("VM Level: %ld", stsi_get_fc(pagebuf));
> +
> +	mnest = sclp_get_stsi_parm();
> +	/* If the STSI parm is 0, the maximum MNEST for STSI is 2 */
> +	if (!mnest)
> +		mnest = 2;
> +	report_info("SCLP MNEST: %d", mnest);
> +
> +	ret = sclp_get_cpu_num();
> +	report_info("SCLP CPU  : %d", ret);
> +
> +	ret = stsi(pagebuf, 15, 1, 2);
> +	report(!ret, "valid stsi 15.1.2");
> +	if (!ret)
> +		check_sysinfo_15_1_x((struct sysinfo_15_1_x
> *)pagebuf);
> +	else
> +		report_info(" ret: %d", ret);
> +
> +	if (mnest < 3) {
> +		report(stsi(pagebuf, 15, 1, 3) == 3, "invalid stsi
> 15.1.3");
> +	} else {
> +		report(stsi(pagebuf, 15, 1, 3) == 0, "valid stsi
> 15.1.3");
> +		check_sysinfo_15_1_x((struct sysinfo_15_1_x
> *)pagebuf);
> +	}
> +
> +	if (mnest < 4) {
> +		report(stsi(pagebuf, 15, 1, 4) == 3, "invalid stsi
> 15.1.4");
> +	} else {
> +		report(stsi(pagebuf, 15, 1, 4) == 0, "valid stsi
> 15.1.4");
> +		check_sysinfo_15_1_x((struct sysinfo_15_1_x
> *)pagebuf);
> +	}
> +
> +	if (mnest < 5) {
> +		report(stsi(pagebuf, 15, 1, 5) == 3, "invalid stsi
> 15.1.5");
> +	} else {
> +		report(stsi(pagebuf, 15, 1, 5) == 0, "valid stsi
> 15.1.5");
> +		check_sysinfo_15_1_x((struct sysinfo_15_1_x
> *)pagebuf);
> +	}
> +
> +	if (mnest < 6) {
> +		report(stsi(pagebuf, 15, 1, 6) == 3, "invalid stsi
> 15.1.6");
> +	} else {
> +		report(stsi(pagebuf, 15, 1, 6) == 0, "valid stsi
> 15.1.6");
> +		check_sysinfo_15_1_x((struct sysinfo_15_1_x
> *)pagebuf);
> +	}
> +}
> +
> +static void parse_topology_args(int argc, char **argv)
> +{
> +	int i;
> +
> +	for (i = 1; i < argc; i++) {
> +		if (!strcmp("-c", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-c (cores) needs a
> parameter");
> +			cores = atol(argv[i]);
> +		} else if (!strcmp("-s", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-s (sockets) needs a
> parameter");
> +			sockets = atol(argv[i]);
> +		} else if (!strcmp("-b", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-b (books) needs a
> parameter");
> +			books = atol(argv[i]);
> +		} else if (!strcmp("-d", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-d (drawers) needs a
> parameter");
> +			drawers = atol(argv[i]);
> +		} else if (!strcmp("-n", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-n (nodes) needs a
> parameter");
> +			nodes = atol(argv[i]);
> +		}
> +	}
> +	if (!cores)
> +		cores = 1;
> +	if (!sockets)
> +		sockets = 1;
> +	if (!books)
> +		books = 1;
> +	if (!drawers)
> +		drawers = 1;
> +	if (!nodes)
> +		nodes = 1;
> +	max_cpus = cores * sockets * books * drawers * nodes;
> +	ncpus = smp_query_num_cpus();
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	report_prefix_push("stsi");
> +	parse_topology_args(argc, argv);
>  
>  	if (!test_facility(11)) {
>  		report_skip("Topology facility not present");
> @@ -82,6 +288,7 @@ int main(int argc, char *argv[])
>  	report_info("Machine level %ld", stsi_get_fc(pagebuf));
>  
>  	test_ptf();
> +	test_stsi();
>  end:
>  	return report_summary();
>  }
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 0f84d279..390e8398 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -112,3 +112,4 @@ file = mvpg-sie.elf
>  
>  [topology]
>  file = topology.elf
> +extra_params=-smp 5,sockets=4,cores=4,maxcpus=16 -append "-n 5 -s 4
> -c 4 -m 16"

