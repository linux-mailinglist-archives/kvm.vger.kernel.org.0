Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413E8471372
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 11:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhLKKub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 05:50:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229977AbhLKKua (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 11 Dec 2021 05:50:30 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BB9vkU3014356;
        Sat, 11 Dec 2021 10:50:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : content-type :
 content-transfer-encoding : mime-version : subject : message-id : date :
 cc : to; s=pp1; bh=dPt4m+468piYs6hjhD5dMImtszl0/ST8y+Nc1uJWV24=;
 b=oya4sgjNrmORJWKz7gOno8r0EeBBfDfJm2OucROVvnk+18efDMwEw0CB9B7nvvy49H9t
 2xgvnFu1nrWTSpx3aLBq2Xxtahlq0ZpZi5HbW3jtRzIZKhQtf8z5xZ3zeuaDyGyNzZcK
 3BH6P/WgO5A+4OISYlUM23by6E830ZUgGWE4kS/TFsy6PlJ7Ccpbh+His8hUIdzgSSrZ
 +Xls5dQvk1shsW57Tt1uLqZrZQyTRt47T190RBgUr8s3Dtlv31JtXzwSTjwStGAxvPvV
 dqmg5ze83hrUyAGbXXjLjnBObijOcNKvqEwOaW2Zo340ToG7WA4wKglgsbHtWfxgOX67 CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cvstm0hav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Dec 2021 10:50:23 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BBAmagl025009;
        Sat, 11 Dec 2021 10:50:23 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cvstm0ha9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Dec 2021 10:50:23 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BBAmHLW020921;
        Sat, 11 Dec 2021 10:50:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3cvkm9hhrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Dec 2021 10:50:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BBAgSiO27525458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Dec 2021 10:42:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 538165204F;
        Sat, 11 Dec 2021 10:50:18 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.195.36.3])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 57BEC5204E;
        Sat, 11 Dec 2021 10:50:17 +0000 (GMT)
From:   Sachin Sant <sachinp@linux.vnet.ibm.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: [next-20211210] Build break powerpc/kvm: unknown member wait
Message-Id: <496ECBB3-36F3-4F07-83B2-875F683BC446@linux.vnet.ibm.com>
Date:   Sat, 11 Dec 2021 16:20:16 +0530
Cc:     linux-next@vger.kernel.org, seanjc@google.com
To:     kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: de0TqpFZK0zsbTO3n0TOsCdKJSibrJbP
X-Proofpoint-ORIG-GUID: 3sa16O813q4o-hY-Y5_bORTbmHHoWpe2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-11_04,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=836 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112110056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

next-20211210 ( commit ea922272cbe547) powerpc build fails due to =
following error:

arch/powerpc/kvm/book3s_hv.c: In function 'kvmhv_run_single_vcpu':
arch/powerpc/kvm/book3s_hv.c:4591:27: error: 'struct kvm_vcpu' has no =
member named 'wait'
   prepare_to_rcuwait(&vcpu->wait);
                           ^~
arch/powerpc/kvm/book3s_hv.c:4608:23: error: 'struct kvm_vcpu' has no =
member named 'wait'
   finish_rcuwait(&vcpu->wait);
                       ^~=20

commit 510958e997217: KVM: Force PPC to define its own rcuwait object=20
introduced the error.=20

Thanks
-Sachin=
