Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E009148AE73
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 14:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbiAKNaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 08:30:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240497AbiAKNav (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 08:30:51 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BDErdL023344;
        Tue, 11 Jan 2022 13:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DFhafjxSGA6qB7sGFq7dfNi6WXT4SPXn3pNOq0DoEB8=;
 b=p7MNbcZLS24TpW8HuqDE2J3EOkfRHiuff59CoqTxpVZ5Xuu9TTFitD6+1f0S19sAQMGH
 RDOsM4AMKyZsIFc/Q2QMpkgOKUU53nD30GKU+0BLE2y6sE4N7Zgkudw4GhxpGKAmeggh
 VIz+L6P7siZO/s1szgVpx9E94E2Qmr9p5vPxFKMY0mGIVpCJJ9JPgcX/cfTgqSr4FOn7
 wZmArzxkkeJQnGZkmQulAX0Rr9ozdTO8J77Aue8jP5CoAQubGscWXVlBdq4vOQYd3Nqf
 ZODpFnBn88nInVzOA5tdekncqTM/0Qbfxsrid2W6B47T+ol5UVCKdGnGySawJn3RgF06 Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh6u15jm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:30:51 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BDCUgt026474;
        Tue, 11 Jan 2022 13:30:51 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh6u15jjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:30:50 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BDRjLI007817;
        Tue, 11 Jan 2022 13:30:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhj195x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:30:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BDUg7e47579494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 13:30:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 782C811C052;
        Tue, 11 Jan 2022 13:30:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1268111C05B;
        Tue, 11 Jan 2022 13:30:42 +0000 (GMT)
Received: from [9.145.189.100] (unknown [9.145.189.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 13:30:42 +0000 (GMT)
Message-ID: <45dea0fb-5605-5f98-74c7-d68f7841f1b6@linux.ibm.com>
Date:   Tue, 11 Jan 2022 14:30:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
 <20220110133755.22238-5-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/4] s390x: topology: Checking
 Configuration Topology Information
In-Reply-To: <20220110133755.22238-5-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ho2r89Hc_hssX2kreRYAaxOBMB2y00ES
X-Proofpoint-ORIG-GUID: ksZ4-G2W3d4odVluSwM3_ecyQguEXuxV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 spamscore=0
 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/22 14:37, Pierre Morel wrote:
> STSI with function code 15 is used to store the CPU configuration
> topology.
> 
> We check :
> - if the topology stored is coherent between the QEMU -smp
>    parameters and kernel parameters.
> - the number of CPUs
> - the maximum number of CPUs
> - the number of containers of each levels for every STSI(15.1.x)
>    instruction allowed by the machine.

The full review of this will take some time.

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/stsi.h    |  44 +++++++++
>   s390x/topology.c    | 231 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   1 +
>   3 files changed, 276 insertions(+)
> 
> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
> index 02cc94a6..e3fc7ac0 100644
> --- a/lib/s390x/stsi.h
> +++ b/lib/s390x/stsi.h
> @@ -29,4 +29,48 @@ struct sysinfo_3_2_2 {
>   	uint8_t ext_names[8][256];
>   };
>   
> +struct topology_core {
> +	uint8_t nl;
> +	uint8_t reserved1[3];
> +	uint8_t reserved4:5;
> +	uint8_t d:1;
> +	uint8_t pp:2;
> +	uint8_t type;
> +	uint16_t origin;
> +	uint64_t mask;
> +};
> +
> +struct topology_container {
> +	uint8_t nl;
> +	uint8_t reserved[6];
> +	uint8_t id;
> +};
> +
> +union topology_entry {
> +	uint8_t nl;
> +	struct topology_core cpu;
> +	struct topology_container container;
> +};
> +
> +#define CPU_TOPOLOGY_MAX_LEVEL 6
> +struct sysinfo_15_1_x {
> +	uint8_t reserved0[2];
> +	uint16_t length;
> +	uint8_t mag[CPU_TOPOLOGY_MAX_LEVEL];
> +	uint8_t reserved10;

reserved0a?

> +	uint8_t mnest;
> +	uint8_t reserved12[4];

reserved0c?

> +	union topology_entry tle[0];
> +};
> +
> +static inline int cpus_in_tle_mask(uint64_t val)
> +{
> +	int i, n;
> +
> +	for (i = 0, n = 0; i < 64; i++, val >>= 1)
> +		if (val & 0x01)
> +			n++;
> +	return n;
> +}
> +
>   #endif  /* _S390X_STSI_H_ */
> diff --git a/s390x/topology.c b/s390x/topology.c
> index a227555e..d06e7c4d 100644
> --- a/s390x/topology.c
> +++ b/s390x/topology.c
> @@ -16,6 +16,15 @@
>   #include <smp.h>
>   #include <sclp.h>
>   #include <s390x/vm.h>
> +#include <s390x/stsi.h>
> +
> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
> +
> +static int max_nested_lvl;
> +static int number_of_cpus;
> +static int max_cpus = 1;
> +static int arch_topo_lvl[CPU_TOPOLOGY_MAX_LEVEL];	/* Topology level defined by architecture */
> +static int stsi_nested_lvl[CPU_TOPOLOGY_MAX_LEVEL];	/* Topology nested level reported in STSI */
>   
>   #define PTF_REQ_HORIZONTAL	0
>   #define PTF_REQ_VERTICAL	1
> @@ -83,11 +92,230 @@ end:
>   	report_prefix_pop();
>   }
>   
> +/*
> + * stsi_check_maxcpus
> + * @info: Pointer to the stsi information
> + *
> + * The product of the numbers of containers per level
> + * is the maximum number of CPU allowed by the machine.
> + */
> +static void stsi_check_maxcpus(struct sysinfo_15_1_x *info)
> +{
> +	int n, i;
> +
> +	report_prefix_push("maximum cpus");
> +
> +	for (i = 0, n = 1; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
> +		report_info("Mag%d: %d", CPU_TOPOLOGY_MAX_LEVEL - i, info->mag[i]);
> +		n *= info->mag[i] ? info->mag[i] : 1;
> +	}
> +	report(n == max_cpus, "Maximum CPUs %d expected %d", n, max_cpus);
> +
> +	report_prefix_pop();
> +}
> +
> +/*
> + * stsi_check_tle_coherency
> + * @info: Pointer to the stsi information
> + * @sel2: Topology level to check.
> + *
> + * We verify that we get the expected number of Topology List Entry
> + * containers for a specific level.
> + */
> +static void stsi_check_tle_coherency(struct sysinfo_15_1_x *info, int sel2)
> +{
> +	struct topology_container *tc, *end;
> +	struct topology_core *cpus;
> +	int n = 0;
> +	int i;
> +
> +	report_prefix_push("TLE coherency");
> +
> +	tc = (void *)&info->tle[0];

tc = &info->tle[0].container ?

> +	end = (struct topology_container *)((unsigned long)info + info->length);
> +
> +	for (i = 0; i < CPU_TOPOLOGY_MAX_LEVEL; i++)
> +		stsi_nested_lvl[i] = 0;
> +
> +	while (tc < end) {
> +		if (tc->nl > 5) {
> +			report_abort("Unexpected TL Entry: tle->nl: %d", tc->nl);
> +			return;
> +		}
> +		if (tc->nl == 0) {
> +			cpus = (struct topology_core *)tc;
> +			n += cpus_in_tle_mask(cpus->mask);
> +			report_info("cpu type %02x  d: %d pp: %d", cpus->type, cpus->d, cpus->pp);
> +			report_info("origin : %04x mask %016lx", cpus->origin, cpus->mask);
> +		}
> +
> +		stsi_nested_lvl[tc->nl]++;
> +		report_info("level %d: lvl: %d id: %d cnt: %d",
> +			    tc->nl, tc->nl, tc->id, stsi_nested_lvl[tc->nl]);
> +
> +		/* trick: CPU TLEs are twice the size of containers TLE */
> +		if (tc->nl == 0)
> +			tc++;
> +		tc++;
> +	}
> +	report(n == number_of_cpus, "Number of CPUs  : %d expect %d", n, number_of_cpus);
> +	/*
> +	 * For KVM we accept
> +	 * - only 1 type of CPU
> +	 * - only horizontal topology
> +	 * - only dedicated CPUs
> +	 * This leads to expect the number of entries of level 0 CPU
> +	 * Topology Level Entry (TLE) to be:
> +	 * 1 + (number_of_cpus - 1)  / arch_topo_lvl[0]
> +	 *
> +	 * For z/VM or LPAR this number can only be greater if different
> +	 * polarity, CPU types because there may be a nested level 0 CPU TLE
> +	 * for each of the CPU/polarity/sharing types in a level 1 container TLE.
> +	 */
> +	n =  (number_of_cpus - 1)  / arch_topo_lvl[0];
> +	report(stsi_nested_lvl[0] >=  n + 1,
> +	       "CPU Type TLE    : %d expect %d", stsi_nested_lvl[0], n + 1);
> +
> +	/* For each level found in STSI */
> +	for (i = 1; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
> +		/*
> +		 * For non QEMU/KVM hypervizor the concatanation of the levels

hypervisor

concatenation

> +		 * above level 1 are architecture dependent.
> +		 * Skip these checks.
> +		 */
> +		if (!vm_is_kvm() && sel2 != 2)
> +			continue;
> +
> +		/* For QEMU/KVM we expect a simple calculation */
> +		if (sel2 > i) {
> +			report(stsi_nested_lvl[i] ==  n + 1,
> +			       "Container TLE  %d: %d expect %d", i, stsi_nested_lvl[i], n + 1);
> +			n /= arch_topo_lvl[i];
> +		}
> +	}
> +
> +	report_prefix_pop();
> +}
> +
> +/*
> + * check_sysinfo_15_1_x
> + * @info: pointer to the STSI info structure
> + * @sel2: the selector giving the topology level to check
> + *
> + * Check if the validity of the STSI instruction and then
> + * calls specific checks on the information buffer.
> + */
> +static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
> +{
> +	int ret;
> +
> +	report_prefix_pushf("15_1_%d", sel2);
> +
> +	ret = stsi(pagebuf, 15, 1, sel2);
> +	if (max_nested_lvl >= sel2)
> +		report(!ret, "Valid stsi instruction");
> +	else
> +		report(ret, "Invalid stsi instruction");
> +	if (ret)
> +		goto end;
> +
> +	stsi_check_maxcpus(info);
> +	stsi_check_tle_coherency(info, sel2);
> +
> +end:
> +	report_prefix_pop();
> +}
> +
> +/*
> + * test_stsi
> + *
> + * Retrieves the maximum nested topology level supported by the architecture
> + * and the number of CPUs.
> + * Calls the checking for the STSI instruction in sel2 reverse level order
> + * from 6 (CPU_TOPOLOGY_MAX_LEVEL) to 2 to have the most interesting level,
> + * the one triggering a topology-change-report-pending condition, level 2,
> + * at the end of the report.
> + *
> + */
> +static void test_stsi(void)
> +{
> +	int sel2;
> +
> +	max_nested_lvl = sclp_get_stsi_parm();
> +	/* If the STSI parm is 0, the Maximum Nesting for STSI is 2 */
> +	if (!max_nested_lvl)
> +		max_nested_lvl = 2;
> +	report_info("SCLP maximum nested level : %d", max_nested_lvl);
> +
> +	number_of_cpus = sclp_get_cpu_num();
> +	report_info("SCLP number of CPU: %d", number_of_cpus);
> +
> +	/* STSI selector 2 can takes values between 2 and 6 */
> +	for (sel2 = 6; sel2 >= 2; sel2--)
> +		check_sysinfo_15_1_x((struct sysinfo_15_1_x *)pagebuf, sel2);
> +}
> +
> +/*
> + * parse_topology_args
> + * @argc: number of arguments
> + * @argv: argument array
> + *
> + * This function initialize the architecture topology levels
> + * which should be the same as the one provided by the hypervisor.
> + *
> + * We use the current names found in IBM/Z literature, Linux and QEMU:
> + * cores, sockets/packages, books, drawers and nodes to facilitate the
> + * human machine interface but store the result in a machine abstract
> + * array of architecture topology levels.
> + * Note that when QEMU uses socket as a name for the topology level 1
> + * Linux uses package or physical_package.
> + */
> +static void parse_topology_args(int argc, char **argv)
> +{
> +	int i;
> +
> +	for (i = 1; i < argc; i++) {
> +		if (!strcmp("-c", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-c (cores) needs a parameter");
> +			arch_topo_lvl[0] = atol(argv[i]);
> +		} else if (!strcmp("-s", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-s (sockets) needs a parameter");
> +			arch_topo_lvl[1] = atol(argv[i]);
> +		} else if (!strcmp("-b", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-b (books) needs a parameter");
> +			arch_topo_lvl[2] = atol(argv[i]);
> +		} else if (!strcmp("-d", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-d (drawers) needs a parameter");
> +			arch_topo_lvl[3] = atol(argv[i]);
> +		} else if (!strcmp("-n", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-n (nodes) needs a parameter");
> +			arch_topo_lvl[4] = atol(argv[i]);
> +		}
> +	}
> +
> +	for (i = 0; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
> +		if (!arch_topo_lvl[i])
> +			arch_topo_lvl[i] = 1;
> +		max_cpus *= arch_topo_lvl[i];
> +	}
> +}
> +
>   static struct {
>   	const char *name;
>   	void (*func)(void);
>   } tests[] = {
>   	{ "PTF", test_ptf},
> +	{ "STSI", test_stsi},
>   	{ NULL, NULL }
>   };
>   
> @@ -97,6 +325,8 @@ int main(int argc, char *argv[])
>   
>   	report_prefix_push("CPU Topology");
>   
> +	parse_topology_args(argc, argv);
> +
>   	if (!test_facility(11)) {
>   		report_skip("Topology facility not present");
>   		goto end;
> @@ -109,6 +339,7 @@ int main(int argc, char *argv[])
>   		tests[i].func();
>   		report_prefix_pop();
>   	}
> +
>   end:
>   	report_prefix_pop();
>   	return report_summary();
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index e2d3e6a5..bc19b5b6 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -125,3 +125,4 @@ extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -devi
>   
>   [topology]
>   file = topology.elf
> +extra_params=-smp 5,drawers=2,books=3,sockets=4,cores=4,maxcpus=16 -append "-d 2 -b 3 -s 4 -c 4"
> 

