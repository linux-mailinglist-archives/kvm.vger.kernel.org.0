Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587312C237E
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 12:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732440AbgKXLBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 06:01:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732243AbgKXLBv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 06:01:51 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOAW7bM179577;
        Tue, 24 Nov 2020 06:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LZBPkChyo3/20UhougbKb9Te/JdSFl+s/zG6QHX7z8U=;
 b=FFC/r45L7ZnomqcM3AOy/4q8VvmLpe1o5ak4LCVAykOvMu74Xnvth2144VlmvDLdleX7
 DEcGehgggIyHE1sM5Px1/pY9uTtFFoX8DZvP46kU2HoTj4NICWsJByTc+8XED5t6rv/k
 ZiKml3eXVd6RyQkB5FJ3+jjViX2FijELvM7668M648KR71sK2cD3YZPMUeC/+6uBPoeX
 fq353oz6pTN9lagpmOWBHoDaMkW9MVWqPcK1yUBpBDCtAyLjoKYTeK5FEAEBWMfL4KwA
 pbsmveO5OT6P7btzEj1QdungSFkypOg4XQEtUdIucjBIMeOVNtvZ6XRHx7GQ6HsnOVbj FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rb0ysb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 06:01:35 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOAWRQA180968;
        Tue, 24 Nov 2020 06:01:34 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rb0ys80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 06:01:33 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOAr6kV017839;
        Tue, 24 Nov 2020 11:01:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 350cvrs0ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 11:01:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOB0Cdp11600570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 11:00:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E83DC4203F;
        Tue, 24 Nov 2020 11:00:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD8CE42059;
        Tue, 24 Nov 2020 11:00:08 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.32.189])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 11:00:08 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     mpe@ellerman.id.au, paulus@samba.org
Cc:     ravi.bangoria@linux.ibm.com, mikey@neuling.org, npiggin@gmail.com,
        leobras.c@gmail.com, pbonzini@redhat.com, christophe.leroy@c-s.fr,
        jniethe5@gmail.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 0/4] KVM: PPC: Power10 2nd DAWR enablement
Date:   Tue, 24 Nov 2020 16:29:49 +0530
Message-Id: <20201124105953.39325-1-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable p10 2nd DAWR feature for Book3S kvm guest. DAWR is a hypervisor
resource and thus H_SET_MODE hcall is used to set/unset it. A new case
H_SET_MODE_RESOURCE_SET_DAWR1 is introduced in H_SET_MODE hcall for
setting/unsetting 2nd DAWR. Also, new capability KVM_CAP_PPC_DAWR1 has
been added to query 2nd DAWR support via kvm ioctl.

This feature also needs to be enabled in Qemu to really use it. I'll
post Qemu patches once kvm patches get accepted.

v1: https://lore.kernel.org/r/20200723102058.312282-1-ravi.bangoria@linux.ibm.com

v1->v2:
 - patch #1: New patch
 - patch #2: Don't rename KVM_REG_PPC_DAWR, it's an uapi macro
 - patch #3: Increment HV_GUEST_STATE_VERSION
 - Split kvm and selftests patches into different series
 - Patches rebased to paulus/kvm-ppc-next (cf59eb13e151) + few
   other watchpoint patches which are yet to be merged in
   paulus/kvm-ppc-next.

Ravi Bangoria (4):
  KVM: PPC: Allow nested guest creation when L0 hv_guest_state > L1
  KVM: PPC: Rename current DAWR macros and variables
  KVM: PPC: Add infrastructure to support 2nd DAWR
  KVM: PPC: Introduce new capability for 2nd DAWR

 Documentation/virt/kvm/api.rst            |  2 +
 arch/powerpc/include/asm/hvcall.h         | 25 ++++++++-
 arch/powerpc/include/asm/kvm_host.h       |  6 +-
 arch/powerpc/include/uapi/asm/kvm.h       |  2 +
 arch/powerpc/kernel/asm-offsets.c         |  6 +-
 arch/powerpc/kvm/book3s_hv.c              | 65 ++++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_nested.c       | 68 ++++++++++++++++++-----
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 43 ++++++++++----
 arch/powerpc/kvm/powerpc.c                |  3 +
 include/uapi/linux/kvm.h                  |  1 +
 tools/arch/powerpc/include/uapi/asm/kvm.h |  2 +
 11 files changed, 181 insertions(+), 42 deletions(-)

-- 
2.26.2

