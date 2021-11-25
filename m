Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A9F45DCB1
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 15:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354021AbhKYOw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 09:52:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1355935AbhKYOux (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 09:50:53 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APCLqEm026607;
        Thu, 25 Nov 2021 14:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PX0YUOjdddJRBuo9d+YGvoLlYtMwaXGutqMR/DdlXEo=;
 b=pBo4Oq9IxcJpqMXrmpw9n1jdP7SMed8cohH39FV/+oxp0/bpIlJccYp3z/YJgJjz4TBG
 0T3r9+hTJ5Y+Hpr/22e+mgEm71Pu5uKJQGPJ2G9cj47vTrKE1DmNrVvFGB8Aqmb3YMLr
 j2FRIwrawREcpO+tDm3LmV1tgUQzGUww3TtY1ac8dFP03hZRpLGr64yYdtmSH0RmtsFL
 USydfa+jXezDNKvpaB8eLKaWbN6Ka31zSzGyUKCHtPUsBT4ek18wqQ1r7Lum9R5B78Ed
 cO1zPQQLCA9XgB9q1xBJaxuqomJ6CZJjyopNHbavuqLjhphX/x6hoKvGk7tV0042A2SS SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cjae7ax4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 14:47:41 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1APEQFfb012615;
        Thu, 25 Nov 2021 14:47:40 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cjae7ax44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 14:47:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1APEgi2r025564;
        Thu, 25 Nov 2021 14:47:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3cerna22as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 14:47:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1APElZf532112958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 14:47:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A801342054;
        Thu, 25 Nov 2021 14:47:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EC3942041;
        Thu, 25 Nov 2021 14:47:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Nov 2021 14:47:35 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH] s390x: Add strict mode to specification exception interpretation test
Date:   Thu, 25 Nov 2021 15:47:26 +0100
Message-Id: <20211125144726.1414645-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <82750b44-6246-3f3c-4562-3d64d7378448@redhat.com>
References: <82750b44-6246-3f3c-4562-3d64d7378448@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ScLhlVQYLY7BjznejuSZj41a3_7IlX68
X-Proofpoint-ORIG-GUID: rLWx__xJOv5pvla7lGA2CclZXAXMO01C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_05,2021-11-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 impostorscore=0 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111250078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While specification exception interpretation is not required to occur,
it can be useful for automatic regression testing to fail the test if it
does not occur.
Add a `--strict` argument to enable this.
`--strict` takes a list of machine types (as reported by STIDP)
for which to enable strict mode, for example
`--strict 8562,8561,3907,3906,2965,2964`
will enable it for models z15 - z13.
Alternatively, strict mode can be enabled for all but the listed machine
types by prefixing the list with a `!`, for example
`--strict !1090,1091,2064,2066,2084,2086,2094,2096,2097,2098,2817,2818,2827,2828`
will enable it for z/Architecture models except those older than z13.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---

Apparently my message with inline patch did not make it to the mailing
list for some reason, so here's the patch again.

 s390x/spec_ex-sie.c | 59 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 6 deletions(-)

diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index 5dea411..9a063f9 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -7,6 +7,7 @@
  * specification exception interpretation is off/on.
  */
 #include <libcflat.h>
+#include <stdlib.h>
 #include <sclp.h>
 #include <asm/page.h>
 #include <asm/arch_def.h>
@@ -36,7 +37,7 @@ static void reset_guest(void)
 	vm.sblk->icptcode = 0;
 }
 
-static void test_spec_ex_sie(void)
+static void test_spec_ex_sie(bool strict)
 {
 	setup_guest();
 
@@ -61,14 +62,60 @@ static void test_spec_ex_sie(void)
 	report(vm.sblk->icptcode == ICPT_PROGI
 	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
 	       "Received specification exception intercept");
-	if (vm.sblk->gpsw.addr == 0xdeadbeee)
-		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
-	else
-		report_info("Did not interpret initial exception");
+	{
+		const char *msg;
+
+		msg = "Interpreted initial exception, intercepted invalid program new PSW exception";
+		if (strict)
+			report(vm.sblk->gpsw.addr == 0xdeadbeee, msg);
+		else if (vm.sblk->gpsw.addr == 0xdeadbeee)
+			report_info(msg);
+		else
+			report_info("Did not interpret initial exception");
+	}
 	report_prefix_pop();
 	report_prefix_pop();
 }
 
+static bool parse_strict(char **argv)
+{
+	uint16_t machine_id;
+	char *list;
+	bool ret;
+
+	if (!*argv)
+		return false;
+	if (strcmp("--strict", *argv))
+		return false;
+
+	machine_id = get_machine_id();
+	list = argv[1];
+	if (!list) {
+		printf("No argument to --strict, ignoring\n");
+		return false;
+	}
+	if (list[0] == '!') {
+		ret = true;
+		list++;
+	} else
+		ret = false;
+	while (true) {
+		long input = 0;
+
+		if (strlen(list) == 0)
+			return ret;
+		input = strtol(list, &list, 16);
+		if (*list == ',')
+			list++;
+		else if (*list != '\0')
+			break;
+		if (input == machine_id)
+			return !ret;
+	}
+	printf("Invalid --strict argument \"%s\", ignoring\n", list);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
 	if (!sclp_facilities.has_sief2) {
@@ -76,7 +123,7 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	test_spec_ex_sie();
+	test_spec_ex_sie(parse_strict(argv + 1));
 out:
 	return report_summary();
 }
-- 
2.31.1

