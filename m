Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6581C5A66
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 17:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgEEPDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 11:03:18 -0400
Received: from ms11p00im-qufo17281401.me.com ([17.58.38.51]:54760 "EHLO
        ms11p00im-qufo17281401.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729808AbgEEPDR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 11:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1588690994;
        bh=hugAbAdicGIQPpOvFrvbfBGy0r8E0OtiFQgVDHWbtiU=;
        h=Content-Type:Subject:From:Date:Message-Id:To;
        b=AjMXCm7DRH06AK4EFFiXQ+u4b2cF/AqmgrGvHdmFmpIRikerunRvCtZitXiAgwA/C
         T1u2S4/NEQ/Ab4jxPyoN4usHVFQba9Lo0fM+xenwBbJSJ+DvKoKHr0CAIR+6+a19qE
         bBbOa2QA9KgWHY6W7oSoESSE2TNa7x6dLk2FdrpBDxdE74qgEehSTsg6nGuIJfj20D
         XJ+qiWqW8hXMi3uMWpiyx/FvHfqBBCE0y5OC8a9rSHRRjvPEwA1yY9UEwZ9xXy015O
         y3Yt564GMxsT6GiFODY4AocB5PELfZmQ9zxAiM7fvYH2pXdEMd0T+jc/tpk6lVYxD0
         ea0dUoN3rat1A==
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net [71.184.117.43])
        by ms11p00im-qufo17281401.me.com (Postfix) with ESMTPSA id 2E359BC02F9;
        Tue,  5 May 2020 15:03:14 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
From:   Qian Cai <cailca@icloud.com>
In-Reply-To: <a9dcc2b8-15a5-73ff-5784-46c61c8eb2b8@de.ibm.com>
Date:   Tue, 5 May 2020 11:03:12 -0400
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9D5D39B5-B4FE-4371-A8D3-A03D7CC78C2F@icloud.com>
References: <20200505083515.2720-1-borntraeger@de.ibm.com>
 <a9dcc2b8-15a5-73ff-5784-46c61c8eb2b8@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_08:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=953 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2002250000 definitions=main-2005050122
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 5, 2020, at 5:15 AM, Christian Borntraeger =
<borntraeger@de.ibm.com> wrote:

> applied for kvms390/master.
>=20
> Qian Cai, can you verify that this fixes the issue?

Thank you for tracking it down and removed the warning, so there is no =
way for me to trigger it anymore. Otherwise, my simple test case works =
fine for z/VM nested KVM here.

