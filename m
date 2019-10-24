Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F97E30E4
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733010AbfJXLmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726375AbfJXLmn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:43 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBbIWS098738
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:42 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vu95r52h3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:41 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:40 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:38 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBgaNw52887658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FD095204E;
        Thu, 24 Oct 2019 11:42:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A91E85204F;
        Thu, 24 Oct 2019 11:42:34 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 30/37] DOCUMENTATION: protvirt: Diag 308 IPL
Date:   Thu, 24 Oct 2019 07:40:52 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0016-0000-0000-000002BCC9BA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0017-0000-0000-0000331E0E55
Message-Id: <20191024114059.102802-31-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=768 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Description of changes that are necessary to move a KVM VM into
Protected Virtualization mode.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virtual/kvm/s390-pv-boot.txt | 62 ++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/virtual/kvm/s390-pv-boot.txt

diff --git a/Documentation/virtual/kvm/s390-pv-boot.txt b/Documentation/virtual/kvm/s390-pv-boot.txt
new file mode 100644
index 000000000000..af883c928c08
--- /dev/null
+++ b/Documentation/virtual/kvm/s390-pv-boot.txt
@@ -0,0 +1,62 @@
+Boot/IPL of Protected VMs
+========================
+
+Summary:
+
+Protected VMs are encrypted while not running. On IPL a small
+plaintext bootloader is started which provides information about the
+encrypted components and necessary metadata to KVM to decrypt it.
+
+Based on this data, KVM will make the PV known to the Ultravisor and
+instruct it to secure its memory, decrypt the components and verify
+the data and address list hashes, to ensure integrity. Afterwards KVM
+can run the PV via SIE which the UV will intercept and execute on
+KVM's behalf.
+
+The switch into PV mode lets us load encrypted guest executables and
+data via every available method (network, dasd, scsi, direct kernel,
+...) without the need to change the boot process.
+
+
+Diag308:
+
+This diagnose instruction is the basis vor VM IPL. The VM can set and
+retrieve IPL information blocks, that specify the IPL method/devices
+and request VM memory and subsystem resets, as well as IPLs.
+
+For PVs this concept has been continued with new subcodes:
+
+Subcode 8: Set an IPL Information Block of type 5.
+Subcode 9: Store the saved block in guest memory
+Subcode 10: Move into Protected Virtualization mode
+
+The new PV load-device-specific-parameters field specifies all data,
+that is necessary to move into PV mode.
+
+* PV Header origin
+* PV Header length
+* List of Components composed of:
+  * AES-XTS Tweak prefix
+  * Origin
+  * Size
+
+The PV header contains the keys and hashes, which the UV will use to
+decrypt and verify the PV, as well as control flags and a start PSW.
+
+The components are for instance an encrypted kernel, kernel cmd and
+initrd. The components are decrypted by the UV.
+
+All non-decrypted data of the non-PV guest instance are zero on first
+access of the PV.
+
+
+When running in a protected mode some subcodes will result in
+exceptions or return error codes.
+
+Subcodes 4 and 7 will result in specification exceptions.
+When removing a secure VM, the UV will clear all memory, so we can't
+have non-clearing IPL subcodes.
+
+Subcodes 8, 9, 10 will result in specification exceptions.
+Re-IPL into a protected mode is only possible via a detour into non
+protected mode.
-- 
2.20.1

