Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4095438A351
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhETJvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 05:51:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234265AbhETJtL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 05:49:11 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K9XjdO088791;
        Thu, 20 May 2021 05:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ppwtvM3q03PSEpYkTapdLu0gB5ibyf+6YUjM7vCkYB8=;
 b=TzS4tvERt0hBJEaflJAncGpj1kWFVDFnLSjyzyt1oRrmgi/8j8AFeKmoERhJfuoIkiQu
 HFb/2kf1JNT/COmdlQW9iWv3EHww/uVHxMXT/SttEB7rw0kLgfFLdaKgKP6tmjST7L6y
 iG3hki/fekmktpYsdHdVmPUH1ovzivwwgcR3IU4nwXwMeG1Tsa3d4MT6zMpe2C10D3EB
 2PnZh1WUIJ6l6Z7JlsVNZjxsKN/nqTbuMU/ot+ryJDqbZSrBcKv+v8LESUxklItstCri
 WINBwClvlROGMh+9iXNdW2wJVQWub5aGsoIU6CXs9PqufCLSu1CJzctWM4FR59itHgGQ jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nn5qrh77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 05:47:49 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14K9YD93090380;
        Thu, 20 May 2021 05:47:49 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nn5qrh6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 05:47:49 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14K9jWKD013080;
        Thu, 20 May 2021 09:47:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 38m19srsrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 09:47:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14K9lG1533423684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 09:47:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C0684203F;
        Thu, 20 May 2021 09:47:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB6BC42042;
        Thu, 20 May 2021 09:47:43 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 May 2021 09:47:43 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests RFC 0/2] s390x: Add snippet support
Date:   Thu, 20 May 2021 09:47:28 +0000
Message-Id: <20210520094730.55759-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NH-PkV8Q2EbS2qf2BUht74or0YaG2GEw
X-Proofpoint-ORIG-GUID: 8uG9A7LqzQINvNFZ8HG2tfDuNqV0n0Gl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_01:2021-05-20,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SIE support allows us to run guests and test the hypervisor's
(V)SIE implementation. However it requires that the guest instructions
are binary which limits the complexity of the guest code.

The snippet support provides a way to write guest code as ASM or C and
simply memcpy it into guest memory. Some of the KVM-unit-test library
can be re-used which further speeds up guest code development.

The included mvpg-sie test helped us to deliver the KVM mvpg fixes
which Claudio posted a short while ago. In the future I'll post Secure
Execution snippet support patches which was my initial goal with this
series anyway.

I heard you liked tests so I put tests inside tests so you can test
while you test.

Janosch Frank (2):
  s390x: Add guest snippet support
  s390x: mvpg: Add SIE mvpg test

 .gitignore                      |   2 +
 s390x/Makefile                  |  29 ++++++-
 s390x/mvpg-sie.c                | 139 ++++++++++++++++++++++++++++++++
 s390x/snippets/c/cstart.S       |  13 +++
 s390x/snippets/c/flat.lds       |  51 ++++++++++++
 s390x/snippets/c/mvpg-snippet.c |  33 ++++++++
 s390x/unittests.cfg             |   3 +
 7 files changed, 267 insertions(+), 3 deletions(-)
 create mode 100644 s390x/mvpg-sie.c
 create mode 100644 s390x/snippets/c/cstart.S
 create mode 100644 s390x/snippets/c/flat.lds
 create mode 100644 s390x/snippets/c/mvpg-snippet.c

-- 
2.30.2

