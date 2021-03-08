Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FA43310E6
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhCHOeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:34:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhCHOdv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:51 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EXlRa060024;
        Mon, 8 Mar 2021 09:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h2TDYKqF8dfjLLaJLaS6uyQrnuh7xU+pxWOgbD0IBTU=;
 b=ZU/4u4qfGkeXbg/rs69dz/u+mw04EmJVB3mgOrHU9hWWnBy35aKFmjprtdItJRFt810H
 NcvfKIjQU4V6PfcWcOia3D/BMEB9fUJu+hSlgaoNmHGDMJWZyqqrYH1DRHL09ywaMU/B
 PafOV5fSDArFXMQH9/jTweKAtjE5m8qutpt2i/T5aVaDvci7TXCYJ5B/RasfksuUXUEE
 NegbEDXbKj74hXRGnKTTRvBdDAUR4qD1VCqflNTCRm+HrSe28i/fDiOlVRn3gbyTC4Zk
 UO9K+L+klNWjYPK7r+J+5b7Sfkv/4FDDPgspVIIP8D+vnzmDH8OmwTTSfg0+conkUZrT Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nqbg4ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:51 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXmRC060084;
        Mon, 8 Mar 2021 09:33:50 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nqbg4w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:50 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EWLrq010708;
        Mon, 8 Mar 2021 14:33:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3741c8901y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXOHv17826166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93EFBA4051;
        Mon,  8 Mar 2021 14:33:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F51EA4053;
        Mon,  8 Mar 2021 14:33:39 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 05/16] Fix the length in the stsi check for the VM name
Date:   Mon,  8 Mar 2021 15:31:36 +0100
Message-Id: <20210308143147.64755-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

sizeof(somepointer) results in the size of the pointer, i.e. 8 on a
64-bit system, so the

 memcmp(data->ext_names[0], vm_name_ext, sizeof(vm_name_ext))

only compared the first 8 characters of the VM name here. Switch
to a proper array to get the sizeof() right.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20210209155705.67601-1-thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/stsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index 4109b8d4..87d48047 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -106,7 +106,7 @@ static void test_3_2_2(void)
 				 0x00, 0x03 };
 	/* EBCDIC for "KVM/" */
 	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
-	const char *vm_name_ext = "kvm-unit-test";
+	const char vm_name_ext[] = "kvm-unit-test";
 	struct stsi_322 *data = (void *)pagebuf;
 
 	report_prefix_push("3.2.2");
-- 
2.29.2

