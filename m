Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2FB3E41D3
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 10:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhHIItp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 04:49:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234059AbhHIIt1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 04:49:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1798XfYc125814;
        Mon, 9 Aug 2021 04:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=VR/Nrxf0VCY2lgTzvl5UWhJQodkU0Z/7KGYUvleT39c=;
 b=U/Et+s56crdDxndsGq/LT4GiMSLH3/M1uzVx4kd4E+RBvrfE4IExdRMOMJaoHNduT/PB
 LSvpg6YhllTkiuBSRhnasq2Cohrse1VjgLjzznTzBeaD0kUz4iy/4an7obpXFa2CwIlH
 r8GoLsPdD6FxvW+wzKyRfqHYLrRXk+On8ubMLxZkZS7Gzwf8haRTp+NQ/Y8HIPmbTcSy
 canRBJ9hMFmVTT5eskScvQtSjqTKnn/iN8RDh4vTFqIxK6oYyhGLGDDOuq5JTt8J/Q8Y
 BkLUe825u/ElUzezR9p4t/zq9dvIdg5c3IygQzhz+AqN5RR8FxCGpf9Dz18A1YJk86N/ Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa74j2fe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:04 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1798YiaC130418;
        Mon, 9 Aug 2021 04:49:04 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa74j2fdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:04 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798ks6x014969;
        Mon, 9 Aug 2021 08:49:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3a9ht8k9jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:49:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798mw1C55312794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:48:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EDEA4204B;
        Mon,  9 Aug 2021 08:48:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3C6142045;
        Mon,  9 Aug 2021 08:48:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:48:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 4/4] s390x: Topology: checking Configuration Topology Information
Date:   Mon,  9 Aug 2021 10:48:54 +0200
Message-Id: <1628498934-20735-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hiuOa-pQWKTgjvnfYq2aJm1y7rgOL3Uu
X-Proofpoint-GUID: dcnfWGNfpYVrqlUA-gDHcAt92GFyhYBZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

STSI with function code 15 is used to store the CPU configuration
topology.

We check if the topology stored is coherent with the QEMU -smp
parameters.
The current check is done on the number of CPUs, the maximum number
of CPUs, the number of sockets and the number of cores per sockets.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/topology.c    | 207 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   1 +
 2 files changed, 208 insertions(+)

diff --git a/s390x/topology.c b/s390x/topology.c
index 4146189a..1eb463fd 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -19,6 +19,51 @@
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 int machine_level;
 int mnest;
+static long max_cpus;
+static long cores;
+static long sockets;
+static long books;
+static long drawers;
+static long nodes;
+static long ncpus;
+
+struct topology_core {
+	unsigned char nl;
+	unsigned char reserved0[3];
+	unsigned char :5;
+	unsigned char d:1;
+	unsigned char pp:2;
+	unsigned char type;
+	unsigned short origin;
+	unsigned long mask;
+};
+
+struct topology_container {
+	unsigned char nl;
+	unsigned char reserved[6];
+	unsigned char id;
+};
+
+union topology_entry {
+	unsigned char nl;
+	struct topology_core cpu;
+	struct topology_container container;
+};
+
+struct sysinfo_15_1_x {
+	unsigned char reserved0[2];
+	unsigned short length;
+	unsigned char mag6;
+	unsigned char mag5;
+	unsigned char mag4;
+	unsigned char mag3;
+	unsigned char mag2;
+	unsigned char mag1;
+	unsigned char reserved1;
+	unsigned char mnest;
+	unsigned char reserved2[4];
+	union topology_entry tle[0];
+};
 
 #define PTF_HORIZONTAL	0
 #define PTF_VERTICAL	1
@@ -70,9 +115,170 @@ static void test_ptf(void)
 	report_prefix_pop();
 }
 
