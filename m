Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1388DC44C8
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 02:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfJBALH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 20:11:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfJBALH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 20:11:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9208r11016352;
        Wed, 2 Oct 2019 00:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=kKBUoN1s7CYwKnb2Fbv00kkbhS6Cs19jT9Qv1KhoVGw=;
 b=p6O+fH6oQA/91L0R1KW9Q01k89eXwRRgZgDQEXvSS5SEVWEJ4vyOa/QmG3C9oLBLVQfr
 mKlBru6l73oLF7f9VNyztk2pQaHYpvp22gYBeO4j+gQlq1v6FkW5MWWlvHw8TSbzlJoS
 gvJOAFpDSyKO9RU+OOQ/NgnJnx1WxLZAvp33UgZhYw/IILj+zfbm0NaEZKmOxd3zQ5O2
 ZICQgAA1YMlW9Kq1ufuwUK+6yfgR+kB0gOZbaU3VfeZJc5z7N2/vurHtsWpbP5uQ8PLF
 hRwO1CZThDu7Sv0i5A+FRpsPOaPOc0kHxrmYd8nnj/Nclrm9YZeBy5EtkNzLCtFxiScc Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2va05rsjb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 00:10:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9209of3124816;
        Wed, 2 Oct 2019 00:10:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vc9dj8yrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 00:10:41 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x920AdQe024306;
        Wed, 2 Oct 2019 00:10:40 GMT
Received: from [192.168.14.112] (/79.180.244.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 17:10:39 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <3DAFE71E-1A28-490D-BD3E-056C54766915@gmail.com>
Date:   Wed, 2 Oct 2019 03:10:36 +0300
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>, vkuznets@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <6FE09CEA-A7C3-4D40-B982-C128B6631D4A@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
 <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
 <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
 <B1A83F5E-3B15-4715-8AC8-D436A448D0CE@oracle.com>
 <86619DAE-C601-4162-9622-E3DE8CB1C295@gmail.com>
 <20191001184034.GC27090@linux.intel.com>
 <20191001233408.GB6151@linux.intel.com>
 <3DAFE71E-1A28-490D-BD3E-056C54766915@gmail.com>
To:     Nadav Amit <nadav.amit@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=910
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=989 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010207
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 2 Oct 2019, at 2:37, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Oct 1, 2019, at 4:34 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>=20
>> On Tue, Oct 01, 2019 at 11:40:34AM -0700, Sean Christopherson wrote:
>>> Anyways, I'll double check that the INIT should indeed be consumed =
as part
>>> of the VM-Exit.
>>=20
>> Confirmed that the INIT is cleared prior to delivering VM-Exit.
>=20
> Thanks for checking. I guess Liran will take it from here - I just =
wanted to
> ensure kvm-unit-tests on bare-metal is not broken.
>=20

Yes, thanks everyone. I will submit a patch for both KVM and =
kvm-unit-tests for this.

-Liran

