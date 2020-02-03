Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192D71506E3
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgBCNUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51920 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728353AbgBCNUU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:20 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DEifJ056810
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:19 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxkn2hek1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:19 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DF2Lk057965
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:19 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxkn2heht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:19 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DKFSi008702;
        Mon, 3 Feb 2020 13:20:17 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 2xw0y5s096-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:17 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DKFji35193114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:16 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D199B28065;
        Mon,  3 Feb 2020 13:20:15 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD1FB28071;
        Mon,  3 Feb 2020 13:20:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:15 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 29/37] DOCUMENTATION: protvirt: Diag 308 IPL
Date:   Mon,  3 Feb 2020 08:19:49 -0500
Message-Id: <20200203131957.383915-30-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Description of changes that are necessary to move a KVM VM into
Protected Virtualization mode.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/s390-pv-boot.rst | 64 +++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst

diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
new file mode 100644
index 000000000000..431cd5d7f686
--- /dev/null
+++ b/Documentation/virt/kvm/s390-pv-boot.rst
@@ -0,0 +1,64 @@
+.. SPDX-License-Identifier: GPL-2.0
+=========================
+Boot/IPL of Protected VMs
+=========================
+
+Summary
+-------
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
+Diag308
+-------
+This diagnose instruction is the basis for VM IPL. The VM can set and
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
+* List of Components composed of
+   * AES-XTS Tweak prefix
+   * Origin
+   * Size
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
2.24.0