+static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info)
+{
+	struct topology_container *tc, *end;
+	struct topology_core *cpus;
+	int nb_nl0 = 0, nb_nl1 = 0, nb_nl2 = 0, nb_nl3 = 0;
+
+	if (mnest > 5)
+		report(info->mag6 == 0, "topology level 6");
+	if (mnest > 4)
+		report(info->mag5 == nodes, "Maximum number of nodes");
+	if (mnest > 3)
+		report(info->mag4 == drawers, "Maximum number of drawers");
+	if (mnest > 2)
+		report(info->mag3 == books, "Maximum number of book");
+
+	/* Both levels 2 and 1 are always valid */
+	report(info->mag2 == sockets, "Maximum number of sockets");
+	report(info->mag1 == cores, "Maximum number of cores");
+
+	tc = (void *)&info->tle[0];
+	end = (struct topology_container *)((unsigned long)info + info->length);
+
+	while (tc < end) {
+		switch (tc->nl) {
+		case 3:
+			report_info("drawer: %d %d", tc->nl, tc->id);
+			nb_nl3++;
+			break;
+		case 2:
+			report_info("book  : %d %d", tc->nl, tc->id);
+			nb_nl2++;
+			break;
+		case 1:
+			report_info("socket: %d %d", tc->nl, tc->id);
+			nb_nl1++;
+			break;
+		case 0:
+			cpus = (struct topology_core *) tc;
+			report_info("cpu type %02x  d: %d pp: %d", cpus->type, cpus->d, cpus->pp);
+			report_info("origin : %04x mask %016lx", cpus->origin, cpus->mask);
+			tc++;
+			nb_nl0++;
+			break;
+		default:
+			report_abort("Unexpected TL Entry: tle->nl: %d", tc->nl);
+			return;
+		}
+		tc++;
+	}
+	/*
+	 * As we accept only 1 type of CPU, and only horizontal and dedicated CPUs
+	 * We expect max_cpus / cores CPU entries
+	 */
+	report(nb_nl0 ==  (1 + (ncpus - 1) / cores),
+			  "Check count of cores: %d %ld", nb_nl0, ncpus / cores);
+	/* We expect the same count of sockets and CPU entries */
+	report(nb_nl1 ==  nb_nl0, "Check count of sockets");
+	if (mnest > 2)
+		report(nb_nl2 == nb_nl1 / sockets, "Checks count of books");
+	if (mnest > 3)
+		report(nb_nl3 == nb_nl2 / books, "Checks count of drawers");
+}
+
+static void test_stsi(void)
+{
+	int ret;
+
+	report_info("VM Level: %ld", stsi_get_fc(pagebuf));
+
+	mnest = sclp_get_stsi_parm();
+	/* If the STSI parm is 0, the maximum MNEST for STSI is 2 */
+	if (!mnest)
+		mnest = 2;
+	report_info("SCLP MNEST: %d", mnest);
+
+	ret = sclp_get_cpu_num();
+	report_info("SCLP CPU  : %d", ret);
+
+	ret = stsi(pagebuf, 15, 1, 2);
+	report(!ret, "valid stsi 15.1.2");
+	if (!ret)
+		check_sysinfo_15_1_x((struct sysinfo_15_1_x *)pagebuf);
+	else
+		report_info(" ret: %d", ret);
+
+	if (mnest < 3) {
+		report(stsi(pagebuf, 15, 1, 3) == 3, "invalid stsi 15.1.3");
+	} else {
+		report(stsi(pagebuf, 15, 1, 3) == 0, "valid stsi 15.1.3");
+		check_sysinfo_15_1_x((struct sysinfo_15_1_x *)pagebuf);
+	}
+
+	if (mnest < 4) {
+		report(stsi(pagebuf, 15, 1, 4) == 3, "invalid stsi 15.1.4");
+	} else {
+		report(stsi(pagebuf, 15, 1, 4) == 0, "valid stsi 15.1.4");
+		check_sysinfo_15_1_x((struct sysinfo_15_1_x *)pagebuf);
+	}
+
+	if (mnest < 5) {
+		report(stsi(pagebuf, 15, 1, 5) == 3, "invalid stsi 15.1.5");
+	} else {
+		report(stsi(pagebuf, 15, 1, 5) == 0, "valid stsi 15.1.5");
+		check_sysinfo_15_1_x((struct sysinfo_15_1_x *)pagebuf);
+	}
+
+	if (mnest < 6) {
+		report(stsi(pagebuf, 15, 1, 6) == 3, "invalid stsi 15.1.6");
+	} else {
+		report(stsi(pagebuf, 15, 1, 6) == 0, "valid stsi 15.1.6");
+		check_sysinfo_15_1_x((struct sysinfo_15_1_x *)pagebuf);
+	}
+}
+
+static void parse_topology_args(int argc, char **argv)
+{
+	int i;
+
+	for (i = 1; i < argc; i++) {
+		if (!strcmp("-c", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-c (cores) needs a parameter");
+			cores = atol(argv[i]);
+		} else if (!strcmp("-s", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-s (sockets) needs a parameter");
+			sockets = atol(argv[i]);
+		} else if (!strcmp("-b", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-b (books) needs a parameter");
+			books = atol(argv[i]);
+		} else if (!strcmp("-d", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-d (drawers) needs a parameter");
+			drawers = atol(argv[i]);
+		} else if (!strcmp("-n", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-n (nodes) needs a parameter");
+			nodes = atol(argv[i]);
+		}
+	}
+	if (!cores)
+		cores = 1;
+	if (!sockets)
+		sockets = 1;
+	if (!books)
+		books = 1;
+	if (!drawers)
+		drawers = 1;
+	if (!nodes)
+		nodes = 1;
+	max_cpus = cores * sockets * books * drawers * nodes;
+	ncpus = smp_query_num_cpus();
+}
+
 int main(int argc, char *argv[])
 {
 	report_prefix_push("stsi");
+	parse_topology_args(argc, argv);
 
 	if (!test_facility(11)) {
 		report_skip("Topology facility not present");
@@ -82,6 +288,7 @@ int main(int argc, char *argv[])
 	report_info("Machine level %ld", stsi_get_fc(pagebuf));
 
 	test_ptf();
+	test_stsi();
 end:
 	return report_summary();
 }
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 0f84d279..390e8398 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -112,3 +112,4 @@ file = mvpg-sie.elf
 
 [topology]
 file = topology.elf
+extra_params=-smp 5,sockets=4,cores=4,maxcpus=16 -append "-n 5 -s 4 -c 4 -m 16"
-- 
2.25.1

