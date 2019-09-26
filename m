Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5EEBF139
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 13:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfIZLYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 07:24:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47434 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfIZLYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 07:24:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QBNvpv059895;
        Thu, 26 Sep 2019 11:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : content-type :
 content-transfer-encoding : mime-version : subject : message-id : date :
 to; s=corp-2019-08-05; bh=3aeH1pkkN2xdX8h3nwvuS+wpPZk2A7RjmGTlh03tyIk=;
 b=qmlecneYRh8chAy270rb9gJjY5a+NM7FG49RyC1PheAYzLdWHKU0r3pB8OOR9ihAYiih
 7cvDzrev1tCPDlYMNDp/cM1y4LjedGFUr25yhP+qA04dv/mKowrawWfv1hCrg45OGZPz
 yK2tr69W9iAjqmu9F1CSsn7bbpDQ+PPVVBEBzgw2wmAhQXVelfFeHg9epGXoLotKsfaI
 CUewXZfCHgxU3rjCqOVu/91Mky7SdUOwSQ5uCTTCB0+LByhOcYXoP/RBSoUCjWIUoI35
 eG2n0YFfD51mkfjY+2sv7aYTmjSFb//3RZm2brMabek0mULHIMPQXcEkBbgkYIDf9Q6O oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btqb082-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 11:24:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QBNsX8097635;
        Thu, 26 Sep 2019 11:24:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qc3cmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 11:24:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8QBO4m4014010;
        Thu, 26 Sep 2019 11:24:05 GMT
Received: from [192.168.14.112] (/79.179.213.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 04:24:04 -0700
From:   Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Suggest changing commit "KVM: vmx: Introduce handle_unexpected_vmexit
 and handle WAITPKG vmexit"
Message-Id: <B57A2AAE-9F9F-4697-8EFE-5F1CF4D8F7BC@oracle.com>
Date:   Thu, 26 Sep 2019 14:24:02 +0300
To:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Tao Xu <tao3.xu@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=437
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=524 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260109
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


I just reviewed the patch "KVM: vmx: Introduce handle_unexpected_vmexit =
and handle WAITPKG vmexit=E2=80=9D currently queued in kvm git tree
=
(https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?h=3Dqueue&id=3Dbf=
653b78f9608d66db174eabcbda7454c8fde6d5)

It seems to me that we shouldn=E2=80=99t apply this patch in it=E2=80=99s =
current form.

Instead of having a common handle_unexpected_vmexit() manually specified =
for specific VMExit reasons,
we should rely on the functionality I have added to vmx_handle_exit() in =
case there is no valid handler for exit-reason.
In this case (since commit 7396d337cfadc ("KVM: x86: Return to userspace =
with internal error on unexpected exit reason=E2=80=9D),
an internal-error will be raised to userspace as required. Instead of =
silently skipping emulated instruction.

-Liran

