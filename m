Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8457340618
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhCRMuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:50:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230335AbhCRMud (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:50:33 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ICXamc076382;
        Thu, 18 Mar 2021 08:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0D8siYZFzGat4HBb3mnrcUNlFQA1Fll1siS2PdmJwQE=;
 b=pKykixkFBsJ5eZnA+YVi8X5XVWeZvQ/S5YIC51IT8WqMgUdjIecWxi6hLebJI9R7ogvn
 I+rhYcPRu+jHdvFjKwWDBrQFeuC23mscmRi1esjRg4qv4x5kVoexeTQ9gebdxkj02HDA
 /FCdDLeNiJ2+f+0Bi+jzN00MzU7HwKDlHtL3XmapGS8XYQklwGV5FrpCajBtpAyZ4PT2
 ScVB3e/E6QrIs2PbzCvrY7UMYiOaGCIPnTNqF1DiFfEcBauQ8MgwuJyAu+OCC6f4c0Ge
 9RiPk6nm8rDipa/OVmLrZYMwZw8sKd2J5kNbP1OxAgHMMp4NegdxmtC4Yb4NwmHCVbRI ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c6sf8sm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:50:32 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ICYYUf084519;
        Thu, 18 Mar 2021 08:50:32 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c6sf8sk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:50:31 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ICmMYL031719;
        Thu, 18 Mar 2021 12:50:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 378n18ahmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 12:50:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ICoAst24248612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 12:50:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BCADA404D;
        Thu, 18 Mar 2021 12:50:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FF3DA4055;
        Thu, 18 Mar 2021 12:50:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.61])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 12:50:25 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/3] configure: s390x: Check if the host key document exists
Date:   Thu, 18 Mar 2021 12:50:14 +0000
Message-Id: <20210318125015.45502-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318125015.45502-1-frankja@linux.ibm.com>
References: <20210318125015.45502-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_04:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'd rather have a readable error message than make failing the build
with cryptic errors.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 configure | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/configure b/configure
index cdcd34e9..4d4bb646 100755
--- a/configure
+++ b/configure
@@ -121,6 +121,11 @@ while [[ "$1" = -* ]]; do
     esac
 done
 
+if [ "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
+    echo "Host key document doesn't exist at the specified location."
+    exit 1
+fi
+
 if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
     echo "erratatxt: $erratatxt does not exist or is not a regular file"
     exit 1
-- 
2.27.0

